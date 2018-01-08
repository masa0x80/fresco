function __fresco.clone_plugin -a plugin
    if not test -e (__fresco.plugin_path $plugin)
        __fresco.log 'Download ' (__fresco.plugin_path $plugin)
        __fresco.ghq get $plugin >/dev/null ^/dev/null
        set ghq_status $status
        if test $ghq_status != 0
            command rm -rf (__fresco.plugin_path $plugin)
            __fresco.log 'ERROR: invalid plugin name'
        end
        return $ghq_status
    end
end
