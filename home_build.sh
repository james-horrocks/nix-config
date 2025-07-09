if command -v cachix &>/dev/null; then
    cachix authtoken $(op read op://personal/cachix/personal\ auth\ token)
    if nh --version &>/dev/null; then
        cachix watch-exec --watch-mode post-build-hook --compression-level 10 james-horrocks -- nh home switch --configuration $1 -b bak .
    else
        cachix watch-exec --watch-mode post-build-hook --compression-level 10 james-horrocks -- home-manager --flake .#$1 -b bak switch
    fi
else
    if nh --version &>/dev/null; then
        nh home switch --configuration $1 -b bak .
    else
        home-manager --flake .#$1 -b bak switch
    fi
fi
