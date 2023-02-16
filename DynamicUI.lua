local ADDON_NAME = "DynamicUI"

local DynamicUI = {};

local events = {
    "ADDON_LOADED",
    "PLAYER_ENTERING_WORLD",
}

function DynamicUI:WriteLog(message)
    print ("[" .. ADDON_NAME .. "] " .. message)
end

function DynamicUI:SwitchUI()
    local specific = GetScreenWidth() .. "x" .. GetScreenHeight()
    local widthOnly = GetScreenWidth() .. "p"
    local layouts = C_EditMode.GetLayouts()

    DynamicUI:WriteLog("Looking for profile with name: " .. specific .. "...")

    for l, layout in ipairs(layouts.layouts) do
        if layout.layoutName == specific then
            DynamicUI:WriteLog("Found profile with index " .. l .. "...")
            if (layouts.activeLayout ~= l) then
                DynamicUI:WriteLog("Switching profile...")
                C_EditMode.SetActiveLayout(l)
            end

            return
        end
    end

    DynamicUI:WriteLog("Looking for profile with name: " .. widthOnly .. "...")

    for l, layout in ipairs(layouts.layouts) do
        if layout.layoutName == widthOnly then
            DynamicUI:WriteLog("Found profile with index " .. l .. "...")
            if (layouts.activeLayout ~= l) then
                DynamicUI:WriteLog("Switching profile...")
                C_EditMode.SetActiveLayout(l)
            end

            return
        end
    end

    DynamicUI:WriteLog("Couldn't find a matching profile...")
end

local Frame = CreateFrame("Frame", "EventFrame")
Frame:SetScript("OnEvent", function (self, event, ...)
    local c = ...

    DynamicUI:WriteLog("Incoming event: " .. event)

    if event == "ADDON_LOADED" and c[0] == ADDON_NAME then
        DynamicUI:SwitchUI()
    end

    if event == "PLAYER_ENTERING_WORLD" and c[1] == true then
        DynamicUI:SwitchUI()
    end
end)

for event in events do
    Frame:RegisterEvent(event)
end

_G[ADDON_NAME] = DynamicUI