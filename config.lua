Config = {}

Config.Locale = 'en'

Config.Delays = {
	WeedProcessing = 1000 * 1
}

Config.Pricesell = 15000

Config.MinPiecesWed = 1



Config.DrugDealerItems = {
	empty_weed_bag = 91
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 



Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	WeedField = {coords = vector3(1164.23, -2215.11, 30.81), name = 'blip_weedfield', color = 25, sprite = 496, radius = 30.0}, --postal 801
	WeedField2 = {coords = vector3(2902.6, 1587.0, 18.51), name = 'blip_weedfield', color = 25, sprite = 496, radius = 30.0}, --postal 341 
	WeedProcessing = {coords = vector3(604.0, -3057.04, 6.17), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	WeedProcessing2 = {coords = vector3(-49.89, 6375.4, 28.96), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	WeedProcessing3 = {coords = vector3(-50.22, 6366.41, 29.28), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	DrugDealer = {coords = vector3(213.86, -148.74, 58.81), name = 'blip_drugdealer', color = 6, sprite = 378, radius = 25.0},
}


--Building Location: 158.838 3134.578 43.495