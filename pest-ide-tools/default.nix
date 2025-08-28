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

  name = "pest-ide-tools";

  lspConfig = {
    ycm-lsp-server = {
      name = "pest";
      filetypes = [ "pest" ];
      cmdline = [ "${pkgs.pest-ide-tools}/bin/pest-language-server" ];
    };
  };
}
