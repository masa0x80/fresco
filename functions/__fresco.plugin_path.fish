function __fresco.plugin_path -a plugin
    string join -- '/' $fresco_root (__fresco.plugin_url $plugin)
end
