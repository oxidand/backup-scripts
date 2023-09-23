#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ "$#" -ne 1 ]; then
    echo "Usage: rsync.sh [dest]"
    exit 1
fi

ENV_FILE="$SCRIPT_DIR/${1}.env"

if ! [ -f "$ENV_FILE" ]; then
    echo "Unknown destionation"
    exit 1
fi

source "$ENV_FILE"

if [ -z "$RSYNC_DEST" ]; then
    echo "Unknown destination"
    exit 1;
fi

ARGS=()

if [ $DRY_RUN = true ]; then
    ARGS+=("--dry-run")
fi

if ! [ -z "$EXCLUDE_FILE" ]; then
    ARGS+=("--exclude-from=\"$SCRIPT_DIR/$EXCLUDE_FILE\"")
fi

if ! [ -z "$EXCLUDE" ]; then
    excludes=(${EXCLUDE//:/ })
    for e in ${excludes[@]}; do
        ARGS+=("--exclude=\"$e\"")
    done
fi

CMD=$(printf " %s" "${ARGS[@]}"); CMD=${CMD:1}; CMD="rsync -aPv $BACKUP_DIR_PATH $RSYNC_DEST --del --delete-excluded --ignore-errors $CMD"

echo "$CMD"
eval "$CMD"
