.PHONY: clean install backup

TARGETS=.Rprofile .xmobarrc .xmonad/xmonad.hs .gitconfig .gitignore .vimrc .gvimrc .pentadactylrc .bashrc .bash_aliases .bash_completion bin/gvim_fg .ctags .pylintrc .agignore bin/func_cd bin/func_mcd bin/pdftobook bin/func_sortdu bin/run-command-on-git-revisions
FOLDER=~
BACKUP_FILE=.dotfiles.backup.tar

install: $(addprefix ${FOLDER}/, ${TARGETS})
	git submodule init
	git submodule update

${FOLDER}/bin:
	mkdir -p ${FOLDER}/bin

${FOLDER}/.xmonad:
	mkdir -p ${FOLDER}/.xmonad

${FOLDER}/.vim:
	mkdir -p ${FOLDER}/.vim

${FOLDER}/bin/%: bin/% | ~/bin
	ln -s ${FOLDER}/.vim/$< $@

${FOLDER}/.xmonad/%: dotfiles/% | ~/.xmonad
	ln -s ${FOLDER}/.vim/$< $@

${FOLDER}/.%: dotfiles/%
	ln -s ${FOLDER}/.vim/$< $@

clean:
	rm -f $(addprefix ${FOLDER}/, ${TARGETS})

backup:
	cd ${FOLDER}; tar rf ${BACKUP_FILE} --ignore-failed-read ${TARGETS}
	@echo "Any files that would be overwritten are saved to ${FOLDER}/${BACKUP_FILE}"
