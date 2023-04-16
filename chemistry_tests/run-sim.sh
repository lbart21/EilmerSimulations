#!/bin/bash
# run-sim.sh
e4shared --run --job=reactor --verbosity=1 --max-cpus=1
e4shared --post --job=reactor --tindx-plot=all --vtk-xml --add-vars="molef"