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

To install `mono`, execute the following command:

```
$ fresco fisherman/mono
```

After install a plugin, create `$fresco_cache` file which is used to load plugins when fish start at next time.
To recreate the cache file, execute `freaco reload`.

**Example: update a plugin**

To update `mono`, execute the following command:

```
$ fresco update fisherman/mono
```

**Example: remove a plugin**

Make `mono` disable, execute the following command:

```
$ fresco remove fisherman/mono
```

Make `mono` disable and remove `mono` repository, execute the following command:

```
$ fresco remove --force fisherman/mono
```

**Update `fresco`**

To update `fresco` itself, execute the following command:

```
fresco update --self
```
