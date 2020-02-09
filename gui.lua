function debugFrameOnload(self)
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

function createButton (parent, x, y, fonc, nom)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetWidth(30)
    b:SetHeight(30)
    b:SetText(nom)
    b:SetPoint("TOPLEFT", x, y)
    b:SetScript("OnClick", function() fonc() end)
    return b
end

function createText(x, y, txt)
    local t = optionsFrame:CreateFontString(nil, "OVERLAY")
    t:SetPoint("TOPLEFT", x, y)
    t:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    t:SetText(txt)
    return t
end

function optionsFrameOnload(self)
    -- fenêtre elle même
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)
    -- options vignettes
    self.vignetteButton = createCheckButton(self, 80, -70, "alertes vignettes", optionsVignette, "active la détection des vignettes sur la minimap")
    -- options fading
    self.fadingButton = createCheckButton(self, 80, -150, "dissimule interface", optionsFading, "cache une partie de l'interface hors combat et hors cible")
end

function optionsFrameOnclose(self)
    optionsFrame:Hide()
end
