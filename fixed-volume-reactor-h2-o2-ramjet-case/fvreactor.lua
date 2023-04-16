-- fvreactor.lua
-- A simple fixed-volume reactor.
-- PJ & RJG 2018-04-21.

gm = GasModel:new{"h2-o2-n2-9sp.lua"}
chemUpdate = ChemistryUpdate:new{gasmodel=gm, filename="h2-o2-n2-9sp-18r.lua"}

gs = GasState:new{gm}
gs.p = 100e3 -- Pa
gs.T = 2000.0 -- degree K
molef = {O2=0.005, H2=0.005, N2=0.99, H=0.0, O=0.0, H2O=0.0, HO2=0.0, OH=0.0, H2O2=0.0}
gs.massf = gm:molef2massf(molef)
gm:updateThermoFromPT(gs)
conc = gm:massf2conc(gs)

tFinal = 0.1 -- s
t = 0.0
dt = 1.0e-7
dtSuggest = 1.0e-11
print("# Start integration")
f = assert(io.open("fvreactor.data", 'w'))
f:write('# 1:t(s)  2:T(K)  3:p(Pa)  4:rho(kg/m^3)  5:u(J/kg)  6:massf_H2  7:massf_O2  8:massf_H2O  9:massf_N2  10:conc_H2  11:conc_O2  12:conc_H2O  13:conc_N2\n')
f:write(string.format("%10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f\n",
                      t, gs.T, gs.p, gs.rho, gs.u, gs.massf.H2, gs.massf.O2, gs.massf.H2O, gs.massf.N2, conc.H2, conc.O2, conc.H2O, conc.N2))
while t <= tFinal do
   dtSuggest = chemUpdate:updateState(gs, dt, dtSuggest, gm)
   t = t + dt
   print(t)
   -- dt = dtSuggest -- uncomment this to get quicker stepping
   gm:updateThermoFromRHOU(gs)
   
   conc = gm:massf2conc(gs)
   f:write(string.format("%10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f %10.9f\n",
   t, gs.T, gs.p, gs.rho, gs.u, gs.massf.H2, gs.massf.O2, gs.massf.H2O, gs.massf.N2, conc.H2, conc.O2, conc.H2O, conc.N2))
end
f:close()
print("# Done.")
