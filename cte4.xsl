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
  
  <xsl:template match="tei:teiHeader">
    <xsl:text>
  </xsl:text>
    <teiHeader>
      <xsl:text>
    </xsl:text>
      <fileDesc>
        <xsl:text>
      </xsl:text>
        <xsl:apply-templates select="tei:titleStmt" />
      </fileDesc>
      <xsl:text>
    </xsl:text>
      <encodingDesc>
        <xsl:text>
      </xsl:text>
        <tagsDecl>
          <xsl:apply-templates select="//*:Format/*" />
          <xsl:text>
      </xsl:text>
        </tagsDecl>
      </encodingDesc>
    </teiHeader>
  </xsl:template>
  
  <xsl:template match="*:HeaderFooter" />
  <xsl:template match="tei:title">
    <xsl:for-each-group select="node()" group-ending-with="tei:milestone">
      <title>
        <xsl:apply-templates select="current-group()[not(position() eq last())]" />
      </title>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="*:Format" />
  <xsl:template match="*:Format/*">
    <xsl:text>
        </xsl:text>
    <rendition scheme="cte" xml:id="{translate(@name, ' ', '_')}">
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
        <xsl:apply-templates select="//*:Notes1" />
      </back>
    </text>
  </xsl:template>
  
  <xsl:template match="*:Notes1">
    <list type="notes1">
      <xsl:apply-templates />
    </list>
  </xsl:template>
  
  <xsl:template match="tei:note">
    <note>
      <xsl:choose>
        <xsl:when test="@place">
          <xsl:apply-templates select="@place" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="xml:id" select="'n' || @n" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates />
    </note>
  </xsl:template>
  
  <!-- remove white space a start/end of notes -->
  <xsl:template match="tei:note/node()[not(preceding-sibling::node()) and following-sibling::node()]">
    <xsl:choose>
      <xsl:when test="starts-with(.,  ' ') or starts-with(., '&#x2002;')">
        <xsl:value-of select="substring(., 2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="."></xsl:sequence>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:note/node()[not(following-sibling::node()) and preceding-sibling::node()]">
    <xsl:choose>
      <xsl:when test="matches(., '\s$')">
        <xsl:value-of select="substring(., 1, string-length(.) - 1)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:note[count(node()) = 1]/node()">
    <xsl:value-of select="normalize-space(translate(., '&#x2002;', ''))" />
  </xsl:template>
  <!-- END remove white space -->
  
  <!-- Usage could not be ascertained -->
  <xsl:template match="*:S" />
  
  <!-- create p, head by grouping milestones (from cte:P) -->
  <xsl:template match="tei:body">
    <body>
      <xsl:for-each-group select="node()" group-ending-with="tei:milestone[@type eq 'subdivision-ends']">
        <ab>
          <xsl:if test="current-group()[position() eq last()]/@style">
            <xsl:attribute name="type" select="current-group()[position() eq last()]/@style" />
          </xsl:if>
          <xsl:sequence select="current-group()[last()]/@vals" />
          <xsl:apply-templates select="current-group()[not(position() eq last())]" />
        </ab>
      </xsl:for-each-group>
    </body>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>