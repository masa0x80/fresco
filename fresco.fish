set -x fresco_version 0.3.2

if not set -q fresco_root
    set -U fresco_root "$HOME/.local/share/fresco/repos"
    if set -q XDG_DATA_HOME
        set fresco_root "$XDG_DATA_HOME/fresco/repos"
    end
end
if not set -q fresco_plugin_list_path
    set -U fresco_plugin_list_path "$HOME/.local/share/fresco/plugins.fish"
    if set -q XDG_DATA_HOME
        set fresco_plugin_list_path "$XDG_DATA_HOME/fresco/plugins.fish"
    end
end
if not set -q fresco_plugins
    set -U fresco_plugins
end
if not set -q fresco_log_color
    set -U fresco_log_color brown
end
if not set -q fresco_cache
    set -U fresco_cache "$HOME/.local/share/fresco/plugin_cache.fish"
    if set -q XDG_DATA_HOME
        set fresco_cache "$XDG_DATA_HOME/fresco/plugin_cache.fish"
    end
end

for file in $fresco_root/github.com/masa0x80/fresco/{functions,completions}/*.fish
    source $file
end

function fresco
    switch "$argv[1]"
        case get
            __fresco.get_plugin_async (string split -- $argv)
        case remove
            __fresco.remove_plugin (string split -- $argv)
        case update
            __fresco.update_plugin (string split -- $argv)
        case list
            __fresco.list
        case reload
            __fresco.reload_plugins
            __fresco.log 'Reloaded plugins:'
            __fresco.list ' * '
        case help ''
            __fresco.help
        case --version
            __fresco.version
        case \*
            __fresco.get_plugin_async $argv
    end
end

function __fresco.bootstrap
    type -qa git
    if test $status != 0
        return 1
    end
    __fresco.init
    __fresco.load_plugins

    functions -e __fresco.bootstrap
end
__fresco.bootstrap
