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
	
	self.inst:DoTaskInTime(0, function() self:SyncVersion() end)
end)

function UpdateChecker:SyncVersion()	
	TheSim:QueryServer("https://cunningfox146.github.io",
		function( result, isSuccessful, resultCode )
			if isSuccessful and string.len(result) > 1 and resultCode == 200 then
				self.last_ver = result
			
				print("[RusificationSyncVersion]: Current version - "..tostring(t.modinfo.version)..". Last version - "..tostring(self.last_ver))
			else
				print("[RusificationSyncVersion]: ERROR! FAILED TO LOAD LAST VERSION!")
				self.is_error = true
			end
		end,
	"GET")
	
	self.inst:DoTaskInTime(1 + math.random(), function()
		if not self.is_error and t.modinfo.version ~= self.last_ver then
			self.last_ver_text:SetString(self.last_ver)
			self.last_ver_text:SetColour(COLOUR_RED)
			
			self:Show()
			self.bg:MoveTo(Vector3(500, 0, 0), Vector3(0, 0, 0), .5)
		end
	end)
end


return UpdateChecker