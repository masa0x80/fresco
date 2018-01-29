function __fresco_plugin_url -a plugin
    set -l vcs git@github.com
    if string match -q -r -- '.*/.*' $plugin
        echo -s $vcs : $plugin
    else
        echo -s $vcs : $plugin / $plugin
    end
end
