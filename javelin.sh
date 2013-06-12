#!/bin/bash

# A poor man's version of javelin/scripts/sync-spec.php

JXFILES="core/init.js"

JXFILES+=" core/util.js core/install.js"
JXFILES+=" core/Event.js core/Stratcom.js"
JXFILES+=" lib/behavior.js lib/Request.js lib/Vector.js"
JXFILES+=" lib/DOM.js lib/JSON.js lib/URI.js"

output="static/javelin.js"
echo "window['__DEV__'] = 1;" > $output
for file in $JXFILES
do
	cat javelin/src/$file >> $output
done

cp javelin/src/lib/Resource.js static/javelin-resource.js
