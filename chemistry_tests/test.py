from gdtk.gas import GasModel, GasState

gm_dummy = GasModel('H2-O2-6sp-thermally-perfect-gas-model.lua')
gs_dummy = GasState(gm_dummy)
gs_dummy.molef = {"H2":2/3, "O2":1/3, "O":0.0, "H":0.0, "OH":0.0, "H2O":0.0}
gs_dummy.p = 20e6
gs_dummy.T = 2000.0
gs_dummy.update_thermo_from_pT()

print("Starting mass fractions:", gs_dummy.massf)
print("Starting density:", gs_dummy.rho)
print("Starting internal energy:", gs_dummy.u)

gm = GasModel("cea-H2-O2-6sp-gas-model.lua")
gs = GasState(gm)
gs.rho = gs_dummy.rho
gs.u = gs_dummy.u
gs.update_thermo_from_rhou()

equil_massf = gs.ceaSavedData["massf"]
sum = 0.0
for key in equil_massf.keys():
    sum += equil_massf[key]
print("mass fraction error:", abs(1.0 - sum))
for key in equil_massf.keys():
    equil_massf[key] /= sum
print("Normalised equilibrium mass fractions:", equil_massf)
print("Equilibrium pressure:", gs.ceaSavedData["p"])
print("Equilibrium temperature:", gs.ceaSavedData["T"])
