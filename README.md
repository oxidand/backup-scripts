# Backup with restic and rsync

## Usage:

### restic

- create environment, e.g. `b2.env`
    - specify respository with `RESTIC_REPOSITORY`
    - specify what to backup with `BACKUP_DIR_PATH`
- add password to the repo to `%env%.pass`, e.g. `b2.pass`
- run `restic.sh %env%`
