# makefile for some vim config files, by luc

VIM = vim -T dumb
GUNZIP = gunzip --keep --force
WGET = wget -nv --continue

VIMRUNTIME := /usr/share/vim/vim74
#$(shell vim --cmd 'echo $$VIMRUNTIME' --cmd quit)
BUFFERLIST = \
	     ~/notes.mkd                               \
	     ~/.config/vim/vimrc                       \
	     ~/.config/vim/gvimrc                      \
	     ~/.inputrc                                \
	     ~/.config/zsh/profile                     \
	     ~/.zshenv                                 \
	     ~/.config/zsh/zshrc                       \
	     ~/.config/zsh/aliases                     \
	     ~/.latexmkrc                              \
	     ~/.mailcap                                \
	     ~/.mime.types                             \
	     ~/.config/pentadactyl/pentadactylrc       \
	     ~/.rtorrent.rc                            \
	     ~/.tmux.conf                              \
	     ~/.config/fetchmail/fetchmailrc           \
	     ~/.config/mailfilter/main                 \
	     ~/.mutt/muttrc                            \
	     $(GNUPGHOME)/gpg.conf                     \
	     ~/.netrc                                  \
	     ~/.ssh/config                             \
	     $(PASSWORD_STORE_DIR)/old-database/yaml   \
	     ~/.config/vim/makefile                    \
	     ~/.config/vim/vimpagerrc                  \
	     ~/.config/emacs/init.el                   \
	     ~/.config/feh/keys                        \
	     ~/.config/feh/themes                      \

default-buffer-list.viminfo: $(MAKEFILE_LIST)
	@($(foreach item,$(BUFFERLIST),echo $(item);)) | \
	  sed 's#$(HOME)#~#;s/^/%/;s/$$/\t0\t0/' > $@

#%~/.config/mail/mailcheckrc
# remote files
#%ftp://ftp.lima-city.de/index.html	0	0
#%ftp://ftp.lima-city.de/files/dotfiles/index.php	0	0
#%scp://math/.profile	0	0
#%scp://ifi/.profile	0	0
#%scp://ifi/.profile_local	0	0
#%scp://lg/.bash_profile	0	0

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
