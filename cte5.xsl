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
  
  <xsl:template match="tei:hi">
    <xsl:variable name="rend" select="@rend" />
    <xsl:choose>
      <xsl:when test="preceding-sibling::node()[1][not(@rend)] and following-sibling::node()[1][@rend = $rend]">
        <hi>
          <xsl:sequence select="@rend" />
          <xsl:sequence select="node()" />
          <xsl:choose>
            <xsl:when test="following-sibling::node()[not(@rend = $rend)]">
              <xsl:sequence select="(following-sibling::* 
                intersect following-sibling::node()[not(@rend = $rend)][1]/preceding-sibling::*)/node()" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="following-sibling::*/node()" />
            </xsl:otherwise>
          </xsl:choose>
        </hi>
      </xsl:when>
      <xsl:when test="preceding-sibling::node()[1][@rend = $rend] or following-sibling::node()[1][@rend = $rend]" />
      <xsl:otherwise>
        <xsl:sequence select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- remove white space at beginning of ab -->
  <xsl:template match="tei:ab/text()[not(preceding-sibling::node())]">
    <xsl:choose>
      <xsl:when test="starts-with(., '&#x0A;')">
        <xsl:value-of select="substring(., 2)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:ab">
    <xsl:text>
      </xsl:text>
    <ab>
      <xsl:apply-templates select="@* | node()" />
    </ab>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>