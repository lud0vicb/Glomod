function debugFrameOnload(self)
    self.zoomText = self:CreateFontString(nil, "OVERLAY")
    self.zoomText:SetPoint("BOTTOMLEFT", 22, 83)
    self.zoomText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    self.zoomText:SetText("zooms")
    self.zoomActual = self:CreateFontString(nil, "OVERLAY")
    self.zoomActual:SetPoint("BOTTOMLEFT", 92, 83)
    self.zoomActual:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    self.zoomActual:SetText("0")
    self.dynamicPitchActual = self:CreateFontString(nil, "OVERLAY")
    self.dynamicPitchActual:SetPoint("BOTTOMLEFT", 272, 83)
    self.dynamicPitchActual:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    self.dynamicPitchActual:SetText(tostring("p: " .. GetCVar("test_cameraDynamicPitchBaseFovPad")))
    self.debugText = self:CreateFontString(nil, "OVERLAY")
    self.debugText:SetPoint("TOPLEFT", self, "TOPLEFT", 22, -80)
    self.debugText:SetWidth(300)
    self.debugText:SetHeight(320)
    self.debugText:SetJustifyH("LEFT")
    self.debugText:SetJustifyV("TOP")
    self.debugText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    self.debugText:SetText("this is it\noh yeah")
    SetConsoleKey("!")
end
-- fermeture de la fenetre de debug
function debugFrameOnclose(self)
    isDebuging = false
    debugFrame:Hide()
end
-- le bouton pour afficher les options du plugin
function gloButtonOnload(self)
    self:SetText("Glo")
    self:RegisterForClicks("LeftButtonUp", "RightButtonDown");
end
-- gestion des clics sur le bouton
function gloButtonClick(self, button)
    if button == "LeftButton" then
        if optionsFrame:IsShown() then
            optionsFrame:Hide()
        else
            optionsFrame:Show()
        end
    elseif button == 'RightButton' then
        if debugFrame:IsVisible() then
            isDebuging = false
            debugFrame:Hide()
        else
            isDebuging = true
            debugFrame:Show()
        end
    end
end
-- gestion du pitch (centrage de la caméra sur les yeux du perso par défaut au centre de l'écran)
function optionsPitch()
    if intPitchZoom ~= GetCVarDefault("test_cameraDynamicPitchBaseFovPad") then
        stopPitch()
    else
        setPitch(2)
    end
end
-- gestion du masquage de l'interface
function optionsFading()
    if isFadeOn then
        showAll()
        isFadeOn = false
        if isDebuging then
            printDebug('fading OFF')
        end
    else
        isFadeOn = true
        checkHide()
        if isDebuging then
            printDebug('fading ON')
        end
    end
end
-- permutation du zoom lors de clic dans les options
function optionsZoom()
    local z = ""
    if isZoomOn then
        isZoomOn = false
        if isDebuging then
            printDebug('zooms OFF')
        end
        z = string.format("0 %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
    else
        isZoomOn = true
        if isDebuging then
            printDebug('zooms ON')
        end
        z = string.format("1 %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
    end
    debugFrame.zoomText:SetText(z)
end
-- gestion de la fonction des vignettes
function optionsVignette()
    if isVignetteOn then
        GlomodFrame:UnregisterEvent("VIGNETTE_MINIMAP_UPDATED")
        isVignetteOn = false
        if isDebuging then
            printDebug('UnregisterEvent VIGNETTE')
        end
    else
        GlomodFrame:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
        isVignetteOn = true
        if isDebuging then
            printDebug('RegisterEvent VIGNETTE')
        end
    end
end
-- creation d'un bouton à cocher
function createCheckButton(parent, x, y, nom, fonc, tt)
	local c = CreateFrame("CheckButton", nom, parent, "ChatConfigCheckButtonTemplate")
	c:SetPoint("TOPLEFT", x, y)
    _G[c:GetName() .. "Text"]:SetText(nom)
	c.tooltip = tt
    c:SetScript("OnClick", function() fonc() end)
    return c
end
-- creation d'une zone de saisie
function createEnter(parent, x, y, val)
    local e = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    e:SetWidth(26)
    e:SetHeight(20)
    e:SetPoint("TOPLEFT", x, y)
    e:SetMultiLine(1)
    e:SetText(val)
    e:SetAutoFocus(false)
    return e
end
-- prise en compte des valeurs du zoom ; les diff distance de cam et la vitesse de mouvement de cam
function computeZoom()
    intFeetZoom = tonumber(optionsFrame.enterZF:GetText())
    intCombatZoom = tonumber(optionsFrame.enterZC:GetText())
    intMountZoom = tonumber(optionsFrame.enterZM:GetText())
    isZoomOn = true
    optionsFrame.zoomButton:SetChecked(true)
    if isInCombat then
        moveCam(intCombatZoom)
    elseif IsMounted() then
        moveCam(intMountZoom)
    elseif iclass == 11 or iclass == 7 then
        if iforme ~= tableForm[iclass] then
            moveCam(intFeetZoom)
        else
            moveCam(intMountZoom)
        end
    end
    intCameraZoomSpeed = tonumber(optionsFrame.speedZ:GetText())
    C_CVar.SetCVar("cameraZoomSpeed", intCameraZoomSpeed)
    local z = string.format("1 %d %d %d %d", intFeetZoom, intCombatZoom, intMountZoom, intCameraZoomSpeed)
    if isDebuging then
        debugFrame.zoomText:SetText(z)
        printDebug(z)
    end
    message("New zooms " .. z)
end
-- creation d'un bouton
function createButton (parent, x, y, fonc, nom)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetWidth(30)
    b:SetHeight(30)
    b:SetText(nom)
    b:SetPoint("TOPLEFT", x, y)
    b:SetScript("OnClick", function() fonc() end)
    return b
end
-- creation d'une zone de texte à afficher
function createText(x, y, txt)
    local t = optionsFrame:CreateFontString(nil, "OVERLAY")
    t:SetPoint("TOPLEFT", x, y)
    t:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    t:SetText(txt)
    return t
end
-- parfois la barre minibutton ne fonctionne plus, ceci permet de la refresh
function miniButtonReset()
  MicroButtonAndBagsBar:Hide()
  MicroButtonAndBagsBar:Show()
end
-- rechargement complet de l'interface  /reload
function uiReload()
  C_UI.Reload()
end
-- affichage de la fenetre des options
function optionsFrameOnload(self)
    -- fenêtre elle même
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)
    -- options pitch
    self.pitchButton = createCheckButton(self, 80, -50, "caméra pitch 0.2", optionsPitch, "active le décalage de la caméra sur le bas")
    intPitchZoom = GetCVar("test_cameraDynamicPitchBaseFovPad")
    if intPitchZoom ~= GetCVarDefault("test_cameraDynamicPitchBaseFovPad") then
        self.pitchButton:SetChecked(true)
    end
    -- options vignettes
    self.vignetteButton = createCheckButton(self, 80, -70, "alertes vignettes", optionsVignette, "active la détection des vignettes sur la minimap")
    -- options fading
    self.fadingButton = createCheckButton(self, 80, -150, "dissimule interface", optionsFading, "cache une partie de l'interface hors combat et hors cible")
    -- options zooms
    self.zoomButton = createCheckButton(self, 80, -90, "zooms automatiques", optionsZoom, "active les zooms automatiques contextuels : à pieds, en combat, en monture")
    self.zoomText = createText(80, -110, "feet/combat/mount/speed")
    self.enterZF = createEnter(self, 85, -130, 0)
    self.enterZC = createEnter(self, 115, -130, 0)
    self.enterZM = createEnter(self, 145, -130, 0)
    self.speedZ = createEnter(self, 175, -130, 0)
    self.validZoom = createButton(self, 205, -120, computeZoom, "Z")
    -- options reset
    self.miniButtonReset = createButton(self, 80, -170, miniButtonReset, "M")
    self.uiReload = createButton(self, 110, -170, uiReload, "R")
    -- bouton sur l'écran
    self.action1 = createEnter(self, 85, -200, 0)
    optionsFrame.action1:SetText("Attaque auto")
    n_action1 = optionsFrame.action1:GetText()
    b_action1:SetAttribute("type", "spell")
    b_action1:SetAttribute("spell", n_action1)
    name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(n_action1)
    local t = b_action1:CreateTexture()
    t:SetSize(32, 32)
    t:SetPoint("CENTER")
    t:SetHorizTile(false)
    t:SetVertTile(false)
    t:SetTexture(icon)
end
-- fermeture de la fenetre des options
function optionsFrameOnclose(self)
    optionsFrame:Hide()
end
