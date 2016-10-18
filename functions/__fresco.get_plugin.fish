function __fresco.get_plugin -a plugin
  function __fresco.resolve_dependency -a plugin
    if test -f (__fresco.plugin_path $plugin)/fishfile
      for name in (cat (__fresco.plugin_path $plugin)/fishfile)
        if __fresco.clone_plugin $name
          __fresco.resolve_dependency $name
          __fresco.append_plugin_to_list $name
        end
      end
    end
  end

  function __fresco.append_plugin_to_list -a plugin
    if not command grep "^$plugin\$" $fresco_plugin_list_path >/dev/null
      echo $plugin >> $fresco_plugin_list_path
    end
  end

  if __fresco.clone_plugin $plugin
    __fresco.resolve_dependency $plugin
    __fresco.append_plugin_to_list $plugin

    if not contains -- $plugin $fresco_plugins
      __fresco.log "Enable $plugin"
      set fresco_plugins $fresco_plugins $plugin
    end
  end
  set fresco_job_count (math $fresco_job_count - 1)
end
