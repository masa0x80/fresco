function __fresco.reload_plugins
  function __fresco.reset_variables
    set fresco_plugins
    test -e $fresco_cache; and command rm $fresco_cache
  end

  __fresco.reset_variables
  __fresco.load_plugins
end
