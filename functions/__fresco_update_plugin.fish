function __fresco_update_plugin
    function __fresco.git_update -a plugin
        __fresco_log "Update " $plugin
        pushd (pwd)
        builtin cd (__fresco_plugin_path $plugin)
        command git pull origin main 2>/dev/null
        popd
    end

    set -l plugins $argv

    switch "$argv[1]"
        case ''
            __fresco_log 'ERROR: specify at least one plugin name'
            return 1
        case --self
            __fresco.git_update masa0x80/fresco
            source $fresco_root/github.com/masa0x80/fresco/fresco.fish
            return 0
        case --all
            set plugins $fresco_plugins
    end

    for plugin in $plugins
        if not contains -- $plugin $fresco_plugins
            or not test -e (__fresco_plugin_path $plugin)
            __fresco_log "ERROR: `$plugin` is invalid plugin"
            continue
        end

        __fresco.git_update $plugin
    end

    __fresco_reload_plugins
end
