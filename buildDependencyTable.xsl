<?xml version="1.0"?>
<!--
       '$RCSfile: buildDependencyTable.xsl,v $'
       Copyright: 1997-2002 Regents of the University of California,
                            University of New Mexico, and
                            Arizona State University
        Sponsors: National Center for Ecological Analysis and Synthesis and
                  Partnership for Interdisciplinary Studies of Coastal Oceans,
                     University of California Santa Barbara
                  Long-Term Ecological Research Network Office,
                     University of New Mexico
                  Center for Environmental Studies, Arizona State University
   Other funding: National Science Foundation (see README for details)
                  The David and Lucile Packard Foundation
     For Details: http://knb.ecoinformatics.org/

        '$Author: berkley $'
          '$Date: 2002-09-10 16:04:51 $'
      '$Revision: 1.5 $'

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:doc="eml://ecoinformatics.org/documentation-2.0.0rc1"
                version="1.0">
<xsl:output method="html" indent="yes"/>

<xsl:template match="/">
<html>
<head>
<link rel="stylesheet" type="text/css" href="default.css"/>
<title>EML Dependency Table</title>
</head>
<body class="tabledefault">
  <table border="1" cellpadding="3">
  <tr>
  <th/>
  <xsl:for-each select="//doc:module">
    <th valign="bottom" class="tablehead2">
      <xsl:call-template name="verttext">
        <xsl:with-param name="text" select="."/>
      </xsl:call-template>
    </th>
  </xsl:for-each>
  </tr>
    <xsl:for-each select="/xs:schema/xs:annotation/xs:appinfo/doc:moduleDocs/doc:module">
      <xsl:variable name="modFile">
        <xsl:value-of select="."/>
      </xsl:variable>
      <tr>

      <xsl:attribute name="class">
       <xsl:choose>
         <xsl:when test="position() mod 2 = 1">rowodd</xsl:when>
         <xsl:when test="position() mod 2 = 0">roweven</xsl:when>
       </xsl:choose>
      </xsl:attribute>

      <td><xsl:value-of select="."/></td> <!--the row header-->

        <xsl:for-each select="/xs:schema/xs:annotation/xs:appinfo/doc:moduleDocs/doc:module">
          <xsl:variable name="modName">
            <xsl:value-of select="substring-before(., '.')"/>
          </xsl:variable>
          <td align="center">
          <xsl:for-each select="document($modFile)//xs:import">
          <xsl:variable name="importedDoc">
            <xsl:value-of select="substring-before(./@schemaLocation, '.')"/>
          </xsl:variable>
          <xsl:if test="normalize-space($importedDoc)=normalize-space($modName)">
            <!--<xsl:attribute name="bgcolor">
              <xsl:text>white</xsl:text>
            </xsl:attribute>-->
            <xsl:text>X</xsl:text>
          </xsl:if>
          <xsl:if test="normalize-space($modName)=normalize-space(substring-before($modFile, '.'))">
            <xsl:attribute name="bgcolor">
              <xsl:text>black</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </xsl:for-each>
        &#160; <!--put in a nonbreaking space to create the empty cells-->
        </td>
      </xsl:for-each>
      </tr>
    </xsl:for-each>
  </table>
</body>
</html>
</xsl:template>

<!--this template makes the table headers go vertical-->
<xsl:template name="verttext">
  <xsl:param name="text"/>
  <xsl:variable name="textchar">
    <xsl:value-of select="substring($text, 1, 1)"/>
  </xsl:variable>
  <xsl:variable name="textend">
    <xsl:value-of select="substring($text, 2)"/>
  </xsl:variable>

  <xsl:value-of select="$textchar"/><br/>

  <xsl:if test="string-length($textend) > 0">
    <xsl:call-template name="verttext">
      <xsl:with-param name="text" select="$textend"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
