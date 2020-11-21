<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="tei:back" />
  
  <xsl:template match="tei:ab">
    <ab>
      <xsl:apply-templates select="@*" />
      <xsl:for-each-group select="node()" group-adjacent="@tylse || 't'">
        <xsl:choose>
          <xsl:when test="current-group()[self::tei:hi]">
            <hi>
              <xsl:sequence select="current-group()[1]/@style" />
              <xsl:apply-templates select="current-group()/node()" />
            </hi>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="current-group()" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </ab>
  </xsl:template>
  
  <!-- replace ptr/@corresp by correct value the target’s xml:id -->
  <xsl:template match="tei:ptr[@corresp]">
    <xsl:variable name="partner" select="@corresp" />
    <ptr type="{@type}" corresp="#{preceding-sibling::tei:note[@is = $partner]/@xml:id}" />
  </xsl:template>
  <xsl:template match="@is" />
  
  <!-- for now, ignore {Q\...\Q} -->
  <xsl:template match="*:Qs | *:Qe
    | node()[preceding-sibling::node()[1][self::*:Qs] and following-sibling::node()[1][self::*:Qe]]" />
  
  <!-- for now, ignore R -->
  <xsl:template match="*:R" />
  
  <xsl:template match="*[not(namespace-uri() = 'http://www.tei-c.org/ns/1.0')
    and not(local-name() = ('Qs', 'Qe', 'R'))]">
    <xsl:message>unhandled element: <xsl:value-of select="local-name()"/></xsl:message>
    <xsl:sequence select="." />
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>