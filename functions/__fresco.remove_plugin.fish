function __fresco.remove_plugin
  set -l force_option false

  switch "$argv[1]"
    case ''
      __fresco.log 'ERROR: specify at least one plugin name'
      return 1
    case -f --force
      set force_option true
  end

  set -l plugins $argv[1..-1]
  eval $force_option; and set plugins $argv[2..-1]

  for plugin in $plugins
    if not contains -- $plugin $fresco_plugins
      __fresco.log 'ERROR: invalid plugin name'
      continue
    end

    for uninstall_fish in (__fresco.plugin_path $plugin)/{functions/,}uninstall.fish
      if test -f $uninstall_fish
        builtin source $uninstall_fish
      end
    end

    if eval $force_option
      if test -e (__fresco.plugin_path $plugin)
        command rm -rf (__fresco.plugin_path $plugin)
        __fresco.log 'Remove ' (__fresco.plugin_path $plugin)
      end
    end

    if command grep "^$plugin" $fresco_plugin_list_path >/dev/null
      string replace '/' '\\/' -- $plugin | read -l escaped_plugin
      set -l fresco_tmp_file /tmp/fresco-(random)
      command sed -e "/^$escaped_plugin\$/d" -- $fresco_plugin_list_path > $fresco_tmp_file
      command mv $fresco_tmp_file $fresco_plugin_list_path
      __fresco.log 'Disable ' $plugin
    end
  end

  __fresco.reload_plugins
end
