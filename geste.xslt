<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="1.0">
<!--
    Author : Ariane Pinche
    Edited by: JBC
-->
    
    
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!--<xsl:template match="text()">
        <xsl:if test="not(normalize-space()='')"><xsl:copy/></xsl:if>
    </xsl:template>-->

    <xsl:template match="tei:body">
        <section>
            <aside class="pull-right">
                <div class="btn-group">
                    <button type="button" class="btn btn-success" id="fac"
                        >Allographétique</button>
                    <button type="button" class="btn btn-default" id="reg"
                        >Graphématique</button>
                </div>
            </aside>
            <xsl:apply-templates/>
            <footer class="row">
                <hr class="information-hr" title="notes de bas de page"/>
                <div class="col-md-7 col-md-push-2">
                    <ul class="list-unstyled">
                        <!--<xsl:apply-templates select="//tei:text//tei:witDetail"
                            mode="notesbasdepage"/>-->
                        <xsl:apply-templates select="descendant::tei:note | descendant::tei:witDetail" mode="notesbasdepage"/>
                    </ul>
                </div>
            </footer>
        </section>
    </xsl:template>



    <xsl:template match="tei:body/tei:div">
        <xsl:element name="div">
            <xsl:call-template name="id"/>
            <xsl:element name="h1">
                <xsl:value-of select="tei:head"/>
                <xsl:text>&#160;</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="./tei:div"/>
       </xsl:element>
    </xsl:template>


    <xsl:template match="tei:l">
        <xsl:element name="li">
            <xsl:attribute name="n">
                <xsl:value-of select="@n"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:lg">
        <xsl:element name="ol">
            <xsl:attribute name="n">
                <xsl:value-of select="@n"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:p">
        <xsl:element name="div">
            <xsl:apply-templates/>
        </xsl:element>
        <!--<xsl:element name="br"/>-->
    </xsl:template>

    <!-- saut de page et de colonne + espace -->
    
    <!-- JBC: je modifie un peu cela selon mes conventions -->

    <xsl:template match="tei:lb">
        <xsl:element name="br"/>
    </xsl:template>

    <xsl:template match="tei:cb">
        <!--<hr class="information-hr orig" title="Colonne {@n}"/>-->
        <span><!-- class="reg orig">-->
            <xsl:text> [ col. </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text> ] </xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="tei:pb">
        <!--<hr class="information-hr orig" title="Folio {@n}"/>-->
        <span><!-- class="reg orig">-->
            <xsl:text> [ fol. </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text> ] </xsl:text>
        </span>
    </xsl:template>
    
    <!-- JBC: j'ajoute les changements de cahier -->
    
    <xsl:template match="tei:gb">
        <span><!-- class="reg orig">-->
            <xsl:text> [ cah. </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text> ] </xsl:text>
        </span>
    </xsl:template>
    
    <!-- fin saut de page et de colonne -->

    <!-- éléments à affichier pour la visualisation facsimilaire -->
    <xsl:template match="tei:orig">
        <xsl:element name="span">
            <xsl:attribute name="class">orig</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:abbr">
        <xsl:element name="span">
            <xsl:attribute name="class">abbr</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:pc">
        <xsl:element name="span">
            <xsl:attribute name="class">orig</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- éléments de mise en page du manuscrit -->
    
    
    
    <!-- JBC: pas besoin pour le moment -->
    <!--<xsl:template match="tei:rdg[@rend]">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>-->

    <xsl:template match="tei:hi[@rend]">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
    <!-- JBC: j'aligne cela sur ma pratique -->
    <xsl:template match="tei:add"><!--[@place]">-->

        <xsl:element name="span">
            <xsl:attribute name="class">underline</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>
    <!-- JBC: modifié selon mes conventions -->
    <xsl:template match="tei:gap"><!--[@reason='lacuna']">-->
        <xsl:choose>
        <xsl:when test="@unit='fol'">
            <!--<xsl:text>\skipnumbering \dots \dots \dots \dots</xsl:text>-->
        </xsl:when>
        <xsl:when test="@unit='char'">
            <xsl:variable name="quantite">
                <xsl:choose>
                    <xsl:when test="@min and @max">
                        <xsl:value-of select="(@min + @max) div 2 "/>
                    </xsl:when>
                    <xsl:when test="@quantity">
                        <xsl:value-of select="@quantity"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <!-- JBC: ne marche pas en 1.0 (XPath 2.0) -->
            <!--<xsl:value-of select="for $i in 1 to $quantite
                return '.'
                "/>-->
            <!-- Donc, il faut alourdir le code  -->
            <xsl:call-template name="repetition">
                <xsl:with-param name="quantite" select="$quantite"/>
                <xsl:with-param name="chaine"><xsl:text>.</xsl:text></xsl:with-param>
            </xsl:call-template>
            
        </xsl:when>
        </xsl:choose> 
       
    </xsl:template>
    <xsl:template name="repetition">
        <xsl:param name="quantite"/>
        <xsl:param name="chaine"/>
        
        <xsl:if test="$quantite > 0">
            <xsl:call-template name="repetition">
                <xsl:with-param name="quantite" select="$quantite - 1"/>
                <xsl:with-param name="chaine" select="$chaine"/>
            </xsl:call-template>
            <xsl:value-of select="$chaine"/>
        </xsl:if>
        
    </xsl:template>
    
    
    <xsl:template match="tei:corr">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>corr</xsl:text>
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- JBC: idem -->
    <xsl:template match="tei:del">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>del</xsl:text>
                <!--<xsl:value-of select="@rend"/>-->
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:metamark">
        <span class="information-hr metamark" title="{@function}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- JBC: j'ajoute space -->
    <xsl:template match="tei:space">
        <xsl:element name="span">
            <xsl:attribute name="class">space</xsl:attribute>
            <xsl:choose>
                <xsl:when test="@quantity='0.5'">
                    <xsl:text>&#8239;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="repetition">
                        <xsl:with-param name="quantite" select="@quantity"/>
                        <xsl:with-param name="chaine">
                            <xsl:text> </xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <!-- fin de éléments de mise en page du manuscrit -->
    

    <!-- fin éléments à afficher pour la visualisation facsimilaire -->

    <!-- éléments à affichier pour la visualisation normalisée -->
    <xsl:template match="tei:reg">
        <xsl:element name="span">
            <xsl:attribute name="class">reg</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:expan">
        <xsl:element name="span">
            <xsl:attribute name="class">expan</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:ex">
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:text>margin-left: 0;</xsl:text>
                <xsl:text>background-color:#c5e88f;</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--<xsl:template match="tei:pc[@type='reg']">
        <span class="reg">
            <xsl:apply-templates/>
        </span>
    </xsl:template>-->
    <xsl:template match="tei:pc[@type='supplied']">
        <xsl:element name="span">
            <xsl:attribute name="class">reg</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- fin éléments à affichier pour la visualisation normalisée -->
    
    <!-- JBC: autres éléments éditoriaux et graphiques -->
    <!-- gestion fine de l'espacement dans les textes tokénisés -->
    <xsl:template match="tei:w">
        <xsl:apply-templates/>
        <xsl:choose>
            <xsl:when test="@rend = 'elision'">
                <xsl:element name="span">
                    <xsl:attribute name="classe">reg</xsl:attribute>
                    <xsl:text>'</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@rend = 'aggl'">
                <xsl:element name="span">
                    <xsl:attribute name="classe">reg</xsl:attribute>
                    <xsl:text> </xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- JBC: traitement ponctuation à affiner -->
                <xsl:if test="not(local-name(following::*[1]) = 'note' 
                    or
                    following::*[1] = ','
                    )">
                    <xsl:element name="span">
                        <xsl:text> </xsl:text>
                    </xsl:element>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- JBC: passages de lecture difficile -->
    
    <xsl:template match="tei:unclear">
        <xsl:element name="span">
            <xsl:attribute name="class">unclear</xsl:attribute>
            <xsl:attribute name="title">Lecture difficile (<xsl:value-of select="@reason"/>)</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
        <!-- TODO: traiter les différentes valeurs d'unclear prévues par le modèle -->
    </xsl:template>
    
    <!-- JBC: mise en forme texte basique, pour les notes, etc. -->
    <xsl:template match="tei:mentioned">
        <xsl:element name="span">
            <xsl:attribute name="class">mentioned</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    

    <!-- fin édition mode visualisation par témoin -->

    <!-- Footer starts -->
    
    <!-- JBC: pour le moment, je traite les witDetail et note d'une traite, mais ce sera à
    affiner
    -->
    <xsl:template match="tei:witDetail | tei:note ">

        <xsl:variable name="pos">
            <xsl:number count="tei:witDetail | tei:note" level="any" from="tei:text"/>
        </xsl:variable>

        <xsl:variable name="infobulle" select="normalize-space(.)"/>
        <sup>
            <a name="appelnote{$pos}" href="#textenote{$pos}" title="{$infobulle}">
                <xsl:value-of select="$pos"/>
            </a>
        </sup>
        <xsl:element name="span">
            <xsl:text> </xsl:text>
        </xsl:element>
    </xsl:template>


    <xsl:template match="tei:witDetail | tei:note " mode="notesbasdepage">
        <xsl:variable name="pos">
            <xsl:number count="tei:witDetail | tei:note" level="any" from="tei:text"/>
        </xsl:variable>
        <li>
            <a name="textenote{$pos}" href="#appelnote{$pos}">
                <xsl:value-of select="$pos"/>
            </a>
            <xsl:text>. </xsl:text>
            <!--<xsl:value-of select="."/>-->
            <xsl:apply-templates/><!-- JBC: mode 'note' à créer sans doute -->
        </li>
    </xsl:template>


    <!-- Header ends -->

    <!-- templates -->
    <!-- règles de numérotation des vers -->

   <!--     <xsl:template name="ol">
        <xsl:element name="ol">
            <xsl:attribute name="start">
                <xsl:value-of select="./tei:l[1]/@n"/>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:text>norm</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    -->

    <!-- attribution des id -->
    <xsl:template name="id">
        <xsl:attribute name="id">
            <xsl:value-of select="@type"/>

                    <xsl:value-of select="@n"/>

        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>