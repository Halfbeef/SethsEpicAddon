-- This first line anchors the tooltip to the cursor! -- --
--hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent) self:SetOwner(parent, "ANCHOR_CURSOR") end)

local GameTooltip = GameTooltip

-- -- CREATING THE "MAIN FRAME" WHICH IS "F" IN THE CODE BELOW -- --
-- code for initialziing the frame and making it click and movable
local MainFrameSeth = CreateFrame("Frame","DragFrame2",UIParent)
MainFrameSeth:SetMovable(true)
MainFrameSeth:EnableMouse(true)
MainFrameSeth:RegisterForDrag("LeftButton")
MainFrameSeth:SetScript("OnDragStart", MainFrameSeth.StartMoving)
MainFrameSeth:SetScript("OnDragStop", MainFrameSeth.StopMovingOrSizing)
MainFrameSeth:SetClampedToScreen(true)

-- code for making the frame resizeable
MainFrameSeth:SetResizable(true)
MainFrameSeth:SetMaxResize(800,500)
MainFrameSeth.text = MainFrameSeth:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MainFrameSeth.text:SetPoint("BOTTOM", MainFrameSeth, "TOP", 5, 0)

-- code for setting up and displaying the frame
MainFrameSeth:SetFrameStrata("BACKGROUND")
MainFrameSeth:SetWidth(256)
MainFrameSeth:SetHeight(256)
local MainFrameTexture = MainFrameSeth:CreateTexture(nil,"BACKGROUND")
MainFrameTexture:SetTexture("Interface\\AddOns\\Seth'sEpicAddon\\images\\test.blp")
MainFrameTexture:SetAllPoints(MainFrameSeth)
MainFrameSeth.texture = MainFrameTexture
MainFrameSeth:SetPoint("CENTER",0,0)
MainFrameSeth:Show()

--Registering the events i want to track and set the scripts for said events
MainFrameSeth:RegisterEvent("FRIENDLIST_UPDATE")
MainFrameSeth:RegisterEvent("GOSSIP_CLOSED")
MainFrameSeth:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
MainFrameSeth:RegisterEvent("PLAYER_MONEY")
MainFrameSeth:RegisterEvent("MAIL_CLOSED")
MainFrameSeth:RegisterEvent("MAIL_SHOW")
MainFrameSeth:RegisterEvent("TAXIMAP_CLOSED")
MainFrameSeth:SetScript("OnEvent", 
function(self, event, ...)
    if(event == "FRIENDLIST_UPDATE") then
        MainFrameTexture:SetTexture("Interface\\AddOns\\Seth'sEpicAddon\\images\\test.blp")
        MainFrameSeth.text:SetText("Checked friendlist! Is Autoattak online? I hope so!")
    else if(event == "GOSSIP_CLOSED") then
        MainFrameTexture:SetTexture("Interface\\AddOns\\Seth'sEpicAddon\\images\\nutsBung.blp")
        MainFrameSeth.text:SetText("You just talked to an NPC! You finna cop a Hellcat now?")
    else if(event == "MAIL_SHOW") then
        MainFrameTexture:SetTexture("Interface\\AddOns\\Seth'sEpicAddon\\images\\money.blp")
        MainFrameSeth.text:SetText("Jake from State Farm is wearing Jeans.")
    else if(event == TAXIMAP_CLOSED) then
        MainFrameSeth.text:SetText("All aboard the Big Chungus express!")
        MainFrameTexture:SetTexture("Interface\\AddOns\\Seth'sEpicAddon\\images\\chungus.blp")
    end        
end
end
end   
end)

-- -- CREATING THE CHILD FRAME "Resize" WHICH WILL BE INSIDE THE MAIN FRAME -- --
-- -- THIS FRAME WILL BE USED FOR RESIZING ITS PARENT FRAME -- --

local ResizeFrame = CreateFrame("Button", nil, MainFrameSeth)
ResizeFrame:SetPoint("BOTTOMRIGHT", -6, 7)
ResizeFrame:SetSize(16, 16)
ResizeFrame:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
ResizeFrame:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
ResizeFrame:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
ResizeFrame:SetScript("OnMouseDown", function()
	MainFrameSeth:StartSizing("BOTTOMRIGHT")
end)
ResizeFrame:SetScript("OnMouseUp", function()
	MainFrameSeth:StopMovingOrSizing()
end)

local ClosingFrame = CreateFrame("Button", nil, MainFrameSeth)
ClosingFrame:SetPoint("TOPRIGHT", -6, -5)
ClosingFrame:SetSize(16, 16)
ClosingFrame:SetNormalTexture("Interface\\AddOns\\Seth'sEpicAddon\\images\\close.blp")
ClosingFrame:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
ClosingFrame:SetScript("OnMouseDown", function()
	MainFrameSeth:Hide()
end)

-- -- This is the code that generates the items equiped by the player. -- ---
-- -- Note that these are not in functions due to the local nature of the variables -- --
local headLink = GetInventoryItemLink("player",GetInventorySlotInfo("HeadSlot"))
local _, itemHeadLink, _, _, _, _, itemType = GetItemInfo(headLink)
local itemHeadString = select(3, strfind(headLink, "|H(.+)|h"))


-- -- Create the Linkframe and tie the text to it -- --
-- -- Note that the main frame is a parent of this link frame -- --
CreateFrame("Frame", "HeadFrame", MainFrameSeth)
HeadFrame:SetPoint("TOP", 0, -1)
HeadFrame:SetSize(100,50)

HeadLinkText = HeadFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
HeadLinkText:SetText(itemHeadLink)
HeadLinkText:SetPoint("CENTER")
HeadFrame:EnableMouse(true)
HeadFrame:Show()

-- -- Events and scripts to register for the linkframe -- --
HeadFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
HeadFrame:SetScript("OnEvent", 
function(self, event, ...)
    headLink = GetInventoryItemLink("player",GetInventorySlotInfo("HeadSlot"))
    _, itemHeadLink, _, _, _, _, itemType = GetItemInfo(headLink)
    itemHeadString = select(3, strfind(headLink, "|H(.+)|h"))
    HeadLinkText:SetText(itemHeadLink)
end)
HeadFrame:HookScript("OnEnter", function()
    if(itemHeadLink) then
    GameTooltip:SetOwner(MainFrameSeth, "ANCHOR_CURSOR");
    GameTooltip:SetHyperlink(itemHeadString)
    GameTooltip:Show()
    end
end)
HeadFrame:HookScript("OnLeave", function()
    GameTooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR");
	GameToolTip:Hide()
end)

-- FeetLink --
local feetLink = GetInventoryItemLink("player",GetInventorySlotInfo("FeetSlot"))
local _, itemFeetLink, _, _, _, _, itemType = GetItemInfo(feetLink)
local itemFeetString = select(3, strfind(feetLink, "|H(.+)|h"))

CreateFrame("Frame", "FeetFrame", MainFrameSeth)
FeetFrame:SetPoint("BOTTOM", 0, -1)
FeetFrame:SetSize(150,50)

FeetLinkText = FeetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
FeetLinkText:SetText(itemFeetLink)
FeetLinkText:SetPoint("CENTER")
FeetFrame:EnableMouse(true)
FeetFrame:Show()

-- -- Events and scripts to register for the linkframe -- --
FeetFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
FeetFrame:SetScript("OnEvent", 
function(self, event, ...)
    feetLink = GetInventoryItemLink("player",GetInventorySlotInfo("FeetSlot"))
    _, itemFeetLink, _, _, _, _, itemType = GetItemInfo(feetLink)
    itemFeetString = select(3, strfind(feetLink, "|H(.+)|h"))
    FeetLinkText:SetText(itemFeetLink)
end)
FeetFrame:HookScript("OnEnter", function()
    if(itemFeetLink) then
    GameTooltip:SetOwner(MainFrameSeth, "ANCHOR_CURSOR");
    GameTooltip:SetHyperlink(itemFeetString)
    GameTooltip:Show()
    end
end)
FeetFrame:HookScript("OnLeave", function()
    GameTooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR");
	GameToolTip:Hide()
end)


-- MainHandLink --
local mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
local _, itemMainHandLink, _, _, _, _, itemType = GetItemInfo(mainHandLink)
local itemMainHandString = select(3, strfind(mainHandLink, "|H(.+)|h"))

CreateFrame("Frame", "MainHandFrame", MainFrameSeth)
MainHandFrame:SetPoint("CENTER", -120, -1)
MainHandFrame:SetSize(100,50)

MainHandLinkText = MainHandFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
MainHandLinkText:SetText(itemMainHandLink)
MainHandLinkText:SetPoint("CENTER")
MainHandFrame:EnableMouse(true)
MainHandFrame:Show()

-- -- Events and scripts to register for the linkframe -- --
MainHandFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
MainHandFrame:SetScript("OnEvent", 
function(self, event, ...)
    mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
    _, itemMainHandLink, _, _, _, _, itemType = GetItemInfo(mainHandLink)
    itemMainHandString = select(3, strfind(mainHandLink, "|H(.+)|h"))
    MainHandLinkText:SetText(itemMainHandLink)
end)
MainHandFrame:HookScript("OnEnter", function()
    if(itemMainHandLink) then
    GameTooltip:SetOwner(MainFrameSeth, "ANCHOR_CURSOR");
    GameTooltip:SetHyperlink(itemMainHandString)
    GameTooltip:Show()
    end
end)
MainHandFrame:HookScript("OnLeave", function()
    GameTooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR");
	GameToolTip:Hide()
end)




-- SecondaryHandLink --
local secondHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("SecondaryHandSlot"))
local _, itemSecondHandLink, _, _, _, _, itemType = GetItemInfo(secondHandLink)
local itemSecondHandString = select(3, strfind(secondHandLink, "|H(.+)|h"))

CreateFrame("Frame", "SecondaryHandFrame", MainFrameSeth)
SecondaryHandFrame:SetPoint("CENTER", 120, -1)
SecondaryHandFrame:SetSize(100,50)

SecondaryHandLinkText = SecondaryHandFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
SecondaryHandLinkText:SetText(itemSecondHandLink)
SecondaryHandLinkText:SetPoint("CENTER")
SecondaryHandFrame:EnableMouse(true)
SecondaryHandFrame:Show()

-- -- Events and scripts to register for the linkframe -- --
SecondaryHandFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
SecondaryHandFrame:SetScript("OnEvent", 
function(self, event, ...)
    secondHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("SecondaryHandSlot"))
    _, itemSecondHandLink, _, _, _, _, itemType = GetItemInfo(secondHandLink)
    itemSecondHandString = select(3, strfind(secondHandLink, "|H(.+)|h"))
    SecondaryHandLinkText:SetText(itemSecondHandLink)
end)
SecondaryHandFrame:HookScript("OnEnter", function()
    if(itemSecondHandLink) then
    GameTooltip:SetOwner(MainFrameSeth, "ANCHOR_CURSOR");
    GameTooltip:SetHyperlink(itemSecondHandString)
    GameTooltip:Show()
    end
end)
SecondaryHandFrame:HookScript("OnLeave", function()
    GameTooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR");
	GameToolTip:Hide()
end)