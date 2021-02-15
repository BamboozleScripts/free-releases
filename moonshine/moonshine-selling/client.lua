--/---------------------------\--
--| Created By Bamboozle#9642 |--
--\---------------------------/--

ESX							= nil

local start					= true

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
		
		local verkoop = GetDistanceBetweenCoords(currentpos, 1642.72, 4846.05, 45.48, true)
		
		if start then
			if verkoop < 3 then
				DrawScriptText(vector3(1642.72, 4846.05, 45.48), '~g~E ~w~· Om spullen te verkopen!')
				if IsControlJustReleased(0, Keys["E"]) then
					DisableControlAction(0, 38, true)
					start = false
					
					openGeneralMenu('open')
				end
			else
				Wait(500)
			end
		end
	end
end)

function openGeneralMenu(value)
    local elements = {}
    local ped = GetPlayerPed(-1)

	if value == 'open' then
        table.insert(elements, {label = 'Verkoop', value = 'moonshine'})
        table.insert(elements, {label = 'Menu Sluiten', value = 'close'})
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'd',
        {
          title    = 'Illegale Drank Verkoop',
          align    = 'top-right',
          elements = elements,
        },
        function(data, menu)
    
        if data.current.value == 'moonshine' then
            menu.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Verkoop Moonshine',
            {
                title = 'Verkoop Moonshine - Zet aantal',
            }, function(data, menu2)
                local aantal = data.value
                if data.value == '' or data.value == nil then 
                    exports['mythic_notify']:DoHudText('error', '[ERROR] Ongeldige invoer')
					start = true
                elseif tonumber(data.value) > 0 and tonumber(data.value) < 241 then 
                    menu.close()
                    menu2.close()
                    local sellprice = 25
                    exports['mythic_notify']:DoHudText('inform', '[INFO] Moonshine Verkopen...')
                    RequestAnimDict("timetable@jimmy@doorknock@")
                    PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
                    Citizen.Wait(1500)
                    TriggerServerEvent('bamboozle-selling:SellMoonshine', sellprice, data.value)
					
					Wait(2500)
					
					start = true
                else 
					menu.close()
                    menu2.close()
                    exports['mythic_notify']:DoHudText('inform', '[INFO] Je kunt maximaal 240 flesjes verkopen')
					start = true
                end
            end, function(data, menu2)
                menu2.close()
				start = true
            end)
        end
        
        if data.current.value == 'close' then 
            menu.close()
			start = true
        end
      end,
      function(data, menu)
        menu.close()
		start = true
      end
    )
end

Citizen.CreateThread(function ()
    local blip = AddBlipForCoord(vector3(1642.72, 4846.05, 45.48))

    SetBlipSprite (blip, 436)
    SetBlipDisplay(blip, 2)
    SetBlipScale  (blip, 0.8)
    SetBlipAsShortRange(blip, true)
    SetBlipColour (blip, 1)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Moonshine: Verkoop')
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


PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

function MissionText(text,time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end