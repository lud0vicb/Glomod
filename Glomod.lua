myHandlers = {}
function GlomodOnload(self)
    -- initialisation lors du chargement du plugin, voir fichier xml c'est là qu'est indiqué le myHandler
    -- un plugin a forcément une fenêtre mère virtuelle
    UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED") --certains variables experimentales posent un warning en jeu quand on les change, on retire le test
    -- des flags
    isInCombat = false
    isTargeting = false
    isFishing = false
    isFirstFeetMove = true
    isFirstMountMove = true
    isDebuging = false
    isCamLock = false
    -- des vars
    intRotationSpeed = 0.05
    intFishZoom = 1.5
    intCamZoomBackup = 5
    intVignetteSave = 1
    intVignetteMax = 30
    intNameSave = 1
    intNameMax = 30
    intDebugLine = 1
    intMaxDebug = 26
    intVehicleZoom = 30
    intScale = 0.75
    secCamAfterCombat = 5
    secTimerFade = 3
    -- repérage de la classe pour id shaman et druide, rapport au changement de formes
    FRClass, ENClass, iclass = UnitClass("player")
    if iclass == 11 or iclass == 7 then
        iforme = GetShapeshiftForm(flag)
        tableForm = {[11]=3, [7]=1}
    end
    -- liste des fenetres qui seront cachées hors combat hors sélection
    tableFrameShowHide = {
        PlayerFrame, TargetFrame, MainMenuBar, MultiBarRight, BuffFrame, MultiBarLeft,
        MicroButtonAndBagsBar, ChatFrame1, ChatFrame2, MainMenuBarArtFrame,
    }
    for i,v in ipairs(tableFrameShowHide) do
        v:SetScript('OnEnter', function() showAll() end)
        v:SetScript('OnLeave', function() checkHide() end)
    end
    tableFrame50 = {
      MainMenuBar, MultiBarRight, MultiBarLeft, BuffFrame,
    }
    for i,v in ipairs(tableFrameShowHide) do
      v:SetScale(intScale)
    end
    -- liste des fenetres qui seront déplaçables à la souris
    -- et déplacées sur la droite
    local tableFrameMove = {
        --ExtraActionBarFrame, PlayerPowerBarAlt,
    }
    for i,v in ipairs(tableFrameMove) do
        v:SetMovable(true)
        v:EnableMouse(true)
        v:RegisterForDrag("LeftButton")
        v:SetScript("OnDragStart", v.StartMoving)
        v:SetScript("OnDragStop", v.StopMovingOrSizing)
        -- ancre, relativeTo, relativePoint, x, y = v:GetPoint(1)
        -- v:SetPoint(ancre, relativeTo, relativePoint, x + 200, y) -- decalage à droite de 200px
        v:SetUserPlaced(false)
    end
    -- ExtraActionBarFrame:SetParent(TargetFrame)
    -- ExtraActionBarFrame.SetParent = function() end
    -- les évenements à surveiller, construction d'une fonction pour gérer tous les évènements
    local tableEvent = {
      "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED",
      "UNIT_SPELLCAST_SUCCEEDED", "PLAYER_ENTERING_WORLD", "VIGNETTE_MINIMAP_UPDATED",
      "PLAYER_CONTROL_GAINED", "PLAYER_CONTROL_LOST",
      "PLAYER_STARTED_MOVING", "PLAYER_STOPPED_MOVING", "PLAYER_STARTED_TURNING",
      "GROUP_FORMED", "ADDON_LOADED", "PLAYER_LOGOUT", "UPDATE_SHAPESHIFT_FORM",
      "UNIT_ENTERING_VEHICLE", "UNIT_EXITING_VEHICLE",
      -- "GOSSIP_SHOW", "MERCHANT_SHOW", "MERCHANT_UPDATE",
      -- "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_GREETING", "QUEST_ITEM_UPDATE", "QUEST_COMPLETE",
      "PET_BATTLE_OPENING_DONE", "PET_BATTLE_CLOSE",
      --"PLAYER_LEAVE_COMBAT",
      --"ACTIONBAR_UPDATE_COOLDOWN", "ACTIONBAR_UPDATE_STATE", "ACTIONBAR_UPDATE_USABLE",
    }
    for i,v in ipairs(tableEvent) do
        self:RegisterEvent(v);
    end
    -- MinimapTracking:SetParent(Minimap)
    self:SetScript('OnEvent', function(self, event, ...) myHandlers[event](self, event, ...) end)
    -- fenetres à cacher en permanence
    local tableHide={
        MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap,
        --MainMenuBarArtFrameBackground,
        MinimapBorder, MinimapZoomIn, MinimapZoomOut, MinimapBorderTop, MiniMapWorldMapButton,
    }
    for i,v in ipairs(tableHide) do
        v:Hide()
    end
    -- liste des fenetres dont l'affichage change si la souris passe dessus
    local tableShowOnMouse = {
    }
    for i,v in ipairs(tableShowOnMouse) do
        ShowOnMouse(v)
    end
    -- un tableau pour sauver les X dernières étoiles croisées sur la minimap
    tableVignetteSave = {}
    for ind=1, intVignetteMax, 1 do
        tableVignetteSave[ind] = ""
    end
    -- un tableau pour sauver les lignes de debug
    tableDebugLine = {}
    for ind=1, intMaxDebug, 1 do
        tableDebugLine[ind] = ""
    end
    -- tableau pour sauver les noms de joueurs sélectionnés à la souris
    tableNameSave ={}
    for ind=1, intNameMax, 1 do
        tableNameSave[ind] = ""
    end
    -- déplacement de la minimap en bas à droite
    MinimapCluster:ClearAllPoints();
    MinimapCluster:SetScale(1.6);
    MinimapCluster:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -10, 40);
    -- ex : MinimapCluster:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16,insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    --MinimapZoneTextButton:SetBackdropColor(0,0,0,0);
    --MinimapZoneTextButton:SetBackdropBorderColor(0,0,0,0);
    -- BuffFrame
    -- f=BuffFrame
    -- f:SetMovable(1)
    -- f:SetUserPlaced(true)
    -- f:SetScale(0.7)
    -- hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function()
    --   BuffButton1:ClearAllPoints()
    --   BuffButton1:SetPoint("BOTTOMRIGHT", PlayerFrame, "TOPRIGHT", 0, -20)
    --   DebuffButton1:ClearAllPoints()
    --   DebuffButton1:SetPoint("BOTTOM", BuffFrame, "TOPRIGHT", 10, 24)
    -- Tracker
--    end)
    -- g=ObjectiveTrackerFrame
    -- g:SetMovable(1)
    -- g:SetUserPlaced(true)
    -- g:ClearAllPoints()
    -- g:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", 0, 0);
end
-- fonction de comportement de passage à la souris
function showOnMouse(frame)
    frame:SetScript('OnEnter', function() frame:SetAlpha(1) end)
    frame:SetScript('OnLeave', function() frame:SetAlpha(0) end)
    C_Timer.After(6, function() frame:SetAlpha(0) end)
end
-- déplacement de la barre de sort
function moveCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("TOP", PlayerFrame, "BOTTOM",30, 30)
    CastingBarFrame:SetHeight(14)
end
-- déplacement d'une fenetre
function moveFrame(fr)
    fr:ClearAllPoints()
    fr:SetMovable(true)
    fr:SetUserPlaced(true)
    fr:SetPoint("LEFT", "UIParent", "CENTER", 200, 60)
    if isDebuging then
        local log = string.format("Move %s", fr:GetName())
        printDebug(log)
    end
end
-- le pitch est l'angle de caméra ; les yeux du personnage sont le centre de l'écran
-- changer le pitch change le point d'ancrage des yeux du personnage
-- retour au pitch de blizzard
function stopPitch()
    intPitchZoom = GetCVarDefault("test_cameraDynamicPitchBaseFovPad")
    C_CVar.SetCVar("test_cameraDynamicPitch", 0)
    C_CVar.SetCVar("test_cameraDynamicPitchBaseFovPad", intPitchZoom)
    C_CVar.SetCVar("test_cameraDynamicPitchBaseFovPadFlying", GetCVarDefault("test_cameraDynamicPitchBaseFovPadFlying"))
    if isDebuging then
        printDebug("PITCH OFF")
        debugFrame.dynamicPitchActual:SetText("p: " .. tostring(intPitchZoom))
    end
end
-- changement du pitch (point d'ancrage des yeux du personnage)
-- le pitch n'est pas sauvé dans le plugin car il s'agit d'une CVAR, un jeux de réglages de blizzard
-- on sauve donc le réglade dans ce CVAR directement
function setPitch(i)
    local j = i / 10
    local actual = GetCVar("test_cameraDynamicPitchBaseFovPad")
    local isActivated = C_CVar.SetCVar("test_cameraDynamicPitch", 1)
    local isPitched = C_CVar.SetCVar("test_cameraDynamicPitchBaseFovPad", j) --, "scriptCVar"
    local isPitched2 = C_CVar.SetCVar("test_cameraDynamicPitchBaseFovPadFlying", j) --, "scriptCVar"
    intPitchZoom = j
    if isDebuging then
        log = string.format("PITCH from %.2f to %.2f = %.2f", actual, j, GetCVar("test_cameraDynamicPitchBaseFovPad"))
        debugFrame.dynamicPitchActual:SetText("p: " .. tostring(j))
        printDebug(log)
    end
end
