<xsl:stylesheet 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="*:cte">
    <TEI>
      <teiHeader>
        <titleStmt>
          <title>
            <xsl:apply-templates select="//*:HeaderFooter/tei:ab[1]/node()" />
          </title>
        </titleStmt>
      </teiHeader>
      <xsl:apply-templates />
    </TEI>
  </xsl:template>
  
  <xsl:template match="*:Text">
    <text>
      <body>
        <xsl:apply-templates select="*:Block" />
      </body>
    </text>
  </xsl:template>
  
  <xsl:template match="*:Block">
    <xsl:variable name="type" select="substring-after(*:P[last()]/@type, 'P')"/>
    <ab>
      <xsl:attribute name="type">
        <xsl:value-of select="//*:pdef[@n = $type]/@name"/>
      </xsl:attribute>
      <xsl:apply-templates />
    </ab>
  </xsl:template>
  
  <xsl:template match="*:Z">
    <xsl:variable name="values" select="tokenize(., '\|')" />
    <ptr type="note" subtype="{$values[1]}" n="{$values[2]}" />
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
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>