set -x FRESCO_VERSION 0.3.1

function __fresco.ghq
    if type -qa ghq
        ghq $argv
    else if test -x "$fresco_ghq"
        eval $fresco_ghq $argv
    else
        set_color $fish_color_error
        echo 'ERROR: `ghq` not found'
        set_color normal
        return 1
    end
end

if not set -q fresco_plugin_list_path
    set -U fresco_plugin_list_path "$HOME/.config/fish/plugins.fish"
    if set -q XDG_CONFIG_HOME
        set fresco_plugin_list_path "$XDG_CONFIG_HOME/fish/plugins.fish"
    end
end
if not set -q fresco_plugins
    set -U fresco_plugins
end
if not set -q fresco_log_color
    set -U fresco_log_color brown
end
if not set -q fresco_cache
    set -U fresco_cache "$HOME/.cache/fresco/plugin_cache.fish"
end

for file in (__fresco.ghq root)/github.com/masa0x80/fresco/{functions,completions}/*.fish
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
    __fresco.ghq >/dev/null
    if test $status != 0
        return 1
    end
    __fresco.init
    __fresco.load_plugins

    functions -e __fresco.bootstrap
end
__fresco.bootstrap
