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

  name = "typescript-language-server";

  lspConfig = {
    ycm-lsp-server = {
      name = "typescript-language-server";
      filetypes = [ "typescript" ];
      cmdline = [
        "${pkgs.typescript-language-server}/bin/typescript-language-server"
        "--stdio"
      ];
      project_root_files = [
        "tsconfig.json"
      ];
    };

    # ycm_extra_conf.settings =
    #   let
    #     dict = utils.convertTo.python.dictFromAttrs { };
    #   in
    #   ''
    #     if kwargs[ 'language' ] == 'typescript':
    #         return ${dict}
    #   '';
  };
}
