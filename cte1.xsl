<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
  
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
  
  <xsl:template match="*:Format">
    <xsl:text>
  </xsl:text>
    <Format>
      <xsl:apply-templates select="*" />
    </Format>
  </xsl:template>
  <xsl:template match="*:Format/*">
    <xsl:text>
    </xsl:text>
    <xsl:sequence select="." />
  </xsl:template>
  
  <xsl:template match="*:Fonts">
    <xsl:text>
  </xsl:text>
    <Fonts>
      <xsl:analyze-string select="." regex="(\d)\|([^\|]+)">
        <xsl:matching-substring>
          <xsl:text>
    </xsl:text>
          <Font num="{regex-group(1)}" name="{regex-group(2)}" />
        </xsl:matching-substring>
      </xsl:analyze-string>
    </Fonts>
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
  
  <xsl:template match="*:Notes1">
    <xsl:text>  </xsl:text>
    <Notes1>
      <xsl:for-each-group select="*" group-starting-with="*:W">
        <xsl:text>
    </xsl:text>
        <Note1>
          <xsl:sequence select="current-group()" />
        </Note1>
      </xsl:for-each-group>
    </Notes1>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>