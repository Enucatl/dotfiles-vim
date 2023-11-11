# Install

Config files can be backed up to a tar archive with the `rake backup` task.
They will be saved to `~/dotfiles.vim.backup.tar`.

    sudo apt install rake git
    cd
    git clone git@github.com:Enucatl/dotfiles-vim.git .vim
    cd .vim
    rake backup
    rake

# Neovim
Configured with https://github.com/LunarVim/LunarVim
