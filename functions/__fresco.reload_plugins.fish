function __fresco.reload_plugins
    function __fresco.reset_variables
        set fresco_plugins
        if test -e $fresco_cache
            command rm $fresco_cache
        end
    end

    __fresco.reset_variables
    __fresco.load_plugins
end
