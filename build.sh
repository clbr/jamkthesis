#!/bin/sh -e

a2x -f pdf --fop --fop-opts="-dpi 300" -L \
	--xsl-file='fop.xsl' -k \
	--xsltproc-opts='--stringparam body.start.indent 0pt' \
	thesis.asciidoc

mv thesis.pdf tmpy
gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
	-dCompatibilityLevel=1.3 \
	-dPDFSETTINGS=/prepress \
	-o thesis.pdf tmpy

rm tmpy
