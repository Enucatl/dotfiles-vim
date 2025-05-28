lvim.leader = ","
lvim.colorscheme = "solarized-flat"

local opts = { silent = true }
vim.keymap.set("n", "<Up>", ":bnext<CR>", opts)
vim.keymap.set("n", "<Down>", ":bprevious<CR>", opts)

vim.opt.guifont = "Inconsolata Nerd Font Mono:h18"
vim.opt.background = "light"

-- improve python highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
  "rust",
}
-- formatting
local on_attach = function(client, bufnr)
  -- Disable hover in favor of Pyright
  client.server_capabilities.hoverProvider = false
end

require("lspconfig").ruff.setup {
  on_attach = on_attach,
}

lvim.format_on_save.enabled = true

lvim.plugins = {
  { "ishan9299/nvim-solarized-lua" },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   event = "InsertEnter",
  --   dependencies = { "zbirenbaum/copilot.lua" },
  --   config = function()
  --     vim.defer_fn(function()
  --       require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
  --       require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
  --     end, 100)
  --   end,
  -- },
  { "tpope/vim-repeat" },
  {
    "tpope/vim-surround",
    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    -- setup = function()
    --  vim.o.timeoutlen = 500
    -- end
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      settings = {
        search = {
          opt_venvs = {
            command = "fd --type symlink python$ /opt/home/user/venv/"
          }
        }
      }
    },
    lazy = false,
    branch = "regexp",
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
    },
  },
  {
    "stevearc/conform.nvim",
    -- Ensure conform.nvim is included in your plugins
    opts = {
      -- Define formatters for specific filetypes
      formatters_by_ft = {
        -- Use 'ruff_format' for Python files
        -- conform.nvim often uses names like tool_format or tool_lint
        python = { "ruff_format" },

        -- Add other formatters for other languages here
        lua = { "stylua" },
        javascript = { "prettier" },
        -- etc.
      },

      -- Configure format on save within conform.nvim
      -- This might override or work with lvim.format_on_save.enabled
      -- Check LunarVim docs for how they integrate.
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true, -- Try LSP formatting if conform fails (optional)
      },
    },
  },
  {
    "yetone/avante.nvim",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "gemini",
      gemini = {
        -- endpoint = "https://api.openai.com/v1",
        model = "gemini-2.0-flash", -- your desired model (or use gpt-4o, etc.)
        timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
        temperature = 0.3,
        max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make BUILD_FROM_SOURCE=true",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}
