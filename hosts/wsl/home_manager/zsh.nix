{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = 
      let 
        initExtraFirstContent = lib.mkOrder 500 ''
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '';

        initExtraContent = lib.mkOrder 1000''
          eval `dircolors ~/.dircolors`
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
          fpath+=~/.zsh_functions
          if [[ -n $SSH_CONNECTION ]]; then
            export EDITOR='nano'
          else
            export EDITOR='code'
          fi
        '';

      in lib.mkMerge [
        initExtraFirstContent
        initExtraContent
      ];

    localVariables = {
      POWERLEVEL9K_MODE = "nerdfont-complete";
      COMPLETION_WAITING_DOTS = true;
      ZSH_DISABLE_COMPFIX = true;
      PAGER = "most";
      AWS_SDK_LOAD_CONFIG = 1;
      DOCKER_HOST = "unix:///run/user/1000/docker.sock";
      JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64";
    };

    profileExtra = ''
      if [ -d "$HOME/bin" ] ; then
          PATH="$HOME/bin:$PATH"
      fi

      if [ -d "$HOME/.local/bin" ] ; then
          PATH="$HOME/.local/bin:$PATH"
      fi

      if [ -d "${pkgs.vscode}/bin" ] ; then
          PATH="${pkgs.vscode}/bin:$PATH"
      fi

      if [ -d "$HOME/go/bin" ] ; then
          PATH="$HOME/go/bin:$PATH"
      fi

      if [ -d "$HOME/.nix-profile/bin" ] ; then
          PATH="$HOME/.nix-profile/bin:$PATH"
      fi
    '';

    shellAliases = {
      ssh = "ssh.exe";
      ssh-add = "ssh-add.exe";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aliases"
        "ubuntu"
        # "nala"
        "z"
        "common-aliases"
        "sudo"
        "git"
	      "gh"
        "python"
        "pip"
        "poetry"
        "uv"
        "virtualenv"
        "aws"
        "docker"
        "docker-compose"
        "terraform"
        "rsync"
        "systemd"
        "1password"
	      "pre-commit"
	      "azure"
	      "emoji"
	      "extract"
	      "gcloud"
      ];
    };
  };

  home.file.".p10k.zsh".source = ./powerlevel10k.zsh;
}