<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:xslthl="http://xslthl.sf.net"
                exclude-result-prefixes="xslthl">

<!-- Include basic AsciiDoc FOP formatting -->
<xsl:import href="file:///etc/asciidoc/docbook-xsl/fo.xsl"/>

<!-- My title pages -->
<xsl:import href="mytitlepages.xsl"/>

<xsl:param name="page.margin.inner">4.3cm</xsl:param>
<xsl:param name="page.margin.outer">2cm</xsl:param>
<xsl:param name="page.margin.top">2cm</xsl:param>
<xsl:param name="page.margin.bottom">2cm</xsl:param>

<xsl:attribute-set name="root.properties">
	<xsl:attribute name="widows">4</xsl:attribute>
	<xsl:attribute name="orphans">4</xsl:attribute>
	<xsl:attribute name="line-height">1.5</xsl:attribute>
	<xsl:attribute name="hyphenate">true</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="formal.title.properties">
	<xsl:attribute name="font-weight">normal</xsl:attribute>
	<xsl:attribute name="font-size">100%</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="component.title.properties">
	<xsl:attribute name="text-align">left</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="orderedlist.label.width">1.5em</xsl:param>

<xsl:param name="header.rule">0</xsl:param>
<xsl:param name="footer.rule">0</xsl:param>

<xsl:param name="generate.toc" select="'article toc,title,figure,table'"/>

<xsl:param name="local.l10n.xml" select="document('')"/>
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">
    <l:gentext key="TableofContents" text="Contents"/>
    <l:context name="title-numbered">
    	<l:template name="article/appendix" text="Appendix %n. %t"/>
    </l:context>
    <l:context name="xref-number-and-title">
	<l:template name="section" text="section %n, “%t”"/>
	<l:template name="figure" text="Figure %n"/>
    </l:context>
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

<xsl:template name="toc.line">
  <xsl:param name="toc-context" select="NOTANODE"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>

<!-- Appendices hack -->
 <xsl:if test="self::appendix">
  <fo:block xsl:use-attribute-sets="toc.line.properties">

    <fo:inline keep-with-next.within-line="always">
      <fo:basic-link internal-destination="{$id}">
       	<xsl:text>Appendices</xsl:text>
      </fo:basic-link>
    </fo:inline>

    <fo:inline keep-together.within-line="always">
      <xsl:text> </xsl:text>
      <fo:leader leader-pattern="dots"
                 leader-pattern-width="3pt"
                 leader-alignment="reference-area"
                 keep-with-next.within-line="always"/>
      <xsl:text> </xsl:text>
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </fo:inline>
  </fo:block>
 </xsl:if>

  <fo:block xsl:use-attribute-sets="toc.line.properties">
        <xsl:if test="self::appendix">
        	<xsl:attribute name="margin-{$direction.align.start}">
        		24pt
        	</xsl:attribute>
        </xsl:if>
    <fo:inline keep-with-next.within-line="always">
      <fo:basic-link internal-destination="{$id}">
        <xsl:if test="self::appendix">
        	<xsl:call-template name="gentext">
      			<xsl:with-param name="key" select="local-name()"/>
          	</xsl:call-template>
          	<xsl:text> </xsl:text>
        </xsl:if>


        <xsl:if test="$label != ''">
          <xsl:copy-of select="$label"/>
          <xsl:value-of select="$autotoc.label.separator"/>
        </xsl:if>
        <xsl:apply-templates select="." mode="titleabbrev.markup"/>
      </fo:basic-link>
    </fo:inline>
    <fo:inline keep-together.within-line="always">
      <xsl:text> </xsl:text>
      <fo:leader leader-pattern="dots"
                 leader-pattern-width="3pt"
                 leader-alignment="reference-area"
                 keep-with-next.within-line="always"/>
      <xsl:text> </xsl:text>
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </fo:inline>
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

<xsl:template match="footnote/para[1]
                     |footnote/simpara[1]
                     |footnote/formalpara[1]"
              priority="2">
  <!-- this only works if the first thing in a footnote is a para, -->
  <!-- which is ok, because it usually is. -->
  <fo:block>
    <xsl:call-template name="format.footnote.mark">
      <xsl:with-param name="mark">
        <xsl:apply-templates select="ancestor::footnote" mode="footnote.number"/>
      </xsl:with-param>
    </xsl:call-template>
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

<xsl:template name="make-glossary">
  <xsl:param name="divs" select="glossdiv"/>
  <xsl:param name="entries" select="glossentry"/>
  <xsl:param name="preamble" select="*[not(self::title
                                           or self::subtitle
                                           or self::glossdiv
                                           or self::glossentry)]"/>


  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="presentation">
    <xsl:call-template name="pi.dbfo_glossary-presentation"/>
  </xsl:variable>

  <xsl:variable name="term-width">
    <xsl:call-template name="pi.dbfo_glossterm-width"/>
  </xsl:variable>

  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="$term-width = ''">
        <xsl:value-of select="$glossterm.width"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$term-width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <fo:block id="{$id}">
    <xsl:call-template name="glossary.titlepage"/>
  </fo:block>

  <xsl:if test="$preamble">
    <xsl:apply-templates select="$preamble"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$presentation = 'list'">
      <xsl:apply-templates select="$divs" mode="glossary.as.list">
        <xsl:with-param name="width" select="$width"/>
      </xsl:apply-templates>
      <xsl:if test="$entries">
        <fo:list-block provisional-distance-between-starts="{$width}"
                       provisional-label-separation="{$glossterm.separation}"
                       xsl:use-attribute-sets="normal.para.spacing"
                       break-after="page">
              <xsl:apply-templates select="$entries" mode="glossary.as.list"/>
        </fo:list-block>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$presentation = 'blocks'">
      <xsl:apply-templates select="$divs" mode="glossary.as.blocks"/>
          <xsl:apply-templates select="$entries" mode="glossary.as.blocks"/>
    </xsl:when>
    <xsl:when test="$glossary.as.blocks != 0">
      <xsl:apply-templates select="$divs" mode="glossary.as.blocks"/>
          <xsl:apply-templates select="$entries" mode="glossary.as.blocks"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$divs" mode="glossary.as.list">
        <xsl:with-param name="width" select="$width"/>
      </xsl:apply-templates>
      <xsl:if test="$entries">
        <fo:list-block provisional-distance-between-starts="{$width}"
                       provisional-label-separation="{$glossterm.separation}"
                       xsl:use-attribute-sets="normal.para.spacing"
                       break-after="page">
              <xsl:apply-templates select="$entries" mode="glossary.as.list"/>
        </fo:list-block>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="article/appendix">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>

  <xsl:variable name="titleabbrev">
    <xsl:apply-templates select="." mode="titleabbrev.markup"/>
  </xsl:variable>

  <fo:block id='{$id}' break-before="page">
    <fo:block xsl:use-attribute-sets="article.appendix.title.properties">
      <fo:marker marker-class-name="section.head.marker">
        <xsl:choose>
          <xsl:when test="$titleabbrev = ''">
            <xsl:value-of select="$title"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$titleabbrev"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:marker>
      <xsl:copy-of select="$title"/>
    </fo:block>

    <xsl:call-template name="make.component.tocs"/>

    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:attribute-set name="monospace.verbatim.properties">
	<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
