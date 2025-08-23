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

  name = "nil";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "nix" ];
      cmdline = [ "${pkgs.nil}/bin/${name}" "--stdio" ];
      project_root_files = [ "flake.nix" ];
    };
  };
}

