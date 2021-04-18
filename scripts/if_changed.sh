# this is a template to act if a file has changed
FNAME='avc8_graphviz.dot' ; OLDM5SZ=$(md5sum $FNAME) ; \
while true; do sleep 1 ; \
NEWM5SZ=$(md5sum $FNAME) ; \
if [[ "$OLDM5SZ" == "$NEWM5SZ" ]]; then continue ; fi ; \
OLDM5SZ=$NEWM5SZ ; echo "$(date -Is): The file '$FNAME' has changed.  Processing it." ; \
    echo "do your if changed here" ; \
done

