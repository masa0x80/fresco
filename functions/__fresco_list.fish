function __fresco_list -a prefix
    for plugin in $fresco_plugins
        echo -s $prefix $plugin
    end
end
