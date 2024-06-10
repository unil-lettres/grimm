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
    let $baseText := collection($config:data-default)/id($tale)
    let $number := $tale => substring-before('_') => replace('KHM', '') => number() => format-number('0000')
    order by $number
    return
        <div class="tale">
            {$pm-config:web-transform($baseText//tei:titleStmt, map { "root": $baseText, "doc": config:get-identifier($baseText), "tale": $tale, "view": "tale" }, $config:default-odd)}
        </div>
};

declare function app:get-position($id as xs:string) {
    let $documents := app:get-sorted-documents($id)
    let $identifiers := for $x in $documents return config:get-identifier($x)
    return 
        index-of($identifiers, $id) - 1
    };

declare function app:get-sorted-documents($id as xs:string) {
    let $selectedDoc := collection($config:data-default)/id($id)
    let $documents := collection($config:data-default)//tei:TEI[@corresp = $selectedDoc/@corresp]
    let $sortedDocuments := for $x in $documents order by $x/descendant::tei:sourceDesc//tei:date return $x
    return $sortedDocuments
    };
    
declare function app:create-title($doc) {
    let $fileNameComponents := tokenize(substring-before(util:document-name($doc), '.xml'), '_')
    let $language := $fileNameComponents[4] => upper-case()
    let $type := if ($doc/substring(@corresp, 2) = $doc/@xml:id/string()) then 'Source' else $language
    let $title := $doc//tei:titleStmt/tei:title/string()
    let $author := $fileNameComponents[3]
    let $year := $fileNameComponents[2]
    return 
        $type || ' – ' || $year || ' – ' || $title
    };
    
declare 
    %templates:wrap 
    function app:create-panels($node as node(), $model as map(*)) {
    let $id := $model?doc
    let $docsToDisplay := app:get-sorted-documents($id)
    let $position := app:get-position($id)
    return
        <pb-grid id="grid" panels="[{$position}]" emit="transcription" subscribe="transcription">
            <template>
                <pb-panel emit="transcription" subscribe="transcription" draggable="">
                    <paper-button toggles="true" class="disable" slot="toolbar">
                        <img src="resources/images/disable-sync.svg" title="Disable sync" alt="disable sync icon" class="disable-button"/>
                        </paper-button>
                    <pb-popover trigger="click" persistent="yes" onclick="getMetadata(this)" data-id="{$id}" slot="toolbar"><paper-icon-button icon="icons:info"/></pb-popover>
                    <pb-grid-action grid="#grid" slot="toolbar" action="remove">
                        <paper-icon-button icon="icons:close"/>
                    </pb-grid-action>
                    {
                    for $doc at $pos in $docsToDisplay
                    let $title := app:create-title($doc)
                    let $contents := $pm-config:web-transform(
                            $doc,
                            map { 
                                "root": $doc, 
                                "view": "versions", 
                                "header": "document", 
                                "webcomponents": 7},
                                'grimm.odd')
                    return
                        <template title="{$title}">
                            {$contents}
                        </template>
                        }
                </pb-panel>
            </template>
        </pb-grid>
        };

declare %templates:wrap function app:tale-title($node as node(), $model as map(*)) {
    let $id := $model?doc
    let $source :=  collection($config:data-default)/id($id)
    let $title := $source/descendant::tei:titleStmt/tei:title/string() 
    return
       $title
    };
    
declare  
%templates:wrap
function app:load-map($node as node(), $model as map(*)) {
    let $doc := $model?doc
    let $tale := collection($config:data-default)/id($doc)/substring(@corresp, 2)
    return
        map:merge(($model, map {"tale" : $tale}))
};

declare
%templates:wrap
function app:tales($node as node(), $model as map(*)) {
        let $work := root($model("work"))/*
        let $relPath := config:get-identifier($work)
        let $title := app:create-title($work)
        let $pos := app:get-position($relPath)
        return
            try {
                <paper-checkbox name="panel" value="{$pos}">
                    {$title}
                </paper-checkbox>
                
            } catch * {
                <a href="{$relPath}">{util:document-name($work)}</a>,
                <p class="error">Failed to output document metadata: {$err:description}</p>
            }
};