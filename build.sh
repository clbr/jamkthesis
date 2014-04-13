#!/bin/sh -e

xsltproc -o mytitlepages.xsl titlepage.templates.xsl titlepage.templates.xml

a2x -f pdf --fop --fop-opts="-dpi 300" -L \
	--xsl-file='fop.xsl' -k \
	--xsltproc-opts='--stringparam body.start.indent 0pt' \
	-a compact-option \
	thesis.asciidoc

mv thesis.pdf tmpy
gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
	-dCompatibilityLevel=1.3 \
	-dPDFSETTINGS=/prepress \
	-o thesis.pdf cover.pdf abstracten.pdf abstractfi.pdf tmpy pdfmarks

rm tmpy
