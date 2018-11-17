local t = mods.RussianLanguagePack

local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local UpdateScreen = require "screens/update_screen"

local EyeButton = Class(Widget, function(self)
    Widget._ctor(self, "RLPEyeButton")
	
	self.btn = self:AddChild(ImageButton("images/web_button.xml", "web_button.tex", nil, nil, nil, nil, {1,1}, {0,0}))
	self.btn.image:SetPosition(-12, 0)

	self.btn.highlight = self.btn:AddChild(Image("images/frontend.xml", "button_square_highlight.tex"))
	self.btn.highlight:SetScale(1.5)
	self.btn.highlight:SetClickable(false)
	self.btn.highlight:Hide()

	self.btn:SetText("Обновить\nПеревод")
	self.btn:SetTextSize(25)
	self.btn.text:SetPosition(-12, -80)
	self.btn:SetFont(CHATFONT)
	self.btn:SetTextColour({.7,.7,.7,1})
	self.btn:SetTextFocusColour({1,1,1,1})
	self.btn.scale_on_focus = false
	
	self.btn:SetOnClick(function()
		TheFrontEnd:PushScreen(UpdateScreen())
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

return EyeButton
