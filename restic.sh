#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ "$#" -ne 1 ]; then
    echo "Usage: restic.sh [dest]"
    exit 1
fi

ENV_FILE="$SCRIPT_DIR/${1}.env"

if ! [ -f "$ENV_FILE" ]; then
    echo "Unknown destionation"
    exit 1
fi

source "$ENV_FILE"

RESTIC_PASSWORD_FILE="$SCRIPT_DIR/$RESTIC_PASSWORD_FILE"

if ! [ -f "$RESTIC_PASSWORD_FILE" ]; then
    echo "Password file doesn't exist"
    exit 1
fi

if [ -z "$RESTIC_REPOSITORY" ]; then
    echo "Unknown repository"
    exit 1;
fi

# Init

restic unlock

if [ $? -ne 0 ]; then
    restic init
fi

# Backup

ARGS=()

if ! [ -z "$EXCLUDE_FILE" ]; then
    ARGS+=("--exclude-file=\"$SCRIPT_DIR/$EXCLUDE_FILE\"")
fi

if ! [ -z "$EXCLUDE" ]; then
    excludes=(${EXCLUDE//:/ })
    for e in ${excludes[@]}; do
        ARGS+=("--exclude=\"$e\"")
    done
fi

if ! [ -z "$VERBOSITY" ]; then
    ARGS+=("--verbose=$VERBOSITY")
fi

if [ $DRY_RUN = true ]; then
    ARGS+=("--dry-run")
fi

CMD=$(printf " %s" "${ARGS[@]}"); CMD=${CMD:1}; CMD="restic backup $BACKUP_DIR_PATH $CMD"

echo "$CMD"
eval "$CMD"

# Cleanup

KEEP=()

num='^[0-9]+$'

if [[ $KEEP_DAILY =~ $num ]] ; then
   KEEP+=("--keep-daily $KEEP_DAILY")
fi

if [[ $KEEP_WEEKLY =~ $num ]] ; then
   KEEP+=("--keep-weekly $KEEP_WEEKLY")
fi

if [[ $KEEP_MONTHLY =~ $num ]] ; then
   KEEP+=("--keep-monthly $KEEP_MONTHLY")
fi

if [[ $KEEP_YEARLY =~ $num ]] ; then
   KEEP+=("--keep-yearly $KEEP_YEARLY")
fi

CMD=$(printf " %s" "${KEEP[@]}"); CMD=${CMD:1}; CMD="restic forget $CMD"

echo "$CMD"
eval "$CMD"
