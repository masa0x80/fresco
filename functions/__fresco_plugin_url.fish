function __fresco_plugin_url -a plugin
    set -l vcs github.com
    if string match -q -r -- '.*/.*' $plugin
        string join -- '/' $vcs $plugin
    else
        string join -- '/' $vcs $plugin $plugin
    end
end
