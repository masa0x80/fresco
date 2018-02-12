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

To install `fisherman/simple`, execute the following command:

```
$ fresco fisherman/simple
```

After install a plugin, create `$fresco_cache` file which is used to load plugins when fish start at next time.
To recreate the cache file, execute `freaco reload`.

**Example: update a plugin**

To update `fisherman/simple`, execute the following command:

```
$ fresco update fisherman/simple
```

**Example: remove a plugin**

Make `fisherman/simple` disable, execute the following command:

```
$ fresco remove fisherman/simple
```

Make `fisherman/simple` disable and remove `fisherman/simple` repository, execute the following command:

```
$ fresco remove --force fisherman/simple
```

**Update `fresco`**

To update `fresco` itself, execute the following command:

```
fresco update --self
```
