#@@ -1,11 +1,11 @@
#!/usr/bin/env bash

main(){
    #fetch total memory
    TOTAL="$(free --mega | awk 'NR==2{print $2}')"

    #set threshold to 80%
    THRESHOLD="$(awk -v a="${TOTAL}" -v b=0.8 'BEGIN{c=(a*b); print c;}' | awk '{printf "%.0f\n", $1}')"
    #Fetch amount of memory
    MEMAMOUNT="$(free -m | awk '/Mem/{print $2}')"
   
    #set memory usage threshold to 80%
    THRESHOLD=80

    #fetch the process with the highest memory usage
    HIGHEST_PROCESS="$(ps aux | grep -v COMMAND | awk '{print $4,$11}' | sort -rnk 4 | head -1)"
#@@ -20,18 +20,19 @@ 
main(){
    INTERVAL=30

    while true; do 
        #fetch used memory
        USED="$(free --mega | awk 'NR==2{print $3}')"

        #compare $USED with $THRESHOLD and continue
        if (( USED > THRESHOLD )); then
            notify-send -i dialog-warning "WARNING: High Memory Usage: ${USED} MB / ${TOTAL} MB used." 
    #Fetch used memory"
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
