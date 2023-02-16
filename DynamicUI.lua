local ADDON_NAME = "DynamicUI"

local DynamicUI = {};

function DynamicUI:SwitchUI()
    local desired = GetScreenWidth() .. "x" .. GetScreenHeight()
    local layouts = C_EditMode.GetLayouts()

    print("Looking for profile with name: " .. desired .. ".")

    for l, layout in ipairs(layouts.layouts) do
        if layout.layoutName == desired then
            C_EditMode.SetActiveLayout(l)
            return
        end
    end
end

local events = {
    "ADDON_LOADED",
    "PLAYER_ENTERING_WORLD",
}

local frame = CreateFrame("Frame", "EventFrame")
frame:SetScript("OnEvent", function (self, event, ...)
    local c = ...
    if event == "ADDON_LOADED" and c[0] == ADDON_NAME then
        DynamicUI:SwitchUI()
    end

    if event == "PLAYER_ENTERING_WORLD" and c[1] == true then
        DynamicUI:SwitchUI()
    end
end)

for event in events do
    frame:RegisterEvent(event)
end

_G[ADDON_NAME] = DynamicUI