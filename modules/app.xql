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
import module namespace ext-html="https://teipublisher.com/apps/grimm/custom" at "ext-html.xql";



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

declare function app:get-sorted-documents($id as xs:string) {
    let $selectedDoc := doc($config:data-root || $id)
    let $documents := collection($config:data-default)//tei:TEI[not(@xml:id/string() = $selectedDoc/tei:TEI/@xml:id/string())][@corresp = $selectedDoc/tei:TEI/@corresp]
    let $sortedDocuments := for $x in $documents order by $x/descendant::tei:sourceDesc//tei:date return $x
    let $docsToDisplay := ($selectedDoc/tei:TEI, $sortedDocuments)
    return $docsToDisplay
    };
    
declare 
    %templates:wrap 
    function app:create-panels($node as node(), $model as map(*)) {
    let $id := $model?doc
    let $docsToDisplay := app:get-sorted-documents($id)
    return
        <pb-grid id="grid" panels="[0]" subscribe="transcription">
            <template>
                <pb-panel emit="transcription" subscribe="transcription">
                    <pb-popover trigger="click" persistent="yes" onclick="getMetadata(this)" data-id="{$id}" slot="toolbar"><paper-icon-button icon="icons:info"/></pb-popover>
                    <pb-grid-action grid="#grid" slot="toolbar" action="remove">
                        <paper-icon-button icon="icons:close"/>
                    </pb-grid-action>
                    {
                    for $doc at $pos in $docsToDisplay
                    let $id := string($doc/@xml:id)
                    let $fileNameComponents := tokenize(substring-before(util:document-name($doc), '.xml'), '_')
                    let $language := $fileNameComponents[4] => upper-case()
                    let $type := if ($doc/substring(@corresp, 2) = $doc/@xml:id/string()) then 'Source' else $language
                    let $title := $doc//tei:titleStmt/tei:title/string()
                    let $author := $fileNameComponents[3]
                    let $year := $fileNameComponents[2]
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
                        <template title="{$type} – {$year} – {$author} – {$title}">
                            {$contents}
                        </template>
                        }
                </pb-panel>
            </template>
        </pb-grid>
        };

declare %templates:wrap function app:tale-title($node as node(), $model as map(*)) {
    let $id := $model?doc
    let $source :=  doc($config:data-root || $id)
    let $title := $source/descendant::tei:titleStmt/tei:title/string() 
    return
       $title
    };