function debugFrameOnload(self)
    self.zoomText = self:CreateFontString(nil, "OVERLAY")
    self.zoomText:SetPoint("BOTTOMLEFT", 22, 83)
    self.zoomText:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    self.zoomText:SetText("zooms")
    self.zoomActual = self:CreateFontString(nil, "OVERLAY")
    self.zoomActual:SetPoint("BOTTOMLEFT", 172, 83)
    self.zoomActual:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    self.zoomActual:SetText("0")
    self.dynamicPitchActual = self:CreateFontString(nil, "OVERLAY")
    self.dynamicPitchActual:SetPoint("BOTTOMLEFT", 272, 83)
    self.dynamicPitchActual:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    self.dynamicPitchActual:SetText(tostring("P : " .. GetCVar("test_cameraDynamicPitchBaseFovPad")))
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
function debugButtonOnload(self)
    self:SetText("debug on")
end
function debugButtonClick(self)
    if debugFrame:IsVisible() then
        self:SetText("debug on")
        isDebuging = false
        debugFrame:Hide()
    else
        self:SetText("debug off")
        isDebuging = true
        debugFrame:Show()
    end
end
function debugFrameOnclose(self)
    debugButton:SetText("debug on")
    isDebuging = false
    debugFrame:Hide()
end
-- CVAR à changer pour modifier la hauteur de la prise de vue ??
-- test_cameraDynamicPitchBaseFovPad
function gloButtonOnload(self)
    self:SetText("Glo")
end
function gloButtonClick(self)
    optionsFrame:Show()
end
function optionsPitch()
    print(intPitchZoom)
    print(GetCVarDefault("test_cameraDynamicPitchBaseFovPad"))
    if intPitchZoom ~= GetCVarDefault("test_cameraDynamicPitchBaseFovPad") then
        stopPitch()
    else
        setPitch(2)
    end
end
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
function optionsVignette()
    if GlomodFrame:IsEventRegistered("VIGNETTE_MINIMAP_UPDATED") then
        GlomodFrame:UnregisterEvent("VIGNETTE_MINIMAP_UPDATED")
        if isDebuging then
            printDebug('UnregisterEvent VIGNETTE')
        end
    else
        GlomodFrame:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
        if isDebuging then
            printDebug('RegisterEvent VIGNETTE')
        end
    end
end
function createCheckButton(parent, x, y, nom, fonc, tt)
	local c = CreateFrame("CheckButton", nom, parent, "ChatConfigCheckButtonTemplate")
	c:SetPoint("TOPLEFT", x, y)
    _G[c:GetName() .. "Text"]:SetText(nom)
	c.tooltip = tt
    c:SetScript("OnClick", function() fonc() end)
    return c
end
function createEnter(parent, x, y, val)
    local e = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    e:SetWidth(20)
    e:SetHeight(20)
    e:SetPoint("BOTTOMLEFT", x, y)
    e:SetMultiLine(1)
    e:SetText(val)
    e:SetAutoFocus(false)
    return e
end
function computeZoom()
    local zf = optionsFrame.enterZF:GetText()
    local zc = optionsFrame.enterZC:GetText()
    local zm = optionsFrame.enterZM:GetText()
    intFeetZoom = tonumber(zf)
    intCombatZoom = tonumber(zc)
    intMountZoom = tonumber(zm)
    isZoomOn = true
    optionsFrame.zoomButton:SetChecked(true)
    optionsFrame.enterZF:SetText(zf)
    optionsFrame.enterZC:SetText(zc)
    optionsFrame.enterZM:SetText(zm)
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
    if isDebuging then
        local z = string.format("1 %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
        debugFrame.zoomText:SetText(z)
    end
end
function optionsFrameOnload(self)
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)

    self.titreText = optionsFrame:CreateFontString(nil, "OVERLAY")
    self.titreText:SetPoint("TOPLEFT", 120, -10)
    self.titreText:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    self.titreText:SetText("Gloptions")

    self.pitchButton = createCheckButton(self, 80, -50, "pitch", optionsPitch, "active le décalage de la caméra sur le bas")
    if intPitchZoom ~= GetCVarDefault("test_cameraDynamicPitchBaseFovPad") then
        self.pitchButton:SetChecked(true)
    end
    self.vignetteButton = createCheckButton(self, 80, -70, "vignettes", optionsVignette, "active la détection des vignettes sur la minimap")
    self.vignetteButton:SetChecked(true)
    self.zoomButton = createCheckButton(self, 80, -90, "zooms", optionsZoom, "active les zooms automatiques contextuels")
    self.zoomButton:SetChecked(true)
    self.enterZF = createEnter(self, 85, 50, tostring(intFeetZoom))
    self.enterZC = createEnter(self, 110, 50, tostring(intCombatZoom))
    self.enterZM = createEnter(self, 135, 50, tostring(intMountZoom))
    self.validZoom = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    self.validZoom:SetWidth(30)
    self.validZoom:SetHeight(30)
    self.validZoom:SetText("Z")
    self.validZoom:SetPoint("BOTTOMLEFT", 160, 45)
    self.validZoom:SetScript("OnClick", function() computeZoom() end)

end
function optionsFrameOnclose(self)
    optionsFrame:Hide()
end
