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
Configured directly in `~/.config/nvim/init.lua`.

# Codex
Puppet's `profile::codex_config` manages shared defaults in
`/etc/codex/config.toml` on desktop and Docker hosts. Codex owns the writable
`~/.codex/config.toml` for user overrides and runtime state. User settings,
including later model selections, take precedence over the system defaults.
Instructions and skills continue to use the existing dotfiles links.

During cutover, Puppet removes `~/.codex/config.toml` only if it is the old
`~/.vim/dotfiles/codex/config.toml` symlink, before updating dotfiles and syncing
plugins. Regular config files remain untouched. State from the old tracked
config is intentionally discarded without migration. Reboot after deployment;
Codex recreates its user config as needed, and trust confirmations may appear
again once.
