# Fresco

[![MIT LICENSE](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)

## Overview

`fresco` is a simple plugin manager for fish-shell.

## Installation

```
$ curl https://raw.githubusercontent.com/masa0x80/fresco/master/install | fish
```

## Usage

```
fresco [repos]        -- install plugins
fresco remove [repos] -- remove plugins
fresco update [repos] -- update plugins
fresco list           -- list installed plugins
fresco reload         -- reload plugins based on `$HOME/.config/fish/plugins.fish` file
fresco help           -- show this message
```

**Example: install a plugin**

To install `mono`, execute the following command:

```
$ fresco fisherman/mono
```

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
