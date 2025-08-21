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

  name = "docker-language-server";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "dockerfile" ];
      cmdline = [ "${pkgs.docker-language-server}/bin/${name}" "--stdio" ];
    };
  };
}

