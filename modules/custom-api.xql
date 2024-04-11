xquery version "3.1";

(:~
 : This is the place to import your own XQuery modules for either:
 :
 : 1. custom API request handling functions
 : 2. custom templating functions to be called from one of the HTML templates
 :)
module namespace api="http://teipublisher.com/api/custom";

(: Add your own module imports here :)
import module namespace rutil="http://e-editiones.org/roaster/util";
import module namespace app="teipublisher.com/app" at "app.xql";
import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";
import module namespace capi="http://teipublisher.com/api/collection" at "lib/api/collection.xql";
import module namespace tpu="http://www.tei-c.org/tei-publisher/util" at "lib/util.xql";
import module namespace templates="http://exist-db.org/xquery/html-templating";
import module namespace browse="http://www.tei-c.org/tei-simple/templates" at "lib/browse.xql";
import module namespace pages="http://www.tei-c.org/tei-simple/pages" at "lib/pages.xql";
import module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config" at "pm-config.xql";
import module namespace query="http://www.tei-c.org/tei-simple/query" at "lib/query.xql";
import module namespace nav="http://www.tei-c.org/tei-simple/navigation" at "lib/navigation.xql";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare default collation "http://exist-db.org/collation?lang=DE";


(:~
 : Keep this. This function does the actual lookup in the imported modules.
 :)
declare function api:lookup($name as xs:string, $arity as xs:integer) {
    try {
        function-lookup(xs:QName($name), $arity)
    } catch * {
        ()
    }
};

declare function api:list($request as map(*)) {
    let $path := if ($request?parameters?path) then xmldb:decode($request?parameters?path) else ()
    let $params := capi:params2map($path)
    let $cached := session:get-attribute($config:session-prefix || ".works")
    let $useCached := capi:use-cache($params, $cached)
    let $works := capi:list-works($path, if ($useCached) then $cached else (), $params)
    let $templatePath := $config:app-root || "/templates/collection.html"
    let $templateAvail := doc-available($templatePath) or util:binary-doc-available($templatePath)
    let $show-collection := if ($request?parameters?type = "document")
                            then (false())
                            else (true())
    let $template := 
        if ($templateAvail and $works?mode = 'browse' and $show-collection) then 
            $templatePath
        else
            $config:app-root || "/templates/documents.html"
    let $lookup := function($name as xs:string, $arity as xs:int) {
        try {
            let $cfun := api:lookup($name, $arity)
            return
                if (empty($cfun)) then
                    function-lookup(xs:QName($name), $arity)
                else
                    $cfun
        } catch * {
            ()
        }
    }
    let $model := map:merge(($works, map {
        "app": $config:context-path,
        "mode": "browse"
    }))
    return
        templates:apply(doc($template), $lookup, $model, tpu:get-template-config($request))
};


