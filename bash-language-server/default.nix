## Works
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

  name = "bash-language-server";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "sh" ];
      cmdline = [ "${pkgs.bash-language-server}/bin/${name}" "start" ];
    };
  };
}

