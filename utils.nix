/**
  https://nixos.wiki/wiki/NixOS_modules
  https://github.com/nix-community/home-manager/blob/master/modules/programs/bash.nix
  https://github.com/nix-community/home-manager/blob/master/modules/programs/vim.nix
  https://home-manager.dev/manual/24.11/index.xhtml#ch-writing-modules
  https://nixos.org/manual/nixos/stable/index.html#sec-writing-modules
*/
{
  lib,
  pkgs,
}:
let
  inherit (lib)
    attrValues
    concatStringsSep
    filterAttrs
    isAttrs
    isBool
    isInt
    isFloat
    isList
    isPath
    isStorePath
    isString
    length
    mapAttrs
    mkDefault
    # mkIf
    mkOption
    remove
    splitString
    stringLength
    typeOf
    types
    ;

  inherit (pkgs.writers)
    writePython3Bin
    ;
in
rec {
  /**
    Common options that may be applied to YCM third-party language server modules
  */
  options = {
    enable = mkOption {
      default = false;
      description = "Enable or disable";
      type = types.bool;
    };

    /**
      Use the `.value` attribute to get string representation of configurations

      ```vim
      :help youcompleteme-plugging-an-arbitrary-lsp-server
      ```
    */
    ycm-lsp-server = mkOption {
      description = "Check the Configuration section of -- https://github.com/ycm-core/lsp-examples";

      apply =
        attrs:
        convertTo.vim.dictFromAttrs (
          filterAttrs (
            n: v:
            (isList v && length v > 0)
            || (isString v && stringLength v > 0)
            || (isAttrs v && v != { })
            || (n == "port" && v != null)
          ) attrs
        );

      example = ''
        ## Module snippet

        ```nix
        {
          config,
          pkgs,
          ...
        }:
        let
          utils = import ./utils.nix {};
          name = "vim-language-server";
          cfg = config.''${name};
          # ...
        in
        {
          options.''${name} = {
            inherit (utils.options) enable ycm-lsp-server;
          };

          config.''${name}.ycm-lsp-server = {
            name = "vim-language-server";
            filetypes = [ "vim" "help" ];
            cmdline = [ "''${pkgs.vim-language-server}/bin/''${name}" "--stdio" ];
          };
          # ...
        }
        ```
      '';

      type =
        with types;
        types.submodule {
          options = {
            name = mkOption {
              type = nonEmptyStr;
              description = ''
                (string, mandatory): When configuring a LSP server the value of
                the 'name' key will be used as the "kwargs[ 'language' ]". Can be
                anything you like.
              '';
            };

            filetypes = mkOption {
              type = listOf nonEmptyStr;
              description = ''
                (list of string, mandatory): List of Vim filetypes this server
                should be used for.
              '';
            };

            cmdline = mkOption {
              default = [ ];
              type = listOf nonEmptyStr;
              description = ''
                (list of strings, optional): If supplied, the server is started
                with this command line (each list element is a command line
                word).  Typically, the server should be started with STDIO
                communication. If not supplied, 'port' must be supplied.
              '';
            };

            port = mkOption {
              default = null;
              type = nullOr port;
              # type = nullOr (numbers.between 1 65535);
              description = ''
                (number, optional): If supplied, ycmd will connect to the server
                at 'localhost:<port>' using TCP (remote servers are not
                supported).
              '';
            };

            project_root_files = mkOption {
              default = [ ];
              type = listOf nonEmptyStr;
              description = ''
                (list of string, optional): List of filenames to search for when
                trying to determine the project's root. Uses python's pathlib for
                glob matching.
              '';
            };

            capabilities = mkOption {
              default = { };
              type = attrs;
              description = ''
                (dict, optional): If supplied, this is a dictionary that is
                merged with the LSP client capabilities reported to the language
                server.  This can be used to enable or disable certain features,
                such as the support for configuration sections
                ('workspace/configuration').
              '';
            };
          };
        };
    };

    ycm_extra_conf = mkOption {
      description = "Components of `.ycm_extra_conf.py` file";
      default = { };
      type = types.submodule {
        options = {
          settings = mkOption {
            description = "Insert within the Python `Settings` function that YCM calls from `.ycm_extra_conf.py`";
            type = types.nullOr types.lines;
            default = null;
            example = ''
              ## Set branch for Astro to load TypeScript configurations

              ```nix
              config.services.ycm_examples.astro-language-server.ycm_extra_conf.settings = \'\'
                if kwargs[ 'language' ] == 'astro':
                    node_modules_directory = closest_node_modules_directory(os.path.dirname(kwargs['filename']))
                    typescript_tsdk_directory = os.path.join(node_modules_directory, 'typescript/lib')
                    return { 'ls': { 'typescript': { 'tsdk':  typescript_tsdk_directory, }, }, }
              \'\'
              ```
            '';
          };
        };
      };
    };
  };

  write = {
    # vim.rcSnippet = name: cfg: pkgs.writeTextFile {
    #   inherit name;
    #   text = "let g:ycm_language_server += [ ${cfg.ycm-lsp-server} ]";
    # };

    python = {
      ## TODO: maybe make the re-indentation less ugly
      /**
        Inject `ycm_extra_conf.settings` for specific language servers into
        Python script pre-populated with boilerplate and helpful functions.

        > Notes about default `flakeIgnore`
        >
        > - "E201" "E202" are because that's how YCM formats things
        > - "E501" because re-indenting fewer lines be faster for rebuilds
        > - "E231" because `convertTo.python.dictFromAttrs` does not pretty print
      */
      ycm_extra_conf =
        {
          name,
          settings,
          args ? {
            flakeIgnore = [
              "E201"
              "E202"
              "E501"
              "E231"
            ];
          },
        }:
        writePython3Bin name args ''
          def Settings( **kwargs ):
          ${concatStringsSep "\n" (builtins.map (x: "    ${x}") (remove "" (splitString "\n" settings)))}
        '';

    };
  };

  convertTo = {
    /**
      Convert Nix data types into something Python maybe will accept

      # Example

      ```nix
      input = {
        soTrue = true;
        soFalse = false;
        nested.key = "woot";
        listed = [
          "str"
          true
          { dict = false; }
          null
        ];
      };

      output = convertTo.python.dictFromAttrs input;
      ```

      # Expected `output` value

      ```python
      {"listed":["str",True,{"dict":False},None]},{"nested":{"key":"woot"}},{"soFalse":False},{"soTrue":True}
      ```
    */
    python = rec {
      dictFromAttrs =
        attrs:
        "{${
          builtins.concatStringsSep "," (
            attrValues (mapAttrs (name: value: ''"${name}":${valueFrom value}'') attrs)
          )
        }}";

      boolianFrom = value: if value then "True" else "False";

      listFrom = value: "[${builtins.concatStringsSep "," (map (x: valueFrom x) value)}]";

      valueFrom =
        value:
        if isAttrs value then
          "${dictFromAttrs value}"
        else if isBool value then
          "${boolianFrom value}"
        else if isList value then
          "${listFrom value}"
        else if isString value then
          ''"${value}"''
        else if isPath value then
          ''"${toString value}"''
        else if isStorePath value then
          ''"${builtins.toStorePath value}"''
        else if (isFloat value || isInt value) then
          "${toString value}"
        else if typeOf value == "null" then
          "None"
        else
          throw "Unexpected type: value -> '${value}' | type -> ${typeOf value}";
    };

    /**
      Nearly identical to `convertTo.python` but for boolean and null requiring
      special attention
    */
    vim = with lib; rec {
      dictFromAttrs =
        attrs:
        "{${
          builtins.concatStringsSep "," (
            attrValues (attrsets.mapAttrs (name: value: ''"${name}":${valueFrom value}'') attrs)
          )
        }}";

      boolianFrom = value: if value then "v:true" else "v:false";

      listFrom = value: "[${builtins.concatStringsSep "," (builtins.map (x: valueFrom x) value)}]";

      valueFrom =
        value:
        if isAttrs value then
          "${dictFromAttrs value}"
        else if isBool value then
          "${boolianFrom value}"
        else if isList value then
          "${listFrom value}"
        else if isString value then
          ''"${value}"''
        else if isPath value then
          ''"${builtins.toString value}"''
        else if isStorePath value then
          ''"${builtins.toStorePath value}"''
        else if (isFloat value || isInt value) then
          "${builtins.toString value}"
        else if typeOf value == "null" then
          "v:null"
        else
          throw "Unexpected type: value -> '${value}' | type -> ${typeOf value}";
    };
  };

  /**
    ## Example declaration of module

    ```nix
    {
      config,
      pkgs,
      ...
    }:
    let
      utils = import ./utils.nix {};
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
    ```
  */
  mkModule =
    {
      name,
      lspConfig,
      lspOptions ? { },
      config,
      # pkgs,
      ...
    }:
    let
      service = "ycm_examples";
      # cfg = config.services.${service}.${name};
    in
    {
      ## TODO: Enable following after PR is merged -- https://github.com/NixOS/nixpkgs/pull/430772/
      # config.programs.vim.plugins = [ pkgs.vimPlugins.YouCompleteMe ];

      config.programs.vim.enable = true;

      options.services.${service}.${name} = {
        inherit (options) enable ycm-lsp-server ycm_extra_conf;
      }
      // lspOptions;

      # config.services.${service}.${name} = mkIf cfg.enable {
      #   enable = mkDefault false;
      # } // lspConfig;
      ## TODO: swap below for above when infinite recursion errors are sorted
      config.services.${service}.${name} = {
        enable = mkDefault false;
      }
      // lspConfig;
    };
}
