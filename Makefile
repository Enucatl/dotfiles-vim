.PHONY: clean install

TARGETS=~/.Rprofile ~/.xmobarrc ~/.xmonad/xmonad.hs ~/.gitconfig ~/.gitignore ~/.vimrc ~/.gvimrc ~/.pentadactylrc ~/.bashrc ~/.bash_aliases ~/.bash_completion ~/bin/gvim_fg ~/.ctags ~/.pylintrc ~/.agignore ~/bin/func_cd ~/bin/func_mcd ~/bin/pdftobook ~/bin/func_sortdu

install: ${TARGETS}
	git submodule init
	git submodule update

~/bin:
	mkdir -p ~/bin

~/.xmonad:
	mkdir -p ~/.xmonad

~/bin/%: bin/% | ~/bin
	ln -s ~/.vim/$< $@

~/.xmonad/%: dotfiles/% | ~/.xmonad
	ln -s ~/.vim/$< $@

~/.%: dotfiles/%
	ln -s ~/.vim/$< $@

clean:
	rm -f ${TARGETS}
