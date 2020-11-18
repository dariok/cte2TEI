<xsl:stylesheet 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:output omit-xml-declaration="1" />
  
  <xsl:template match="tei:TEI">
    <TEI>
      <xsl:apply-templates select="tei:teiHeader" />
      <xsl:apply-templates select="tei:text" />
    </TEI>
  </xsl:template>
  
  <xsl:template match="tei:teiHeader" xml:space="preserve">
  <teiHeader>
    <fileDesc>
      <xsl:apply-templates select="tei:titleStmt" />
    </fileDesc>
    <encodingDesc>
      <tagsDecl>
        <xsl:apply-templates select="//*:Format/*" />
      </tagsDecl>
    </encodingDesc>
  </teiHeader>
  </xsl:template>
  
  <xsl:template match="*:HeaderFooter" />
  
  <xsl:template match="*:Format" />
  <xsl:template match="*:Format/*">
    <xsl:if test="preceding-sibling::*">
      <xsl:text>
        </xsl:text>
    </xsl:if>
    <rendition scheme="other" xml:id="{translate(@name, ' ', '_')}">
      <xsl:value-of select="@def"/>
    </rendition>
  </xsl:template>
  
  <xsl:template match="tei:text//tei:ab[@type = '']">
    <xsl:text>
      </xsl:text>
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="tei:text">
    <text>
      <xsl:apply-templates />
      <back>
        <xsl:apply-templates select="//*:Notes1 | //*:Apparatus1" />
      </back>
    </text>
  </xsl:template>
  
  <xsl:template match="*:Notes1 | *:Apparatus1">
    <list type="{lower-case(local-name())}">
      <xsl:apply-templates />
    </list>
  </xsl:template>
  
  <xsl:template match="tei:note">
    <note>
      <xsl:sequence select="@type" />
      <xsl:choose>
        <xsl:when test="@place">
          <xsl:apply-templates select="@place" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="xml:id">
            <xsl:choose>
              <xsl:when test="@type eq 'app1'">I</xsl:when>
              <xsl:otherwise>n</xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="@n" />
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates />
    </note>
  </xsl:template>
  
  <!-- Usage could not be ascertained -->
  <xsl:template match="*:S" />
  
  <!-- info should now be in ab -->
  <xsl:template match="*:P" />
  
  <!-- avoid empty-only hi -->
  <xsl:template match="tei:hi">
    <xsl:choose>
      <xsl:when test="normalize-space eq '' and not(preceding-sibling::node() or following-sibling::node())" />
      <xsl:otherwise>
        <hi>
          <xsl:apply-templates select="@* | node()" />
        </hi>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>