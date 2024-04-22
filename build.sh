# Bash script to symlink all nix files in all subdirectories to /etc/nixos

sudo rm -r /etc/nixos/*

# Get the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Find all nix files in the current directory and all subdirectories
echo "DIR: $DIR"
find $DIR -not -name "build.sh" -not -path "*/\.*" | while read file; do
    # Get the relative path of the file
    echo "FILE: $file"
    relpath=$(realpath --relative-to=$DIR $file)
    # Check if file is in a subdirectory
    if [[ $relpath == *"/"* ]]; then
        # Create the subdirectory in /etc/nixos if it doesn't exist
        subdir=$(dirname $relpath)
        echo "$file is in a subdirectory, creating subdirectory at /etc/nixos/$subdir"
        sudo mkdir -p /etc/nixos/$subdir
    fi
    echo "RELPATH: $relpath"
    # Create the symlink
    sudo ln $file /etc/nixos/$relpath
done

# Rebuild the system using the flake name passed as an argument and switch to it
nh os switch -H $1 || sudo nixos-rebuild switch --flake /etc/nixos#$1
