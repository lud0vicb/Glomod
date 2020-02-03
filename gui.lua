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

function debugFrameOnclose(self)
    isDebuging = false
    debugFrame:Hide()
end

function gloButtonOnload(self)
    self:SetText("Glo")
    self:RegisterForClicks("LeftButtonUp", "RightButtonDown");
end

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

function optionsPitch()
    print(intPitchZoom)
    print(GetCVarDefault("test_cameraDynamicPitchBaseFovPad"))
    if intPitchZoom ~= GetCVarDefault("test_cameraDynamicPitchBaseFovPad") then
        stopPitch()
    else
        setPitch(2)
    end
end

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
    e:SetWidth(26)
    e:SetHeight(20)
    e:SetPoint("TOPLEFT", x, y)
    e:SetMultiLine(1)
    e:SetText(val)
    e:SetAutoFocus(false)
    return e
end

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
    local z = string.format("1 %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
    if isDebuging then
        debugFrame.zoomText:SetText(z)
        printDebug(z)
    end
    message("New zooms " .. z)
end

function computeScale()
    intScale = tonumber(optionsFrame.enterSC:GetText()) / 100
    for i,v in ipairs(tableScale) do
        v:SetScale(intScale)
    end
    if isDebuging then
        printDebug(string.format("SCALE %.1f", intScale))
    end
    showAll()
end

function createButton (parent, x, y, fonc, nom)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetWidth(30)
    b:SetHeight(30)
    b:SetText(nom)
    b:SetPoint("TOPLEFT", x, y)
    b:SetScript("OnClick", function() fonc() end)
    return b
end

function optionsFrameOnload(self)
    -- fenêtre elle même
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)
    -- options pitch
    self.pitchButton = createCheckButton(self, 80, -50, "pitch", optionsPitch, "active le décalage de la caméra sur le bas")
    if intPitchZoom ~= GetCVarDefault("test_cameraDynamicPitchBaseFovPad") then
        self.pitchButton:SetChecked(true)
    end
    -- options vignettes
    self.vignetteButton = createCheckButton(self, 80, -70, "vignettes", optionsVignette, "active la détection des vignettes sur la minimap")
    -- options fading
    self.fadingButton = createCheckButton(self, 80, -140, "fading", optionsFading, "cache une partie de l'interface hors combat et hors cible")
    -- options zooms
    self.zoomButton = createCheckButton(self, 80, -90, "zooms", optionsZoom, "active les zooms automatiques contextuels")
    self.enterZF = createEnter(self, 85, -120, tostring(intFeetZoom))
    self.enterZC = createEnter(self, 110, -120, tostring(intCombatZoom))
    self.enterZM = createEnter(self, 135, -120, tostring(intMountZoom))
    self.validZoom = createButton(self, 160, -105, computeZoom, "Z")
    -- options scale
    self.scaleText = optionsFrame:CreateFontString(nil, "OVERLAY")
    self.scaleText:SetPoint("TOPLEFT", 80, -165)
    self.scaleText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    self.scaleText:SetText("scale")
    self.enterSC = createEnter(self, 120, -165, tostring(intScale * 100))
    self.validScale = createButton(self, 150, -155, computeScale, "S")
end

function optionsFrameOnclose(self)
    optionsFrame:Hide()
end
