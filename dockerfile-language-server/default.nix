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

  name = "dockerfile-language-server";

  lspConfig = {
    ycm-lsp-server = {
      name = "docker";
      filetypes = [ "dockerfile" ];
      cmdline = [
        "${pkgs.dockerfile-language-server}/bin/docker-langserver"
        "--stdio"
      ];
    };
  };
}
