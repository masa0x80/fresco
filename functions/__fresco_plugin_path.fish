function __fresco_plugin_path -a plugin
    set -l plugin_path (string replace -- 'git@' '' (__fresco_plugin_url $plugin))
    set plugin_path (string replace -- ':' '/' $plugin_path)
    string join -- '/' $fresco_root $plugin_path
end
