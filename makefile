# makefile for some vim config files, by luc

VIM = vim -T dumb
GUNZIP = gunzip --keep --force
WGET = wget -nv --continue
VIMRUNTIME := /usr/share/vim/vim74
#$(shell vim --cmd 'echo $$VIMRUNTIME' --cmd quit)

URLS = http://www.drchip.org/astronaut/vim/vbafiles/manpageview.vba.gz \
       http://www.drchip.org/astronaut/vim/vbafiles/AnsiEsc.vba.gz     \
       http://www.fastnlight.com/syntax/applescript.vim

define download-rules
.downloads/$(notdir $1): .downloads
	$(WGET) --directory-prefix .downloads $1
$(patsubst %.vba.gz,%,$(notdir $1)): .downloads/$(patsubst %.vba.gz,%.vba,$(notdir $1))
	$(VIM) -S $$< -c quit
	cut -f 2- -d : < .VimballRecord | tr '|' '\n' | sed "s/^ *call delete('//;s/')$$$$//;s#^$(PWD)/##" >> .git/info/exclude
.PHONY: $(patsubst %.vba.gz,%,$(notdir $1))
endef
define system-rules
$1/%: $(VIMRUNTIME)/macros/%
	cp -f $$< $$@
	echo $$@ >> .git/info/exclude
$1/%: .downloads/%
	cp -f $$< $$@
	echo $$@ >> .git/info/exclude
endef

web-plugins: manpageview AnsiEsc syntax/applescript.vim doc/tags
system-plugins: plugin/matchit.vim doc/matchit.txt plugin/editexisting.vim doc/tags
$(foreach url,$(URLS),$(eval $(call download-rules,$(url))))
$(foreach folder,plugin syntax doc,$(eval $(call system-rules,$(folder))))
doc/tags: doc/*.txt
	$(VIM) --cmd helptags\ doc --cmd quit
.downloads:
	mkdir $@
%: %.gz
	$(GUNZIP) $<
