
xquery version "1.0-ml";
(:~
 : Controller :  packageTypes 
 :               
 : @author   
 : @version    
~:)

module namespace controller = "http://www.condenast.com/dam/2.0/controller/packageTypes";



(:Global Import Module:)
import module namespace request =  "http://www.xquerrail-framework.com/request"
   at "../../_framework/request.xqy";
   
import module namespace response =  "http://www.xquerrail-framework.com/response"
   at "../../_framework/response.xqy";   

import module namespace model = "http://www.condenast.com/dam/2.0/model/packageType"
  at "/application/model/packageType-model.xqy";
  
(:Default Imports:)
declare namespace search = "http://marklogic.com/appservices/search";


(:Global Option:)
declare option xdmp:mapping "false";

declare variable $collation := "http://marklogic.com/collation/codepoint";

declare function controller:initialize($request)
{(
   request:initialize($request),
   response:initialize(map:map(),$request)
)};

 
(:Controller Required Functions:)
 
declare function controller:name() {
"packageTypes"
}; 

declare function controller:main()
{
   if(request:format() eq "xml") 
   then (
      response:set-controller(controller:name()),
      response:set-format(request:format()),
      response:set-template("main"),
      response:set-view("info"),
      response:flush()
   ) else (
     controller:index()  
   )
};

  declare function controller:info() { 
  <info xmlns:domain="http://www.xquerrail-framework.com/domain"
      xmlns:search="http://marklogic.com/appservices/search"
      xmlns:builder="http://www.xquerrail-framework.com/builder"/>
};

(:~
 : Create packageType
~:) 
declare function controller:create() {
  model:create( 
  request:param("name") )
};

(:~
 :  Retrieves a packageType
~:) 
declare function controller:get()
{
   model:get(request:param("id"))
};
 
(:~
 : Update Operation packageType
 :) 
declare function controller:update()
{
  model:update(
   request:param("id")  cast as xs:string, 
   request:param("name")  cast as xs:string
  )
};
 
(:~
 :  Deletes a packageType
~:)  
declare function controller:delete()
{
    model:delete(request:param("id"))
};
 
(:~
 : Provide search interface for packageType
 : @param $query - Search query 
 : @param $sort -  Sorting Key to sort results by
 : @param $start 
~:)
declare function controller:search()
{
    model:search(
        request:param("query") cast as xs:string,
        request:param("sort") cast as xs:string,
        request:param("sort-order") cast as xs:string,
        request:param("page",1) cast as xs:integer,
        request:param("size",10) cast as xs:integer
   )
};
 

(:~
: This function will create the  assetTypes related to this packageType
:)
declare function controller:create-assetTypes()
as empty-sequence()
{
    let $currentId := request:param("id")
    let $ids := request:param("id")
    return
        model:create-assetTypes($currentId,$ids)
};
     
(:~
 : This function will return the  assetTypes related to this packageType
 : @return assetTypes related to this packageType
 :)
declare function controller:get-assetTypes()
as element(assetTypes) 
{
    model:get-assetTypes(request:param("id"))
};

(:~
 : This function will create the  assetTypes related to this packageType
 :)
declare function controller:update-assetTypes()
as empty-sequence()
{
    let $currentId := request:param("id")
    let $ids := request:param("id")
    return
       model:update-assetTypes($currentId,$ids)
};

(:~
: This function will delete all assetTypes related to this packageType
:)
declare function controller:delete-assetTypes()
as element(assetTypes) 
{
    model:delete-assetTypes(request:param("id"))
};
    
  

(:Controller HTML Functions:)
 
(:~
 : Default Index Page 
~:)
declare function controller:index()
{(
   controller:list()[0],
   response:set-template("main"),
   response:set-view("index"),
   response:flush()
)};

 (:~ Show a record ~:) 
 
declare function controller:show()
{
 (   
    response:set-body(controller:get()),
    response:set-template("main"),
    response:set-view("show"),  
    response:flush()
 )     
};   

declare function controller:new()
{(  
    response:set-template("main"),
    response:set-view("new"),  
    response:flush()
)}; 

(:~
 :  Saves a controller
~:)
declare function controller:save()
{
   let $update := 
       try {
         controller:update()
       } catch($exception) {
         xdmp:rethrow()
       }
   return
   if(response:has-error()) 
   then (
     response:flash("error_message","Could not save"),
     response:flush()
   ) else (
      response:set-body($update),
      response:set-template("main"),
      response:set-format("html"),
      response:set-view("index"),  
      response:flush()
   )
};
 
declare function controller:edit()
{(
    response:set-body(controller:get()),
    response:set-template("main"),
    response:set-view("edit"),  
    response:flush()
)};

declare function controller:remove()
{
  let $delete := 
  try { 
     controller:delete( )
  } catch($exception) {
    response:set-error("404",$exception) 
  }
  return
  if(response:has-error()) then (
     response:flash("error_message","Could not Delete"),
     response:flush()
   ) else ( 
    response:flash("status",$delete), 
    response:redirect(response:redirect(controller:name(),"index"))
  )
};

(:~
 : Finds Records
~:)
declare function controller:find()
{
  let $find := 
  try { 
    model:find(
      request:param("query","*"),
      request:param("page",1),
      request:param("size",20)
    )
  } catch($exception) {
    response:set-error("404",$exception) 
  }
  return
	  if(response:error()) then (
	     response:flash("error_message",response:error()//*:format-string),
	     response:flush()
	   ) else ( 
	    response:set-template("main"),
	    response:set-view("find"),
	    response:set-body($find),
	    response:flush()
	  )
};

(:~
 : Returns a list of records
~:)
declare function controller:list()
{
    model:list()
};
