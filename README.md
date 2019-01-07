# Fresco

[![MIT LICENSE](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)

## Overview

`fresco` is a simple plugin manager for fish-shell.

## Installation

```
$ curl https://raw.githubusercontent.com/masa0x80/fresco/master/install | fish
$ exec fish -l
```

**Tips: For you who use `ghq` to manage git repository**

`fresco` clones repositories under the directory specified by `fresco_root` shell variable.
`fresco_root` default value is `~/.local/share/fresco/repos/`.

If you want to integrate and manage plugins installed with `fresco` and `ghq`,
you should set `fresco_root` shell variable to `(ghq root)`.

```
set -U fresco_root (ghq root)
```

### Requirements

- git: version 1.7.6 or higher
- fish: version 3.0.0 or higher

## Usage

```
fresco [repos]        -- install plugins
fresco remove [repos] -- remove plugins
fresco update [repos] -- update plugins
fresco list           -- list installed plugins
fresco reload         -- reload plugins based on `$fresco_plugin_list_path` file
fresco help           -- display the help message
fresco --version      -- display the version of fresco
```

**Example: install a plugin**

To install `masa0x80/angler.fish`, execute the following command:

```
$ fresco masa0x80/angler.fish
```

After install a plugin, create `$fresco_cache` file which is used to load plugins when fish start at next time.
To recreate the cache file, execute `freaco reload`.

**Example: update a plugin**

To update `masa0x80/angler.fish`, execute the following command:

```
$ fresco update masa0x80/angler.fish
```

**Example: remove a plugin**

Make `masa0x80/angler.fish` disable, execute the following command:

```
$ fresco remove masa0x80/angler.fish
```

Make `masa0x80/angler.fish` disable and remove `masa0x80/angler.fish` repository, execute the following command:

```
$ fresco remove --force masa0x80/angler.fish
```

**Update `fresco`**

To update `fresco` itself, execute the following command:

```
fresco update --self
```
