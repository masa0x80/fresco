function __fresco_use_subcommand
    set -l cmd (commandline -poc)
    set -e cmd[1]
    for i in $cmd
        switch $i
            case '-*'
                continue
        end
        return 1
    end
    return 0
end

function __fresco_seen_subcommand_from
    set -l cmd (commandline -poc)
    set -e cmd[1]
    for i in $cmd
        if contains -- $i $argv
            return 0
        end
    end
    return 1
end

complete -f -c fresco -n '__fresco_use_subcommand' -a remove -d 'remove plugins'
complete -f -c fresco -n '__fresco_use_subcommand' -a update -d 'update plugins'
complete -f -c fresco -n '__fresco_use_subcommand' -a list -d 'list installed plugins'
complete -f -c fresco -n '__fresco_use_subcommand' -a reload -d 'reload plugins'
complete -f -c fresco -n '__fresco_use_subcommand' -a help -d 'display the help message'
complete -f -c fresco -n '__fresco_use_subcommand' -l version -d 'display the version of fresco'

complete -f -c fresco -n '__fresco_seen_subcommand_from remove update' -a '(fresco list)'
complete -f -c fresco -n '__fresco_seen_subcommand_from remove' -l force -d 'remove the repository'
complete -f -c fresco -n '__fresco_seen_subcommand_from update' -l self -d 'update fresco itself'
