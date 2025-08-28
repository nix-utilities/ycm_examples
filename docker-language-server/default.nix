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

  name = "docker-language-server";

  lspConfig = {
    ycm-lsp-server = {
      name = "docker";
      filetypes = [ "dockerfile" ];
      cmdline = [
        "${pkgs.docker-language-server}/bin/${name}"
        "start"
        "--stdio"
      ];
    };
  };
}
