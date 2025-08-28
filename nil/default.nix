{
  config,
  lib,
  pkgs,
  ...
}:
let
  utils = import ../utils.nix { inherit lib pkgs; };
in
utils.mkModule rec {
  inherit config pkgs;

  name = "nil";

  lspConfig = {
    ycm-lsp-server = {
      name = "nix";
      filetypes = [ "nix" ];
      cmdline = [ "${pkgs.nil}/bin/${name}" "--stdio" ];
      project_root_files = [ "flake.nix" ];
    };

    ycm_extra_conf.settings =
      let
        dict = utils.convertTo.python.dictFromAttrs {
          ls.nil.formatting.command = ["nix" "fmt"];
        };
      in
      ''
        if kwargs[ 'language' ] == 'nix':
            return ${dict}
      '';
  };
}

