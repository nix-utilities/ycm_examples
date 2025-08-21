## "POST /run_completer_command HTTP/1.1" 500
{
  pkgs,
  config,
  ...
}:
let
  utils = import ../utils.nix {};
in
utils.mkModule rec {
  inherit config pkgs;

  name = "awk-language-server";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "awk" ];
      cmdline = [ "${pkgs.awk-language-server}/bin/${name}" ];
    };
  };
}

