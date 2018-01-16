function __fresco.clone_plugin -a plugin
    if not test -e (__fresco.plugin_path $plugin)
        __fresco.log 'Download ' (__fresco.plugin_path $plugin)
        set -l url (string join -- '//' https: (__fresco.plugin_url $plugin))
        git clone $url (__fresco.plugin_path $plugin) >/dev/null ^/dev/null
        set -l git_status $status
        if test $git_status != 0
            command rm -rf (__fresco.plugin_path $plugin)
            __fresco.log 'ERROR: invalid plugin name'
        end
        return $git_status
    end
end
