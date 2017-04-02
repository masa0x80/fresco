set -x FRESCO_VERSION 0.2.0

if not set -q fresco_plugin_list_path
  set -U fresco_plugin_list_path "$HOME/.config/fish/plugins.fish"
  set -q XDG_CONFIG_HOME; and set fresco_plugin_list_path "$XDG_CONFIG_HOME/fish/plugins.fish"
end
not set -q fresco_plugins; and set -U fresco_plugins
not set -q fresco_log_color; and set -U fresco_log_color brown

for file in (ghq root)/github.com/masa0x80/fresco/{functions,completions}/*.fish
  source $file
end

function fresco
  switch "$argv[1]"
    case get
      __fresco.get_plugin_async (string split -- $argv)
    case remove
      __fresco.remove_plugin (string split -- $argv)
    case update
      __fresco.update_plugin (string split -- $argv)
    case list
      __fresco.list
    case reload
      __fresco.reload_plugins
      __fresco.log 'Reloaded plugins:'
      __fresco.list ' * '
    case help ''
      __fresco.help
    case --version
      __fresco.version
    case \*
      __fresco.get_plugin_async $argv
  end
end

__fresco.init
__fresco.load_plugins
