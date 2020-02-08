function checkVignetteSave(vInfo)
    for ind=1, intVignetteMax, 1 do
        if tableVignetteSave[ind] == vInfo.objectGUID then
            if isDebuging then
                log = string.format("Vignette trouvée %d", ind)
                printDebug(log)
            end
            return true
        end
    end
    return false
end

function sendInfoVignette(vInfo)
    tableVignetteSave[intVignetteSave] = vInfo.objectGUID
    intVignetteSave = (intVignetteSave + 1) % intVignetteMax
    local type, _, iServer, iInstance, iZone, iNpc, iSpawn = strsplit("-", vInfo.objectGUID)
    ChatFrame1:SetAlpha(1)
    C_Timer.After(6, function() checkHide() end)
    local msg = string.format("ALERTE %s : %s à proximité", type, vInfo.name)
    if UnitInParty("player") then
        SendChatMessage(msg, "PARTY")
    else
        SendChatMessage(msg, "EMOTE")
    end
    if type == "Creature" then
        DoEmote("ATTACKMYTARGET")
    elseif type == "GameObject" then
        DoEmote("KISS")
    end
    if isDebuging then
        local log = string.format("Vignette %d = %s", intVignetteSave - 1, vInfo.name)
        printDebug(log)
    end
end
