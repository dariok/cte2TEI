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
  
  <xsl:template match="tei:titleStmt">
    <titleStmt>
      <xsl:for-each-group select="tei:title/node()" group-ending-with="tei:milestone">
        <xsl:text>
        </xsl:text>
        <title>
          <xsl:apply-templates select="current-group()[not(position() eq last())]" />
        </title>
      </xsl:for-each-group>
    </titleStmt>
  </xsl:template>
  
  <xsl:template match="*:HeaderFooter" />
  
  <xsl:template match="*:Format" />
  <xsl:template match="*:Format/*">
    <xsl:if test="preceding-sibling::*">
      <xsl:text>
        </xsl:text>
    </xsl:if>
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
    <xsl:text>
    </xsl:text>
    <body>
      <xsl:for-each-group select="node()" group-ending-with="tei:milestone[@type eq 'subdivision-ends']">
        <xsl:text>
      </xsl:text>
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