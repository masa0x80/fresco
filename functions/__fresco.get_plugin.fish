function __fresco.get_plugin -a plugin
    fish -c "__fresco.clone_plugin $plugin" &
    __fresco.wait (jobs -l -p)
end
