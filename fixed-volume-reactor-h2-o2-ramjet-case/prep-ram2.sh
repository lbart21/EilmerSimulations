#!/bin/bash
# prep-ram2.sh
e4shared --prep --job=reactor
e4shared --post --job=reactor --tindx-plot=all --vtk-xml \
	 --add-vars="conc, molef"

echo "At this point, we should have a starting grid"
echo "Run run-ram2.sh next"

