function __fresco.init
    set -l fresco_dir (dirname $fresco_plugin_list_path)
    if not test -d $fresco_dir
        mkdir -p $fresco_dir
    end
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
