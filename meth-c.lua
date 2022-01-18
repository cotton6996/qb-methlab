local QBCore = exports['qb-core']:GetCoreObject() 

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }

isLoggedIn = true

local menuOpen = false
local wasOpen = false



local spawnedWeed = 0
local weedPlants = {}
local spawnedWeed2 = 0
local weedPlants2 = {}

--Coords for crafting the sodium
local sellX4 = 181.27
local sellY4 = 2778.28
local sellZ4 = 45.66


local isPickingUp, isProcessing, isProcessing2 = false, false, false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()

	CheckCoords2()
	CheckCoords2m()
	Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 10000 then
		SpawnWeedPlants2d()
	end
end)

--Spawn Location
RegisterNetEvent("QBCORE:client:OnPlayerLoaded", function()
if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField2.coords, true) < 10000 then
	SpawnWeedPlants2dm()
end
end)

function CheckCoords2()
	CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 10000 then
				SpawnWeedPlants2d()
			end
			Wait(1 * 60000)
		end
	end)
end
-------Second Spawn Location
function CheckCoords2m()
	CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField2.coords, true) < 10000 then
				SpawnWeedPlants2dm()
			end
			Wait(1 * 60000)
		end
	end)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CheckCoords2()
		CheckCoords2m()
	end
end)

CreateThread(function()--Meth
	while true do
		Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID
		
		
		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				QBCore.Functions.Draw2DText(0.5, 0.88, 'Press ~g~[E]~w~ to pickup Hydrocloric acid', 0.5)
			end
			local hasBagd = false
			local s1d = false
			if IsControlJustReleased(0, 38) and not isPickingUp then

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBagd = result
					s1d = true
				end, 'hydrochloric_bottle')
				while(not s1d) do
					Wait(100)
				end
				if (hasBagd) then
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, false)
				--PROP_HUMAN_BUM_BIN animazione
				--prop_cs_cardbox_01 oggetto di spawn  prop_plant_01a
				QBCore.Functions.Progressbar("search_register", "Picking up Acid..", 5000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					QBCore.Functions.DeleteObject(nearbyObject)

					table.remove(weedPlants, nearbyID)
					spawnedWeed = spawnedWeed - 1

					TriggerServerEvent('xd_drugs:metacid')
				end, function()
					ClearPedTasks(PlayerPedId())
				end) -- Cancel

				isPickingUp = false
			else
				QBCore.Functions.Notify('You dont have enough empty Bottle .', 'error')
			end	
			end
		else
			Wait(500)
		end
	end
end)
CreateThread(function()--weed
	while true do
		Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID
		
		
		for i=1, #weedPlants2, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants2[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants2[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				QBCore.Functions.Draw2DText(0.5, 0.88, 'Press ~g~[E]~w~ to pickup Sulfuric', 0.5)
			end
			local hasBagd = false
			local s1d = false
			if IsControlJustReleased(0, 38) and not isPickingUp then

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBagd = result
					s1d = true
				end, 'sulfuricacid_bottle')
				while(not s1d) do
					Wait(100)
				end
				if (hasBagd) then
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, false)
				--PROP_HUMAN_BUM_BIN Animation
				--prop_cs_cardbox_01 or prop_plant_01a
				QBCore.Functions.Progressbar("search_register", "Picking Sulfuric..", 5000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					QBCore.Functions.DeleteObject(nearbyObject)

					table.remove(weedPlants2, nearbyID)
					spawnedWeed2 = spawnedWeed2 - 1

					TriggerServerEvent('xd_drugs:metasodium')
				end, function()
					ClearPedTasks(PlayerPedId())
				end) -- Cancel

				isPickingUp = false
			else
				QBCore.Functions.Notify('You dont have enough empty Bottles .', 'error')
			end	
			end
		else
			Wait(500)
		end
	end
end)


AddEventHandler('onResourceStop', function(resource) --weedPlants
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			QBCore.Functions.DeleteObject(v)
		end
		for k, v in pairs(weedPlants2) do
			QBCore.Functions.DeleteObject(v)
		end
	end
end)
function SpawnWeedPlants2d() --This spawns in the Weed plants, 
	while spawnedWeed < 25 do
		Wait(1)
		local weedCoords = GenerateWeedCoords2()
--prop_barrel_01a  prop_plant_01a
		QBCore.Functions.CreateObject('prop_barrel_02b', weedCoords, function(obj) --- change this prop to whatever plant you are trying to use 
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			

			table.insert(weedPlants, obj)
			spawnedWeed = spawnedWeed + 1
		end)
	end
	Wait(45 * 60000)
end

--second spown
function SpawnWeedPlants2dm() --This spawns in the Weed plants, 
	while spawnedWeed2 < 25 do
		Wait(1)
		local weedCoords = GenerateWeedCoords2m()
--prop_barrel_01a  prop_plant_01a
		QBCore.Functions.CreateObject('prop_rad_waste_barrel_01', weedCoords, function(obj) --- change this prop to whatever plant you are trying to use 
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			

			table.insert(weedPlants2, obj)
			spawnedWeed2 = spawnedWeed2 + 1
		end)
	end
	Wait(45 * 60000)
end


function ValidateWeedCoord(plantCoord) --This is a simple validation checker
	if spawnedWeed > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords2() --This spawns the weed plants at the designated location
	while true do
		Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-5, 5)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-5, 5)

		weedCoordX = Config.CircleZones.WeedField.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField.coords.y + modY

		local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GenerateWeedCoords2m() --This spawns the weed plants at the designated location
	while true do
		Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-5, 5)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-5, 5)

		weedCoordX = Config.CircleZones.WeedField2.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField2.coords.y + modY

		local coordZ = GetCoordZWeed2(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoordm(coord) then
			return coord
		end
	end
end
function ValidateWeedCoordm(plantCoord) --This is a simple validation checker
	if spawnedWeed2 > 0 then
		local validate = true

		for k, v in pairs(weedPlants2) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField2.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GetCoordZWeed(x, y)
	local groundCheckHeights = { 27.0, 28.0, 29.0, 30.0, 31.0, 32.0, }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 29.81
end
function GetCoordZWeed2(x, y)
	local groundCheckHeights = { 22.0, 23.0, }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 22.85
end

CreateThread(function() --- check that makes sure you have the materials needed to process
	while QBCore == nil do
		Wait(200)
	end
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 1 then
			DrawMarker(20, Config.CircleZones.WeedProcessing.coords.x, Config.CircleZones.WeedProcessing.coords.y, Config.CircleZones.WeedProcessing.coords.z - 0.66 , 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 255, 100, 0, 0, 0, true, 0, 0, 0)

			
			if not isProcessing then
				QBCore.Functions.DrawText3D(Config.CircleZones.WeedProcessing.coords.x, Config.CircleZones.WeedProcessing.coords.y, Config.CircleZones.WeedProcessing.coords.z, 'Press ~g~[ E ]~w~ to Process Meth')
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				local hasBag = false
				local s1 = false
				local hasWeed = false
				local s2 = false
				local hasmet = false 
				local s2m = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasWeed = result
					s1 = true
				end, 'sulfuricacid')
				
				while(not s1) do
					Wait(100)
				end
				Wait(100)
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag = result
					s2 = true
				end, 'hydrochloric')
				
				while(not s2) do
					Wait(100)
				end
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasmet = result 
					s2m = true
				end, 'sodiumhydroxide')
				
				while(not s2m) do
					Wait(100)
				end

				if (hasWeed and hasBag and hasmet) then
					Processweed3d()
				
				else
					QBCore.Functions.Notify('you must have these materials, sulfuricacid, hydrochloric, sodiumhydroxide', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)

--paleto Goykz

CreateThread(function() --- check that makes sure you have the materials needed to process
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing2.coords, true) < 3 then
			DrawMarker(27, Config.CircleZones.WeedProcessing2.coords.x, Config.CircleZones.WeedProcessing2.coords.y, Config.CircleZones.WeedProcessing2.coords.z - 0.66 , 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 0, 0, 200, 0, 0, 0, 0)

			
			if not isProcessing then
				QBCore.Functions.DrawText3D(Config.CircleZones.WeedProcessing2.coords.x, Config.CircleZones.WeedProcessing2.coords.y, Config.CircleZones.WeedProcessing2.coords.z, 'Press ~g~[ E ]~w~ to Process Meth')
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				local hasBag = false
				local s1 = false
				local hasWeed = false
				local s2 = false
				local hasmet = false 
				local s2m = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasWeed = result
					s1 = true
				end, 'sulfuricacid')
				
				while(not s1) do
					Wait(100)
				end
				Wait(100)
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag = result
					s2 = true
				end, 'hydrochloric')
				
				while(not s2) do
					Wait(100)
				end
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasmet = result 
					s2m = true
				end, 'sodiumhydroxide')
				
				while(not s2m) do
					Wait(100)
				end

				if (hasWeed and hasBag and hasmet) then
					Processweed3d()
				
				else
					QBCore.Functions.Notify('you must have these materials, sulfuricacid, hydrochloric, sodiumhydroxide', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)

--paleto 2
CreateThread(function() --- check that makes sure you have the materials needed to process
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing3.coords, true) < 3 then
			DrawMarker(27, Config.CircleZones.WeedProcessing3.coords.x, Config.CircleZones.WeedProcessing3.coords.y, Config.CircleZones.WeedProcessing3.coords.z - 0.66 , 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 0, 0, 200, 0, 0, 0, 0)

			
			if not isProcessing3 then
				QBCore.Functions.DrawText3D(Config.CircleZones.WeedProcessing3.coords.x, Config.CircleZones.WeedProcessing3.coords.y, Config.CircleZones.WeedProcessing3.coords.z, 'Press ~g~[ E ]~w~ to Package Meth')
			end

			if IsControlJustReleased(0, 38) and not isProcessing3 then
				local hasBag3 = false
				local r1 = false
				local hasWeed3 = false
				local r2 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag3 = result
					r1 = true
				end, 'blue_meth')
				
				while(not r1) do
					Wait(100)
				end

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasWeed3 = result 
					r2 = true
				end, 'plastic_baggy')

				while(not r2) do
					Wait(100)
				end
				
				print(hasweed3)
				print(hasbag3)
				if (hasWeed3 and hasBag3) then
					Processweed3d2()
				
				else
					QBCore.Functions.Notify('you must have blue_meth', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)




function Processweed3d()  -- simple animations to loop while process is taking place
	isProcessing = true
	local playerPed = PlayerPedId()

	
	--
	--TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
	--SetEntityHeading(PlayerPedId(), 108.06254)
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
	--prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
	--SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
	LoadDict('amb@medic@standing@tendtodead@idle_a')
	TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
	
	QBCore.Functions.Progressbar("search_register", "Trying to Process..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
		
	}, {}, {}, {}, function()
		
	
	Wait(1000)
	LoadDict('amb@medic@standing@tendtodead@exit')
	TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
         
	    TriggerServerEvent('xd_drugs_weed:metprocess') -- Done

		local timeLeft = Config.Delays.WeedProcessing / 30000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 4 then
				TriggerServerEvent('xd_drugs_weed:cancelProcmet')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
         DeleteEntity(prop)
		--ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
         DeleteEntity(prop)
		--ClearPedTasks(PlayerPedId())
	end) -- Cancel
		
	
	isProcessing = false
	
end

-- paleto goykz 

function Processweed3d()  -- simple animations to loop while process is taking place
	isProcessing = true
	local playerPed = PlayerPedId()

	
	--
	--TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
	--SetEntityHeading(PlayerPedId(), 108.06254)
	--local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
	--prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
	SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
	LoadDict('amb@prop_human_bbq@male@idle_a')
	TaskPlayAnim(PlayerPedId(), 'amb@prop_human_bbq@male@idle_a', 'idle_c', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
	
	QBCore.Functions.Progressbar("search_register", "Trying to Process..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
		
	}, {}, {}, {}, function()
		
	
	Wait(1000)
	--LoadDict('amb@medic@standing@tendtodead@exit')
	--TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
         
	    TriggerServerEvent('xd_drugs_weed:metprocess') -- Done

		local timeLeft = Config.Delays.WeedProcessing2 / 30000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing2.coords, false) > 4 then
				TriggerServerEvent('xd_drugs_weed:cancelProcmet')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
         DeleteEntity(prop)
		--ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
         DeleteEntity(prop)
		--ClearPedTasks(PlayerPedId())
	end) -- Cancel
		
	
	isProcessing = false
	
end

function Processweed3d2()  -- simple animations to loop while process is taking place
	isProcessing3 = true
	local playerPed = PlayerPedId()

	
	--
	--TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
	--SetEntityHeading(PlayerPedId(), 108.06254)
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
	--prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
	SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
	LoadDict('amb@prop_human_bbq@male@idle_a')
	TaskPlayAnim(PlayerPedId(), 'amb@prop_human_bbq@male@idle_a', 'idle_c', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
	
	QBCore.Functions.Progressbar("search_register", "Trying to Process..", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
		
	}, {}, {}, {}, function()
		
	
	Wait(1000)
	--LoadDict('amb@medic@standing@tendtodead@exit')
	--TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
         
	    TriggerServerEvent('xd_drugs_weed:metprocess2') -- Done

		local timeLeft = Config.Delays.WeedProcessing3 / 5000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing3.coords, false) > 4 then
				TriggerServerEvent('xd_drugs_weed:cancelProcmet')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
         DeleteEntity(prop)
		--ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
         DeleteEntity(prop)
		--ClearPedTasks(PlayerPedId())
	end) -- Cancel
		
	
	isProcessing3 = false
	
end



CreateThread(function() --- check that makes sure you have the materials needed to process
	
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.DrugDealer.coords, true) < 1 then
			DrawMarker(20, Config.CircleZones.DrugDealer.coords.x, Config.CircleZones.DrugDealer.coords.y, Config.CircleZones.DrugDealer.coords.z - 0.66 , 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)

			
			if not isProcessing2 then
				QBCore.Functions.DrawText3D(Config.CircleZones.DrugDealer.coords.x, Config.CircleZones.DrugDealer.coords.y, Config.CircleZones.DrugDealer.coords.z, 'Press ~g~[ E ]~w~ to Sell Meth')
			end

			if IsControlJustReleased(0, 38) and not isProcessing2 then
				local hasBag = false
				local s1 = false
				local hasWeed2 = false
				local hasBag2 = false
				local s3 = false
				
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasWeed2 = result
					hasBag2 = result
					s3 = true
					
				end, 'blue_meth')
				
				while(not s3) do
					Wait(100)
				end
				

				if (hasWeed2) then
					SellDrug3()
				elseif (hasWeed2) then
					QBCore.Functions.Notify('You dont have blue_meth.', 'error')
				elseif (hasBag2) then
					QBCore.Functions.Notify('You dont have blue_meth.', 'error')
				else
					QBCore.Functions.Notify('You dont have blue_meth.', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)

function SellDrug3()  -- simple animations to loop while process is taking place
	isProcessing2 = true
	local playerPed = PlayerPedId()

	--
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
	prop = CreateObject(GetHashKey('prop_luggage_07a'), x, y, z,  true,  true, true)
	SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
	LoadDict('amb@medic@standing@tendtodead@idle_a')
	TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)

	QBCore.Functions.Progressbar("search_register", "Trying to Process..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	  -- Done
	  --Wait(1000)
	  LoadDict('amb@medic@standing@tendtodead@exit')
	  TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)

	  TriggerServerEvent('xd_drugs_weed:sellmeth')
		local timeLeft = Config.Delays.WeedProcessing / 30000

		while timeLeft > 0 do
			Wait(500)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 4 then
				--TriggerServerEvent('xd_drugs_weed:cancelProcessing2d')
				ClearPedTasks(PlayerPedId())
                 DeleteEntity(prop)
				break
			end
		end
		ClearPedTasks(PlayerPedId())
         DeleteEntity(prop)
		
		
	end, function()
		ClearPedTasks(PlayerPedId())
         DeleteEntity(prop)
	end) -- Cancel
		
	
	isProcessing2 = false
end


-----------------------------------------------PROCESS CRAFT SODIUM-----------------------------------------------
CreateThread(function()
    while true do
        Wait(0)
        -----------------------------------------------LOCAL------------------------------------------------------

        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        ---local distanza marker 1----------------------
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX4, sellY4, sellZ4)
      
        ---end local distanza marker 1------------------
       
        local vehicled = GetVehiclePedIsIn(PlayerPedId(), true)
        local playerPeds = PlayerPedId()

        --Marker

		if dist <= 10.0 then
			DrawMarker(27, sellX4, sellY4, sellZ4-0.96, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
            --DrawMarker(20, sellX4, sellY4, sellZ4 + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.2, 0.2, 15, 255, 55, 255, true, false, false, true, false, false, false)
        end
            
        -------------------------------------------fine marker pavimento-----------------------------------------
        --####################################################################################################---

        --Inputs marker 1
        if dist <= 3.0 then

            --Checks if client is in the vehicle
		    if GetPedInVehicleSeat(vehicled, -1) == PlayerPedId() then
              --Checks if your in the vehicle
            else
                --If its correct it runs

                --Drawing the text
                DrawText3D2(sellX4, sellY4, sellZ4+0.1,'~g~[E]~w~ Sodium Hidroxyde')
                
                -----------Press E
                if IsControlJustPressed(0, Keys['E']) then 

                --Controls the xp
                local hasBagd7 = false
                local s1d7 = false
                
				--Checks if you have the right amount if xp points
               
                         --check if I have the item
                                        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result2)
                                        hasBagd7 = result2
                                        s1d7 = true
                                        end, 'plastic_baggy')
                                        while(not s1d7) do
                                        Wait(100)
                                        end
                                        
                                                  ----Checks if you have the right items
                                                    if (hasBagd7) then
                                                          --Starts
                                                          procOn()
                                  
                                                    else
                                                      QBCore.Functions.Notify('you don\'t have plastic_baggy', 'error')
                                                    end
                      
                        

                end	
            end
		end	
    end
end)



--Does the crafting animation
function procOn()
    -- local
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local inventory = QBCore.Functions.GetPlayerData().inventory
    local count = 0
    ----
    if(count == 0) then
    QBCore.Functions.Progressbar("search_register", "Pikup sodium hydroxide", 5000, false, true, {disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()end, function()
                        
                    end)
         local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
         prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
         SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
         LoadDict('amb@medic@standing@tendtodead@idle_a')
         TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
         Wait(5000)
         --LoadDict('amb@medic@standing@tendtodead@exit')
         --TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
         ClearPedTasks(PlayerPedId())
         DeleteEntity(prop)
         TriggerServerEvent('craft:sodium')
    else
    
    
    end
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Wait(10)
    end
end
--Ends crafting 1


--Draws 3D text
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3D2(x, y, z, text)
  
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end