function __fresco_reload_plugins
    function __fresco.reset_variables
        set fresco_plugins

        for plugin in (cat $fresco_plugin_list_path)
            set fresco_plugins $fresco_plugins $plugin
            if not test -d (__fresco_plugin_path $plugin)
                set fresco_plugins
                break
            end
        end

        if test -e $fresco_cache
            command rm $fresco_cache
        end
    end

    __fresco.reset_variables
    __fresco_load_plugins
end
