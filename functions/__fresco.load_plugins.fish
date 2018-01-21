function __fresco.load_plugins
    function __fresco.reload_fresco_variable
        if test (count $fresco_plugins) = 0
            if test -r $fresco_plugin_list_path
                for plugin in (cat $fresco_plugin_list_path)
                    set plugin (string trim -- $plugin)
                    if string match -q '' -- $plugin
                        or string match -q -r '^#' -- $plugin
                        continue
                    end
                    set fresco_plugins $fresco_plugins $plugin
                end
            end
        end
    end
    __fresco.reload_fresco_variable

    function __fresco.cache_plugins
        command mkdir -p (dirname $fresco_cache)
        echo -n >$fresco_cache
        for plugin in $fresco_plugins
            for file in (__fresco.plugin_path $plugin)/{functions/,conf.d/,completions/,}*.fish
                if string match -q -- 'uninstall.fish' (basename $file)
                    continue
                end
                command cat $file >>$fresco_cache
            end
        end
    end

    if not test -e $fresco_cache
        __fresco.cache_plugins
    end

    source $fresco_cache
end
