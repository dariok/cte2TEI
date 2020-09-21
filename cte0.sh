#!/bin/bash

# general outline to create a wellformed XML
perl -p0e "s@^[^\{]*(.*)@<cte>\1@s" "$1" > cte1xml
perl -i -p0e 's@[^\}]*$@</cte>@s' cte1xml

# replace reserved and problematic characters
perl -i -p0e "s@\x{02}@_@g" cte1xml
perl -i -p0e "s@&@&amp;@g" cte1xml

# Replace special character combinations
perl -i -p0e "s@\^-@@g" cte1xml

# Clean up prologue
perl -i -p0e "s@\x{5c}TemplateSpacing@\n\x{5c}TemplateSpacing@g" cte1xml
perl -i -p0e "s@\x{5c}User(\d+)@\n\x{5c}User\1@g" cte1xml
perl -i -p0e "s@\x{5c}FontUser(\d+)@\n\x{5c}FontUser\1@g" cte1xml
perl -i -p0e 's@\x{5c}User(\d+):([^,]+),(\d+)=(.+)@<pdef lfd="User\1" name="\2" n="\3" def="\4" />@g' cte1xml
perl -i -p0e 's@\x{5c}FontUser(\d+):([^,]+),(\d+)=(.+)@<fdef lfd="FontUser\1" name="\2" n="\3" def="\4" />@g' cte1xml

# main outline
perl -i -p0e "s@{(Description|Text|Notes\d|Apparatus\d|Fonts|Format|HeaderFooter)\x{5c}@<\1>@g" cte1xml
perl -i -p0e "s@\\\\(Description|Text|Notes\d|Apparatus\d|Fonts|Format|HeaderFooter)\}@</\1>@g" cte1xml

# we must not create elements without a name
perl -i -p0e "s@{ @<Z>@g" cte1xml
perl -i -p0e "s@\x{5c} \}@</Z>@g" cte1xml

# paragraph marker
perl -i -p0e 's@{P\x{5c}([^\x{5C}]*)\x{5C}P}@<P vals="\1" />@g' cte1xml

# other elements
perl -i -p0e 's@{(.)([^\x{5C}]*)\x{5C}@<\1 vals="\2">@g' cte1xml
perl -i -p0e "s@\x{5c}(.)\}@</\1>@g" cte1xml