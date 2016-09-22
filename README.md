# Fresco

[![MIT LICENSE](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)

## Overview

Fresco is a simple plugin manager for fish-shell.

## Installation

```
$ curl -Lo $HOME/.config/fish/conf.d/fresco.fish --create-dirs https://raw.githubusercontent.com/masa0x80/fresco/master/fresco.fish
$ exec fish -l
```

## Usage

```
fresco [repos]        -- install plugins
fresco remove [repos] -- remove plugins
fresco update [repos] -- update plugins
fresco list           -- list installed plugins
fresco reload         -- reload plugins based on `$HOME/.config/fish/conf.d/fresco.d/plugins.fish` file
fresco help           -- show this message
```

**Example**

To install `mono`, execute the following command:

```
$ fresco fisherman/mono
```
