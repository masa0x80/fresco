function __fresco.load_plugins
  function __fresco.reload_fresco_plugins_variable
    if test (count $fresco_plugins) = 0
      if test -r $fresco_plugin_list_path
        for repo_name in (cat $fresco_plugin_list_path)
          set repo_name (string trim -- $repo_name)
          if string match -q '' -- $repo_name; or string match -q -r '^#' -- $repo_name
            continue
          end
          set fresco_plugins $fresco_plugins $repo_name
        end
      end
    end
  end
  __fresco.reload_fresco_plugins_variable

  for plugin in $fresco_plugins
    for file in (__fresco.plugin_path $plugin)/functions/*.fish
      string match -q -- 'uninstall.fish' (basename $file); and continue
      source $file
    end
  end

  for plugin in $fresco_plugins
    for file in (__fresco.plugin_path $plugin)/{conf.d/,completions/,}*.fish
      string match -q -- 'uninstall.fish' (basename $file); and continue
      source $file
    end
  end
end
