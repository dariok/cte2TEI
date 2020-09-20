#!/bin/bash

# grobes Skelett
perl -p0e "s@^[^\{]*(.*)@<cte>\1@s" "$1" > cte.xml
perl -i -p0e 's@[^\}]*$@</cte>@s' cte.xml

# problematische Zeichen ersetzen
perl -i -p0e "s@\x{02}@_@g" cte.xml
perl -i -p0e "s@&@&amp;@g" cte.xml

# Teile im Prolog, die interessant sein könnten
perl -i -p0e "s@\x{5c}TemplateSpacing@\n\x{5c}TemplateSpacing@g" cte.xml
perl -i -p0e "s@\x{5c}User(\d+)@\n\x{5c}User\1@g" cte.xml
perl -i -p0e "s@\x{5c}FontUser(\d+)@\n\x{5c}FontUser\1@g" cte.xml
perl -i -p0e 's@\x{5c}User(\d+):([^,]+),(\d+)=(.+)@<pdef lfd="User\1" name="\2" n="\3" def="\4" />@g' cte.xml
perl -i -p0e 's@\x{5c}FontUser(\d+):([^,]+),(\d+)=(.+)@<fdef lfd="FontUser\1" name="\2" n="\3" def="\4" />@g' cte.xml

# Hauptgliederung
perl -i -p0e "s@{(Description|Text|Notes\d|Apparatus\d|Fonts|Format|HeaderFooter)\x{5c}@<\1>@g" cte.xml
perl -i -p0e "s@\\\\(Description|Text|Notes\d|Apparatus\d|Fonts|Format|HeaderFooter)\}@</\1>@g" cte.xml

# Leerzeichenelement
perl -i -p0e "s@{ @<Z>@g" cte.xml
perl -i -p0e "s@\x{5c} \}@</Z>@g" cte.xml

# Absatzmarker
perl -i -p0e 's@{P\x{5c}([^\x{5C}]*)\x{5C}P}@<P vals="\1" />@g' cte.xml

# normale Elemente
perl -i -p0e 's@{(.)([^\x{5C}]*)\x{5C}@<\1 vals="\2">@g' cte.xml
perl -i -p0e "s@\x{5c}(.)\}@</\1>@g" cte.xml