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

  name = "vscode-css-languageserver";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "css" "sass" ];
      cmdline = [ "${pkgs.vscode-css-languageserver}/bin/${name}" "--stdio" ];
    };
  };
}

