/**

  ```nix
  {
    config,
    lib,
    ...
  }:
  let
    ycm_examples = import /home/s0ands0/git/hub/nix-utilities/ycm_examples {
      inherit config lib;
    };
  in
  {
    imports = [
      ycm_examples
    ];

    config.services.ycm_examples.servers = with config.services.ycm_examples; [
      vim-language-server
      # ...
    ];
  }
  ```
*/
{
  lib,
  pkgs,
  config,
  ...
}:
let
  service = "ycm_examples";
  cfg = config.services.ycm_examples;
  utils = import ./utils.nix { inherit lib pkgs; };

  list_ycm_extra_conf_attrs = builtins.filter (x:
    x ? "ycm_extra_conf"
    && x.ycm_extra_conf ? "settings"
    && x.ycm_extra_conf.settings != null
  ) cfg.enabled;
in
{
  imports = [
    ./astro-language-server
    ./awk-language-server
    ./bash-language-server
    ./docker-language-server
    ./erlang-ls
    ./haskell-language-server
    ./nil
    ./pest-ide-tools
    ./postgres-lsp
    ./vim-language-server
    ./vscode-css-languageserver
    ./vscode-json-languageserver
  ];

  options.services.${service} = {
    enabled = lib.mkOption {
      default = [];
      description = "Automaticly append listed LSP servers to `config.programs.vim.extraConfig`";
      type = lib.types.listOf lib.types.attrs;
    };

    ycm-lsp-server = lib.mkOption {
      description = "Vim dictionary list that may be set or appended to `g:ycm_language_server`";
      type = lib.types.str;
      default = lib.concatStringsSep "," (builtins.map (x: x.ycm-lsp-server) cfg.enabled);
    };

    ## TODO: Figure out why this is not writing to Nix store
    ycm_extra_conf = lib.mkOption {
      description = "Path of `.ycm_extra_conf.py` file";
      type = lib.types.pathInStore;
      default = utils.write.python.ycm_extra_conf {
        name = "ycm_extra_conf.py";
        settings = builtins.concatStringsSep "\n" (builtins.map (x:
          x.ycm_extra_conf.settings
        ) list_ycm_extra_conf_attrs);
      };
    };
  };

  ## TODO: maybe be smorter about this
  config.programs.vim.extraConfig =
    if builtins.length cfg.enabled > 0 && builtins.length list_ycm_extra_conf_attrs > 0 then
      ''
      let g:ycm_language_server = extend(get(g:, 'ycm_language_server', []), [ ${cfg.ycm-lsp-server} ])
      let g:ycm_global_ycm_extra_conf = "${cfg.ycm_extra_conf}/bin/ycm_extra_conf.py"
      ''
    else if builtins.length cfg.enabled > 0 then
      ''
      let g:ycm_language_server = extend(get(g:, 'ycm_language_server', []), [ ${cfg.ycm-lsp-server} ])
      ''
    else "";
}
