-- reactor.lua
-- A no-flow chemical reactor.
-- RG & PJ
--   2015-03-10: ported from Eilmer3
--   2018-04-14: refreshed
--   2021-06-24: integral chemical update with the implicit gas-dynamic update
--
config.title = "Nitrogen reactor -- recombination driven."
print(config.title)
config.dimensions = 2
--
setGasModel('h2-o2-n2-9sp.lua')
gm = GasModel:new{"h2-o2-n2-9sp.lua"}
gs = GasState:new{gm}
molef = {O2=0.005, H2=0.005, N2=0.99, H=0.0, O=0.0, H2O=0.0, HO2=0.0, OH=0.0, H2O2=0.0}
gs.massf = gm:molef2massf(molef)
config.reacting = true
config.reactions_file = 'h2-o2-n2-9sp-18r.lua'
config.gasdynamic_update_scheme = 'euler'
--config.chemistry_update = 'integral' -- other option is 'split'
initial = FlowState:new{p=100e3, T=2000.0, massf=gs.massf}
--
-- Geometry is a square
pnts = {}
pnts.a = Vector3:new{x=0.0, y=0.0}
pnts.b = Vector3:new{x=0.0, y=0.1}
pnts.c = Vector3:new{x=0.1, y=0.0}
pnts.d = Vector3:new{x=0.1, y=0.1}
patch0 = CoonsPatch:new{p00=pnts.a, p01=pnts.b, p10=pnts.c, p11=pnts.d}
grid0 = StructuredGrid:new{psurface=patch0, niv=3, njv=3}
blk0 = FluidBlock:new{grid=grid0, initialState=initial}
setHistoryPoint{ib=0, i=0, j=0}
--
-- Finish off config
config.max_time = 0.1
config.max_step = 100000000
-- A time step of 1.0e-6 is good for the operator-split chemical update.
-- The backward-euler updates for the chemistry need to take finer steps
-- to get comparable accuracy.
config.dt_init = 2e-7
config.dt_history = 50e-7
config.dt_plot = 0.1
config.fixed_time_step = true




