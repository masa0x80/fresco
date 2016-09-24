set -l fresco_fish_dir $HOME/.config/fish
not set -q XDG_CONFIG_HOME; and set fresco_fish_dir $XDG_CONFIG_HOME/fish
not set -q fresco_plugin_list_path; and set -U fresco_plugin_list_path $fresco_fish_dir/plugins.fish
not set -q fresco_plugins; and set -U fresco_plugins
not set -q fresco_log_color; and set -U fresco_log_color brown

function fresco
  switch "$argv[1]"
    case get
      __fresco_get_plugin (string split $argv)
    case remove
      __fresco_remove_plugin (string split $argv)
    case update
      __fresco_update_plugin (string split $argv)
    case list
      __fresco_list
    case reload
      __fresco_reload_plugins
      __fresco_log 'Reloaded plugins:'
      __fresco_list ' * '
    case help ''
      __fresco_help
    case '*'
      __fresco_get_plugin $argv
  end
end

function __fresco_log
  set_color $fresco_log_color
  echo -s $argv
  set_color normal
end

function __fresco_init
  set -l fresco_dir (dirname $fresco_plugin_list_path)
  not test -d $fresco_dir; and mkdir -p $fresco_dir
  if not test -f $fresco_plugin_list_path
    __fresco_log 'Initialize fresco...'
    __fresco_log "  Create $fresco_plugin_list_path"
    touch $fresco_plugin_list_path
  end

  functions -e __fresco_init
end

function __fresco_plugin_path -a plugin
  echo (ghq root)/github.com/$plugin
end

function __fresco_clone_plugin -a plugin
  if not test -e (__fresco_plugin_path $plugin)
    __fresco_log 'Download ' (__fresco_plugin_path $plugin)
    ghq get $plugin ^/dev/null
  end
end

function __fresco_append_plugin_to_list -a plugin
  if not command grep "^fresco $plugin" $fresco_plugin_list_path >/dev/null
    echo $plugin >> $fresco_plugin_list_path
  end
end

function __fresco_resolve_dependency -a plugin
  if test -f (__fresco_plugin_path $plugin)/fishfile
    for name in (cat (__fresco_plugin_path $plugin)/fishfile)
      __fresco_clone_plugin $name
      __fresco_resolve_dependency $name
      __fresco_append_plugin_to_list $name
    end
  end
end

function __fresco_get_plugin
  for plugin in $argv
    __fresco_clone_plugin $plugin
    __fresco_resolve_dependency $plugin
    __fresco_append_plugin_to_list $plugin

    if not contains $plugin $fresco_plugins
      set fresco_plugins $fresco_plugins $plugin
    end
  end

  __fresco_reload_plugins
end

function __fresco_remove_plugin
  for plugin in $argv
    set -l uninstall_fish (__fresco_plugin_path $plugin)/uninstall.fish
    if test -f $uninstall_fish
      builtin source $uninstall_fish
    end

    if test -e (__fresco_plugin_path $plugin)
      command rm -rf (__fresco_plugin_path $plugin)
      __fresco_log 'Remove ' (__fresco_plugin_path $plugin)
    end

    if command grep "^$plugin" $fresco_plugin_list_path >/dev/null
      string replace '/' '\\/' -- $plugin | read -l escaped_plugin
      command sed -i -e "/^$escaped_plugin\$/d" $fresco_plugin_list_path
    end
  end

  __fresco_reload_plugins
end

function __fresco_update_plugin
  for plugin in $argv
    if not test -e (__fresco_plugin_path $plugin)
      __fresco_log 'not exist'
      return 1
    end

    __fresco_log "Update " (__fresco_plugin_path $plugin)
    pushd (pwd)
    builtin cd (__fresco_plugin_path $plugin)
    command git pull origin master ^/dev/null
    popd
  end

  __fresco_reload_plugins
end

function __fresco_list -a prefix
  for plugin in $fresco_plugins
    echo -s $prefix $plugin
  end
end

function __fresco_load_plugins
  __fresco_reload_fresco_plugins_variable

  for plugin in $fresco_plugins
    for file in (__fresco_plugin_path $plugin)/functions/*.fish
      source $file
    end
  end

  for plugin in $fresco_plugins
    for file in (__fresco_plugin_path $plugin)/{conf.d/,completions/,}*.fish
      if string match -q 'uninstall.fish' (basename $file)
        continue
      end
      source $file
    end
  end
end

function __fresco_reload_fresco_plugins_variable
  if test (count $fresco_plugins) = 0
    if test -r $fresco_plugin_list_path
      for repo_name in (cat $fresco_plugin_list_path)
        set repo_name (string trim $repo_name)
        if string match -q '' -- $repo_name; or string match -q -r '^#' -- $repo_name
          continue
        end
        set fresco_plugins $fresco_plugins $repo_name
      end
    end
  end
end

function __fresco_reload_plugins
  set fresco_plugins
  __fresco_load_plugins
end

function __fresco_help
  echo 'fresco [repos]        -- install plugins'
  echo 'fresco remove [repos] -- remove plugins'
  echo 'fresco update [repos] -- update plugins'
  echo 'fresco list           -- list installed packages'
  echo 'fresco reload         -- reload plugins based on `fresco.d/plugins.fish` file'
  echo 'fresco help           -- show this message'
end

__fresco_init
__fresco_load_plugins
