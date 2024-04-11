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

declare variable $app:xsl := doc('../resources/scripts/create-segs.xsl');

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
    
declare %templates:wrap function app:create-panels($node as node(), $model as map(*)) {
    let $id := $model?doc
    let $selectedDoc := doc($config:data-root || $id)
    let $documents := collection($config:data-default)//tei:TEI[not(@xml:id/string() = $selectedDoc/tei:TEI/@xml:id/string())][@corresp = $selectedDoc/tei:TEI/@corresp]
    let $sortedDocuments := for $x in $documents order by $x/descendant::tei:sourceDesc//tei:date return $x
    return
        <pb-grid id="grid" panels="[0]">
            <template>
                <pb-panel>
                    <pb-grid-action grid="#grid" slot="toolbar" action="remove">
                        <paper-icon-button icon="icons:close"/>
                    </pb-grid-action>
                    {
                    for $doc in ($selectedDoc/tei:TEI, $sortedDocuments)
                    let $type := if ($doc/substring(@corresp, 2) = $doc/@xml:id/string()) then 'Source text' else 'Translation'
                    let $language := $doc/descendant::tei:language/@ident => upper-case()
                    let $idno := $doc/descendant::tei:sourceDesc/descendant::tei:date/string()
                    let $docWithSegs := transform:transform($doc, $app:xsl, ()) 
                    let $contents := $pm-config:web-transform(
                            $docWithSegs,
                            map { 
                                "root": $docWithSegs//tei:body, 
                                "view": "single", 
                                "header": "document", 
                                "webcomponents": 7},
                                'grimm.odd')
                    return
                        <template title="{$type} ({$language}, {$idno})">
                            {$contents}
                        </template>
                    }
                </pb-panel>
            </template>
        </pb-grid>
        };