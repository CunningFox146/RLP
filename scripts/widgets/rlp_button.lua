local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local LanguageOptions = require "screens/LanguageOptions"

local OFFSET = -5.5

local RLPButton = Class(Widget, function(self)
    Widget._ctor(self, "RLPButton")
	
    self.btn = self:AddChild(ImageButton("images/global_redux.xml",
       "button_carny_square_normal.tex",
       "button_carny_square_hover.tex",
       "button_carny_square_disabled.tex",
       "button_carny_square_down.tex"))
	
	self.btn:SetFocusScale(1.05, 1.05, 1.05)
	self.btn:SetNormalScale(.7, .7, 1)

	self.btn.icon = self.btn:AddChild(Image("images/button_icons.xml", "mods.tex", "mods.tex"))
	self.btn.icon:SetPosition(-5,4)
	self.btn.icon:SetScale(.16)
	self.btn.icon:SetClickable(false)

	self.btn:SetTextSize(25)
	self.btn:SetText("Настроить\nрусификатор.", true)
	self.btn.text:SetPosition(-3, -34 + OFFSET)
	self.btn.text_shadow:SetPosition(-5, -36 + OFFSET)
	self.btn:SetFont(NEWFONT_OUTLINE)
	self.btn:SetTextColour(UICOLOURS.GOLD)
	self.btn:SetTextFocusColour(UICOLOURS.GOLD)
	
	self.btn:SetOnClick(function()
		TheFrontEnd:GetSound():KillSound("FEMusic")
		TheFrontEnd:GetSound():KillSound("FEPortalSFX")
		TheFrontEnd:GetSound():PlaySound("dontstarve/music/gramaphone_ragtime", "rlp_ragtime") 
		
		TheFrontEnd:FadeToScreen(TheFrontEnd:GetActiveScreen(), function() return LanguageOptions() end)
	end)
end)

return RLPButton
