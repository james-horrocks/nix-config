{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = lib.mkMerge [
      lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      ''
      lib.mkOrder 1000 ''
        eval `dircolors ~/.dircolors`
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        fpath+=~/.zsh_functions
        export EDITOR='code'
      ''
    ];

    localVariables = {
      POWERLEVEL9K_MODE = "nerdfont-complete";
      COMPLETION_WAITING_DOTS = true;
      ZSH_DISABLE_COMPFIX = true;
      PAGER = "less";
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
    '';

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
        "git"
        "gh"
        "python"
        "pip"
        "docker"
        "aws"
        "terraform"
      ];
    };
  };

  home.file.".p10k.zsh".source = ../nixps/home_manager/powerlevel10k.zsh;
}
