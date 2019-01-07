# Fresco

[![MIT LICENSE](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)

## 概要

Fish-shell向けのシンプルなプラグインマネージャーが `fresco` です。

## 導入方法

```
$ curl https://raw.githubusercontent.com/masa0x80/fresco/master/install | fish
$ exec fish -l
```

**`ghq` を利用してリポジトリー管理をしている人向け情報**

`fresco` は通常 `~/.local/share/fresco/repos/` 配下にリポジトリーを保存しますが、
環境変数 `fresco_root` が設定されている場合、そのディレクトリー配下にプラグインを保存します。

したがって、下記のように設定しておくと、
`fresco` で導入したプラグインも `ghq` で導入したリポジトリーと同様に管理できます。

```
set -U fresco_root (ghq root)
```

### 必要要件

- git: 1.7.6より新しいバージョンが必要です。
- fish: 3.0.0より新しいバージョンが必要です。

## 使い方

```
fresco [repos]        -- 指定されたプラグインをインストールします
fresco remove [repos] -- 指定されたプラグインを削除します
fresco update [repos] -- 指定されたプラグインを更新します
fresco list           -- インストール済みのプラグインをリスト表示します
fresco reload         -- `$fresco_plugin_list_path` に基づきプラグインを再読込します
fresco help           -- ヘルプを表示します
fresco --version      -- frescoのバージョンを表示します
```

**例：プラグインのインストール**

`masa0x80/angler.fish` をインストールするには下記コマンドを実行してください。

```
$ fresco masa0x80/angler.fish
```

プラグインをインストールすると、`$fresco_cache` ファイルが作成されます。
このファイルは、Fish起動時に行われるプラグインの読み込みを高速化に活用されます。

なお、`$fresco_cache` ファイルは `fresco reload` すると再作成されます。

**例：プラグインの更新**

`masa0x80/angler.fish` を更新するには下記コマンドを実行してください。

```
$ fresco update masa0x80/angler.fish
```

**例：プラグインの削除**

`masa0x80/angler.fish` を無効化するには下記コマンドを実行してください。
この場合、リポジトリー自体は削除されません。

```
$ fresco remove masa0x80/angler.fish
```

無効化した上でリポジトリーを削除する場合は、下記コマンドを実行してください。

```
$ fresco remove --force masa0x80/angler.fish
```

**`fresco` 自体を更新する場合**

`fresco` 自体を更新するには下記コマンドを実行してください。

```
fresco update --self
```
