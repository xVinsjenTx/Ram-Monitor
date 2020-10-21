#!/usr/bin/env bash

main(){
    #fetch total memory
    TOTAL="$(free --mega | awk 'NR==2{print $2}')"

    #set threshold to 80%
    THRESHOLD="$(awk -v a="${TOTAL}" -v b=0.8 'BEGIN{c=(a*b); print c;}' | awk '{printf "%.0f\n", $1}')"

    #fetch the process with the highest memory usage
    HIGHEST_PROCESS="$(pgrep -v COMMAND | awk '{print $4,$11}' | sort -rnk 4 | head -1)"

    #fetch the memory used by the process
    PROCESS_MEMORY="$(printf "%s\\n" "${HIGHEST_PROCESS}" | awk '{print $1}')"

    #fetch the name of the process
    PROCESS_NAME="$(printf "%s\\n" "${HIGHEST_PROCESS}" | awk '{print $2}' | sed 's!.*/!!')"

    #set interval (seconds)
    INTERVAL=30

    while true; do 
        #fetch used memory
        USED="$(free --mega | awk 'NR==2{print $3}')"

        #compare $USED with $THRESHOLD and continue
        if (( USED > THRESHOLD )); then
            notify-send -i dialog-warning "WARNING: High Memory Usage: ${USED} MB / ${TOTAL} MB used. 
            Highest process: ${PROCESS_NAME} uses: ${PROCESS_MEMORY} %"
        else
            printf "Memory Usage: %s MB / %s MB used\\n" "${USED}" "${TOTAL}"
        fi

        sleep $INTERVAL
    done
}

main "$@"
