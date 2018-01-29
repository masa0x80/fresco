function __fresco_wait
    if test (count $argv) != 0
        while true
            set -l remain 0

            for j in $argv
                if contains $j (jobs -p)
                    set remain 1
                    break
                end
            end

            if test $remain = 0
                break
            end

            for c in ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷
                echo -en "  $c\r"
                sleep 0.1
            end
        end
    end
end
