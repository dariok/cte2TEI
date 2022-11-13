<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="*:ab[*:P]">
    <xsl:variable name="type" select="substring-after(*:P[@type][1]/@type, 'P')"/>
    <ab>
      <xsl:sequence select="*:P/@vals" />
      <xsl:if test="$type">
        <xsl:attribute name="type">
          <xsl:value-of select="//*:pdef[@n = $type]/@name"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates />
    </ab>
  </xsl:template>
  
  <xsl:template match="*:Z">
    <xsl:variable name="n" select="normalize-space(*:F)" />
    <xsl:variable name="subtype">
      <xsl:choose>
        <xsl:when test="matches($n, '\d+')">numeric</xsl:when>
        <xsl:when test="matches($n, '[a-z]+')">lowerAlpha</xsl:when>
        <xsl:when test="matches($n, '[A-Z]+')">upperAlpha</xsl:when>
        <xsl:otherwise>symbols</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="values" select="tokenize(substring-before(text(), '\'), '\|')" />
     <xsl:variable name="type">
        <xsl:choose>
           <xsl:when test="$values[1] = 'A1'">App1</xsl:when>
           <xsl:when test="$values[1] = 'N1'">Note1</xsl:when>
           <xsl:otherwise>
              <xsl:value-of select="$values[1]" />
           </xsl:otherwise>
        </xsl:choose>
     </xsl:variable>
    
    <ptr type="{$type}" subtype="{$subtype}" n="{$n}">
      <xsl:choose>
        <xsl:when test="$values = 'R' and $values[starts-with(., 'D')]">
          <xsl:attribute name="corresp" select="$values[starts-with(., 'D')]" />
        </xsl:when>
        <xsl:when test="$values[starts-with(., 'D')]">
          <xsl:attribute name="is" select="$values[starts-with(., 'D')]" />
        </xsl:when>
      </xsl:choose>
    </ptr>
  </xsl:template>
  
  <xsl:template match="*:Note1 | *:App1">
    <xsl:variable name="lname" select="lower-case(local-name())"/>
    <note type="{$lname}" n="{normalize-space(*:W)}" position="{count(preceding-sibling::*) + 1}">
      <xsl:apply-templates select="*:W[1]/following-sibling::node()" />
    </note>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>