NAME=projekt
BIB=bibliography

ZIP_NAME=374115
DIR_NAME=zaklady-ekonometrie-ZAEK

all: pdf

pdf: $(NAME).tex $(BIB).bib
	pdflatex $<
	pdflatex $<
	bibtex $(NAME)
	pdflatex $<
	pdflatex $<

clean:
	rm -f $(NAME).{dvi,log,aux,ps,out,bbl,blg}

zip: pdf clean
	zip -r ./$(ZIP_NAME).zip ../$(DIR_NAME) -x \
		 '*/$(ZIP_NAME).zip' '*/.git/*' '*/.gitignore' '*/README.md'
