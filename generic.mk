# makefile to create and remove links from $HOME to the dotfile directory
# vim: foldmethod=marker

# functions {{{1
map            = $(foreach a,$(2),$(call $(1),$(a)))
tail           = $(lastword $(subst $(SEP), ,$(1)))
head           = $(firstword $(subst $(SEP), ,$(1)))
get            = $(word $(1),$(subst $(SEP), ,$(2)))
is_link        = $(shell cd && if [ -L $(1) ]; then echo $(1); fi)
#link           = $(LN) $(DIR)/$(subst $(SEP), ,$(1))
#echo_and_link  = echo $(call link,$(1)); cd && $(call link,$(1));

# variables {{{1
SEP         = :
DIR         = $(strip $(subst $(HOME)/, , \
	      $(realpath $(dir $(firstword $(MAKEFILE_LIST))))))
LN          = ln -s
	       
# linking files to $HOME {{{1

# these targets uses the variable CONFIGS and OTHER
echo:;@echo $(call map,tail,$(CONFIGS))
	false&&echo false ignored;echo hans
links: clean
	-cd; $(foreach pair,$(CONFIGS), \
	$(LN) $(DIR)/$(subst $(SEP), ,$(pair));)
	-$(foreach triple,$(OTHER),    \
	cd $(call get,1,$(triple)) && \
	$(LN) $(call get,2,$(triple)) $(call get,3,$(triple));)
clean:
	-cd && $(RM) $(call map,is_link,$(call map,tail,$(CONFIGS)))
	-$(foreach triple,$(OTHER),       \
	cd $(call head,$(triple))      && \
	test -L $(call tail,$(triple)) && \
	$(RM) $(call tail,$(triple));)

# update git repo {{{1
update:
	git submodule update --recursive
init:
	git submodule update --recursive --init
git-push:
	git push github master

# tags {{{1
.PHONY: links clean hardlink-generics update init git-push
