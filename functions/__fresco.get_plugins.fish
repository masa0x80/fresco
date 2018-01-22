function __fresco.get_plugins
    set -l fresco_job_pids

    for plugin in $argv
        if test $plugin = ''
            continue
        end

        if string match -qr -- '^\-.*' $plugin
            __fresco.log 'ERROR: `' $plugin '` is an invalid argument.'
            continue
        end

        if not contains -- $plugin $fresco_plugins
            fish -c "__fresco.get_plugin $plugin" &
            set fresco_job_pids $fresco_job_pids (jobs -p -l)
        end
    end

    if __fresco.wait $fresco_job_pids
        __fresco.reload_plugins
    end
end
