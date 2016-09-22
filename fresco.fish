set -l fresco_fish_dir $HOME/.config/fish
not set -q XDG_CONFIG_HOME; and set fresco_fish_dir $XDG_CONFIG_HOME/fish
not set -q fresco_dir; and set -U fresco_dir $fresco_fish_dir/conf.d/fresco.d
set -U fresco_plugin_list_path $fresco_dir_path/plugins.fish
not set -q fresco_plugins; and set -U fresco_plugins

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
    case help ''
      __fresco_help
    case '*'
      __fresco_get_plugin $argv
  end
end

function __fresco_init
  not test -d $fresco_dir; and mkdir -p $fresco_dir
  not test -f $fresco_plugin_list_path; and touch $fresco_plugin_list_path

  functions -e __fresco_init
end

function __fresco_plugin_path -a plugin
  echo (ghq root)/github.com/$plugin
end

function __fresco_load_plugin -a plugin
  set fresco_plugins $fresco_plugins $plugin
end

function __fresco_clone_plugin -a plugin
  if not test -e (__fresco_plugin_path $plugin)
    ghq get $plugin
  end
end

function __fresco_append_plugin_to_list -a plugin
  if not command grep "^fresco $plugin" $fresco_plugin_list_path >/dev/null
    echo "fresco $plugin" >> $fresco_plugin_list_path
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
end

function __fresco_remove_plugin
  for plugin in $argv
    if test -e (__fresco_plugin_path $plugin)
      command rm -rf (__fresco_plugin_path $plugin)
    end

    if command grep "^fresco $plugin" $fresco_plugin_list_path >/dev/null
      string replace '/' '\\/' -- $plugin | read -l escaped_plugin
      command sed -i -e "/^fresco $escaped_plugin\$/d" $fresco_plugin_list_path
    end
  end

  __fresco_reload_plugins
end

function __fresco_update_plugin
  for plugin in $argv
    if not test -e (__fresco_plugin_path $plugin)
      echo 'not exist'
      return 1
    end

    pushd (pwd)
    cd (__fresco_plugin_path $plugin)
    git pull origin master
    popd
  end

  __fresco_reload_plugins
end

function __fresco_list
  for plugin in $fresco_plugins
    echo $plugin
  end
end

function __fresco_load_plugins
  if set -q fresco_plugins
    test -r $fresco_plugin_list_path; and source $fresco_plugin_list_path
  end

  for plugin in $fresco_plugins
    for file in (__fresco_plugin_path $plugin)/functions/*.fish
      source $file
    end
  end

  for plugin in $fresco_plugins
    for dir in conf.d completions ''
      for file in (__fresco_plugin_path $plugin)/$dir/*.fish
        source $file
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
