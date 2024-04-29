
xquery version "3.1";

module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config";

import module namespace pm-grimm-web="http://www.tei-c.org/pm/models/grimm/web/module" at "../transform/grimm-web-module.xql";
import module namespace pm-grimm-print="http://www.tei-c.org/pm/models/grimm/print/module" at "../transform/grimm-print-module.xql";
import module namespace pm-grimm-latex="http://www.tei-c.org/pm/models/grimm/latex/module" at "../transform/grimm-latex-module.xql";
import module namespace pm-grimm-epub="http://www.tei-c.org/pm/models/grimm/epub/module" at "../transform/grimm-epub-module.xql";
import module namespace pm-grimm-fo="http://www.tei-c.org/pm/models/grimm/fo/module" at "../transform/grimm-fo-module.xql";
import module namespace pm-docx-tei="http://www.tei-c.org/pm/models/docx/tei/module" at "../transform/docx-tei-module.xql";
import module namespace pm-static-web="http://www.tei-c.org/pm/models/static/web/module" at "../transform/static-web-module.xql";
import module namespace pm-static-print="http://www.tei-c.org/pm/models/static/print/module" at "../transform/static-print-module.xql";
import module namespace pm-static-latex="http://www.tei-c.org/pm/models/static/latex/module" at "../transform/static-latex-module.xql";
import module namespace pm-static-epub="http://www.tei-c.org/pm/models/static/epub/module" at "../transform/static-epub-module.xql";
import module namespace pm-static-fo="http://www.tei-c.org/pm/models/static/fo/module" at "../transform/static-fo-module.xql";
import module namespace pm-teipublisher-web="http://www.tei-c.org/pm/models/teipublisher/web/module" at "../transform/teipublisher-web-module.xql";
import module namespace pm-teipublisher-print="http://www.tei-c.org/pm/models/teipublisher/print/module" at "../transform/teipublisher-print-module.xql";
import module namespace pm-teipublisher-latex="http://www.tei-c.org/pm/models/teipublisher/latex/module" at "../transform/teipublisher-latex-module.xql";
import module namespace pm-teipublisher-epub="http://www.tei-c.org/pm/models/teipublisher/epub/module" at "../transform/teipublisher-epub-module.xql";
import module namespace pm-teipublisher-fo="http://www.tei-c.org/pm/models/teipublisher/fo/module" at "../transform/teipublisher-fo-module.xql";

declare variable $pm-config:web-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "grimm.odd" return pm-grimm-web:transform($xml, $parameters)
case "static.odd" return pm-static-web:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-web:transform($xml, $parameters)
    default return pm-grimm-web:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:print-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "grimm.odd" return pm-grimm-print:transform($xml, $parameters)
case "static.odd" return pm-static-print:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-print:transform($xml, $parameters)
    default return pm-grimm-print:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:latex-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "grimm.odd" return pm-grimm-latex:transform($xml, $parameters)
case "static.odd" return pm-static-latex:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-latex:transform($xml, $parameters)
    default return pm-grimm-latex:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:epub-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "grimm.odd" return pm-grimm-epub:transform($xml, $parameters)
case "static.odd" return pm-static-epub:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-epub:transform($xml, $parameters)
    default return pm-grimm-epub:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:fo-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "grimm.odd" return pm-grimm-fo:transform($xml, $parameters)
case "static.odd" return pm-static-fo:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-fo:transform($xml, $parameters)
    default return pm-grimm-fo:transform($xml, $parameters)
            
    
};
            


declare variable $pm-config:tei-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "docx.odd" return pm-docx-tei:transform($xml, $parameters)
    default return error(QName("http://www.tei-c.org/tei-simple/pm-config", "error"), "No default ODD found for output mode tei")
            
    
};
            
    