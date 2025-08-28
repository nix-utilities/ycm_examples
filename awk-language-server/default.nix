## "POST /run_completer_command HTTP/1.1" 500
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

  name = "awk-language-server";

  lspConfig = {
    ycm-lsp-server = {
      name = "awk";
      filetypes = [ "awk" ];
      cmdline = [ "${pkgs.awk-language-server}/bin/${name}" ];
    };
  };
}
