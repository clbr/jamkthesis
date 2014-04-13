<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:xslthl="http://xslthl.sf.net"
                exclude-result-prefixes="xslthl">

<!-- Include basic AsciiDoc FOP formatting -->
<xsl:import href="file:///etc/asciidoc/docbook-xsl/fo.xsl"/>

<!-- My title pages -->
<xsl:import href="mytitlepages.xsl"/>

<xsl:attribute-set name="root.properties">
	<xsl:attribute name="widows">4</xsl:attribute>
	<xsl:attribute name="orphans">4</xsl:attribute>
	<xsl:attribute name="line-height">1.5</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="formal.title.properties">
	<xsl:attribute name="font-weight">normal</xsl:attribute>
	<xsl:attribute name="font-size">normal</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="orderedlist.label.width">1.5em</xsl:param>

<xsl:param name="header.rule">0</xsl:param>
<xsl:param name="footer.rule">0</xsl:param>

<xsl:param name="generate.toc" select="'article toc,title,figure,table'"/>

<xsl:param name="local.l10n.xml" select="document('')"/>
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">
    <l:gentext key="TableofContents" text="Contents"/>
  </l:l10n>
</l:i18n>

<xsl:param name="formal.title.placement">
figure after
example before
equation after
table before
procedure before
</xsl:param>

<xsl:template name="footer.content">
</xsl:template>

<xsl:template name="header.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <fo:block>
    <!-- pageclass can be front, body, back -->
    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>
      <xsl:when test="$pageclass = 'titlepage'">
        <!-- nop; no header on title pages -->
      </xsl:when>

      <xsl:when test="$position='right'">
        <fo:page-number/>
      </xsl:when>

      <xsl:otherwise>
        <!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template match="simpara">
  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>
  <fo:block xsl:use-attribute-sets="normal.para.spacing">
      <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

  <!-- 1.2 section -->
  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.36"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <!-- 1.2.3 section -->
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <!-- 1.2.3.4 section -->
  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.1"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

<xsl:attribute-set name="monospace.verbatim.properties">
	<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
