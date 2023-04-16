-- reactor.lua
-- A no-flow chemical reactor.
-- RG & PJ
--   2015-03-10: ported from Eilmer3
--   2018-04-14: refreshed
--   2021-06-24: integral chemical update with the implicit gas-dynamic update
--
config.title = "Hydrogen reactor -- recombination driven."
print(config.title)
config.dimensions = 2
--
setGasModel('H2-O2-11sp-thermally-perfect-gas-model.lua')
config.reacting = true
config.reactions_file = 'hydrogen-oxygen-19r-chain-dissociation-recombination-and-formation-chemistry.lua'
config.gasdynamic_update_scheme = 'backward_euler'
config.chemistry_update = 'integral' -- other option is 'split'
initial = FlowState:new{p=30397.5, T=880.0, massf={H=0.0, H2=0.005, O=0.0, O2=0.005, H2O2=0.0, H2O=0.0, HO2=0.0, OH=0.0, Ar=0.0, He=0.0, N2=0.99}}
--
-- Geometry is a square
pnts = {}
pnts.a = Vector3:new{x=0.0, y=0.0}
pnts.b = Vector3:new{x=0.0, y=0.01}
pnts.c = Vector3:new{x=0.01, y=0.0}
pnts.d = Vector3:new{x=0.01, y=0.01}
patch0 = CoonsPatch:new{p00=pnts.a, p01=pnts.b, p10=pnts.c, p11=pnts.d}
grid0 = StructuredGrid:new{psurface=patch0, niv=3, njv=3}
blk0 = FluidBlock:new{grid=grid0, initialState=initial}
setHistoryPoint{ib=0, i=0, j=0}
--
-- Finish off config
config.max_time = 0.02
config.max_step = 100000000
-- A time step of 1.0e-6 is good for the operator-split chemical update.
-- The backward-euler updates for the chemistry need to take finer steps
-- to get comparable accuracy.
config.dt_init = 0.01e-6
config.dt_history = 5.0e-6
config.dt_plot = 0.005
config.fixed_time_step = true



