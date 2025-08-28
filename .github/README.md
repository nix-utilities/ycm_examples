# YCM Examples
[heading__top]:
  #ycm_examples
  "&#x2B06; Nix modules based on `ycm-core/lsp-examples` from GitHub"


Nix modules based on
[`ycm-core/lsp-examples`](https://github.com/ycm-core/lsp-examples)


## [![Byte size of Ycm_examples][badge__main__ycm_examples__source_code]][ycm_examples__main__source_code] [![Open Issues][badge__issues__ycm_examples]][issues__ycm_examples] [![Open Pull Requests][badge__pull_requests__ycm_examples]][pull_requests__ycm_examples] [![Latest commits][badge__commits__ycm_examples__main]][commits__ycm_examples__main] [![License][badge__license]][branch__current__license]


---


- [:arrow_up: Top of Document][heading__top]
- [:building_construction: Requirements][heading__requirements]
- [:zap: Quick Start][heading__quick_start]
- [&#x1F9F0; Usage][heading__usage]
- [:chart_with_upwards_trend: Contributing][heading__contributing]
  - [:trident: Forking][heading__forking]
  - [:currency_exchange: Sponsor][heading__sponsor]
- [:ballot_box_with_check: Status of LSP testing][heading__status_of_lsp_testing]
- [:card_index: Attribution][heading__attribution]
- [:balance_scale: Licensing][heading__license]


---



## Requirements
[heading__requirements]:
  #requirements
  "&#x1F3D7; Prerequisites and/or dependencies that this project needs to function properly"


Install the NixOS and/or Nix package manager via official instructions;

> `https://nixos.org/nixos/manual/`

This repository requires the [Vim][vim__home] text editor to be installed the
source code is available on [GitHub -- `vim/vim`][vim__github], and most GNU
Linux package managers are able to install Vim directly, eg...

- Arch based Operating Systems
   ```bash
   sudo packman -Syy
   sudo packman -S vim
   ```
- Debian derived Distributions
  ```bash
  sudo apt-get update
  sudo apt-get install vim
  ```


______


## Quick Start
[heading__quick_start]:
  #quick-start
  "&#9889; Perhaps as easy as one, 2.0,..."


- Clone this project...

```bash
mkdir -vp ~/git/hub/nix-utilities

cd ~/git/hub/nix-utilities

git clone git@github.com:nix-utilities/ycm_examples.git
```


______


## Usage
[heading__usage]:
  #usage
  "&#x1F9F0; How to utilize this repository"


### Optional if using Home Manager with system flake

Pass system level `pkgs` through Home-Manager `extraSpecialArgs`

`flake.nix` **(snippet)**

```nix
{
  description = "System wide flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs, ... }@attrs:
  let
    hostname = "nixos";
    system = "x86_64-linux";
  in
  {
    nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = with attrs; {
            inherit nixpkgs;
            pkgs = nixpkgs.legacyPackages.${system};
          };
        }
      ];
    };
  };
}
```

---

### Import as a configuration module

> `configuration.nix` **(snippet)**

```nix
{
  config,
  lib,
  nixpkgs,
  pkgs,
  ...
}:

{
  imports = [
    (import /home/your-name/git/hub/nix-utilities/ycm_examples {
      inherit config lib pkgs;
    })
  ];

  config.services.ycm_examples.servers = with config.services.ycm_examples; [
    nil
    pest-ide-tools
    vim-language-server
    # ...
  ];
}
```

Then rebuild as usual;

```bash
sudo nixos-rebuild switch
```

...  note if using a `flake.nix` then instead of above, then use following;

```bash
nixos-rebuild switch --flake .
```

---

### Experimental use as flake input with home-manager


`flake.nix` **(diff)**

```diff
 {
   description = "System wide flake";

   inputs = {
     nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
     home-manager.url = "github:nix-community/home-manager";
     home-manager.inputs.nixpkgs.follows = "nixpkgs";
+    ycm_examples.url = "github:nix-utilities/ycm_examples?ref=main";
   };
 
   outputs = { self, home-manager, nixpkgs, ... }@attrs:
   let
     hostname = "nixos";
     system = "x86_64-linux";
   in
   {
     nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
       inherit system;
       specialArgs = attrs;
       modules = [
         ./configuration.nix
         home-manager.nixosModules.home-manager
         {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.extraSpecialArgs = with attrs; {
-            inherit nixpkgs;
+            inherit nixpkgs ycm_examples;
             pkgs = nixpkgs.legacyPackages.${system};
           };
         }
       ];
     };
   };
 }
```

> `configuration.nix` **(diff)**

```diff
 {
   config,
   lib,
   nixpkgs,
   pkgs,
+  ycm_examples
   ...
 }:

 {
   imports = [
-    (import /home/your-name/git/hub/nix-utilities/ycm_examples {
+    (import ycm_examples {
       inherit config lib pkgs;
     })
   ];
 
   config.services.ycm_examples.servers = with config.services.ycm_examples; [
     nil
     pest-ide-tools
     vim-language-server
     # ...
   ];
 }
```


______


## Contributing
[heading__contributing]:
  #contributing
  "&#x1F4C8; Options for contributing to ycm_examples and nix-utilities"


Options for contributing to ycm_examples and nix-utilities


---


### Forking
[heading__forking]:
  #forking
  "&#x1F531; Tips for forking ycm_examples"


Start making a [Fork][ycm_examples__fork_it] of this repository to an account
that you have write permissions for.

- Clone this project...

```bash
mkdir -vp ~/git/hub/nix-utilities

cd ~/git/hub/nix-utilities

git clone git@github.com:nix-utilities/ycm_examples.git
```

- Add remote for fork URL. The URL syntax is
  _`git@github.com:<NAME>/<REPO>.git`_...

```bash
cd ~/git/hub/nix-utilities/ycm_examples

git remote add fork git@github.com:<NAME>/ycm_examples.git
```

- Add a language server sub-directory, for example here's how Astro support was
  added

```bash
mkdir my-language-server

touch astro-language-server/default.nix
```

- Populate `astro-language-server/default.nix` file with configurations

```nix
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
      cmdline = [ "${pkgs.astro-language-server}/bin/astro-ls" "--stdio" ];
      project_root_files = [ "tsconfig.json" "astro.config.mjs" ];
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
```

> Notes about configurations;
>
> - `lspConfig.ycm-lsp-server` attribute set will be appended to VimRC file's
>   `g:ycm_language_server` list value, check;
>   - [`ycm-core/lsp-examples` -- Configuration](https://github.com/ycm-core/lsp-examples/?tab=readme-ov-file#configuration)
>     for additional details and valid values.
>   - `:help g:ycm_language_server` for Vim documentation
>
> - `lspConfig.ycm_extra_conf.settings` will be inserted within the resulting
>   `Settings` function definition, and file path will appended to VimRC file's
>   `g:ycm_global_ycm_extra_conf` value, check;
>   - [`ycm-core/ycmd` -- `examples/.ycm_extra_conf.py`](https://github.com/ycm-core/ycmd/blob/67308a61b1433f22124f0378dbee5d3a76349619/examples/.ycm_extra_conf.py)
>     for examples
>   - `:help g:ycm_global_ycm_extra_conf` for Vim documentation
>
> **Warnings**
>
> - `lspConfig.ycm-lsp-server.name` **MUST** match the value that Vim reports
>   via `:echo &filetype` in order for YouCompleteMe to load correct settings
>   from `ycm_extra_conf.py`

- Add to the `imports` list within `default.nix`

```diff
 {
   imports = [
+    ./astro-language-server
     ./awk-language-server
     ./bash-language-server
```

- Add entry to your `configuration.nix`

```diff
 { config, pkgs, nixpkgs, ... }:
 
 {
   imports = [
     (import /home/your-name/git/hub/nix-utilities/ycm_examples {
       inherit config lib pkgs;
     })
   ];

   config.services.ycm_examples.servers = with config.services.ycm_examples; [
+    ./astro-language-server
     nil
     pest-ide-tools
     vim-language-server
     # ...
   ];
 }
```

- Rebuild and test that things work

- Commit your changes and push to your fork, eg. to fix an issue...

```bash
cd ~/git/hub/nix-utilities/ycm_examples

git commit -m "Add Astro language server"

git push fork main
```

> Note, the `-u` option may be used to set `fork` as the default remote, eg.
> _`git push -u fork main`_ however, this will also default the `fork` remote
> for pulling from too! Meaning that pulling updates from `origin` must be done
> explicitly, eg. _`git pull origin main`_

- Then on GitHub submit a Pull Request through the Web-UI, the URL syntax is
  _`https://github.com/<NAME>/<REPO>/pull/new/<BRANCH>`_

> Note; to decrease the chances of your Pull Request needing modifications
> before being accepted, please check the
> [dot-github](https://github.com/nix-utilities/.github) repository for
> detailed contributing guidelines.


---


### Sponsor
  [heading__sponsor]:
  #sponsor
  "&#x1F4B1; Methods for financially supporting nix-utilities that maintains ycm_examples"


Thanks for even considering it!

Via Liberapay you may
<sub>[![sponsor__shields_io__liberapay]][sponsor__link__liberapay]</sub> on a
repeating basis.

Regardless of if you're able to financially support projects such as
ycm_examples that nix-utilities maintains, please consider sharing projects
that are useful with others, because one of the goals of maintaining Open
Source repositories is to provide value to the community.


______


## Status of LSP testing
[heading__status_of_lsp_testing]: #status-of-lsp-testing


- `./astro-language-server` **works** with `ycm_extra_conf.py` generated by `./default.nix`
- `./awk-language-server` error, `"POST /run_completer_command HTTP/1.1" 500`
- `./bash-language-server` **works**
- `./docker-language-server` error, `"POST /run_completer_command HTTP/1.1" 500`
- `./erlang-ls` **works**
- `./haskell-language-server` error, may need investigation by Haskell expert
- `./nil` **works** though may slow-down initial load
- `./pest` **works**
- `./postgres-lsp` error, might need Docker or other dependencies injected
- `./vim-language-server` **works**
- `./vscode-css-languageserver` **works**
- `./vscode-json-languageserver` no errors or server rejections but doesn't seem to do anything


______


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources that where helpful in building this project so far."


- [GitHub -- `github-utilities/make-readme`](https://github.com/github-utilities/make-readme)
- [Home Manager -- Writing Modules](https://home-manager.dev/manual/24.11/index.xhtml#ch-writing-modules)
- [NixOS Manual -- Writing Modules](https://nixos.org/manual/nixos/stable/index.html#sec-writing-modules)
- [NixOS Wiki -- NixOS Modules](https://nixos.wiki/wiki/NixOS_modules)


______


## License
[heading__license]:
  #license
  "&#x2696; Legal side of Open Source"


```
Nix modules based on `ycm-core/lsp-examples` from GitHub
Copyright 2025 S0AndS0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

For further details review full length version of
[Apache-2.0][branch__current__license] License.



[branch__current__license]:
  /LICENSE
  "&#x2696; Full length version of Apache-2.0 License"

[badge__license]:
  https://img.shields.io/github/license/nix-utilities/ycm_examples

[badge__commits__ycm_examples__main]:
  https://img.shields.io/github/last-commit/nix-utilities/ycm_examples/main.svg

[commits__ycm_examples__main]:
  https://github.com/nix-utilities/ycm_examples/commits/main
  "&#x1F4DD; History of changes on this branch"

[ycm_examples__community]:
  https://github.com/nix-utilities/ycm_examples/community
  "&#x1F331; Dedicated to functioning code"

[issues__ycm_examples]:
  https://github.com/nix-utilities/ycm_examples/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."

[ycm_examples__fork_it]:
  https://github.com/nix-utilities/ycm_examples/fork
  "&#x1F531; Fork it!"

[pull_requests__ycm_examples]:
  https://github.com/nix-utilities/ycm_examples/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"

[ycm_examples__main__source_code]:
  https://github.com/nix-utilities/ycm_examples/
  "&#x2328; Project source!"

[badge__issues__ycm_examples]:
  https://img.shields.io/github/issues/nix-utilities/ycm_examples.svg

[badge__pull_requests__ycm_examples]:
  https://img.shields.io/github/issues-pr/nix-utilities/ycm_examples.svg

[badge__main__ycm_examples__source_code]:
  https://img.shields.io/github/repo-size/nix-utilities/ycm_examples

[vim__home]:
  https://www.vim.org
  "Home page for the Vim text editor"

[vim__github]:
  https://github.com/vim/vim
  "Source code for Vim on GitHub"

[sponsor__shields_io__liberapay]:
  https://img.shields.io/static/v1?logo=liberapay&label=Sponsor&message=nix-utilities

[sponsor__link__liberapay]:
  https://liberapay.com/nix-utilities
  "&#x1F4B1; Sponsor developments and projects that nix-utilities maintains via Liberapay"

