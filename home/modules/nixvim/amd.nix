{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim = {
    enable = true;
    version.enableNixpkgsReleaseCheck = false;
    nixpkgs.source = inputs.nixpkgs;

    opts = {
      number = true;
      relativenumber = true;
    };

    plugins.lualine.enable = true;

    plugins.indent-blankline = {
      enable = true;
      settings = {
        indent = {
          char = "│";
        };
      };
    };

    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        folding.enable = true;
      };
    };

    plugins.lsp = {
      enable = true;
    };

    plugins.lsp-format = {
      enable = true;
      settings.lspServersToEnable = "all";
    };

    lsp.servers = {
      ruff.enable = true;
      pyright = {
        enable = true;
        package = pkgs.pyright;
      };
      ts_ls.enable = true;
      rust_analyzer.enable = true;
      nil.enable = true;
    };

    keymaps = [
      {
        key = ";";
        action = ":";
      }
    ];

    globals.mapleader = " ";
  };
}
