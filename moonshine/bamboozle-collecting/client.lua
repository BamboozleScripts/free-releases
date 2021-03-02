--/---------------------------\--
--| Created By Bamboozle#9642 |--
--\---------------------------/--

ESX							= nil

local start					= true
local npcspawned			= false
local moonshinecar			= false

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
		
		RequestModel(GetHashKey("a_m_m_farmer_01"))
	
		while not HasModelLoaded(GetHashKey("a_m_m_farmer_01")) do
			Citizen.Wait(1)
		end
		
		local ped 			= GetPlayerPed(-1)
		local currentpos	= GetEntityCoords(ped)
		
		local inkoop = GetDistanceBetweenCoords(currentpos, 2436.45, 4976.77, 46.57, true)
		
		if start then
			if inkoop < 50 then
				if npcspawned == false then
					npc = CreatePed(4, "a_m_m_farmer_01", 2436.45, 4976.77, 45.67, 50.01, false, true)
					FreezeEntityPosition(npc, true)	
					SetEntityInvincible(npc, true)
					SetBlockingOfNonTemporaryEvents(npc, true)
					npcspawned = true
				end
			else
				Wait(500)
				
				FreezeEntityPosition(npc, false)	
				SetEntityInvincible(npc, false)
				SetBlockingOfNonTemporaryEvents(npc, false)
				DeletePed(npc)
				npcspawned = false
			end
			
			if inkoop < 3 then
				DrawScriptText(vector3(2436.45, 4976.77, 46.57), '~g~E ~w~· Buyin menu!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					start = false
					
					local ped = PlayerPedId()

					ESX.UI.Menu.CloseAll()
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cocaina_laptop', {
							title = ("Moonshine Markt"),
							align = "top-left",
							elements = {
								{label = ("Buy Boiler"), value = "buy_ketel"},
								{label = ("Moonshine Packet"), value = "buy_items"},
						}}, function(data, menu)
							if data.current.value == "buy_ketel" then
								TriggerServerEvent("bamboozle-collecting:ketel", action)
											
								ESX.UI.Menu.CloseAll()
												
								Wait(2500)
								
								start = true
							elseif data.current.value == "buy_items" then
								TriggerServerEvent("bamboozle-collecting:buyitems", action)
								
								moonshinecar = true
											
								ESX.UI.Menu.CloseAll()
												
								Wait(2500)
								
								start = true	
							end
						end, function(data, menu)
							menu.close()
							
							start = true
					end)
				end
			else
				Wait(500)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		
		RequestModel(GetHashKey("a_m_m_farmer_01"))
	
		while not HasModelLoaded(GetHashKey("a_m_m_farmer_01")) do
			Citizen.Wait(1)
		end
		
		local ped 			= GetPlayerPed(-1)
		local currentpos	= GetEntityCoords(ped)
		local vehModel 		= GetEntityModel(GetVehiclePedIsIn(ped, false))

		local uitpakken = GetDistanceBetweenCoords(currentpos, -26.73, 3026.16, 40.96, true)
		
		if moonshinecar then
			if uitpakken < 3 and vehModel == GetHashKey("speedo4") then
				RemoveBlip(deliverblip)
				DrawScriptText(vector3(-26.73, 3026.16, 40.96), '~g~E ~w~· Unload vehicle!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					
					exports['mythic_notify']:DoHudText('success', '[SUCCESS] Vehicle is being unloaded!')
							
					local Veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
					SetVehicleDoorOpen(Veh,2,0,0)
					SetVehicleDoorOpen(Veh,3,0,0)
							
					exports['progressBars']:startUI((6000), "Uitladen...")
							
					Wait(5000)
							
					SetVehicleDoorShut(Veh,2,0,0)
					SetVehicleDoorShut(Veh,3,0,0)
							
					Wait(1000)
					
					TriggerServerEvent('bamboozle-collecting:unload')
					exports['mythic_notify']:DoHudText('success', '[SUCCESS] Vehicle is being unloaded!')
					moonshinecar = false
					
					DisableControlAction(0, 38, false)
				end
			else
				Wait(500)
			end
		end
	end
end)

RegisterNetEvent('bamboozle-collecting:startinkoop')
AddEventHandler('bamboozle-collecting:startinkoop', function()
	RequestModel(219613597)

	startervehicle = CreateVehicle(219613597, 2423.79, 4958.59, 45.91, 44.04, true, false) 
			
	ClearAreaOfVehicles(GetEntityCoords(startervehicle), 50, false, false, false, false, false)
	SetVehicleOnGroundProperly(startervehicle)

	deliverblip = AddBlipForCoord(-26.73, 3026.16)
		SetBlipSprite(deliverblip, 436)
		SetBlipColour(deliverblip, 1)
		AddTextComponentString("Uitladen")
		EndTextCommandSetBlipName(deliverblip)
		SetBlipAsShortRange(deliverblip, false)
		SetBlipAsMissionCreatorBlip(deliverblip, true)
	SetBlipRoute(deliverblip, 1)
	
	MissionText("Take the ~r~car~w~ and go the the destinition ", 20000)
end)

Citizen.CreateThread(function ()
    local blip = AddBlipForCoord(vector3(2436.45, 4976.77, 46.57))

    SetBlipSprite (blip, 436)
    SetBlipDisplay(blip, 2)
    SetBlipScale  (blip, 0.8)
    SetBlipAsShortRange(blip, true)
    SetBlipColour (blip, 1)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Moonshine: Buyin')
    EndTextCommandSetBlipName(blip)
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

function MissionText(text,time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end