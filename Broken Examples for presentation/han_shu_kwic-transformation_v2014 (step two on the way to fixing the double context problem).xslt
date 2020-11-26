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

        <!--<xsl:variable name="tokenedText" select="tokenize($inputText,$keyword-active)"/>-->
        <!-- Creates a split on the keyword (also deleting the keyword) -->


                
                <!--                <xsl:for-each select="$tokenedText[position() lt last()]">-->
                <!-- Change to for each occurrance of the keyword -->

                    <!--<xsl:variable name="keywordPosition" select="position()"/>-->
                    <!-- stores the number of the chunk of text -->
                
                <!-- IMP! Now we're only getting the first one in each chapter. -->
                
                <xsl:variable name="contextPre-long" select="substring-before($inputText, $keyword-active)"/>
                <xsl:variable name="contextPost-long" select="substring-after($inputText, $keyword-active)"/>

                <xsl:variable name="contextPre"
                            select="substring($contextPre-long, string-length($contextPre-long) - ($contextLength-pre -1), $contextLength-pre)"/>
                <xsl:variable name="contextPost"
                            select="substring($contextPost-long, 1, $contextLength-post)"/>
        
        <div>
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
                <!--</xsl:for-each>-->                  
        </div>          
                
                
                <xsl:if test="contains($contextPost, $keyword-active)">
<!--                    <xsl:variable name="Dbl-contextPre"
                        select="substring($contextPre-long, string-length($contextPre-long) - ($contextLength-pre -2), ($contextLength-pre -1))"/>                 
                    <xsl:variable name="Dbl-contextPost"
                        select="substring($contextPost-long, 1, ($contextLength-post +1))"/>
                    
                    <xsl:variable name="doubleContext" select="concat($Dbl-contextPre, $Dbl-contextPost)"/>-->
                    
                    <xsl:variable name="doubleContext" select="concat($contextPre-long, $contextPost-long)"/>
                    <!-- Now, I've stiched it back together, but without the first instance of the keyword. -->
                    

                    <xsl:variable name="Dbl-contextPost-long" select="substring-after($doubleContext, $keyword-active)"/>
                    <xsl:variable name="Dbl-contextPre-long" select="substring-before($inputText, concat($keyword-active, $Dbl-contextPost-long))"/>
                    <!-- This is grabbing the string from the input text which comes before the full string of the next post-context string.  The extra keyword is added back in before the aft-string, so that it is the marker for what is not grabbed.  -->
                    
                    <xsl:variable name="contextPre"
                        select="substring($Dbl-contextPre-long, string-length($Dbl-contextPre-long) - ($contextLength-pre -1), $contextLength-pre)"/>
                    
                    <xsl:variable name="contextPost"
                        select="substring($Dbl-contextPost-long, 1, $contextLength-post)"/>
                    <!-- This time the first instance of the keyword is missing, so I have to shift the endpoints to the right to grab the correct chunk of text.  This way, I don't need to shift the left endpoint, because I've already removed the extra character; but I still need to shift the right endpoint.  I will reinsert the keyword later. -->
                    
                    
                    <div>
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
                    </div>
<!--                    <xsl:variable name="doubleContext" select="concat($contextPre, $keyword-active, $contextPost)"/>
                    <xsl:call-template name="process-the-text">
                        <xsl:with-param name="inputText" select="$doubleContext"/>
                        <xsl:with-param name="parentID" select="@id"/>
                        <xsl:with-param name="keyword-active" select="$keyword-active"/>
                    </xsl:call-template>-->
                </xsl:if>
                <!-- Above is the attempt to fix the repeating keyword problem.  What we have now should repeat the same thing... -->
                
                <xsl:if test="contains($contextPost-long, $keyword-active)">
                    <xsl:call-template name="process-the-text">
                        <xsl:with-param name="inputText" select="$contextPost-long"/>
                        <xsl:with-param name="parentID" select="@id"/>
                        <xsl:with-param name="keyword-active" select="$keyword-active"/>
                    </xsl:call-template>
                </xsl:if>
                <!-- Sets up the recursion: the template runs again on this chapter. This is called a "tail recursion"-->
                <!-- What we are doing here is using the text after to run the test again, if the text after has the keyword.  This still bugs out when the keyword shows up twice in a row, though it does give the keyword example correctly in the first instance.  What we need is to jump in before this with an 'if the keyword shows up in the contextPost, then do something special -->



    </xsl:template>

</xsl:stylesheet>
