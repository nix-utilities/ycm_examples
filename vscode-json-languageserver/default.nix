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

  name = "vscode-json-languageserver";

  lspConfig = {
    ycm-lsp-server = {
      name = "json";
      filetypes = [ "json" ];
      cmdline = [
        "${pkgs.vscode-json-languageserver}/bin/${name}"
        "--stdio"
      ];
      capabilities.textDocument.completion.completionItem.snippetSupport = true;
    };
  };
}
