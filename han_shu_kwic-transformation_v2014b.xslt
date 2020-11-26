<?xml version="1.0" encoding="UTF-8"?>

<!-- 
Revision: 2013 June 10 spm, created
Revision: 2013 June 12 spm, changed to have <div type="juan"> instead of <juan> in the input document.
Revision: 2014 Feb. 15 spm, fixed the ordering bug.  Adding recursion to fix the multiple occurrances bug.  Fixed it for two in a row, but when I went to add in for three or more occurrances, the recursion started skipping around weirdly.  Unresolved.]
Revision 2014 Feb. 16 spm, new version branched, rewrote the templates, solved recursion problem.  Much simpler and more elegant now.  Also works with two or more words in a phrase.  Possibly also with regex could find parallel phrases that have some variation (for example, in whether it uses a preposition such as 於).


Changes needed:
- center on the keyword (css)
- deal with recursion skipping.  fixed

Other to do:
- explore the uses of the document() function in trying to compare from multiple texts.
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
<!-- I can probably use the document() function to do a comparison from multiple files.  -->

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

    <xsl:variable name="contextLength-pre" select="12"/><!-- works with 7, trying 12; works with 12 -->
    <xsl:variable name="contextLength-post" select="12"/>
    <!-- The preceeding two variables set the length of the context (before and after) around the keyword. Note that, when counting backwards, it is easy to get an 'off by one' error. Be sure to add or subtract from 1, not 0. -->

    <xsl:variable name="currentDate">
        <xsl:value-of select="format-date(current-date(), '[Y] [MNn] [D]')"/>
    </xsl:variable>

    <xsl:template match="/">
        <html>
            <xsl:call-template name="htmlHeader"/>

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
                                <xsl:with-param name="sourceText" select="normalize-space(string(.))"/>
                                <xsl:with-param name="nthText" select="normalize-space(string(.))"/>
                                <!-- Converts to a string (which removes elements), and removes whitespace, just in case. -->
                                <xsl:with-param name="parentID" select="@id"/>
                                <xsl:with-param name="nameZH" select="@nameZH"/><!-- Not working?! -->
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
                                <xsl:with-param name="sourceText" select="normalize-space(string(.))"/>
                                <xsl:with-param name="nthText" select="normalize-space(string(.))"/>
                                <!-- Converts to a string (which removes elements), and removes whitespace, just in case. -->
                                <!-- Here "with" means "using" -->
                                <xsl:with-param name="parentID" select="@id"/>
                                <xsl:with-param name="nameZH" select="@nameZH"/><!-- Not working?! -->
                                <xsl:with-param name="keyword-active" select="$keyword02"/>
                                <!-- Here I need to pass through the parameter for text-abbr AB -->
                            </xsl:call-template>
                        </xsl:for-each>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="process-the-text">
        <xsl:param name="sourceText"/>
        <xsl:param name="nthText"/>
        <!-- at this point, the source text and the nth text are the same; but the nthText will change through any recursions -->
        <xsl:param name="parentID"/>
        <xsl:param name="nameZH"/>
        <xsl:param name="keyword-active"/>
        <!-- These are just declaring that there is a parameter called "input text."  What this parameter does is defined above, in the call-template element.  For example, below we see that there is a parameter "Keyword active" declared.  Above, the keyword-active is set as either $keyword01 or keyword02, depending on what we want to use.  One use for this is to pass a variable from the parent template to this one. -->
        
        <xsl:variable name="sourceText86ed" select="concat($sourceText, '86')"/>
        <!-- Here I am adding '86' to the end of the text, to deal with the section-end error, that is, the problem that would otherwise occur in the keyword happened at the end of a section.  Before, there was a potential to have an aftContext-full that would be found earlier in the sourceText, meaning that we could get an erroneous output.  For example, imagine that a section ends with the substring 通也。 It would give us the aftContext-full = 也。 which might match elsewhere in the text when we contruct our foreContext. [I tested this, and it does indeed happen, though it would be rare.] But now, the aftContext-full will end with the string '通也。86', and since the string 也。86 will not be found in the text (since 86 is not a valid classical Chinese string), it won't produce any false positives. -->
        
        <xsl:variable name="aftContext-full" select="substring-after($nthText, $keyword-active)"/>
        <xsl:variable name="foreContext-full" select="substring-before($sourceText86ed, concat($keyword-active, $aftContext-full, '86'))"/>
        <!-- By adding the 86 here (instead of on the aftContext-full or the $nthText), I ensure that the number is not carried through to the output. -->
    
        <xsl:variable name="foreContext" select="substring($foreContext-full, string-length($foreContext-full) - ($contextLength-pre -1), $contextLength-pre)"/>
        <xsl:variable name="aftContext" select="substring($aftContext-full, 1, $contextLength-post)"/>
       
        <xsl:call-template name="textOutput">
            <xsl:with-param name="parentID" select="$parentID"/>
            <xsl:with-param name="foreContext" select="$foreContext"/>
            <xsl:with-param name="keyword-active" select="$keyword-active"/>
            <xsl:with-param name="aftContext" select="$aftContext"/>
            <xsl:with-param name="nameZH" select="$nameZH"/>
        </xsl:call-template>
        <xsl:if test="contains($aftContext-full, $keyword-active)">
            <!-- This tests whether the remaining text includes the keyword. If it does, it calls the template again.  If not, we go back to the root template, which will take us to the next section (juan) of text. Note, it passes the sourcetext86ed through so that we don't add a bunch of 868686 to the end.  This probably wouldn't hurt, but I think it's better not to add unnecessary junk.  More importantly, it sets the nthText to equal our truncated aftercontext.  So each time it runs, it lops off the nthtext up to the next occurrance of the keyword -->
            <xsl:call-template name="process-the-text">
                <xsl:with-param name="sourceText" select="$sourceText86ed"/>
                <xsl:with-param name="parentID" select="$parentID"/>
                <xsl:with-param name="keyword-active" select="$keyword-active"/>
                <xsl:with-param name="nthText" select="$aftContext-full"/>
                <xsl:with-param name="nameZH" select="$nameZH"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="textOutput">
        <xsl:param name="parentID"/>
        <xsl:param name="foreContext"/>
        <xsl:param name="keyword-active"/>
        <xsl:param name="aftContext"/>
        <xsl:param name="nameZH"/>
        <div>
            <span class="textBefore"><xsl:value-of select="$foreContext"/></span>
            <span class="keyword"><xsl:value-of select="$keyword-active"/></span>
            <span class="textAfter"><xsl:value-of select="$aftContext"/></span>
            <span class="citation">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="$textAbbr-AA"/><!-- I need to make this match the correct text name. -->
                <xsl:text> </xsl:text>
                <xsl:value-of select="$parentID"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$nameZH"/>
                <xsl:text>)</xsl:text>
            </span>
            <!-- Instet a counter here: <xsl:variable name="word-count" select="$word-count+1"/> But how to pass that value back out to the root template?  Should I be using a parameter?  Or a global variable? -->
        </div>
    </xsl:template>
    
    <xsl:template name="htmlHeader">
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
    </xsl:template>
    
</xsl:stylesheet>
