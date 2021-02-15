--/---------------------------\--
--| Created By Bamboozle#9642 |--
--\---------------------------/--

ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("bamboozle-collecting:buyitems")
AddEventHandler("bamboozle-collecting:buyitems", function(amount, action)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getMoney() >= amount then
		xPlayer.removeMoney(amount)
			
		TriggerClientEvent('bamboozle-collecting:startinkoop', _source)
	else
		exports['mythic_notify']:DoHudText('error', '[INFO] Je komt geld tekort!')
	end
end)

RegisterServerEvent('bamboozle-collecting:unload')
AddEventHandler('bamboozle-collecting:unload', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	
	xPlayer.addInventoryItem('barley', 10)
	xPlayer.addInventoryItem('yeast', 10)
	xPlayer.addInventoryItem('corn', 10)
	xPlayer.addInventoryItem('waterbucket', 10)
end)

RegisterServerEvent("bamboozle-collecting:ketel")
AddEventHandler("bamboozle-collecting:ketel", function(amount, action)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getMoney() >= amount then
		xPlayer.removeMoney(amount)
		xPlayer.addInventoryItem('boiler', 1)
	else
		exports['mythic_notify']:DoHudText('error', '[INFO] Je komt geld tekort!')
	end
end)