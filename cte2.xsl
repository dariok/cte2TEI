<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="*:ab[*:P]">
    <xsl:variable name="type" select="substring-after(*:P/@type, 'P')"/>
    <ab>
      <xsl:if test="$type">
        <xsl:attribute name="style">
          <xsl:value-of select="//*:pdef[@n = $type]/@name"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates />
    </ab>
  </xsl:template>
  
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