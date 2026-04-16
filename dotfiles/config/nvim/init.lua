-- === Leader & Basic Settings ===
vim.g.mapleader = ","
vim.opt.guifont = "Inconsolata:h18"
vim.opt.background = "light"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- === Keymaps ===
local opts = { silent = true }
vim.keymap.set("n", "<Up>", ":bnext<CR>", opts)
vim.keymap.set("n", "<Down>", ":bprevious<CR>", opts)

-- === Bootstrap lazy.nvim ===
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- === Plugins ===
require("lazy").setup({
  -- Colorscheme
  { "ishan9299/nvim-solarized-lua", lazy = false, priority = 1000,
    config = function() vim.cmd.colorscheme("solarized") end },

  -- Utilities
  { "tpope/vim-fugitive", cmd = { "G", "Git", "Gdiffsplit" } },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },

  -- LSP + Mason
  { "williamboman/mason.nvim", config = function() require("mason").setup() end },
  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({ ensure_installed = { "pyright", "ruff" } })

      -- Pyright: completions + type checking
      vim.lsp.config("pyright", {
        settings = { python = { analysis = { typeCheckingMode = "basic" } } },
      })
      vim.lsp.enable("pyright")

      -- Ruff: linting/formatting only
      vim.lsp.config("ruff", {
        on_attach = function(c)
          c.server_capabilities.hoverProvider = false
          c.server_capabilities.completionProvider = false
        end,
      })
      vim.lsp.enable("ruff")
    end },

  -- Formatting with conform.nvim
  { "stevearc/conform.nvim", event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        lua = { "stylua" },
        rust = { "rustfmt" },
      },
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
    } },

  -- venv-selector
  { "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
      settings = {
        search = { opt_venvs = { command = "fd --type symlink python$ /opt/home/user/venv/" } },
      },
    },
    keys = { { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select venv" } },
  },
})

-- === Diagnostics ===
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  signs = true,
  severity_sort = true,
})
