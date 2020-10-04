-- une étoile sur la minimap ; vérification de la présence de cette étoile dans la table de sauvegarde
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
-- affichage d'une ligne de chat et jeu d'une emote lorsqu'une nouvelle étoile est repérée
-- sauvegarde de la vignette reçue dans la liste
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
        DoEmote("WAVE")
    end
    if isDebuging then
        local log = string.format("Vignette %d = %s", intVignetteSave - 1, vInfo.name)
        printDebug(log)
    end
end
