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

require("lspconfig").ruff_lsp.setup {
  on_attach = on_attach,
}

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Auto select virtualenv Nvim open",
  pattern = "*",
  callback = function()
    local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
    if venv ~= "" then
      require("venv-selector").retrieve_from_cache()
    end
  end,
  once = true,
})

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { name = "black" }, }
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
      -- Your options go here
      name = ".venv",
      venvwrapper_path = "/opt/home/user/venv/",
      -- auto_refresh = false
    },
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    }
  }
}
