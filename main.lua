local frame = CreateFrame("FRAME"); -- Need a frame to respond to events


local function GetIdLink(Link) -- returns id from itemlink, by parsing the itemlink string
    if Link == nil then
        return -1
    end
    local _,_,_,_, id,_,_,_,_,_,_,_,_,_ = string.find(Link,
            "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
    return id
end


local function IsQuestItem(Link) -- return boolean for quest item using GetItemInfo
    if Link == nil then
        return false
    end
    local _,_,_,_,_,itemType,_,_,_,_,_ = GetItemInfo(GetIdLink(Link))
    return (itemType == "Quest")
end


local function LootCommandHandler(Link) -- handles the /agus command
    if(string.len(Link) > 0) then
        local Id = GetIdLink(Link)
        flag = 0
        for _,v in pairs(ItemList) do
          if v == Id then
                flag = 1
            break
          end
        end
        if flag == 0 then
            table.insert(ItemList,Id);
        end
    else
        print("Usage: /agus [ItemLink]")
    end
end


function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "AgusLoot" then -- Our saved variables are ready at this point. If there are none, both variables will set to nil.
        print("[AgusLoot] holi C:")
        if ItemList == nil then
            ItemList = {}
        end
    elseif event == "LOOT_OPENED" then
        for slot = 1,GetNumLootItems() do -- loop all the slots
            if (LootSlotHasItem(slot)) then 
                local SlotLink = GetLootSlotLink(slot)
                local id = GetIdLink(SlotLink)
                if not (id == -1) then -- If is not coin
                    for _,v in pairs(ItemList) do
                        if id == v then
                            LootSlot(slot)
                        end
                    end
                    if IsQuestItem(GetLootSlotLink(slot)) then
                        LootSlot(slot)
                    end
                else
                    LootSlot(slot)
                end
            else
                LootSlot(slot)
            end
        end
    end
end

SLASH_AGUSLOOT1 = "/agus"
SLASH_ISQUEST1 = "/isquest"

SlashCmdList["AGUSLOOT"] = LootCommandHandler
SlashCmdList["ISQUEST"]  = IsQuestItem


frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("LOOT_OPENED"); -- Fired when loot windows is opened
frame:SetScript("OnEvent", frame.OnEvent);