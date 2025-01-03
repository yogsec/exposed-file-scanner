#!/bin/bash

# Banner
echo -e "\033[34m========================================"
echo -e "       Exposed File Finder by YogSec    "
echo -e "========================================\033[0m"

# Function to display help
show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -u <url>         Scan a single URL for exposed files."
    echo "  -l <file>        Scan a list of URLs from a file."
    echo "  -s <file>        Save results to a specified file."
    echo "  -h               Show this help message."
}

# Function to find exposed files in the given content
find_exposed_files() {
    local content="$1"
    echo "$content" | grep -Eo "\b[A-Za-z0-9_-]+\\.(bak|tar|sql|zip|log|config|php|json|tmp|swp)\b"
}

# Function to fetch and analyze a URL with retries
scan_url() {
    local url="$1"
    local save_file="$2"
    local retries=5
    local delay=5
    echo -e "\033[34mScanning: $url\033[0m"

    # Retry logic for fetching content
    local content
    for ((i=1; i<=retries; i++)); do
        content=$(curl -s --max-time 60 "$url")
        
        # If content fetched successfully, break out of the loop
        if [[ -n "$content" ]]; then
            break
        fi
        
        # If the last retry failed, wait and retry
        if ((i < retries)); then
            echo "Retrying $url ($i/$retries)..."
            sleep "$delay"
        else
            echo -e "\033[31mFailed to fetch content from $url after $retries attempts.\033[0m"
            return
        fi
    done

    # Extract href or src attributes containing possible file paths
    local links
    links=$(echo "$content" | grep -Eo 'href="[^"]+"|src="[^"]+"' | grep -Eo 'http[^"]+')

    # Search for exposed files in the links
    local exposed_files
    exposed_files=$(find_exposed_files "$links")

    if [[ -n "$exposed_files" ]]; then
        echo -e "\033[31mExposed files found in $url:\033[0m"
        echo -e "\033[31m$exposed_files\033[0m"
        # Save results if a file is specified
        [[ -n "$save_file" ]] && echo -e "URL: $url\n$exposed_files\n" >> "$save_file"
    else
        echo -e "\033[32mNo exposed files found in $url.\033[0m"
    fi
}

# Main script logic
output_file=""
urls_file=""

if [[ $# -eq 0 ]]; then
    show_help
    exit 1
fi

while getopts "u:l:s:h" opt; do
    case $opt in
        u)  # Single URL
            single_url="$OPTARG"
            ;;
        l)  # List of URLs
            urls_file="$OPTARG"
            ;;
        s)  # Save results to file
            output_file="$OPTARG"
            ;;
        h)  # Help
            show_help
            exit 0
            ;;
        *)  
            show_help
            exit 1
            ;;
    esac
done

# Check if the output file is specified and create it
if [[ -n "$output_file" ]]; then
    >"$output_file"  # Clear the file before use
fi

# Process URLs
if [[ -n "$single_url" ]]; then
    scan_url "$single_url" "$output_file"
elif [[ -n "$urls_file" ]]; then
    if [[ -f "$urls_file" ]]; then
        export -f scan_url find_exposed_files  # Export functions for xargs
        export output_file
        cat "$urls_file" | xargs -P 5 -I {} bash -c 'scan_url "{}" "$output_file"'  # Reduce parallel processes to 5
    else
        echo "File not found: $urls_file"
        exit 1
    fi
else
    echo "No URL or file specified."
    show_help
    exit 1
fi
