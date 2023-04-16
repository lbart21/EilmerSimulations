config.title = "hydrogen-oxygen reactor in N2 bath"

config.dimensions = 2

nsp, nmodes, gm = setGasModel("H2-O2-6sp-thermally-perfect-gas-model.lua")
config.reacting = true
config.reactions_file = 'h2-o2-6sp-4r-alphaQSS-default-chemistry.lua'
config.gasdynamic_update_scheme = "euler"
config.chemistry_update = "split"

initial = FlowState:new{p=37461000.0, T=4500.34, massf={H=0.00512480614976738, O=0.04143004971605966, 
                                                    OH=0.19519023422828108, O2=0.09373111247733497, 
                                                    H2O=0.6410507692609232, H2=0.023473028167633803}}


pnts = {}
pnts.a = Vector3:new{x=0.0, y=0.0}
pnts.b = Vector3:new{x=0.0, y=0.01}
pnts.c = Vector3:new{x=0.01, y=0.0}
pnts.d = Vector3:new{x=0.01, y=0.01}

patch0 = CoonsPatch:new{p00=pnts.a, p01=pnts.b, p10=pnts.c, p11=pnts.d}

grid0 = StructuredGrid:new{psurface=patch0, niv=3, njv=3}

blk0 = FluidBlock:new{grid=grid0, initialState=initial}

setHistoryPoint{ib=0, i=0, j=0}

-- Finish off config
config.max_time = 1e-1
config.max_step = 100000000
-- A time step of 1.0e-6 is good for the operator-split chemical update.
-- The backward-euler updates for the chemistry need to take finer steps
-- to get comparable accuracy.
config.dt_init = 1.0e-8
config.dt_history = 1.0e-7
config.dt_plot = 0.025
config.fixed_time_step = true