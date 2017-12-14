local t = mods.RussianLanguagePack

local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local EyeButton = Class(Widget, function(self)
    Widget._ctor(self, "RLPEyeButton")
	
	self.btn = self:AddChild(ImageButton("images/frontend.xml", "button_square.tex", "button_square_halfshadow.tex", "button_square_disabled.tex", "button_square_halfshadow.tex", "button_square_disabled.tex", {1,1}, {0,0}))
	self.btn.image:SetScale(1.5)

	self.btn.icon = self.btn:AddChild(Image("images/web_button.xml", "web_button.tex", "web_button.tex"))
	self.btn.icon:SetPosition(-15,10,0)
	self.btn.icon:SetScale(.88)
	self.btn.icon:SetClickable(false)

	self.btn.highlight = self.btn:AddChild(Image("images/frontend.xml", "button_square_highlight.tex"))
	self.btn.highlight:SetScale(1.5)
	self.btn.highlight:SetClickable(false)
	self.btn.highlight:Hide()

	self.btn:SetText("Страница с\nобновлениями.")
	self.btn:SetTextSize(32)
	self.btn.text:SetPosition(-12, -57)
	self.btn:SetFont(CHATFONT)
	self.btn:SetTextColour({.7,.7,.7,1})
	self.btn:SetTextFocusColour({1,1,1,1})
	self.btn.scale_on_focus = false
	
	self.btn:SetOnClick(function()
		VisitURL("http://steamcommunity.com/sharedfiles/filedetails/changelog/"..t.SteamID)
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
