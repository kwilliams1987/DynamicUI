local ADDON_NAME = "DynamicUI"
local BUILTIN_LAYOUTS = 2
local DEBUG = false

local DynamicUI = {};

-- Value can be either "true" to always trigger or a function
-- accepting the arguments of the event which returns true when it should trigger.
local events = {
    ["DISPLAY_SIZE_CHANGED"] = true,
    ["PLAYER_ENTERING_WORLD"] = true,
}

function DynamicUI:WriteLog(message)
    if DEBUG == true then
        print("[" .. ADDON_NAME .. "] " .. message)
    end
end

function DynamicUI:SwitchUI()
    local layouts = C_EditMode.GetLayouts()
    local width, height = GetPhysicalScreenSize()

    local strict = width .. "x" .. height
    local loose = height .. "p"
    local looseMatch = nil

    DynamicUI:WriteLog("Looking for matching profiles: " .. strict .. " or " .. loose .. "...")

    for l, layout in pairs(layouts.layouts) do
        DynamicUI:WriteLog("> Comparing: " .. strict .. " to: " .. layout.layoutName .. "...")
        local index = l + BUILTIN_LAYOUTS

        if layout.layoutName == strict then
            DynamicUI:WriteLog("Using strict profile match " .. strict .. "...")
            DynamicUI:WriteLog("> Comparing to: " .. layout.layoutName)

            DynamicUI:WriteLog("> Comparing: " .. layouts.activeLayout .. " to: " .. index .. "...")
            if (layouts.activeLayout ~= index) then
                DynamicUI:WriteLog("Switching profile...")
                C_EditMode.SetActiveLayout(index)
            end

            return
        end

        DynamicUI:WriteLog("> Comparing: " .. loose .. " to: " .. layout.layoutName .. "...")
        if layout.layoutName == loose then
            DynamicUI:WriteLog("Found potential loose match with index " .. index .. "...")
            looseMatch = index
        end
    end

    if looseMatch ~= nil then
        DynamicUI:WriteLog("Using loose profile match " .. loose .. "...")

        DynamicUI:WriteLog("> Comparing: " .. layouts.activeLayout .. " to: " .. looseMatch .. "...")
        if (layouts.activeLayout ~= looseMatch) then
            DynamicUI:WriteLog("Switching profile...")
            C_EditMode.SetActiveLayout(looseMatch)
        end

        return
    end

    DynamicUI:WriteLog("Couldn't find a matching profile...")
end

local Frame = CreateFrame("Frame", "EventFrame")
Frame:SetScript("OnEvent", function(self, event, ...)
    if events[event] ~= nil and (events[event] == true or events[event](...)) then
        DynamicUI:WriteLog("Triggered on " .. event .. ".")
        DynamicUI:SwitchUI()
    end
end)

for event, _ in pairs(events) do
    Frame:RegisterEvent(event)
end

_G[ADDON_NAME] = DynamicUI
