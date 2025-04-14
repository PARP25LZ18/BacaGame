#!/bin/sh

RESULT=$(cat ascii.pl | sed -s s/.*typewriter_write_text\(\'\\\\e/putStrLn\ \'\\\\x1b/)
RESULT=$(echo "$RESULT" | sed -s s/\\\\e/\\\\x1b/g)
RESULT=$(echo "$RESULT" | sed -s s/\).*//)
RESULT=$(echo "$RESULT" | sed -s s/\'/\"/g)
echo "$RESULT"
