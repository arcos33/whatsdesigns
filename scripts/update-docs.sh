#!/bin/bash

# Exit on error
set -e

# Load configuration
CONFIG_FILE=".docconfig.json"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    brew install jq
fi

# Function to update documentation based on changes
update_docs() {
    local change_type="$1"
    local message="$2"
    local date=$(date +"%B %d, %Y")
    local files_to_update=()

    # Get files that need to be updated based on change type
    while IFS= read -r file; do
        if [[ $(jq -r --arg type "$change_type" '.files[$file].updateTriggers | contains([$type])' "$CONFIG_FILE") == "true" ]]; then
            files_to_update+=("$file")
        fi
    done < <(jq -r '.files | keys[]' "$CONFIG_FILE")

    # Update each file
    for file in "${files_to_update[@]}"; do
        echo "Updating $file..."
        
        # For dev-journal.md, add new entry
        if [[ "$file" == "dev-journal.md" ]]; then
            # Check if today's date section exists
            if ! grep -q "^## $date" "$file"; then
                # Add new date section after the first line
                sed -i '' "1a\\
\\
## $date\\
" "$file"
            fi
            
            # Add change under today's section
            sed -i '' "/^## $date/a\\
\\
### ${change_type}\\
$message\\
" "$file"
        else
            # For other files, update relevant sections
            echo "Please review and update $file manually for changes related to: $change_type"
        fi
    done
}

# Check if running as part of another script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Running as standalone script
    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 <change_type> <message>"
        echo "Change types: code_changes, environment_changes, configuration_changes, dependency_changes, infrastructure_changes, security_changes, api_changes, installation_steps, troubleshooting_updates"
        exit 1
    fi

    update_docs "$1" "$2"
fi

# Export function for use in other scripts
export -f update_docs 