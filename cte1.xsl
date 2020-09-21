<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="*:Text">
    <xsl:for-each-group select="node()" group-ending-with="*:P">
      <abc>
        <xsl:apply-templates select="current-group()" />
      </abc>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="*:Format">
    <xsl:text>
  </xsl:text>
    <Format>
      <xsl:apply-templates select="*" />
    </Format>
  </xsl:template>
  <xsl:template match="*:Format/*">
    <xsl:text>
    </xsl:text>
    <xsl:sequence select="." />
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>