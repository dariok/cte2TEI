<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  
  <xsl:output omit-xml-declaration="1" /> 
  
  <xsl:template match="*:end" />
  
  <xsl:template match="*:Z">
    <xsl:variable name="attributes" as="attribute()*">
      <xsl:for-each select="tokenize(., '\|')">
        <xsl:choose>
          <xsl:when test="starts-with(., 'A')">
            <xsl:attribute name="subtype" select="." />
          </xsl:when>
          <xsl:when test="starts-with(., 'D')">
            <xsl:attribute name="target" select="'#' || ." />
          </xsl:when>
          <xsl:when test="starts-with(., 'I')">
            <xsl:attribute name="n" select="." />
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <ptr type="note">
      <xsl:sequence select="$attributes" />
    </ptr>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>