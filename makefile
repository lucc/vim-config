# makefile for some vim config files, by luc

VIM = vim -T dumb
GUNZIP = gunzip --keep --force
WGET = wget -nv --continue

VIMRUNTIME := /usr/share/vim/vim74
#$(shell vim --cmd 'echo $$VIMRUNTIME' --cmd quit)

system-plugins: plugin/matchit.vim plugin/editexisting.vim doc/tags
doc/tags: doc/matchit.txt
	$(VIM) --cmd helptags\ doc --cmd quit
manpageview: .downloads/manpageview.vba
	$(VIM) -S $< +quit

plugin/%: $(VIMRUNTIME)/macros/%
	cp -f $< $@
doc/%: $(VIMRUNTIME)/macros/%
	cp -f $< $@

.downloads/manpageview.vba.gz: .downloads
	$(WGET) --directory-prefix .downloads http://www.drchip.org/astronaut/vim/vbafiles/manpageview.vba.gz
.downloads:
	mkdir $@

%: %.gz
	$(GUNZIP) $<
