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

  name = "vim-language-server";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "vim" "help" ];
      cmdline = [ "${pkgs.vim-language-server}/bin/${name}" "--stdio" ];
    };
  };
}
