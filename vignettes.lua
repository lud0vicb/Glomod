function checkVignetteSave(vInfo)
    for ind=1,12,1 do
        if tableVignetteSave[ind] == vInfo.objectGUID then
            --msg = string.format("Vignette %s déjà connue", vInfo.objectGUID)
            --SendChatMessage(msg, "WHISPER", nil, GetUnitName("player"))
            return true
        end
    end
    return false
end

function sendInfoVignette(vInfo)
    tableVignetteSave[intVignetteSave] = vInfo.objectGUID
    intVignetteSave = (intVignetteSave + 1) % 12
    local type, _, iServer, iInstance, iZone, iNpc, iSpawn = strsplit("-", vInfo.objectGUID)
    ChatFrame1:SetAlpha(1)
    local msg = string.format("ALERTE %s : %s à proximité", type, vInfo.name)
    if UnitInParty("player") then
        SendChatMessage(msg, "PARTY")
    else
        SendChatMessage(msg, "EMOTE")
    end
    if type == "Creature" then
        DoEmote("OPENFIRE")
    elseif type == "GameObject" then
        DoEmote("CHARGE")
    end
    --local msg = string.format("%s sauvée dans %d", vInfo.objectGUID, intVignetteSave - 1)
    --SendChatMessage(msg, "WHISPER", nil, GetUnitName("player"))
end
