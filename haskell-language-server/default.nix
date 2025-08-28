## Errors
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

  name = "haskell-language-server";

  lspConfig = {
    ycm-lsp-server = {
      name = "haskell";
      filetypes = [ "haskell" ];
      cmdline = [
        "${pkgs.haskell-language-server}/bin/${name}"
        "--lsp"
      ];
      project_root_files = [
        "stack.yaml"
        "cabal.project"
        "package.yaml"
        "hie.yaml"
      ];
    };
  };
}
