#!/bin/bash

# Define file paths
CURRENT_ZSHRC="$HOME/.zshrc"
BACKUP_ZSHRC="/Users/yaminocellist/git_repos/saveMyEnvironment/zshrc_backup.sh"

# ANSI color codes
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if the current .zshrc exists
if [ ! -f "$CURRENT_ZSHRC" ]; then
    echo "Error: $CURRENT_ZSHRC does not exist."
    exit 1
fi

# Check if backup exists and compare contents
if [ -f "$BACKUP_ZSHRC" ]; then
    if cmp -s "$CURRENT_ZSHRC" "$BACKUP_ZSHRC"; then
        echo "The backup is already up to date. No changes needed."
    fi

    read -p "Backup differs from current .zshrc. Overwrite backup (b) or restore backup to .zshrc (r)? (b/r/n): " choice
    case "$choice" in
        b|B ) 
            echo "Overwriting backup..."
            cp "$CURRENT_ZSHRC" "$BACKUP_ZSHRC"
            ;;
        r|R ) 
            for i in {1..2}; do
                read -p "Are you sure you want to restore the backup? This will overwrite your current .zshrc! (yes/no): " confirm
                if [[ "$confirm" != "yes" ]]; then
                    echo "Restore canceled."
                    exit 0
                fi
            done
            echo -e "${RED}Restoring backup to .zshrc...${NC}"
            cp "$BACKUP_ZSHRC" "$CURRENT_ZSHRC"
            ;;
        n|N ) 
            echo "No changes made. Exiting." 
            exit 0 
            ;;
        * ) 
            echo "Invalid input. Exiting." 
            exit 1 
            ;;
    esac
fi

# Switch to zsh and source the updated .zshrc
echo "Switching to zsh and sourcing the updated .zshrc..."
exec zsh
