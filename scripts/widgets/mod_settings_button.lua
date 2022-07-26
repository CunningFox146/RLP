local t = mods.RussianLanguagePack

local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local UIAnimButton = require "widgets/uianimbutton"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"

local RLPModButton = Class(Widget, function(self)
    Widget._ctor(self, "RLPModButton")
	
	local transtype = Profile:GetModTranslationEnabled()
	
	--Добавим инфу о модах
	self.info = self:AddChild(ImageButton("images/ui.xml", "button_small.tex", "button_small.tex", "button_small.tex", "button_small.tex", "button_small.tex", {1,1}, {0,0}))
	self.info:SetPosition(-74,0,1)
	self.info.image:SetScale(1.4, 1.075, 1)
	self.info.image:SetRotation(90)

	self.info.icon = self.info:AddChild(Image("images/inf_btn.xml", "inf_btn.tex", "inf_btn.tex"))
	self.info.icon:SetScale(.45)
	self.info.icon:SetClickable(false)
	
	self.info.highlight = self.info:AddChild(Image("images/frontend.xml", "button_square_highlight.tex"))
	self.info.highlight:SetPosition(6,-6,1)
	self.info.highlight:SetScale(1, 1.4, 1)
	self.info.highlight:SetClickable(false)
	self.info.highlight:Hide()
	
	self.status = transtype == t.ModTranslationTypes.Enabled and "enabled" or "disabled" --сохраняем то значение, которое у нас при входе в это окно
	
	self.btn = self:AddChild(UIAnimButton("mods_button", "mods_button", nil, nil, nil, nil, nil))--bank, build, idle_anim, focus_anim, disabled_anim, down_anim, selected_anim
	
	local function AntiSpam(time)
		if self.task then
			self.task:Cancel()
			self.task = nil
		end
	
		self.btn:SetClickable(false)
		self.task = self.inst:DoTaskInTime(time, function() self.btn:SetClickable(true) end)
	end
	
	self.btn:SetScale(.9, .9, 1)
	self.btn.animstate:PlayAnimation("pre_"..self.status)
	self.btn.animstate:PushAnimation("idle_"..self.status)
	AntiSpam(.8)
	
	self.btn:SetText("")
	self.btn:SetTextSize(35)
	self.btn.text:SetPosition(165, 0)
	self.btn.text:SetFont(CHATFONT)
	self.btn.text:SetHAlign(ANCHOR_LEFT)
	self.btn:SetTextColour({.8,.8,.8,1})
	self.btn:SetTextFocusColour({1,1,1,1})
	
	self:UpdateText()
	
	self.btn:SetOnClick(function()
		if self.status == "enabled" then
			self.btn.animstate:PlayAnimation("onclick_enabled")
            self.btn:SetLoop("idle_disabled", false)
            self.btn.animstate:PushAnimation("idle_disabled")
			
			AntiSpam(.6)
			
			self.status = "disabled"
			Profile:SetLocalizaitonValue("mod_translation_type", t.ModTranslationTypes.Disabled)
			
			self:UpdateText()
		else
			self.btn.animstate:PlayAnimation("onclick_disabled")
            self.btn:SetLoop("idle_enabled", false)
            self.btn.animstate:PushAnimation("idle_enabled")
			
			AntiSpam(.6)
			
			self.status = "enabled"
			Profile:SetLocalizaitonValue("mod_translation_type", t.ModTranslationTypes.Enabled)
			
			self:UpdateText()
		end
	end)
	
	self.info:SetOnClick(function()
		VisitURL("http://steamcommunity.com/workshop/filedetails/?id=556346855")
	end)

	self.info:SetOnGainFocus(function()
		if self.info:IsEnabled() and not self.info:IsSelected() and TheFrontEnd:GetFadeLevel() <= 0 then
			self.info.highlight:Show()
		end
		
		self.info.image:SetScale(1.4, 1.075, 1)
	end)
	
	self.info:SetOnLoseFocus(function()
		self.info.highlight:Hide()
		
		self.info.image:SetScale(1.4, 1.075, 1)
	end)
	
	--[[
	self.btn:SetOnGainFocus(function()
		if self.btn:IsEnabled() and not self.btn:IsSelected() and TheFrontEnd:GetFadeLevel() <= 0 then
			self.btn.image:SetScale(.325)--Мда
			self.btn.highlight:Show()
		end
	end)
	
	self.btn:SetOnLoseFocus(function()
		self.btn.image:SetScale(.325)
		self.btn.highlight:Hide()
	end)
	]]
end)

function RLPModButton:UpdateText()
	self.btn:SetText(self.status == "enabled" and "Перевод модов\nвключён" or "Перевод модов\nвыключён")
end

return RLPModButton
