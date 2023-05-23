<xsl:stylesheet
  xmlns:xstring = "https://github.com/dariok/XStringUtils"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all"
  version="3.0">
   
   <xsl:import href="https://raw.githubusercontent.com/dariok/w2tei/master/string-pack.xsl"/>
   
   <xsl:param name="origFile" />
   
   <xsl:variable name="name" select="//*:SecondaryDocs/@name"/>
   
   <xsl:output omit-xml-declaration="1" />
   
   <xsl:template match="/">
      <xsl:if test="exists(//*:SecondaryDocs)">
         <xsl:processing-instruction name="cte-secondaryFile">
            <xsl:value-of select="//*:SecondaryDocs/@name => replace('\^s', ' ')"/>
         </xsl:processing-instruction>
      </xsl:if>
      <xsl:apply-templates />
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
  
  <xsl:template match="*:Notes1">
    <xsl:text>  </xsl:text>
    <Notes1>
      <xsl:for-each-group select="node()" group-starting-with="*:W">
        <xsl:text>
    </xsl:text>
        <xsl:if test="current-group() => string-join() => normalize-space()">
          <Note1>
            <xsl:apply-templates select="current-group()" />
          </Note1>
        </xsl:if>
      </xsl:for-each-group>
    </Notes1>
  </xsl:template>
  
  <xsl:template match="*:Apparatus1">
    <xsl:text>  </xsl:text>
    <Apparatus1>
      <xsl:for-each-group select="node()" group-starting-with="*:W">
        <xsl:text>
    </xsl:text>
        <App1>
          <xsl:apply-templates select="current-group()" />
        </App1>
      </xsl:for-each-group>
    </Apparatus1>
  </xsl:template>
  
   <xsl:template match="*:F[*:P]">
      <xsl:for-each-group select="node()" group-ending-with="*:P">
         <F>
            <xsl:apply-templates select="parent::*/@*" />
            <xsl:apply-templates select="current-group()[not(self::*:P)]" />
         </F>
         <xsl:apply-templates select="current-group()[self::*:P]" />
      </xsl:for-each-group>
   </xsl:template>
   
   <xsl:template match="*:Qs">
      <xsl:variable name="lfd">
         <xsl:number level="any" />
      </xsl:variable>
      <cell n="{$lfd}"  xmlns="http://www.tei-c.org/ns/1.0" />
      <xsl:sequence select="." />
   </xsl:template>
   
   <xsl:template match="*:Text//*:end">
      <xsl:choose>
         <xsl:when test="preceding-sibling::*[1][self::*:P]" />
         <xsl:otherwise>
            <lb xmlns="http://www.tei-c.org/ns/1.0" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
  
  <xsl:template match="@vals">
    <xsl:choose>
      <xsl:when test="starts-with(., 'P') and contains(., '|')">
        <xsl:attribute name="type" select="xstring:substring-before(., '|')" />
        <xsl:attribute name="vals" select="xstring:substring-after(., '|')" />
      </xsl:when>
      <xsl:when test="starts-with(., 'P')">
        <xsl:attribute name="type" select="." />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>