#!/bin/bash
# post-ram2.sh
e4shared --post --job=reactor --tindx-plot=all --vtk-xml \
	 --add-vars="conc, molef"
