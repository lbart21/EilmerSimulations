-- fvreactor.lua
-- A simple fixed-volume reactor.
-- PJ & RJG 2018-04-21.

gm = GasModel:new{"H2-O2-11sp-thermally-perfect-gas-model.lua"}
chemUpdate = ChemistryUpdate:new{gasmodel=gm, filename="hydrogen-oxygen-19r-chain-dissociation-recombination-and-formation-chemistry.lua"}

gs = GasState:new{gm}
gs.p = 30397.5 -- Pa
gs.T = 880.0 -- degree K
molef = {H=0.0, H2=0.005, O=0.0, O2=0.005, H2O2=0.0, H2O=0.0, HO2=0.0, OH=0.0, Ar=0.0, He=0.0, N2=0.99}
gs.massf = gm:molef2massf(molef)
gm:updateThermoFromPT(gs)
conc = gm:massf2conc(gs)

tFinal = 0.1 -- s
t = 0.0
dt = 1.0e-8
dtSuggest = 1.0e-11
print("# Start integration")
f = assert(io.open("fvreactor.data", 'w'))
f:write('# 1:t(s)  2:T(K)  3:p(Pa)  4:massf_H2  5:massf_O2  6:massf_H2O  7:massf_N2\n')
f:write(string.format("%10.3e %10.3f %10.3e %20.12e %20.12e %20.12e %20.12e\n",
                      t, gs.T, gs.p, gs.massf.H2, gs.massf.O2, gs.massf.H2O, gs.massf.N2))
while t <= tFinal do
   dtSuggest = chemUpdate:updateState(gs, dt, dtSuggest, gm)
   t = t + dt
   -- dt = dtSuggest -- uncomment this to get quicker stepping
   gm:updateThermoFromRHOU(gs)
   conc = gm:massf2conc(gs)
   f:write(string.format("%10.3e %10.3f %10.3e %20.12e %20.12e %20.12e %20.12e\n",
                         t, gs.T, gs.p, gs.massf.H2, gs.massf.O2, gs.massf.H2O, gs.massf.N2))
end
f:close()
print("# Done.")
