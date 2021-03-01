--/---------------------------\--
--| Created By Bamboozle#9642 |--
--\---------------------------/--

ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('bamboozle-production:GetInventory', function (source, cb, boiler, corn, barley, yeast, water)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local boiler = xPlayer.getInventoryItem('boiler').count
	local corn = xPlayer.getInventoryItem('corn').count
	local barley = xPlayer.getInventoryItem('barley').count
	local yeast = xPlayer.getInventoryItem('yeast').count
	local water = xPlayer.getInventoryItem('waterbucket').count

    cb(boiler, bucket, corn, barley, yeast, water)
end)

RegisterServerEvent('bamboozle-production:RemoveWater')
AddEventHandler('bamboozle-production:RemoveWater', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	xPlayer.removeInventoryItem('waterbucket', 1)
end)

RegisterServerEvent('bamboozle-production:RemoveCorn')
AddEventHandler('bamboozle-production:RemoveCorn', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	xPlayer.removeInventoryItem('corn', 1)
end)

RegisterServerEvent('bamboozle-production:RemoveBarley')
AddEventHandler('bamboozle-production:RemoveBarley', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	xPlayer.removeInventoryItem('barley', 1)
end)

RegisterServerEvent('bamboozle-production:RemoveYeast')
AddEventHandler('bamboozle-production:RemoveYeast', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	xPlayer.removeInventoryItem('yeast', 1)
end)

RegisterServerEvent('bamboozle-production:GiveMoonshine')
AddEventHandler('bamboozle-production:GiveMoonshine', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local ped = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(ped)

	if Config.onesync then 
		if #(playerCoords - vec3(-36.83, 3030.73, 41.02)) <= 20.0 then
			xPlayer.addInventoryItem('moonshine', 24)
		else  
			print("Cheater: " .. GetPlayerName(src))
		end
	else
		xPlayer.addInventoryItem('moonshine', 24)
	end
end)

RegisterServerEvent('bamboozle-production:water')
AddEventHandler('bamboozle-production:water', function(currentposx,currentposy,currentposz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('bamboozle-production:water',xPlayers[i],currentposx,currentposy,currentposz, 'a') 
	end
	
end)

RegisterServerEvent('bamboozle-production:fire')
AddEventHandler('bamboozle-production:fire', function(currentposx,currentposy,currentposz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('bamboozle-production:fire',xPlayers[i],currentposx,currentposy,currentposz, 'a') 
	end
	
end)

RegisterServerEvent('bamboozle-production:smoke')
AddEventHandler('bamboozle-production:smoke', function(currentposx,currentposy,currentposz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('bamboozle-production:smoke',xPlayers[i],currentposx,currentposy,currentposz, 'a') 
	end
	
end)

