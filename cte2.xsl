<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="*:Text">
    <xsl:text>  </xsl:text>
    <Text>
      <xsl:for-each-group select="node()" group-ending-with="*:P">
        <xsl:text>
    </xsl:text>
        <Block>
          <xsl:apply-templates select="current-group()" />
        </Block>
      </xsl:for-each-group>
    </Text>
  </xsl:template>
  
  <xsl:template match="*:HeaderFooter">
    <xsl:text>  </xsl:text>
    <HeaderFooter>
      <xsl:for-each-group select="node()" group-ending-with="*:P">
        <xsl:text>
    </xsl:text>
        <Block>
          <xsl:apply-templates select="current-group()" />
        </Block>
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
  
  <xsl:template match="*:P/@vals">
    <xsl:choose>
      <xsl:when test="starts-with(., 'P')">
        <xsl:attribute name="type" select="substring-before(., '|')" />
        <xsl:attribute name="vals" select="substring-after(., '|')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*:F">
    <xsl:copy>
      <xsl:for-each select="tokenize(@vals, '\|')">
        <xsl:if test="normalize-space(translate(., '+>', '')) != ''">
          <xsl:variable name="values" as="xs:string*">
            <xsl:choose>
              <xsl:when test="matches(., 'g\d')">
                <xsl:sequence select="('font', substring-after(., 'g'))" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="(translate(., '+>', ''), .)" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:attribute name="{$values[1]}" select="$values[2]" />
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>