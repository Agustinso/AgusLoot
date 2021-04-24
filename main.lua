SLASH_AGUSLOOT1 = "/agus"

local function LootCommandHandler(ItemLink)
    if(string.len(ItemLink) > 0) then
        local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4,
            Suffix, Unique, LinkLvl, Name = string.find(ItemLink,
            "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
        print(Id)
        print(Name)
        for _,v in pairs(ItemList) do
          if v == ItemLink then
            -- do something
            break
          end
        end
    else
        print("Hello, " .. UnitName("player") .. "!")
    end
end
--LOOT_OPENED
SlashCmdList["AGUSLOOT"] = LootCommandHandler


local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("LOOT_OPENED"); -- Fired when about to log out

function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "AgusLoot" then -- Our saved variables are ready at this point. If there are none, both variables will set to nil.
        print("[AgusLoot] holi C:")
        if ItemList == nil then
            ItemList = {}; -- This is the first time this addon is loaded; initialize 
        end
    elseif event == "LOOT_OPENED" then
        for i = 1,GetNumLootItems(), +1
        do
            SlotLink = GetLootSlotLink(i)
            local _, _, _, _, id, _, _, _, _, _,
                _, _, _, Name = string.find(ItemLink,
                "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
            
            for _,v in pairs(ItemList) do
                if id == v then
                    LootSlot(i)
                break
              end
            end
        end
    end
end
frame:SetScript("OnEvent", frame.OnEvent);