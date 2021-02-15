--/---------------------------\--
--| Created By Bamboozle#9642 |--
--\---------------------------/--

ESX							= nil

local start					= true
local boilerplaced			= false
local wateradded			= false
local mais					= false
local gerst					= false
local gist					= false
local roeren				= false
local schenken				= false

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end
	
    PlayerData = ESX.GetPlayerData()
    Citizen.Wait(10)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		
		local ped 			= GetPlayerPed(-1)
		local currentpos	= GetEntityCoords(ped)
		
		local production	= GetDistanceBetweenCoords(currentpos, -36.83, 3030.73, 41.02, true)
		
		if start then
			if production < 3 then
				DrawScriptText(vector3(-36.83, 3030.73, 41.02), '~g~E ~w~· Start production!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					start = false
					
					SetEntityCoords(ped, -36.83, 3030.73, 40.12)
					SetEntityHeading(ped, 30.24)
					
					ESX.TriggerServerCallback('bamboozle-production:GetInventory', function (boiler, bucket, corn, barley, yeast, water, cb, source)
						if boiler < 1 then
							exports['mythic_notify']:DoHudText('error', '[INFO] You dont have a boiler')
							start = true
						else
							exports['mythic_notify']:DoHudText('success', '[INFO] Placing boiler')
							
							ESX.Game.SpawnObject(304964818, vector3(-37.29, 3031.43, 40.02), function(tafel)
								SetEntityHeading(tafel, 29.95)
								FreezeEntityPosition(tafel, true)
								tafelspawn = tafel
							end)
							
							RequestAnimDict("mini@repair")							
							TaskPlayAnim((GetPlayerPed(-1)),"mini@repair","fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
							
							exports['progressBars']:startUI((2500), "Placing boiler...")
							
							Wait(2500)
							
							ESX.Game.SpawnObject(603786675, vector3(-37.29, 3031.43, 40.90), function(boiler)
								SetEntityHeading(boiler, 36.6)
								FreezeEntityPosition(boiler, true)
								boilerspawn = boiler
							end)
							
							boilerplaced = true
							
							ClearPedTasksImmediately(ped)

							DisableControlAction(0, 38, false)
						end
					end)
				end
			else
				Wait(500)
			end
		end
		
		if boilerplaced then
			if production < 3 then
				DrawScriptText(vector3(-36.83, 3030.73, 41.02), '~g~E ~w~· Add water!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					boilerplaced = false
					
					ESX.TriggerServerCallback('bamboozle-production:GetInventory', function (boiler, bucket, corn, barley, yeast, water, cb, source)
						if water < 1 then
							exports['mythic_notify']:DoHudText('error', '[INFO] You dont have enough water')
							boilerplaced = true
						else
							exports['mythic_notify']:DoHudText('success', '[INFO] Pouring water')
								
							RequestAnimDict("mini@repair")							
							TaskPlayAnim((GetPlayerPed(-1)),"mini@repair","fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
							
							TriggerServerEvent('bamboozle-production:water', -37.29, 3031.43, 42.0)
							
							exports['progressBars']:startUI((5000), "Pouring...")
								
							Wait(5000)
							
							wateradded = true
							
							TriggerServerEvent('bamboozle-production:RemoveWater')
								
							ClearPedTasksImmediately(ped)

							DisableControlAction(0, 38, false)
						end
					end)
				end
			else
				Wait(500)		
			end
		end
		
		if wateradded then
			if production < 3 then
				DrawScriptText(vector3(-36.83, 3030.73, 41.02), '~g~E ~w~· Heat up water!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					wateradded = false
					
					exports['mythic_notify']:DoHudText('success', '[INFO] Heating up the water')
							
					RequestAnimDict("mini@repair")							
					TaskPlayAnim((GetPlayerPed(-1)),"mini@repair","fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
					
					TriggerServerEvent('bamboozle-production:fire', -37.29, 3031.43, 40.0)
					TriggerServerEvent('bamboozle-production:smoke', -37.29, 3031.43, 39.3)
							
					exports['progressBars']:startUI((5000), "Heating...")
							
					Wait(5000)
						
					vuur = true					
							
					ClearPedTasksImmediately(ped)

					DisableControlAction(0, 38, false)
				end
			else
				Wait(500)		
			end
		end
		
		if vuur then
			if production < 3 then
				DrawScriptText(vector3(-36.83, 3030.73, 41.02), '~g~E ~w~· Add flaked corn maize!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					vuur = false
					
					ESX.TriggerServerCallback('bamboozle-production:GetInventory', function (boiler, bucket, corn, barley, yeast, water, cb, source)
						if corn < 1 then
							exports['mythic_notify']:DoHudText('error', '[INFO] You dont have enough flakes corn maize')
							vuur = true
						else
							exports['mythic_notify']:DoHudText('success', '[INFO] Adding flaked corn maize')
								
							RequestAnimDict("mini@repair")							
							TaskPlayAnim((GetPlayerPed(-1)),"mini@repair","fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
							
							TriggerServerEvent('bamboozle-production:smoke', -37.29, 3031.43, 39.3)
							
							exports['progressBars']:startUI((5000), "Adding...")
								
							Wait(5000)
							
							mais = true
							
							TriggerServerEvent('bamboozle-production:RemoveCorn')
								
							ClearPedTasksImmediately(ped)

							DisableControlAction(0, 38, false)
						end
					end)
				end
			else
				Wait(500)		
			end
		end
		
		if mais then
			if production < 3 then
				DrawScriptText(vector3(-36.83, 3030.73, 41.02), '~g~E ~w~· Add crushed malted barley!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					mais = false
					
					ESX.TriggerServerCallback('bamboozle-production:GetInventory', function (boiler, bucket, corn, barley, yeast, water, cb, source)
						if barley < 1 then
							exports['mythic_notify']:DoHudText('error', '[INFO] You dont have enough crushed malted barley')
							mais = true
						else
							exports['mythic_notify']:DoHudText('success', '[INFO] Adding crushed malted barley')
								
							RequestAnimDict("mini@repair")							
							TaskPlayAnim((GetPlayerPed(-1)),"mini@repair","fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
							
							TriggerServerEvent('bamboozle-production:smoke', -37.29, 3031.43, 39.3)
							
							exports['progressBars']:startUI((5000), "Adding...")
								
							Wait(5000)
							
							gerst = true
							
							TriggerServerEvent('bamboozle-production:RemoveBarley')
								
							ClearPedTasksImmediately(ped)

							DisableControlAction(0, 38, false)
						end
					end)
				end
			else
				Wait(500)		
			end
		end
		
		if gerst then
			if production < 3 then
				DrawScriptText(vector3(-36.83, 3030.73, 41.02), '~g~E ~w~· Add yeast!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					gerst = false
					
					ESX.TriggerServerCallback('bamboozle-production:GetInventory', function (boiler, bucket, corn, barley, yeast, water, cb, source)
						if yeast < 1 then
							exports['mythic_notify']:DoHudText('error', '[INFO] You dont have enough yest')
							gerst = true
						else
							exports['mythic_notify']:DoHudText('success', '[INFO] Adding yeast')
								
							RequestAnimDict("mini@repair")							
							TaskPlayAnim((GetPlayerPed(-1)),"mini@repair","fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
							
							TriggerServerEvent('bamboozle-production:smoke', -37.29, 3031.43, 39.3)
							
							exports['progressBars']:startUI((5000), "Adding...")
								
							Wait(5000)
							
							gist = true
							
							TriggerServerEvent('bamboozle-production:RemoveYeast')
								
							ClearPedTasksImmediately(ped)

							DisableControlAction(0, 38, false)
						end
					end)
				end
			else
				Wait(500)		
			end
		end
		
		if gist then
			if production < 3 then
				DrawScriptText(vector3(-36.83, 3030.73, 41.02), '~g~E ~w~· Stir!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					gist = false

					exports['mythic_notify']:DoHudText('success', '[INFO] Stirring')
								
					RequestAnimDict("mini@repair")							
					TaskPlayAnim((GetPlayerPed(-1)),"mini@repair","fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
							
					TriggerServerEvent('bamboozle-production:smoke', -37.29, 3031.43, 39.3)
					
					exports['progressBars']:startUI((5000), "Stirring...")
								
					Wait(5000)
							
					roeren = true
								
					ClearPedTasksImmediately(ped)

					DisableControlAction(0, 38, false)
				end
			else
				Wait(500)		
			end
		end
		
		if roeren then
			if production < 3 then
				DrawScriptText(vector3(-36.83, 3030.73, 41.02), '~g~E ~w~ Extract moonshine!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					roeren = false

					exports['mythic_notify']:DoHudText('success', '[INFO] Extracting moonshine')
								
					RequestAnimDict("mini@repair")							
					TaskPlayAnim((GetPlayerPed(-1)),"mini@repair","fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
							
					TriggerServerEvent('bamboozle-production:smoke', -37.29, 3031.43, 39.3)
					
					exports['progressBars']:startUI((5000), "Extracting...")
								
					Wait(5000)
							
					schenken = true
					start = true
					
					TriggerServerEvent('bamboozle-production:GiveMoonshine')
								
					ClearPedTasksImmediately(ped)

					DisableControlAction(0, 38, false)
				end
			else
				Wait(500)		
			end
		end
		
		if schenken == true then
			DeleteEntity(boilerspawn)
			DeleteEntity(tafelspawn)
			schenken = false
		end	
	end
end)

function DrawScriptText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords["x"], coords["y"], coords["z"])
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370

    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end

Citizen.CreateThread(function ()
    local blip = AddBlipForCoord(vector3(-36.83, 3030.73, 41.02))

    SetBlipSprite (blip, 436)
    SetBlipDisplay(blip, 2)
    SetBlipScale  (blip, 0.8)
    SetBlipAsShortRange(blip, true)
    SetBlipColour (blip, 1)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Moonshine: Productie')
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('bamboozle-production:water')
AddEventHandler('bamboozle-production:water', function(currentposx, currentposy, currentposz, bool)
		
	if bool == 'a' then

		if not HasNamedPtfxAssetLoaded("scr_carwash") then
			RequestNamedPtfxAsset("scr_carwash")
			while not HasNamedPtfxAssetLoaded("scr_carwash") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("scr_carwash")
		local test = StartParticleFxLoopedAtCoord("ent_amb_car_wash", currentposx, currentposy, currentposz, 0.0, 0.0, 0.0, 0.4, false, false, false, false)
		SetParticleFxLoopedAlpha(test, 0.2)
		SetParticleFxLoopedColour(test, 0.0, 0.0, 0.0, 0)
		Citizen.Wait(5000)
		StopParticleFxLooped(test, 0)
	else
		StopParticleFxLooped(test, 0)
	end

end)

RegisterNetEvent('bamboozle-production:fire')
AddEventHandler('bamboozle-production:fire', function(currentposx, currentposy, currentposz, bool)
		
	if bool == 'a' then

		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local test = StartParticleFxLoopedAtCoord("fire_wrecked_train", currentposx, currentposy, currentposz, 0.0, 0.0, 0.0, 0.8, false, false, false, false)
		SetParticleFxLoopedAlpha(test, 0.2)
		SetParticleFxLoopedColour(test, 0.0, 0.0, 0.0, 0)
		Citizen.Wait(5000)
		StopParticleFxLooped(test, 0)
	else
		StopParticleFxLooped(test, 0)
	end

end)

RegisterNetEvent('bamboozle-production:smoke')
AddEventHandler('bamboozle-production:smoke', function(currentposx, currentposy, currentposz, bool)
		
	if bool == 'a' then

		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local smoke = StartParticleFxLoopedAtCoord("ent_amb_smoke_foundry", currentposx, currentposy, currentposz + 1.7, 0.0, 0.0, 0.0, 5.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.2)
		SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
		Citizen.Wait(5000)
		StopParticleFxLooped(smoke, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end

end)