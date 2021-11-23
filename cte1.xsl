<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="*:end" />
  
  <xsl:template match="*:Text">
    <Text xmlns="">
      <xsl:for-each-group select="node()" group-ending-with="*:P">
         <xsl:text>
            </xsl:text>
        <ab xmlns="http://www.tei-c.org/ns/1.0">
          <xsl:apply-templates select="current-group()" />
        </ab>
      </xsl:for-each-group>
    </Text>
  </xsl:template>
  
  <xsl:template match="*:HeaderFooter">
    <xsl:text>  </xsl:text>
    <HeaderFooter xmlns="">
      <xsl:for-each-group select="node()" group-ending-with="*:end">
        <xsl:text>
    </xsl:text>
        <ab xmlns="http://www.tei-c.org/ns/1.0">
          <xsl:apply-templates select="current-group()" />
        </ab>
      </xsl:for-each-group>
    </HeaderFooter>
  </xsl:template>
  
  <xsl:template match="*:Apparatus1 | *:Notes1 | *:Notes2">
    <xsl:if test="normalize-space() != ''">
      <xsl:copy>
        <xsl:apply-templates />
      </xsl:copy>
    </xsl:if>
  </xsl:template>
   
   <xsl:template match="*:C/@vals">
      <xsl:attribute name="vals" select=". || '|AC'" />
   </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>