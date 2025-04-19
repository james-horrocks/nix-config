nh --version
if [ $? -eq 0 ]; then
    cachix watch-exec --watch-mode post-build-hook james-horrocks -- nh home switch -b bak
else
    cachix watch-exec --watch-mode post-build-hook james-horrocks -- home-manager --flake .#$1 -b bak switch
fi
