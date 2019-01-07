function __fresco_get_plugins
    set -l fresco_job_pids

    for plugin in $argv
        set plugin (string trim -- $plugin)
        if test "$plugin" = ''
            or string match -q -r '^#' -- $plugin
            continue
        end

        if string match -qr -- '^\-.*' $plugin
            __fresco_log 'ERROR: `' $plugin '` is an invalid argument.'
            continue
        end

        if not contains -- $plugin $fresco_plugins
            fish -c "__fresco_clone_plugin $plugin" &
            set fresco_job_pids $fresco_job_pids (jobs -p -l)
        end
    end

    if test (count $fresco_job_pids) != 0
        wait $fresco_job_pids
        __fresco_reload_plugins
    end
end
