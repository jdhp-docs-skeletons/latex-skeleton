# LIST OF FILES TO MAKE #######################################################

# PUT HERE THE LIST OF FILES TO MAKE
# (E.G. "FILES_TO_MAKE = foo.png bar.svg baz.png")

FILES_TO_MAKE = 

###############################################################################

.PHONY: all clean

all: $(FILES_TO_MAKE)

# DESCRIBE HERE HOW TO MAKE EACH FILE #########################################

%.py.png: %.py
	python3 $<

%.py.svg: %.py
	python3 $<

# CLEAN #######################################################################

clean:
	@if [ -n "$(FILES_TO_MAKE)" ] ; then rm -v $(FILES_TO_MAKE) ; fi
