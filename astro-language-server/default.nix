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

  name = "astro-language-server";

  lspConfig = {
    ycm-lsp-server = {
      name = "astro";
      filetypes = [ "astro" ];
      cmdline = [
        "${pkgs.astro-language-server}/bin/astro-ls"
        "--stdio"
      ];
      project_root_files = [
        "tsconfig.json"
        "astro.config.mjs"
      ];
    };

    ycm_extra_conf.settings =
      let
        dict = utils.convertTo.python.dictFromAttrs {
          ls.typescript.tsdk = "${pkgs.typescript.outPath}/lib/node_modules/typescript/lib";
        };
      in
      ''
        if kwargs[ 'language' ] == 'astro':
            return ${dict}
      '';
  };
}
