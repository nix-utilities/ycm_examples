## Slow to load but sorta works
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

