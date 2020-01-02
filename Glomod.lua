--graph 
MainMenuBarArtFrame.LeftEndCap:Hide()
MainMenuBarArtFrame.RightEndCap:Hide()
-- groupe


function GlomodOnload() 
  inCombat = false;
  fade=0;
  targeting=false;
  FadeAll();
end

function CheckHide()
    if inCombat == false then
      C_Timer.After(3, function() HideAll() end)
    end
end

function HideAll()
  if inCombat or targeting or PlayerFrame:IsMouseOver() or TargetFrame:IsMouseOver() or
    MainMenuBar:IsMouseOver() or MicroButtonAndBagsBar:IsMouseOver() or ChatFrame1:IsMouseOver() then return end
  fade=fade-0.1;
  --print(fade)
  FadeAll();
  if fade >= 0 then C_Timer.After(.1, function() HideAll() end) end
end

function FadeAll()
  PlayerFrame:SetAlpha(fade); TargetFrame:SetAlpha(fade);MainMenuBar:SetAlpha(fade);MicroButtonAndBagsBar:SetAlpha(fade); ChatFrame1:SetAlpha(fade);
end

function ShowAll()
  fade=1;
  FadeAll();
end

-- Init ; essai de le faire dans le script de la frame du xml
--inCombat = false;
--fade=1;
--targeting=false;
--HideAll();
-- la frame pour y attacher la gestion d'events
local GloFrame = CreateFrame("FRAME", "GlomodFrame");
GloFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
GloFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
GloFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
--GloFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
GloFrame:RegisterEvent("PLAYER_ENTERING_WORLD");

local function GlomodEventHandler(self, event, arg1, arg2, arg3, ...)
  --print("EVENT TRIGGERED : " .. event);
  -- utiliser la commande /fstack en jeu pour identifier les élements de l'interface wow
  if event == 'PLAYER_REGEN_DISABLED' then 
    inCombat = true;
    ShowAll();
  elseif event == 'PLAYER_REGEN_ENABLED' then
    inCombat = false;
    CheckHide();
  elseif event == 'PLAYER_TARGET_CHANGED' then
    if UnitExists("target") then
      ShowAll(); targeting=true;
    else
      CheckHide(); targeting=false;
    end
  elseif event == 'PLAYER_ENTERING_WORLD' then
    print('Bienvenue à nouveau ');
    fade=0;
    FadeAll();
  end
end
GloFrame:SetScript("OnEvent", GlomodEventHandler);
-- ajout des events souris sur certaines frames
--PlayerFrame:EnableMouse();TargetFrame:EnableMouse();MainMenuBar:EnableMouse(); 
PlayerFrame:SetScript('OnEnter', function() ShowAll() end)
PlayerFrame:SetScript('OnLeave', function() CheckHide() end)
TargetFrame:SetScript('OnEnter', function() ShowAll() end)
TargetFrame:SetScript('OnLeave', function() CheckHide() end)
MainMenuBar:SetScript('OnEnter', function() ShowAll() end)
MainMenuBar:SetScript('OnLeave', function() CheckHide() end)
MicroButtonAndBagsBar:SetScript('OnEnter', function() ShowAll() end)
MicroButtonAndBagsBar:SetScript('OnLeave', function() CheckHide() end)
ChatFrame1:SetScript('OnEnter', function() ShowAll() end)
ChatFrame1:SetScript('OnLeave', function() CheckHide() end)

-- GERER LE MOUSE OVER
--frame:EnableMouse()
--frame:SetScript('OnEnter', function() highlightStuff end)
--frame:SetScript('OnLeave', function() unHighightStuff end)

-- MASQUER UN ELEMENTE
--PlayerFrame:SetAlpha(0);
-- autres syntaxes ; à noter qu'une frame cachée ne peut être survolée à la souris !
--HideUIPanel(PlayerFrame);
--PlayerFrame:Hide();
