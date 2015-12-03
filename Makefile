NAME=projekt
BIB=bibliography

all: pdf

pdf: $(NAME).tex $(BIB).bib
	pdflatex $<
	pdflatex $<
	bibtex $(NAME)
	pdflatex $<
	pdflatex $<

clean:
	rm -f $(NAME).{dvi,pdf,log,aux,ps,out,bbl,blg}
