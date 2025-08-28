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

  name = "bash-language-server";

  lspConfig = {
    ycm-lsp-server = {
      name = "bash";
      filetypes = [ "sh" ];
      cmdline = [ "${pkgs.bash-language-server}/bin/${name}" "start" ];
    };
  };
}

