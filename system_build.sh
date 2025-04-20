# Bash script to symlink all nix files in all subdirectories to /etc/nixos

# Get the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Find all nix files in the current directory and all subdirectories
echo "DIR: $DIR"
if [ -L /etc/nixos ] && [ "$(readlink -f /etc/nixos)" = "$(realpath $DIR)" ]; then
    echo "/etc/nixos is already symlinked to $DIR"
else
    echo "Symlinking /etc/nixos to $DIR"
    sudo rm -rf /etc/nixos
    sudo ln -s "$(realpath $DIR)" /etc/nixos
fi

sudo cachix authtoken $(op read op://personal/cachix/personal\ auth\ token)

# Rebuild the system using the flake name passed as an argument and switch to it
nh --version
if [ $? -eq 0 ]; then
    cachix watch-exec --watch-mode post-build-hook --compression-level 10 james-horrocks -- nh os switch -H $1
else
    cachix watch-exec --watch-mode post-build-hook --compression-level 10 james-horrocks -- sudo nixos-rebuild switch --flake .#$1
fi
