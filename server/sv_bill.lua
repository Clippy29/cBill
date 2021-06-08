ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("cBill:SendBill")
AddEventHandler("cBill:SendBill", function(bill)
    local xPlayer = ESX.GetPlayerFromId(source)
    bill.source = source
    
    TriggerClientEvent('esx:showNotification', xPlayer.source, "~b~Vous avez bien envoyé la demande.")
    TriggerClientEvent("cBill:GetBill", bill.playerId, bill)
end)

RegisterServerEvent("cBill:PayBills")
AddEventHandler("cBill:PayBills",function(bill, price)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local rPlayer = ESX.GetPlayerFromId(bill.source)
    local xMoney = xPlayer.getMoney()
    local bMoney = xPlayer.getAccount('bank').money
    print(price)
    if xMoney >= price then 
        TriggerClientEvent("cBill:AlertBill", bill.source, 1)
        xPlayer.removeMoney(price)
        if bill.solo then 
            rPlayer.addMoney(price)
        elseif bill.account then 
            TriggerEvent('esx_addonaccount:getSharedAccount', bill.account, function(account)
                account.addMoney(price)
            end)
        end
        TriggerClientEvent('esx:showNotification', _source, "Vous avez payé la facture de: ~b~"..price.."$~s~.")
    else
        if bMoney >= price then 
            TriggerClientEvent("cBill:AlertBill", bill.source, 1)
            xPlayer.removeAccountMoney("bank", price)
            if bill.solo then 
                rPlayer.addAccountMoney("bank", price)
            elseif bill.account then 
                TriggerEvent('esx_addonaccount:getSharedAccount', bill.account, function(account)
                    account.addMoney(price)
                end)
            end
            TriggerClientEvent('esx:showNotification', _source, "Vous avez payé la facture de: ~b~"..price.."$~s~.")
        else
            TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent.")
            TriggerClientEvent("cBill:AlertBill", bill.source, 2)
        end
    end
end)