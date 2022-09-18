-- setup of all plugins that don't have their separate setup file

local status_ok, surround = pcall(require, "nvim-surround")
if status_ok then
    surround.setup({})
end

