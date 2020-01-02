# Glomod

## Gestion frame

On les gère plutôt dans le fichier xml. Mais on peut le faire des le code :

```
local GloFrame = CreateFrame("FRAME", "GlomodFrame");
GloFrame:SetScript("OnEvent", GlomodEventHandler);
```

## Bouger une frame déjà définie

on ne définit pas le xml puisqu'il existe déjà, donc on appelle des méthodes lua

```
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
```
