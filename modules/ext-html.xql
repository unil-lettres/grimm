xquery version "3.1";

module namespace pmf="https://teipublisher.com/apps/grimm/custom";
import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function pmf:available-languages($tale as xs:string) {
    let $versions := pmf:get-versions($tale)
    let $languages := for $lang in $versions//tei:language/upper-case(@ident) order by $lang return $lang
    return
        string-join(distinct-values($languages), ' / ')
};

declare function pmf:get-source($tale as xs:string) {
    let $source := collection($config:data-root)//tei:TEI[@xml:id/string() = $tale]
    return $source};

declare function pmf:get-versions($tale as xs:string) {
    collection($config:data-root)//tei:TEI[@corresp eq '#' || $tale][not(@xml:id/string = $tale)]
    };

declare function pmf:get-tale-id($root as node()) as xs:string {
    substring($root/@corresp, 2)
    };
    
declare function pmf:get-versions-metadata($tale as xs:string) {
    let $versions := pmf:get-versions($tale)
    for $version in $versions
    let $id := map{"id" : $version/@xml:id/string() }
    let $title := map {"title": $version//tei:titleStmt/tei:title[1]}
    let $bibl := $version//tei:sourceDesc/tei:bibl
    let $translatorNode := $bibl/tei:editor[@role eq 'translator']/text()[1]/replace(., '\s+', '')
    let $translator := if (string-length($translatorNode) gt 1) then map {"translator" : $translatorNode} else ()
    let $pubDate := map {"pubDate": $bibl/tei:date/string()}
    let $publisher := map {"publisher" : $bibl/tei:publisher/string()}
    let $language := map {"language": $version//tei:language/upper-case(@ident)}
    let $origDate := map {"origDate": $version//tei:origDate/string()}
    order by $origDate?origDate
    return map:merge(($id, $title, $translator, $publisher, $pubDate, $language, $origDate))
    };