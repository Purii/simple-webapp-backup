simple-webapp-backup
====================

This script just does its job. Creating a quick backup of a webapp and restore it if it's necessary without any hassle.
It's also useful when you want to move or copy a webapp with the whole database.
*(I use this before installing updates to WordPress, or any other productive app)*

The script uses `cp -p` to preserve the permissions and ownerships.

## Versioning
The script can handle multiple versions of backups. Just add the parameter `--version` and it asks for an identifier.

## Commands
**Create Backup**: `sh restore.sh --create`

**Do Restore**: `sh restore.sh --restore`
