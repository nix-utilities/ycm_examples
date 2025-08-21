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

  name = "erlang-ls";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "erlang" ];
      cmdline = [ "${pkgs.erlang-ls}/bin/erlang_ls" "--transport" "stdio" ];
      project_root_files = [ "erlang_ls.config" "erlang_ls.yaml" ];
    };
  };
}

