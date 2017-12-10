local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local LanguageOptions = require "screens/LanguageOptions"

local OFFSET = -5.5

local RLPButton = Class(Widget, function(self)
    Widget._ctor(self, "RLPButton")
	
	--self:SetPosition(1040, 124 , 0)
	
	self.btn = self:AddChild(ImageButton("images/frontend.xml", "button_square.tex", "button_square_halfshadow.tex", "button_square_disabled.tex", "button_square_halfshadow.tex", "button_square_disabled.tex", {1,1}, {0,0}))
	self.btn.image:SetScale(.7)

	self.btn.icon = self.btn:AddChild(Image("images/button_icons.xml", "mods.tex", "mods.tex"))
	self.btn.icon:SetPosition(-5,4)
	self.btn.icon:SetScale(.16)
	self.btn.icon:SetClickable(false)

	self.btn.highlight = self.btn:AddChild(Image("images/frontend.xml", "button_square_highlight.tex"))
	self.btn.highlight:SetScale(.7)
	self.btn.highlight:SetClickable(false)
	self.btn.highlight:Hide()

	self.btn:SetTextSize(25)
	self.btn:SetText("Настроить\nрусификатор.", true)
	self.btn.text:SetPosition(-3, -34 + OFFSET)
	self.btn.text_shadow:SetPosition(-5, -36 + OFFSET)
	self.btn:SetFont(NEWFONT_OUTLINE)
	self.btn:SetTextColour({unpack(GOLD)})
	self.btn:SetTextFocusColour({1,1,1,1})
	
	self.btn:SetOnClick(function()
		TheFrontEnd:FadeToScreen(TheFrontEnd:GetActiveScreen(), function() return LanguageOptions() end, nil)
	end)

	self.btn:SetOnGainFocus(function()
		if self.btn:IsEnabled() and not self.btn:IsSelected() and TheFrontEnd:GetFadeLevel() <= 0 then
			self.btn.highlight:Show()
		end
	end)
	
	self.btn:SetOnLoseFocus(function()
		self.btn.highlight:Hide()
	end)
end)

return RLPButton
