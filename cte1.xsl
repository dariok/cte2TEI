<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="*:Text">
    <Text>
      <xsl:for-each-group select="node()" group-ending-with="*:end">
        <xsl:text>
    </xsl:text>
        <ab>
          <xsl:sequence select="current-group()" />
        </ab>
      </xsl:for-each-group>
    </Text>
  </xsl:template>
  
  <xsl:template match="*:HeaderFooter">
    <xsl:text>  </xsl:text>
    <HeaderFooter>
      <xsl:for-each-group select="node()" group-ending-with="*:end">
        <xsl:text>
    </xsl:text>
        <ab>
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
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>