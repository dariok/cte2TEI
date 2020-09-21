<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
  xmlns="http://www.tei-c.org/ns/1.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="*:Text">
    <xsl:text>  </xsl:text>
    <Text>
      <xsl:for-each-group select="descendant::node()" group-ending-with="*:P">
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
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>