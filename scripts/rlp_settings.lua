local env = env
local t = mods.RussianLanguagePack

GLOBAL.setfenv(1, GLOBAL)

--Для тех, кто пользуется ps4 или NACL должна быть возможность сохранять не в ини файле, а в облаке.
--Для этого дорабатываем функционал стандартного класса PlayerProfile

do 
	local USE_SETTINGS_FILE = PLATFORM ~= "PS4" and PLATFORM ~= "NACL"

	local function tobool(str)
		if not str or str:lower() == "false" then
			return false
		end
		return true
	end
	
	local function SetLocalizaitonValue(self, name, value) --Метод, сохраняющий опцию с именем name и значением value
		-- print("SetLocalizaitonValue", name, value, CalledFrom())
		if USE_SETTINGS_FILE then
			TheSim:SetSetting("translation", name, tostring(value))
		else
			self:SetValue(tostring(name), value)
			self.dirty = true
			self:Save() --Сохраняем сразу, поскольку у нас нет кнопки "применить"
		end
	end
	
	local function GetLocalizaitonValue(self, name) --Метод, возвращающий значение опции name
		-- print("GetLocalizaitonValue", name, CalledFrom())
		local USE_SETTINGS_FILE = PLATFORM ~= "PS4" and PLATFORM ~= "NACL"
		if USE_SETTINGS_FILE then
			return TheSim:GetSetting("translation", name)
		end
		return self:GetValue(name)
	end
	
	local function GetTranslationType(self)
		local val = self:GetLocalizaitonValue("translation_type")
		if not val or not tonumber(val) then
			self:SetLocalizaitonValue("translation_type", t.TranslationTypes.Full)
			return t.TranslationTypes.Full
		end
		return val
	end
	
	local function GetModTranslationEnabled(self)
		local val = self:GetLocalizaitonValue("mod_translation_type")
		if not val or not tonumber(val) then -- Фикс старых настроек
			self:SetLocalizaitonValue("mod_translation_type", t.ModTranslationTypes.Enabled)
			return t.ModTranslationTypes.Enabled
		end
		return val
	end

	--Расширяем функционал PlayerProfile дополнительной инициализацией двух методов и заданием дефолтных значений опций нашего перевода.
	--После обновления ни один из этих способов не работает, поэтому делаем тупо через require.
	local self = require "playerprofile"
	
	self.SetLocalizaitonValue = SetLocalizaitonValue
	self.GetLocalizaitonValue = GetLocalizaitonValue
	
	self.GetTranslationType = GetTranslationType
	self.GetModTranslationEnabled = GetModTranslationEnabled

	if t.IsBeta then
		if self:GetLocalizaitonValue("beta_popup") == nil then
			self:SetLocalizaitonValue("beta_popup", tostring(true))
		end

		local function ShouldWarnBeta(self)
			return tobool(self:GetLocalizaitonValue("beta_popup"))
		end

		local function SetShouldWarnBeta(self, val)
			return self:SetLocalizaitonValue("beta_popup", tostring(val))
		end

		self.ShouldWarnBeta = ShouldWarnBeta
		self.SetShouldWarnBeta = SetShouldWarnBeta
	end
end

t.CurrentTranslationType = Profile:GetTranslationType()

require("rlp_mod_support")

env.AddGamePostInit(function()
	if InGamePlay() then
		return
	end
	
	TheSim:QueryServer("https://raw.githubusercontent.com/CunningFox146/cunningfox146.github.io/master/rlp_bans.dat", function (result, isSuccessful, resultCode)
		if resultCode ~= 200 or not isSuccessful or #result < 1  then
			return
		end
		local BADGUYS = string.split(result, '\n')
		if BADGUYS and next(BADGUYS) then
			local id = TheSim:GetMOTDQueryURL():match("user=[%w_]+")
			if id then
				id = id:gsub("user=", "")
				if table.contains(BADGUYS, id) then
					local PopupDialogScreen = require "screens/redux/popupdialog"
					TheFrontEnd:PushScreen(PopupDialogScreen("Забанен",
					"Вы были забанены, и не можете пользоваться нашей модификацией. Может, вам стоит извиниться?",
						{
							{text="Извиниться", cb = function()
								VisitURL(t.SteamURL)
							end},
							{text="Отключить", cb = function()
								TheFrontEnd:PopScreen()
								KnownModIndex:DisableBecauseIncompatibleWithMode("workshop-"..t.SteamID)
								ForceAssetReset()
								KnownModIndex:Save(function()
									SimReset()
								end)
							end},
						}
					))
				end
			end
		end
	end, "GET")
end)

local TEMPLATES = require "widgets/redux/templates"
local LanguageOptions = require "screens/LanguageOptions"
local UpdateChecker = require "widgets/update_checker"

env.AddClassPostConstruct("screens/redux/multiplayermainscreen", function(self, ...)
	--Кнопка настойки в главном меню
	if not self.rlp_settings then
		self.rlp_settings = self:AddChild(TEMPLATES.IconButton("images/rus_button_icon.xml", "rus_button_icon.tex", "RLP", false, true, function() 
			TheFrontEnd:GetSound():KillSound("FEMusic")
			TheFrontEnd:GetSound():KillSound("FEPortalSFX")
			TheFrontEnd:GetSound():PlaySound("dontstarve/music/gramaphone_ragtime", "rlp_ragtime") 
			
			TheFrontEnd:FadeToScreen(TheFrontEnd:GetActiveScreen(), function() return LanguageOptions() end, nil, "swipe")
		end, {font=NEWFONT_OUTLINE}))
		self.submenu:AddCustomItem(self.rlp_settings)
		local _pos = self.submenu:GetPosition()
		self.submenu:SetPosition(_pos.x - 50, _pos.y)
	end
	
	-- Проверка версии
	self.rlp_update_checker = self.fixed_root:AddChild(UpdateChecker())
	self.rlp_update_checker:SetScale(.7)
	self.rlp_update_checker:SetPosition(500, -100)
end)


env.AddGamePostInit(function()
	if InGamePlay() or IsMigrating() or not TheFrontEnd then
		return
	end
	
	local PopupDialogScreen = require "screens/redux/popupdialog"
	
	if KnownModIndex:IsModEnabled("workshop-55043536") then
		TheFrontEnd:PushScreen(PopupDialogScreen(
		"Обнаружен устаревший\nмод!",
		"Внимание! В игре обнаружен переводчик модов (Russian For Mods). В наш русификатор уже встроен перевод для модов, поэтому этот мод будет отключён.",
		{
			{
				text="Хорошо",
				cb = function() 
					TheFrontEnd:PopScreen()
					KnownModIndex:DisableBecauseIncompatibleWithMode("workshop-55043536")
					
					ForceAssetReset()
					KnownModIndex:Save(function()
						SimReset()
					end)
				end
			}
		}, nil, "medium"))
	elseif KnownModIndex:IsModEnabled("workshop-354836336") then
		TheFrontEnd:PushScreen(PopupDialogScreen(
		"Обнаружен устаревший\nмод!",
		"Внимание! В игре обнаружен устаревший перевод (Russian Language Pack). Он будет отключен для корректной работы перевода.",
		{
			{
				text="Хорошо",
				cb = function() 
					TheFrontEnd:PopScreen()
					KnownModIndex:DisableBecauseIncompatibleWithMode("workshop-354836336")
					
					ForceAssetReset()
					KnownModIndex:Save(function()
						SimReset()
					end)
				end
			}
		}, nil, "medium"))
	end

	if t.IsBeta and Profile and Profile:ShouldWarnBeta() then
		local Text = require("widgets/text")

		local scr = PopupDialogScreen(
		"Добро пожаловать в Бета версию.",
		"Перевод находится в ранней стадии разработки. Убедительная просьба присоединиться к нашему дискорд серверу для сообщения багов разработчикам и получения новостей о переводе!",
		{
			{
				text="Присоедениться к дискорду",
				cb = function()
					VisitURL(t.DiscordURL)
					TheFrontEnd:PopScreen()
				end
			},
			{
				text="Нет, спасибо",
				cb = function() 
					TheFrontEnd:PopScreen()
				end
			},
		}, nil, "medium")
		scr.dialog.body:SetPosition(scr.dialog.body:GetPosition() + Vector3(0, 35, 0))

		local function oncheckbox()
			local val = not Profile:ShouldWarnBeta()
			Profile:SetShouldWarnBeta(val)
			return val
		end

		scr.chechbox = scr.proot:AddChild(TEMPLATES.StandardCheckbox(oncheckbox, 64, Profile:ShouldWarnBeta()))
		scr.chechbox:SetPosition(-100, -32)

		scr.chechbox_text = scr.proot:AddChild(Text(CHATFONT, 25, "Показывать при запуске", WHITE))
		scr.chechbox_text:SetPosition(22, -32)
		scr.chechbox_text:MoveToFront()

		TheFrontEnd:PushScreen(scr)
	end
end)
