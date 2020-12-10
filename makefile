# makefile for some vim config files, by luc

# Targets for system installtion
install-deps:
	pacaur -S neovim-symlinks python{,2}-neovim

# Other targets
VIM = nvim
GUNZIP = gunzip --keep --force
WGET = wget -nv --continue

$(HOME)/.local/bin/v: bin/v
	ln -fns $(PWD)/$< $@
ansiesc: AnsiEsc.vba doc/tags
	$(VIM) -S $< -c quit
	cut -f 2- -d : < .VimballRecord | tr '|' '\n' | sed "s/^ *call delete('//;s/')$$//;s#^$(PWD)/##" >> .git/info/exclude

AnsiEsc.vba.gz:
	$(WGET) http://www.drchip.org/astronaut/vim/vbafiles/AnsiEsc.vba.gz
doc/tags: doc/*.txt
	$(VIM) --cmd helptags\ doc --cmd quit
%: %.gz
	$(GUNZIP) $<
clean-excludes:
	sort -u .git/info/exclude > .exclude.tmp
	mv -f .exclude.tmp .git/info/exclude
.PHONY: clean-excludes
