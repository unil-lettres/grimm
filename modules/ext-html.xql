xquery version "3.1";

module namespace pmf="https://teipublisher.com/apps/grimm/custom";
import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function pmf:available-languages($tail as xs:string) {
    let $versions := collection($config:data-root)//tei:TEI[@corresp eq '#' || $tail]
    let $languages := for $lang in $versions//tei:language/upper-case(@ident) order by $lang return $lang
    return
        string-join(distinct-values($languages), ' / ')
};