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
  
  <xsl:template match="tei:ptr[@type = 'note']">
    <xsl:variable name="num" select="substring(@n, 2)" />
    <xsl:variable name="note" select="substring(@subtype, 1, 1)" />
    
    <xsl:choose>
      <xsl:when test="$note eq 'N'">
        <xsl:sequence select="//tei:back/tei:list[@type = 'notes1']/tei:note[@xml:id = 'n' || $num]" />
      </xsl:when>
      <xsl:when test="$note eq 'A'">
        <xsl:sequence select="//tei:back/tei:list[@type = 'apparatus1']/tei:note[@xml:id = 'I' || $num]" />
      </xsl:when>
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
      <xsl:apply-templates select="@*" />
      <xsl:for-each-group select="node()" group-adjacent="@rend || 't'">
        <xsl:choose>
          <xsl:when test="current-group()[self::tei:hi]">
            <hi>
              <xsl:sequence select="current-group()[1]/@rend" />
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
  
  <xsl:template match="*[not(namespace-uri() = 'http://www.tei-c.org/ns/1.0')]">
    <xsl:message>unhandled element: <xsl:value-of select="local-name()"/></xsl:message>
    <xsl:sequence select="." />
  </xsl:template>
  
  <xsl:template match="@vals">
    <xsl:variable name="values" as="xs:string*">
      <xsl:for-each select="tokenize(., '\|')">
        <xsl:choose>
          <xsl:when test="substring(., 1, 2) = ('SA', 'SB')">
            <xsl:analyze-string select="." regex="(\d+)">
              <xsl:matching-substring>
                <xsl:choose>
                  <xsl:when test="substring(., 1, 2) eq 'SA'">
                    <xsl:value-of select="'margin-bottom: ' || number(regex-group(1)) div 10 || 'pt'" />
                  </xsl:when>
                  <xsl:when test="substring(., 1, 2) eq 'SB'">
                    <xsl:value-of select="'margin-top: ' || number(regex-group(1)) div 10 || 'pt'" />
                  </xsl:when>
                </xsl:choose>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:when>
          <xsl:when test=". eq 'AC'">
            <xsl:text>text-align: center</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:if test="count($values) gt 0">
      <xsl:attribute name="rend" select="string-join($values, '; ')" />
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>