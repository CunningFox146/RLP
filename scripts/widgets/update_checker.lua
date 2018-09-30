local Widget = require "widgets/widget"
local Text = require "widgets/text"
local TEMPLATES = require "widgets/redux/templates"
local ModsScreen = require "screens/redux/modsscreen"

local t = mods.RussianLanguagePack

local COLOUR_RED = {255/255,25/255,0,1}

local UpdateChecker = Class(Widget, function(self)
    Widget._ctor(self, "UPDATE_CHECKER")
	--sizeX, sizeY, title_text, bottom_buttons, button_spacing, body_text
	self.bg = self:AddChild(TEMPLATES.CurlyWindow(150, 175, "Внимание!",
	{
		{ text = "Обновить!", cb = function() 
			TheFrontEnd:FadeToScreen(TheFrontEnd:GetActiveScreen(), function() return ModsScreen() end)
		end},
	},
	nil, "Вам нужно обновить русификатор! Последняя версия:"))
	
	if self.bg.actions then
		self.bg.actions:SetPosition(0, 30)
	end
	
	if self.bg.body then
		self.bg.body:SetPosition(0, 55)
	end
	
	self.last_ver_text = self.bg:AddChild(Text(HEADERFONT, 50))
	self.last_ver_text:SetRegionSize(185, 200)
	self.last_ver_text:SetPosition(0, -30)
	
	self:Hide()
	
	self.inst:DoTaskInTime(1, function() self:SyncVersion() end)
end)

function UpdateChecker:SyncVersion()
	t.VerChecker:GetData(function(data)
		if data.last_ver ~= nil and t.modinfo.version ~= data.last_ver then
			self.last_ver_text:SetString(data.last_ver)
			self.last_ver_text:SetColour(COLOUR_RED)
			
			self:Show()
			self.bg:MoveTo(Vector3(500, 0, 0), Vector3(0, 0, 0), .5)
		end
	end)
end


return UpdateChecker