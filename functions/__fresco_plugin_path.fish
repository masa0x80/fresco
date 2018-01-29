function __fresco_plugin_path -a plugin
    string join -- '/' $fresco_root (__fresco_plugin_url $plugin)
end
