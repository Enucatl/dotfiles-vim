.PHONY: clean install backup submodules

TARGETS=.Rprofile .xmobarrc .xmonad/xmonad.hs .gitconfig .gitignore .vimrc .gvimrc .pentadactylrc .bashrc .bash_aliases .bash_completion bin/gvim_fg bin/remove_submodule.sh .ctags .pylintrc .agignore bin/func_cd bin/func_mcd bin/pdftobook bin/func_sortdu bin/run-command-on-git-revisions bin/pushifupstream bin/pullifupstream .config/ipython/profile_default/startup/load_math.py
FOLDER=~
SUBFOLDERS=$(addprefix ${FOLDER}/, .vim .xmonad .config/ipython/profile_default/startup bin)
END_TARGETS=$(addprefix ${FOLDER}/, ${TARGETS})
BACKUP_FILE=.dotfiles.backup.tar

install: ${SUBFOLDERS} ${END_TARGETS} submodules

submodules:
	git submodule init
	git submodule sync
	git submodule update

${SUBFOLDERS}:
	mkdir -p $@

${FOLDER}/bin/%: bin/% | ${FOLDER}/bin
	ln -s ${FOLDER}/.vim/$< $@

${FOLDER}/.xmonad/%: dotfiles/% | ${FOLDER}/.xmonad
	ln -s ${FOLDER}/.vim/$< $@

${FOLDER}/.%: dotfiles/%
	ln -s ${FOLDER}/.vim/$< $@

clean:
	rm -f ${END_TARGETS}

backup:
	cd ${FOLDER}; tar rf ${BACKUP_FILE} --ignore-failed-read ${TARGETS}
	@echo "Any files that would be overwritten are saved to ${FOLDER}/${BACKUP_FILE}"
