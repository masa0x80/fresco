function __fresco.load_plugins
    if test (count $fresco_plugins) = 0
        if test "$fresco_plugins" != ''
            if test -r $fresco_plugin_list_path
                __fresco.get_plugins (cat $fresco_plugin_list_path)
            end
        end
    end

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
