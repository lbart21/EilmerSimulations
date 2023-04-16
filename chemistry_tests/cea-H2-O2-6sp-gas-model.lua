model = "CEAGas"

CEAGas = {
    mixtureName = 'h2-o2-6sp',
    speciesList = {"H2", "O2", "O", "H", "OH", "H2O"},
    reactants = {H2=2/3, O2=1/3, O=0.0, H=0.0, OH=0.0, H2O=0.0},
    inputUnits = "moles",
    withIons = false,
    trace = 1.0e-6
}