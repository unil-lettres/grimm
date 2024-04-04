xquery version "3.1";

(: 
 : Module for app-specific template functions
 :
 : Add your own templating functions here, e.g. if you want to extend the template used for showing
 : the browsing view.
 :)
module namespace app="teipublisher.com/app";

import module namespace templates="http://exist-db.org/xquery/html-templating";
import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";
import module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config" at "pm-config.xql";


declare namespace tei="http://www.tei-c.org/ns/1.0";

declare
    %templates:wrap
function app:foo($node as node(), $model as map(*)) {
    <p>Dummy templating function.</p>
};

declare
    %templates:wrap
function app:list-texts($node as node(), $model as map(*), $root as xs:string?) {
    for $hits in $model?all
    group by $tale := ft:field($hits, "tale")
    let $baseText := collection($config:data-root)/id($tale)
    return
        <div class="tale">
            {$pm-config:web-transform($baseText//tei:titleStmt, map { "root": $baseText, "doc": config:get-identifier($baseText), "tale": $tale, "view": "tale" }, $config:default-odd)}
        </div>
};