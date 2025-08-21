## Works
/**
  ## Home Manager usage

  ```nix
  {
    pkgs,
    config,
    ...
  }:
  let
    ycm_examples = import /home/s0ands0/git/hub/nix-utilities/ycm_examples {
      inherit config;
    };
  in
  {
    imports = [
      ycm_examples
    ];

    config.services.ycm_examples.vim-language-server.enable = true;

    config.programs.vim = {
      enable = true;

      plugins = [
        YouCompleteMe
      ];

      extraConfig = ''
        let g:ycm_language_server = []
        let g:ycm_language_server += [ ${config.services.ycm_examples.vim-language-server.ycm-lsp-server} ]
      '';
    };
  }
  ```

*/
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

  name = "vim-language-server";

  lspConfig = {
    ycm-lsp-server = {
      inherit name;
      filetypes = [ "vim" "help" ];
      cmdline = [ "${pkgs.vim-language-server}/bin/${name}" "--stdio" ];
    };
  };
}
