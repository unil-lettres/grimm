
xquery version "3.1";

module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config";

import module namespace pm-teipublisher-web="http://www.tei-c.org/pm/models/teipublisher/web/module" at "../transform/teipublisher-web-module.xql";
import module namespace pm-teipublisher-print="http://www.tei-c.org/pm/models/teipublisher/print/module" at "../transform/teipublisher-print-module.xql";
import module namespace pm-teipublisher-latex="http://www.tei-c.org/pm/models/teipublisher/latex/module" at "../transform/teipublisher-latex-module.xql";
import module namespace pm-teipublisher-epub="http://www.tei-c.org/pm/models/teipublisher/epub/module" at "../transform/teipublisher-epub-module.xql";
import module namespace pm-teipublisher-fo="http://www.tei-c.org/pm/models/teipublisher/fo/module" at "../transform/teipublisher-fo-module.xql";
import module namespace pm-grim-web="http://www.tei-c.org/pm/models/grim/web/module" at "../transform/grim-web-module.xql";
import module namespace pm-grim-print="http://www.tei-c.org/pm/models/grim/print/module" at "../transform/grim-print-module.xql";
import module namespace pm-grim-latex="http://www.tei-c.org/pm/models/grim/latex/module" at "../transform/grim-latex-module.xql";
import module namespace pm-grim-epub="http://www.tei-c.org/pm/models/grim/epub/module" at "../transform/grim-epub-module.xql";
import module namespace pm-grim-fo="http://www.tei-c.org/pm/models/grim/fo/module" at "../transform/grim-fo-module.xql";
import module namespace pm-docx-tei="http://www.tei-c.org/pm/models/docx/tei/module" at "../transform/docx-tei-module.xql";

declare variable $pm-config:web-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "teipublisher.odd" return pm-teipublisher-web:transform($xml, $parameters)
case "grim.odd" return pm-grim-web:transform($xml, $parameters)
    default return pm-teipublisher-web:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:print-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "teipublisher.odd" return pm-teipublisher-print:transform($xml, $parameters)
case "grim.odd" return pm-grim-print:transform($xml, $parameters)
    default return pm-teipublisher-print:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:latex-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "teipublisher.odd" return pm-teipublisher-latex:transform($xml, $parameters)
case "grim.odd" return pm-grim-latex:transform($xml, $parameters)
    default return pm-teipublisher-latex:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:epub-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "teipublisher.odd" return pm-teipublisher-epub:transform($xml, $parameters)
case "grim.odd" return pm-grim-epub:transform($xml, $parameters)
    default return pm-teipublisher-epub:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:fo-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "teipublisher.odd" return pm-teipublisher-fo:transform($xml, $parameters)
case "grim.odd" return pm-grim-fo:transform($xml, $parameters)
    default return pm-teipublisher-fo:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:tei-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "docx.odd" return pm-docx-tei:transform($xml, $parameters)
    default return error(QName("http://www.tei-c.org/tei-simple/pm-config", "error"), "No default ODD found for output mode tei")
            
    
};
            
    