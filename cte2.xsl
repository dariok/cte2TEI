<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  
  <xsl:output omit-xml-declaration="1" /> 
  
  <xsl:template match="*:end" />
  
  <xsl:template match="*:F[*:P]">
    <!-- P is always before \n; as \n is turned into *:end, there is a max of one P in F -->
    <F xmlns="">
      <xsl:sequence select="@*" />
      <xsl:sequence select="node()[not(self::*:P)]" />
    </F>
    <xsl:apply-templates select="node()[self::*:P]" />
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>