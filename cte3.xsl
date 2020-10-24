<xsl:stylesheet 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
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
            <xsl:apply-templates select="//*:HeaderFooter/tei:ab[1]/node()" />
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
  
  <xsl:template match="*:Block">
    <xsl:variable name="type" select="substring-after(*:P[last()]/@type, 'P')"/>
    <ab>
      <xsl:attribute name="type">
        <xsl:value-of select="//*:pdef[@n = $type]/@name"/>
      </xsl:attribute>
      <xsl:apply-templates />
    </ab>
  </xsl:template>
  
  <xsl:template match="*:Z">
    <xsl:variable name="values" select="tokenize(., '\|')" />
    <ptr type="note" subtype="{$values[1]}" n="{$values[2]}" />
  </xsl:template>
  
  <xsl:template match="*[preceding-sibling::*:Text]">
    <xsl:copy>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="*:Note1">
    <note n="{normalize-space(*:W)}">
      <xsl:apply-templates select="*:W[1]/following-sibling::node()" />
    </note>
  </xsl:template>
  
  <xsl:template match="*:P">
    <milestone type="subdivision-ends" />
  </xsl:template>
  
  <xsl:template match="*:F">
    <xsl:variable name="styles">
      <xsl:for-each select="tokenize(@vals, '\|')">
        <xsl:choose>
          <xsl:when test=". = 'a0'" />
          <xsl:when test="matches(., 'P\d')" />
          <xsl:when test="matches(., 'g\d')">
            <xsl:variable name="num" select="substring(., 2)"/>
            <xsl:variable name="font" select="normalize-space($Fonts/*:Font[@num = $num]/@name)" />
            <xsl:value-of select="'font-family: ' || $font"/>
          </xsl:when>
          <xsl:when test=". = 'i+'">
            <xsl:text>font-style: italic</xsl:text>
          </xsl:when>
          <xsl:when test=". = 'k+'">
            <xsl:text>font-variant: smallCaps</xsl:text>
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
      <xsl:when test="string-length($rendition) gt 0 or string-length($styles) gt 0">
        <hi>
          <xsl:if test="string-length($styles) gt 0">
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
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>