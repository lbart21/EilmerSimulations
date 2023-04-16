from gdtk.gas import GasModel, GasState
import numpy as np

gm_1 = GasModel("Luke-5-sp-comp-air.lua")

gs_1 = GasState(gm_1)

gs_1.molef = (np.array([0.78084, 0.20946, 0.00934, 0.000412, 0.00001818])/sum([0.78084, 0.20946, 0.00934, 0.000412, 0.00001818])).tolist()
gs_1.T = 300.0
gs_1.p = 1e6
print("printing comp model data")

print(gs_1.gamma)
print(gs_1.gamma)
print(gs_1.Cp)
print(gs_1.Cv)

gm_2 = GasModel('ideal-air.lua')

gs_2 = GasState(gm_2)
gs_2.T = 300.0
gs_2.p = 1e6

print("printing ideal gas model data")
print(gs_2.gamma)
print(gs_2.gamma)
print(gs_2.Cp)
print(gs_2.Cv)
