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

  name = "postgres-lsp";

  lspConfig = {
    ycm-lsp-server = {
      name = "sql";
      filetypes = [ "sql" ];
      cmdline = [ "${pkgs.postgres-lsp}/bin/postgrestools" "lsp-proxy" ];
      project_root_files = [ "postgrestools.jsonc" ];
    };
  };
}
