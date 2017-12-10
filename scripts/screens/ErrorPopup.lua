local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local Menu = require "widgets/menu"
local Text = require "widgets/text"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
local TEMPLATES = require "widgets/templates"


local MATERIALS =
{
	bgconstructor = function(root)
		local bg = root:AddChild(Image("images/fepanels.xml", "wideframe.tex"))
		bg:SetScale(0.70, 0.70)
		bg:SetPosition(0, 10)
		return bg
	end,
	title = {font=TITLEFONT, size=50, colour={1,1,1,1}},
	text = {font=NEWFONT_OUTLINE, size=28, colour={1,1,1,1}},
}

local ErrorPopup = Class(Screen, function(self, buttons, spacing_override)
	Screen._ctor(self, "ErrorPopup")

    --assert(MATERIALS)

    self.black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
    self.black.image:SetVRegPoint(ANCHOR_MIDDLE)
    self.black.image:SetHRegPoint(ANCHOR_MIDDLE)
    self.black.image:SetVAnchor(ANCHOR_MIDDLE)
    self.black.image:SetHAnchor(ANCHOR_MIDDLE)
    self.black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.black.image:SetTint(0,0,0,0)
    self.black:SetOnClick(function() --[[ eat the click ]] end)

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,0,0)
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)

    self.bg = MATERIALS.bgconstructor(self.proot)

	--title	
    self.title = self.proot:AddChild(Text(HEADERFONT, MATERIALS.title.size))
    self.title:SetPosition(5, 88, 0)
    self.title:SetString("Маленькие текстуры")
    self.title:SetColour(unpack(MATERIALS.title.colour))

    --text
    self.text = self.proot:AddChild(Text(CHATFONT, 25))
    self.text:SetPosition(5, -15, 0)
    self.text:SetString("У Вас включён режим \"Маленькие текстуры (Small Textutes)\". В этом режиме Klei отключили загрузку всех шрифтов, кроме основных, из-за чего некоторые буквы могут стать вопросами (???). Мы сделали обход, но он может не сработать. Вы предупреждены.")
    self.text:SetColour({1,1,1,1})
    self.text:EnableWordWrap(true)
    self.text:SetRegionSize(500, 160)
    self.text:SetVAlign(ANCHOR_MIDDLE)
    
    local spacing = spacing_override or 200

	self.menu = self.proot:AddChild(Menu(buttons, spacing, true))
	self.menu:SetPosition(-(spacing*(#buttons-1))/2, -127, 0) 
    for i,v in pairs(self.menu.items) do
        v:SetScale(.7)
    end
	self.buttons = buttons

	self.default_focus = self.menu
end)

function ErrorPopup:SetTitleTextSize(size)
	self.title:SetSize(size)
end

function ErrorPopup:SetButtonTextSize(size)
	self.menu:SetTextSize(size)
end

function ErrorPopup:OnControl(control, down)
    if ErrorPopup._base.OnControl(self,control, down) then return true end
    
    if control == CONTROL_CANCEL and not down then    
        if #self.buttons > 1 and self.buttons[#self.buttons] then
            self.buttons[#self.buttons].cb()
            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
            return true
        end
    end
end


function ErrorPopup:Close()
	TheFrontEnd:PopScreen(self)
end

function ErrorPopup:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {}
	if #self.buttons > 1 and self.buttons[#self.buttons] then
        table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)	
    end
	return table.concat(t, "  ")
end

return ErrorPopup
