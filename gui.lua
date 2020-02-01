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
    if isZoomOn then
        isZoomOn = false
        if isDebuging then
            printDebug('zooms OFF')
        end
    else
        isZoomOn = true
        if isDebuging then
            printDebug('zooms ON')
        end
    end
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
function createCheckButton(parent, x, y, nom, f, t)
	local c = CreateFrame("CheckButton", nom, parent, "ChatConfigCheckButtonTemplate")
	c:SetPoint("TOPLEFT", x, y)
    --c:SetWidth(20)
    print(c:GetName())
    _G[c:GetName() .. "Text"]:SetText(nom);
	c.tooltip = t;
    c:SetScript("OnClick", function() f() end)
    return c;
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
end
function optionsFrameOnclose(self)
    optionsFrame:Hide()
end
