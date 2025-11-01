{
  lib,
  ## TODO: investigate why home-manager doesn't seem to pass `pkgs`
  pkgs,
  config,
  ...
}:
let
  service = "ycm_examples";

  cfg = config.services.ycm_examples;

  utils = import ./utils.nix { inherit lib pkgs; };

  list_ycm_extra_conf_attrs = builtins.filter (
    x: x ? "ycm_extra_conf" && x.ycm_extra_conf ? "settings" && x.ycm_extra_conf.settings != null
  ) cfg.enabled;
in
{
  imports = [
    ./astro-language-server
    ./awk-language-server
    ./bash-language-server
    ./docker-language-server
    ./dockerfile-language-server
    ./dockerfile-language-server-nodejs
    ./erlang-ls
    ./haskell-language-server
    ./nil
    ./pest-ide-tools
    ./postgres-lsp
    ./typescript-language-server
    ./vim-language-server
    ./vscode-css-languageserver
    ./vscode-json-languageserver
  ];

  options.services.${service} = {
    enabled = lib.mkOption {
      default = [ ];
      description = "Automaticly append listed LSP servers to `config.programs.vim.extraConfig`";
      type = lib.types.listOf lib.types.attrs;
    };

    ycm-lsp-server = lib.mkOption {
      description = "Vim dictionary list that may be set or appended to `g:ycm_language_server`";
      type = lib.types.str;
      default = lib.concatStringsSep "," (builtins.map (x: x.ycm-lsp-server) cfg.enabled);
    };

    ycm_extra_conf = lib.mkOption {
      description = "Path of `.ycm_extra_conf.py` file";
      type = lib.types.pathInStore;
      default = utils.write.python.ycm_extra_conf {
        name = "ycm_extra_conf.py";
        settings = builtins.concatStringsSep "\n" (
          builtins.map (x: x.ycm_extra_conf.settings) list_ycm_extra_conf_attrs
        );
      };
    };
  };

  config.programs.vim.extraConfig =
    lib.optionalString (builtins.length cfg.enabled > 0) ''
      let g:ycm_language_server = extend(get(g:, 'ycm_language_server', []), [ ${cfg.ycm-lsp-server} ])
    ''
    + lib.optionalString (builtins.length list_ycm_extra_conf_attrs > 0) ''
      let g:ycm_global_ycm_extra_conf = "${cfg.ycm_extra_conf}/bin/ycm_extra_conf.py"
    '';
}
