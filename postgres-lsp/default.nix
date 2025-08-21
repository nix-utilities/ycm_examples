## Errors
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

  name = "postgres-lsp";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "sql" ];
      cmdline = [ "${pkgs.postgres-lsp}/bin/postgrestools" "lsp-proxy" ];
      project_root_files = [ "postgrestools.jsonc" ];
    };
  };
}
