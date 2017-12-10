local t = mods.RussianLanguagePack

local SkinsPuppet = require("widgets/skinspuppet")
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local DanceAnims = {
	"emoteXL_waving1", 
	"emoteXL_waving2", 
	"emoteXL_waving3",
	"emoteXL_happycheer",
	--"research",
	"emoteXL_kiss",
	"emote_strikepose",
	"emote_laugh",
	"emote_slowclap",
	"emote_jumpcheer",
	"emote_flex",
	"emote_swoon",
}

local Puppet = Class(Widget, function(self)
    Widget._ctor(self, "RLPuppet")
	
	self.player = self:AddChild(SkinsPuppet())
	self.player:AddShadow()
	self.player:SetCharacter(DST_CHARACTERLIST[math.random(#DST_CHARACTERLIST)])
	
	self.player:Hide()
	
	self.inst:DoTaskInTime(3, function()
		self.player:Show()
		self.player.animstate:PlayAnimation("enter")
		
		self.inst:DoTaskInTime(11*FRAMES, function(inst) 
			TheFrontEnd:GetSound():PlaySound("dontstarve/movement/bodyfall_dirt")
		end)
		
		self.inst:DoTaskInTime(self.player.animstate:GetCurrentAnimationLength(), function()
			self.player:DoIdleEmote()
		end)
	end)
	
	self.player.DanceTask = self.inst:DoPeriodicTask(15, function()
		if self.player.DanceTask ~= nil then
			self.player.DanceTask:Cancel()
			self.player.DanceTask = nil
		end
		
		if not self.player.is_running then
			self.player:DoEmote(DanceAnims, nil, true)
			
			-- self.inst:DoTaskInTime(self.player.animstate:GetCurrentAnimationLength(), function()
				-- self.player:_ResetIdleEmoteTimer()
				-- self.player:DoIdleEmote()
			-- end)
		end
	end)
end)

function Puppet:RunTo(where, time, donefn)
	self:MoveTo(self:GetPosition(), where, time, function()
		donefn()
	end)
end

return Puppet
