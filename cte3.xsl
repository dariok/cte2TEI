<xsl:stylesheet
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:variable name="Fonts" select="//*:Fonts"/>
  
  <xsl:template match="*:cte">
    <TEI>
      <teiHeader>
        <titleStmt>
          <title>
            <xsl:apply-templates select="//*:HeaderFooter/*:Block[1]/node()[not(self::*:P)]" />
          </title>
        </titleStmt>
      </teiHeader>
      <xsl:apply-templates />
    </TEI>
  </xsl:template>
  
  <xsl:template match="*:Text">
    <text>
      <body>
        <xsl:apply-templates select="*:Block" />
      </body>
    </text>
  </xsl:template>
  
  <xsl:template match="*:Note1">
    <note n="{normalize-space(*:W)}">
      <xsl:apply-templates select="*:W[1]/following-sibling::node()" />
    </note>
  </xsl:template>
  
  <xsl:template match="*:App1">
    <note type="app1" n="{count(preceding-sibling::*) + 1}">
      <xsl:apply-templates select="*:W[1]/following-sibling::node()" />
    </note>
  </xsl:template>
  
  <xsl:template match="*:F">
    <xsl:variable name="styles" as="xs:string*">
      <xsl:for-each select="tokenize(@vals, '\|')">
        <xsl:choose>
          <xsl:when test=". eq 'a0'" />
          <xsl:when test="matches(., 'P\d')"/>
          <xsl:when test="matches(., 'g\d')">
            <xsl:variable name="num" select="substring(., 2)"/>
            <xsl:variable name="font" select="normalize-space($Fonts/*:Font[@num = $num]/@name)" />
            <xsl:value-of select="'font-family: ' || $font"/>
          </xsl:when>
          <xsl:when test=". eq 'i+'">
            <xsl:text>font-style: italic</xsl:text>
          </xsl:when>
          <xsl:when test=". eq 'b+'">
            <xsl:text>font-weight: bold</xsl:text>
          </xsl:when>
          <xsl:when test=". eq 'k+'">
            <xsl:text>font-variant: smallCaps</xsl:text>
          </xsl:when>
          <xsl:when test="matches(., 's\d+')">
            <xsl:variable name="num" select="number(substring(., 2)) div 10" />
            <xsl:value-of select="'font-size: ' || $num || 'pt'" />
          </xsl:when>
          <xsl:when test="matches(., 'w\-?\d+')">
            <xsl:variable name="num">
              <xsl:analyze-string select="." regex="w(-?)(\d+)">
                <xsl:matching-substring>
                  <xsl:value-of select="regex-group(1)" />
                  <xsl:value-of select="number(regex-group(2)) div 10" />
                </xsl:matching-substring>
              </xsl:analyze-string>
            </xsl:variable>
            <xsl:value-of select="'letter-spacing: ' || $num || 'pt'"/>
          </xsl:when>
          <xsl:when test=". eq 'c+'">
            <xsl:text>text-transform: uppercase</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="translate(., '+>', '')" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="rendition">
      <xsl:if test="matches(@vals, '^P\d+')">
        <xsl:variable name="num" select="substring-before(substring(@vals, 2), '|')" />
        <xsl:value-of select="//*:fdef[@n = $num]/@name" />
      </xsl:if>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="string-length($rendition) gt 0 or count($styles) gt 0">
        <hi>
          <xsl:if test="count($styles) gt 0">
            <xsl:attribute name="rend" select="string-join($styles, '; ') || ';'" />
          </xsl:if>
          <xsl:if test="string-length($rendition) gt 0">
            <xsl:attribute name="rendition" select="'#' || $rendition" />
          </xsl:if>
          <xsl:apply-templates />
        </hi>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- O = outer margin (I = inner margin) ? -->
  <xsl:template match="*:O">
    <note place="outer-margin">
      <xsl:apply-templates />
    </note>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>