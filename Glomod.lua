--graph 
MainMenuBarArtFrame.LeftEndCap:Hide()
MainMenuBarArtFrame.RightEndCap:Hide()
-- groupe

ZoneAbilityFrame.SpellButton.Style:SetAlpha(0)
ZoneAbilityFrame.SpellButton.Style:Hide()

function GlomodOnload() 
  message("wazaaaa!");  
end

local frame = CreateFrame("FRAME", "GlomodFrame");
frame:RegisterEvent("PLAYER_REGEN_DISABLED");
frame:RegisterEvent("PLAYER_REGEN_ENABLED");
local function GlomodEventHandler(self, event, ...)
 print("Hello World! Hello " .. event);
end
frame:SetScript("OnEvent", GlomodEventHandler);