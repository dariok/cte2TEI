<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
  xmlns="http://www.tei-c.org/ns/1.0">
  
  <xsl:template match="/">
    <TEI>
      <teiHeader>
        
      </teiHeader>
      <text>
        <body>
          <xsl:apply-templates select="//*:Text" />
        </body>
      </text>
    </TEI>
  </xsl:template>
  
  <xsl:template match="*:Text">
    <xsl:for-each-group select="node()" group-ending-with="*:P">
      <p>
        <xsl:sequence select="current-group()" />
      </p>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>