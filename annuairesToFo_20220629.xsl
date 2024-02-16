<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:template match="/">
        <xsl:variable name="teiCorpus" select="."/>
        
        <!--Génération d'un PDF général avec l'ensemble des tables des matières / hiérarchies des annuaires - DEBUT -->
        <xsl:result-document href="./FO/donnees_hierarchies.fo">
            
            <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
                <fo:layout-master-set>
                    <fo:simple-page-master master-name="sample">
                        <fo:region-body/>
                    </fo:simple-page-master>
                    <fo:simple-page-master master-name="titlepage" margin-top="20mm"
                        margin-bottom="0mm">
                        <fo:region-body margin-bottom="10mm" margin-top="10mm" margin-left="12mm"
                            margin-right="12mm"/>
                        <fo:region-before region-name="xsl-region-before" margin-bottom="10mm" extent="10mm"/>
                        <fo:region-after region-name="xsl-region-after" extent="42mm"/>
                    </fo:simple-page-master>
                    <fo:simple-page-master master-name="matieres" margin-top="10mm"
                        margin-bottom="10mm" margin-left="12mm"
                        margin-right="12mm" page-width="293mm" page-height="210mm">
                        <fo:region-body margin-bottom="10mm" margin-top="10mm"/>
                        <fo:region-before region-name="header" margin-bottom="10mm" extent="10mm"/>
                        <fo:region-after region-name="footer" extent="10mm"/>
                    </fo:simple-page-master>
                </fo:layout-master-set>
                
                <fo:bookmark-tree>
                    <fo:bookmark internal-destination="sommaire">
                        <fo:bookmark-title>Sommaire<!-- général--></fo:bookmark-title>
                    </fo:bookmark>
                    <xsl:for-each select="//TEI">
                        <xsl:variable name="filename" select="@xml:id"/>
                        <xsl:variable name="title" select=".//titleStmt/title//text()"/>
                        <fo:bookmark internal-destination="matieres_{$filename}">
                            <fo:bookmark-title><xsl:value-of select="$title"/></fo:bookmark-title>
                            <!--<fo:bookmark internal-destination="matieres_{$filename}">
                                <fo:bookmark-title>Table des matières de l'annuaire / Hiérarchie</fo:bookmark-title>
                            </fo:bookmark>-->
                        </fo:bookmark>
                    </xsl:for-each>
                </fo:bookmark-tree>
                
                <fo:page-sequence master-reference="matieres">
                    <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                        <fo:block font-size="20pt" color="#C02D2D" space-after="1em" id="sommaire">Annuaires : tables des matières / hiérarchies - Sommaire<!-- général--></fo:block>
                        <xsl:for-each select="//TEI">
                            <xsl:variable name="filename" select="@xml:id"/>
                            <xsl:variable name="title" select=".//titleStmt/title//text()"/>
                            <fo:block text-align-last="justify" margin-left="4mm" space-after="2mm">
                                <fo:basic-link internal-destination="matieres_{$filename}">
                                    <xsl:value-of select="$title"/>
                                    <fo:leader leader-pattern="dots"/>
                                    <fo:page-number-citation ref-id="matieres_{$filename}"/></fo:basic-link>
                                <!--<fo:block text-align-last="justify" margin-left="4mm" space-after="2mm">
                                    <fo:basic-link internal-destination="matieres_{$filename}">
                                        Table des matières de l'annuaire / Hiérarchie
                                        <fo:leader leader-pattern="dots"/>
                                        <fo:page-number-citation ref-id="matieres_{$filename}"/>
                                    </fo:basic-link>
                                </fo:block>-->
                            </fo:block>
                        </xsl:for-each>
                    </fo:flow>
                </fo:page-sequence>
                
                <xsl:for-each select="//TEI">
                    
                    <xsl:variable name="filename" select="./@xml:id"/>
                    <xsl:variable name="title" select=".//titleStmt/title//text()"/>
                
                <fo:page-sequence master-reference="matieres">
                    
                    <fo:static-content flow-name="header">
                        <fo:block color="#C02D2D" margin-bottom="0.7mm" text-align="left">
                            Table des matières de l'annuaire / Hiérarchie - <fo:inline font-size="8pt"><xsl:value-of select="$title"/></fo:inline>
                            <fo:retrieve-marker retrieve-class-name="titel"/>
                        </fo:block>
                    </fo:static-content>
                    <fo:static-content flow-name="footer">
                        <fo:block font-size="11pt"><fo:inline>0</fo:inline><fo:inline padding-left="5mm">1</fo:inline><fo:inline padding-left="7mm">2</fo:inline><fo:inline padding-left="7mm">3</fo:inline><fo:inline padding-left="6mm">4</fo:inline><fo:inline padding-left="7mm">5</fo:inline><fo:inline padding-left="7mm">6</fo:inline></fo:block>
                        <fo:block color="#C02D2D" margin-top="0.7mm" text-align="right">                         
                            <fo:page-number/>
                        </fo:block>
                    </fo:static-content>
                    
                    <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                        <fo:block font-size="11pt" id="matieres_{$filename}">
                            <fo:table>
                                <fo:table-column/>
                                <fo:table-column column-width="9mm"/>
                                <fo:table-body>
                                    
                                    <xsl:for-each select=".//org">
                                        
                                        <xsl:variable name="nbrOrg" select="count(./ancestor::org)"/>
                                        
                                        <fo:table-row line-height="5mm" vertical-align="middle">
                                            <xsl:if test="position() mod 2">
                                                <xsl:attribute name="background-color">#E5E5E5</xsl:attribute>
                                            </xsl:if>
                                            <fo:table-cell padding-left="{$nbrOrg*10}mm">
                                                <fo:block border-left="0.2mm black solid" padding-left="0.3mm">
                                                    <xsl:if test=".=./ancestor::*/org[1]">
                                                        <xsl:attribute name="border-top">0.2mm black solid</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test=".=./ancestor::*/org[last()] and not(./org)">
                                                        <xsl:attribute name="border-bottom">0.2mm black solid</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="orgName"/>
                                                </fo:block>
                                            </fo:table-cell><!--<xsl:value-of select="placeName|(*[not(./name()='org')]//placeName)"/>-->
                                            <fo:table-cell>
                                                <fo:block text-align="right" margin-right="0.5mm"><xsl:value-of select="./orgName/preceding::pb[1]/@n"/></fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        
                                    </xsl:for-each>
                                    
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:flow>
                </fo:page-sequence>
                    
                </xsl:for-each>
                
            </fo:root>
        </xsl:result-document>
        <!--Génération d'un PDF général avec l'ensemble des tables des matières / hiérarchies des annuaires - FIN -->
        
        <!--Génération d'un PDF par annuaire - DEBUT-->
        <xsl:for-each select="//TEI">
            
            <xsl:variable name="filename" select="@xml:id"/>
            <xsl:variable name="title" select=".//titleStmt/title//text()"/>
            
            <xsl:result-document href="./FO/donnees_{$filename}.fo"><!--Création du fichier FO avec indications de destination et de nom de fichier-->
                
            <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
                <!--Métadonnées du fichier FO relatives à la mise en page - DEBUT-->
                <fo:layout-master-set>
                    <fo:simple-page-master master-name="sample">
                        <fo:region-body/>
                    </fo:simple-page-master>
                    <fo:simple-page-master master-name="titlepage" margin-top="20mm"
                        margin-bottom="0mm">
                        <fo:region-body margin-bottom="10mm" margin-top="10mm" margin-left="12mm"
                            margin-right="12mm"/>
                        <fo:region-before region-name="xsl-region-before" margin-bottom="10mm" extent="10mm"/>
                        <fo:region-after region-name="xsl-region-after" extent="42mm"/>
                    </fo:simple-page-master>
                    <fo:simple-page-master master-name="matieres" margin-top="10mm"
                        margin-bottom="10mm" margin-left="12mm"
                        margin-right="12mm" page-width="293mm" page-height="210mm">
                        <fo:region-body margin-bottom="10mm" margin-top="10mm"/>
                        <fo:region-before region-name="header" margin-bottom="10mm" extent="10mm"/>
                        <fo:region-after region-name="footer" extent="10mm"/>
                    </fo:simple-page-master>
                </fo:layout-master-set>
                <!--Métadonnées du fichier FO relatives à la mise en page - FIN-->
                
                <!--Création d'une arborescence PDF (signets) - DEBUT-->
                <fo:bookmark-tree>
                    <fo:bookmark internal-destination="introduction">
                        <fo:bookmark-title>Introduction</fo:bookmark-title>
                    </fo:bookmark>
                    <fo:bookmark internal-destination="sommaire">
                        <fo:bookmark-title>Sommaire</fo:bookmark-title>
                    </fo:bookmark>
                    <fo:bookmark internal-destination="matieres">
                        <fo:bookmark-title>Table des matières de l'annuaire / Hiérarchie</fo:bookmark-title>
                    </fo:bookmark>
                    <fo:bookmark internal-destination="personnes">
                        <fo:bookmark-title>Personnes pour indexation effective ou éventuelle</fo:bookmark-title>
                    </fo:bookmark>
                    <xsl:for-each select=".//org[@role]">
                        <xsl:sort select="./@role"/>
                        <xsl:variable name="role" select="./@role"/>
                        <xsl:variable name="position" select="./count(./preceding::org[./ancestor::TEI/@xml:id=$filename and ./@role=$role])+1"/>
                        <xsl:variable name="nbrRole" select="count(./ancestor::body//org[./@role=$role])"/>
                        <fo:bookmark internal-destination="{$role}_{$position}">
                            <fo:bookmark-title>Service(s) « <xsl:value-of select="$role"/> » (<xsl:value-of select="$position"/>/<xsl:value-of select="$nbrRole"/>)</fo:bookmark-title>
                        </fo:bookmark>
                    </xsl:for-each>
                </fo:bookmark-tree>
                <!--Création d'une arborescence PDF (signets) - FIN-->
                
                <!--Création d'une page d'introduction - DEBUT-->
                <fo:page-sequence master-reference="matieres" id="introduction">
                    <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                        <fo:block font-size="20pt" color="#C02D2D" space-after="1em" id="introduction">Introduction au fichier : <xsl:value-of select="$title"/></fo:block>
                        <fo:block text-align-last="justify" margin-left="4mm" space-after="2mm"><!--<fo:basic-link internal-destination="matieres">-->
                            <fo:block text-align-last="left" margin-left="4mm" space-after="2mm">
                                <xsl:value-of select="concat('La version encodée de cet annuaire est produite par ',.//titleStmt/author)"/>
                            </fo:block>
                            <xsl:for-each select=".//respStmt">
                                <fo:block text-align-last="left" margin-left="4mm" space-after="2mm">
                                    <xsl:value-of select="./resp"/> : 
                                    <xsl:choose>
                                        <xsl:when test="count(./name)=2">
                                            <xsl:value-of select="./name[1]"/> et <xsl:value-of select="./name[2]"/>
                                        </xsl:when>
                                        <xsl:otherwise><xsl:value-of select="./name"/></xsl:otherwise>
                                    </xsl:choose>
                                </fo:block>
                            </xsl:for-each>
                            <fo:block text-align-last="left" margin-left="4mm" space-after="2mm">
                                <xsl:value-of select="concat('Réalisé en ',.//publicationStmt/date[@when])"/>
                            </fo:block>
                            <fo:block font-size="9pt" text-align-last="left" margin-left="4mm" margin-top="20mm" space-after="2mm">
                                Historique du fichier XML :
                                <fo:block>
                                    <xsl:for-each select=".//revisionDesc/list/item">
                                        <xsl:value-of select="."/>
                                    </xsl:for-each>
                                </fo:block>
                            </fo:block>
                            <fo:block font-size="9pt" text-align-last="left" margin-left="4mm" margin-top="20mm" space-after="2mm">
                                Fichier PDF généré le <xsl:value-of select="substring(xs:string(current-date()),0,11)"/>
                            </fo:block>
                        <!--</fo:basic-link>-->
                        </fo:block>
                        
                    </fo:flow>
                </fo:page-sequence>
                <!--Création d'une page d'introduction - FIN-->
                
                <!--Création du sommaire du fichier PDF - DEBUT-->
                <fo:page-sequence master-reference="matieres">
                    <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                        <fo:block font-size="20pt" color="#C02D2D" space-after="1em" id="sommaire">Sommaire</fo:block>
                        <fo:block text-align-last="justify" margin-left="4mm" space-after="2mm"><fo:basic-link internal-destination="matieres">
                            Table des matières de l'annuaire / Hiérarchie
                            <fo:leader leader-pattern="dots"/>
                            <fo:page-number-citation ref-id="matieres"/></fo:basic-link>
                        </fo:block>
                        <fo:block text-align-last="justify" margin-left="4mm" space-after="2mm"><fo:basic-link internal-destination="personnes">
                            Personnes pour indexation effective ou éventuelle
                            <fo:leader leader-pattern="dots"/>
                            <fo:page-number-citation ref-id="personnes"/></fo:basic-link>
                        </fo:block>
                        <xsl:for-each select=".//org[@role]">
                            <xsl:sort select="./@role"/>
                            <xsl:variable name="role" select="./@role"/>
                            <xsl:variable name="position" select="./count(./preceding::org[./ancestor::TEI/@xml:id=$filename and ./@role=$role])+1"/>
                            <xsl:variable name="nbrRole" select="count(./ancestor::body//org[./@role=$role])"/>
                            <fo:block text-align-last="justify" margin-left="4mm" space-after="2mm"><fo:basic-link internal-destination="{$role}_{$position}">
                                Service(s) « <xsl:value-of select="$role"/> » (<xsl:value-of select="$position"/>/<xsl:value-of select="$nbrRole"/>)
                                <fo:leader leader-pattern="dots"/>
                                <fo:page-number-citation ref-id="{$role}_{$position}"/></fo:basic-link>
                            </fo:block>
                        </xsl:for-each>
                    </fo:flow>
                </fo:page-sequence>
                <!--Création du sommaire du fichier PDF - FIN-->
                
                <!--Création de la table des matières de l'annuaire - DEBUT-->
                <fo:page-sequence master-reference="matieres">
                    
                    <!--Définition des entêtes et pieds-de-page pour l'ensemble de la table des matières de l'annuaire - DEBUT-->
                    <fo:static-content flow-name="header">
                        <fo:block color="#C02D2D" margin-bottom="0.7mm" text-align="left">
                            Table des matières de l'annuaire / Hiérarchie - <fo:inline font-size="8pt"><xsl:value-of select="$title"/></fo:inline>
                            <fo:retrieve-marker retrieve-class-name="titel"/>
                        </fo:block>
                    </fo:static-content>
                    <fo:static-content flow-name="footer">
                        <fo:block font-size="11pt"><fo:inline>0</fo:inline><fo:inline padding-left="5mm">1</fo:inline><fo:inline padding-left="7mm">2</fo:inline><fo:inline padding-left="7mm">3</fo:inline><fo:inline padding-left="6mm">4</fo:inline><fo:inline padding-left="7mm">5</fo:inline><fo:inline padding-left="7mm">6</fo:inline></fo:block>
                        <fo:block color="#C02D2D" margin-top="0.7mm" text-align="right">                         
                            <fo:page-number/>
                        </fo:block>
                    </fo:static-content>
                    <!--Définition des entêtes et pieds-de-page pour l'ensemble de la table des matières de l'annuaire - FIN-->
                    
                    <!--Corps du texte de la table des matières - DEBUT-->
                    <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                        <fo:block font-size="11pt" id="matieres">
                            <fo:table>
                                <fo:table-column/>
                                <fo:table-column column-width="9mm"/>
                                
                                <fo:table-body>
                                    
                                    <!--Création d'une entrée par org - DEBUT-->
                                    <xsl:for-each select=".//org">
                                        
                                        <xsl:variable name="nbrOrg" select="count(./ancestor::org)"/><!--décompte du niveau du org-->
                                        
                                        <fo:table-row line-height="5mm" vertical-align="middle">
                                            <xsl:if test="position() mod 2"><!--fonds gris 1 ligne sur 2, donc pour org dont le positionnement est pair-->
                                                <xsl:attribute name="background-color">#E5E5E5</xsl:attribute>
                                            </xsl:if>
                                            <fo:table-cell padding-left="{$nbrOrg*10}mm"><!--alinéa en fonction du décompte du niveau du org-->
                                                <fo:block border-left="0.2mm black solid" padding-left="0.3mm">
                                                    <xsl:if test=".=./ancestor::*/org[1]"><!--si premier org de son niveau : création d'une bordure supérieure-->
                                                        <xsl:attribute name="border-top">0.2mm black solid</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test=".=./ancestor::*/org[last()] and not(./org)"><!--si dernier org de son niveau : création d'une bordure inférieure-->
                                                        <xsl:attribute name="border-bottom">0.2mm black solid</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="orgName"/>
                                                </fo:block>
                                            </fo:table-cell><!--<xsl:value-of select="placeName|(*[not(./name()='org')]//placeName)"/>-->
                                            <fo:table-cell>
                                                <fo:block text-align="right" margin-right="0.5mm"><xsl:value-of select="./orgName/preceding::pb[1]/@n"/></fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>  
                                    </xsl:for-each>
                                    <!--Création d'une entrée par org - FIN-->
                                     
                                </fo:table-body>
                                
                            </fo:table>
                        </fo:block>
                    </fo:flow>
                    <!--Corps du texte de la table des matières - FIN-->
                    
                </fo:page-sequence>
                <!--Création de la table des matières de l'annuaire - FIN-->
                
                <!--Création d'une liste, par services, des personnes avec @ref - DEBUT -->
                <fo:page-sequence master-reference="matieres">
                    
                    <!--Définition des entêtes et pieds-de-page - DEBUT-->
                    <fo:static-content flow-name="header">
                        <fo:block color="#C02D2D" margin-bottom="0.7mm" text-align="left">
                            Personnes pour indexation effective ou éventuelle - <fo:inline font-size="8pt"><xsl:value-of select="$title"/></fo:inline>
                            <fo:retrieve-marker retrieve-class-name="titel"/>
                        </fo:block>
                    </fo:static-content>
                    <fo:static-content flow-name="footer">
                        <fo:block color="#C02D2D" margin-top="0.7mm" text-align="right">                         
                            <fo:page-number/>
                        </fo:block>
                    </fo:static-content>
                    <!--Définition des entêtes et pieds-de-page - FIN-->
                    
                    <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                        <fo:block font-size="9pt" text-align-last="left" margin-left="4mm" space-after="2mm" id="personnes">
                            <xsl:for-each select=".//org[./(persName/@ref)|*[not(./name()='org')]//persName/@ref]">
                                <fo:block font-size="10pt" color="#C02D2D" margin-top="4mm"><xsl:value-of select="./orgName/text()"/></fo:block>
                                <fo:block font-size="8pt" color="gray">
                                    <xsl:for-each select="./ancestor::org">
                                        <xsl:value-of select="./orgName"/> > 
                                    </xsl:for-each>
                                    <xsl:value-of select="./orgName"/>
                                </fo:block>
                                <fo:table>
                                    <fo:table-column column-width="55%"/>
                                    <fo:table-column column-width="25%"/>
                                    <fo:table-column column-width="10%"/>
                                    <fo:table-column column-width="10%"/>
                            
                                    <fo:table-body>
                                        <xsl:for-each select="./persName[@ref]|*[not(./name()='org')]//persName[@ref]">
                                            <xsl:variable name="ref" select="./@ref"/>
                                            <fo:table-row>
                                                <xsl:if test="position() mod 2">
                                                    <xsl:attribute name="background-color">#E5E5E5</xsl:attribute>
                                                </xsl:if>
                                                <fo:table-cell><fo:block><xsl:value-of select="."/></fo:block></fo:table-cell>
                                                <fo:table-cell text-align-last="left" margin-left="4mm" space-after="2mm">
                                                    <fo:block>
                                                    <xsl:choose>
                                                        <xsl:when test="$ref=./ancestor::teiCorpus/teiHeader/profileDesc/particDesc//person/concat('#',@xml:id)">
                                                            <xsl:variable name="person" select="./ancestor::teiCorpus/teiHeader/profileDesc/particDesc//person[concat('#',@xml:id)=$ref]"/>
                                                            <fo:block><xsl:value-of select="$person/persName/surname"/>, <xsl:value-of select="$person/persName/forename"/><xsl:if test="$person/persName/nameLink"> (<xsl:value-of select="$person/persName/nameLink"/>)</xsl:if></fo:block>
                                                            <fo:block><xsl:value-of select="$person/sex"/></fo:block>
                                                        </xsl:when>
                                                        <xsl:otherwise>(Absent de l'index)</xsl:otherwise>
                                                    </xsl:choose>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block>
                                                        <xsl:for-each select="./ancestor::teiCorpus/TEI[not(@xml:id=$filename) and .//@ref=$ref]">
                                                            <fo:block><xsl:value-of select=".//bibl/title/date/@when"/></fo:block>
                                                        </xsl:for-each>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell><fo:block><xsl:value-of select="$ref"/></fo:block></fo:table-cell>
                                            </fo:table-row>
                                        </xsl:for-each>
                                    </fo:table-body>
                                </fo:table>
                            </xsl:for-each>
                        </fo:block>
                    </fo:flow>
                </fo:page-sequence>
                <!--Création d'une liste, par services, des personnes avec @ref - FIN-->
                
                
                
                
                <!--Pour chaque service repéré par un @role, création d'une présentation particulière avec images des pages et transcription encodée - DEBUT -->
                <xsl:for-each select=".//org[@role]">
                    <xsl:sort select="./@role"/>
                    <xsl:variable name="role" select="./@role"/>
                    <xsl:variable name="position" select="./count(./preceding::org[./ancestor::TEI/@xml:id=$filename and ./@role=$role])+1"/>
                    <xsl:variable name="nbrRole" select="count(./ancestor::body//org[./@role=$role])"/>
                    
                    <fo:page-sequence master-reference="matieres">
                        
                        <!--Définition des entêtes et pieds-de-page - DEBUT-->
                        <fo:static-content flow-name="header">
                            <fo:block color="#C02D2D" margin-bottom="0.7mm" text-align="left">
                                Service(s) « <xsl:value-of select="$role"/> » (<xsl:value-of select="$position"/>/<xsl:value-of select="$nbrRole"/>) - <fo:inline font-size="8pt"><xsl:value-of select="$title"/></fo:inline>
                                <fo:retrieve-marker retrieve-class-name="title"/>
                            </fo:block>
                        </fo:static-content>
                        <fo:static-content flow-name="footer">
                            <fo:block color="#C02D2D" margin-top="0.7mm" text-align="right">                         
                                <fo:page-number/>
                            </fo:block>
                        </fo:static-content>
                        <!--Définition des entêtes et pieds-de-page - FIN-->
                    
                        <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                            <fo:block font-size="9pt" text-align-last="left" space-after="2mm" id="{$role}_{$position}">
                                <fo:block margin-bottom="20mm">
                                    <fo:block font-size="20pt" color="#C02D2D" margin-top="40mm" margin-bottom="5mm"><xsl:value-of select="./orgName/text()"/></fo:block>
                                    <fo:block font-size="18pt" color="gray">
                                        <xsl:for-each select="./ancestor::org">
                                            <xsl:value-of select="./orgName"/> > 
                                        </xsl:for-each>
                                        <xsl:value-of select="./orgName"/>
                                    </fo:block>
                                    <fo:block>
                                        <xsl:for-each select=".//(orgName/preceding::pb[1])|pb">
                                            <xsl:variable name="pb" select="."/>
                                            <xsl:variable name="nsuiv" select="./following::pb[1]/@n"/>
                                            <fo:block-container reference-orientation="-90"><fo:block font-size="12pt">P. <xsl:value-of select="./@n"/> (<xsl:value-of select="./@facs"/>)</fo:block>
                                            <fo:block>
                                                <xsl:choose>
                                                    <xsl:when test="./@facs and contains(./@facs,'.jpg')">
                                                        <fo:external-graphic src="../{substring(./@facs,0,20)}_{substring($filename,4,7)}/JPEG/{./@facs}" height="240mm" content-width="scale-down-to-fit"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>(Image manquante)</xsl:otherwise>
                                                </xsl:choose>
                                            </fo:block>
                                            </fo:block-container>
                                            <fo:block>
                                                
                                                <fo:table>
                                                    <fo:table-column column-width="10%"/>
                                                    <fo:table-column column-width="15%"/>
                                                    <fo:table-column column-width="75%"/>
                                                    <fo:table-body>
                                                        <xsl:for-each select="./following::*[not(./name()='org' or ./ancestor::persName or .[not(name()='pb')]/ancestor::desc or ./ancestor::orgName)]">
                                                            <xsl:variable name="background-color" select="if(./name()='orgName') then ('#C02D2D') else('transparent')"/>
                                                            <xsl:variable name="color" select="if(./name()='orgName') then ('white') else('black')"/>
                                                            <xsl:if test="./ancestor::TEI/@xml:id=$filename and (./following::pb[1]/@n=$nsuiv or .[name()='desc' or name()='persName']//pb/@n=$nsuiv)"><fo:table-row>
                                                                <xsl:if test="position() mod 2"><!--fonds gris 1 ligne sur 2, donc pour org dont le positionnement est pair-->
                                                                    <xsl:attribute name="background-color">#E5E5E5</xsl:attribute>
                                                                </xsl:if>
                                                                <fo:table-cell><fo:block background-color="{$background-color}" color="{$color}"><xsl:value-of select="./name()"/></fo:block></fo:table-cell>
                                                                <fo:table-cell>
                                                                    <fo:block background-color="{$background-color}" color="{$color} ">
                                                                        <xsl:choose>
                                                                            <xsl:when test="./name()='orgName'">Nom de l'entité</xsl:when>
                                                                            <xsl:when test="./name()='persName'">Personne</xsl:when>
                                                                            <xsl:when test="./name()='placeName'">Lieu</xsl:when>
                                                                            <xsl:when test="./name()='district'">Emplacement bureau</xsl:when>
                                                                            <xsl:when test="./name()='desc' and ./@type='attributions'">Attributions</xsl:when>
                                                                            <xsl:when test="./name()='desc' and ./@type='composition'">Type de composition</xsl:when>
                                                                            <xsl:when test="./name()='desc' and ./@type='presentation'">Présentation</xsl:when>
                                                                            <xsl:when test="./name()='desc' and ./@type='liste'">Liste</xsl:when>
                                                                            <xsl:when test="./name()='desc' and ./@type='pratique'">Informations pratiques</xsl:when>
                                                                            <xsl:otherwise>-</xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell>
                                                                    <fo:block background-color="{$background-color}" color="{$color}">
                                                                        <xsl:choose>
                                                                            <xsl:when test="./name()='orgName'">
                                                                                <xsl:for-each select="./*|text()">
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="./name()='surplus' or ./name()='placeName'">
                                                                                            <fo:inline font-style="italic"><xsl:value-of select="."/></fo:inline>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </xsl:for-each>
                                                                            </xsl:when>
                                                                            <xsl:when test="./name()='persName' and ./*">
                                                                                <xsl:value-of select="."/>
                                                                                <fo:table width="60%" border="0.5pt solid gray">
                                                                                    <fo:table-column column-width="25%"/>
                                                                                    <fo:table-column column-width="75%"/>
                                                                                    <fo:table-body>
                                                                                        <xsl:for-each select="./*|text()[not(.='.' or .=',' or .=' .' or .=', ' or .=' ')]">
                                                                                            <fo:table-row>
                                                                                                <fo:table-cell border="0.5pt solid gray">
                                                                                                    <fo:block>
                                                                                                        <xsl:choose>
                                                                                                            <xsl:when test="./name()='roleName' and ./@type='distinction'">Distinction(s)</xsl:when>
                                                                                                            <xsl:when test="./name()='roleName' and ./@type='titre'">Titre(s)</xsl:when>
                                                                                                            <xsl:when test="./name()='placeName'">Lieu</xsl:when>
                                                                                                            <xsl:when test="./name()='district'">Emplacement bureau</xsl:when>
                                                                                                            <xsl:when test="./name()='affiliation'">Position hiérarchique</xsl:when>
                                                                                                            <xsl:when test="./name()='state'">Attributions</xsl:when>
                                                                                                            <xsl:otherwise>-</xsl:otherwise>
                                                                                                        </xsl:choose>
                                                                                                    </fo:block>
                                                                                                </fo:table-cell>
                                                                                                <fo:table-cell border="0.5pt solid gray"><fo:block><xsl:value-of select="."/></fo:block></fo:table-cell>
                                                                                            </fo:table-row>
                                                                                        </xsl:for-each>
                                                                                    </fo:table-body>
                                                                                </fo:table>
                                                                            </xsl:when>
                                                                            <xsl:when test="./name()='desc' and ./*">
                                                                                <fo:table width="60%" border="0.5pt solid gray">
                                                                                    <fo:table-column column-width="25%"/>
                                                                                    <fo:table-column column-width="75%"/>
                                                                                    <fo:table-body>
                                                                                        <xsl:for-each select="./*|text()">
                                                                                            <fo:table-row>
                                                                                                <fo:table-cell border="0.5pt solid gray">
                                                                                                    <fo:block>
                                                                                                        <xsl:choose>
                                                                                                            <xsl:when test="./name()='material' and ./damage">État du document</xsl:when>
                                                                                                            <xsl:when test="./name()='material' and ./pb">pb</xsl:when>
                                                                                                            <xsl:when test="./name()='material' and ./lb"></xsl:when>
                                                                                                            <xsl:when test="./name()='list' and not(./item/*)">(liste)</xsl:when>
                                                                                                            <xsl:when test="./name()='list' and ./item/*">(liste)</xsl:when>
                                                                                                            <xsl:when test="./name()='persName'">Personne</xsl:when>
                                                                                                            <xsl:otherwise>-</xsl:otherwise>
                                                                                                        </xsl:choose>
                                                                                                    </fo:block>
                                                                                                </fo:table-cell>
                                                                                                <fo:table-cell border="0.5pt solid gray">
                                                                                                    <fo:block>
                                                                                                        <xsl:choose>
                                                                                                            <xsl:when test="./name()='material' and ./damage"><xsl:value-of select="./damage/@type"/></xsl:when>
                                                                                                            <xsl:when test="./name()='material' and ./pb">???????</xsl:when>
                                                                                                            <xsl:when test="./name()='material' and ./lb"></xsl:when>
                                                                                                            <xsl:when test="./name()='list' and not(./item/*)"><xsl:for-each select="./item"><fo:block><xsl:value-of select="."/></fo:block></xsl:for-each></xsl:when>
                                                                                                            <xsl:when test="./name()='list' and ./item/*"><xsl:for-each select="./item"><fo:block><xsl:value-of select="."/></fo:block></xsl:for-each></xsl:when>
                                                                                                            <xsl:when test="./name()='persName'"><xsl:value-of select="."/></xsl:when>
                                                                                                            <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                                                                                                        </xsl:choose>
                                                                                                    </fo:block>
                                                                                                </fo:table-cell>
                                                                                            </fo:table-row>
                                                                                        </xsl:for-each>
                                                                                    </fo:table-body>
                                                                                </fo:table>
                                                                            </xsl:when>
                                                                            <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row></xsl:if>
                                                        </xsl:for-each>
                                                    </fo:table-body>
                                                </fo:table>
                                            </fo:block>
                                        </xsl:for-each>
                                    </fo:block>
                                </fo:block>
                            </fo:block>
                        </fo:flow>
                    </fo:page-sequence>
                </xsl:for-each>
                <!--Pour chaque service repéré par un @role, création d'une présentation particulière avec images des pages et transcription encodée - FIN -->
                
            </fo:root>
        </xsl:result-document>
            
        </xsl:for-each>
        <!--Génération d'un PDF par annuaire - FIN-->
        
        <!--Génération d'un PDF général pour l'index des personnes - DEBUT-->
        <xsl:result-document href="./FO/donnees_index.fo">
            <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
                <!--Métadonnées du fichier FO relatives à la mise en page - DEBUT-->
                <fo:layout-master-set>
                    <fo:simple-page-master master-name="sample">
                        <fo:region-body/>
                    </fo:simple-page-master>
                    <fo:simple-page-master master-name="titlepage" margin-top="20mm"
                        margin-bottom="0mm">
                        <fo:region-body margin-bottom="10mm" margin-top="10mm" margin-left="12mm"
                            margin-right="12mm"/>
                        <fo:region-before region-name="xsl-region-before" margin-bottom="10mm" extent="10mm"/>
                        <fo:region-after region-name="xsl-region-after" extent="42mm"/>
                    </fo:simple-page-master>
                    <fo:simple-page-master master-name="matieres" margin-top="10mm"
                        margin-bottom="10mm" margin-left="12mm"
                        margin-right="12mm" page-width="293mm" page-height="210mm">
                        <fo:region-body margin-bottom="10mm" margin-top="10mm"/>
                        <fo:region-before region-name="header" margin-bottom="10mm" extent="10mm"/>
                        <fo:region-after region-name="footer" extent="10mm"/>
                    </fo:simple-page-master>
                </fo:layout-master-set>
                <!--Métadonnées du fichier FO relatives à la mise en page - FIN-->
                
                <fo:page-sequence master-reference="matieres">
                    <!--Définition des entêtes et pieds-de-page - DEBUT-->
                    <fo:static-content flow-name="header">
                        <fo:block color="#C02D2D" margin-bottom="0.7mm" text-align="left">
                            Annuaires de la Préfecture de la Seine et de la Ville de Paris - Index des personnes
                            <fo:retrieve-marker retrieve-class-name="title"/>
                        </fo:block>
                    </fo:static-content>
                    <fo:static-content flow-name="footer">
                        <fo:block color="#C02D2D" margin-top="0.7mm" text-align="right">                         
                            <fo:page-number/>
                        </fo:block>
                    </fo:static-content>
                    <!--Définition des entêtes et pieds-de-page - FIN-->
                    
                    <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                        <fo:block font-size="9pt" text-align-last="left" space-after="2mm" id="index-personnes">
                            <fo:table>
                                <fo:table-column column-width="8%" border-right="0.5pt #C02D2D solid"/>
                                <fo:table-column column-width="3%" border-right="0.5pt #C02D2D solid"/>
                                <fo:table-column column-width="10%" border-right="0.5pt #C02D2D solid"/>
                                <fo:table-column column-width="79%"/>
                                <fo:table-header>
                                    <fo:table-row background-color="#C02D2D" color="white">
                                        <fo:table-cell border-right="0.5pt white solid"><fo:block margin-left="2mm">Id.</fo:block></fo:table-cell>
                                        <fo:table-cell border-right="0.5pt white solid"><fo:block margin-left="0.5mm">H/F</fo:block></fo:table-cell>
                                        <fo:table-cell border-right="0.5pt white solid"><fo:block margin-left="2mm">Nom</fo:block></fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block>
                                                <fo:table>
                                                    <fo:table-column column-width="8%" border-right="0.5pt white solid"/>
                                                    <fo:table-column column-width="20%" border-right="0.5pt white solid"/>
                                                    <fo:table-column column-width="20%" border-right="0.5pt white solid"/>
                                                    <fo:table-column column-width="12%" border-right="0.5pt white solid"/>
                                                    <fo:table-column column-width="10%" border-right="0.5pt white solid"/>
                                                    <fo:table-column column-width="15%" border-right="0.5pt white solid"/>
                                                    <fo:table-column column-width="15%"/>
                                                    <fo:table-body>
                                                        <fo:table-row>
                                                            <fo:table-cell><fo:block>Annuaire</fo:block></fo:table-cell>
                                                            <fo:table-cell><fo:block>Arborescence</fo:block></fo:table-cell>
                                                            <fo:table-cell><fo:block>Informations</fo:block></fo:table-cell>
                                                            <fo:table-cell><fo:block>Titre(s)</fo:block></fo:table-cell>
                                                            <fo:table-cell><fo:block>Distinction(s)</fo:block></fo:table-cell>
                                                            <fo:table-cell><fo:block>Position hiérarchique</fo:block></fo:table-cell>
                                                            <fo:table-cell><fo:block>Lieu</fo:block></fo:table-cell>
                                                        </fo:table-row>
                                                    </fo:table-body>
                                                </fo:table>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-header>
                                <fo:table-body>
                                    <xsl:for-each select="//listPerson/person">
                                        <xsl:variable name="xmlid" select="./@xml:id"/>
                                        <xsl:variable name="position" select="position()"/>
                                        <xsl:variable name="genre" select="if(./sex='Homme') then ('H.') else if(./sex='Femme') then ('F.') else('???')"/>
                                        <fo:table-row>
                                            <xsl:if test="$position mod 2">
                                                <xsl:attribute name="background-color">#E5E5E5</xsl:attribute>
                                            </xsl:if>
                                            <fo:table-cell>
                                                <fo:block margin-left="2mm">#<xsl:value-of select="$xmlid"/></fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block margin-left="1mm">
                                                    <!--<xsl:value-of select="substring(./sex,0,2)"/>.-->
                                                    <xsl:value-of select="$genre"/>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block>
                                                    <xsl:choose>
                                                        <xsl:when test="./persName/nameLink"> <xsl:value-of select="concat(./persName/surname, ' ', ./persName/forename, ' (', ./persName/nameLink, ')' )"/></xsl:when>
                                                        <xsl:otherwise> <xsl:value-of select="concat(./persName/surname, ' ', ./persName/forename)"/></xsl:otherwise>
                                                    </xsl:choose>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell><fo:block>
                                                <xsl:choose>
                                                <xsl:when test="./ancestor::teiCorpus//persName[@ref=concat('#',$xmlid)]">
                                                    <fo:table>
                                                        <fo:table-column column-width="8%" border-right="0.5pt #C02D2D solid"/>
                                                        <fo:table-column column-width="20%" border-right="0.5pt #C02D2D solid"/>
                                                        <fo:table-column column-width="20%" border-right="0.5pt #C02D2D solid"/>
                                                        <fo:table-column column-width="12%" border-right="0.5pt #C02D2D solid"/>
                                                        <fo:table-column column-width="10%" border-right="0.5pt #C02D2D solid"/>
                                                        <fo:table-column column-width="15%" border-right="0.5pt #C02D2D solid"/>
                                                        <fo:table-column column-width="15%"/>
                                                        <fo:table-body>
                                                            <xsl:for-each select="./ancestor::teiCorpus//persName[@ref=concat('#',$xmlid)]">
                                                                <fo:table-row margin-top="1mm" margin-bottom="1mm">
                                                                    <xsl:choose>
                                                                        <xsl:when test="$position mod 2">
                                                                            <xsl:attribute name="border-bottom">0.75pt white dashed</xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:attribute name="border-bottom">0.75pt #E5E5E5 dashed</xsl:attribute>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                    <fo:table-cell><fo:block>
                                                                        <xsl:value-of select="./ancestor::TEI//bibl/title/date/@when"/>
                                                                        <fo:block>P. <xsl:value-of select="./preceding::pb[1]/@n"/></fo:block>
                                                                        <!--<fo:block>(<xsl:value-of select="./preceding::pb[1]/@facs"/>)</fo:block>-->
                                                                    </fo:block></fo:table-cell>
                                                                    <fo:table-cell><fo:block>
                                                                        <xsl:for-each select="./ancestor::org[not(position()=1)]/orgName">
                                                                            <xsl:value-of select="./text()"/> > 
                                                                        </xsl:for-each>
                                                                        <xsl:value-of select="./ancestor::org[1]/orgName/text()"/>
                                                                    </fo:block></fo:table-cell>
                                                                    <fo:table-cell><fo:block>
                                                                        <xsl:value-of select="."/>
                                                                    </fo:block></fo:table-cell>
                                                                    <fo:table-cell><fo:block>
                                                                        <xsl:choose>
                                                                            <xsl:when test="./roleName/@type='titre'"><xsl:value-of select="./roleName[@type='titre']"/></xsl:when>
                                                                            <xsl:otherwise>-</xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </fo:block></fo:table-cell>
                                                                    <fo:table-cell><fo:block>
                                                                        <xsl:choose>
                                                                            <xsl:when test="./roleName/@type='distinction'"><xsl:value-of select="./roleName[@type='distinction']"/></xsl:when>
                                                                            <xsl:otherwise>-</xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </fo:block></fo:table-cell>
                                                                    <fo:table-cell><fo:block>
                                                                        <xsl:choose>
                                                                            <xsl:when test="./affiliation"><xsl:value-of select="./affiliation"/></xsl:when>
                                                                            <xsl:otherwise>-</xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </fo:block></fo:table-cell>
                                                                    <fo:table-cell><fo:block>
                                                                        <xsl:choose>
                                                                            <xsl:when test="./placeName"><xsl:value-of select="./placeName"/></xsl:when>
                                                                            <xsl:otherwise>-</xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </fo:block></fo:table-cell>
                                                                </fo:table-row>
                                                            </xsl:for-each>
                                                        </fo:table-body>
                                                    </fo:table>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <fo:block>-</fo:block>
                                                    <!--state ; district ?-->
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            </fo:block></fo:table-cell>
                                        </fo:table-row>
                                    </xsl:for-each>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:flow>
                </fo:page-sequence>
            </fo:root>
        </xsl:result-document>
        <!--Génération d'un PDF général pour l'index des personnes - FIN-->
        
        <!--Génération d'un PDF par type de @role avec, pour chaque org concerné, création d'une présentation particulière avec images des pages et transcription encodée - DEBUT-->
        <xsl:for-each select="distinct-values(//org/@role)">
            <xsl:variable name="role" select="."/>
            <xsl:result-document href="./FO/donnees_{$role}.fo">
                <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
                    <!--Métadonnées du fichier FO relatives à la mise en page - DEBUT-->
                    <fo:layout-master-set>
                        <fo:simple-page-master master-name="sample">
                            <fo:region-body/>
                        </fo:simple-page-master>
                        <fo:simple-page-master master-name="titlepage" margin-top="20mm"
                            margin-bottom="0mm">
                            <fo:region-body margin-bottom="10mm" margin-top="10mm" margin-left="12mm"
                                margin-right="12mm"/>
                            <fo:region-before region-name="xsl-region-before" margin-bottom="10mm" extent="10mm"/>
                            <fo:region-after region-name="xsl-region-after" extent="42mm"/>
                        </fo:simple-page-master>
                        <fo:simple-page-master master-name="matieres" margin-top="10mm"
                            margin-bottom="10mm" margin-left="12mm"
                            margin-right="12mm" page-width="293mm" page-height="210mm">
                            <fo:region-body margin-bottom="10mm" margin-top="10mm"/>
                            <fo:region-before region-name="header" margin-bottom="10mm" extent="10mm"/>
                            <fo:region-after region-name="footer" extent="10mm"/>
                        </fo:simple-page-master>
                    </fo:layout-master-set>
                    <!--Métadonnées du fichier FO relatives à la mise en page - FIN-->
                    
                    <fo:bookmark-tree>
                        <fo:bookmark internal-destination="sommaire">
                            <fo:bookmark-title>Sommaire</fo:bookmark-title>
                        </fo:bookmark>
                        <xsl:for-each select="$teiCorpus//org[@role=$role]">
                            <xsl:variable name="TEI" select="./ancestor::TEI"/>
                            <xsl:variable name="filename" select="$TEI/@xml:id"/>
                            <xsl:variable name="title" select="$TEI//titleStmt/title//text()"/>
                            <xsl:variable name="position" select="./count(./preceding::org[./ancestor::TEI/@xml:id=$filename and ./@role=$role])+1"/>
                            <xsl:variable name="nbrRole" select="count(./ancestor::body//org[./@role=$role])"/>
                            <fo:bookmark internal-destination="{$filename}_{$position}">
                                <fo:bookmark-title><xsl:value-of select="$title"/> (<xsl:value-of select="$position"/>/<xsl:value-of select="$nbrRole"/>)</fo:bookmark-title>
                            </fo:bookmark>
                        </xsl:for-each>
                    </fo:bookmark-tree>
                    
                    <fo:page-sequence master-reference="matieres">
                        <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                            <fo:block font-size="20pt" color="#C02D2D" space-after="1em" id="sommaire">Service(s) « <xsl:value-of select="$role"/> » - Sommaire</fo:block>
                            <xsl:for-each select="$teiCorpus//org[@role=$role]">
                                <xsl:variable name="TEI" select="./ancestor::TEI"/>
                                <xsl:variable name="filename" select="$TEI/@xml:id"/>
                                <xsl:variable name="title" select="$TEI//titleStmt/title//text()"/>
                                <xsl:variable name="position" select="./count(./preceding::org[./ancestor::TEI/@xml:id=$filename and ./@role=$role])+1"/>
                                <xsl:variable name="nbrRole" select="count(./ancestor::body//org[./@role=$role])"/>
                                <fo:block text-align-last="justify" margin-left="4mm" space-after="2mm">
                                    <fo:basic-link internal-destination="{$filename}_{$position}">
                                        <xsl:value-of select="$title"/> (<xsl:value-of select="$position"/>/<xsl:value-of select="$nbrRole"/>)
                                        <fo:leader leader-pattern="dots"/>
                                        <fo:page-number-citation ref-id="{$filename}_{$position}"/></fo:basic-link>
                                </fo:block>
                            </xsl:for-each>
                        </fo:flow>
                    </fo:page-sequence>
                    
                    <xsl:for-each select="$teiCorpus//org[@role=$role]">
                        <xsl:sort select="./ancestor::TEI//bibl/title/date/@when"/>
                        <xsl:variable name="TEI" select="./ancestor::TEI"/>
                        <xsl:variable name="filename" select="$TEI/@xml:id"/>
                        <xsl:variable name="title" select="$TEI//titleStmt/title//text()"/>
                        <xsl:variable name="position" select="./count(./preceding::org[./ancestor::TEI/@xml:id=$filename and ./@role=$role])+1"/>
                        <xsl:variable name="nbrRole" select="count(./ancestor::body//org[./@role=$role])"/>
                        
                        <fo:page-sequence master-reference="matieres">
                            
                            <!--Définition des entêtes et pieds-de-page - DEBUT-->
                            <fo:static-content flow-name="header">
                                <fo:block color="#C02D2D" margin-bottom="0.7mm" text-align="left">
                                    Service(s) « <xsl:value-of select="$role"/> » - <fo:inline font-size="8pt"><xsl:value-of select="$title"/></fo:inline> (<xsl:value-of select="$position"/>/<xsl:value-of select="$nbrRole"/>)
                                    <fo:retrieve-marker retrieve-class-name="title"/>
                                </fo:block>
                            </fo:static-content>
                            <fo:static-content flow-name="footer">
                                <fo:block color="#C02D2D" margin-top="0.7mm" text-align="right">                         
                                    <fo:page-number/>
                                </fo:block>
                            </fo:static-content>
                            <!--Définition des entêtes et pieds-de-page - FIN-->
                            
                            <fo:flow flow-name="xsl-region-body" font-family="Times, Times New Roman, serif">
                                <fo:block font-size="9pt" text-align-last="left" space-after="2mm" id="{$filename}_{$position}">
                                    <fo:block margin-bottom="20mm">
                                        <fo:block font-size="20pt" color="#C02D2D" margin-top="40mm" margin-bottom="5mm"><xsl:value-of select="./orgName/text()"/></fo:block>
                                        <fo:block font-size="18pt" color="gray">
                                            <xsl:for-each select="./ancestor::org">
                                                <xsl:value-of select="./orgName"/> > 
                                            </xsl:for-each>
                                            <xsl:value-of select="./orgName"/>
                                        </fo:block>
                                        <fo:block>
                                            <xsl:for-each select=".//(orgName/preceding::pb[1])|pb">
                                                <xsl:variable name="pb" select="."/>
                                                <xsl:variable name="nsuiv" select="./following::pb[1]/@n"/>
                                                <fo:block-container reference-orientation="-90"><fo:block font-size="12pt">P. <xsl:value-of select="./@n"/> (<xsl:value-of select="./@facs"/>)</fo:block>
                                                    <fo:block>
                                                        <xsl:choose>
                                                            <xsl:when test="./@facs and contains(./@facs,'.jpg')">
                                                                <fo:external-graphic src="../{substring(./@facs,0,20)}_{substring($filename,4,7)}/JPEG/{./@facs}" height="240mm" content-width="scale-down-to-fit"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>(Image manquante)</xsl:otherwise>
                                                        </xsl:choose>
                                                    </fo:block>
                                                </fo:block-container>
                                                <fo:block>
                                                    
                                                    <fo:table>
                                                        <fo:table-column column-width="10%"/>
                                                        <fo:table-column column-width="15%"/>
                                                        <fo:table-column column-width="75%"/>
                                                        <fo:table-body><!--bug sur le for-each, concernant une partie des annuaires, à régler d'urgence
                                                        <xsl:for-each select="./following::*[not(./name()='org' or ./ancestor::persName or .[not(name()='pb')]/ancestor::desc or ./ancestor::orgName)]">
                                                            <xsl:variable name="background-color" select="if(./name()='orgName') then ('#C02D2D') else('transparent')"/>
                                                            <xsl:variable name="color" select="if(./name()='orgName') then ('white') else('black')"/>
                                                            <xsl:if test="./ancestor::TEI/@xml:id=$filename and (./following::pb[1]/@n=$nsuiv or .[name()='desc' or name()='persName']//pb/@n=$nsuiv)">
                                                        -->
                                                            <xsl:for-each select="./following::*[not(./name()='org' or ./ancestor::persName or .[not(name()='pb')]/ancestor::desc or ./ancestor::orgName)]">
                                                                <xsl:variable name="background-color" select="if(./name()='orgName') then ('#C02D2D') else('transparent')"/>
                                                                <xsl:variable name="color" select="if(./name()='orgName') then ('white') else('black')"/>
                                                                <xsl:if test="./ancestor::TEI/@xml:id=$filename and (./following::pb[1]/@n=$nsuiv or .[name()='desc' or name()='persName']//pb/@n=$nsuiv)"><fo:table-row>
                                                                    <xsl:if test="position() mod 2"><!--fonds gris 1 ligne sur 2, donc pour org dont le positionnement est pair-->
                                                                        <xsl:attribute name="background-color">#E5E5E5</xsl:attribute>
                                                                    </xsl:if>
                                                                    <fo:table-cell><fo:block background-color="{$background-color}" color="{$color}"><xsl:value-of select="./name()"/></fo:block></fo:table-cell>
                                                                    <fo:table-cell>
                                                                        <fo:block background-color="{$background-color}" color="{$color} ">
                                                                            <xsl:choose>
                                                                                <xsl:when test="./name()='orgName'">Nom de l'entité</xsl:when>
                                                                                <xsl:when test="./name()='persName'">Personne</xsl:when>
                                                                                <xsl:when test="./name()='placeName'">Lieu</xsl:when>
                                                                                <xsl:when test="./name()='district'">Emplacement bureau</xsl:when>
                                                                                <xsl:when test="./name()='desc' and ./@type='attributions'">Attributions</xsl:when>
                                                                                <xsl:when test="./name()='desc' and ./@type='composition'">Type de composition</xsl:when>
                                                                                <xsl:when test="./name()='desc' and ./@type='presentation'">Présentation</xsl:when>
                                                                                <xsl:when test="./name()='desc' and ./@type='liste'">Liste</xsl:when>
                                                                                <xsl:when test="./name()='desc' and ./@type='pratique'">Informations pratiques</xsl:when>
                                                                                <xsl:otherwise>-</xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </fo:block>
                                                                    </fo:table-cell>
                                                                    <fo:table-cell>
                                                                        <fo:block background-color="{$background-color}" color="{$color}">
                                                                            <xsl:choose>
                                                                                <xsl:when test="./name()='orgName'">
                                                                                    <xsl:for-each select="./*|text()">
                                                                                        <xsl:choose>
                                                                                            <xsl:when test="./name()='surplus' or ./name()='placeName'">
                                                                                                <fo:inline font-style="italic"><xsl:value-of select="."/></fo:inline>
                                                                                            </xsl:when>
                                                                                            <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                                                                                        </xsl:choose>
                                                                                    </xsl:for-each>
                                                                                </xsl:when>
                                                                                <xsl:when test="./name()='persName' and ./*">
                                                                                    <xsl:value-of select="."/>
                                                                                    <fo:table width="60%" border="0.5pt solid gray">
                                                                                        <fo:table-column column-width="25%"/>
                                                                                        <fo:table-column column-width="75%"/>
                                                                                        <fo:table-body>
                                                                                            <xsl:for-each select="./*|text()[not(.='.' or .=',' or .=' .' or .=', ' or .=' ')]">
                                                                                                <fo:table-row>
                                                                                                    <fo:table-cell border="0.5pt solid gray">
                                                                                                        <fo:block>
                                                                                                            <xsl:choose>
                                                                                                                <xsl:when test="./name()='roleName' and ./@type='distinction'">Distinction(s)</xsl:when>
                                                                                                                <xsl:when test="./name()='roleName' and ./@type='titre'">Titre(s)</xsl:when>
                                                                                                                <xsl:when test="./name()='placeName'">Lieu</xsl:when>
                                                                                                                <xsl:when test="./name()='district'">Emplacement bureau</xsl:when>
                                                                                                                <xsl:when test="./name()='affiliation'">Position hiérarchique</xsl:when>
                                                                                                                <xsl:when test="./name()='state'">Attributions</xsl:when>
                                                                                                                <xsl:otherwise>-</xsl:otherwise>
                                                                                                            </xsl:choose>
                                                                                                        </fo:block>
                                                                                                    </fo:table-cell>
                                                                                                    <fo:table-cell border="0.5pt solid gray"><fo:block><xsl:value-of select="."/></fo:block></fo:table-cell>
                                                                                                </fo:table-row>
                                                                                            </xsl:for-each>
                                                                                        </fo:table-body>
                                                                                    </fo:table>
                                                                                </xsl:when>
                                                                                <xsl:when test="./name()='desc' and ./*">
                                                                                    <fo:table width="60%" border="0.5pt solid gray">
                                                                                        <fo:table-column column-width="25%"/>
                                                                                        <fo:table-column column-width="75%"/>
                                                                                        <fo:table-body>
                                                                                            <xsl:for-each select="./*|text()">
                                                                                                <fo:table-row>
                                                                                                    <fo:table-cell border="0.5pt solid gray">
                                                                                                        <fo:block>
                                                                                                            <xsl:choose>
                                                                                                                <xsl:when test="./name()='material' and ./damage">État du document</xsl:when>
                                                                                                                <xsl:when test="./name()='material' and ./pb">pb</xsl:when>
                                                                                                                <xsl:when test="./name()='material' and ./lb"></xsl:when>
                                                                                                                <xsl:when test="./name()='list' and not(./item/*)">(liste)</xsl:when>
                                                                                                                <xsl:when test="./name()='list' and ./item/*">(liste)</xsl:when>
                                                                                                                <xsl:when test="./name()='persName'">Personne</xsl:when>
                                                                                                                <xsl:otherwise>-</xsl:otherwise>
                                                                                                            </xsl:choose>
                                                                                                        </fo:block>
                                                                                                    </fo:table-cell>
                                                                                                    <fo:table-cell border="0.5pt solid gray">
                                                                                                        <fo:block>
                                                                                                            <xsl:choose>
                                                                                                                <xsl:when test="./name()='material' and ./damage"><xsl:value-of select="./damage/@type"/></xsl:when>
                                                                                                                <xsl:when test="./name()='material' and ./pb">???????</xsl:when>
                                                                                                                <xsl:when test="./name()='material' and ./lb"></xsl:when>
                                                                                                                <xsl:when test="./name()='list' and not(./item/*)"><xsl:for-each select="./item"><fo:block><xsl:value-of select="."/></fo:block></xsl:for-each></xsl:when>
                                                                                                                <xsl:when test="./name()='list' and ./item/*"><xsl:for-each select="./item"><fo:block><xsl:value-of select="."/></fo:block></xsl:for-each></xsl:when>
                                                                                                                <xsl:when test="./name()='persName'"><xsl:value-of select="."/></xsl:when>
                                                                                                                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                                                                                                            </xsl:choose>
                                                                                                        </fo:block>
                                                                                                    </fo:table-cell>
                                                                                                </fo:table-row>
                                                                                            </xsl:for-each>
                                                                                        </fo:table-body>
                                                                                    </fo:table>
                                                                                </xsl:when>
                                                                                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row></xsl:if>
                                                            </xsl:for-each>
                                                        </fo:table-body>
                                                    </fo:table>
                                                </fo:block>
                                            </xsl:for-each>
                                        </fo:block>
                                    </fo:block>
                                </fo:block>
                            </fo:flow>
                        </fo:page-sequence>
                    </xsl:for-each>
                    
                </fo:root>
            </xsl:result-document>
        </xsl:for-each>
        <!--Génération d'un PDF par type de @role avec, pour chaque org concerné, création d'une présentation particulière avec images des pages et transcription encodée - DEBUT-->
        
    </xsl:template>
    
    
</xsl:stylesheet>