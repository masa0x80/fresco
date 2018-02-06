function __fresco_wait
    # Set default wait timeout [sec]
    set -l timeout 30
    if set -q fresco_timeout
        set -l timeout $fresco_timeout
    end
    set -l start_time (date +%s)
    set -l end_time $start_time

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

            if test (math $end_time - $start_time) -gt $timeout
                break
            end

            for c in ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷
                echo -en "  $c\r"
                set end_time (date +%s)
                sleep 0.1
            end
        end
    end
end
