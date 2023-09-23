# Backup with restic and rsync

## Usage:

### restic

- Create environment, e.g. `b2.env`:
    - Specify respository with `RESTIC_REPOSITORY`
    - Specify what to backup with `BACKUP_DIR_PATH`
    - And other [restic environmental variables](https://restic.readthedocs.io/en/latest/040_backup.html?highlight=variables#environment-variables)
- Add password to the repo to `%env%.pass`, e.g. `b2.pass`
- Run `restic.sh %env%`

### rsync

- Create environment, e.g. `ext.env`:
    - Specify destination with `RSYNC_DEST`
    - Specify what to backup with `BACKUP_DIR_PATH`
- Run `rsync.sh %env%`
