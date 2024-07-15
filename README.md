# Install
Config files can be backed up to a tar archive with the `rake backup` task.
They will be saved to `~/dotfiles.vim.backup.tar`.

    sudo apt install rake git
    cd
    git clone git@github.com:Enucatl/dotfiles-vim.git .vim
    cd .vim
    rake backup
    rake

# SSH key allowed signers
Add the key to the SSH allowed signers for git verification

```bash
echo "$(git config --get user.email) namespaces=\"git\" $(cat ~/.ssh/id_ed25519.pub)" >> $(git config gpg.ssh.allowedsignersfile)
```

# Neovim
Configured with https://github.com/LunarVim/LunarVim
