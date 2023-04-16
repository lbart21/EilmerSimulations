# fvreactor.py
# A simple fixed-volume reactor.
# PJ & RJG 2019-11-25
#
# To prepare:
#   $ prep-gas nitrogen-2sp.inp nitrogen-2sp.lua
#   $ prep-chem nitrogen-2sp.lua nitrogen-2sp-2r.lua chem.lua
#
# To run:
#   $ python3 fvreactor.py

from gdtk.gas import GasModel, GasState, ThermochemicalReactor

gm = GasModel("H2-O2-11sp-thermally-perfect-gas-model.lua")
reactor = ThermochemicalReactor(gm, "hydrogen-oxygen-19r-chain-dissociation-recombination-and-formation-chemistry.lua")

gs = GasState(gm)
gs.p = 30397.5 # Pa
gs.T = 880.0 # degree K
gs.molef = {'H':0.0, 'H2':0.005, 'O':0.0, 'O2':0.005, 'H2O2':0.0, 'H2O':0.0, 'HO2':0.0, 'OH':0.0, 'Ar':0.0, 'He':0.0, 'N2':0.99}
gs.update_thermo_from_pT()
print("rho:", gs.rho)
tFinal = 0.03 # s
t = 0.0
dt = 1.0e-8
dtSuggest = 1.0e-11
print("# Start integration")
f = open("fvreactor.data", 'w')
f.write('# 1:t(s)  2:T(K)  3:p(Pa)  4:molef_H2  5:molef_O2  6:molef_H2O  7:molef_N2\n')
f.write("%10.3e %10.3f %10.3e %20.12e %20.12e %20.12e %20.12e\n" %
        (t, gs.T, gs.p, gs.molef[1], gs.molef[3], gs.molef[5], gs.molef[10]))
while t <= tFinal:
    dtSuggest = reactor.update_state(gs, dt, dtSuggest)
    t = t + dt
    print(t)
    # dt = dtSuggest # uncomment this to get quicker stepping
    gs.update_thermo_from_rhou()
    f.write("%10.3e %10.3f %10.3e %20.12e %20.12e %20.12e %20.12e\n" %
            (t, gs.T, gs.p, gs.molef[1], gs.molef[3], gs.molef[5], gs.molef[10]))
f.close()
print("# Done.")
