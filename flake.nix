{
  description = "Nix modules based on `ycm-core/lsp-examples` from GitHub";

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = {
        supported = {
          formatter = [ "x86_64-linux" ];
          modules = [ "x86_64-linux" ];
        };
      };

      /**
        For each `system.supported.modules` build set with shape similar to;

        ```nix
        { ${system} = { imports = [ ./default.nix ]; } }
        ```
      */
      defaultModules = nixpkgs.lib.listToAttrs (
        builtins.map (system: {
          name = system;
          value = {
            pkgs ? nixpkgs.legacyPackages.${system},
            lib ? nixpkgs.lib,
            ...
          }:
          {
            imports = [ ./default.nix ];
          };
        }) system.supported.modules
      );
    in
    {
      formatter = nixpkgs.lib.genAttrs system.supported.formatter (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );

      nixosModules = defaultModules;
      homeModules = defaultModules;
    };
}
