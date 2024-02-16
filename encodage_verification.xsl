<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding="UTF-8"
        doctype-public="-//W3C/DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:template match="/">
        <xsl:variable name="fichier" select="substring-before(./document-uri(), '.')"/>
        <xsl:result-document href="{$fichier}_verification.html">
            <html>
                <head>
                    <title><xsl:value-of select="$fichier"/>_<xsl:value-of
                            select="replace(substring-before(string(current-date()), '+'), '-', '')"
                        /></title>
                    <link rel="stylesheet" href="BoiteAOutils/encodage_verification.css"/>
                </head>
                <body>
                    <h1><xsl:value-of select="$fichier"/> - Vérification - <xsl:value-of
                            select="current-date()"/> (depuis la version 2 de la feuille de style de
                        vérification)</h1>
                        <xsl:choose>
                            <xsl:when test="//tei:body/tei:listOrg and count(//tei:body/*) = 1">
                                <xsl:apply-templates select="//tei:body/tei:listOrg"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <h2>Vérifier que la balise tei:body ne contient rien, au premier
                                    niveau, qu'une balise tei:listOrg</h2>
                            </xsl:otherwise>
                        </xsl:choose>
                    
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="tei:listOrg | tei:org">
        <xsl:variable name="name" select="./name()"/>
        <xsl:if test="$name='org'">
            <xsl:choose>
                <xsl:when test="./@n">
                    <h5 class="n">@n : <xsl:value-of select="./@n"/></h5>
                </xsl:when>
                <xsl:otherwise><h5 class="n" style="color:red">@n manquant</h5></xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <div class="{$name}">
            <xsl:for-each select="./(*|comment())">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="tei:orgName">
        <xsl:for-each select="./*|text()">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>
    
   <xsl:template match="tei:surplus">
       <span style="color:gray"><xsl:value-of select="."/></span>
   </xsl:template> 

    <xsl:template match="tei:desc">
        <xsl:variable name="name" select="./name()"/>
        <xsl:variable name="type" select="./@type"/>
        <div class="{$name}">
            <h5>(<xsl:value-of select="$name"/><xsl:value-of select="' '"/>
                <xsl:choose>
                    <xsl:when test="./@type">@<xsl:value-of select="$type"/></xsl:when>
                    <xsl:otherwise><span style="color:red">@type manquant</span></xsl:otherwise>
                </xsl:choose>
            )</h5>
            <div><xsl:apply-templates select="./*|text()"/></div>
        </div>
    </xsl:template>

    <xsl:template match="tei:persName">
        <xsl:variable name="name" select="./name()"/>
        <div class="{$name}">
            <xsl:for-each select="./*|text()">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:if test="./@ref">
                <a><xsl:value-of select="./@ref"/></a>
            </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:placeName">
        <xsl:choose>
            <xsl:when test="./ancestor::tei:persName">
                <span class="placeName"><xsl:value-of select="."/></span>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <span class="placeName"><xsl:value-of select="."/></span>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:roleName">
        <span class="roleName"><xsl:value-of select="."/></span>
        <a class="type">*(<xsl:value-of select="./@type"/>)</a>
    </xsl:template>
    
    <xsl:template match="tei:affiliation">
        <span class="affiliation"><xsl:value-of select="."/></span>
        <a class="type">*(<xsl:value-of select="./@type"/>)</a>
    </xsl:template>
    
    <xsl:template match="tei:district">
        <xsl:choose>
            <xsl:when test="./ancestor::tei:persName">
                <span class="district"><xsl:value-of select="."/></span>
                <a class="type">*(<xsl:value-of select="./@type"/>)</a>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <span class="district"><xsl:value-of select="."/></span>
                    <a class="type">*(<xsl:value-of select="./@type"/>)</a>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <span class="page"> (Page <xsl:value-of select="@n"/><span class="lienImage">*<xsl:value-of select="@facs"/></span>) </span>
    </xsl:template>
    
    <xsl:template match="comment()">
        <span class="comment"><xsl:value-of select="."/></span>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul>
            <xsl:for-each select="./tei:item"><li><xsl:apply-templates select="."/></li></xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:choice">
        <a title="{./(tei:abbr|tei:orig)}" class="infobulle"><xsl:apply-templates select="./(tei:expan|tei:reg|tei:corr)"/></a>
    </xsl:template>
    
</xsl:stylesheet>
