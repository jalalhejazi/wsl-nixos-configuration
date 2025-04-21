{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [ # https://search.nixos.org/options?channel=unstable
    bat
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    git-crypt
    htop
    jq
    killall
    mosh
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    vim
    wget
    zip
    kubectl
    kubectx
    kubeval
    kubeone
    minikube
    k9s
  ];

  stable-packages = with pkgs; [ #https://search.nixos.org/packages
    jeezyvim

    # key tools
    gh
    just

    # .NET 
    dotnet-sdk # version 8

    # IaC and cloud
    terraform
    pulumi-bin

    # 🦀 rust
    rustup
    cargo-cache
    cargo-expand

    # local dev stuf
    mkcert
    httpie

    # treesitter
    tree-sitter

    # language servers
    nodejs-18_x # v18.20.5
    nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    nil # nix

    # NPM 
    nodePackages_latest.rimraf
    nodePackages.prettier


    # formatters and linters
    alejandra # nix
    deadnix # nix
    shellcheck
    shfmt
    statix # nix
];
in {
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    # FIXME: you can add anything else that doesn't fit into the above two lists in here
    [
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableFishIntegration = true;
    nix-index-database.comma.enable = true;

    # prompt and shell 
    starship.enable = true;
    starship.settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = false;
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      python.disabled = true;
      ruby.disabled = true;
      hostname.ssh_only = false;
      hostname.style = "bold green";
    };

    # FIXME: disable whatever you don't want
    bash.enable = true;
    fzf.enable = true;
    fzf.enableFishIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    zoxide.enable = true;
    zoxide.enableFishIntegration = true;
    zoxide.options = ["--cmd cd"];
    broot.enable = true;
    broot.enableFishIntegration = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "jh@linuxfoundation.org"; # FIXME: set your git email
      userName = "jh"; #FIXME: set your git username
      extraConfig = {
        # FIXME: uncomment the next lines if you want to be able to clone private https repos
        # url = {
        #   "https://oauth2:${secrets.github_token}@github.com" = {
        #     insteadOf = "https://github.com";
        #   };
        #   "https://oauth2:${secrets.gitlab_token}@gitlab.com" = {
        #     insteadOf = "https://gitlab.com";
        #   };
        # };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

    # FIXME: This is my fish config - you can fiddle with it if you want
    fish = {
      enable = true;
      # FIXME: run 'scoop install win32yank' on Windows, then add this line with your Windows username to the bottom of interactiveShellInit
      # fish_add_path --append /mnt/c/Users/<Your Windows Username>/scoop/apps/win32yank/0.1.1
      interactiveShellInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

        ${pkgs.lib.strings.fileContents (pkgs.fetchFromGitHub {
            owner = "rebelot";
            repo = "kanagawa.nvim";
            rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
            sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
          }
          + "/extras/kanagawa.fish")}

        set -U fish_greeting
        fish_add_path --append /mnt/c/Users/${username}/scoop/apps/win32yank/0.1.1
      '';
      functions = {
        refresh = "source $HOME/.config/fish/config.fish";
        who="whoami";
        take = ''mkdir -p -- "$1" && cd -- "$1"'';
        ttake = "cd $(mktemp -d)";
        path = "echo $PATH | tr ' ' '\n'";
        posix-source = ''
          for i in (cat $argv)
            set arr (echo $i |tr = \n)
            set -gx $arr[1] $arr[2]
          end
        '';
      };
      shellAbbrs =
        {
          gc = "nix-collect-garbage --delete-old";
        }
        # navigation shortcuts
        // {
          ".." = "cd ..";
          "..." = "cd ../../";
          "...." = "cd ../../../";
          "....." = "cd ../../../../";
        }
        # git shortcuts
        // {
          gs = "git status";
          git-status = "git status";
          git-show = "git show";
          git-add-patch = "git add --patch";
          git-reset-patch = "git reset --patch";
          git-diff-head = "git diff HEAD";
          git-commit = "git commit";
          git-commit-amend = "git commit --amend --no-edit";
          git-push = "git push";
          git-push-head = "git push -u origin HEAD";
          git-checkout = "git checkout";
          git-checkout-b = "git checkout -b";
          git-checkout-main = "git checkout main";
          git-checkout-dev = "git checkout dev";
          git-stash-push = "git stash push -m";
          git-stash-apply = "git stash apply stash^{/";
          git-stash-list = "git stash list";
          git-log-hitory-n10 = "git log --graph --oneline --decorate -n 10";
          git-log-hitory-n01 = "git log --graph --oneline --decorate -n 1";
        };
      shellAliases = {
        jvim = "nvim";
        edit = "nvim";

        # (windows c drive) call windows programs outside of WSL 
        f = "/mnt/c/Windows/explorer.exe";
        finder = "/mnt/c/Windows/explorer.exe";
        explorer = "/mnt/c/Windows/explorer.exe";
        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        subl = "/mnt/c/Users/${username}/scoop/shims/subl.exe";
        
        # nixos rebuild and garbage collection
        rebuild = "~/configuration/bash/nixos-rebuild.sh";
        build = "~/configuration/bash/nixos-rebuild.sh";
        clean-docker-images = "~/configuration/bash/gc.sh";
        clean-generations = "nix-collect-garbage -d";

        # kubernetes cluster management
        k8s-init = "~/configuration/bash/k8s-nixos-dev-cluster.sh";
        
        # process management
        process-kill = "~/configuration/bash/process-kill.sh";

        # GIT: calling scripts to do more than just the shellAbbrs section
        git-reset-hard = "~/configuration/bash/git-reset-hard.sh";
        git-log-file = "~/configuration/bash/git-log.sh";
        git-deploy = "~/configuration/bash/git-push.sh";

        # Experiments and test only 
        test-mssql = "~/configuration/bash/experimental/mssql/test.sh";
        test-nix-shell = "~/configuration/bash/experimental/nix-shell/test.sh";

      };
      plugins = [
        {
          inherit (pkgs.fishPlugins.autopair) src;
          name = "autopair";
        }
        {
          inherit (pkgs.fishPlugins.done) src;
          name = "done";
        }
        {
          inherit (pkgs.fishPlugins.sponge) src;
          name = "sponge";
        }
      ];
    };
  };
}
