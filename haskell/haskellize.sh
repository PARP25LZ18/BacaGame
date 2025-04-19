#!/bin/sh

PROLOG_PREDICATE_TO_REPLACE="write_img_line"

RESULT=$(cat ascii.pl | sed -s s/.*$PROLOG_PREDICATE_TO_REPLACE\(\'/putStrLn\ \"/)
RESULT=$(echo "$RESULT" | sed -s s/\'\).*/\"/)

# uncomment if image is colored
#RESULT=$(cat ascii.pl | sed -s s/.*PROLOG_PREDICATE_TO_REPLACE\(\'\\\\e/putStrLn\ \'\\\\x1b/)
#RESULT=$(echo "$RESULT" | sed -s s/\\\\e/\\\\x1b/g)
#RESULT=$(echo "$RESULT" | sed -s s/\).*//)
#RESULT=$(echo "$RESULT" | sed -s s/\'/\"/g)
echo "$RESULT"
