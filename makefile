# makefile for some vim config files, by luc

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
