<xsl:stylesheet 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="tei:teiHeader">
    <xsl:text>
  </xsl:text>
    <teiHeader>
      <xsl:text>
    </xsl:text>
      <fileDesc>
        <xsl:text>
      </xsl:text>
        <titleStmt>
          <xsl:apply-templates select="//*:HeaderFooter/tei:ab" />
        </titleStmt>
      </fileDesc>
      <xsl:text>
    </xsl:text>
      <encodingDesc>
        <xsl:text>
      </xsl:text>
        <tagsDecl>
          <xsl:apply-templates select="//*:Format/*" />
          <xsl:text>
      </xsl:text>
        </tagsDecl>
      </encodingDesc>
    </teiHeader>
  </xsl:template>
  
  <xsl:template match="*:HeaderFooter" />
  <xsl:template match="*:HeaderFooter/tei:ab">
    <xsl:if test="normalize-space() != ''">
      <xsl:text>
        </xsl:text>
      <title>
        <xsl:apply-templates />
      </title>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*:Format" />
  <xsl:template match="*:Format/*">
    <xsl:text>
        </xsl:text>
    <rendition scheme="cte" xml:id="{translate(@name, ' ', '_')}">
      <xsl:value-of select="@def"/>
    </rendition>
  </xsl:template>
  
  <xsl:template match="tei:text//tei:ab[@type = '']">
    <xsl:text>
      </xsl:text>
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="tei:text">
    <text>
      <xsl:apply-templates />
      <back>
        <xsl:apply-templates select="*:Notes1" />
      </back>
    </text>
  </xsl:template>
  
  <xsl:template match="*:Notes1">
    <list type="notes1">
      <xsl:apply-templates />
    </list>
  </xsl:template>
  
  <xsl:template match="tei:note">
    <note xml:id="n{@n}">
      <xsl:apply-templates />
    </note>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>