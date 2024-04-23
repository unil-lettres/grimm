<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="type" select="if(/TEI/@xml:id = substring(/TEI/@corresp, 2)) then 'base' else 'version'"/>
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="anchor">
                <p>
                    <xsl:apply-templates select="anchor"/>
                </p>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="anchor">
        <xsl:variable name="p" select="ancestor::p"/>
        <xsl:variable name="nextAnchor" select="following::anchor[1]"/>
        <xsl:variable name="nextAnchorSibling" select="following::anchor[1][ancestor::p = $p]"/>
        <xsl:variable name="pBoundary" select="
                if (current()[last()]) then
                    true()
                else
                    false()"/>
        <seg>
            <xsl:if test="@corresp">
                <xsl:attribute name="corresp" select="current()/@corresp"/>
            </xsl:if>
            <xsl:if test="@xml:id">
                <xsl:attribute name="xml:id" select="current()/@xml:id"/>
            </xsl:if>
            <xsl:if test="$type eq 'base'">
                <xsl:attribute name="type" select="$type"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$nextAnchorSibling">
                    <xsl:apply-templates
                        select="following::node()[parent::s] except following::anchor[. = $nextAnchorSibling]/following::node()"
                    />
                </xsl:when>
                <xsl:when test="$pBoundary">
                    <!-- When we process an anchor who is the last one in a paragraph, first we get the contents until the end of the paragraph-->
                    <xsl:apply-templates select="following::node()[parent::s][ancestor::p = $p]"/>

                    <xsl:choose>
                        <xsl:when test="$nextAnchor">
                            <!-- Then, if the next anchor is the first child of the following paragraph, we do nothing-->
                            <xsl:choose>
                                <xsl:when
                                    test="$p/following-sibling::p[1]/child::*[1][. = $nextAnchor]"/>
                                <!-- If there are some sentences from the following paragraph who belong with this segment, we create 
                        a seg element with @type in order to try to get the correct display via ODD-->
                                <xsl:otherwise>
                                    <s type="nextParagraph">
                                        <xsl:apply-templates
                                            select="$p/following-sibling::p[1]/s[preceding-sibling::anchor[. = $nextAnchor]]"
                                        />
                                    </s>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- If there is no $nextAnchor, it means we need to get all the paragraphs until the end of the document inside this seg.
                            We create a element <seg> to avoid having a <p> inside a <p> -->
                            <xsl:for-each select="$p/following-sibling::p">
                                <ab type="paragraph">
                                    <xsl:apply-templates select="s/node()"/>
                                </ab>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </seg>
    </xsl:template>
    <xsl:template match="s"/>
    <xsl:template match="text()[last()]">
        <xsl:value-of select="current()"/><xsl:text> </xsl:text>
    </xsl:template>
</xsl:stylesheet>
