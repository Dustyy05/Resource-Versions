RegisterCommand(Dusty.Set_Command, function(source, args, rawCommand)
    local radius = tonumber(args[1])
    if IsPlayerAceAllowed(source, Dusty.Ace_Permissions) then
            TriggerClientEvent("Dusty:SetADA", -1, source, radius)
    else
        TriggerClientEvent("chatMessage", source, "^*^1Insufficient Permissions.")
    end
end)

RegisterCommand(Dusty.Clear_Command, function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Dusty.Ace_Permissions) then
        TriggerClientEvent("Dusty:ClearADA", -1, source)
    else
        TriggerClientEvent("chatMessage", source, "^*^1Insufficient Permissions.")
    end
end)
