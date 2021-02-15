--/---------------------------\--
--| Created By Bamboozle#9642 |--
--\---------------------------/--

ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('bamboozle-selling:SellMoonshine')
AddEventHandler('bamboozle-selling:SellMoonshine', function(sellprice, value)
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source)
	local moonshine = xPlayer.getInventoryItem('moonshine').count
	local price = sellprice * value
	local identifier = xPlayer.identifier
	local drug = 'Moonshine'

	if moonshine >= tonumber(value) then 
		xPlayer.removeInventoryItem('moonshine', value)
		xPlayer.addAccountMoney('black_money', price)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold '.. value .. ' Moonshine for ' .. price .. ' black money!'})
		sendtoDiscord(_source, xPlayer.identifier, sellprice, value, drug, price)
	else 
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have enough bottles!'})
	end
end)

function sendtoDiscord(id, player, price, value, drug, totalprice)
	local spelernaam = GetPlayerName(id)
	local k = GetPlayerEndpoint(id)
    local WebHook = ""
	
		local discordInfo = {
			["color"] = "16711680",
			["type"] = "rich",
			["title"] = "[Bamboozle Scripts]",
			["description"] = player .. " (" .. spelernaam .. ") Sold " .. value .. 'x ' .. drug .. ' for '.. price ..' dollar **EACH** and made ' .. totalprice .. ' total',
			["footer"] = {
			["text"] = "Bamboozle Scripts - Logger" 
			}
		}
		PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Bamboozle Scripts', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
		if price > 3000 then 
			PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Bamboozle Scripts', content = "@everyone" }), { ['Content-Type'] = 'application/json'})
			PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Bamboozle Scripts', content = "**HACKER**" }), { ['Content-Type'] = 'application/json'})
		end
		if totalprice > 1000000 then
			PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Bamboozle Scripts', content = "@everyone" }), { ['Content-Type'] = 'application/json'})
			PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Bamboozle Scripts', content = "**BUG ABUSER**" }), { ['Content-Type'] = 'application/json'})
		end
	
end