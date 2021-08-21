$(HOME)/.local/bin/v: bin/v
	ln -fns $(PWD)/$< $@
