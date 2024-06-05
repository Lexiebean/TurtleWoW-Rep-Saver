RepSaver = {}

local function RepSaverExportCSV()
	local _G = getfenv(0)
	local PaneBackdrop  = {
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
		edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 5, bottom = 3 }
	}

	-- If we haven't created these frames, then lets do so now.
	if (not _G["RepSaverCopyFrame"]) then
		local frame = CreateFrame("Frame", "RepSaverCopyFrame", UIParent)
		tinsert(UISpecialFrames, "RepSaverCopyFrame")
		frame:SetBackdrop(PaneBackdrop)
		frame:SetBackdropColor(0,0,0,1)
		frame:SetWidth(350)
		frame:SetHeight(400)
		frame:SetPoint("CENTER", UIParent, "CENTER")
		frame:SetFrameStrata("DIALOG")
		frame:SetClampedToScreen(true)

		frame.title = CreateFrame("Frame", "RepSaverCopyFrameGUITtitle", frame)
		frame.title:SetPoint("TOP", frame, "TOP", 0, 12)
		frame.title:SetWidth(256)
		frame.title:SetHeight(64)

		frame.title.tex = frame.title:CreateTexture(nil, "MEDIUM")
		frame.title.tex:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
		frame.title.tex:SetAllPoints()

		frame.title.text = frame.title:CreateFontString(nil, "HIGH", "GameFontNormal")
		frame.title.text:SetText("Rep Saver Export")
		frame.title.text:SetPoint("TOP", 0, -14)

		local scrollArea = CreateFrame("ScrollFrame", "RepSaverCopyScroll", frame, "UIPanelScrollFrameTemplate")
		scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
		scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

		frame:SetMovable(true)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnMouseDown", function()
			if arg1 == "LeftButton" and not this.isMoving then
				this:StartMoving();
				this.isMoving = true;
			end
		end)
		frame:SetScript("OnMouseUp", function()
			if arg1 == "LeftButton" and this.isMoving then
				this:StopMovingOrSizing();
				this.isMoving = false;
			end
		end)
		frame:SetScript("OnHide", function()
			if this.isMoving then
				this:StopMovingOrSizing();
				this.isMoving = false;
			end
		end)

		RepSaverExportCSVeditBox = CreateFrame("EditBox", "RepSaverCopyEdit", frame)
		RepSaverExportCSVeditBox:SetMultiLine(true)
		RepSaverExportCSVeditBox:SetMaxLetters(99999)
		RepSaverExportCSVeditBox:EnableMouse(true)
		RepSaverExportCSVeditBox:SetAutoFocus(false)
		RepSaverExportCSVeditBox:SetFontObject(ChatFontNormal)
		RepSaverExportCSVeditBox:SetWidth(400)
		RepSaverExportCSVeditBox:SetHeight(270)
		RepSaverExportCSVeditBox:SetScript("OnEscapePressed", function() frame:Hide() end)
		RepSaverExportCSVeditBox:SetText("")

		scrollArea:SetScrollChild(RepSaverExportCSVeditBox)

		local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT",frame,"TOPRIGHT")
	end

	local exportwindow = _G["RepSaverCopyFrame"]
	local RepSaverExportCSVeditBox = _G["RepSaverCopyEdit"]

	RepSaverExportCSVeditBox:Insert("Name;standingId;bottomValue;topValue;earnedValue\n")

	for i=1, table.getn(RepSaver) do
		RepSaverExportCSVeditBox:Insert(RepSaver[i].."\n")
    end

	RepSaverExportCSVeditBox:HighlightText(0)
	exportwindow:Show()
end

local function RepSave()
	RepSaver = {}
	for i=1, GetNumFactions() do
		local name, _, standingId, bottomValue, topValue, earnedValue = GetFactionInfo(i)
		RepDump = name..";"..standingId..";"..bottomValue..";"..topValue..";"..earnedValue
		table.insert(RepSaver, RepDump)
	end
	RepSaverExportCSV()
end

SLASH_REPSAVER1, SLASH_REPSAVER2 = "/repsave", "/repsaver"
SlashCmdList["REPSAVER"] = function()
	RepSave()
end
