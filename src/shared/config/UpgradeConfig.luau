return table.freeze({
    PointsPerSpeedLevel = 30,
    SpeedPerLevel = 1,
    MaxSpeedLevel = 24,
    TreadmillRates = table.freeze({6, 9, 14, 21, 30}),
    TreadmillCosts = table.freeze({75, 160, 300, 550}),
    CapacityByLevel = table.freeze({3, 6, 9, 12}),
    CapacityCosts = table.freeze({100, 240, 500}),
})
