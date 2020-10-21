#!/usr/bin/env bash

main(){
    #Fetch amount of memory
    MEMAMOUNT="$(free -m | awk '/Mem/{print $2}')"
   
    #set memory usage threshold to 80%
    THRESHOLD=80

    #fetch the process with the highest memory usage
    HIGHEST_PROCESS="$(pgrep -v COMMAND | awk '{print $4,$11}' | sort -rnk 4 | head -1)"

    #fetch the memory used by the process
    PROCESS_MEMORY="$(printf "%s\\n" "${HIGHEST_PROCESS}" | awk '{print $1}')"

    #fetch the name of the process
    PROCESS_NAME="$(printf "%s\\n" "${HIGHEST_PROCESS}" | awk '{print $2}' | sed 's!.*/!!')"

    #set interval (seconds)
    INTERVAL=30

    while true; do 
    #Fetch used memory
    USED="$(free -m | awk '/Mem/{print $3}')"
    TOTALUSED="$(free -m | awk '/Mem/{printf("Ram Usage: %i\n")$3/$2*100}' | awk '{print $3}')"    
    
        #compare $TOTALUSED with $THRESHOLD and continue
        if (( TOTALUSED > THRESHOLD )); then
            notify-send -i dialog-warning "WARNING: High Memory Usage: $USED MB / $MEMAMOUNT MB used. 
            Highest process: ${PROCESS_NAME} uses: ${PROCESS_MEMORY} %"
        else
            printf "Memory Usage: %s MB / %s MB used\\n" "${USED}" "${TOTAL}"
        fi

        sleep "$INTERVAL"
    done
}

main "$@"
