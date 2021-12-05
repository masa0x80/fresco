set -x fresco_version 0.6.0

if not set -q fresco_root
    set -U fresco_root "$HOME/.local/share/fresco/repos"
    set -q XDG_DATA_HOME && set fresco_root "$XDG_DATA_HOME/fresco/repos"
end
if not set -q fresco_plugin_list_path
    set -U fresco_plugin_list_path "$HOME/.local/share/fresco/plugins.fish"
    set -q XDG_DATA_HOME && set fresco_plugin_list_path "$XDG_DATA_HOME/fresco/plugins.fish"
end
not set -q fresco_plugins && set -U fresco_plugins
not set -q fresco_log_color && set -U fresco_log_color brown
if not set -q fresco_cache
    set -U fresco_cache "$HOME/.local/share/fresco/plugin_cache.fish"
    set -q XDG_DATA_HOME && set fresco_cache "$XDG_DATA_HOME/fresco/plugin_cache.fish"
end

for file in $fresco_root/github.com/masa0x80/fresco/{functions,completions}/*.fish
    source $file
end

function fresco
    switch "$argv[1]"
        case get
            __fresco_get_plugins (string split -- $argv)
        case remove
            __fresco_remove_plugin (string split -- $argv)
        case update
            __fresco_update_plugin (string split -- $argv)
        case list
            __fresco_list
        case reload
            __fresco_reload_plugins
            __fresco_log 'Reloaded plugins:'
            __fresco_list ' * '
        case help ''
            __fresco_help
        case --version
            __fresco_version
        case \*
            __fresco_get_plugins $argv
    end
end

function __fresco.bootstrap --on-event fresco_bootstrap
    type -qa git
    if test $status != 0
        return 1
    end
    __fresco_init
    __fresco_load_plugins

    functions -e __fresco.bootstrap
end
emit fresco_bootstrap
