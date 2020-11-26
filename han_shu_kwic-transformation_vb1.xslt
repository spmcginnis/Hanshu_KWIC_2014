<?xml version="1.0" encoding="UTF-8"?>

<!-- 
Revision: 2013 June 10 spm, created
Revision: 2013 June 12 spm, changed to have <div type="juan"> instead of <juan> in the input document.

Changes needed:
- cut at full stops
- center on the keyword
- deal with double cuts
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="" xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output indent="yes" encoding="UTF-8" method="xhtml"/>

    <xsl:variable name="title" select="'KWIC Visualization'"/>

<!-- This section sets the paramaters for search 1 -->
    <xsl:param name="keyword01" select="'通'"/>
    <!-- the keyword.  These are parameters so they can be passed in and out of the template.  Click the wrench in debugger ... these values can be changed in the output without chaning the xstl sheet.  In other words, the value here (i.e. 通) is now a default value that can be changed, making oxygen function like a search engine.-->
    
    <xsl:param name="keyword01pinyin" select="'Tong'"/>
    <!-- The pinyin Romanization of the keyword -->

    <xsl:param name="keyword01gloss" select="'to gain passage; a penetrating understanding'"/>
    <!-- Gloss of the keyword in English -->

    <xsl:param name="textName-AA" select="'Han shu 漢書'"/>
    <xsl:param name="textAbbr-AA" select="'HS'"/>
    <!-- The name of the text -->
    <xsl:variable name="subtitle1">
    <!-- This variable will set the title according to the information above. -->
        <xsl:text>Occurrences of </xsl:text>
        <xsl:value-of select="$keyword01"/>
        <xsl:text> ["</xsl:text>
        <xsl:value-of select="$keyword01pinyin"/>
        <xsl:text>" </xsl:text>
        <xsl:value-of select="$keyword01gloss"/>
        <xsl:text>] in the </xsl:text>
        <xsl:value-of select="$textName-AA"/>
    </xsl:variable>
<!-- End sections setting the parameters for search 1 -->

<!-- This section sets the parameters for search 2 -->
    <xsl:param name="keyword02" select="'知'"/>
    <xsl:param name="keyword02pinyin" select="'Zhi'"/>    
    <xsl:param name="keyword02gloss" select="'to know, to understand; wisdom (智), knowledge'"/>    
    <xsl:param name="textName-AB" select="'Han shu 漢書'"/>
    <xsl:param name="textAbbr-AB" select="'HS'"/>
    <xsl:variable name="subtitle2">
        <!-- This variable will set the title according to the information above. -->
        <xsl:text>Occurrences of </xsl:text>
        <xsl:value-of select="$keyword02"/>
        <xsl:text> ["</xsl:text>
        <xsl:value-of select="$keyword02pinyin"/>
        <xsl:text>" </xsl:text>
        <xsl:value-of select="$keyword02gloss"/>
        <xsl:text>] in the </xsl:text>
        <xsl:value-of select="$textName-AB"/>
    </xsl:variable>
<!-- End sections setting the parameters for search 2 -->

    <xsl:variable name="contextLength-pre" select="7"/>
    <xsl:variable name="contextLength-post" select="7"/>
    <!-- The preceeding two variables set the length of the context (before and after) around the keyword. Note that, when counting backwards, it is easy to get an 'off by one' error. Be sure to add or subtract from 1, not 0. -->

    <xsl:variable name="currentDate">
        <xsl:value-of select="format-date(current-date(), '[Y] [MNn] [D]')"/>
    </xsl:variable>

    <xsl:template match="/">
        <html>
            <head>
                <style type="text/css">
                    body {background-color:#f0f0f0;}
                    p {
                        font-size: 1.3em;
                    }
                    span.textBefore{
                        color:#909090;
                    }
                    span.keyword{
                        font-weight:bold;
                    }
                    span.textAfter{
                        color:00a0a0;
                    }
                    span.citation{
                        font-size: .8em;
                        font-variant:small-caps;
                    }
                    div {
                        background-color:#f0f0f0;
                        text-align:center;
                    }
                    #wrapper{
                        margin:1% auto;
                        padding-top:4%;
                        width:1200px;

                    }
                    #leftPanel, #rightPanel {
                        height:700px;
                        overflow:auto;
                        width:49%;
                        border-left-style:dashed;
                        border-left-width:12px;
                        border-left-color:#c8c8c8;
                        }
                    #leftPanel{
                        float:left;
                        }
                    #rightPanel{
                        float:right;
                        }
                    h2 {font-size:1.5em;}
                    #title {text-align:left;}
                    
                </style>
                <title>
                    <xsl:value-of select="$title"/>
                </title>
            </head>
            <body>
                <div id="wrapper">
<!-- this is the section for displaying the results of search 1 -->
                    <h2 id="title">Keyword in context visualization using XSLT<br/>Scott Paul McGinnis<br/><xsl:value-of select="$currentDate"></xsl:value-of></h2>
                    <div id="leftPanel">
                        <h2><xsl:value-of select="$title"/>:</h2>
                        <h3>
                            <xsl:value-of select="$subtitle1"/>
                        </h3>
                        <xsl:for-each select="//div[@type='juan' and contains(., $keyword01)]">
                            <xsl:call-template name="process-the-text">
                                <xsl:with-param name="inputText" select="normalize-space(string(.))"/>
                                <!-- Converts to a string (which removes elements), and removes whitespace, just in case. -->
                                <xsl:with-param name="parentID" select="@id"/>
                                <xsl:with-param name="keyword-active" select="$keyword01"/>
                                <!-- This parameter sets the active keyword in the template during the current applying of the template -->
                            </xsl:call-template>
                        </xsl:for-each>
                    </div>
<!-- begin the section for displaying the results of search 2 -->
                    <div id="rightPanel">
                        <h2><xsl:value-of select="$title"/>:</h2>
                        <h3>
                            <xsl:value-of select="$subtitle2"/>
                        </h3>
                        <xsl:for-each select="//div[@type='juan' and contains(., $keyword02)]">
                            <!-- contains(A, B) does A contain B?  Do I contain keyword2? -->
                            <xsl:call-template name="process-the-text">
                                <xsl:with-param name="inputText" select="normalize-space(string(.))"/>
                                <!-- Converts to a string (which removes elements), and removes whitespace, just in case. -->
                                <!-- Here "with" means "using" -->
                                <xsl:with-param name="parentID" select="@id"/>
                                <xsl:with-param name="keyword-active" select="$keyword02"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="process-the-text">
        <xsl:param name="inputText"/>
        <!-- This is just declaring that there is a parameter called "input text."  What this parameter does is defined above, in the call-template element.  For example, below we see that there is a parameter "Keyword active" declared.  Above, the keyword-active is set as either $keyword01 or keyword02, depending on what we want to use. -->
        <!-- Use the parameter value that is given when the call is made?  e.g. in the call-template element above, the select="" value is brought into play in this template during the active applying of the template. -->
        <xsl:param name="parentID"/>
        <xsl:param name="keyword-active"/>

        <xsl:variable name="tokenedText" select="tokenize($inputText,$keyword-active)"/>
        <!-- Creates a split on the keyword (also deleting the keyword) -->


<!--        <xsl:if test="count($tokenedText) lt $contextLength-post">
            <xsl:text>DEBUG: TEST TEST TEST</xsl:text>
        </xsl:if>-->


        <!--<xsl:if test="count($tokenedText) gt 1">-->
        <!-- checks for a split.  If there is only one text chunk (node?), then it knows the section does not have our keyword (because it has not been split).  If there is more than one, then we know it does have the keyword, because there is a split.   Is this necessary?  In the function call, we are only applying this template to sections which have the word we want.  Turns out that this is unnecessary.-->

            <div>
                <xsl:for-each select="$tokenedText[position() lt last()]">
                <!-- everything but the last chunk of tokened text -->

                    <xsl:variable name="tokenedText-number" select="position()"/>
                    <!-- stores the number of the chunk of text -->

                    <xsl:variable name="contextPre"
                        select="substring(., string-length(.) - ($contextLength-pre -1), $contextLength-pre)"/>
                    <xsl:variable name="contextPost"
                        select="substring(., 1, $contextLength-post)"/>
                    <!-- here is our error.  It is counting one too early. It is taking the beginning of the same chunk instead of the beginning of the next chunk.  Instead of "." we need ".+1", attempting substring-after() -->
                    <p>
                        <span class="textBefore"><xsl:value-of select="$contextPre"/></span>
                        <span class="keyword"><xsl:value-of select="$keyword-active"/></span>
                        <span class="textAfter"><xsl:value-of select="$contextPost"/></span>
                        <span class="citation">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="$textAbbr-AA"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$parentID"/>
                            <xsl:text>)</xsl:text>
                        </span>
                    </p>
                </xsl:for-each>
            </div>
        <!--</xsl:if>-->
    </xsl:template>
</xsl:stylesheet>
