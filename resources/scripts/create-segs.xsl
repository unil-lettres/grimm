<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="s">
        <xsl:variable name="precedingAnchor" select="preceding-sibling::*[1][name() eq 'anchor']"/>
        <xsl:variable name="nextAnchor" select="$precedingAnchor/following::anchor[1]"/>
           <xsl:choose>
               <xsl:when test="$precedingAnchor">
                   <xsl:element name="seg">
                       <xsl:if test="$precedingAnchor/@xml:id">
                           <xsl:attribute name="xml:id" select="$precedingAnchor/@xml:id"></xsl:attribute>
                       </xsl:if>
                       <xsl:if test="$precedingAnchor/@corresp">
                           <xsl:attribute name="corresp" select="$precedingAnchor/@corresp"></xsl:attribute>
                       </xsl:if>
                       <xsl:apply-templates select="descendant::node()[./following::anchor[. = $nextAnchor]]"/>
                   </xsl:element>
                   <xsl:apply-templates select="anchor"/>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:apply-templates select="anchor"/>
               </xsl:otherwise>
           </xsl:choose>
       <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="anchor[following-sibling::*[1][name() eq 's']]"/>
    <xsl:template match="anchor[not(following-sibling::*[1][name() eq 's'])]">
        <xsl:variable name="nextAnchor" select="./following::anchor[1]"/>
        <seg>
            <xsl:if test="@xml:id">
                <xsl:attribute name="xml:id" select="@xml:id"></xsl:attribute>
            </xsl:if>
            <xsl:if test="@corresp">
                <xsl:attribute name="corresp" select="@corresp"></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="descendant::node()[./following::anchor[. = $nextAnchor]]"/>            
        </seg>
    </xsl:template>
</xsl:stylesheet>