local ADDON_NAME = "DynamicUI"
local DEBUG = true

local DynamicUI = {};

local events = {
    "ADDON_LOADED",
    "PLAYER_ENTERING_WORLD",
}

function DynamicUI:WriteLog(message)
    if DEBUG == true then
        print ("[" .. ADDON_NAME .. "] " .. message)
    end
end

function DynamicUI:SwitchUI()
    local layouts = C_EditMode.GetLayouts()
    local uiScale = 1
    local width = math.floor(GetScreenWidth())
    local height = math.floor(GetScreenHeight())

    if GetCVar("useUiScale") == "1" then
        uiScale = math.floor(UIParent:GetEffectiveScale())
    end

    local specific = math.floor(width / uiScale) .. "x" .. math.floor(width / uiScale)
    local widthOnly = math.floor(width / uiScale) .. "p"

    DynamicUI:WriteLog("Native resolution: " .. GetScreenWidth() .. "x" .. GetScreenHeight())
    DynamicUI:WriteLog("Looking for profile with name: " .. specific .. " (" .. (uiScale * 100) .. "% scaling)...")

    for l, layout in ipairs(layouts.layouts) do
        if layout.layoutName == specific then
            DynamicUI:WriteLog("Found profile with index " .. l .. "...")

            if (layouts.activeLayout ~= l) then
                DynamicUI:WriteLog("Switching profile...")
                C_EditMode.SetActiveLayout(layout)
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
                C_EditMode.SetActiveLayout(layout)
            end

            return
        end
    end

    DynamicUI:WriteLog("Couldn't find a matching profile...")
end

local Frame = CreateFrame("Frame", "EventFrame")
Frame:SetScript("OnEvent", function (self, event, ...)
    local c, d = ...

    if (event == "ADDON_LOADED" and c == ADDON_NAME)
    or (event == "PLAYER_ENTERING_WORLD" and d == true)
    or (event == "DISPLAY_SIZE_CHANGED")
    or (event == "CVAR_UPDATE" and (c == "RenderScale" or c == "uiScale" or c == "useUiScale")) then
        DynamicUI:WriteLog("Triggered on " .. event .. ".")
        DynamicUI:SwitchUI()
    end
end)

Frame:RegisterEvent("ADDON_LOADED")
Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
Frame:RegisterEvent("CVAR_UPDATE")

_G[ADDON_NAME] = DynamicUI
