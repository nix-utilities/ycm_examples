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

  name = "vscode-css-languageserver";

  lspConfig = {
    ycm-lsp-server = {
      name = "css";
      filetypes = [ "css" "sass" ];
      cmdline = [ "${pkgs.vscode-css-languageserver}/bin/${name}" "--stdio" ];
    };
  };
}

