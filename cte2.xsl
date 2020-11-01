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
  
  <xsl:template match="*:P">
    <xsl:variable name="type" select="substring-after(@type, 'P')"/>
    <milestone type="subdivision-ends">
      <xsl:if test="$type">
        <xsl:attribute name="style">
          <xsl:value-of select="//*:pdef[@n = $type]/@name"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:sequence select="@vals" />
    </milestone>
  </xsl:template>
  
  <xsl:template match="*:F[*:P]">
    <xsl:variable name="vals" select="@vals" />
    <xsl:for-each-group select="node()" group-ending-with="*:P">
      <F xmlns="">
        <xsl:sequence select="$vals" />
        <xsl:sequence select="current-group()[not(self::*:P)]" />
      </F>
      <xsl:apply-templates select="current-group()[self::*:P]" />
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>