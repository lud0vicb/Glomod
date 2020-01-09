MyFunctions={}

function GlomodOnload(self) 
  inCombat = false
  fade=0
  targeting=false
  FadeAll()
  MountZoom=15
  FeetZoom=5
  FishZoom=1.5
  IsFishing = false
  FirstFeetMove = true
  FirstMountMove = true
  
  FRClass, ENClass, iclass = UnitClass("player")
  
  tableEvent = {
    "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED","UNIT_SPELLCAST_SUCCEEDED","PLAYER_ENTERING_WORLD",
    "UNIT_MODEL_CHANGED", "PLAYER_CONTROL_GAINED", "PLAYER_CONTROL_LOST", "UNIT_SPELLCAST_SUCCEEDED", "PLAYER_STARTED_MOVING",
    "PLAYER_STOPPED_MOVING", "UNIT_SPELLCAST_START"
  }
  for i,v in ipairs(tableEvent) do
      self:RegisterEvent(v);
  end
  
  self:SetScript('OnEvent', function(self, event, ...) MyFunctions[event](...) end)
  
  tableFrame ={
    PlayerFrame, TargetFrame, MainMenuBar, MultiBarRight, MicroButtonAndBagsBar, ChatFrame1, BuffFrame
  } 
  for i,v in ipairs(tableFrame) do
      v:SetScript('OnEnter', function() ShowAll() end)
      v:SetScript('OnLeave', function() CheckHide() end)
  end
    
  tableHide={
    MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap, MainMenuBarArtFrameBackground
  }
  for i,v in ipairs(tableHide) do
      v:Hide()
  end  
  
end

function MyFunctions:PLAYER_REGEN_DISABLED()
  inCombat = true; 
  ShowAll()  
end

function MoveCastBar()
  CastingBarFrame:ClearAllPoints()
  CastingBarFrame:SetPoint("TOP",PlayerFrame,"BOTTOM",30, 30)
  CastingBarFrame:SetHeight  (14)
end

function MyFunctions:UNIT_SPELLCAST_START()
  
end

function MyFunctions:PLAYER_REGEN_ENABLED()
    inCombat = false; 
    CheckHide()  
end

function MyFunctions:PLAYER_STOPPED_MOVING()
  Moved()
end

function MyFunctions:PLAYER_STARTED_MOVING()
  Moved()
end

function MyFunctions:PLAYER_TARGET_CHANGED()
    if UnitExists("target") then
        ShowAll(); 
        targeting=true
    else
        CheckHide(); 
        targeting=false
    end
end

function MyFunctions:PLAYER_CONTROL_LOST()
    UIParent:Hide()
    MoveViewLeftStart(0.1)
    MoveCam (MountZoom)
end

function MyFunctions:PLAYER_CONTROL_GAINED()
    UIParent:Show()
    MoveViewLeftStop()
    MoveCam (FeetZoom)
end

function MyFunctions:UNIT_SPELLCAST_SUCCEEDED(arg1, arg2)
    --print ('SPELL' arg2)
    local iSpell = arg2
    -- PECHE A LA LIGNE
    if iSpell == 131476 then
      if not IsFishing then
        MoveViewRightStart(0.05)
        C_Timer.After(2, function() MoveViewRightStop() end)
        IsFishing = true
        MoveCam (FishZoom)
        FirstFeetMove = true
        FirstMountMove = true
      end
    end  
end

function MyFunctions:PLAYER_ENTERING_WORLD()
    fade=0; 
    FadeAll()
end

function MyFunctions:UNIT_MODEL_CHANGED()
    -- druide
    if iclass == 11 then
      local iforme = GetShapeshiftForm(flag)
      --print('CHANGEFORM'.. iforme)
      if iforme == 3 or iforme == 4 then
        MoveCam(MountZoom)
      else
        MoveCam(FeetZoom)
      end
    end
    -- shaman
    if iclass == 7 then
      local iforme = GetShapeshiftForm(flag)
      --print('CHANGEFORM'.. iforme)
      if iforme == 1 then
        MoveCam(MountZoom)
      else
        MoveCam(FeetZoom)
      end
    end 
end

function Moved()
    -- druide et shaman
  if iclass == 11 or iclass == 7 then
    local iforme = GetShapeshiftForm(flag)
    if iforme == 0 then
      -- le druide/shaman est en humanoide ; il peut en se cas être sur une monture !
      CheckMount()
    end
  else
    CheckMount()
  end
  if IsFishing then
    IsFishing = false
    MoveViewLeftStart(0.05)
    C_Timer.After(2, function() MoveViewLeftStop() end)
  end
end

function MoveCam(ref)
  local z=GetCameraZoom()
  if ref > z then
    CameraZoomOut(ref - z)
  else
    CameraZoomIn(z - ref)
  end
end

function CheckHide()
    if inCombat == false then
      C_Timer.After(3, function() HideAll() end)
    end
end

function HideAll()
  if inCombat or targeting or PlayerFrame:IsMouseOver() or TargetFrame:IsMouseOver() or MultiBarRight:IsMouseOver() or 
    MainMenuBar:IsMouseOver() or MicroButtonAndBagsBar:IsMouseOver() or ChatFrame1:IsMouseOver() or BuffFrame:IsMouseOver()
    then 
      return 
  end
  if fade ~= 0 then
    fade=fade-0.1
  end
  --print(fade)
  FadeAll()
  if fade > 0 then
    C_Timer.After(.1, function() HideAll() end)
  end
end

function FadeAll()
  PlayerFrame:SetAlpha(fade);
  TargetFrame:SetAlpha(fade)
  MainMenuBar:SetAlpha(fade)
  MicroButtonAndBagsBar:SetAlpha(fade)
  ChatFrame1:SetAlpha(fade)
  MultiBarRight:SetAlpha(fade)
  BuffFrame:SetAlpha(fade)
end

function ShowAll()
  fade=1; 
  FadeAll();
end

function CheckMount()
  if IsMounted() then 
    if not FirstMountMove then return end
    MoveCam(MountZoom)
    FirstMountMove = false
    FirstFeetMove = true
  else 
    if not inCombat then
      if not FirstFeetMove then return end
      MoveCam (FeetZoom)
      FirstFeetMove = false
      FirstMountMove = true
    end
  end
end
