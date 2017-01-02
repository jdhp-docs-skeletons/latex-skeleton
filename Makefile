include meta.make

###############################################################################

SUBDIRS = figs

SRCARTICLE=macros_common.tex\
		   macros.tex\
		   meta.tex\
		   bibliography.bib\
		   setup_package*.tex\
		   main.tex\
		   content/*.tex

SRCTIKZ=

.PHONY : all clean init pdf ps html jdhp publish $(SUBDIRS)

all: $(FILE_BASE_NAME).pdf


# SUBDIRS #####################################################################

$(SUBDIRS):
	$(MAKE) --directory=$@


## MAKE DOCUMENT ##############################################################

# HTML ############

html: $(FILE_BASE_NAME).html

$(FILE_BASE_NAME).html: $(SRCARTICLE) $(SRCTIKZ) $(SUBDIRS)
	hevea -fix -o $(FILE_BASE_NAME).html main.tex
	bibhva $(FILE_BASE_NAME)            # this is the name of the .aux file, not the .bib file !
	hevea -fix -o $(FILE_BASE_NAME).html main.tex

# PDF #############

pdf: $(FILE_BASE_NAME).pdf

$(FILE_BASE_NAME).pdf: $(SRCARTICLE) $(SRCTIKZ) $(SUBDIRS)
	pdflatex -jobname=$(FILE_BASE_NAME) main.tex
	bibtex $(FILE_BASE_NAME)            # this is the name of the .aux file, not the .bib file !
	pdflatex -jobname=$(FILE_BASE_NAME) main.tex
	pdflatex -jobname=$(FILE_BASE_NAME) main.tex

# PS ##############

#ps: $(FILE_BASE_NAME).ps
#
#$(FILE_BASE_NAME).ps: $(SRCARTICLE) $(SRCTIKZ) $(SUBDIRS)
#	latex -jobname=$(FILE_BASE_NAME) main.tex
#	bibtex $(FILE_BASE_NAME)            # this is the name of the .aux file, not the .bib file !
#	latex -jobname=$(FILE_BASE_NAME) main.tex
#	latex -jobname=$(FILE_BASE_NAME) main.tex
#	dvips $(FILE_BASE_NAME).dvi


# PUBLISH #####################################################################

publish: jdhp

jdhp: $(FILE_BASE_NAME).html $(FILE_BASE_NAME).pdf
	
	########
	# HTML #
	########
	
	# JDHP_DOCS_URI is a shell environment variable that contains the
	# destination URI of the HTML files.
	@if test -z $$JDHP_DOCS_URI ; then exit 1 ; fi
	
	# Copy HTML
	@rm -rf $(HTML_TMP_DIR)/
	@mkdir $(HTML_TMP_DIR)/
	cp -v $(FILE_BASE_NAME).html $(HTML_TMP_DIR)/
	cp -vr figs $(HTML_TMP_DIR)/
	rm -rf $(HTML_TMP_DIR)/figs/logos
	
	# Upload the HTML files
	rsync -r -v -e ssh $(HTML_TMP_DIR)/ ${JDHP_DOCS_URI}/$(FILE_BASE_NAME)/
	
	#######
	# PDF #
	#######
	
	# JDHP_DL_URI is a shell environment variable that contains the destination
	# URI of the PDF files.
	@if test -z $$JDHP_DL_URI ; then exit 1 ; fi
	
	# Upload the PDF file
	rsync -v -e ssh $(FILE_BASE_NAME).pdf ${JDHP_DL_URI}/pdf/


## CLEAN ######################################################################

clean:
	@echo "Remove generated files"
	@rm -f *.log *.aux *.dvi *.toc *.lot *.lof *.out *.nav *.snm *.bbl *.blg *.vrb
	@rm -f *.haux *.htoc *.hbbl $(FILE_BASE_NAME).image.tex
	@rm -rf $(HTML_TMP_DIR)
	$(MAKE) clean --directory=figs

init: clean
	@echo "Remove target files"
	@rm -f $(FILE_BASE_NAME).pdf
	@rm -f $(FILE_BASE_NAME).ps
	@rm -f $(FILE_BASE_NAME).html
