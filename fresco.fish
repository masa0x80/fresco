set -x FRESCO_VERSION 0.1.2

if not set -q fresco_plugin_list_path
  set -U fresco_plugin_list_path "$HOME/.config/fish/plugins.fish"
  set -q XDG_CONFIG_HOME; and set fresco_plugin_list_path "$XDG_CONFIG_HOME/fish/plugins.fish"
end
not set -q fresco_plugins; and set -U fresco_plugins
not set -q fresco_log_color; and set -U fresco_log_color brown

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

function __fresco.log
  set_color $fresco_log_color
  echo -s $argv
  set_color normal
end

function __fresco.init
  set -l fresco_dir (dirname $fresco_plugin_list_path)
  not test -d $fresco_dir; and mkdir -p $fresco_dir
  if not test -f $fresco_plugin_list_path
    __fresco.log 'Initialize fresco...'
    __fresco.log "  Create $fresco_plugin_list_path"
    touch $fresco_plugin_list_path
  end

  function __fresco.initial_clone_plugins --on-event fish_prompt
    for plugin in (cat $fresco_plugin_list_path)
      __fresco.clone_plugin $plugin
    end
    functions -e __fresco.initial_clone_plugins
  end

  functions -e __fresco.util.init
end

function __fresco.plugin_path -a plugin
  echo (ghq root)/github.com/$plugin
end

function __fresco.clone_plugin -a plugin
  if not test -e (__fresco.plugin_path $plugin)
    __fresco.log 'Download ' (__fresco.plugin_path $plugin)
    ghq get $plugin >/dev/null ^/dev/null
    set ghq_status $status
    if test $ghq_status != 0
      command rm -rf (__fresco.plugin_path $plugin)
      __fresco.log 'ERROR: invalid plugin name'
    end
    return $ghq_status
  end
end

function __fresco.get_plugin -a plugin
  function __fresco.resolve_dependency -a plugin
    if test -f (__fresco.plugin_path $plugin)/fishfile
      for name in (cat (__fresco.plugin_path $plugin)/fishfile)
        if __fresco.clone_plugin $name
          __fresco.resolve_dependency $name
          __fresco.append_plugin_to_list $name
        end
      end
    end
  end

  function __fresco.append_plugin_to_list -a plugin
    if not command grep "^$plugin\$" $fresco_plugin_list_path >/dev/null
      echo $plugin >> $fresco_plugin_list_path
    end
  end

  if __fresco.clone_plugin $plugin
    __fresco.resolve_dependency $plugin
    __fresco.append_plugin_to_list $plugin

    if not contains -- $plugin $fresco_plugins
      __fresco.log "Enable $plugin"
      set fresco_plugins $fresco_plugins $plugin
    end
  end
  set fresco_job_count (math $fresco_job_count - 1)
end

function __fresco.get_plugin_async
  not set -q fresco_job_count; and set -U fresco_job_count 0
  for plugin in $argv
    set fresco_job_count (math $fresco_job_count + 1)
    fish -c "__fresco.get_plugin $plugin" &
  end

  while true
    for c in ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷
      echo -en "  $c\r"
      sleep 0.1
    end

    if test "$fresco_job_count" -le 0
      set -e fresco_job_count
      __fresco.reload_plugins
      break
    end
  end
end

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

function __fresco.update_plugin
  function __fresco.git_update -a plugin
    __fresco.log "Update " $plugin
    pushd (pwd)
    builtin cd (__fresco.plugin_path $plugin)
    command git pull origin master >/dev/null ^/dev/null
    popd
  end

  set -l plugins $argv

  switch "$argv[1]"
    case ''
      __fresco.log 'ERROR: specify at least one plugin name'
      return 1
    case --self
      __fresco.git_update masa0x80/fresco
      source (ghq root)/github.com/masa0x80/fresco/fresco.fish
      return 0
    case --all
      set plugins $fresco_plugins
  end

  for plugin in $plugins
    if not contains -- $plugin $fresco_plugins; or not test -e (__fresco.plugin_path $plugin)
      __fresco.log 'ERROR: invalid plugin name'
      continue
    end

    __fresco.git_update $plugin
  end

  __fresco.reload_plugins
end

function __fresco.list -a prefix
  for plugin in $fresco_plugins
    echo -s $prefix $plugin
  end
end

function __fresco.load_plugins
  function __fresco.reload_fresco_plugins_variable
    if test (count $fresco_plugins) = 0
      if test -r $fresco_plugin_list_path
        for repo_name in (cat $fresco_plugin_list_path)
          set repo_name (string trim -- $repo_name)
          if string match -q '' -- $repo_name; or string match -q -r '^#' -- $repo_name
            continue
          end
          set fresco_plugins $fresco_plugins $repo_name
        end
      end
    end
  end
  __fresco.reload_fresco_plugins_variable

  for plugin in $fresco_plugins
    for file in (__fresco.plugin_path $plugin)/functions/*.fish
      string match -q -- 'uninstall.fish' (basename $file); and continue
      source $file
    end
  end

  for plugin in $fresco_plugins
    for file in (__fresco.plugin_path $plugin)/{conf.d/,completions/,}*.fish
      string match -q -- 'uninstall.fish' (basename $file); and continue
      source $file
    end
  end
end

function __fresco.reload_plugins
  set fresco_plugins
  __fresco.load_plugins
end

function __fresco.version
  echo $FRESCO_VERSION
end

function __fresco.help
  echo 'fresco [repos]        -- install plugins'
  echo 'fresco remove [repos] -- remove plugins'
  echo 'fresco update [repos] -- update plugins'
  echo 'fresco list           -- list installed packages'
  echo 'fresco reload         -- reload plugins based on `fresco.d/plugins.fish` file'
  echo 'fresco help           -- display the help message'
  echo 'fresco --version      -- display the version of fresco'
end

__fresco.init
__fresco.load_plugins
