{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    # syntaxHighlighting = {
    #   enable = true;
    # };

    initExtraFirst = ''
    if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
      source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    fi
    '';

    initExtra = ''
    eval `dircolors ~/.dircolors`
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    fpath+=~/.zsh_functions
    if [[ -n $SSH_CONNECTION ]]; then
      export EDITOR='nano'
    else
      export EDITOR='code'
    fi
    '';

    localVariables = {
      POWERLEVEL9K_MODE="nerdfont-complete";
      COMPLETION_WAITING_DOTS=true;
      ZSH_DISABLE_COMPFIX=true;
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
    '';

    sessionVariables = {
      PAGER="most";
      AWS_SDK_LOAD_CONFIG=1;
      SPICETIFY_INSTALL="$HOME/spicetify-cli";
      PATH="$SPICETIFY_INSTALL:$HOME/.poetry/bin:$PATH";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "z"
        "common-aliases"
        "sudo"
        "git"
        "python"
        "pip"
        "poetry"
        "virtualenv"
        "aws"
        "docker"
        "docker-compose"
        "terraform"
        "rsync"
        "systemd"
        "1password"
      ];
    };
  };

  home.file.".p10k.zsh".source = ./powerlevel10k.zsh;
}