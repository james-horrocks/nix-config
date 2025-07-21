# NixOS Configuration

A comprehensive Nix flake configuration for managing both NixOS systems and Home Manager environments across different platforms.

## 📋 Overview

This repository contains:
- **NixOS system configurations** for desktop/laptop environments
- **Home Manager configurations** for both NixOS and non-NixOS systems (including WSL)
- **Development tools** and shell environment setup
- **Terminal customizations** with modern themes and tools

## 🏗️ Structure

```
.
├── flake.nix              # Main flake configuration
├── flake.lock             # Locked dependencies
├── home_build.sh          # Home Manager build script
├── system_build.sh        # NixOS system build script
└── hosts/
    ├── nixps/             # NixOS desktop configuration
    │   ├── configuration.nix
    │   ├── hardware-configuration.nix
    │   ├── home.nix
    │   └── home_manager/  # Home Manager modules
    └── wsl/               # WSL environment configuration
        ├── home.nix
        └── home_manager/
```

## 🖥️ Configurations

### NixOS Systems
- **nixps**: Dell XPS 13 9300 with COSMIC desktop environment

### Home Manager Profiles
- **james@nixps**: Full desktop environment with GUI applications
- **wsl**: Minimal terminal-focused environment for WSL

## 🚀 Quick Start

### Prerequisites
- [Nix package manager](https://nixos.org/download.html) installed
- [Flakes enabled](https://nixos.wiki/wiki/Flakes#Enable_flakes) in your Nix configuration

### For NixOS Systems

1. Clone this repository:
   ```bash
   cd ~
   git clone https://github.com/james-horrocks/nix-config.git
   cd nix-config
   ```

2. Build and switch to the configuration:
   ```bash
   ./system_build.sh james@nixps
   ```

### For Home Manager on Non-NixOS Systems

#### Initial Setup
1. **Install Lix** (if not already installed):
    ```bash
    curl -sSf -L https://install.lix.systems/lix | sh -s -- install
    ```

2. **Add the Home Manager channel**:
    ```bash
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    ```

3. **Clone this repository (if you haven't already)**:
    ```bash
    git clone <your-repo-url> ~/.config/nix-config
    cd ~/.config/nix-config
    ```

4. **Install Home Manager**:
    ```bash
    nix-shell '<home-manager>' -A install
    ```

5. **Apply the configuration**:
    ```bash
    ./home_build.sh wsl
    ```

6. **Change repo origin to use ssh** (optional):
   ```bash
   git remote set-url origin git@github.com:james-horrocks/nix-config.git
    ```

#### For WSL Specifically

If you're running Windows Subsystem for Linux:

1. **Install WSL2** with your preferred Linux distribution
2. **Install Lix** inside WSL:
   ```bash
   curl -sSf -L https://install.lix.systems/lix | sh -s -- install
   ```
3. **Follow the Home Manager setup steps above** using the `wsl` configuration

## 🔧 Features

### Development Environment
- **Modern shell setup** with Zsh and Powerlevel10k
- **Essential development tools**: Git, editors, compilers
- **Terminal enhancements**: Syntax highlighting, better navigation
- **Cachix integration** for faster builds

### Desktop Environment (NixOS)
- **COSMIC desktop** environment
- **Hardware optimization** for Dell XPS 13 9300
- **Lix** as Nix implementation
- **Gaming support** and multimedia tools

### Terminal Setup
- **Ghostty terminal** with custom themes
- **Zsh with Powerlevel10k** for enhanced prompt
- **Dracula color scheme** for consistent theming
- **Fast syntax highlighting** and completion

## 📜 Scripts

### `home_build.sh`
Builds and switches Home Manager configurations with optional Cachix caching.

**Usage:**
```bash
./home_build.sh <configuration-name>
```

**Examples:**
```bash
./home_build.sh wsl          # For WSL/non-NixOS systems
./home_build.sh james@nixps  # For NixOS desktop
```

### `system_build.sh`
Rebuilds NixOS system configurations (requires sudo).

**Usage:**
```bash
./system_build.sh <hostname>
```

## 🎨 Customization

### Adding New Hosts

1. Create a new directory under `hosts/`:
   ```bash
   mkdir hosts/new-host
   ```

2. Add the necessary configuration files:
   - `configuration.nix` (for NixOS)
   - `home.nix` (for Home Manager)
   - `home_manager/` directory with specific modules

3. Update `flake.nix` to include the new configuration

### Modifying Existing Configurations

- **System-level changes**: Edit files in `hosts/<hostname>/`
- **User-level changes**: Edit Home Manager modules in `hosts/<hostname>/home_manager/`
- **Global changes**: Modify `flake.nix` inputs and outputs

## 🔄 Updating

To update all flake inputs:
```bash
nix flake update
```

To rebuild after updates:
```bash
./home_build.sh <configuration>  # For Home Manager
./system_build.sh <hostname>     # For NixOS
```

## 🛠️ Troubleshooting

### Common Issues

1. **"experimental feature 'flakes' is disabled"**
   - Enable flakes in your Nix configuration as shown in the setup section

2. **Permission errors on non-NixOS systems**
   - Ensure you're using the daemon installation of Nix
   - Check that your user is in the `nix-users` group

3. **Build failures**
   - Check the flake lock file is up to date: `nix flake update`
   - Verify internet connectivity for downloading dependencies

### Getting Help

- Check the [NixOS manual](https://nixos.org/manual/nixos/stable/)
- Visit the [Home Manager manual](https://nix-community.github.io/home-manager/)
- Join the [NixOS Discourse](https://discourse.nixos.org/)

## 📝 License

This configuration is provided as-is for personal use. Feel free to adapt it to your needs.

---

*Generated with ❤️ using Nix and Home Manager*