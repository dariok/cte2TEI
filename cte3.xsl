<xsl:stylesheet
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:variable name="Fonts" select="//*:Fonts"/>
  
  <xsl:template match="*:cte">
    <TEI>
      <teiHeader>
        <titleStmt>
          <xsl:apply-templates select="//*:HeaderFooter/*:ab[string-length(normalize-space()) gt 0]" />
        </titleStmt>
      </teiHeader>
      <xsl:apply-templates />
    </TEI>
  </xsl:template>
  
  <xsl:template match="*:HeaderFooter/tei:ab">
    <title>
      <xsl:apply-templates />
    </title>
  </xsl:template>
  
  <xsl:template match="*:Text">
    <text>
      <body>
        <xsl:apply-templates />
      </body>
    </text>
  </xsl:template>
  
  <xsl:template match="*:F">
    <xsl:variable name="rendition">
      <xsl:if test="matches(@type, '^P\d+')">
        <xsl:variable name="num" select="substring(@type, 2)" />
        <xsl:value-of select="//*:fdef[@n = $num]/@name" />
      </xsl:if>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="string-length($rendition) gt 0 or @vals">
        <hi>
          <xsl:apply-templates select="@vals" />
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
  
  <xsl:template match="tei:ptr">
    <ptr>
      <xsl:sequence select="@*" />
      <xsl:if test="not(@corresp)">
        <xsl:variable name="subtype" select="@subtype" />
        <xsl:attribute name="position" select="count(preceding::tei:ptr[@subtype = $subtype and not(@corresp)]) + 1" />
      </xsl:if>
    </ptr>
  </xsl:template>
  
  <xsl:template match="@vals">
    <xsl:variable name="styles" as="xs:string*">
      <xsl:apply-templates select="." mode="eval" />
    </xsl:variable>
    <xsl:attribute name="style">
      <xsl:value-of select="string-join($styles, '; ') "/>
      <xsl:text>;</xsl:text>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="@vals" mode="eval">
    <xsl:for-each select="tokenize(., '\|')">
      <xsl:choose>
        <xsl:when test=". eq ''" />
        <xsl:when test="matches(., 'P\d')"/>
        <xsl:when test="matches(., 'g\d')">
          <xsl:variable name="num" select="substring(., 2)"/>
          <xsl:variable name="font" select="normalize-space($Fonts/*:Font[@num = $num]/@name)" />
          <xsl:value-of select="'font-family: ' || $font"/>
        </xsl:when>
        
        <!-- font variations -->
        <xsl:when test=". eq 'i+'">
          <xsl:text>font-style: italic</xsl:text>
        </xsl:when>
        <xsl:when test=". eq 'b+'">
          <xsl:text>font-weight: bold</xsl:text>
        </xsl:when>
        <xsl:when test=". eq 'k+'">
          <xsl:text>font-variant: smallCaps</xsl:text>
        </xsl:when>
        <xsl:when test=". eq 'u0'">
          <xsl:text>font-decoration: underline</xsl:text>
        </xsl:when>
        
        <!-- font size, line height, spacing, ... -->
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
        <xsl:when test="matches(., 'L\-?\d+')">
          <xsl:variable name="num">
            <xsl:analyze-string select="." regex="L-?(\d+)">
              <xsl:matching-substring>
                <xsl:value-of select="number(regex-group(1 )) div 10" />
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:variable>
          <xsl:value-of select="'line-height: ' || $num || 'pt'"/>
        </xsl:when>
        <xsl:when test=". eq 'c+'">
          <xsl:text>text-transform: uppercase</xsl:text>
        </xsl:when>
        
        <!-- margins -->
        <xsl:when test="substring(., 1, 2) eq 'SA'">
          <xsl:value-of select="'margin-bottom: ' || number(substring(., 3)) div 10 || 'pt'" />
        </xsl:when>
        <xsl:when test="substring(., 1, 2) eq 'SB'">
          <xsl:value-of select="'margin-top: ' || number(substring(., 3)) div 10 || 'pt'" />
        </xsl:when>
        <xsl:when test="substring(., 1, 2) eq 'ML'">
          <xsl:value-of select="'margin-left: ' || number(substring(., 3)) div 10 || 'pt'" />
        </xsl:when>
        
        <!-- positioning -->
        <xsl:when test="substring(., 1, 1) eq 'I'">
          <xsl:variable name="num">
            <xsl:analyze-string select="." regex="I(-?)(\d+)">
              <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)" />
                <xsl:value-of select="number(regex-group(2)) div 10" />
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:variable>
          <xsl:value-of select="'text-indent: ' || $num || 'pt'"/>
        </xsl:when>
        
        <!-- alignment -->
        <xsl:when test=". eq 'AB'">
          <xsl:text>text-align: justify</xsl:text>
        </xsl:when>
        <xsl:when test=". eq 'AC'">
          <xsl:text>text-align: center</xsl:text>
        </xsl:when>
        <xsl:when test=". eq 'AD'">
          <xsl:text>text-align: justify; text-align-last: center</xsl:text>
        </xsl:when>
        
        <!-- directives to be ignored for now -->
        <!-- TL: tab stops;
            RIS(B): unknown
            ROF: unknown
        -->
        <xsl:when test="substring(., 1, 1) = ('C', 'K', 'N')" />
        <xsl:when test="substring(., 1, 2) = ('TL', 'WO', 'WW')" />
        <xsl:when test="substring(., 1, 3) = ('RIS', 'RIU', 'ROF', 'ROU')" />
        
        <!-- fallback -->
        <xsl:otherwise>
          <xsl:sequence select="translate(., '+>', '')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>