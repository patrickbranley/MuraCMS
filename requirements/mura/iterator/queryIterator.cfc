<!--- 
   Copyright 2007 Paul Marcotte

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   Iterator.cfc (.3)
   [2007-05-31] Added Apache license.
				Fixed bug in currentRow method.
				Dropped cfscript blocks in favour of tags in all methods but queryRowToStruct().
   [2007-05-27] Added end() method.
				Renamed rewind() to reset().
				Acknowlegement to Aaron Roberson for suggesting currentRow() method and other enhancements.
   [2007-05-10]	Initial Release.
				Acknowlegement to Peter Bell for the "Iterating Business Object" concept that Iterator seeks to provide as a composite.				
 --->
<cfcomponent extends="mura.cfobject" displayname="Iterator" output="false" hint="I am a Iterator object.">
	<cfset variables.maxRecordsPerPage=1000>
	<cfset variables.recordTranslator="">
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfset variables.recordIndex = 0 />
		<cfset variables.pageIndex = 1 />
		<cfreturn THIS />
	</cffunction>
	
	<cffunction name="currentIndex" access="public" output="false" returntype="numeric">
		<cfreturn variables.recordIndex  />
	</cffunction>
	
	<cffunction name="getRecordIndex" access="public" output="false" returntype="numeric">
		<cfreturn variables.recordIndex />
	</cffunction>
	
	<cffunction name="getFirstRecordOnPageIndex" access="public" output="false" returntype="numeric">
		<cfset var first = ((variables.pageIndex-1) * variables.maxRecordsPerPage)>
		
		<cfif first gt getRecordCount()>
			<cfreturn 1>
		<cfelse>
			<cfreturn first+1 />
		</cfif>
		
	</cffunction>
	
	<cffunction name="getLastRecordOnPageIndex" access="public" output="false" returntype="numeric">
		<cfset var last=(((variables.pageIndex-1) * variables.maxRecordsPerPage) + variables.maxRecordsPerPage)>
		<cfif last gt variables.records.recordcount>
			<cfset last=variables.records.recordcount>
		</cfif>
		<cfreturn last />
	</cffunction>
	
	<cffunction name="getPageIndex" access="public" output="false" returntype="numeric">
		<cfreturn variables.pageIndex />
	</cffunction>
	
	<cffunction name="setStartRow" access="public" output="false">
		<cfargument name="startRow">
		<cfif getRecordCount()>
			<cfif variables.maxRecordsPerPage neq 1>
				<cfset setPage(Ceiling(arguments.startRow/variables.maxRecordsPerPage))>
			<cfelse>
				<cfset setPage(arguments.startRow)>
			</cfif>
		<cfelse>
			<cfset variables.recordIndex=0 />
			<cfset setPage(1)>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="currentRow" access="public" output="false" returntype="numeric">
    	<cfreturn variables.recordIndex />
    </cffunction>
		
	<cffunction name="hasNext" access="public" output="false" returntype="boolean">
		<cfreturn currentIndex() lt getRecordCount() and currentIndex() lt (getPageIndex() *  variables.maxRecordsPerPage ) />
	</cffunction>
	
	<cffunction name="next" access="public" output="false" returntype="any">
		<cfset variables.recordIndex = currentIndex() + 1 />
		<cfreturn packageRecord() />
	</cffunction>
	
	<cffunction name="hasPrevious" access="public" output="false" returntype="boolean">
		<cfreturn (currentIndex() gt (((variables.pageIndex-1) * variables.maxRecordsPerPage) + 1)) />
	</cffunction>
	
	<cffunction name="previous" access="public" output="false" returntype="any">
		<cfset variables.recordIndex = currentIndex() - 1 />
		<cfreturn packageRecord() />
	</cffunction>
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfreturn queryRowToStruct(variables.records,currentIndex()) />
	</cffunction>
	
	<cffunction name="reset" access="public" output="false">
		<cfset variables.recordIndex = 0 />
		<cfreturn this>
	</cffunction>
	
	<cffunction name="end" access="public" output="false">
		<cfset variables.recordIndex = getRecordCount() + 1 />
		<cfreturn this>
	</cffunction>
				
	<cffunction name="pageCount" access="public" output="false" returntype="numeric">
		<cfset var pageCount = 1 />
		<cfif structKeyExists(variables,"maxRecordsPerPage")>
			<cfset pageCount = Ceiling(getRecordCount()/variables.maxRecordsPerPage) />
		</cfif>
		<cfreturn pageCount />
	</cffunction>
	
	<cffunction name="recordCount" access="public" output="false" returntype="numeric" hint="For Railo compatibility use getRecordCount()">
		<cfreturn getRecordCount()>
	</cffunction>
	
	<cffunction name="getRecordCount" access="public" output="false" returntype="numeric">
		<cfset var recordCount = 0 />
		<cfif structKeyExists(variables,"records")>
			<cfset recordCount =records.recordCount />
		</cfif>
		<cfreturn recordCount />
	</cffunction>
	
	<cffunction name="setPage" access="public" output="false">
		<cfargument name="pageIndex" type="numeric" required="true">
		<cfset variables.pageIndex = arguments.pageIndex />
		<cfset variables.recordIndex = ((variables.pageIndex-1) * variables.maxRecordsPerPage)>
		
		<cfif variables.recordIndex gt getRecordCount()>
			<cfset variables.recordIndex=0>
			<cfset variables.pageIndex=1>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setNextN" access="public" output="false">
		<cfargument name="nextN">
		<cfif isNumeric(arguments.nextN) and arguments.nextN>
			<cfset variables.maxRecordsPerPage=arguments.nextN>
		<cfelse>
			<cfset variables.maxRecordsPerPage=getRecordCount()>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getNextN" access="public" output="false" returntype="any">
		<cfreturn variables.maxRecordsPerPage>
	</cffunction>
	
	<cffunction name="setQuery" access="public" output="false">
		<cfargument name="rs" type="query" required="true">
		<cfargument name="maxRecordsPerPage" type="numeric" required="false">

		<cfset variables.records = arguments.rs />
		
		<cfif structKeyExists(arguments,"maxRecordsPerPage") and isNumeric(arguments.maxRecordsPerPage)>
			<cfset variables.maxRecordsPerPage = arguments.maxRecordsPerPage />
		<cfelse>
			<cfset variables.maxRecordsPerPage = variables.records.recordcount />
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getQuery" output="false" returntype="any">
		<cfreturn variables.records>
	</cffunction>
	
	<cffunction name="queryRowToStruct" access="public" output="false" returntype="struct">
		<cfargument name="qry" type="query" required="true">
		
		<cfscript>
			/**
			 * Makes a row of a query into a structure.
			 * 
			 * @param query 	 The query to work with. 
			 * @param row 	 Row number to check. Defaults to row 1. 
			 * @return Returns a structure. 
			 * @author Nathan Dintenfass (nathan@changemedia.com) 
			 * @version 1, December 11, 2001 
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = qry[cols[ii]][row];
			}		
			//return the struct
			return stReturn;
		</cfscript>
	</cffunction>
	
	<cffunction name="setRecordTranslator" output="false" access="public">
	<cfargument name="recordTranslator">
		<cfset variables.recordTranslator=arguments.recordTranslator/>
		<cfreturn this>
	</cffunction>
</cfcomponent>