# ======== navigate to your target folder
cd "/target_folder"
# ======== extracting all files and store it in array
while true; do
    directories="$(find . -type d | cut -f2- | tr '\n' ' ')"
    IFS=' ' read -ra NAMES <<< "$directories"
    ARRAY=();
    for i in "${NAMES[@]}"; do
        #======= excluding some folders like node_modules and so
        if [[ "$i" != *node_modules*]
        then 
            ARRAY+=($i); 
            ((COUNT=COUNT+1))
        fi;
    done;
    # ======= print number of files that gonna be watched
    echo Watching $COUNT files

    # the next statement will wait for the inotify event to triggered
    change=$(inotifywait -e modify,delete_self,create ${ARRAY[@]})
    # print the event and also time 
    echo $change "$(date +"%T")";

    # =============== do your action here (copy, move, build, bundle anything) just for example
    (npm run webpack-en-build)
    cp -R dist/* "/someplaceelse"
    echo "copied..."
done

