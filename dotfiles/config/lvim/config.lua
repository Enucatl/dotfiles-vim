lvim.leader = ","
lvim.colorscheme = "solarized-flat"

local opts = { silent = true }
vim.keymap.set("n", "<Up>", ":bnext<CR>", opts)
vim.keymap.set("n", "<Down>", ":bprevious<CR>", opts)

vim.opt.guifont = "Inconsolata:h18"
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

require("lspconfig").ruff.setup({
	on_attach = on_attach,
})

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
			"Gedit",
		},
		ft = { "fugitive" },
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
						command = "fd --type symlink python$ /opt/home/user/venv/",
					},
				},
			},
		},
		lazy = false,
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
				rust = { "cargo fmt" },
				-- etc.
			},

			-- Configure format on save within conform.nvim
			-- This might override or work with lvim.format_on_save.enabled
			-- Check LunarVim docs for how they integrate.
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true, -- Try LSP formatting if conform fails (optional)
			},
		},
	},
}
