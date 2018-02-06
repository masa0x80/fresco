function __fresco_reload_plugins
    function __fresco.reset_variables
        set fresco_plugins

        for plugin in (cat $fresco_plugin_list_path)
            if test -d (__fresco_plugin_path $plugin)
                if not contains $fresco_plugins $plugin
                    set fresco_plugins $fresco_plugins $plugin
                end
            end
        end

        if test -e $fresco_cache
            command rm $fresco_cache
        end
    end

    __fresco.reset_variables
    __fresco_load_plugins
end
