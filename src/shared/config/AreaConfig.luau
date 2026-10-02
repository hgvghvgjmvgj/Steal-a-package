-- Every stage rolls the full rarity catalogue. Independent test pools.
return table.freeze({
    {Id="StarterStreet", Name="Starter Street", CenterX=100, Reward=50, ChaserSpeed=13, Color=Color3.fromRGB(170,180,170), RarityWeights={70,20,7,2.3,0.6,0.09,0.01}},
    {Id="Neighborhood", Name="Neighborhood", CenterX=200, Reward=90, ChaserSpeed=16, Color=Color3.fromRGB(155,170,185), RarityWeights={55,28,12,3.5,1.2,0.25,0.05}},
    {Id="RichStreet", Name="Rich Street", CenterX=300, Reward=140, ChaserSpeed=20, Color=Color3.fromRGB(185,175,155), RarityWeights={45,31,16,5.5,2,0.4,0.1}},
    {Id="Mansion", Name="Mansion", CenterX=400, Reward=210, ChaserSpeed=24, Color=Color3.fromRGB(175,160,185), RarityWeights={35,33,22,7,2.3,0.5,0.2}},
    {Id="Facility", Name="Facility", CenterX=500, Reward=300, ChaserSpeed=28, Color=Color3.fromRGB(155,180,180), RarityWeights={25,32,29,10,3,0.7,0.3}},
})
