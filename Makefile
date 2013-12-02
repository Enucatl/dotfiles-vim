.PHONY: clean install
TARGETS=~/bin/func_cd ~/bin/func_mcd ~/.Rprofile ~/.xmobarrc ~/.xmonad/xmonad.hs ~/.gitconfig ~/.gitignore ~/.vimrc ~/.gvimrc ~/.pentadactylrc ~/.bashrc ~/.bash_aliases ~/.bash_completion ~/bin/gvim_fg ~/.ctags ~/.pylintrc

install: ${TARGETS}
	git submodule init
	git submodule update

~/bin/%: %
	mkdir -p ~/bin
	ln -s ~/.vim/$< $@

~/.xmonad/%: %
	mkdir -p ~/.xmonad
	ln -s ~/.vim/$< $@

~/.%: %
	ln -s ~/.vim/$< $@

clean:
	rm -f ${TARGETS}
