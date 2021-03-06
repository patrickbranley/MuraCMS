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
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.fieldList="tusers.userID, tusers.GroupName, tusers.Fname, tusers.Lname, tusers.UserName, tusers.PasswordCreated, tusers.Email, tusers.Company, tusers.JobTitle, tusers.MobilePhone, tusers.Website, tusers.Type, tusers.subType, tusers.ContactForm, tusers.S2, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy, tusers.LastUpdateByID, tusers.Perm, tusers.InActive, tusers.IsPublic, tusers.SiteID, tusers.Subscribe, tusers.Notes, tusers.description, tusers.Interests, tusers.keepPrivate, tusers.PhotoFileID, tusers.IMName, tusers.IMService, tusers.Created, tusers.RemoteID, tusers.Tags, tusers.tablist, tfiles.fileEXT photoFileExt">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
		<cfset variables.settingsManager=arguments.settingsManager />
<cfreturn this />
</cffunction> 

<cffunction name="getUserGroups" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfargument name="isPublic" type="numeric" default="0" />
	<cfset var rs = "" />
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT tusers.UserID, tusers.Email, tusers.GroupName, tusers.Type, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy, 
	tusers.LastUpdateByID, memberQuery.Counter, tusers.Perm, tusers.isPublic
	FROM tusers LEFT JOIN 
	(select tusersmemb.groupID, count(tusersmemb.groupID) Counter
	from tusersmemb inner join tusers on (tusersmemb.userID=tusers.userID)
	where
	tusers.siteid = <cfif arguments.isPublic eq 0 >
		'#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
		<cfelse>
		'#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
		</cfif>
	group by tusersmemb.groupID
	) memberQuery ON tusers.UserID = memberQuery.GroupID
	WHERE tusers.Type=1 and tusers.isPublic=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isPublic#"> and 
	tusers.siteid = <cfif arguments.isPublic eq 0 >
		'#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
		<cfelse>
		'#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
		</cfif>
	Order by tusers.perm desc, tusers.GroupName
	</cfquery>
	
	<cfreturn rs />
</cffunction> 

<cffunction name="getSearch" returntype="query" access="public" output="false">
	<cfargument name="search" type="string" default="" />
	<cfargument name="siteid" type="string" default="" />
	<cfargument name="isPublic" type="numeric" default="0" />
	<cfset var rs = "" />

	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	Select #variables.fieldList# from tusers 
	left join tfiles on tusers.photofileID=tfiles.fileID
	where tusers.type=2 and tusers.isPublic = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isPublic#"> and 
	tusers.siteid = <cfif arguments.isPublic eq 0 >
		'#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
		<cfelse>
		'#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
		</cfif> 
		
	<cfif arguments.search eq ''>
		and 0=1
	</cfif>
	
	 and (
	 		tusers.lname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or tusers.fname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or tusers.company like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or tusers.username like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or tusers.email like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or tusers.jobtitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">)
	 
	<cfif not listFind(session.mura.memberships,'S2')> and tusers.s2=0 </cfif> order by tusers.lname
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getAdvancedSearch" returntype="query" access="public" output="false">
	<cfargument name="data" type="any" default="" hint="This can be a struct or an instance of userFeedBean."/>
	<cfargument name="siteid" type="any" hint="deprecated, use userFeedBean.setSiteID()" default=""/>
	<cfargument name="isPublic" type="any" hint="deprecated, use userFeedBean.setIsPublic()" default=""/>
	
	<cfset var i = 1 />
	<cfset var params=""  />
	<cfset var param="" />
	<cfset var paramNum=0 />
	<cfset var started=false />
	<cfset var jointables="" />
	<cfset var jointable="">
	<cfset var openGrouping =false />
	<cfset var userPoolID="">
	<cfset var rs=""/>
	<cfset var rsParams="">
	<cfset var sortOptions="fname,lname,username,company,lastupdate,created,isPubic,email">
	<cfset var isExtendedSort="">
	<cfset var isListParam=false>

	<cfif not isObject(arguments.data)>
		<cfset params=getBean("userFeedBean")>
		<cfset params.setParams(data)>
		<cfif isNumeric(arguments.isPublic)>
			<cfset params.setIsPublic(arguments.isPublic)>
		</cfif>
	<cfelse>
		<cfset params=arguments.data>
	</cfif>
	

	<cfset isExtendedSort=(not listFindNoCase(sortOptions,params.getSortBy()))>
	
	<cfif len(arguments.siteID)>
		<cfset params.setSiteID(arguments.siteID)>
	</cfif>
	
	<cfif isNumeric(arguments.isPublic)>
		<cfset params.setIsPublic(arguments.isPublic)>
	</cfif>
	
	<cfif params.getIsPublic() eq 0 >
		<cfset userPoolID=variables.settingsManager.getSite(params.getSiteID()).getPrivateUserPoolID()>
	<cfelse>
		<cfset userPoolID=variables.settingsManager.getSite(params.getSiteID()).getPublicUserPoolID()>
	</cfif>
	
	<cfset rsParams=params.getParams() />
	
	<cfloop query="rsParams">
		<cfif listLen(rsParams.field,".") eq 2>
			<cfset jointable=listFirst(rsParams.field,".") >
			<cfif jointable neq "tusers" and not listFind(jointables,jointable)>
				<cfset jointables=listAppend(jointables,jointable)>
			</cfif>
		</cfif>
	</cfloop>

	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	Select #variables.fieldList# from tusers 
	left join tfiles on tusers.photofileID=tfiles.fileID
	<cfloop list="#jointables#" index="jointable">
	inner join #jointable# on (tusers.userid=#jointable#.userid)
	</cfloop>
	
	<cfif isExtendedSort>
	left Join (select 
			
			#variables.classExtensionManager.getCastString(data.getSortBy(),data.getSiteID())# extendedSort
			 ,tclassextenddata.baseID 
			from tclassextenddatauseractivity inner join tclassextendattributes
			on (tclassextenddatauseractivity.attributeID=tclassextendattributes.attributeID)
			where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#data.getSiteID()#">
			and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#data.getSortBy()#">
	) qExtendedSort
	
	on (tusers.userID=qExtendedSort.baseID)
	</cfif>
	
	where tusers.type=2 and tusers.isPublic =#params.getIsPublic()# and 
	tusers.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userPoolID#">
		
		<cfif rsParams.recordcount>
		<cfset started = false />
		<cfloop query="rsParams">
			<cfset param=createObject("component","mura.queryParam").init(rsParams.relationship,
					rsParams.field,
					rsParams.dataType,
					rsParams.condition,
					rsParams.criteria
				) />
								 
			<cfif param.getIsValid()>	
				<cfif not started >
					and (
				</cfif>
				<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
					(
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
					<cfif started>or</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
					<cfif started>and</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
					)
				<cfelse>
					<cfif not openGrouping and started>
						#param.getRelationship()#
					<cfelse>
						<cfset openGrouping=false />
					</cfif>
				</cfif>
				
				<cfset started = true />
				<cfset isListParam=listFindNoCase("IN,NOT IN",param.getCondition())>		
				<cfif  listLen(param.getField(),".") gt 1>					
					#param.getField()# #param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif>  	
				<cfelseif len(param.getField())>
					tusers.userid IN (
						select tclassextenddatauseractivity.baseID from tclassextenddatauseractivity
						<cfif isNumeric(param.getField())>
						where tclassextenddatauseractivity.attributeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
						<cfelse>
						inner join tclassextendattributes on (tclassextenddatauseractivity.attributeID = tclassextendattributes.attributeID)
						where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.getSiteID()#">
						and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
						</cfif>
						and #variables.classExtensionManager.getCastString(param.getField(),params.getSiteID())# #param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#"><cfif isListParam>)</cfif>)
				</cfif>
			</cfif>						
		</cfloop>
		<cfif started>)</cfif>
	</cfif> 
	<!---
	<cfif arrayLen(paramArray)>
		<cfloop from="1" to="#arrayLen(paramArray)#" index="i">
				<cfset param=paramArray[i] />
		 		<cfif not started ><cfset started = true />and (<cfelse>#param.getRelationship()#</cfif>			
		 		#param.getField()# #param.getCondition()# <cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#">  	
		</cfloop>
		<cfif started>)</cfif>
	</cfif>
	--->
	
  	<cfif len(params.getCategoryID())>
	<cfset paramNum=listLen(params.getCategoryID())>
	and tusers.userID in (select userID from tusersinterests
							where categoryID in 
							(<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(params.getCategoryID())#">
							<cfif paramNum gt 1>
							<cfloop from="2" to="#paramNum#" index="i">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(params.getCategoryID(),i)#">
							</cfloop>
							</cfif>
							)
							)
	</cfif>
	
	<cfif len(params.getGroupID())>
	<cfset paramNum=listLen(params.getGroupID())>
	and tusers.userID in (select userID from tusersmemb
							where groupID in 
							(<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(params.getGroupID())#">
							<cfif paramNum gt 1>
							<cfloop from="2" to="#paramNum#" index="i">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(params.getGroupID(),i)#">
							</cfloop>
							</cfif>
							)
							)
	</cfif>
		
	<cfif isNumeric(params.getInActive())>
		and tusers.inactive=#params.getInActive()#
	</cfif>
	
	<cfif not listFind(session.mura.memberships,'S2')> and tusers.s2=0 </cfif> 
	
	order by
	
	<cfif isExtendedSort>
			qExtendedSort.extendedSort #arguments.feedBean.getSortDirection()#
	<cfelse>	
		<cfif variables.configBean.getDbType() neq "oracle" or listFindNoCase("lastUpdate,created,isPublic",params.getSortBy())>
			tusers.#params.getSortBy()# #params.getSortDirection()#
		<cfelse>
			lower(tusers.#params.getSortBy()#) #params.getSortDirection()#
		</cfif>
	</cfif>
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getPrivateGroups" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT tsettings.Site, #variables.fieldList#
	FROM tsettings INNER JOIN tusers ON tsettings.SiteID = tusers.SiteID
	LEFT JOIN tfiles on tusers.photofileID=tfiles.fileID
	WHERE tusers.Type=1 AND tusers.isPublic=0
	and tsettings.PrivateUserPoolID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#">
	and tusers.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#">
	ORDER BY tsettings.Site, tusers.Perm DESC, tusers.GroupName
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="getPublicGroups" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT tsettings.Site, #variables.fieldList# 
	FROM tsettings INNER JOIN tusers ON tsettings.SiteID = tusers.SiteID
	LEFT JOIN tfiles on tusers.photofileID=tfiles.fileID
	WHERE tusers.Type=1 AND tusers.isPublic=1
	and tsettings.PublicUserPoolID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#">
	and tusers.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#">
	ORDER BY tsettings.Site, tusers.Perm DESC, tusers.GroupName
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="getCreatedMembers" returntype="numeric" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs = "" />
	<cfset var start = "" />
	<cfset var stop = "" />
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT Count(*) as theCount
	FROM tusers
	WHERE tusers.Type=2 AND tusers.isPublic=1
	and siteID = '#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
	<cfif lsisdate(arguments.stopDate)>
		<cfset stop=lsParseDateTime(arguments.stopDate)/>
		and created <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(stop),month(stop),day(stop),23,59,0)#"></cfif>
	<cfif lsisdate(arguments.startDate)>
		<cfset start=lsParseDateTime(arguments.startDate)/>
		and created >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(start),month(start),day(start),0,0,0)#"></cfif>
	</cfquery>
	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getTotalMembers" returntype="numeric" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />

	
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT Count(*) as theCount
	FROM tusers
	WHERE tusers.Type=2 AND tusers.isPublic=1
	and siteID = '#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
	and inActive=0
	
	</cfquery>
	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getTotalAdministrators" returntype="numeric" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />

	
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT Count(*) as theCount
	FROM tusers
	WHERE tusers.Type=2 AND tusers.isPublic=0
	and siteID = '#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
	and inActive=0
	
	</cfquery>
	<cfreturn rs.theCount />
</cffunction>

</cfcomponent>