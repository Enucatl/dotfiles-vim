vim.cmd [[ set background=light ]]
local status_ok, solarized = pcall(require, "solarized")
if not status_ok then
    vim.notify("colorscheme solarized not found")
    return
else
    vim.g.solarized_italic_comments = false
    vim.g.solarized_italic_keywords = false
    vim.g.solarized_italic_functions = false
    vim.g.solarized_italic_variables = false
    vim.g.solarized_contrast = false
    vim.g.solarized_borders = true
    vim.g.solarized_disable_background = false
    solarized.set()
end
