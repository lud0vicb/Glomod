-- évènement entrée dans un véhicule
function myHandlers:UNIT_ENTERING_VEHICLE(event, target)
    if target ~= "player" then
        return
    end
    moveCam(intVehicleZoom)
    isZoomOn = false
end
-- évènement sortie d'un véhicule
function myHandlers:UNIT_EXITING_VEHICLE(event, target)
    if target ~= "player" then
        return
    end
    isZoomOn = gloptions[6]
    moveCam(intFeetZoom)
    MicroButtonAndBagsBar:Hide()
    MicroButtonAndBagsBar:Show()
end
-- évènement la vie n'est plus régénérée I.E. début combat
function myHandlers:PLAYER_REGEN_DISABLED()
    isInCombat = true
    combatHide()
    showAll()
    combatCamIn()
end
-- évènement la vie est régénérée I.E. fin de combat
function myHandlers:PLAYER_REGEN_ENABLED()
    isInCombat = false
    isFading = false
    checkHide()
    combatHide()
    combatCamOut()
    --DoEmote("BYE")
end
-- évènement les étoiles sur la minimap ont changé
function myHandlers:VIGNETTE_MINIMAP_UPDATED(event, id, isVisible)
    if not isVisible then
        return
    end
    vInfo = C_VignetteInfo.GetVignetteInfo(id)
    if checkVignetteSave(vInfo) then
        return
    end
    sendInfoVignette(vInfo)
end
-- évènement début d'un lancement de sort à chargement
function myHandlers:UNIT_SPELLCAST_START()
end
-- évènement personnage s'arrête de bouger
function myHandlers:PLAYER_STOPPED_MOVING()
    moved()
end
-- évènement personnage commence à bouger
function myHandlers:PLAYER_STARTED_MOVING()
    moved()
end
-- évènement personnage commence à tourner
function myHandlers:PLAYER_STARTED_TURNING()
    moved()
end
-- évènement personnage quitte un combat
function myHandlers:PLAYER_LEAVE_COMBAT()
end
-- évènement la sélection à la souris ou TAB a changé
function myHandlers:PLAYER_TARGET_CHANGED()
    if UnitExists("target") then
        if isFadeOn then
          showAll();
          isTargeting = true
        end
        -- la sélection est un joueur alors sauvegarde de son nom
        -- si ce nom n'est pas connu dans la table des noms => emote salut
        if UnitIsPlayer("target") then
            local nom = UnitName("target")
            if isDebuging then
                local log = string.format("Joueur %s rencontré", nom)
                printDebug(log)
            end
            local yeah = false
            for i=1, intNameMax, 1 do
                if nom == tableNameSave[i] then
                    yeah = true
                    break
                end
            end
            if not yeah then
                eFaction, fFaction = UnitFactionGroup("target")
                -- if eFaction == 'Alliance' then
                --   DoEmote("HELLO")
                -- else
                --   DoEmote("LAUGH")
                -- end
                nmiFrameOnopen()
                tableNameSave[intNameSave] = nom
                intNameSave = (intNameSave + 1) % intNameMax
            end
        else
          miniFrameOnclone()
        end
    else
      if isFadeOn then
        checkHide();
        isTargeting = false
      end
      nmiFrameOnclose()
    end
end
-- évènement perte de control : assomer, ebeter, etc
-- la caméra commence à tourner autours du perso et l'interface est caché
function myHandlers:PLAYER_CONTROL_LOST()
        UIParent:Hide()
        hideAll()
        MoveViewLeftStart(intRotationSpeed)
        local c = isZoomOn
        isZoomOn = true
        moveCam(intMountZoom)
        isZoomOn = c
end
-- évènement regain du control ; retour de la caméra et affichage de l'interface
function myHandlers:PLAYER_CONTROL_GAINED()
    if not UIParent:IsVisible() then
        UIParent:Show()

    end
    MoveViewLeftStop()
    MicroButtonAndBagsBar:Hide()
    MicroButtonAndBagsBar:Show()
    local c = isZoomOn
    isZoomOn = true
    moveCam(intFeetZoom)
    isZoomOn = c
end
-- évènement lancement d'un sort réussi
function myHandlers:UNIT_SPELLCAST_SUCCEEDED(event, caster, arg3, iSpell)
    -- le lanceur est le joueur
    if caster ~= "player" then
        return
    end
    --if isDebuging then
        --local msg = string.format("SPELL %d", iSpell)
        --printDebug(msg)
    --end
    if iSpell == 131476 then -- PECHE A LA LIGNE
        if not isFishing then
            MoveViewRightStart(0.05)
            C_Timer.After(2, function() MoveViewRightStop() end)
            isFishing = true
            moveCam (intFishZoom)
            isFirstFeetMove = true
            isFirstMountMove = true
        end
    elseif iSpell == 125883 then -- nuage volant du moine
        --moveCam (intMountZoom)
    end
end
-- évènement le joueur entre en jeu en fin de chargement
function myHandlers:PLAYER_ENTERING_WORLD()
    intFade = 1;
    if isFadeOn then
        fadeAll()
        checkHide()
    end
    MoveViewLeftStop()
end
-- évènement un groupe est formé
function myHandlers:GROUP_FORMED()
    PlaySound(17316)
end
-- évènement changement de formes
-- on suit ceci pour les shamans druide pour le zoom du mode déplacement comme les montures
function myHandlers:UPDATE_SHAPESHIFT_FORM()
    if iclass == 11 or iclass == 7 then -- druid shaman
        local fff = GetShapeshiftForm(flag)
        if isDebuging then
           local m = string.format("SHAPESHIFT %d %d", fff, iforme)
           printDebug(m)
         end
        if iforme == fff or fff == 4 or fff == 6 then
            return
        end
        iforme = fff
        if iforme ~= tableForm[iclass] then
            if isInCombat then
                moveCam(intCombatZoom)
                m = string.format("SH combat %d",  intCombatZoom)
            else
                moveCam(intFeetZoom)
                m = string.format("SH feet %d",  intFeetZoom)
            end
        else
            moveCam(intMountZoom)
            m = string.format("SH mount %d",  intMountZoom)
        end
        if isDebuging then
          printDebug(m)
        end
    end
end
-- évènement le plugin est chargé ; c'est ici qu'on récupère les paramètres sauvés dans un fichier
function myHandlers:ADDON_LOADED(arg1, addon)
    if addon ~= "Glomod" then
        return
    end
    UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED") --certains variables experimentales posent un warning en jeu quand on les change, on retire le test
    local z = ""
    -- si les paramètres ne sont pas dispo dans la sauvegarde alors on prend des valeurs par défaut
    if gloptions == nil then
        intFeetZoom = 5
        intMountZoom = 15
        isZoomOn = true
        intCombatZoom = 10
        saveZoom = {}
        isFadeOn = true
        isZoomOn = true
        isVignetteOn = true
        intCameraZoomSpeed = 20
        --C_CVar.SetCVar("cameraZoomSpeed", intCameraZoomSpeed)
        gloptions = {isFadeOn, isZoomOn, isVignetteOn, intFeetZoom, intMountZoom, isZoomOn, intCombatZoom, 1}
        z = string.format("z:1 %d %d %d %d", intFeetZoom, intCombatZoom, intMountZoom, intCameraZoomSpeed)
    else
        intFeetZoom = gloptions[4]
        intMountZoom = gloptions[5]
        isZoomOn = gloptions[6]
        intCombatZoom = gloptions[7]
        intCameraZoomSpeed = C_CVar.GetCVar("cameraZoomSpeed")
        optionsFrame.speedZ:SetText(tostring(intCameraZoomSpeed))
        --C_CVar.SetCVar("cameraZoomSpeed", intCameraZoomSpeed)
        if isZoomOn then
            optionsFrame.enterZF:SetText(tonumber(intFeetZoom))
            optionsFrame.enterZC:SetText(tonumber(intCombatZoom))
            optionsFrame.enterZM:SetText(tonumber(intMountZoom))
            optionsFrame.zoomButton:SetChecked(true)
            z = string.format("z:1 %d %d %d %d", intFeetZoom, intCombatZoom, intMountZoom, intCameraZoomSpeed)
        else
            optionsFrame.enterZF:SetText(tonumber(intFeetZoom))
            optionsFrame.enterZC:SetText(tonumber(intCombatZoom))
            optionsFrame.enterZM:SetText(tonumber(intMountZoom))
            optionsFrame.zoomButton:SetChecked(false)
            z = string.format("z:0 %d %d %d %d", intFeetZoom, intCombatZoom, intMountZoom, intCameraZoomSpeed)
        end
        isFadeOn = not gloptions[1]
        isZoomOn = not gloptions[2]
        isVignetteOn = not gloptions[3]
        optionsZoom()
        optionsFading()
        optionsVignette()
    end
    optionsFrame.zoomButton:SetChecked(isZoomOn)
    optionsFrame.fadingButton:SetChecked(isFadeOn)
    optionsFrame.vignetteButton:SetChecked(isVignetteOn)
    debugFrame.zoomActual:SetText(string.format("a: %d", GetCameraZoom()))
    debugFrame.zoomText:SetText(z)
end
-- évènement le joueur se déconnecte, on sauvegarde les paramètres du plugin dans le fichier dédié
function myHandlers:PLAYER_LOGOUT()
    gloptions[4] = intFeetZoom
    gloptions[5] = intMountZoom
    gloptions[6] = isZoomOn
    gloptions[7] = intCombatZoom
    gloptions[1] = isFadeOn
    gloptions[2] = isZoomOn
    gloptions[3] = isVignetteOn
    gloptions[8] = 1
end
-- évènement des fenetres sont affichées, on déplace ces fenetres
function myHandlers:GOSSIP_SHOW()
    moveFrame(GossipFrame)
end
function myHandlers:QUEST_GREETING()
    moveFrame(QuestFrame)
end
function myHandlers:QUEST_PROGRESS()
    moveFrame(QuestFrame)
end
function myHandlers:QUEST_DETAIL()
    moveFrame(QuestFrame)
end
function myHandlers:QUEST_ITEM_UPDATE()
    moveFrame(QuestFrame)
end
function myHandlers:QUEST_COMPLETE()
    moveFrame(QuestFrame)
end
function myHandlers:MERCHANT_SHOW()
    moveFrame(MerchantFrame)
end
function myHandlers:MERCHANT_UPDATE()
    moveFrame(MerchantFrame)
end
-- FIN DE COMBAT DE MASQUOTTE
function myHandlers:PET_BATTLE_CLOSE()
  isFadeOn = isFadeOnbackup
  showAll()
  MicroButtonAndBagsBar:Hide()
  MicroButtonAndBagsBar:Show()
end
-- DEBUT DE COMBAT DE MASQUOTTE
function myHandlers:PET_BATTLE_OPENING_DONE()
    ChatFrame1:SetAlpha(1)
    isFadeOnbackup = isFadeOn
    isFadeOn = 0
end
-- FIN DE CINEMATIQUE
function myHandlers:CINEMATIC_STOP()
end
