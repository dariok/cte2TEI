<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="tei:back" />
  
  <xsl:template match="tei:ptr[@type = 'note']">
    <xsl:variable name="num" select="substring(@n, 2)" />
    <xsl:variable name="note" select="substring(@subtype, 2)" />
    
    <xsl:choose>
      <xsl:when test="$note eq '1'">
        <xsl:sequence select="//tei:back/tei:list[@type = 'notes1']/tei:note[@xml:id = 'n' || $num]" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>