--/---------------------------\--
--| Created By Bamboozle#9642 |--
--\---------------------------/--

ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("bamboozle-collecting:buyitems")
AddEventHandler("bamboozle-collecting:buyitems", function(action)
	local amount = 1500
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getMoney() >= amount then
		xPlayer.removeMoney(amount)
			
		TriggerClientEvent('bamboozle-collecting:startinkoop', _source)
	else
		exports['mythic_notify']:DoHudText('error', '[INFO] You dont have enough money!')
	end
end)

RegisterServerEvent('bamboozle-collecting:unload')
AddEventHandler('bamboozle-collecting:unload', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

	if Config.onesync then 
		if #(playerCoords - vec3(-26.73, 3026.16, 40.96)) <= 20.0 then
			xPlayer.addInventoryItem('barley', 10)
			xPlayer.addInventoryItem('yeast', 10)
			xPlayer.addInventoryItem('corn', 10)
			xPlayer.addInventoryItem('waterbucket', 10)
		else  
			print("Cheater: " .. GetPlayerName(src))
		end
	else
		xPlayer.addInventoryItem('barley', 10)
		xPlayer.addInventoryItem('yeast', 10)
		xPlayer.addInventoryItem('corn', 10)
		xPlayer.addInventoryItem('waterbucket', 10)
	end
end)

RegisterServerEvent("bamboozle-collecting:ketel")
AddEventHandler("bamboozle-collecting:ketel", function(action)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local amount = 5000
	
	if xPlayer.getMoney() >= amount then
		xPlayer.removeMoney(amount)
		xPlayer.addInventoryItem('boiler', 1)
	else
		exports['mythic_notify']:DoHudText('error', '[INFO] You dont have enough money!')
	end
end)

