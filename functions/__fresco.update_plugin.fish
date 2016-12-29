function __fresco.update_plugin
  function __fresco.git_update -a plugin
    __fresco.log "Update " $plugin
    pushd (pwd)
    builtin cd (__fresco.plugin_path $plugin)
    command git pull origin master ^/dev/null
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
