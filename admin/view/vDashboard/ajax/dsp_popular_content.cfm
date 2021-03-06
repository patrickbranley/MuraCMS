<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfinclude template="../act_defaults.cfm">
<cfoutput><cfset rsList=application.dashboardManager.getTopContent(attributes.siteID,3,false,"All",attributes.startDate,attributes.stopDate,true) />
<cfset count=rsList.recordcount>
<table class="mura-table-grid stripe" id="topPages">
<tr>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.pages")# <a href="index.cfm?fuseaction=cDashboard.topContent&siteid=#URLEncodedFormat(attributes.siteid)#&startDate=#URLEncodedFormat(attributes.startDate)#&stopDate=#URLEncodedFormat(attributes.stopDate)#">(#application.rbFactory.getKeyValue(session.rb,"dashboard.viewreport")#)</a></th>
</tr>
<cfloop query="rslist">
<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
	<td><cfswitch expression="#rslist.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,rsList.filename)#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,30-len(rsList.hits)))#</a>
		</cfcase>
		<cfcase value="Link">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('#rslist.filename#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,30-len(rsList.hits)))#</a>
		</cfcase>
		<cfcase value="File">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#rslist.contentid#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,30-len(rsList.hits)))#</a>
		</cfcase>
		</cfswitch> <span>(#rsList.hits# #application.rbFactory.getKeyValue(session.rb,"dashboard.views")#)</span></td>
</tr>
</cfloop>
<cfif count eq 0><tr class="alt"><td>&mdash;</td></tr></cfif>
<cfif count lt 2><tr><td>&mdash;</td></tr></cfif>
<cfif count lt 3><tr class="alt"><td>&mdash;</td></tr></cfif>
</table>
<!---
<cfset rsList=application.dashboardManager.getTopReferers(attributes.siteID,3,attributes.startDate,attributes.stopDate) />
<cfset count=rsList.recordcount>
<table id="topReferrers">
<tr>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.topreferrers")# <a href="index.cfm?fuseaction=cDashboard.topReferers&siteid=#URLEncodedFormat(attributes.siteid)#&startDate=#URLEncodedFormat(attributes.startDate)#&stopDate=#URLEncodedFormat(attributes.stopDate)#">(#application.rbFactory.getKeyValue(session.rb,"dashboard.viewreport")#)</a></th>
</tr>
<cfloop query="rslist">
<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
	<td><cfif rsList.referer neq 'Unknown'><a title="View" href="javascript:preview('#rsList.referer#','');">#left(rsList.referer,30-len(rslist.referals))#&hellip;</a><cfelse>#rsList.referer#</cfif> <span>(#rslist.referals# #application.rbFactory.getKeyValue(session.rb,"dashboard.referrals")#)</span></td>
</tr>
</cfloop>
<cfif count eq 0><tr class="alt"><td>&mdash;</td></tr></cfif>
<cfif count lt 2><tr><td>&mdash;</td></tr></cfif>
<cfif count lt 3><tr class="alt"><td>&mdash;</td></tr></cfif>
</table>
--->
<cfset rsList=application.dashboardManager.getTopKeywords(attributes.siteID,3,false,"All",attributes.startDate,attributes.stopDate) />
<cfset count=rsList.recordcount>
<table class="mura-table-grid stripe" id="topSearches">
<tr>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.topsearches")# <a href="index.cfm?fuseaction=cDashboard.topSearches&siteid=#URLEncodedFormat(attributes.siteid)#&startDate=#URLEncodedFormat(attributes.startDate)#&stopDate=#URLEncodedFormat(attributes.stopDate)#">(View Report)</a></th>
</tr>
<cfloop query="rslist">
<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
	<td>#left(rsList.keywords,30-len(rsList.keywordCount))# <span>(#rsList.keywordCount# #application.rbFactory.getKeyValue(session.rb,"dashboard.searches")#)</span></td>
</tr>
</cfloop>
<cfif count eq 0><tr class="alt"><td>&mdash;</td></tr></cfif>
<cfif count lt 2><tr><td>&mdash;</td></tr></cfif>
<cfif count lt 3><tr class="alt"><td>&mdash;</td></tr></cfif>
</table>
<!---
<cfset rsList=application.dashboardManager.getTopRated(attributes.siteID,attributes.threshold,3,attributes.startDate,attributes.stopDate) />
<cfset count=rsList.recordcount>
<table id="topRated">
<tr>
	<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.toprated")# <a href="index.cfm?fuseaction=cDashboard.topRated&siteid=#URLEncodedFormat(attributes.siteid)#&startDate=#URLEncodedFormat(attributes.startDate)#&stopDate=#URLEncodedFormat(attributes.stopDate)#">(View Report)</a></th>
</tr>
<cfloop query="rslist">
<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
	<td><cfswitch expression="#rslist.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,rsList.filename)#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,28))#</a>
		</cfcase>
		<cfcase value="Link">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('#rslist.filename#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,28))#</a>
		</cfcase>
		<cfcase value="File">
		<a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#rslist.contentid#','#rslist.targetParams#');">#HTMLEditFormat(left(rslist.menutitle,28))#</a>
		</cfcase>
		</cfswitch> <img src="images/rater/star_#application.raterManager.getStarText(rslist.theAvg)#.gif"/></td>
</tr>
</cfloop>
<cfif count eq 0><tr class="alt"><td>&mdash;</td></tr></cfif>
<cfif count lt 2><tr><td>&mdash;</td></tr></cfif>
<cfif count lt 3><tr class="alt"><td>&mdash;</td></tr></cfif>
</table>
--->
</cfoutput>

