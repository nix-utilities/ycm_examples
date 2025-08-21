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

  name = "vscode-json-languageserver";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "json" ];
      cmdline = [ "${pkgs.vscode-json-languageserver}/bin/${name}" "--stdio" ];
      ## TODO: maybe convert `true` to `v:true`
      # capabilities.textDocument.completion.completionItem.snippetSupport = true;
    };
  };
}
