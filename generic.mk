# makefile to create and remove links from $HOME to the dotfile directory
# vim: foldmethod=marker

# functions {{{1
map            = $(foreach a,$(2),$(call $(1),$(a)))
tail           = $(lastword $(subst $(SEP), ,$(1)))
head           = $(firstword $(subst $(SEP), ,$(1)))
get            = $(word $(1),$(subst $(SEP), ,$(2)))
is_link        = $(shell cd && if [ -L $(1) ]; then echo $(1); fi)
link           = $(LN) $(DIR)/$(subst $(SEP), ,$(1))
echo_and_link  = echo $(call link,$(1)); cd && $(call link,$(1));

# variables {{{1
SEP         = :
DIR         = $(strip $(subst $(HOME)/, , \
	      $(realpath $(dir $(firstword $(MAKEFILE_LIST))))))
LN          = ln -s
	       
# linking files to $HOME {{{1

# these targets uses the variable CONFIGS
links: clean
	$(foreach triple,                                               \
	  $(CONFIGS),                                                   \
	  cd $(call get,1,$(triple)) &&                                 \
	  ln -s $(DIR)/$(call get,2,$(triple)) $(call get,3,$(triple)); \
	  )
	$(foreach triple,                                        \
	  $(OTHER),                                              \
	  cd $(call get,1,$(triple)) &&                          \
	  ln -s $(call get,2,$(triple)) $(call get,3,$(triple)); \
	  )
clean:
	-$(foreach triple,                   \
	  $(CONFIGS) $(OTHER),               \
	  cd $(call get,1,$(triple))      && \
	  test -L $(call get,3,$(triple)) && \
	  $(RM) $(call get,3,$(triple))   ;  \
	  )
hardlink-generics:
	ln $(HOME)/$(DIR)/generic.mk .

# update git repo {{{1
update:
	git submodule update --recursive
init:
	git submodule update --recursive --init
git-push:
	git push github master
