local Widget = require "widgets/widget"
local Text = require "widgets/text"
local TEMPLATES = require "widgets/redux/templates"
local ModsScreen = require "screens/redux/modsscreen"

local t = mods.RussianLanguagePack

local COLOUR_RED = {255/255, 25/255, 0, 1}

local UpdateChecker = Class(Widget, function(self)
    Widget._ctor(self, "UpdateChecker")
	
	self.bg = self:AddChild(TEMPLATES.RectangleWindow(175, 250, "Внимание!",
	{
		{ text = "Обновить!", cb = function() 
			if t.IsLive then
				VisitURL(t.Repository)
			else
				TheFrontEnd:FadeToScreen(TheFrontEnd:GetActiveScreen(), function() return ModsScreen() end)
			end
		end},
	},
	nil, "Вам нужно обновить русификатор! Последняя версия:"))
	
	local r, g, b = unpack(UICOLOURS.BROWN_DARK)
    self.bg:SetBackgroundTint(r, g, b, 1)
	
	if self.bg.actions then
		self.bg.actions:SetPosition(0, 35)
	end
	
	if self.bg.body then
		self.bg.body:SetPosition(0, 25)
	end
	
	self.last_ver_text = self.bg:AddChild(Text(HEADERFONT, 50))
	self.last_ver_text:SetRegionSize(185, 200)
	self.last_ver_text:SetPosition(0, -60)
	
	self:Hide()
	
	self:SyncVersion()
end)

function UpdateChecker:SyncVersion()
	t.VerChecker:GetVersion(function(ver)
		if ver and t.modinfo.version ~= ver then
			self.last_ver_text:SetString(t.IsBeta and ver:gsub("_beta", "") or ver)
			self.last_ver_text:SetColour(COLOUR_RED)
			
			self:Show()
			self.bg:MoveTo(Vector3(500, 0, 0), Vector3(0, 0, 0), .5)
		end
	end)
end


return UpdateChecker