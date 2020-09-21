<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
  xmlns="http://www.tei-c.org/ns/1.0">
  
  <xsl:output omit-xml-declaration="1" indent="1" />
  
  <xsl:template match="*:cte">
    <TEI>
      <standOff>
        <xsl:apply-templates select="*:Text/following-sibling::*" />
      </standOff>
      <xsl:apply-templates select="*:Text" />
    </TEI>
  </xsl:template>
  
  <xsl:template match="*:Text">
<!--    <xsl:text>-->
  <!--</xsl:text>-->
    <text>
      <body>
        <xsl:apply-templates select="*:Block" />
      </body>
    </text>
  </xsl:template>
  
  <xsl:template match="*:Block">
<!--    <xsl:text>-->
    <!--</xsl:text>-->
    <xsl:variable name="number" select="substring-before(substring-after(*:P[last()]/@vals, 'P'), '|')"/>
    <ab>
      <xsl:attribute name="type">
        <xsl:value-of select="//*:pdef[@n = $number]/@name"/>
      </xsl:attribute>
      <xsl:apply-templates />
    </ab>
  </xsl:template>
  
  <xsl:template match="*:Z">
    <xsl:variable name="target" select="substring-before(substring-after(., 'N'), '|')"/>
    <ptr type="note" target="#{$target}" />
  </xsl:template>
  
  <xsl:template match="*[preceding-sibling::*:Text]">
    <xsl:copy>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="*:Note1">
    <note n="{normalize-space(*:W)}">
      <xsl:apply-templates select="*:W[1]/following-sibling::node()" />
    </note>
  </xsl:template>
</xsl:stylesheet>