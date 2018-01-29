function __fresco_get_plugin -a plugin
    fish -c "__fresco_clone_plugin $plugin" &
    __fresco_wait (jobs -l -p)
end
