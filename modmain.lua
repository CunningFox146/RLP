_G = GLOBAL

_G.CHEATS_ENABLED = true

mods = _G.rawget(_G, "mods")
if not mods then
	mods = {}
	_G.rawset(_G, "mods", mods)
end
Assets = {
    _G.Asset( "IMAGE", "images/rus_button_icon.tex" ),
    _G.Asset( "ATLAS", "images/rus_button_icon.xml" ),

    _G.Asset( "IMAGE", "images/frontscreen.tex" ),
    _G.Asset( "ATLAS", "images/frontscreen.xml" ),
}
--Вставляем проверку на наличие старого русификатора.
local IS_ENABLED_OLD_RLP
if mods.RussianLanguagePack ~= nil and mods.RussianLanguagePack ~= {} or _G.KnownModIndex:IsModEnabled("workshop-354836336") or _G.KnownModIndex:IsModEnabled("workshop-1224043697") then
	IS_ENABLED_OLD_RLP = true
end

mods.RussianLanguagePack = {}
local t = mods.RussianLanguagePack

t.modinfo = modinfo
--Путь, по которому будут сохраняться рабочие версии po файла и лога обновлений.
--Он нужен потому, что сейчас при синхронизации стим затирает все файлы в папке мода на версии из стима.
t.StorePath = MODROOT--"scripts/languages/"

t.UpdateLogFileName = "updatelog.txt"
t.MainPOfilename = "DST.po"
t.ModsPOfilename = "MODS.po"
t.UpdatePeriod = {"OncePerLaunch", "OncePerDay", "OncePerWeek", "OncePerMonth", "Never"}
t.TranslationTypes = {Full = "Full", InterfaceChat = "InterfaceChat", ChatOnly = "ChatOnly"}
t.ModTranslationTypes = {enabled = "enabled", disabled = "disabled"}
t.CurrentTranslationType = nil
t.IsModTranslEnabled = nil
t.SteamURL = "http://steamcommunity.com/sharedfiles/filedetails/?id=1240565842"
t.SteamID = "1240565842"
t.SelectedLanguage = "ru"

t.DataFile = "scripts/rlp_data.json"--Сюда будем записывать разную инфу
--Склонения
t.AdjectiveCaseTags = {	nominative = "nom", --Именительный	Кто/что
						accusative = "acc", --Винительный	Кого/что
						dative = "dat",		--Дательный		Кому/чему
						ablative = "abl",	--Творительный	Кем/чем
						genitive = "gen",	--Родительный	Кого/чего
						vocative = "voc",	--Звательный
						locative = "loc",	--Предложный	О ком/о чём
						instrumental = "ins"}--unused
t.DefaultActionCase = "accusative"

--Для модов
t.announcerus = {
	mods = {}
}

io = _G.io
STRINGS = _G.STRINGS
tonumber = _G.tonumber
tostring = _G.tostring
assert = _G.assert
rawget = _G.rawget
require = _G.require
dumptable = _G.dumptable
GetPlayer = rawget(_G, "ThePlayer") and (function() return ThePlayer end) or _G.GetPlayer
TheSim = _G.TheSim

--Отключаем предупреждение о модах.
_G.getmetatable(TheSim).__index.ShouldWarnModsLoaded = function() 
	return false 
end

local FontNames = {
	DEFAULTFONT = _G.DEFAULTFONT,
	DIALOGFONT = _G.DIALOGFONT,
	TITLEFONT = _G.TITLEFONT,
	UIFONT = _G.UIFONT,
	BUTTONFONT = _G.BUTTONFONT,
	HEADERFONT = _G.HEADERFONT,
	CHATFONT = _G.CHATFONT,
	CHATFONT_OUTLINE = _G.CHATFONT_OUTLINE,
	NUMBERFONT = _G.NUMBERFONT,
	TALKINGFONT = _G.TALKINGFONT,
	SMALLNUMBERFONT = _G.SMALLNUMBERFONT,
	BODYTEXTFONT = _G.BODYTEXTFONT,
	NEWFONT = rawget(_G,"NEWFONT"),
	NEWFONT_SMALL = rawget(_G,"NEWFONT_SMALL"),
	NEWFONT_OUTLINE = rawget(_G,"NEWFONT_OUTLINE"),
	NEWFONT_OUTLINE_SMALL = rawget(_G,"NEWFONT_OUTLINE_SMALL")}

--В этой функции происходит загрузка, подключение и применение русских шрифтов
function ApplyLocalizedFonts()
	--Имена шрифтов, которые нужно загрузить.
	local LocalizedFontList = {["talkingfont"] = true,
							   ["stint-ucr50"] = true,
							   ["stint-ucr20"] = true,
							   ["opensans50"] = true,
							   ["belisaplumilla50"] = true,
							   ["belisaplumilla100"] = true,
							   ["buttonfont"] = true,
							   ["hammerhead50"] = true,
							   ["bellefair50"] = true,
							   ["bellefair_outline50"] = true,
							   ["spirequal"] = rawget(_G,"NEWFONT") and true or nil,
							   ["spirequal_small"] = rawget(_G,"NEWFONT_SMALL") and true or nil,
							   ["spirequal_outline"] = rawget(_G,"NEWFONT_OUTLINE") and true or nil,
							   ["spirequal_outline_small"] = rawget(_G,"NEWFONT_OUTLINE_SMALL") and true or nil}

	--ЭТАП ВЫГРУЗКИ: Вначале выгружаем шрифты, если они были загружены
	--Восстанавливаем оригинальные переменные шрифтов
	_G.DEFAULTFONT = FontNames.DEFAULTFONT
	_G.DIALOGFONT = FontNames.DIALOGFONT
	_G.TITLEFONT = FontNames.TITLEFONT
	_G.UIFONT = FontNames.UIFONT
	_G.BUTTONFONT = FontNames.BUTTONFONT
	_G.HEADERFONT = FontNames.HEADERFONT
	_G.CHATFONT = FontNames.CHATFONT
	_G.CHATFONT_OUTLINE = FontNames.CHATFONT_OUTLINE
	_G.NUMBERFONT = FontNames.NUMBERFONT
	_G.TALKINGFONT = FontNames.TALKINGFONT
	_G.SMALLNUMBERFONT = FontNames.SMALLNUMBERFONT
	_G.BODYTEXTFONT = FontNames.BODYTEXTFONT
	if rawget(_G,"NEWFONT") then
		_G.NEWFONT = FontNames.NEWFONT
	end
	if rawget(_G,"NEWFONT_SMALL") then
		_G.NEWFONT_SMALL = FontNames.NEWFONT_SMALL
	end
	if rawget(_G,"NEWFONT_OUTLINE") then
		_G.NEWFONT_OUTLINE = FontNames.NEWFONT_OUTLINE
	end
	if rawget(_G,"NEWFONT_OUTLINE_SMALL") then
		_G.NEWFONT_OUTLINE_SMALL = FontNames.NEWFONT_OUTLINE_SMALL
	end

	--Выгружаем локализированные шрифты, если они были до этого загружены
	for FontName in pairs(LocalizedFontList) do
		TheSim:UnloadFont(t.SelectedLanguage.."_"..FontName)
	end
	TheSim:UnloadPrefabs({t.SelectedLanguage.."_fonts_"..modname}) --выгружаем общий префаб локализированных шрифтов


	--ЭТАП ЗАГРУЗКИ: Загружаем шрифты по новой

	--Формируем список ассетов
	local LocalizedFontAssets = {}
	for FontName in pairs(LocalizedFontList) do 
		table.insert(LocalizedFontAssets, _G.Asset("FONT", MODROOT.."fonts/"..FontName.."__"..t.SelectedLanguage..".zip"))
	end

	--Создаём префаб, регистрируем его и загружаем
	local LocalizedFontsPrefab = _G.Prefab("common/"..t.SelectedLanguage.."_fonts_"..modname, nil, LocalizedFontAssets)
	_G.RegisterPrefabs(LocalizedFontsPrefab)
	TheSim:LoadPrefabs({t.SelectedLanguage.."_fonts_"..modname})

	--Формируем список связанных с файлами алиасов
	for FontName in pairs(LocalizedFontList) do
		TheSim:LoadFont(MODROOT.."fonts/"..FontName.."__"..t.SelectedLanguage..".zip", t.SelectedLanguage.."_"..FontName)
	end

	--Строим таблицу фоллбэков для последующей связи шрифтов с доп-шрифтами
	local fallbacks = {}
	for _, v in pairs(_G.FONTS) do
		local FontName = v.filename:sub(7, -5)
		if LocalizedFontList[FontName] then
			fallbacks[FontName] = {v.alias, _G.unpack(type(v.fallback) == "table" and v.fallback or {})}
		end
	end
	--Привязываем к новым английским шрифтам локализированные символы
	for FontName in pairs(LocalizedFontList) do
		TheSim:SetupFontFallbacks(t.SelectedLanguage.."_"..FontName, fallbacks[FontName])
	end

	--Вписываем в глобальные переменные шрифтов наши алиасы
	_G.DEFAULTFONT = t.SelectedLanguage.."_opensans50"
	_G.DIALOGFONT = t.SelectedLanguage.."_opensans50"
	_G.TITLEFONT = t.SelectedLanguage.."_belisaplumilla100"
	_G.UIFONT = t.SelectedLanguage.."_belisaplumilla50"
	_G.BUTTONFONT = t.SelectedLanguage.."_buttonfont"
	_G.HEADERFONT = t.SelectedLanguage.."_hammerhead50"
	_G.CHATFONT = t.SelectedLanguage.."_bellefair50"
	_G.CHATFONT_OUTLINE = t.SelectedLanguage.."_bellefair_outline50"
	_G.NUMBERFONT = t.SelectedLanguage.."_stint-ucr50"
	_G.TALKINGFONT = t.SelectedLanguage.."_talkingfont"
	_G.SMALLNUMBERFONT = t.SelectedLanguage.."_stint-ucr20"
	_G.BODYTEXTFONT = t.SelectedLanguage.."_stint-ucr50"
	if rawget(_G,"NEWFONT") then
		_G.NEWFONT = t.SelectedLanguage.."_spirequal"
	end
	if rawget(_G,"NEWFONT_SMALL") then
		_G.NEWFONT_SMALL = t.SelectedLanguage.."_spirequal_small"
	end
	if rawget(_G,"NEWFONT_OUTLINE") then
		_G.NEWFONT_OUTLINE = t.SelectedLanguage.."_spirequal_outline"
	end
	if rawget(_G,"NEWFONT_OUTLINE_SMALL") then
		_G.NEWFONT_OUTLINE_SMALL = t.SelectedLanguage.."_spirequal_outline_small"
	end
end

--Для тех, кто пользуется ps4 или NACL должна быть возможность сохранять не в ини файле, а в облаке.
--Для этого дорабатываем функционал стандартного класса PlayerProfile
local function SetLocalizaitonValue(self,name,value) --Метод, сохраняющий опцию с именем name и значением value
	local USE_SETTINGS_FILE = _G.PLATFORM ~= "PS4" and _G.PLATFORM ~= "NACL"
	if USE_SETTINGS_FILE then
		TheSim:SetSetting("translation", tostring(name), tostring(value))
	else
		self:SetValue(tostring(name), tostring(value))
		self.dirty = true
		self:Save() --Сохраняем сразу, поскольку у нас нет кнопки "применить"
	end
end
local function GetLocalizaitonValue(self,name) --Метод, возвращающий значение опции name
	local USE_SETTINGS_FILE = _G.PLATFORM ~= "PS4" and _G.PLATFORM ~= "NACL"
	if USE_SETTINGS_FILE then
		return TheSim:GetSetting("translation", tostring(name))
	else
		return self:GetValue(tostring(name))
	end
end

--Расширяем функционал PlayerProfile дополнительной инициализацией двух методов и заданием дефолтных значений опций нашего перевода.
--После обновления ни один из этих способов не работает, поэтому делаем тупо через require.

--AddGlobalClassPostConstruct("playerprofile", "PlayerProfile", function(self)
--AddClassPostConstruct("playerprofile", function(self)
do
	local self = require "playerprofile"
	
	local USE_SETTINGS_FILE = _G.PLATFORM ~= "PS4" and _G.PLATFORM ~= "NACL"
	
	if not USE_SETTINGS_FILE then
			self.persistdata.update_is_allowed = true --Разрешено запускать обновление по умолчанию
			self.persistdata.update_frequency = t.UpdatePeriod[3] --Раз в неделю по умолчанию
		local date=_G.os.date("*t")
		self.persistdata.last_update_date = tostring(date.day.."."..date.month.."."..date.year) --Текущая дата по умолчанию
	end
	
	self.SetLocalizaitonValue=SetLocalizaitonValue --метод задачи значения опции
	self.GetLocalizaitonValue=GetLocalizaitonValue --метод получения значения опции
end

function t.escapeR(str) --Удаляет \r из конца строки. Нужна для строк, загружаемых в юниксе.
	if string.sub(str, #str)=="\r" then return string.sub(str, 1, #str-1) else return str end
end

_G.getmetatable(TheSim).__index.UnregisterAllPrefabs = (function()
	local oldUnregisterAllPrefabs = _G.getmetatable(TheSim).__index.UnregisterAllPrefabs
	return function(self, ...)
		oldUnregisterAllPrefabs(self, ...)
		ApplyLocalizedFonts()
	end
end)()

--Вставляем функцию, подключающую русские шрифты
local OldRegisterPrefabs = _G.ModManager.RegisterPrefabs --Подменяем функцию,в которой нужно подгрузить шрифты и исправить глобальные шрифтовые константы
local function NewRegisterPrefabs(self)
	OldRegisterPrefabs(self)
	ApplyLocalizedFonts()
	_G.TheFrontEnd.consoletext:SetFont(_G.BODYTEXTFONT) --Нужно, чтобы шрифт в консоли не слетал
	_G.TheFrontEnd.consoletext:SetRegionSize(900, 404) --Чуть-чуть увеличил по вертикали, чтобы не обрезало буквы в нижней строке
end
_G.ModManager.RegisterPrefabs=NewRegisterPrefabs

--Узнаём тип локализации, и меняем содержимое таблицы с переводом PO, если нужно
--	t.CurrentTranslationType=_G.Profile:GetLocalizaitonValue("translation_type")
t.CurrentTranslationType = TheSim:GetSetting("translation", "translation_type")

if not t.CurrentTranslationType then --Если нет записи о типе, то делаем по умолчанию полный перевод
	t.CurrentTranslationType = t.TranslationTypes.Full
	TheSim:SetSetting("translation", "translation_type", t.CurrentTranslationType)
end

--То же для модов.
t.IsModTranslEnabled = TheSim:GetSetting("translation", "mod_translation_type")

if not t.IsModTranslEnabled then --Если нет записи о типе, то делаем по умолчанию полный перевод
	t.IsModTranslEnabled = t.ModTranslationTypes.enabled
	TheSim:SetSetting("translation", "mod_translation_type", t.IsModTranslEnabled)
end

require("RLP_support")

--Переопределяем функцию AddClassPostConstruct, чтобы она проверяла наличие файла и не падала при его отсутствии
local OldAddClassPostConstruct = AddClassPostConstruct
local function AddClassPostConstruct(path, ...)
	if not _G.kleifileexists("scripts/"..path..".lua") then
		print("RLP ERROR AddClassPostConstruct: file \""..path..".lua\" is not found. Skipping.")
		return
	end
	local res = OldAddClassPostConstruct(path, ...)
	return res
end


--!!! Временное исправление нерабочего русского языка в чате на выделенных серверах
AddClassPostConstruct("screens/chatinputscreen", function(self)
	if self.chat_edit then
		self.chat_edit:SetCharacterFilter(nil)
	end

end)

--[[--Увеличим область для текста в чате, чтобы не пропадали длинные русские буквы
AddClassPostConstruct("widgets/chatqueue", function(self)
	if self.messages and type(self.messages)=="table" and #self.messages>0 then
		for i,v in pairs(self.messages) do
			local w,h=v:GetRegionSize()
			v:SetRegionSize(w,h+2)
		end
	end
end)]]

--Добавление кнопки настроек меню модов при наведении на русский мод
--[[
local OldHasModConfigurationOptions = _G.KnownModIndex and _G.KnownModIndex.HasModConfigurationOptions
if OldHasModConfigurationOptions then
	function _G.KnownModIndex:HasModConfigurationOptions(modname, ...)
		local res = OldHasModConfigurationOptions(self,modname)
		if self:GetModInfo(modname).name==modinfo.name then return true end
		return res
	end
end

--Переопределяем действие кнопки
AddGlobalClassPostConstruct("screens/modsscreen", "ModsScreen", function(self)

	if self.detailwarning and self.CreateDetailPanel then
		self.detailwarning:SetSize(25)
		local OldCreateDetailPanel=self.CreateDetailPanel
		function self:CreateDetailPanel(...)
			OldCreateDetailPanel(self,...)
			self.detailwarning:SetSize(25)
		end
	end
	if not self.ConfigureSelectedMod then return end
	self.OldConfigureSelectedMod=self.ConfigureSelectedMod
	local function NewConfigureSelectedMod(self)
		if _G.KnownModIndex:GetModInfo(self.currentmodname).name==modinfo.name then
			local LanguageOptions = require "screens/LanguageOptions"
			_G.TheFrontEnd:PushScreen(LanguageOptions())
		else
			self:OldConfigureSelectedMod()
		end
	end
	self.ConfigureSelectedMod=NewConfigureSelectedMod
end)
]]

--Кнопка настойки в главном меню
do
	--local RLPButton = require "widgets/rlp_button"
	local TEMPLATES = require "widgets/redux/templates"
	local LanguageOptions = require "screens/LanguageOptions"

	local function AddButton(self, ...)
		if self.rlp_settings == nil then
			local TheFrontEnd = _G.TheFrontEnd

			self.rlp_settings = self:AddChild(TEMPLATES.IconButton("images/rus_button_icon.xml", "rus_button.tex", "RLP", false, true, function() 

				TheFrontEnd:GetSound():KillSound("FEMusic")
				TheFrontEnd:GetSound():KillSound("FEPortalSFX")
				TheFrontEnd:GetSound():PlaySound("dontstarve/music/gramaphone_ragtime", "rlp_ragtime") 
				
				TheFrontEnd:FadeToScreen(TheFrontEnd:GetActiveScreen(), function() return LanguageOptions() end, nil, "swipe")
			end, {font=_G.NEWFONT_OUTLINE}))
			self.submenu:AddCustomItem(self.rlp_settings--[[, _G.Vector3(-530,0,0)]])
		end
	end

	--AddClassPostConstruct("screens/multiplayermainscreen", AddButton)
	AddClassPostConstruct("screens/redux/multiplayermainscreen", AddButton)
end

--Исправление бага с шрифтом в спиннерах
AddClassPostConstruct("widgets/spinner", function(self, options, width, height, textinfo, ...) --Выполняем подмену шрифта в спиннере из-за глупой ошибки разрабов в этом виджете
	if textinfo then return end
	
	self.text:SetFont(_G.BUTTONFONT)
	--Насильно заменяем
	--[[
	if self.text.string == nil then return end
	print(self.text.string)
	if self.text.string == "Disabled" then
		self.text:SetString("Отключено")
	end
	
	if self.text.string == "Enabled" then
		self.text:SetString("Включено")
	end
	]]
end)

local function GetPoFileVersion(file) --Возвращает версию po файла
	local f = assert(io.open(file,"r"))
	local ver=nil
	for line in f:lines() do
		ver = string.match(t.escapeR(line),"#%s+Версия%s+(.+)%s*$")
		if ver then break end
	end
	f:close()
	if not ver then ver = "не задана" end
	return ver
end
--[[
--Проверяем версию по файла, и если она не соответствует текущей версии, то отключаем перевод
local poversion = GetPoFileVersion(t.StorePath..t.MainPOfilename)
if poversion~=modinfo.version then
	local OldStart = _G.Start --Переопределяем функцию, после выполнения которой можно будет вывести попап.
	function _G.Start() 
		ApplyLocalizedFonts()
		OldStart()
		local a,b="/","\\"
		if _G.PLATFORM == "NACL" or _G.PLATFORM == "PS4" or _G.PLATFORM == "LINUX_STEAM" or _G.PLATFORM == "OSX_STEAM" then
			a,b=b,a
		end
		local text="Версия игры: "..modinfo.version..", версия PO файла: "..poversion.."\nПуть: "..string.gsub(_G.CWD..t.StorePath,a,b)..t.MainPOfilename.."\nПеревод работает в режиме «Только чат»."
		local PopupDialogScreen = require "screens/popupdialog"
			_G.TheFrontEnd:PushScreen(PopupDialogScreen("Неверная версия PO файла", text,
			{{text="Понятно", cb = function() _G.TheFrontEnd:PopScreen() end}},nil,nil,"dark"))
	end
	return
end
]]
--Проверяем наличие мода-переводчика модов. Если включен, то отключаем.


--Перед загрузкой делаем проверку
do
	if IS_ENABLED_OLD_RLP then
		local OldStart=_G.Start --Переопределяем функцию, после выполнения которой можно будет вывести попап и перезагрузиться
		function _G.Start() 
			ApplyLocalizedFonts()
			OldStart()
			
			local a,b="/","\\"
			if _G.PLATFORM == "NACL" or _G.PLATFORM == "PS4" or _G.PLATFORM == "LINUX_STEAM" or _G.PLATFORM == "OSX_STEAM" then
				a,b=b,a
			end
			
			local text="Внимание! Обнаружена устаревшая русификация (Russian Language Pack). В игре может работать только однин русификатор, поэтому она будет отключена."
			local PopupDialogScreen = require "screens/popupdialog"
				_G.TheFrontEnd:PushScreen(PopupDialogScreen("Обнаружена устаревшая \nрусификация!", text,
				{{text="Хорошо.", cb = function() 
						_G.TheFrontEnd:PopScreen() 
						--Отрубаем.
						_G.KnownModIndex:DisableBecauseIncompatibleWithMode("workshop-354836336")
						_G.KnownModIndex:DisableBecauseIncompatibleWithMode("workshop-1224043697")
						
						_G.ForceAssetReset()
						_G.KnownModIndex:Save(function()
							_G.SimReset()
						end)
					end
					}},nil,nil,"dark"))
					
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") 
			print("!!!!!!!!!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!!!!!") 
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") 
			print("!FOUND OLD RUSSIAN LANGUAGE PACK!") 
			print("!!!!!!!!!!!!!DISABLEING MOD...!!!!!!!!!!!!!!") 
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!") 
		end
	end
	
	--У нас уже встроен перевод модов.
	if (mods.RusMods ~= nil or _G.KnownModIndex:IsModEnabled("workshop-55043536")) and _G.TheWorld == nil then
		local OldStart=_G.Start
		function _G.Start() 
			ApplyLocalizedFonts()
			OldStart()
			
			local text="Внимание! В игре обнаружен переводчик модов (Russian For Mods). В наш русификатор уже встроен перевод для модов, поэтому мод (Russian For Mods) будет отключён."
			local PopupDialogScreen = require "screens/popupdialog"
				_G.TheFrontEnd:PushScreen(PopupDialogScreen("Обнаружена устаревшая \nрусификация!", text,
				{{text="Хорошо.", cb = function() 
						_G.TheFrontEnd:PopScreen() 
						--Отрубаем.
						_G.KnownModIndex:DisableBecauseIncompatibleWithMode("workshop-55043536")
						
						_G.ForceAssetReset()
						_G.KnownModIndex:Save(function()
							_G.SimReset()
						end)
					end
					}},nil,nil,"dark"))
		end
	end
	
	local OldStart=_G.Start
	function _G.Start() 
		ApplyLocalizedFonts()
		OldStart()
			if _G.TheFrontEnd ~= nil and _G.TheFrontEnd:GetGraphicsOptions():IsSmallTexturesMode() and _G.TheWorld == nil then -- Не запускаем в игре. Только в лобби
			
			local PopupDialogScreen = require "screens/ErrorPopup"
				_G.TheFrontEnd:PushScreen(PopupDialogScreen(
				{{text="Ok.", cb = function() 
					_G.TheFrontEnd:PopScreen() 
				end}}))
		end
	end
end

--Функция проверяет файл language.lua на наличие подключения po файла и старых версий русификации
function language_lua_has_rusification(filename)
	if not _G.kleifileexists(filename) then return false end --Нет файла? Нет проблем


	local f = assert(io.open(filename,"r")) --Читаем весь файл в буфер
	local content =""
	for line in f:lines() do
		content=content..line
	end
	f:close()

	content=string.gsub(content,"\r","")--Удаляем все возвраты каретки, на случай, если это юникс
	content=string.gsub(content,"%-%-%[%[.-%]%]","")--Удаляем многострочные комментарии
	if string.sub(content,#content)~="\n" then content=content.."\n" end --добавляем перенос строки в самом конце, если нужно
	local tocomment={}
	for str in string.gmatch(content,"([^\n]*)\n") do --Обходим все строки
		if not str then str="" end
		str=string.gsub(str,"%-%-.*$","")--Удаляем все однострочные комментарии
		--Запоминаем строки, которые нужно отключить
		if string.find(str,"LanguageTranslator:LoadPOFile(",1,true) then table.insert(tocomment,str) end --загрузка po
		if string.find(str,"russian_fix",1,true) then table.insert(tocomment,str) end --загрузка моей ранней версии русификации
	end
	if #tocomment==0 then return false end --Если не нашлось строк, которые нужно закомментировать, то выходим

	content={}
	local f=assert(io.open(filename,"r"))
	for line in f:lines() do --Снова считываем все строки, параллельно проверяя
		for _,str in ipairs(tocomment) do --обходим все строки, которые нужно закомментировать
			local a,b=string.find(line,str,1,true)
			if a then --если есть совпадение то...
				line=string.sub(line,1,a-1).."--"..str..string.sub(line,b+1)
				break --комментируем и прерываем цикл
			end
		end
		table.insert(content,line)
	end
	f:close()
	f = assert(io.open(filename,"w")) --Формируем новый language.lua с отключёнными строками
	for _,str in ipairs(content) do
		f:write(str.."\n")
	end
	f:close()
	return true
end


local languageluapath ="scripts/languages/language.lua"

if language_lua_has_rusification(languageluapath) then --Если в language.lua подключается русификация
	local OldStart=_G.Start --Переопределяем функцию, после выполнения которой можно будет вывести попап и перезагрузиться
	function _G.Start() 
		ApplyLocalizedFonts()
		OldStart()
		local a,b="/","\\"
		if _G.PLATFORM == "NACL" or _G.PLATFORM == "PS4" or _G.PLATFORM == "LINUX_STEAM" or _G.PLATFORM == "OSX_STEAM" then
			a,b=b,a
		end
		local text="В файле "..string.gsub("data/"..languageluapath,a,b).."\nнайдено подключение другой локализации.\nЭто подключение было деактивировано."
		local PopupDialogScreen = require "screens/popupdialog"
			_G.TheFrontEnd:PushScreen(PopupDialogScreen("Обнаружена посторонняя локализация", text,
			
			{{text="Понятно", cb = function() _G.TheFrontEnd:PopScreen() _G.SimReset() end}},nil,nil,"dark"))
	end
end



local OldStart = _G.Start --
function _G.Start() 
	ApplyLocalizedFonts()
	OldStart()
end



PrefabFiles = {
	"russian_assets"
}

modimport("scripts/ver_checker.lua")

if t.CurrentTranslationType==t.TranslationTypes.ChatOnly then
	return
end












--!!!!!!!! ТУТ ПРЕРЫВАЕТСЯ ВЫПОЛНЕНИЕ МОДА, ЕСЛИ ТЕКУЩИЙ РЕЖИМ РУСИФИКАЦИИ - ТОЛЬКО ЧАТ!!!!!!!!!!!!!













--[[
Assets = {
	Asset("ATLAS","images/gradient.xml"), --Градиент на слишком длинных строках лога в настройках перевода
	Asset("ATLAS","images/rus_mapgen.xml"), --Русифицированные пиктограммы в окне генерирования нового мира
	--Персонажи
	Asset("ATLAS","images/rus_locked.xml"), 
	Asset("ATLAS","images/rus_wickerbottom.xml"), 
	Asset("ATLAS","images/rus_waxwell.xml"), 
	Asset("ATLAS","images/rus_willow.xml"), 
	Asset("ATLAS","images/rus_wilson.xml"), 
	Asset("ATLAS","images/rus_woodie.xml"), 
	Asset("ATLAS","images/rus_wes.xml"), 
	Asset("ATLAS","images/rus_wolfgang.xml"), 
	Asset("ATLAS","images/rus_wendy.xml"),
	Asset("ATLAS","images/rus_wathgrithr.xml"),
	Asset("ATLAS","images/rus_webber.xml"),
	Asset("ATLAS","images/rus_random.xml"),

	Asset("ATLAS","images/rus_names_wickerbottom.xml"), 
	Asset("ATLAS","images/rus_names_willow.xml"), 
	Asset("ATLAS","images/rus_names_wilson.xml"), 
	Asset("ATLAS","images/rus_names_woodie.xml"), 
	Asset("ATLAS","images/rus_names_wes.xml"), 
	Asset("ATLAS","images/rus_names_wolfgang.xml"), 
	Asset("ATLAS","images/rus_names_wendy.xml"),
	Asset("ATLAS","images/rus_names_wathgrithr.xml"),
	Asset("ATLAS","images/rus_names_webber.xml"),
	Asset("ATLAS","images/rus_names_waxwell.xml"),
	Asset("ATLAS","images/rus_names_random.xml"),
}
]]



--Возвращает корректную форму слова день (или другого, переданного вторым параметром)
local function StringTime(n,s)
	local pl_type=n%10==1 and n%100~=11 and 1 or(n%10>=2 and n%10<=4
			and(n%100<10 or n%100>=20)and 2 or 3)
	s=s or {"день","дня","дней"}
	return s[pl_type]
end 



--Пытается сформировать правильные окончания в словах названия предмета str1 в соответствии действию action
--objectname - название префаба предмета
function rebuildname(str1,action,objectname)
	local function repsubstr(str,pos,substr)--вставить подстроку substr в строку str в позиции pos
		pos=pos-1
		return str:utf8sub(1,pos)..substr..str:utf8sub(pos+substr:utf8len()+1,str:utf8len())
	end
	if not str1 then
		return nil
	end
	local 	sogl=  {['б']=1,['в']=1,['г']=1,['д']=1,['ж']=1,['з']=1,['к']=1,['л']=1,['м']=1,['н']=1,['п']=1,
			['р']=1,['с']=1,['т']=1,['ф']=1,['х']=1,['ц']=1,['ч']=1,['ш']=1,['щ']=1}

	local sogl2 = {['г']=1,['ж']=1,['к']=1,['х']=1,['ц']=1,['ч']=1,['ш']=1,['щ']=1}
	local sogl3 = {["р"]=1,["л"]=1,["к"]=1,["Р"]=1,["Л"]=1,["К"]=1}

	local resstr=""
	local delimetr
	local wasnoun=false
	local wordcount=#(str1:gsub("[%s-]","~"):split("~"))
	local counter=0
	local FoundNoun
	local str=""
	str1=str1.." "
	local str1len=str1:utf8len()
	for i=1,str1len do
		delimetr=str1:utf8sub(i,i)
		if delimetr~=" " and delimetr~="-" then
			str=str..delimetr
		elseif #str>0 and (delimetr==" " or delimetr=="-") then
			counter=counter+1
			if action=="KILL" and objectname and str:utf8len()>2 then -- был убит (кем? чем?) Творительный
				--Особый случай, в objectname передаём имя префаба для более точного анализа его пола
				--Действие "KILL" не генерируется игрой, а используется только в этом моде для формирования сообщений о смерти в DST
				local function testnoun()
					if t.NamesGender["she"][string.lower(objectname)] then --женский род
						if str:utf8sub(str:utf8len()-1)=="ца" or str:utf8sub(str:utf8len()-1)=="ча" or str:utf8sub(str:utf8len()-1)=="ша" then
							str=repsubstr(str,str:utf8len(),"ей") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len())=="а" then
							str=repsubstr(str,str:utf8len(),"ой") FoundNoun=delimetr~="-"
						elseif str:utf8sub(-4)=="роня" then
							str=repsubstr(str,str:utf8len(),"ёй") FoundNoun=delimetr~="-"
						elseif str:utf8sub(-3)=="мля" then
							str=repsubstr(str,str:utf8len(),"ёй") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len())=="я" and str:utf8len()>3 then
							str=repsubstr(str,str:utf8len(),"ей") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len())=="ь" then
							str=str.."ю" FoundNoun=delimetr~="-"
						end
					elseif t.NamesGender["it"][string.lower(objectname)] then --средний род
						if str:utf8sub(-1)~="и" then
							str=str.."м" FoundNoun=delimetr~="-"
						end
					elseif t.NamesGender["plural"][string.lower(objectname)] or 
						   t.NamesGender["plural2"][string.lower(objectname)] then --множественное число
						if str:utf8sub(str:utf8len())=="а" or str:utf8sub(str:utf8len())=="ы" then
							str=repsubstr(str,str:utf8len(),"ами") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len())=="я" then
							str=repsubstr(str,str:utf8len(),"ями") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len())=="и" then
							if sogl2[str:utf8sub(str:utf8len()-1,str:utf8len()-1)] then
								str=repsubstr(str,str:utf8len(),"ами") FoundNoun=delimetr~="-"
							else 
								str=repsubstr(str,str:utf8len(),"ями") FoundNoun=delimetr~="-"
							end
						end
					else --мужской род
						if str:utf8sub(-3,-3)=="о" and str:utf8sub(str:utf8len())=="ь" and not sogl3[str:utf8sub(-4,-4) or "р"] then
							str=str:utf8sub(1,-4)..str:utf8sub(-2,-2).."ём" FoundNoun=delimetr~="-" 
						elseif str:utf8sub(str:utf8len()-1)=="ок" then
							str=repsubstr(str,str:utf8len()-1,"ком") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-2)=="чек" then
							str=repsubstr(str,str:utf8len()-1,"ком") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-1)=="ец" then
							str=repsubstr(str,str:utf8len()-1,"цем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-2)=="ень" then
							str=repsubstr(str,str:utf8len()-2,"нем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-1)=="дь" then
							str=repsubstr(str,str:utf8len(),"ем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-2)=="арь" then
							str=repsubstr(str,str:utf8len(),"ём") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-1)=="рь" then
							str=repsubstr(str,str:utf8len(),"ем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-1)=="ёр" then
							str=repsubstr(str,str:utf8len()-1,"ром") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-1)=="уй" then
							str=repsubstr(str,str:utf8len(),"ем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-1)=="ай" then
							str=repsubstr(str,str:utf8len(),"ем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-2)=="лей" then --улей
							str=repsubstr(str,str:utf8len()-1,"ьем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-2)=="йль" then
							str=repsubstr(str,str:utf8len(),"ем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-2)=="ель" then
							str=repsubstr(str,str:utf8len(),"ем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len()-2)=="ень" then
							str=repsubstr(str,str:utf8len(),"ем") FoundNoun=delimetr~="-"
						elseif str:utf8sub(str:utf8len())=="ь" then
							str=repsubstr(str,str:utf8len(),"ём") FoundNoun=delimetr~="-"
						elseif sogl[str:utf8sub(-1)] then
							str=str.."ом" FoundNoun=delimetr~="-"
						end
					end
				end
				if counter~=wordcount and str:utf8len()>3 then --Если это не последнее слово, то это может быть прилагательное
					if t.NamesGender["she"][string.lower(objectname)] then --женский род
						if str:utf8sub(str:utf8len()-1)=="ая" then
							str=repsubstr(str,str:utf8len()-1,"ой")
						elseif str:utf8sub(str:utf8len()-1)=="яя" then
							str=repsubstr(str,str:utf8len()-1,"ей")
						elseif str:utf8sub(str:utf8len()-1)=="ья" then
							str=repsubstr(str,str:utf8len(),"ей")
						elseif str:utf8sub(-4)=="аяся" then
							str=repsubstr(str,str:utf8len()-3,"ейся")
						elseif not  FoundNoun then testnoun() end
					elseif t.NamesGender["it"][string.lower(objectname)] then --средний род
						if str:utf8sub(str:utf8len()-2)=="кое" then
							str=repsubstr(str,str:utf8len()-1,"им")
						elseif str:utf8sub(str:utf8len()-1)=="ое" then
							str=repsubstr(str,str:utf8len()-1,"ым")
						elseif str:utf8sub(str:utf8len()-1)=="ее" then
							str=repsubstr(str,str:utf8len()-1,"им")
						elseif not  FoundNoun then testnoun() end
					elseif t.NamesGender["plural"][string.lower(objectname)] or 
						   t.NamesGender["plural2"][string.lower(objectname)] then --множественное число
						if str:utf8sub(str:utf8len()-1)=="ые" then
							str=repsubstr(str,str:utf8len()-1,"ыми")
						elseif str:utf8sub(str:utf8len()-1)=="ие" then
							str=repsubstr(str,str:utf8len()-1,"ими")
						elseif str:utf8sub(str:utf8len()-1)=="ьи" then
							str=repsubstr(str,str:utf8len()-1,"ими")
						elseif not  FoundNoun then testnoun() end
					else --мужской род
						if str:utf8sub(str:utf8len()-1)=="ый" then
							str=repsubstr(str,str:utf8len()-1,"ым")
						elseif str:utf8sub(str:utf8len()-1)=="ий" then
							str=repsubstr(str,str:utf8len()-1,"им")
						elseif str:utf8sub(str:utf8len()-1)=="ой" then
							str=repsubstr(str,str:utf8len()-1,"ым")
						elseif not  FoundNoun then testnoun() end
					end
				else
					if not  FoundNoun then testnoun() end
				end			
			elseif action=="WALKTO" then --идти к (кому? чему?) Дательный
				if str:utf8sub(str:utf8len()-1)=="ая" and resstr=="" then
					str=repsubstr(str,str:utf8len()-1,"ой")
				elseif str:utf8sub(str:utf8len()-1)=="ая" then
					str=repsubstr(str,str:utf8len()-1,"ей")
				elseif str:utf8sub(str:utf8len()-1)=="ей" then
					str=repsubstr(str,str:utf8len()-1,"ью")
				elseif str:utf8sub(str:utf8len()-1)=="яя" then
					str=repsubstr(str,str:utf8len()-1,"ей")
				elseif str:utf8sub(str:utf8len()-1)=="ец" then
					str=repsubstr(str,str:utf8len()-1,"цу")
				elseif str:utf8sub(str:utf8len()-1)=="ый" then
					str=repsubstr(str,str:utf8len()-1,"ому")
				elseif str:utf8sub(str:utf8len()-1)=="ий" then
					str=repsubstr(str,str:utf8len()-1,"ему")
				elseif str:utf8sub(str:utf8len()-1)=="ое" then
					str=repsubstr(str,str:utf8len()-1,"ому")
				elseif str:utf8sub(str:utf8len()-1)=="ее" then
					str=repsubstr(str,str:utf8len()-1,"ему")
				elseif str:utf8sub(str:utf8len()-1)=="ые" then
					str=repsubstr(str,str:utf8len()-1,"ым")
				elseif str:utf8sub(str:utf8len()-1)=="ой" and resstr=="" then
					str=repsubstr(str,str:utf8len()-1,"ому")
				elseif str:utf8sub(str:utf8len()-1)=="ья" and resstr=="" then
					str=repsubstr(str,str:utf8len()-1,"ьей")
				elseif str:utf8sub(str:utf8len()-2)=="орь" then
					str=str:utf8sub(1,str:utf8len()-3).."рю"
				elseif str:utf8sub(str:utf8len()-1)=="ек" then
					str=str:utf8sub(1,str:utf8len()-2).."ку"
					wasnoun=true
				elseif str:utf8sub(str:utf8len()-2)=="ень" then
					str=str:utf8sub(1,str:utf8len()-3).."ню"
				elseif str:utf8sub(str:utf8len()-1)=="ок" then
					str=repsubstr(str,str:utf8len()-1,"ку")
					wasnoun=true
				elseif str:utf8sub(str:utf8len()-1)=="ть" then
					str=repsubstr(str,str:utf8len(),"и")
					wasnoun=true
				elseif str:utf8sub(str:utf8len()-1)=="вь" then
					str=repsubstr(str,str:utf8len(),"и")
					wasnoun=true
				elseif str:utf8sub(str:utf8len()-1)=="ль" then
					str=repsubstr(str,str:utf8len(),"и")
					wasnoun=true
				elseif str:utf8sub(str:utf8len()-1)=="зь" then
					str=repsubstr(str,str:utf8len(),"и")
					wasnoun=true
				elseif str:utf8sub(str:utf8len()-1)=="нь" then
					str=repsubstr(str,str:utf8len(),"ю")
					wasnoun=true
				elseif str:utf8sub(str:utf8len()-1)=="рь" then
					str=repsubstr(str,str:utf8len(),"ю")
					wasnoun=true
				elseif str:utf8sub(str:utf8len()-1)=="ьи" then
					str=str.."м"
				elseif str:utf8sub(str:utf8len()-1)=="ки" and not wasnoun then
					str=repsubstr(str,str:utf8len(),"ам")
					wasnoun=true
				elseif str:utf8sub(str:utf8len())=="ы" and not wasnoun then
					str=repsubstr(str,str:utf8len(),"ам")
					wasnoun=true
				elseif str:utf8sub(str:utf8len())=="ы" and not wasnoun then
					str=repsubstr(str,str:utf8len(),"ам")
					wasnoun=true
				elseif str:utf8sub(str:utf8len())=="а" and not wasnoun then
					str=repsubstr(str,str:utf8len(),"е")
					wasnoun=true
				elseif str:utf8sub(str:utf8len())=="я" and not wasnoun then
					str=repsubstr(str,str:utf8len(),"е")
					wasnoun=true
				elseif str:utf8sub(str:utf8len())=="о" and not wasnoun then
					str=repsubstr(str,str:utf8len(),"у")
					wasnoun=true
				elseif str:utf8sub(str:utf8len()-1)=="це" and not wasnoun then
					str=repsubstr(str,str:utf8len()-1,"цу")
					wasnoun=true
				elseif str:utf8sub(str:utf8len())=="е" and not wasnoun then
					str=repsubstr(str,str:utf8len(),"ю")
					wasnoun=true
				elseif sogl[str:utf8sub(str:utf8len())] and not wasnoun then
					str=str.."у"
					wasnoun=true
				end
			-- (Кого? Чего?) Родительный
			elseif action=="reskin" and str:utf8len()>3 then
				if str=="Стол" then
					str=str.."а"
				elseif counter==wordcount then
					if str:utf8sub(str:utf8len()-1)=="ьё" then
						str=repsubstr(str,str:utf8len()-1,"ья")
					elseif str:utf8sub(str:utf8len())=="я" then
						str=repsubstr(str,str:utf8len(),"и")
					elseif str:utf8sub(str:utf8len()-1)=="на" then
						str=repsubstr(str,str:utf8len(),"ы")
					elseif str:utf8sub(str:utf8len()-1)=="ль" then
						str=repsubstr(str,str:utf8len(),"я")
					elseif str:utf8sub(str:utf8len())=="ь" then
						str=repsubstr(str,str:utf8len(),"и")
					elseif str:utf8sub(str:utf8len()-1)=="ок" then
						str=repsubstr(str,str:utf8len()-1,"ка")
					elseif str:utf8sub(str:utf8len()-1)=="ка" then
						str=repsubstr(str,str:utf8len()-1,"ки")
					elseif str:utf8sub(str:utf8len()-1)=="та" then
						str=repsubstr(str,str:utf8len()-1,"ты")
					elseif str:utf8sub(str:utf8len()-1)=="ая" then
						str=repsubstr(str,str:utf8len()-1,"ой")
					elseif str:utf8sub(str:utf8len()-1)=="ло" then
						str=repsubstr(str,str:utf8len()-1,"ла")
					elseif str:utf8sub(str:utf8len()-1)=="ол" then
						str=repsubstr(str,str:utf8len()-1,"ола")
					elseif str:utf8sub(str:utf8len()-1)=="ом" then
						str=repsubstr(str,str:utf8len()-1,"ома")
					elseif str:utf8sub(str:utf8len()-2)=="нец" then
						str=repsubstr(str,str:utf8len()-2,"нец")
					elseif str:utf8sub(str:utf8len()-2)=="ий" then
						str=repsubstr(str,str:utf8len()-2,"ого")
					elseif str:utf8sub(str:utf8len()-1)=="ья" then
						str=repsubstr(str,str:utf8len()-1,"ьей")
					elseif str:utf8sub(str:utf8len()-1)=="па" then
						str=repsubstr(str,str:utf8len()-1,"пы")
					elseif str:utf8sub(str:utf8len()-1)=="ще" then
						str=repsubstr(str,str:utf8len()-1,"ща")
					elseif str:utf8sub(str:utf8len()-1)=="це" then
						str=repsubstr(str,str:utf8len()-1,"ца")
					elseif sogl[str:utf8sub(str:utf8len())] then
						str=str.."а"
					end
				else
					if t.NamesGender["she"][string.lower(objectname)] then --женский род
						if str:utf8sub(str:utf8len()-1)=="ая" then
							str=repsubstr(str,str:utf8len()-1,"ой")
						elseif str:utf8sub(str:utf8len()-1)=="яя" then
							str=repsubstr(str,str:utf8len()-1,"ей")
						elseif str:utf8sub(str:utf8len()-1)=="ья" then
							str=repsubstr(str,str:utf8len(),"ей")
						elseif str:utf8sub(-4)=="аяся" then
							str=repsubstr(str,str:utf8len()-3,"ейся")
						end
					elseif t.NamesGender["it"][string.lower(objectname)] then --средний род
						if str:utf8sub(str:utf8len()-2)=="кое" then
							str=repsubstr(str,str:utf8len()-1,"ого")
						elseif str:utf8sub(str:utf8len()-1)=="ое" then
							str=repsubstr(str,str:utf8len()-1,"ого")
						elseif str:utf8sub(str:utf8len()-1)=="ее" then
							str=repsubstr(str,str:utf8len()-1,"его")
						end
					elseif t.NamesGender["plural"][string.lower(objectname)] or 
						   t.NamesGender["plural2"][string.lower(objectname)] then --множественное число
						if str:utf8sub(str:utf8len()-1)=="ые" then
							str=repsubstr(str,str:utf8len()-1,"ых")
						elseif str:utf8sub(str:utf8len()-1)=="ие" then
							str=repsubstr(str,str:utf8len()-1,"их")
						elseif str:utf8sub(str:utf8len()-1)=="ьи" then
							str=repsubstr(str,str:utf8len()-1,"их")
						end
					elseif t.NamesGender["he"][string.lower(objectname)] or t.NamesGender["he2"][string.lower(objectname)] then--мужской род
						if str:utf8sub(str:utf8len()-1)=="ый" then
							str=repsubstr(str,str:utf8len()-1,"ого")
						elseif str:utf8sub(str:utf8len()-1)=="ий" then
							str=repsubstr(str,str:utf8len()-1,"его")
						elseif str:utf8sub(str:utf8len()-1)=="ой" then
							str=repsubstr(str,str:utf8len()-1,"ого")
						end
					end
				end
			--Изучить (Кого? Что?) Винительный
			--применительно к имени свиньи или кролика
			elseif action and objectname and (objectname=="pigman" or objectname=="pigguard" or objectname=="bunnyman" or objectname:find("critter")~=nil) then 
				if str:utf8sub(str:utf8len()-2)=="нок" then
					str=str:utf8sub(1,str:utf8len()-2).."ка"
				elseif str:utf8sub(str:utf8len()-2)=="лец" then
					str=str:utf8sub(1,str:utf8len()-2).."ьца"
				elseif str:utf8sub(str:utf8len()-2)=="ный" then
					str=str:utf8sub(1,str:utf8len()-2).."ого"
				elseif str:utf8sub(str:utf8len()-1)=="ец" then
					str=str:utf8sub(1,str:utf8len()-2).."ца"
				elseif str:utf8sub(str:utf8len())=="а" then
					str=str:utf8sub(1,str:utf8len()-1).."у"
				elseif str:utf8sub(str:utf8len())=="я" then
					str=str:utf8sub(1,str:utf8len()-1).."ю"
				elseif str:utf8sub(str:utf8len())=="ь" then
					str=str:utf8sub(1,str:utf8len()-1).."я"
				elseif str:utf8sub(str:utf8len())=="й" then
					str=str:utf8sub(1,str:utf8len()-1).."я"
				elseif sogl[str:utf8sub(str:utf8len())] then
					str=str.."а"
				end
			elseif action and not(objectname and objectname=="sketch") then --Изучить (Кого? Что?) Винительный
				if str:utf8sub(str:utf8len()-1)=="ая" then
					str=repsubstr(str,str:utf8len()-1,"ую")
				elseif str:utf8sub(str:utf8len()-1)=="яя" then
					str=repsubstr(str,str:utf8len()-1,"юю")
				elseif str:utf8sub(str:utf8len())=="а" then
					str=repsubstr(str,str:utf8len(),"у")
				elseif str:utf8sub(str:utf8len())=="я" then
					str=repsubstr(str,str:utf8len(),"ю")
				end
			end
			resstr=resstr..str..delimetr
			str=""		
		end
	end
	resstr=resstr:utf8sub(1,resstr:utf8len()-1)
	return resstr
end
t.rebuildname = rebuildname


_G.testname=function(name,key)
	if name and (not key) and type(name)=="string" and rawget(STRINGS.NAMES,name:upper()) then key=name:upper() name=STRINGS.NAMES[key] end
	print("Идти к "..rebuildname(name,"WALKTO", key))
	print("Осмотреть "..rebuildname(name,"DEFAULTACTION", key))
	if key then
		print("Был убит "..rebuildname(name,"KILL",key))
	end
	print("Сменить скин у "..rebuildname(name,"reskin", key))
end

--Сохраняет в файле fn все имена с действием, указанным в параметре action)
local function printnames(fn,action,openfn)
	local filename = MODROOT..fn..".txt"
	local str1,str2
	local names={}
	local f=assert(io.open(MODROOT..(openfn or "names_new.txt"),"r"))
	for line in f:lines() do
		str1=string.match(line,"[.\t]([^.\t]*)$")
		str2=STRINGS.NAMES[str1]
		if not (t.RussianNames[str2] and t.RussianNames[str2]["KILL"]) then
			local s1
			if action=="DEFAULTACTION" then
				s1="Изучить "
			elseif action=="WALKTO" then
				s1="Идти к "
			elseif action=="KILL" then
				s1="Он был убит "
			end
			s1=s1..rebuildname(str2,action,str1:lower())
			local name=s1
			local len=s1:utf8len()
			while len<48 do
				name=name.."\t"
				len=len+8
			end
			s1=str2
			name=name..s1
			len=s1:utf8len()
			while len<48 do
				name=name.."\t"
				len=len+8
			end
			name=name..str1.."\n"
			table.insert(names,name)
		end
	end
	f:close()
	local file = io.open(filename, "w")
	for i,v in ipairs(names) do
		file:write(v)
	end
	file:close()
end



t.RussianNames = {} --Таблица с особыми формами названий предметов в различных падежах
t.ShouldBeCapped = {} --Таблица, в которой находится список названий, первое слово которых пишется с большой буквы

t.NamesGender={} --Таблица со списками имён, отсортированными по полам
t.NamesGender["he"]={}
t.NamesGender["he2"]={}
t.NamesGender["she"]={}
t.NamesGender["it"]={}
t.NamesGender["plural"]={}
t.NamesGender["plural2"]={}



--Объявляем таблицу особых тегов, присущих персонажам.
--Порядковый номер тега определяет его приоритет.
t.CharacterInherentTags={}
for char in pairs(_G.GetActiveCharacterList()) do
	t.CharacterInherentTags[char]={}
end

--делит строку на части по символу-разделителю. Возвращает и пустые вхождения:
--split("|a|","|") вернёт таблицу из "", "а" и ""
--split("а","|") вернёт таблицу из "а"
--split("","|") вернёт таблицу из ""
--split("|","|") вернёт таблицу из "" и ""
--По идее разделителем может служить сразу несколько символов (не тестировалось)
local function split(str,sep)
		local fields, first = {}, 1
	str=str..sep
	for i=1,#str do
		if string.sub(str,i,i+#sep-1)==sep then
			fields[#fields+1]=(i<=first) and "" or string.sub(str,first,i-1)
			first=i+#sep
		end
	end
		return fields
end


local LetterCasesHash={u2l={["А"]="а",["Б"]="б",["В"]="в",["Г"]="г",["Д"]="д",["Е"]="е",["Ё"]="ё",["Ж"]="ж",["З"]="з",
							["И"]="и",["Й"]="й",["К"]="к",["Л"]="л",["М"]="м",["Н"]="н",["О"]="о",["П"]="п",["Р"]="р",
							["С"]="с",["Т"]="т",["У"]="у",["Ф"]="ф",["Х"]="х",["Ц"]="ц",["Ч"]="ч",["Ш"]="ш",["Щ"]="щ",
							["Ъ"]="ъ",["Ы"]="ы",["Ь"]="ь",["Э"]="э",["Ю"]="ю",["Я"]="я"},
					   l2u={["а"]="А",["б"]="Б",["в"]="В",["г"]="Г",["д"]="Д",["е"]="Е",["ё"]="Ё",["ж"]="Ж",["з"]="З",
							["и"]="И",["й"]="Й",["к"]="К",["л"]="Л",["м"]="М",["н"]="Н",["о"]="О",["п"]="П",["р"]="Р",
							["с"]="С",["т"]="Т",["у"]="У",["ф"]="Ф",["х"]="Х",["ц"]="Ц",["ч"]="Ч",["ш"]="Ш",["щ"]="Щ",
							["ъ"]="Ъ",["ы"]="Ы",["ь"]="Ь",["э"]="Э",["ю"]="Ю",["я"]="Я"}}
--первый символ в нижний регистр
local function firsttolower(tmp)
	if not tmp then return end
	local firstletter=tmp:utf8sub(1,1)
	firstletter = LetterCasesHash.u2l[firstletter] or firstletter
	return firstletter:lower()..tmp:utf8sub(2)
end

--первый символ в верхний регистр
local function firsttoupper(tmp)
	if not tmp then return end
	local firstletter=tmp:utf8sub(1,1)
	firstletter = LetterCasesHash.l2u[firstletter] or firstletter
	return firstletter:upper()..tmp:utf8sub(2)
end

function isupper(letter)
	if not letter or type(letter)~="string" then return end
	return LetterCasesHash.u2l[letter] or (#letter==1 and letter>="A" and letter<="Z")
end

function islower(letter)
	if not letter or type(letter)~="string" then return end
	return LetterCasesHash.l2u[letter] or (#letter==1 and letter>="a" and letter<="z")
end

local function russianupper(tmp)
	if not tmp then return end
	local res=""
	local letter
	for i=1,tmp:utf8len() do
		letter = tmp:utf8sub(i,i)
		letter = LetterCasesHash.l2u[letter] or letter
		res = res..letter:upper()
	end
	return res
end

local function russianlower(tmp)
	if not tmp then return end
	local res=""
	local letter
	for i=1,tmp:utf8len() do
		letter = tmp:utf8sub(i,i)
		letter = LetterCasesHash.u2l[letter] or letter
		res = res..letter:lower()
	end
	return res
end

--Функция ищет в реплике спец-тэги, оформленные в [] и выбирает нужный, соответствующий персонажу char
--Варианты с разным переводом для разного пола оформляются в [] и разделяются символом |.
--В общем случае оформляется так: [мужчина|женщина|оно|множественное число|имя префаба персонажа=его вариант]
--При этом каждый вариант без указания имени префаба определяет свою принадлежность в такой последовательности:
--первый — мужской вариант, второй — женский, третий — средний род, четвёртый — мн. число.
--Имя префаба можно указывать в любом из вариантов (например первом). Тогда оно не берётся в расчёт при анализе
--пустых (без указания имени префаба) вариантов: [wes=он молчун|это мужчина|wolfgang=силач|это женщина|это оно]
--Если в вариантах не указан нужный для char, то берётся вариант мужского пола (кроме webber'а, которому сперва
--попытается подставить вариант множественного числа, и Wx-78, который на русском считается мужским полом),
--если нет и этого, то ничего не подставится.
--Варианты полов можно задавать явно, указывая ключевые слова "he", "she", "it" или "plural"/"they"/"pl".
--Варианты с указанными префабами (и ключевыми словами) можно объединять в группы через запятую:
--[he=мужской|willow,wendy=женский без Уиккерботтом]
--Пример: "Скажи[plural=те], [приятель|милочка|создание|приятели|wickerbottom=дамочка], почему так[ой|ая|ое|ие] грустн[ый|ая|ое|ые]?"
--Необязательный параметр talker сообщает название префаба говорящего. Сейчас нужен для корректной обработки ситуации с Веббером
function t.ParseTranslationTags(message, char, talker, optionaltags)
	if not (message and string.find(message,"[",1,true)) then return message end

	local gender="neutral"
	local function parse(str)
		local vars=split(str,"|")
		local tags={}
		local function SelectByCustomTags(CustomTags)
			if not CustomTags then return false end
			if type(CustomTags)=="string" then return tags[CustomTags] end
			for _,tag in ipairs(CustomTags) do
				if tags[tag] then return tags[tag] end
			end
			return false
		end
		local counter=0
		for i,v in pairs(vars) do
			local vars2=split(v,"=")
			if #vars2==1 then counter=counter+1 end
			local path=(#vars2==2) and vars2[1] or 
					(((counter==1) and "he")
				or ((counter==2) and "she")
				or ((counter==3) and "it")
				or ((counter==4) and "plural")
				or ((counter==5) and "neutral")
				or ((counter>5) and nil))
			if path then
				local vars3=split(path,",")
				for _,vv in ipairs(vars3) do
					local c=vv and vv:match("^%s*(.*%S)")
					c=c and c:lower()
					if c=="they" or c=="pl" then c="plural"
					elseif c=="nog" or c=="nogender" then c="neutral"
					elseif c=="def" then c="default" end
					if c then tags[c]=(#vars2==2) and vars2[2] or v end
				end
			end
		end
		str=tags and (tags[char] --сначала ищем по имени
			or SelectByCustomTags(t.CharacterInherentTags[char]) --потом по особым тегам персонажа
			or tags[gender] --потом пытаемся выбрать по полу персонажа
			or SelectByCustomTags(optionaltags) --потом ищем, есть ли в вариантах дополнительные теги
			or tags["default"] --или берём дефолтный тег
			or tags["neutral"] --если ничего не нашли, пытаемся выбрать нейтральный вариант
			or tags["he"] --если и его нет, то мужской пол (это уже неправильно, но лучше, чем ничего)
			or "") or "" --ладно, ничего, значит ничего
		return str
	end
	local function search(part)
		part=string.sub(part,2,-2)
		if not string.find(part,"[",1,true) then
			part=parse(part)
		else
			part=parse(part:gsub("%b[]",search))
		end
		return part
	end

	--Экранируем тег заглавной буквы
	local CaseAdoptationNeeded
	message, CaseAdoptationNeeded = message:gsub("%[adoptcase]","<adoptcase>")
	--Ищем теги-маркеры, которые нужно добавить в список optionaltags
	message=message:gsub("%[marker=(.-)]",function(marker)
		if not optionaltags then optionaltags={}
		elseif type(optionaltags)=="string" then optionaltags={optionaltags} end
		table.insert(optionaltags,marker)
		return ""
	end)
	
--[[	message=message:gsub("$(.-)%((.-)%)[adoptadjective%.(.-)%.(.-)=(.-)]",function(gender, case, adjective)
		adjective = FixPrefix(adjective, case:lower(), gender:lower())
		return adjective
	end)]]
	message=message:gsub("%[adoptadjective%.(.-)%.(.-)=(.-)]",function(gender, case, adjective)
		adjective = FixPrefix(adjective, case:lower(), gender:lower())
		return adjective
	end)

	if char then
		char=char:lower()
		if char=="generic" then char="wilson" end

		if rawget(_G,"CHARACTER_GENDERS") then
			if _G.CHARACTER_GENDERS.MALE and table.contains(_G.CHARACTER_GENDERS.MALE, char) then gender="he"
			elseif _G.CHARACTER_GENDERS.FEMALE and table.contains(_G.CHARACTER_GENDERS.FEMALE, char) then gender="she"
			elseif _G.CHARACTER_GENDERS.ROBOT and table.contains(_G.CHARACTER_GENDERS.ROBOT, char) then gender="he"
			elseif _G.CHARACTER_GENDERS.IT and table.contains(_G.CHARACTER_GENDERS.IT, char) then gender="it"
			elseif _G.CHARACTER_GENDERS.NEUTRAL and table.contains(_G.CHARACTER_GENDERS.IT, char) then gender="neutral"
			elseif _G.CHARACTER_GENDERS.PLURAL and table.contains(_G.CHARACTER_GENDERS.PLURAL, char) then gender="plural" end
		end
		--Если это Веббер и он говорит сам о себе, то это множественное число
		if char=="webber" and (not talker or talker:lower()==char) then gender="plural" end
	end
	message=search("["..message.."]") or message
	if CaseAdoptationNeeded then
		message=message:gsub("([^.!? ]?)(%s*)<adoptcase>(.)",function(before, space, symbol)
			if not before or before=="" then symbol=firsttoupper(symbol) else symbol=firsttolower(symbol) end
			return((before or "")..(space or "")..(symbol or ""))
		end)
	end
	return message
end






















--Делаем бекап названия версии игры
local UPDATENAME=_G.STRINGS.UI.MAINSCREEN.UPDATENAME

--Загружаем русификацию
LoadPOFile(t.StorePath..t.MainPOfilename, t.SelectedLanguage)

t.PO = _G.LanguageTranslator.languages[t.SelectedLanguage]

--Восстанавливаем название версии игры из бекапа
t.PO["STRINGS.UI.MAINSCREEN.UPDATENAME"] = UPDATENAME


function ExtractMeta(str, key)
	if not str:find("{",1, true) then return str end --Для увеличения скорости
	local gentbl = {male = "he", maleanimated = "he2", female = "she", femaleanimated = "she2",
					neutral = "it", plural = "plural", pluralanimated = "plural2"}
	local actions = {}
	local res = str:gsub("{([^}]+)}", function(meta)
		if meta=="forcecase" then
			t.ShouldBeCapped[key:lower()] = true
			return ""
		else
			local parts = meta:split("=")
			if #parts==2 then
				if parts[1]=="gender" then
					local gen = gentbl[parts[2]:lower()]
					if gen then
						t.NamesGender[gen][key:lower()] = true
					end
					return ""
				elseif parts[1]:sub(1,5)=="case." or parts[1]:sub(1,5)=="form." then --формы по падежам и действиям
					local act = parts[1]:sub(6):upper()
					if act=="DEF" or act=="DEFAULT" or act==t.AdjectiveCaseTags[t.DefaultActionCase]:upper() then
						act = "DEFAULTACTION"
					end
					actions[act] = parts[2]
					return ""
				end
			end
		end
	end)
	for act, rus in pairs(actions) do
		if not t.RussianNames[res] then
			t.RussianNames[res] = {}
			t.RussianNames[res]["DEFAULT"] = res --TODO: Это лишнее, нужно удалить
			t.RussianNames[res].path = key --добавляем путь
			if act~="DEFAULTACTION" then
				t.RussianNames[res]["DEFAULTACTION"] = rebuildname(res, "DEFAULTACTION")
			end
			if act~="WALKTO" then
				t.RussianNames[res]["WALKTO"] = rebuildname(res, "WALKTO")
			end
		end
		t.RussianNames[res][act] = rus
	end
	return res
end




























--Сохраняем строки анонсов на русском
local announcerus = t.announcerus or {}
local ru=t.PO
announcerus.LEFTGAME=ru["STRINGS.UI.NOTIFICATION.LEFTGAME"] or ""
announcerus.JOINEDGAME=ru["STRINGS.UI.NOTIFICATION.JOINEDGAME"] or ""
announcerus.KICKEDFROMGAME=ru["STRINGS.UI.NOTIFICATION.KICKEDFROMGAME"] or ""
announcerus.BANNEDFROMGAME=ru["STRINGS.UI.NOTIFICATION.BANNEDFROMGAME"] or ""
--announcerus.NEW_SKIN_ANNOUNCEMENT=ru["STRINGS.UI.NOTIFICATION.NEW_SKIN_ANNOUNCEMENT"] or ""


announcerus.DEATH_ANNOUNCEMENT_1=ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1"] or ""
announcerus.DEATH_ANNOUNCEMENT_2_MALE=ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_MALE"] or ""
announcerus.DEATH_ANNOUNCEMENT_2_FEMALE=ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_FEMALE"] or ""
announcerus.DEATH_ANNOUNCEMENT_2_ROBOT=ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_ROBOT"] or ""
announcerus.DEATH_ANNOUNCEMENT_2_DEFAULT=ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_DEFAULT"] or ""
announcerus.GHOST_DEATH_ANNOUNCEMENT_MALE=ru["STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_MALE"] or ""
announcerus.GHOST_DEATH_ANNOUNCEMENT_FEMALE=ru["STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_FEMALE"] or ""
announcerus.GHOST_DEATH_ANNOUNCEMENT_ROBOT=ru["STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_ROBOT"] or ""
announcerus.GHOST_DEATH_ANNOUNCEMENT_DEFAULT=ru["STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_DEFAULT"] or ""
announcerus.REZ_ANNOUNCEMENT=ru["STRINGS.UI.HUD.REZ_ANNOUNCEMENT"] or ""
announcerus.START_AFK=ru["STRINGS.UI.HUD.START_AFK"] or ""
announcerus.STOP_AFK=ru["STRINGS.UI.HUD.STOP_AFK"] or ""
--	announcerus.VOTINGKICKSTART=ru["STRINGS.VOTING.KICK.START"] or ""
--	announcerus.VOTINGKICKSUCCESS=ru["STRINGS.VOTING.KICK.SUCCESS"] or ""
--	announcerus.VOTINGKICKFAILURE=ru["STRINGS.VOTING.KICK.FAILURE"] or ""
--[[
--Multitaste Starvation + Hunger Games
announcerus.BELL_DESTROYED = "Колокол на острорв #%s был уничтожен!"
announcerus.BELL_DESTOYED_ANNOUNCE = "Колокольчик игрока %s был уничтожен %s."
announcerus.BELL_DESTOYED_ANNOUNCE_UNKNOWN = "Колокольчик игрока %s был уничтожен неизвестным мобом."
announcerus.BELL_DBB = "%s уничтожил свой колокол."

announcerus.CLAN_DELETED = "Клан \"%s\" распался!"
announcerus.CLAN_DELETED_BY_PLAYER = "Клан \"%s\" был уничтожен %s!"
announcerus.CLAN_PLAYER_JOINED = "%s присоединился к клану \"%s\"."
announcerus.CLAN_PLAYER_LEFT = "%s покину клан."
announcerus.CLAN_CREATED = "%s создал клан \"%s\"!"
announcerus.CLAN_LEVELUP = "Клан \"%s\" получил %i уровень!"
announcerus.CLAN_PLAYER_KICKED = "%s был изгнан из клана \"%s\"!"]]

--Обнуляем их, чтобы они не перевелись, и сервер всегда писал на английском
ru["STRINGS.UI.NOTIFICATION.LEFTGAME"]=nil
ru["STRINGS.UI.NOTIFICATION.JOINEDGAME"]=nil
ru["STRINGS.UI.NOTIFICATION.KICKEDFROMGAME"]=nil
ru["STRINGS.UI.NOTIFICATION.BANNEDFROMGAME"]=nil
--ru["STRINGS.UI.NOTIFICATION.NEW_SKIN_ANNOUNCEMENT"]=nil
ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1"]=nil
ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_MALE"]=nil
ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_FEMALE"]=nil
ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_ROBOT"]=nil
ru["STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_DEFAULT"]=nil
ru["STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_MALE"]=nil
ru["STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_FEMALE"]=nil
ru["STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_ROBOT"]=nil
ru["STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_DEFAULT"]=nil
ru["STRINGS.UI.HUD.REZ_ANNOUNCEMENT"]=nil
ru["STRINGS.UI.HUD.START_AFK"]=nil
ru["STRINGS.UI.HUD.STOP_AFK"]=nil
--	ru["STRINGS.VOTING.KICK.START"]=nil
--	ru["STRINGS.VOTING.KICK.SUCCESS"]=nil
--	ru["STRINGS.VOTING.KICK.FAILURE"]=nil

--Строим хеш-таблицы
t.SpeechHashTbl={}

--Строит хеш-таблицу по имени персонажа. Английские реплики персонажа должны быть в STRINGS.CHARACTERS
--russource - таблица, в которой находятся все русские реплики персонажа в виде ["ключ из STRINGS"]="русский перевод"
--Если она не указана, то используется стандартная таблица, в которую загружаются реплики из PO файлов LanguageTranslator.languages[t.SelectedLanguage]
function t.BuildCharacterHash(charname,russource)
	local source=russource or t.PO
	local function CreateRussianHashTable(hashtbl,tbl,str)
		for i,v in pairs(tbl) do
			if type(v)=="table" then
				CreateRussianHashTable(hashtbl,tbl[i],str.."."..i)
			else
				local val=source[str.."."..i] or v
				--составляем спец-список всех сообщений, в которых есть отсылки на вставляемое имя (или на что-то другое)
				if v and string.find(v,"%s",1,true) then
					hashtbl["mentioned_class"]=hashtbl["mentioned_class"] or {}
					hashtbl["mentioned_class"][v]=val
				end
				if not hashtbl[v] then
					hashtbl[v]=val
				elseif type(hashtbl[v])=="string" and val~=hashtbl[v] then
					local temp=hashtbl[v] --преобразуем в список
					hashtbl[v]={}
					table.insert(hashtbl[v],temp)
					table.insert(hashtbl[v],val) --добавляем текущее
				elseif type(hashtbl[v])=="table" then
					local found=false
					for _,vv in ipairs(hashtbl[v]) do
						if vv==val then
							found=true
							break
						end
					end
					if not found then table.insert(hashtbl[v],val) end
				end
			end
		end
	end
	charname=charname:upper()
	if character=="WILSON" then character="GENERIC" end
	if character=="MAXWELL" then character="WAXWELL" end
	if character=="WIGFRID" then character="WATHGRITHR" end
	t.SpeechHashTbl[charname]={}
	CreateRussianHashTable(t.SpeechHashTbl[charname],STRINGS.CHARACTERS[charname],"STRINGS.CHARACTERS."..charname)
end


--Генерируем хеши для всех персонажей, перечисленных в STRINGS.CHARACTERS
for charname,v in pairs(STRINGS.CHARACTERS) do
	t.BuildCharacterHash(charname)
end

--Генерируем хеш-таблицы для названий предметов в обе стороны
--А так же извлекаем мета-данные о поле предмета, его особых формах и необходимости писать с большой буквы
t.SpeechHashTbl.NAMES = {Eng2Key = {}, Rus2Eng = {}}
for key, val in pairs(STRINGS.NAMES) do
	local fullkey = "STRINGS.NAMES."..key
	if t.PO[fullkey] then
		t.PO[fullkey] = ExtractMeta(t.PO[fullkey], key)
	end
	t.SpeechHashTbl.NAMES.Eng2Key[val] = key
	t.SpeechHashTbl.NAMES.Rus2Eng[t.PO[fullkey] or val] = val
end
t.SpeechHashTbl.SANDBOXMENU = {Eng2Key = {}, Rus2Eng = {}}
for key, val in pairs(STRINGS.UI.SANDBOXMENU) do
	local fullkey = "STRINGS.UI.SANDBOXMENU."..key
	if t.PO[fullkey] then
		t.PO[fullkey] = ExtractMeta(t.PO[fullkey], key)
	end
	t.SpeechHashTbl.SANDBOXMENU.Eng2Key[val] = key
	t.SpeechHashTbl.SANDBOXMENU.Rus2Eng[t.PO[fullkey] or val] = val
end

-- t.SpeechHashTbl.GOATMUM_WELCOME_INTRO = {Eng2Key = {}, Rus2Eng = {}}
-- for key, val in pairs(STRINGS.GOATMUM_WELCOME_INTRO) do
-- 	local fullkey = "STRINGS.GOATMUM_WELCOME_INTRO."..key
-- 	if t.PO[fullkey] then
-- 		t.PO[fullkey] = ExtractMeta(t.PO[fullkey], key)
-- 	end
-- 	t.SpeechHashTbl.GOATMUM_WELCOME_INTRO.Eng2Key[val] = key
-- 	t.SpeechHashTbl.GOATMUM_WELCOME_INTRO.Rus2Eng[t.PO[fullkey] or val] = val
-- end
--Извлекаем мета-данные из названий скинов
for key, val in pairs(STRINGS.SKIN_NAMES) do
	local fullkey = "STRINGS.SKIN_NAMES."..key
	if t.PO[fullkey] then
		t.PO[fullkey] = ExtractMeta(t.PO[fullkey], key)
	end
end


--Генерируем хеш-таблицы для имён свиней и кроликов
t.SpeechHashTbl.PIGNAMES={Eng2Rus={}}
for i,v in pairs(STRINGS.PIGNAMES) do
	t.SpeechHashTbl.PIGNAMES.Eng2Rus[v]=t.PO["STRINGS.PIGNAMES."..i] or v
	t.PO["STRINGS.PIGNAMES."..i]=nil
end
t.SpeechHashTbl.BUNNYMANNAMES={Eng2Rus={}}
for i,v in pairs(STRINGS.BUNNYMANNAMES) do
	t.SpeechHashTbl.BUNNYMANNAMES.Eng2Rus[v]=t.PO["STRINGS.BUNNYMANNAMES."..i] or v
	t.PO["STRINGS.BUNNYMANNAMES."..i]=nil
end

t.SpeechHashTbl.SWAMPIGNAMES={Eng2Rus={}}
for i,v in pairs(STRINGS.SWAMPIGNAMES) do
	t.SpeechHashTbl.SWAMPIGNAMES.Eng2Rus[v]=t.PO["STRINGS.SWAMPIGNAMES."..i] or v
	t.PO["STRINGS.SWAMPIGNAMES."..i]=nil
end

--Подгружаем в "хэш" фразы Мамси
t.SpeechHashTbl.GOATMUM_CRAVING_HINTS={Eng2Rus={}}
for i,v in pairs(STRINGS.GOATMUM_CRAVING_HINTS) do
	t.SpeechHashTbl.GOATMUM_CRAVING_HINTS.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_CRAVING_HINTS."..i] or v
	t.PO["STRINGS.GOATMUM_CRAVING_HINTS."..i]=nil
end
for i,v in pairs(STRINGS.GOATMUM_CRAVING_MATCH) do
	if string.find(t.PO["STRINGS.GOATMUM_CRAVING_MATCH."..i],'%%s') then 
		t.SpeechHashTbl.GOATMUM_CRAVING_HINTS.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_CRAVING_MATCH."..i] or v
		t.PO["STRINGS.GOATMUM_CRAVING_MATCH."..i]=nil
	end
end
for i,v in pairs(STRINGS.GOATMUM_CRAVING_MISMATCH) do
	if string.find(t.PO["STRINGS.GOATMUM_CRAVING_MISMATCH."..i],'%%s') then 
		t.SpeechHashTbl.GOATMUM_CRAVING_HINTS.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_CRAVING_MISMATCH."..i] or v
		t.PO["STRINGS.GOATMUM_CRAVING_MISMATCH."..i]=nil
	end
end


t.SpeechHashTbl.GOATMUM_CRAVING_HINTS_PART2={Eng2Rus={}}
for i,v in pairs(STRINGS.GOATMUM_CRAVING_HINTS_PART2) do
	t.SpeechHashTbl.GOATMUM_CRAVING_HINTS_PART2.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_CRAVING_HINTS_PART2."..i] or v
	t.PO["STRINGS.GOATMUM_CRAVING_HINTS_PART2."..i]=nil
end
for i,v in pairs(STRINGS.GOATMUM_CRAVING_HINTS_PART2_IMPATIENT) do
	t.SpeechHashTbl.GOATMUM_CRAVING_HINTS_PART2.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_CRAVING_HINTS_PART2_IMPATIENT."..i] or v
	t.PO["STRINGS.GOATMUM_CRAVING_HINTS_PART2_IMPATIENT."..i]=nil
end

t.SpeechHashTbl.GOATMUM_CRAVING_MAP={Eng2Rus={}}
for i,v in pairs(STRINGS.GOATMUM_CRAVING_MAP) do
	t.SpeechHashTbl.GOATMUM_CRAVING_MAP.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_CRAVING_MAP."..i] or v
	t.PO["STRINGS.GOATMUM_CRAVING_MAP."..i]=nil
end


t.SpeechHashTbl.GOATMUM_WELCOME_INTRO={Eng2Rus={}}
for i,v in pairs(STRINGS.GOATMUM_WELCOME_INTRO) do
	t.SpeechHashTbl.GOATMUM_WELCOME_INTRO.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_WELCOME_INTRO."..i] or v
	t.PO["STRINGS.GOATMUM_WELCOME_INTRO."..i]=nil
end
for i,v in pairs(STRINGS.GOATMUM_LOST) do
	t.SpeechHashTbl.GOATMUM_WELCOME_INTRO.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_LOST."..i] or v
	t.PO["STRINGS.GOATMUM_LOST."..i]=nil
end
for i,v in pairs(STRINGS.GOATMUM_VICTORY) do
	t.SpeechHashTbl.GOATMUM_WELCOME_INTRO.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_VICTORY."..i] or v
	t.PO["STRINGS.GOATMUM_VICTORY."..i]=nil
end
for i,v in pairs(STRINGS.GOATMUM_CRAVING_MATCH) do
	if t.PO["STRINGS.GOATMUM_CRAVING_MATCH."..i] then 
		t.SpeechHashTbl.GOATMUM_WELCOME_INTRO.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_CRAVING_MATCH."..i] or v
		t.PO["STRINGS.GOATMUM_CRAVING_MATCH."..i]=nil
	end
end
for i,v in pairs(STRINGS.GOATMUM_CRAVING_MISMATCH) do
	if t.PO["STRINGS.GOATMUM_CRAVING_MISMATCH."..i] then 
		t.SpeechHashTbl.GOATMUM_WELCOME_INTRO.Eng2Rus[v]=t.PO["STRINGS.GOATMUM_CRAVING_MISMATCH."..i] or v
		t.PO["STRINGS.GOATMUM_CRAVING_MISMATCH."..i]=nil
	end
end

--t.SpeechHashTbl.PIGTALKS={}
--t.SpeechHashTbl.BUNNYMANTALKS={}
t.SpeechHashTbl.EPITAPHS={}

local function GetDataByPath(path)
	if type(path)~="table" then return path end
	local dat=_G
	for _,v in ipairs(path) do
		dat=dat[tonumber(v) or v]
		if not dat then break end
	end
	return dat
end

--Удаляем из таблицы с переводом PO некоторые реплики.
--Далее игра будет пользоваться хеш-таблицами для вывода русских реплик		
-- for i,v in pairs(t.PO) do
-- 	local path=string.split(i,".")
-- 	local data=nil
-- 	if path and type(path)=="table" and path[2] then
-- 		if path[2]=="CHARACTERS" then --Удаляем все реплики персонажей
-- 			t.PO[i]=nil
-- --[[		elseif string.sub(path[2],1,9)=="PIG_TALK_" --Удаляем реплики свинов и свинов стражей
-- 		   or string.sub(path[2],1,14)=="PIG_GUARD_TALK" then
-- 			data=GetDataByPath(path)
-- 			if data then t.SpeechHashTbl.PIGTALKS[data]=t.PO[i] end
-- 			t.PO[i]=nil
-- 		elseif string.sub(path[2],1,7)=="RABBIT_" then --Удаляем реплики зайцев
-- 			data=GetDataByPath(path)
-- 			if data then t.SpeechHashTbl.BUNNYMANTALKS[data]=t.PO[i] end
-- 			t.PO[i]=nil]]
-- 		elseif path[2]=="EPITAPHS" then--Удаляем эпитафии
-- 			data=GetDataByPath(path)
-- 			if data then
-- 				t.SpeechHashTbl.EPITAPHS[data] = t.PO[i]
-- 				t.SpeechHashTbl.EPITAPHS[data:upper()] = russianupper(t.PO[i])
-- 			end
-- 			t.PO[i]=nil
-- 		end
-- 	end
-- end




if t.CurrentTranslationType==t.TranslationTypes.Full then --Полный перевод. Ничего не делаем.
elseif t.CurrentTranslationType==t.TranslationTypes.InterfaceChat or t.CurrentTranslationType==t.TranslationTypes.ChatOnly then --Интерфейс и чат. Тоже ничего не делаем. Блокировка произойдёт позже.
	for charname,v in pairs(STRINGS.CHARACTERS) do
		t.SpeechHashTbl[charname]={}
	end
--	t.SpeechHashTbl.PIGTALKS={}
--	t.SpeechHashTbl.BUNNYMANTALKS={}
	t.SpeechHashTbl.EPITAPHS={}
	t.SpeechHashTbl.NAMES={Eng2Key={},Rus2Eng={}}
	t.SpeechHashTbl.PIGNAMES={Eng2Rus={}}
	t.SpeechHashTbl.BUNNYMANNAMES={Eng2Rus={}}

	if t.CurrentTranslationType==t.TranslationTypes.ChatOnly then --Только чат. Убираем перевод всего.
		local a1=t.PO["STRINGS.LMB"]
		local a2=t.PO["STRINGS.RMB"]
		t.PO={} --Да, вот так. Убираем весь перевод.
		t.PO["STRINGS.LMB"]=a1
		t.PO["STRINGS.RMB"]=a2
		Assets={Assets[1],Assets[2]} --Часть графики тоже отключаем
	else
		for i,v in pairs(t.PO) do
			if string.sub(i,8+1,8+3)~="UI." then t.PO[i]=nil end
		end
	end
end





--Подменяем названия режимов игры
if rawget(_G,"GAME_MODES") and STRINGS.UI.GAMEMODES then
	for i,v in pairs(_G.GAME_MODES) do
		for ii,vv in pairs(STRINGS.UI.GAMEMODES) do
			if v.text==vv then
				_G.GAME_MODES[i].text = t.PO["STRINGS.UI.GAMEMODES."..ii] or _G.GAME_MODES[i].text
			end
			if v.description==vv then
				_G.GAME_MODES[i].description = t.PO["STRINGS.UI.GAMEMODES."..ii] or _G.GAME_MODES[i].description
			end
		end
	end
end

--Подменяем шрифт, потому что тут уже инициализировался английский
AddClassPostConstruct("widgets/loadingwidget", function(self)
	local OldKeepAlive = self.KeepAlive
	function self:KeepAlive(...)
		local res = OldKeepAlive(self, ...)
		if self.loading_widget then
			self.loading_widget:SetFont(_G.UIFONT)
		end
		return res
	end
end)


local _utf8=require("1251")
local _1251=require("utf-8")

local function converttoutf8(str)
		return str:gsub('.',_1251)
end

local function convertfromutf8(str)
	return str
--[[		if not str or type(str)~="string" then return str end
	local str2=""
	for uchar in string.gfind(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		if #uchar==1 then
			str2=str2..uchar
		elseif #uchar==2 then
			local res=(uchar:byte(1)-0xC0)*0x40+uchar:byte(2)-0x80
			if _utf8[res] then str2=str2..string.char(_utf8[res]) end
		end
	end
	return str2]]
end


local AllPlayersList={} --Список всех игроков в игре, бывших за сессию. Нужен для случаев, когда игрока уже нет, а сообщение пришло

--Исправляем русские имена персонажей, которые приходят к нам в другой кодировке, и обновляем AllPlayersList
if _G.TheNet.GetClientTable then
	_G.getmetatable(_G.TheNet).__index.GetClientTable = (function()
		local oldGetClientTable = _G.getmetatable(_G.TheNet).__index.GetClientTable
		return function(self, ... )
			local res = oldGetClientTable(self, ...)
			if res and type(res)=="table" then for i,v in pairs(res) do
				if v.name and v.prefab then
					if t.CurrentTranslationType~=t.TranslationTypes.ChatOnly and v.name=="[Host]" then
						v.name="[Хост]"
					end
					AllPlayersList[v.name]=v.prefab or nil
				end
			end end
			return res
		end
	end)()
end
--Склоняем названия вещей в пожитках
_G.GetSkinUsableOnString = function (item_type, popup_txt)
	local skin_data = _G.GetSkinData(item_type)
	
	local skin_str = _G.GetSkinName(item_type)
	
	local usable_on_str = ""
	if skin_data ~= nil and skin_data.base_prefab ~= nil then
		if skin_data.granted_items == nil then
			local item_str = rebuildname(STRINGS.NAMES[string.upper(skin_data.base_prefab)],"reskin",string.upper(skin_data.base_prefab))
			usable_on_str = _G.subfmt(popup_txt and STRINGS.UI.SKINSSCREEN.USABLE_ON_POPUP or STRINGS.UI.SKINSSCREEN.USABLE_ON, { skin = skin_str, item = item_str })
		else
			local item1_str = rebuildname(STRINGS.NAMES[string.upper(skin_data.base_prefab)],"reskin",string.upper(skin_data.base_prefab))
			local item2_str = nil
			local item3_str = nil
			
			local granted_skin_data = _G.GetSkinData(skin_data.granted_items[1])
			if granted_skin_data ~= nil and granted_skin_data.base_prefab ~= nil then
				item2_str = rebuildname(STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)],"reskin",string.upper(granted_skin_data.base_prefab))	
			end
			local granted_skin_data = _G.GetSkinData(skin_data.granted_items[2])
			if granted_skin_data ~= nil and granted_skin_data.base_prefab ~= nil then
				item3_str = rebuildname(STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)],"reskin",string.upper(granted_skin_data.base_prefab))
			end
			
			if item3_str == nil then
				usable_on_str = _G.subfmt(popup_txt and STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE_POPUP or STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE, { skin = skin_str, item1 = item1_str, item2 = item2_str })
			else
				usable_on_str = _G.subfmt(popup_txt and STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE_3_POPUP or STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE_3, { skin = skin_str, item1 = item1_str, item2 = item2_str, item3 = item3_str })
			end
		end
	end
	
	return usable_on_str
end
--Сообщения о событиях в игре
AddClassPostConstruct("widgets/eventannouncer", function(self)
	--Переопределяем глобальную функцию, формирующую анонс-сообщение о смерти
	--Делаем это тут, потому что она объявлена в классе eventannouncer, и не видна до обращения к этому классу.
	--Тут нам нужно позаботиться об выводе имени убийцы на английском языке.
	local oldGetNewDeathAnnouncementString=_G.GetNewDeathAnnouncementString
	function newGetNewDeathAnnouncementString(theDead, source, pkname)
		local str=oldGetNewDeathAnnouncementString(theDead, source, pkname)
		if _G.TheWorld and not _G.TheWorld.ismastersim then return str end
		if string.find(str,STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1,1,true) then
			--если игрок был убит
			local capturestring=nil
			if string.find(str,STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_MALE,1,true) then
				capturestring="( "..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1.." )(.*)("..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_MALE..")"
			elseif string.find(str,STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_FEMALE,1,true) then
				capturestring="( "..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1.." )(.*)("..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_FEMALE..")"
			elseif string.find(str,STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_ROBOT,1,true) then
				capturestring="( "..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1.." )(.*)("..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_ROBOT..")"
			elseif string.find(str,STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_DEFAULT,1,true) then
				capturestring="( "..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1.." )(.*)("..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_DEFAULT..")"
			else 
				capturestring="( "..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1.." )(.*)(%.)$"
			end
			if capturestring then -- выяснилось, что кто-то убит
				local a, killername, b=str:match(capturestring)
				if killername then
					killername=t.SpeechHashTbl.NAMES.Rus2Eng[killername] or killername--Переводим на английский
					str=str:gsub(capturestring,"%1"..killername.."%3")
				end
			end
		end	
		return str
	end
	_G.GetNewDeathAnnouncementString=newGetNewDeathAnnouncementString
	
	--Сообщение о том, что кто-то был оживлён. Тут нужно подменить на английский источник оживления
	local oldGetNewRezAnnouncementString=_G.GetNewRezAnnouncementString
	function NewGetNewRezAnnouncementString(theRezzed, source, ...)
		source=source and (t.SpeechHashTbl.NAMES.Rus2Eng[source] or source) --Переводим имя на английский
		return oldGetNewRezAnnouncementString(theRezzed, source, ...)
	end
	_G.GetNewRezAnnouncementString=NewGetNewRezAnnouncementString

	--Вывод любых анонсов на экран. Тут подменяем все нестандартные фразы, и не только
	local OldShowNewAnnouncement = self.ShowNewAnnouncement
	if OldShowNewAnnouncement then function self:ShowNewAnnouncement(announcement, ...)
		--Ничего не делаем, если переводится только чат или только чат и интерфейс
		if t.CurrentTranslationType==t.TranslationTypes.ChatOnly or t.CurrentTranslationType==t.TranslationTypes.InterfaceChat then
			return OldShowNewAnnouncement(self, announcement, ...)
		end

		local gender, player, RussianMessage, name, name2, killerkey

		local function test(adder1,msg1,rusmsg1,adder2,msg2,rusmsg2,ending)
			--print("Test:", tostring(adder1), tostring(msg1), tostring(rusmsg1), tostring(adder2), tostring(msg2), tostring(rusmsg2), tostring(ending))
			if name or name2 then return end
			msg1=msg1 and msg1:gsub("([.%-?])","%%%1"):gsub("%%s","(.*)") or ""
			msg2=msg2 and msg2:gsub("([.%-?])","%%%1"):gsub("%%s","(.*)") or ""
			name, name2=announcement:match((adder1 or "")..msg1..(adder2 or "")..msg2)
			if name then RussianMessage=rusmsg1 end
			if adder2 and name and name2 and rusmsg2 then RussianMessage=RussianMessage..rusmsg2 end
			if ending and RussianMessage then RussianMessage=RussianMessage..ending end
		end
		--Проверяем голосования
--			test(nil,STRINGS.VOTING.KICK.START, announcerus.VOTINGKICKSTART)
--			test(nil,STRINGS.VOTING.KICK.SUCCESS, announcerus.VOTINGKICKSUCCESS)
--			test(nil,STRINGS.VOTING.KICK.FAILURE, announcerus.VOTINGKICKFAILURE)
		--Присоединение/Отсоединение
--		--C 176665 в этих двух изначально есть %s
--		test("(.*) ",STRINGS.UI.NOTIFICATION.JOINEDGAME, announcerus.JOINEDGAME)
--		test("(.*) ",STRINGS.UI.NOTIFICATION.LEFTGAME, announcerus.LEFTGAME)
		test(nil,STRINGS.UI.NOTIFICATION.JOINEDGAME, announcerus.JOINEDGAME)
		test(nil,STRINGS.UI.NOTIFICATION.LEFTGAME, announcerus.LEFTGAME)
		--Кик/Бан
		test(nil,STRINGS.UI.NOTIFICATION.KICKEDFROMGAME, announcerus.KICKEDFROMGAME)
		test(nil,STRINGS.UI.NOTIFICATION.BANNEDFROMGAME, announcerus.BANNEDFROMGAME)
		--Моды
		--[[
		test(nil, STRINGS.BELL_DESTROYED, announcerus.BELL_DESTROYED)
		test(nil, STRINGS.BELL_DESTOYED_ANNOUNCE, announcerus.BELL_DESTOYED_ANNOUNCE)
		test(nil, STRINGS.BELL_DESTOYED_ANNOUNCE_UNKNOWN, announcerus.BELL_DESTOYED_ANNOUNCE_UNKNOWN)
		test(nil, STRINGS.BELL_DBB, announcerus.BELL_DBB)
		
		if STRINGS.MUTS_CLANS then
			test(nil, STRINGS.MUTS_CLANS.CLAN_DELETED, announcerus.CLAN_DELETED)
			test(nil, STRINGS.MUTS_CLANS.CLAN_DELETED_BY_PLAYER, announcerus.CLAN_DELETED_BY_PLAYER)
			test(nil, STRINGS.MUTS_CLANS.PLAYER_JOINED, announcerus.CLAN_PLAYER_JOINED)
			test(nil, STRINGS.MUTS_CLANS.PLAYER_LEFT, announcerus.CLAN_PLAYER_LEFT)
			test(nil, STRINGS.MUTS_CLANS.CLAN_CREATED, announcerus.CLAN_CREATED)
			test(nil, STRINGS.MUTS_CLANS.LEVELUP, announcerus.CLAN_LEVELUP)
			test(nil, STRINGS.MUTS_CLANS.PLAYER_KICKED, announcerus.CLAN_PLAYER_KICKED)
		end]]
		--[[
		if announcerus.mods and #announcerus.mods > 0 then
			for id, translate in pairs(announcerus.mods) do
				if STRINGS.UI.NOTIFICATION[id] and translate then
					test(nil, STRINGS.UI.NOTIFICATION[id], translate)
				end
			end
		end]]
		--Новый скин
--		test(nil,STRINGS.UI.NOTIFICATION.NEW_SKIN_ANNOUNCEMENT, announcerus.NEW_SKIN_ANNOUNCEMENT)
		if not name2 then
			--Реплики о смерти
			test("(.*) ",STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1, announcerus.DEATH_ANNOUNCEMENT_1,
				 " (.*)",STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_MALE, announcerus.DEATH_ANNOUNCEMENT_2_MALE)
			test("(.*) ",STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1, announcerus.DEATH_ANNOUNCEMENT_1,
				 " (.*)",STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_FEMALE, announcerus.DEATH_ANNOUNCEMENT_2_FEMALE)
			test("(.*) ",STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1, announcerus.DEATH_ANNOUNCEMENT_1,
				 " (.*)",STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_ROBOT, announcerus.DEATH_ANNOUNCEMENT_2_ROBOT)
			test("(.*) ",STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1, announcerus.DEATH_ANNOUNCEMENT_1,
				 " (.*)",STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_DEFAULT, announcerus.DEATH_ANNOUNCEMENT_2_DEFAULT)
			test("(.*) ",STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1, announcerus.DEATH_ANNOUNCEMENT_1, " (.*)%.$", nil, nil, ".")
			test("(.*) ",STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_MALE, announcerus.GHOST_DEATH_ANNOUNCEMENT_MALE)
			test("(.*) ",STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_FEMALE, announcerus.GHOST_DEATH_ANNOUNCEMENT_FEMALE)
			test("(.*) ",STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_ROBOT, announcerus.GHOST_DEATH_ANNOUNCEMENT_ROBOT)
			test("(.*) ",STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_DEFAULT, announcerus.GHOST_DEATH_ANNOUNCEMENT_DEFAULT)
			--Реплика об оживлении
			test("(.*) ",STRINGS.UI.HUD.REZ_ANNOUNCEMENT, announcerus.REZ_ANNOUNCEMENT, " (.*)%.$", nil, nil, ".")
			if name2 then --Было обнаружено второе имя, и это сообщение о смерти/оживлении
				--Переводим имя на русский, если получится
				killerkey=t.SpeechHashTbl.NAMES.Eng2Key[name2] --Получаем ключ имени
				if killerkey then
					name2=STRINGS.NAMES[killerkey] or STRINGS.NAMES["SHENANIGANS"] --Тут переводим имя на русский
					name2=t.RussianNames[name2] and t.RussianNames[name2]["KILL"] or rebuildname(name2,"KILL",killerkey) or name2
					if not t.ShouldBeCapped[killerkey:lower()] and not table.contains(_G.GetActiveCharacterList(), killerkey:lower()) then
						name2=firsttolower(name2)
					end
					killerkey=killerkey:lower()
					if table.contains(_G.GetActiveCharacterList(), killerkey) then killerkey=nil end
				end
			end
		end
		if name and RussianMessage then
			if _G.TheNet.GetClientTable then _G.TheNet:GetClientTable()	end --обновляем список игроков
			announcement = string.format((t.ParseTranslationTags(RussianMessage, AllPlayersList[name], "announce", killerkey)), name or "", name2 or "", "" ,"") or announcement
		end
		OldShowNewAnnouncement(self, announcement, ...)
	end end
end) -- для AddClassPostConstruct "widgets/eventannouncer"



--Подбирает сообщение из хеш-таблиц по указанному персонажу и сообщению на английском.
--Если персонаж не указан, используется уилсон.
--Возвращает переведённое сообщение и вторым параметром таблицу всех замен %s, если таковые были.
function t.GetFromSpeechesHash(message, char)
	local function GetMentioned(message,char)
		if not (message and t.SpeechHashTbl[char] and t.SpeechHashTbl[char]["mentioned_class"] and type(t.SpeechHashTbl[char]["mentioned_class"])=="table") then return nil end
		for i,v in pairs(t.SpeechHashTbl[char]["mentioned_class"]) do
			local mentions={string.match(message,"^"..(string.gsub(i,"%%s","(.*)")).."$")}
			if mentions and #mentions>0 then
				return v, mentions --возвращаем перевод (с незаменёнными %s) и список отсылок
			end
		end
		return nil
	end
	local mentions
	if not char then char = "GENERIC" end
	if message and t.SpeechHashTbl[char] then
		local umlautified = false
		-- if char=="WATHGRITHR" then
		-- 	local tmp = message:gsub("[\246ö]","o"):gsub("[\214Ö]","O") or message --подменяем и 1251 и UTF-8 версии
		-- 	umlautified = tmp~=message
		-- 	message = tmp
		-- end
		--переводим из хеш-таблицы родного персонажа или Уилсона (если не найден родной)
		local msg = t.SpeechHashTbl[char][message] or t.SpeechHashTbl["GENERIC"][message]
		if not msg and char=="WX78" then --Тут хеш-таблица не работает, приходится делать перебор
			for i, v in pairs(t.SpeechHashTbl["GENERIC"]) do
				if message==i:upper() then msg = v break end
			end
		end
		--в mentions попадает таблица всех найденных замен %s, если они есть
		if not msg then msg, mentions = GetMentioned(message,char) end
		if not msg then msg, mentions = GetMentioned(message,"GENERIC") end
		message = msg or message
		--если есть разные варианты переводов, то выбираем один из них случайным образом
		message = (type(message)=="table") and _G.GetRandomItem(message) or message
		-- if umlautified then
		-- 	if rawget(_G, "GetSpecialCharacterPostProcess") then
		-- 		--подменяем русские на английские, чтобы работала Umlautify
		-- 		local tmp = message:gsub("о","o"):gsub("О","O") or message
		-- 		message = _G.GetSpecialCharacterPostProcess("wathgrithr", tmp) or message
		-- 	else
		-- 		message = message:gsub("о","ö"):gsub("О","Ö") or message
		-- 	end
		-- end
	end
	return message, mentions
end

local function GetMentioned1(message)
	for i,v in pairs(t.SpeechHashTbl.GOATMUM_CRAVING_HINTS.Eng2Rus) do
		local regex=string.gsub(i,"%.","%%.")
		regex=string.gsub(regex,"{craving}","(.-)")
		regex=string.gsub(regex,"{part2}","(.+)")
		-- print(regex)
		local mentions={string.match(message,"^"..(regex).."$")}
		if mentions and #mentions>0 and  string.find(mentions[1],'%.%.%.')==nil then
			-- print(v,mentions[1])
			-- if #mentions>1 then print(mentions[2]) end
			return v, mentions --возвращаем перевод (с незаменёнными %s) и список отсылок
		end
	end
	return nil
end
-- _G.GetMentioned=GetMentioned1
-- _G.t=t
--Переводит сообщение на русский, пользуясь хеш-таблицами
--message - сообщение на английском
--entity - ссылка на говорящего это сообщение персонажа
function t.TranslateToRussian(message, entity)
	--print("t.TranslateToRussian", message, entity.prefab)
	if not (entity and entity.prefab and entity.components.talker and type(message)=="string") then return message end
	if entity:HasTag("playerghost") then --Если это реплика игрока-привидения
		message=string.gsub(message,"h","у")
		return message
--	elseif entity.prefab=="pigman" then --Если это реплика свина
--		return t.SpeechHashTbl.PIGTALKS[message] or message
--	elseif entity.prefab=="pigguard" then --Если это реплика свина-стража
--		print("pig talk detected")
--		return t.SpeechHashTbl.PIGTALKS[message] or message
--	elseif entity.prefab=="bunnyman" then --Если это реплика зайца
--		return t.SpeechHashTbl.BUNNYMANTALKS[message] or message
	end

	
	if entity.prefab =='quagmire_goatmum' then

		if t.SpeechHashTbl.GOATMUM_WELCOME_INTRO.Eng2Rus[message] then 
			return t.SpeechHashTbl.GOATMUM_WELCOME_INTRO.Eng2Rus[message]
		end

		local NotTranslated=message
		local msg, mentions=GetMentioned1(message)
		message=msg or message

		if NotTranslated==message then return message end
		local part2
		local craving
		if mentions and #mentions>0 and mentions[1] then
			craving=t.SpeechHashTbl.GOATMUM_CRAVING_MAP.Eng2Rus[mentions[1]]
			if #mentions>1 then
				part2=t.SpeechHashTbl.GOATMUM_CRAVING_HINTS_PART2.Eng2Rus[mentions[2]]
			end
			if  #mentions==1 and craving then
				message=string.format(message,craving)
			elseif #mentions==2 and craving and part2 then
				message=string.format(message,craving,part2)
			end	
		end
		return message
	end

	if t.SpeechHashTbl.EPITAPHS[message] then --если это описание эпитафии
		return t.SpeechHashTbl.EPITAPHS[message]
	end

	local ent=entity
	entity=entity.prefab:upper()
	if entity=="WILSON" then entity="GENERIC" end
	if entity=="MAXWELL" then entity="WAXWELL" end
	if entity=="WIGFRID" then entity="WATHGRITHR" end

	--Обработка сообщения
	local function TranslateMessage(message)
		--Получаем перевод реплики и список отсылок %s, если они есть в реплике
		if not message then return end
		local NotTranslated=message
		local msg, mentions=t.GetFromSpeechesHash(message,entity)
		message=msg or message
		
		if NotTranslated==message then return (t.ParseTranslationTags(message, ent.prefab, nil, nil)) or message end

		local killerkey
		if mentions then
			if #mentions>1 then
				killerkey=t.SpeechHashTbl.NAMES.Eng2Key[mentions[2]] --Получаем ключ имени убийцы
				if not killerkey and entity=="WX78" then --тут только полный перебор, т.к. он говорит всё в верхнем регистре
					for eng, key in pairs(t.SpeechHashTbl.NAMES.Eng2Key) do
						if eng:upper()==mentions[2] then killerkey = key break end
					end
				end
				mentions[2]=killerkey and STRINGS.NAMES[killerkey] or mentions[2]
				if killerkey then
					mentions[2]=t.RussianNames[mentions[2]] and t.RussianNames[mentions[2]]["KILL"] or rebuildname(mentions[2],"KILL",killerkey) or mentions[2]
					if not t.ShouldBeCapped[killerkey:lower()] and not table.contains(_G.GetActiveCharacterList(), killerkey:lower()) then
						mentions[2]=firsttolower(mentions[2])
					end
					killerkey=killerkey:lower()
					if table.contains(_G.GetActiveCharacterList(), killerkey) then killerkey=nil end
				end
			end
		end
		--Подстраиваем сообщение под пол персонажа
		message=(t.ParseTranslationTags(message, ent.prefab, nil, killerkey)) or message
		--Подставляем имена, если они есть
		message=string.format(message, _G.unpack(mentions or {"","","",""}))
		if entity=="WX78" then
			message=russianupper(message) or message
		end
		return message
	end

	--Делим реплику на куски из строк по переносу строки
	--Это нужно для совместимости с модами, которые что-то добавляют в реплику через \n
	local messages=split(message,"\n") or {message}
	message=""
	local i=1
	--Пытаемся перевести по отдельности и парами, потому что есть реплики из двух строк
	while i<=#messages do
		local trans
		trans=TranslateMessage(messages[i])
		if trans~=messages[i] then --Получили перевод реплики
			message=message..(i>1 and "\n" or "")..trans
			if i<#messages then --Если реплика не последняя
				--Переводим, если получится, следующую строку
				message=message..TranslateMessage("\n"..messages[i+1])
				--Собираем оставшиеся строки
				for k=i+2,#messages do message=message.."\n"..messages[k] end
			end
			break --выходим из цикла
		elseif i<#messages then --не получили, пытаемся объединить со следующей и перевести
			trans=TranslateMessage(messages[i].."\n"..messages[i+1])
			if trans~=messages[i].."\n"..messages[i+1] then --Получилось перевести обе
				--Добавляем перевод
				message=message..(i>1 and "\n" or "")..trans
				--Собираем оставшиеся строки
				for k=i+2,#messages do message=message.."\n"..messages[k] end
				break --выходим из цикла
			else--Обе не перевелись
				message=message..(i>1 and "\n" or "")..messages[i]
				i=i+1 --переходим к следующей реплике (она отдельно ещё не проверялась)
			end
		else --это была последняя, и она не перевелась
			message=message..(i>1 and "\n" or "")..messages[i]
			break
		end
	end
	return message
end



--Перевод сообщения на русский на стороне клиента
if rawget(_G,"Networking_Talk") then
	local OldNetworking_Talk=_G.Networking_Talk

	function Networking_Talk(guid, message, ...)
		-- print("Networking_Talk", guid, message, ...)
		local entity = _G.Ents[guid]
		message=t.TranslateToRussian(message,entity) or message --Переводим на русский
		if OldNetworking_Talk then OldNetworking_Talk(guid, message, ...) end
	end
	_G.Networking_Talk=Networking_Talk
end


--Перевод на русский произносимого на сервере
if _G.TheNet.Talker then
	_G.getmetatable(_G.TheNet).__index.Talker = (function()
		local oldTalker = _G.getmetatable(_G.TheNet).__index.Talker
		return function(self, message, entity, ... )
			oldTalker(self, message, entity, ...)
 
			local inst=entity and entity:GetGUID() or nil
			inst=inst and _G.Ents[inst] or nil --определяем инстанс персонажа по entity
			if inst and inst.components.talker.widget then --если он может говорить
				if message and type(message)=="string" then
					--Делаем одноразовую подмену для последующего задания текста, в котором осуществляем перевод.
					local OldSetString = inst.components.talker.widget.text.SetString
					function inst.components.talker.widget.text:SetString(str, ...)
						str = t.TranslateToRussian(str, inst) or str --переводим
						OldSetString(self, str, ...)
						self.SetString = OldSetString
					end
				end
			end
		end
	end)()
end

--Перевод на русский произносимого на сервере
--[[if _G.TheNet.Talker then
	_G.getmetatable(_G.TheNet).__index.Talker = (function()
		local oldTalker = _G.getmetatable(_G.TheNet).__index.Talker
		return function(self, message, entity, ... )
			oldTalker(self, message, entity, ...)

			local inst=entity and entity:GetGUID() or nil 
			inst=inst and _G.Ents[inst] or nil --определяем инстанс персонажа по entity
			if inst and inst.components.talker.widget then --если он может говорить
				message=t.TranslateToRussian(message,inst) or message --переводим
				print("translating to rusian:", message)
				if message and type(message)=="string" then
					inst.components.talker.widget.text:SetString(message) --меняем текст
					print("inst.components.talker.widget.text",inst.components.talker.widget.text)
				end
			end
		end
	end)()
end--]]

--Мамка не говорит фразы на русском, значит заставляем её.
AddClassPostConstruct("components/talker", function(self)
	local _Say = self.Say
	
	function self:Say(script, time, noanim, ...)
		local lines = type(script) == "string" and { _G.Line(script, noanim) } or script
		if lines ~= nil then
			for i, line in ipairs(lines) do
				local display_message = _G.GetSpecialCharacterPostProcess(
					self.inst.prefab,
					self.mod_str_fn ~= nil and self.mod_str_fn(line.message) or line.message
				)
			
				if self.inst.prefab=="quagmire_goatmum"	then
					print("Мамка сказала:", tostring(display_message))
					local mum=nil
					local j=0
					local sayings={"SNACK","MEAT","SOUP","VEGETABLE","FISH","BREAD","CHEESE","PASTA","DESSERT"}
					for i=1, #display_message do
						if string.sub(display_message,i,i)==" " or string.sub(display_message,i,i)=="!" or string.sub(display_message,i,i)=="," or  string.sub(display_message,i,i)=="." then
							if i~=j then
								mum=string.sub(display_message,j+1,i-1)
								j=i
								--print(mum)
							end
							
							if table.contains(sayings,mum) then
								print("Корммим мамку этим: "..tostring(mum))
							end
						end
					end
				end
			end
		end
		
		return _Say(self, script, time, noanim, ...)
	end
end)

local SKETCHES = 
{
    {item="chesspiece_pawn",        recipe="chesspiece_pawn_builder"},
    {item="chesspiece_rook",        recipe="chesspiece_rook_builder"},
    {item="chesspiece_knight",      recipe="chesspiece_knight_builder"},
    {item="chesspiece_bishop",      recipe="chesspiece_bishop_builder"},
    {item="chesspiece_muse",        recipe="chesspiece_muse_builder"},
    {item="chesspiece_formal",      recipe="chesspiece_formal_builder"},
    {item="chesspiece_deerclops",   recipe="chesspiece_deerclops_builder"},
    {item="chesspiece_bearger",     recipe="chesspiece_bearger_builder"},
    {item="chesspiece_moosegoose",  recipe="chesspiece_moosegoose_builder"},
    {item="chesspiece_dragonfly",   recipe="chesspiece_dragonfly_builder"},
}
AddPrefabPostInit("sketch",function(inst)
	if inst.sketchid and SKETCHES[inst.sketchid] and SKETCHES[inst.sketchid].recipe  and STRINGS.NAMES[string.upper(SKETCHES[inst.sketchid].recipe)] then 
		local newname ="Эскиз "..STRINGS.NAMES[string.upper(SKETCHES[inst.sketchid].recipe)]
		newname=newname:gsub("Фигура","фигуры")
		inst.components.named:SetName(newname)
		local oldOnLoad=inst.OnLoad
		inst.OnLoad=function(inst, data)
			oldOnLoad(inst, data)
			inst.components.named:SetName(inst.name:gsub("Фигура","фигуры"))
		end
	end
end)

--Тут мы должны переделать описание скелета, чтобы в него не попал русский
AddPrefabPostInit("skeleton_player", function(inst)
	local function reassignfn(inst) --функция переопределяет функцию. Туповато, но менять лень
		inst.components.inspectable.Oldgetspecialdescription=inst.components.inspectable.getspecialdescription
		function inst.components.inspectable.getspecialdescription(inst, viewer, ...)
			local oldGetDescription=_G.GetDescription
			_G.GetDescription=function(viewer1, inst1, tag)
				local ret=oldGetDescription(viewer1, inst1, tag)
				ret=t.ParseTranslationTags(ret, inst1.cause, nil, nil)
				return ret
			end
			local message=inst.components.inspectable.Oldgetspecialdescription(inst, viewer, ...)
			_G.GetDescription=oldGetDescription
			if not message then return message end

			local player=rawget(_G,"ThePlayer") or _G.GetPlayer()
			local key=player and player.prefab:upper() or "GENERIC"
--				local key=inst.char:upper()
			local deadgender=_G.GetGenderStrings(inst.char)
			local m=STRINGS.CHARACTERS[key] and STRINGS.CHARACTERS[key].DESCRIBE and STRINGS.CHARACTERS[key].DESCRIBE.SKELETON_PLAYER and STRINGS.CHARACTERS[key].DESCRIBE.SKELETON_PLAYER[deadgender] or STRINGS.CHARACTERS.GENERIC.DESCRIBE.SKELETON_PLAYER[deadgender]
			m=t.ParseTranslationTags(m, inst.cause, nil, nil)
			if not m then return message end
			local dead,killer=string.match(message,(string.gsub(m,"%%s","(.*)"))) --вытаскиваем имена из сообщения
			if not (m and dead and killer) then return message end

			dead=inst.playername or t.SpeechHashTbl.NAMES.Rus2Eng[dead] or dead --переводим на английский имя убитого
			if t.SpeechHashTbl.NAMES.Rus2Eng[killer] and inst.pkname == nil then
				local mentions=t.SpeechHashTbl.NAMES.Rus2Eng[killer]
				killerkey=t.SpeechHashTbl.NAMES.Eng2Key[mentions] --Получаем ключ имени убийцы
				print(killerkey)
				if not killerkey and key=="WX78" then --тут только полный перебор, т.к. он говорит всё в верхнем регистре
					for eng, key in pairs(t.SpeechHashTbl.NAMES.Eng2Key) do
						if eng:upper()==mentions then killerkey = key break end
					end
				end
				mentions=killerkey and STRINGS.NAMES[killerkey] or mentions
				if killerkey then
					mentions=t.RussianNames[mentions] and t.RussianNames[mentions]["KILL"] or rebuildname(mentions,"KILL",killerkey) or mentions
					if not t.ShouldBeCapped[killerkey:lower()] and not table.contains(_G.GetActiveCharacterList(), killerkey:lower()) then
						mentions=firsttolower(mentions)
					end
					killerkey=killerkey:lower()
					if table.contains(_G.GetActiveCharacterList(), killerkey) then killerkey=nil end
				end
				killer=mentions
			else
				killer=t.SpeechHashTbl.NAMES.Rus2Eng[killer] or killer --Переводим на английский имя убийцы
			end

			message=string.format(m,dead,killer)
			return message
		end
	end
	if inst.SetSkeletonDescription and not inst.OldSetSkeletonDescription then
		inst.OldSetSkeletonDescription=inst.SetSkeletonDescription
		function inst.SetSkeletonDescription(inst, ...)
			inst.OldSetSkeletonDescription(inst, ...)
			reassignfn(inst)
		end
	end
	if inst.OnLoad and not inst.OldOnLoad then
		inst.OldOnLoad=inst.OnLoad
		function inst.OnLoad(inst, ...)
			inst.OldOnLoad(inst, ...)
			reassignfn(inst)
		end
	end
end)


--Тут мы должны перехватывать название предмета у blueprint и переводить на английский
AddPrefabPostInit("blueprint", function(inst)
	local function reassignfn(inst)
		if inst.recipetouse then
			local name = STRINGS.NAMES[string.upper(inst.recipetouse)] or STRINGS.NAMES[inst.recipetouse]
			if name then
				name = t.SpeechHashTbl.NAMES.Rus2Eng[name] or name
				inst.components.named:SetName(name.." Blueprint")
			end
		end
	end
	if inst.OnLoad and not inst.OldOnLoad then
		inst.OldOnLoad=inst.OnLoad
		function inst.OnLoad(inst, data)
			if data and data.recipetouse and not STRINGS.NAMES[string.upper(data.recipetouse)] then
				STRINGS.NAMES[string.upper(data.recipetouse)]="Предмет из отключённого мода"
				inst.OldOnLoad(inst, data)
				STRINGS.NAMES[string.upper(data.recipetouse)]=nil
			else
				inst.OldOnLoad(inst, data)
			end
			reassignfn(inst)
		end
	end
	reassignfn(inst)
end)



--Вешает хук на любой метод класса указанного объекта.
--Функция fn получает в качестве параметров ссылку на объект и все параметры перехватываемого метода.
--DoAfter определяет, выполняется ли хук до, или после метода.
--Если функция fn выполняется до метода и возвращает результат, то этот результат считается таблицей и распаковывается в качестве параметров оригинального метода.
--ExecuteNow пригодится, если нужно выполнить действие сразу в момент установки хука.
local function SetHookFunction(obj, method, fn, DoAfter, ExecuteNow, ...)
	if obj and method and type(method)=="string" and fn and type(fn)=="function" then
		if ExecuteNow then fn(obj, ...) end
		if obj[method] then
			local Old=obj[method]
			obj[method]=function(obj, ...)
				local params={...}
				if not DoAfter then local a={fn(obj, ...)} if #a>0 then params=a end end
				Old(obj, _G.unpack(params))
				if DoAfter then fn(obj, ...) end
			end
		end
	end
end










--Остальное не выполняется, если перевод в режиме только чата
if t.CurrentTranslationType~=mods.RussianLanguagePack.TranslationTypes.ChatOnly then

	local function HookUpImage(img, DefaultAtlasPath, NewAtlasPath, ListToChange)
		if not img then return end
		local OldSetTexture = img.SetTexture
		function img.SetTexture(self, atlas, tex, default_tex, ...)
--			print("img.SetTexture")
			if atlas and tex then
				if atlas:sub(1,#DefaultAtlasPath)==DefaultAtlasPath then
					local name1 = atlas:sub(#DefaultAtlasPath+1,-5)
					local name2 = tex:sub(1,-5)
					if ListToChange[name1] and ListToChange[name1]==name2 then
--						print("atlas",atlas)
--						print("tex",tex)
--						print("name1",name1)
--						print("name2",name2)
						atlas = NewAtlasPath..name1..".xml"
						tex = "rus_"..tex
						default_tex = default_tex and tex --Не совсем корректно, зато точно не упадёт
					end
				end
			end
			local res = OldSetTexture(self, atlas, tex, default_tex, ...)
			return res
		end
		if img.atlas and img.texture then img:SetTexture(img.atlas, img.texture) end
	end

	--Подменяем портреты
	AddClassPostConstruct("widgets/characterselect", function(self)
		local charlist = {winona=1,wickerbottom=1,waxwell=1,willow=1,wilson=1,woodie=1,wes=1,wolfgang=1,wendy=1,wathgrithr=1,webber=1}
		local texnames = {locked="locked",random="random"}
		for name in pairs(charlist) do texnames[name] = name.."_none" end
		if self.heroportrait then HookUpImage(self.heroportrait, "bigportraits/", "images/rus_", texnames) end
		if self.leftsmallportrait then HookUpImage(self.leftsmallportrait.image, "bigportraits/", "images/rus_", texnames) end
		if self.leftportrait then HookUpImage(self.leftportrait.image, "bigportraits/", "images/rus_", texnames) end
		if self.rightportrait then HookUpImage(self.rightportrait.image, "bigportraits/", "images/rus_", texnames) end
		if self.rightsmallportrait then HookUpImage(self.rightsmallportrait.image, "bigportraits/", "images/rus_", texnames) end
	end)

	--Подменяем русские имена в лобби и правим другие мелочи
	--[[
	AddClassPostConstruct("screens/lobbyscreen", function(self)
		local charlist = {winona=1,wickerbottom=1,willow=1,wilson=1,woodie=1,wes=1,wolfgang=1,wendy=1,wathgrithr=1,webber=1,random=1}
		local texnames = {}
		for name in pairs(charlist) do texnames["names_"..name] = name end
		if self.heroname then HookUpImage(self.heroname, "images/", "images/rus_", texnames) end
		if 	self.disconnectbutton then
			self.disconnectbutton.text:Nudge({x=25,y=0,z=0})
			self.disconnectbutton.text_shadow:Nudge({x=25,y=0,z=0})
			self.disconnectbutton.text:SetSize( self.disconnectbutton.text.size-6 )
			self.disconnectbutton.text_shadow:SetSize( self.disconnectbutton.text_shadow.size-6 )
		end
		if self.loadout_title then
			self.loadout_title:SetString(STRINGS.UI.LOBBYSCREEN.LOADOUT_TITLE..self.loadout_title:GetString():sub(1,-#STRINGS.UI.LOBBYSCREEN.LOADOUT_TITLE-1))
		end
	end)]]

	local function ChangeNamesTex(module)
		AddClassPostConstruct(module, function(self)
			local charlist = {winona=1,wx78=1,waxwell=1,wickerbottom=1,willow=1,wilson=1,woodie=1,wes=1,wolfgang=1,wendy=1,wathgrithr=1,webber=1,random=1}
			local texnames = {}
			for name in pairs(charlist) do texnames["names_gold_"..name] = name end
			if self.heroname then HookUpImage(self.heroname, "images/", "images/rus_", texnames) end
		end)
	end
	ChangeNamesTex("widgets/redux/ovalportrait")
	ChangeNamesTex("widgets/redux/loadoutselect")
	ChangeNamesTex("screens/redux/wardrobescreen")

	--Двигаем портрет в гардеробе
	AddClassPostConstruct("screens/redux/wardrobescreen", function(self)
		if self.heroportrait then
			self.heroportrait:Nudge({x=-80,y=50,z=0})
		end
	end)
	
	AddClassPostConstruct("screens/redux/setpopupdialog", function(self)
		if self.dialog then
			self.dialog:SetSize(550,450)
		end
		for i = 1,self.max_num_items do
			self.input_item_imagetext[i]:Nudge({x=-50,y=0,z=0})
			self.input_item_imagetext[i].text:SetFont(_G.NEWFONT)
			local w,h = self.input_item_imagetext[i].text:GetRegionSize()
			self.input_item_imagetext[i].text:SetRegionSize(w+70, h)
			self.input_item_imagetext[i].text:Nudge({x=20,y=0,z=0})
			i = i + 1
	    end
	    self.reward.text:Nudge({x=20,y=0,z=0})
	    local w,h = self.reward.text:GetRegionSize()
	    self.reward.text:SetRegionSize(w+70, h)

	    self.reward.text:SetFont(_G.NEWFONT)
	end)

	--Фиксим менюшку обзора игрока
	AddClassPostConstruct("screens/redux/playersummaryscreen", function(self)
		if self.new_items and self.new_items.items and self.new_items.items.text and self.new_items.items.text.SetRegionSize then
			self.new_items.items.text:SetRegionSize(200, 80)
			self.new_items.items.text:Nudge({x=-50,y=0,z=0})
			-- local old = self.new_items.UpdateItems
			-- self.new_items.UpdateItems = function()
			-- 	old()
			-- 	self.new_items.items.text:SetString("Декоративный столик \"Драконья муха\"")
			-- end
		end
		if self.most_died and self.most_died.name and self.most_died.name.SetRegionSize then 
			if self.most_died.name.GetRegionSize then
				local w,h = self.most_died.name:GetRegionSize()
				self.most_died.name:SetRegionSize(w+100,h+50)
			else
				self.most_died.name:SetRegionSize(400,100)
			end
		end
	end)

	--Подменяем русские имена в виджете внешнего вида персонажа
	AddClassPostConstruct("widgets/playeravatarpopup", function(self)
		local charlist = {winona=1,wickerbottom=1,willow=1,wilson=1,woodie=1,wes=1,wolfgang=1,wendy=1,wathgrithr=1,webber=1,random=1}
		local texnames = {}
		for name in pairs(charlist) do texnames["names_"..name] = name end
		if self.character_name then HookUpImage(self.character_name, "images/", "images/rus_", texnames) end
	end)
	--[[
	AddClassPostConstruct("screens/skinsscreen", function(self)
		if self.title and self.title:GetString():sub(-#STRINGS.UI.SKINSSCREEN.TITLE)==STRINGS.UI.SKINSSCREEN.TITLE then
			self.title:SetString(STRINGS.UI.SKINSSCREEN.TITLE..self.title:GetString():sub(1,-#STRINGS.UI.SKINSSCREEN.TITLE-1))
		end
	end)]]

	AddClassPostConstruct("screens/playerstatusscreen", function(self)
		if self.OnBecomeActive then
			local OldOnBecomeActive = self.OnBecomeActive
			function self:OnBecomeActive(...)
				local res = OldOnBecomeActive(self, ...)
					if self.player_widgets then
						for _, v in pairs(self.player_widgets) do
							if v.age and v.age.SetString then
								local OldSetString = v.age.SetString
								function v.age:SetString(str, ...)
									if str then
										str = str:gsub("(%d+)(.+)", function (days, word)
											if word~=STRINGS.UI.PLAYERSTATUSSCREEN.AGE_DAY and word~=STRINGS.UI.PLAYERSTATUSSCREEN.AGE_DAYS then return end
											return days.." "..StringTime(days)
										end)
									end
									local res = OldSetString(self, str, ...)
									return res
								end
								v.age:SetString(v.age:GetString())
							end
						end
					end
				return res
			end
		end
	end)
	
	AddClassPostConstruct("widgets/uiclock", function(self)
		if self._text and self._text.SetString then
			local OldSetString = self._text.SetString
			function self._text:SetString(str, ...)
				if str then
					str = str:gsub(STRINGS.UI.HUD.CLOCKSURVIVED.."(.+)(%d+)(%s+)(.+)", function (sep1, days, sep2, word)
						if word~=STRINGS.UI.HUD.CLOCKDAY and word~=STRINGS.UI.HUD.CLOCKDAYS then return end
						return StringTime(days, {"Прожит", "Прожито", "Прожиты"})..sep1..days..sep2..StringTime(days)
					end)
				end
				local res = OldSetString(self, str, ...)
				return res
			end
		end
	end)
	
	AddClassPostConstruct("widgets/playeravatarpopup", function(self)
		self.oldUpdateEquipWidgetForSlot=self.UpdateEquipWidgetForSlot
		self.UpdateEquipWidgetForSlot=function(b,image_group, slot, name)
			if not image_group._text.OldSetMultilineTruncatedString then
				image_group._text.OldSetMultilineTruncatedString = image_group._text.SetMultilineTruncatedString
				if image_group._text.OldSetMultilineTruncatedString then
					image_group._text.SetMultilineTruncatedString = function(s,str, maxlines, maxwidth, maxcharsperline, ellipses)
						maxwidth = maxwidth+20
						image_group._text.OldSetMultilineTruncatedString(s,str, maxlines, maxwidth, maxcharsperline, ellipses)
					end
				end
			end
			self.oldUpdateEquipWidgetForSlot(b,image_group, slot, name)
		end

		self.oldUpdateData=self.UpdateData
		function self:UpdateData(data)
			--data.playerage=21
			self:oldUpdateData(data)
			if self.age and data.playerage then
				local newstr=self.age:GetString()
				newstr=newstr:gsub("Прожито",StringTime(data.playerage, {"Прожит", "Прожито", "Прожиты"}),1)
				self.age:SetString(newstr:gsub("Дней",StringTime(data.playerage),1))
			end
		end
		-- if self.age then
		-- 	local OldSetString = self.age.SetString
		-- 	function self.age:SetString(str, ...)
		-- 		if str then
		-- 			str = str:gsub(STRINGS.UI.PLAYER_AVATAR.AGE_SURVIVED.."(.+)(%d+)(%s+)(.+)", function (sep1, days, sep2, word)
		-- 				if word~=STRINGS.UI.PLAYER_AVATAR.AGE_DAY and word~=STRINGS.UI.PLAYER_AVATAR.AGE_DAYS then return end
		-- 				return StringTime(days, {"Прожит", "Прожито", "Прожиты"})..sep1..days..sep2..StringTime(days)
		-- 			end)
		-- 		end
		-- 		local res = OldSetString(self, str, ...)
		-- 		return res
		-- 	end
		-- 	self.age:SetString(self.age:GetString())
		-- end
	end)

	--Переводим названия дней недели
	if _G.TheNet.ListSnapshots then
		_G.getmetatable(_G.TheNet).__index.ListSnapshots = (function()
			local oldListSnapshots = _G.getmetatable(_G.TheNet).__index.ListSnapshots
			return function(self, ...)
				local list=oldListSnapshots(self, ...)
				if list and #list>0 and list[1].timestamp then
					local daysofweek={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"}
					local rusdaysofweek={"Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье"}
					local rusdaysofweek3={"Пнд","Втр","Срд","Чтв","Птн","Сбт","Вск"}
					for _,v in ipairs(list) do
						for ii,vv in ipairs(daysofweek) do
							if string.sub(v.timestamp,1,#vv):lower()==vv:lower() then
								v.timestamp=rusdaysofweek[ii]..string.sub(v.timestamp,#vv+1)
								break
							elseif string.sub(v.timestamp,1,3):lower()==string.sub(vv,1,3):lower() then
								v.timestamp=rusdaysofweek3[ii]..string.sub(v.timestamp,4)
								break
							elseif string.sub(v.timestamp,1,2):lower()==string.sub(vv,1,2):lower() then
								v.timestamp=string.sub(rusdaysofweek3[ii],1,2)..string.sub(v.timestamp,3)
								break
							end

						end
					end
				end
				return list
			end
		end)()
	end


	--Окно просмотра серверов, двигаем контролсы, исправляем надписи
	local function ServerListingScreenPost1(self)
		if self.filters then
			for i, v in pairs(self.filters) do 
				if v.label and v.label.SetFont then
					v.label:SetFont(_G.CHATFONT)
				end
				if v.spinner and v.spinner.SetFont then
					v.spinner:SetFont(_G.CHATFONT)
				end
			end
		end
		if self.title then
			local checkstr = STRINGS.UI.SERVERLISTINGSCREEN.SERVER_LIST_TITLE_INTENT:gsub("%%s", "(.+)")
			local intentions = {}
			for key, str in pairs(STRINGS.UI.INTENTION) do intentions[str] = key end
			local OldSetString = self.title.SetString
			function self.title:SetString(str, ...)
				if str then
					local int = str:match(checkstr)
					if int and intentions[int] then
						if intentions[int]=="SOCIAL" then
							str = "Дружеские сервера"
						elseif intentions[int]=="COOPERATIVE" then
							str = "Командные сервера"
						elseif intentions[int]=="COMPETITIVE" then
							str = "Соревновательные сервера"
						elseif intentions[int]=="MADNESS" then
							str = "Сервера типа «Безумие»"
						elseif intentions[int]=="ANY" then
							str = "Сервера всех стилей"
						end
					end
				end
				local res = OldSetString(self, str, ...)
				return res
			end
			self.title:SetString(self.title:GetString())
		end
		if self.sorting_spinner and self.sorting_spinner.label then
			self.sorting_spinner.label:Nudge({x=-40,y=0,z=0})
			self.sorting_spinner.label:SetRegionSize(150,50)
		end
		if self.season_description and self.season_description.text then
			local OldSetString = self.season_description.text.SetString
			if OldSetString then
				function self.season_description.text:SetString(str, ...)
					if str:find("Лето")~=nil then
						if str:find("Ранняя")~=nil then
							str=str:gsub("Ранняя","Раннее")
						elseif str:find("Поздняя")~=nil then
							str=str:gsub("Поздняя","Позднее")
						end
					end
					local res = OldSetString(self, str, ...)
					return res
				end
			end
		end
	end
	AddClassPostConstruct("screens/redux/serverlistingscreen", ServerListingScreenPost1)

	AddClassPostConstruct("screens/serverlistingscreen", function(self)
		if self.nav_bar and self.nav_bar.title then
			local w, h = self.nav_bar.title:GetRegionSize()
			self.nav_bar.title:SetRegionSize(w+50, h)
		end
		if self.join_button then
			self.join_button.text:SetSize(33)
		end
		if self.NAME and self.NAME.text and self.NAME.arrow then
			self.NAME.text:Nudge({x=20,y=0,z=0})
			self.NAME.arrow:Nudge({x=20,y=0,z=0})
		end
		if self.DETAILS and self.DETAILS.arrow and self.DETAILS.text then
				self.DETAILS.text:Nudge({x=15,y=0,z=0})
				self.DETAILS.arrow:Nudge({x=13,y=0,z=0})
		end
		if self.PLAYERS and self.PLAYERS.text then
				self.PLAYERS.text:Nudge({x=2,y=0,z=0})
		end
		if self.PING and self.PING.text then
				self.PING.text:Nudge({x=3,y=0,z=0})
		end
		if self.title then
			local checkstr = STRINGS.UI.SERVERLISTINGSCREEN.SERVER_LIST_TITLE_INTENT:gsub("%%s", "(.+)")
			local intentions = {}
			for key, str in pairs(STRINGS.UI.INTENTION) do intentions[str] = key end
			local OldSetString = self.title.SetString
			function self.title:SetString(str, ...)
				if str then
					local int = str:match(checkstr)
					if int and intentions[int] then
						if intentions[int]=="SOCIAL" then
							str = "Дружеские сервера"
						elseif intentions[int]=="COOPERATIVE" then
							str = "Командные сервера"
						elseif intentions[int]=="COMPETITIVE" then
							str = "Соревновательные сервера"
						elseif intentions[int]=="MADNESS" then
							str = "Сервера типа «Безумие»"
						elseif intentions[int]=="ANY" then
							str = "Сервера всех стилей"
						end
					end
				end
				local res = OldSetString(self, str, ...)
				return res
			end
			self.title:SetString(self.title:GetString())
		end
		if self.server_count then
			local OldSetString = self.server_count.SetString
			if OldSetString then
				function self.server_count:SetString(str, ...)
					if str and str:sub(-#STRINGS.UI.SERVERLISTINGSCREEN.SHOWING-1)==STRINGS.UI.SERVERLISTINGSCREEN.SHOWING..")" then
						str = "("..STRINGS.UI.SERVERLISTINGSCREEN.SHOWING.." "..str:sub(2, -#STRINGS.UI.SERVERLISTINGSCREEN.SHOWING-3)..")"
						str = str:gsub(STRINGS.UI.SERVERLISTINGSCREEN.SHOWING.." (%d-) ",function(n)
							n = tonumber(n)
							if not n then return end
							local function StringTime2(n,s)
								local pl_type = n%10==1 and n%100~=11 and 1 or (n%10==2 and (n%100<10 or n%100>=20) and 2 or 3)
								s = s or {"Показан","Показано","Показаны"}
								return s[pl_type]
							end 
							return StringTime2(n).." "..tostring(n).." "
							
						end)
					end
					local res = OldSetString(self, str, ...)
					return res
				end
			end
		end
	end)

	AddClassPostConstruct("components/named_replica", function(self)
		local function OnNameDirtyMoose(inst)
			inst.name = inst.possiblenames[math.random(#inst.possiblenames)]
		end
		if self.inst.prefab=="moose" then
			self.inst.possiblenames={STRINGS.NAMES["MOOSE1"], STRINGS.NAMES["MOOSE2"]}
			self.inst:ListenForEvent("namedirty", OnNameDirtyMoose)
		end
	end)


	--Сохраняем непереведённый текст настроек приватности серверов в свойствах мира (см. ниже)
	local privacy_options = {}
	for i,v in pairs(STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY) do
		privacy_options[v] = i
	end

	--Баг разработчиков, не переводятся радиобаттоны в настройках при создании сервера
	AddClassPostConstruct("widgets/redux/serversettingstab", function(self)
		local oldRefreshPrivacyButtons = self.RefreshPrivacyButtons
		function self:RefreshPrivacyButtons()
			oldRefreshPrivacyButtons(self)
			for i,v in ipairs(self.privacy_type.buttons.buttonwidgets) do
				v.button.text:SetFont(_G.NEWFONT)
				v.button:SetTextSize(self.privacy_type.buttons.buttonsettings.font_size-2)
			end  
		end
		if self.privacy_type and self.privacy_type.buttons and self.privacy_type.buttons.buttonwidgets then
			for _,option in pairs(self.privacy_type.buttons.options) do
				if privacy_options[option.text] then
					option.text = STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY[ privacy_options[option.text] ]
				end
				
			end
			for i,v in ipairs(self.privacy_type.buttons.buttonwidgets) do
				v.button.text:SetFont(_G.NEWFONT)
				v.button:SetTextSize(self.privacy_type.buttons.buttonsettings.font_size-2)
			end   
		end
		if self.server_intention then
			self.server_intention.button.text:SetSize(23)
			self.server_intention.button.text:Nudge({x=-3,y=0,z=0})
		end
	end)

	--Сохраняем непереведённый текст настроек в свойствах мира (см. ниже)
	local SandboxMenuData = {}
	for i,v in pairs(STRINGS.UI.SANDBOXMENU) do
		SandboxMenuData[v] = i
	end


	--Виджет выбора свойств мира. Исправляем надписи, согласовываем слова
	AddClassPostConstruct("widgets/redux/worldcustomizationlist", function(self)
		if self.optionitems then
			for i,v in pairs(self.optionitems) do
				if v.heading_text then
					v.heading_text=v.heading_text:gsub(" World",": настройки мира")
					v.heading_text=v.heading_text:gsub(" Resources",": настройки ресурсов")
					v.heading_text=v.heading_text:gsub(" Food",": настройки еды")
					v.heading_text=v.heading_text:gsub(" Animals",": настройки животных")
					v.heading_text=v.heading_text:gsub(" Monsters",": настройки монстров")
				end
				if v.option and v.option.options then
					for ii,vv in pairs(v.option.options) do
						local txt=STRINGS.UI.SANDBOXMENU[t.SpeechHashTbl.SANDBOXMENU.Eng2Key[vv.text]]
						if txt then
							vv.text=txt
						else
							vv.text=vv.text:gsub("No Day","Без дня")
							vv.text=vv.text:gsub("No Dusk","Без вечера")
							vv.text=vv.text:gsub("No Night","Без ночи")
							vv.text=vv.text:gsub("Long Day","Длинный день")
							vv.text=vv.text:gsub("Long Dusk","Длинный вечер")
							vv.text=vv.text:gsub("Long Night","Длинная ночь")
							vv.text=vv.text:gsub("Only Day","Только день")
							vv.text=vv.text:gsub("Only Dusk","Только вечер")
							vv.text=vv.text:gsub("Only Night","Только ночь")
						end
					end
				end
				if v.GetChildren then
					for ii,vv in pairs(v:GetChildren()) do
						if vv.name and vv.name:upper()=="TEXT" then --Заголовки групп настроек
							local words = vv:GetString():split(" ")
							local res
							if #words==2 then
								local second = SandboxMenuData[ words[2] ]
								words[2] = STRINGS.UI.SANDBOXMENU[second] or words[2]
								if second and words[1]==STRINGS.UI.SANDBOXMENU.LOCATION.FOREST then
									if second=="CHOICEAMTDAY" then
										res = words[2].." в лесу"
									elseif second=="CHOICEMONSTERS" or second=="CHOICEANIMALS" or second=="CHOICERESOURCES" then
										res = words[2].." леса"
									elseif second=="CHOICEFOOD" or second=="CHOICECOOKED"then
										res = words[2]..", доступная в лесу"
									elseif second=="CHOICEMISC" then
										res = "Лесной "..firsttolower(words[2])
									end
								elseif second and words[1]==STRINGS.UI.SANDBOXMENU.LOCATION.CAVE then
									if second=="CHOICEAMTDAY" then
										res = words[2].." в пещерах"
									elseif second=="CHOICEMONSTERS" or second=="CHOICEANIMALS" or second=="CHOICERESOURCES" then
										res = words[2].." пещер"
									elseif second=="CHOICEFOOD" or second=="CHOICECOOKED"then
										res = words[2]..", доступная в пещерах"
									elseif second=="CHOICEMISC" then
										res = "Пещерный "..firsttolower(words[2])
									end
								elseif second and words[1]==STRINGS.UI.SANDBOXMENU.LOCATION.UNKNOWN then
									if second=="CHOICEAMTDAY" then
										res = words[2].." в каком-то мире"
									elseif second=="CHOICEMONSTERS" or second=="CHOICEANIMALS" or second=="CHOICERESOURCES" then
										res = words[2].." какого-то мира"
									elseif second=="CHOICEFOOD" or second=="CHOICECOOKED"then
										res = words[2]..", доступная в каком-то мире"
									elseif second=="CHOICEMISC" then
										res = words[1].." "..firsttolower(words[2])
									end
								end
							end
							if res then vv:SetString(res) end
						elseif vv.name and vv.name:upper()=="OPTION" then --Спиннеры, нужно перевести в них текст
							for iii,vvv in pairs(vv:GetChildren()) do
								if vvv.name and vvv.name:upper()=="SPINNER" then
									for _,opt in ipairs(vvv.options) do
										if SandboxMenuData[opt.text] then
											opt.text = STRINGS.UI.SANDBOXMENU[ SandboxMenuData[opt.text] ]
										elseif opt.text then
											local words = opt.text:split(" ")
											for idx, txt in ipairs(words) do
												local p = SandboxMenuData[txt]
												words[idx] = p and STRINGS.UI.SANDBOXMENU[p] or words[idx]
											end
											if words[2]==STRINGS.UI.SANDBOXMENU.DAY then
												if words[1]==STRINGS.UI.SANDBOXMENU.EXCLUDE then words= {"Без","дня"}
												elseif words[1]==STRINGS.UI.SANDBOXMENU.SLIDELONG then words[1]="Долгий" end
											elseif words[2]==STRINGS.UI.SANDBOXMENU.DUSK then
												if words[1]==STRINGS.UI.SANDBOXMENU.EXCLUDE then words= {"Без","вечера"}
												elseif words[1]==STRINGS.UI.SANDBOXMENU.SLIDELONG then words[1]="Долгий" end
											elseif words[2]==STRINGS.UI.SANDBOXMENU.NIGHT then
												if words[1]==STRINGS.UI.SANDBOXMENU.EXCLUDE then words= {"Без","ночи"}
												elseif words[1]==STRINGS.UI.SANDBOXMENU.SLIDELONG then words[1]="Долгая" end
											end
											opt.text = words[1] or opt.text
											for idx=2,#words do opt.text = opt.text.." "..firsttolower(words[idx]) end
										end
									end
									vvv:UpdateState()
								elseif vvv.name and vvv.name:upper()=="IMAGEPARENT" then
									local list={["day.tex"]=1,
												["season.tex"]=1,
												["season_start.tex"]=1,
												["world_size.tex"]=1,
												["world_branching.tex"]=1,
												["world_loop.tex"]=1,
												["world_map.tex"]=1,
												["world_start.tex"]=1,
												["winter.tex"]=1,
												["summer.tex"]=1,
												["autumn.tex"]=1,
												["spring.tex"]=1}
									for iiii,vvvv in pairs(vvv:GetChildren()) do
										if vvvv.name and vvvv.name:upper()=="IMAGE" then
											if list[vvvv.texture] then
												vvvv:SetTexture("images/rus_mapgen.xml", "rus_"..vvvv.texture)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end)


	--Сохраняем непереведённый текст пресетов настроек в свойствах мира (см. ниже)
	local PresetLevels = {}
	for i,v in pairs(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS) do
		PresetLevels[v] = i
	end
	for i,v in pairs(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC) do
		PresetLevels[v] = i
	end

	--Баг разработчиков: Не переведённые пресеты
	AddClassPostConstruct("widgets/redux/worldcustomizationtab", function(self)
		local Levels = require "map/levels"
		local oldGetDataForLevelID=Levels.GetDataForLevelID
		Levels.GetDataForLevelID=function(id, nolocation)
			local ret = oldGetDataForLevelID(id, nolocation)
			if ret and STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[id] then
				ret.desc=STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC[id]
				ret.name=STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[id]
			end
			return ret
		end
		function self:UpdatePresetInfo(level)
			if level ~= self.currentmultilevel -- this might be called for the "unselected" level, so we don't want to do anything.
			    or not self:IsLevelEnabled(level) -- invalid so we can't show anything.
			    then
			    return
			end

		    local clean = self:GetNumberOfTweaks(self.currentmultilevel) == 0

		    if not self.allowEdit then
		    	
		    	local levelid=self.slotoptions[self.slot][self.currentmultilevel].id
		    	self.slotoptions[self.slot][self.currentmultilevel].desc=STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC[levelid]
		    	self.slotoptions[self.slot][self.currentmultilevel].name=STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[levelid]
		        self.presetdesc:SetString(self.slotoptions[self.slot][self.currentmultilevel].desc)
		        --print(self.slotoptions[self.slot][self.currentmultilevel].name)
		        self.presetspinner.spinner:UpdateText(self.slotoptions[self.slot][self.currentmultilevel].name)
		    elseif clean then
		        self.presetdesc:SetString(Levels.GetDataForLevelID(self.current_option_settings[self.currentmultilevel].preset).desc)
		        --print(Levels.GetDataForLevelID(self.current_option_settings[self.currentmultilevel].preset).name)
		        self.presetspinner.spinner:UpdateText(Levels.GetDataForLevelID(self.current_option_settings[self.currentmultilevel].preset).name)
		    elseif self.current_option_settings[self.currentmultilevel].preset == "MOD_MISSING" then
		        self.presetdesc:SetString(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC.MOD_MISSING)
		        self.presetspinner.spinner:UpdateText(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS.MOD_MISSING)
		    else
		        self.presetdesc:SetString(STRINGS.UI.CUSTOMIZATIONSCREEN.CUSTOMDESC)
		        self.presetspinner.spinner:UpdateText(string.format(STRINGS.UI.CUSTOMIZATIONSCREEN.CUSTOM, Levels.GetDataForLevelID(self.current_option_settings[self.currentmultilevel].preset).name))
		    end

		    if self.allowEdit then
		        self.revertbutton:Show()
		        self.savepresetbutton:Show()
		    else
		        self.revertbutton:Hide()
		        self.savepresetbutton:Hide()
		    end

		    if not clean and self.allowEdit then
		        self.revertbutton:Unselect()
		    else
		        self.revertbutton:Select()
		    end
		end
	end)


	--согласовываем слово "дней" с количеством дней
	AddClassPostConstruct("widgets/worldresettimer", function(self)
		if self.countdown_message then self.countdown_message:SetSize(27) end
		SetHookFunction(self.countdown_message, "SetString", function(self, str)
			local val=tonumber((str or ""):match(" ([^ ]*)$"))
			return str..(val and " "..StringTime(val,{"секунду","секунды","секунд"}) or "")
		end, false, true, self.countdown_message and self.countdown_message:GetString())

		if self.survived_message then self.survived_message:SetSize(27) end
		self.oldStartTimer=self.StartTimer
		function self:StartTimer()
			self:oldStartTimer()
			if self.survived_message then
				local age = self.owner.Network:GetPlayerAge()
				local newmsg=self.survived_message:GetString()
				self.survived_message:SetString(newmsg:gsub("дней",StringTime(age),1))
			end
		end
		-- SetHookFunction(self.survived_message, "SetString", function(self, str)
		-- 	local val=tonumber((str or ""):match(" ([^ ]*)$"))
		-- 	return str..(val and " "..StringTime(val) or "")
		-- end, false, true, self.survived_message and self.survived_message:GetString())
	end)

end-- для if t.CurrentTranslationType~=t.TranslationTypes.ChatOnly


--Меняем размер текста на кнопочках
--[[	AddClassPostConstruct("screens/serveradminscreen", function(self)
	SetHookFunction(self.clear_button, "Disable", function(self) self:SetTextSize(35) end, true, self.clear_button and not self.clear_button:IsEnabled())
	SetHookFunction(self.undo_button, "Disable", function(self) self:SetTextSize(35) end, true, self.clear_button and not self.undo_button:IsEnabled())
end)]]






--Проверяем наличие пустых строк, которые специальным образом маркируются на Notabenoid
for i,v in pairs(t.PO) do
	if v=="<пусто>" then t.PO[i]="" end
end











--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------



--Перегоняем перевод в STRINGS
_G.TranslateStringTable(_G.STRINGS)



local function fixupper()
	print("fixupper begin")
	local f = io.open(MODROOT.."russian_new_.po")
	local content = f:read("*all")
	f:close()
	local c = _G.deepcopy(t.ShouldBeCapped)
	content = content:gsub('"STRINGS%.NAMES%.([^"]+)"(.-)msgstr "([^"]+)"', function(key, data, rus)
		local found = false
		local endadder = ""
		if t.RussianNames[rus] then
			for act, list in pairs(t.ActionsToSave) do
				for _,rec in ipairs(list) do
					if rec.pth==key then
						if rebuildname(rus, act, key:lower())~=rec.trans then
							local a = act=="DEFAULTACTION" and "case."..t.AdjectiveCaseTags[t.DefaultActionCase]:upper() or "form."..act:upper()
							endadder = endadder..(endadder~="" and '"\n"' or "").."{"..a.."="..rec.trans.."}"
							found = true
						else
							print('Found redundant normal form "'..rec.trans..'" for '..act:upper()..' action of '..rus..' ('..key..'). Skipping.')
						end
						break
					end
				end
			end
		end
		local adder2 = ""
		if c[key:lower()] then
			c[key:lower()] = nil
			adder2 = "{forcecase}"
			found = true
		end
		for gender, tbl in pairs(t.NamesGender) do
			local gen = gender
			if gen=="he" then gen = "male" end
			if gen=="he2" then gen = "maleanimated" end
			if gen=="she" then gen = "female" end
			if gen=="it" then gen = "neutral" end
			if gen=="plural2" then gen = "pluralanimated" end
			if tbl[key:lower()] then
				adder2 = adder2.."{gender="..gen.."}"
				found = true
			end
		end
		if adder2~="" then adder2 = '"\n"'..adder2 end
		if endadder~="" then endadder = '"\n"'..endadder end
		if found then
			return '"STRINGS.NAMES.'..key..'"'..data..'msgstr "'..((adder2~="" or endadder~="")and '"\n"' or '')..rus..adder2..endadder..'"'
		end
	end)
	print("NOT FOUND in uppercase:")
	dumptable(c)
	local f = io.open(MODROOT.."russian_new2.po", "w")
	f:write(content)
	f:close()
	print("fixupper end")
end

--fixupper()









--Функция меняет окончания прилагательного prefix в зависимости от падежа, пола и числа предмета
function FixPrefix(prefix, act, item)
	if not t.NamesGender then return prefix end
--	prefix=prefix.." "
	local soft23={["г"]=1,["к"]=1,["х"]=1}
	
	local soft45={["г"]=1,["ж"]=1,["к"]=1,["ч"]=1,["х"]=1,["ш"]=1,["щ"]=1}
	local endings={}
	--Таблица окончаний в зависимости от действия и пола
	--case2 и case3, а так же case4 и case5 — твёрдый и мягкий пары
				-- влажный      синий  скользкий    простой    большой
	--Именительный Кто? Что?
	endings["nom"]={
		he=		{case1="ый",case2="ий",case3="ий",case4="ой",case5="ой"},
		he2=	{case1="ый",case2="ий",case3="ий",case4="ой",case5="ой"},
		she=	{case1="ая",case2="ая",case3="ая",case4="ая",case5="ая"},
		it=		{case1="ое",case2="ее",case3="ое",case4="ое",case5="ое"},
		plural=	{case1="ые",case2="ие",case3="ие",case4="ые",case5="ие"},
		plural2={case1="ые",case2="ие",case3="ие",case4="ые",case5="ие"}}
	--Винительный Кого? Что?
	endings["acc"]={
		he=		{case1="ый",case2="ий",case3="ий",case4="ой",case5="ой"},
		he2=	{case1="ого",case2="его",case3="ого",case4="ого",case5="ого"},
		she=	{case1="ую",case2="ую",case3="ую",case4="ую",case5="ую"},
		it=		{case1="ое",case2="ее",case3="ое",case4="ое",case5="ое"},
		plural=	{case1="ые",case2="ие",case3="ие",case4="ые",case5="ие"},
		plural2={case1="ых",case2="их",case3="их",case4="ых",case5="их"}}
	--Дательный Кому? Чему?
	endings["dat"]={
		he=		{case1="ому",case2="ему",case3="ому",case4="ому",case5="ому"},
		he2=	{case1="ому",case2="ему",case3="ому",case4="ому",case5="ому"},
		she=	{case1="ой",case2="ей",case3="ой",case4="ой",case5="ой"},                          
		it=		{case1="ому",case2="ему",case3="ому",case4="ому",case5="ому"},
		plural=	{case1="ым",case2="им",case3="им",case4="ым",case5="им"},
		plural2={case1="ым",case2="им",case3="им",case4="ым",case5="им"}}
	--Творительный Кем? Чем?
	endings["abl"]={
		he=		{case1="ым",case2="им",case3="им",case4="ым",case5="им"},
		he2=	{case1="ым",case2="им",case3="им",case4="ым",case5="им"},
		she=	{case1="ой",case2="ей",case3="ой",case4="ой",case5="ой"},
		it=		{case1="ым",case2="им",case3="им",case4="ым",case5="им"},
		plural=	{case1="ыми",case2="ими",case3="ими",case4="ыми",case5="ими"},
		plural2=	{case1="ыми",case2="ими",case3="ими",case4="ыми",case5="ими"}}
	--Родительный Кого? Чего?
	endings["gen"]={
		he=		{case1="ого",case2="его",case3="ого",case4="ого",case5="ого"},
		he2=	{case1="ого",case2="его",case3="ого",case4="ого",case5="ого"},
		she=	{case1="ой",case2="ей",case3="ой",case4="ой",case5="ой"},
		it=		{case1="ого",case2="его",case3="ого",case4="ого",case5="ого"},
		plural=	{case1="ых",case2="их",case3="их",case4="ых",case5="их"},
		plural2={case1="ых",case2="их",case3="их",case4="ых",case5="их"}}
	--Предложный О ком? О чём?
	endings["loc"]={
		he=		{case1="ом",case2="ем",case3="ом",case4="ом",case5="ом"},
		he2=	{case1="ом",case2="ем",case3="ом",case4="ом",case5="ом"},
		she=	{case1="ой",case2="ей",case3="ой",case4="ой",case5="ой"},
		it=		{case1="ом",case2="ем",case3="ом",case4="ом",case5="ом"},
		plural=	{case1="ых",case2="их",case3="их",case4="ых",case5="их"},
		plural2={case1="ых",case2="их",case3="их",case4="ых",case5="их"}}
		
	--дополнительные поля под различные действия в игре
	endings["NOACTION"] = endings["nom"]
	endings["DEFAULTACTION"] = endings["acc"]
	endings["WALKTO"] = endings["dat"]
	endings["SLEEPIN"] = endings["loc"]
	
	--Определим пол
	local gender="he"
	if endings["nom"][item] then --Если item содержит непосредственно пол
		gender = item
	else
		if t.NamesGender["he2"][item] then gender="he2"
		elseif t.NamesGender["she"][item] then gender="she"
		elseif t.NamesGender["it"][item] then gender="it"
		elseif t.NamesGender["plural"][item] then gender="plural"
		elseif t.NamesGender["plural2"][item] then gender="plural2" end
	end

	--Особый случай. Для действия "Собрать" у меня есть три записи с заменённым текстом. Там получается множественное число.
	if act=="PICK" and item and t.RussianNames[STRINGS.NAMES[string.upper(item)]] and t.RussianNames[STRINGS.NAMES[string.upper(item)]][act] then gender="plural" end
	--Ищем переданное действие в таблице выше

	act = endings[act] and act or (item and "DEFAULTACTION" or "nom")
	
	local words=string.split(prefix," ") --разбиваем на слова
	prefix=""
	for _,word in ipairs(words) do
		if --[[isupper(word:utf8sub(1,1)) and ]]word:utf8len()>3 and word~="влагой" then
			--Заменяем по всем возможным сценариям
			if word:utf8sub(-2)=="ый" then
				word=word:utf8sub(1,word:utf8len()-2)..endings[act][gender]["case1"]
			elseif word:utf8sub(-2)=="ий" then
				if soft23[word:utf8sub(-3,-3)] then
					word=word:utf8sub(1,word:utf8len()-2)..endings[act][gender]["case3"]
				else
					word=word:utf8sub(1,word:utf8len()-2)..endings[act][gender]["case2"]
				end
			elseif word:utf8sub(-2)=="ой" then
				if soft45[word:utf8sub(-3,-3)] then
					word=word:utf8sub(1,word:utf8len()-2)..endings[act][gender]["case5"]
				else
					word=word:utf8sub(1,word:utf8len()-2)..endings[act][gender]["case4"]
				end
			end
		end
		prefix=prefix..word.." "
	end
	prefix=prefix:utf8sub(1,1)..russianlower(prefix:utf8sub(2,-2))
	return prefix
end


if t.CurrentTranslationType~=t.TranslationTypes.ChatOnly then --Выполняем, если не только чат

	if t.CurrentTranslationType~=t.TranslationTypes.InterfaceChat then
		--Ниже идут функции непосредственного склонения предметов и формирования названий
		-- выполняем если не "только чат" и не "интерфейс/чат" (т.е. если перевод полный)


		--Подменяем имена персонажей, создаваемых с консоли в игре.
		local OldSetPrefabName = _G.EntityScript.SetPrefabName
		function _G.EntityScript:SetPrefabName(name,...)
			OldSetPrefabName(self,name,...)
			if not self.entity:HasTag("player") then return end
			self.name=t.SpeechHashTbl.NAMES.Rus2Eng[self.name] or self.name
		end



		local GetAdjectiveOld = _G.EntityScript["GetAdjective"]
		--Новая версия функции, выдающей качество предмета
		function GetAdjectiveNew(self)
			local str=GetAdjectiveOld(self)
			if str and self.prefab then
				local player=rawget(_G,"ThePlayer") or _G.GetPlayer()
				local act=player.components.playercontroller:GetLeftMouseAction() --Получаем текущее действие
				if act then act=act.action.id or "NOACTION" else act="NOACTION" end
				str=FixPrefix(str,act,self.prefab) --склоняем окончание префикса
				if act~="NOACTION" then --если есть действие, то нужно сделать с маленькой буквы
					str=firsttolower(str)
				end
			end
			return str
		end
		_G.EntityScript["GetAdjective"]=GetAdjectiveNew --подменяем функцию, выводящую качества продуктов



		--Фикс для hoverer, передающий в GetDisplayName действие, если оно есть
		AddClassPostConstruct("widgets/hoverer", function(self)
			if not self.OnUpdate then return end
			local OldOnUpdate=self.OnUpdate
			function self:OnUpdate(...)
				local changed = false
				local OldlmbtargetGetDisplayName
				local lmb = self.owner and self.owner.components and self.owner.components.playercontroller and self.owner.components.playercontroller:GetLeftMouseAction()
				if lmb and lmb.target and lmb.target.GetDisplayName then
					changed = true
					OldlmbtargetGetDisplayName = lmb.target.GetDisplayName
					lmb.target.GetDisplayName = function(self)
						return OldlmbtargetGetDisplayName(self, lmb)
					end
				end
				OldOnUpdate(self, ...)
				if changed then
					lmb.target.GetDisplayName = OldlmbtargetGetDisplayName
				end
			end
		end)



		local GetDisplayNameOld=_G.EntityScript["GetDisplayName"] --сохраняем старую функцию, выводящую название предмета
		function GetDisplayNameNew(self, act) --Подмена функции, выводящей название предмета. В ней реализовано склонение в зависимости от действия (переменная аct)

			local name = GetDisplayNameOld(self)
			local player = rawget(_G,"ThePlayer") or _G.GetPlayer()
			
		--	if not player then return name end --Если не удалось получить instance игрока, то возвращаем имя на англ. и выходим
			
		--	local act=player.components.playercontroller:GetLeftMouseAction() --Получаем текущее действие

			if self:HasTag("player") then
				if STRINGS.NAMES[self.prefab:upper()] then
					--Пытаемся перевести имя на русский, если это кукла, а не игрок
					if not(self.userid and (type(self.userid)=="string") and #self.userid>0)
						and name==t.SpeechHashTbl.NAMES.Rus2Eng[STRINGS.NAMES[self.prefab:upper()] ] then
						name=STRINGS.NAMES[t.SpeechHashTbl.NAMES.Eng2Key[name] ]
						act=act and act.action.id or "DEFAULT"
						name=(t.RussianNames[name] and (t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"])) or rebuildname(name,act,self.prefab) or name
					end
				end
				return name
			end

			local itisblueprint=false
			if name:sub(-10)==" Blueprint" then --Особое исключительное написание для чертежей
				name=name:sub(1,-11)
				name=t.SpeechHashTbl.NAMES.Eng2Key[name] and STRINGS.NAMES[t.SpeechHashTbl.NAMES.Eng2Key[name]] or name
				itisblueprint=true
			end
			--Проверим, есть ли префикс мокрости, засушенности или дымления
			local Prefix=nil
			if STRINGS.WET_PREFIX then
				for i,v in pairs(STRINGS.WET_PREFIX) do
					if type(v)=="string" and v~="" and string.sub(name,1,#v)==v then Prefix=v break end
				end 
				if string.sub(name,1,#STRINGS.WITHEREDITEM)==STRINGS.WITHEREDITEM then Prefix=STRINGS.WITHEREDITEM 
				elseif string.sub(name,1,#STRINGS.SMOLDERINGITEM)==STRINGS.SMOLDERINGITEM then Prefix=STRINGS.SMOLDERINGITEM 
				end

				if Prefix then --Нашли префикс. Меняем его и удаляем из имени для его дальнейшей корректной обработки
					name=string.sub(name,#Prefix+2)--Убираем префикс из имени
					if act then
						Prefix=FixPrefix(Prefix,act.action and act.action.id or "NOACTION",self.prefab)
						--Если есть действие, значит нужно сделать с маленькой буквы
						Prefix=firsttolower(Prefix)
					else 
						Prefix=FixPrefix(Prefix,"NOACTION",self.prefab)
						if self:GetAdjective() then
							Prefix=firsttolower(Prefix)
						end				
					end
				end
			end
			if name and self.prefab then --Для ДСТ нужно перевести имя свина или кролика на русский
				if self.prefab=="pigman" then 
					name=t.SpeechHashTbl.PIGNAMES.Eng2Rus[name] or name
				elseif self.prefab=="pigguard" then 
					name=t.SpeechHashTbl.PIGNAMES.Eng2Rus[name] or name
				elseif self.prefab=="bunnyman" then 
					name=t.SpeechHashTbl.BUNNYMANNAMES.Eng2Rus[name] or name
				elseif self.prefab=="quagmire_swampig" then 
					name=t.SpeechHashTbl.SWAMPIGNAMES.Eng2Rus[name] or name
				end
			end
			if act then --Если есть действие
				act=act.action.id

				if not itisblueprint then
					if t.RussianNames[name] then
						name=t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"] or rebuildname(name,act,self.prefab) or "NAME"
					else
						name=rebuildname(name,act,self.prefab)
					end
					if (not self.prefab or self.prefab~="pigman" and self.prefab~="pigguard" and self.prefab~="bunnyman" and self.prefab~="quagmire_trader_merm" and self.prefab~="quagmire_trader_merm2"  and self.prefab~="quagmire_swampigelder"  and self.prefab~="quagmire_goatmum" and self.prefab~="quagmire_goatkid" and self.prefab~="quagmire_swampig")
					 and not t.ShouldBeCapped[self.prefab] and name and type(name)=="string" and #name>0 then
						--меняем первый символ названия предмета в нижний регистр
						name=firsttolower(name)
					end
				else name="чертёж предмета \""..name.."\"" end

			else	--Если нет действия
					if itisblueprint then name="Чертёж предмета \""..name.."\"" end
				if not t.ShouldBeCapped[self.prefab] and (self:GetAdjective() or Prefix) then
					name=firsttolower(name)
				end
			end
			if Prefix then
				name=Prefix.." "..name
			end
			if act and act=="SLEEPIN" and name then name="в "..name end --Особый случай для "спать в палатке" и "спать в навесе для сиесты"
			return name
		end
		_G.EntityScript["GetDisplayName"]=GetDisplayNameNew --подменяем на новую


		AddClassPostConstruct("components/playercontroller", function(self)
			--Переопределяем функцию, выводящую "Создать ...", когда устанавливается на землю крафт-предмет типа палатки.
			--В старой функции у Klei ошибка. Нужно заменить self.player_recipe на self.placer_recipe
			local OldGetHoverTextOverride = self.GetHoverTextOverride
			if OldGetHoverTextOverride then
				function self:GetHoverTextOverride(...)
					if self.placer_recipe then
						local name = STRINGS.NAMES[string.upper(self.placer_recipe.name)]
						local act = "BUILD"
						if name then
							if t.RussianNames[name] then
								name = t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"] or rebuildname(name,act) or STRINGS.UI.HUD.HERE
							else
								name = rebuildname(name,act) or STRINGS.UI.HUD.HERE
							end
						else
							name = STRINGS.UI.HUD.HERE
						end
						if not t.ShouldBeCapped[self.placer_recipe.name] and name and type(name)=="string" and #name>0 then
							--меняем первый символ названия предмета в нижний регистр
							name = firsttolower(name)
						end
						return STRINGS.UI.HUD.BUILD.. " " .. name
		--				local res = OldGetHoverTextOverride(self, ...) 	
		--				return res
					end
				end
			end
		end)


	end --t.CurrentTranslationType~=t.TranslationTypes.InterfaceChat then







	--Дальше идут функции, отлкючённые только в режиме ChatOnly


	--Дядька, продающий скины должен склонять слова под названия вещей
	AddClassPostConstruct("widgets/skincollector", function(self)
		if not self.Say then return end
		if self.text then
			self.text:SetSize(self.text.size-5)
		end
		local OldSay = self.Say
		function self:Say(text, rarity, name, number, ...)
--			text = STRINGS.UI.TRADESCREEN.SKIN_COLLECTOR_SPEECH.RESULT[3]
--			name = _G.GetRandomItem(STRINGS.SKIN_NAMES)
--			text = STRINGS.UI.TRADESCREEN.SKIN_COLLECTOR_SPEECH.ADDMORE[4]
--			rarity = _G.GetRandomItem(STRINGS.UI.RARITY)
			if type(text) == "table" then 
				text = _G.GetRandomItem(text)
			end
			if text then
				local gender = "he"
				if name then --если есть название предмета, ищем его пол
					local key = table.reverselookup(STRINGS.SKIN_NAMES, name)
					if key then
						for gen, tbl in pairs(t.NamesGender) do
							if tbl[key:lower()] then gender = gen break end
						end
						name = russianlower(name)
					end
	--				text = string.gsub(text, "<item>", name)
				end
				if rarity then
					rarity = russianlower(rarity)
					text = string.gsub(text, "<rarity>", rarity) --заменим, чтобы парсились склонения (ниже)
				end
				--парсим теги
				if name or rarity then
					text = t.ParseTranslationTags(text, nil, nil, gender)
				end
			end
			return OldSay(self, text, rarity, name, number, ...)
		end
	end)


	--Увеличиваем область заголовка, чтобы не съедало буквы
	local function postintentionpicker(self)
		if self.headertext then
			local w,h = self.headertext:GetRegionSize()
			self.headertext:SetRegionSize(w,h+10)
		end
		--Не переводится. Значит переводим насильно
		local intention_options={{text='Дружеский'},{text='Командный'},{text='Агрессивный'},{text='Безумие'},}
		for i, v in ipairs(intention_options) do
			self.buttons[i]:SetText(intention_options[i].text)
		end
	end
	AddClassPostConstruct("widgets/intentionpicker", postintentionpicker)
	AddClassPostConstruct("widgets/redux/intentionpicker", postintentionpicker)


	--Исправляем жёстко зашитые надписи на кнопках в казане и телепорте.
	AddClassPostConstruct("widgets/containerwidget", function(self)
		self.oldOpen=self.Open
		local function newOpen(self, container, doer)
			self:oldOpen(container, doer)
			if self.button then
				if self.button:GetText()=="Cook" then self.button:SetText("Готовить") end
				if self.button:GetText()=="Activate" then self.button:SetText("Запустить") end
			end
		end
		self.Open=newOpen
	end)


	AddClassPostConstruct("widgets/recipepopup", function(self) --Уменьшаем шрифт описания рецепта в попапе рецептов
		if self.name and self.Refresh and not self.horizontal then --Перехватываем вывод названия, проверяем, вмещается ли оно, и если нужно, меняем его размер

			if not self.OldRefresh then
				self.OldRefresh=self.Refresh
				function self.Refresh(self,...)
					self:OldRefresh(...)
					if not self.name then return end
					if self.button and self.button.image then
						self.button.image:SetScale(.60, .7)
					end
					if self.bg and self.bg.light_box then
						self.bg.light_box:SetPosition(30, -42)
					end
					
					
					if (self.skins_options ~= nil and #self.skins_options == 1) or not self.skins_options then
						self.contents:SetPosition(-75,-20,0)
						self.name:SetPosition(320, 157, 0)
						self.button:SetPosition(320, -95, 0)
						self.teaser:SetPosition(320, -90, 0)
				    else
				    	self.name:SetPosition(320, 182, 0)
				    end
				    if not self.name.OldSetTruncatedString then
						self.name.OldSetTruncatedString = self.name.SetTruncatedString
						if self.name.OldSetTruncatedString then
							local function NewSetTruncatedString (self1,str, maxwidth, maxcharsperline, ellipses)
								maxcharsperline = 17
								maxwidth = maxwidth + 30
								local maxlines = 2
								self.name.SetTruncatedString=self.name.OldSetTruncatedString
								self.name:SetMultilineTruncatedString(str, maxlines, maxwidth, maxcharsperline, ellipses)
								self.name.SetTruncatedString=NewSetTruncatedString
							end
							self.name.SetTruncatedString=NewSetTruncatedString
						end
					end
					if self.desc then
						self.desc:SetSize(28)
						self.desc:SetRegionSize(64*3+30,130)
						if not self.desc.OldSetMultilineTruncatedString then
							self.desc.OldSetMultilineTruncatedString = self.desc.SetMultilineTruncatedString
							if self.desc.OldSetMultilineTruncatedString then
								self.desc.SetMultilineTruncatedString=function(self1,str, maxlines, maxwidth, maxcharsperline, ellipses)
									maxcharsperline = 24
									maxlines = 3
									self.desc.OldSetMultilineTruncatedString(self1,str, maxlines, maxwidth, maxcharsperline, ellipses)
								end
							end
						end
					end

				end
			end
		end
	end)

	--Зашифрованные строки загружаются после модов, поэтому сделал такой вот хак
	AddClassPostConstruct("widgets/redux/quagmire_recipebook", function(self)
		for i,v in pairs(STRINGS.NAMES) do
			if type(i)=="string" and string.find(i, "QUAGMIRE_FOOD_") then
				local key=i
				local val=v
				local fullkey = "STRINGS.NAMES."..key
				if t.PO[fullkey] then
					t.PO[fullkey] = ExtractMeta(t.PO[fullkey], key)
				end
				t.SpeechHashTbl.NAMES.Eng2Key[val] = key
				t.SpeechHashTbl.NAMES.Rus2Eng[t.PO[fullkey] or val] = val

				STRINGS.NAMES[i]=t.PO["STRINGS.NAMES."..i]
			end
		end
	end)
	AddPrefabPostInitAny(function(inst)
		if string.find(inst.prefab,'quagmire_food_') then
			local key=string.upper(inst.prefab)
			local val=STRINGS.NAMES[string.upper(inst.prefab)]
			local fullkey = "STRINGS.NAMES."..key
			if t.PO[fullkey] then
				t.PO[fullkey] = ExtractMeta(t.PO[fullkey], key)
			end
			t.SpeechHashTbl.NAMES.Eng2Key[val] = key
			t.SpeechHashTbl.NAMES.Rus2Eng[t.PO[fullkey] or val] = val
			
			STRINGS.NAMES[string.upper(inst.prefab)]=t.PO["STRINGS.NAMES."..string.upper(inst.prefab)]
			inst.name = STRINGS.NAMES[string.upper(inst.prefab)]
		end
	end)

	AddClassPostConstruct("widgets/writeablewidget", function(self)
		if self.menu and self.menu.items then
			local translations={["Cancel"]="Отмена",["Random"]="Случайно",["Write it!"]="Написать!"}
			for i,v in pairs(self.menu.items) do
				if v.text and translations[v.text:GetString()] then
					v.text:SetString(translations[v.text:GetString()])
				end
			end
		end
	end)

	--сочетаем слово "День" с количеством дней
	AddClassPostConstruct("widgets/truescrolllist", function(self) 
		local oldupdate_fn=self.update_fn
		self.update_fn=function(context, widget, data, index)
			oldupdate_fn(context, widget, data, index)
			if widget.opt_spinner and widget.opt_spinner.spinner.options then
				if data and data.option and data.option.image then
					local list={["day.tex"]=1,
						["season.tex"]=1,
						["season_start.tex"]=1,
						["world_size.tex"]=1,
						["world_branching.tex"]=1,
						["world_loop.tex"]=1,
						["world_map.tex"]=1,
						["world_start.tex"]=1,
						["winter.tex"]=1,
						["summer.tex"]=1,
						["autumn.tex"]=1,
						["spring.tex"]=1}
					if list[data.option.image] then
						widget.opt_spinner.image:SetTexture("images/rus_mapgen.xml", "rus_"..data.option.image)
						widget.opt_spinner.image:SetSize(70,70)
					end
				end
			end
			if data and data.item_type and widget.text then
				local x, y = widget.text:GetRegionSize()
				widget.text:SetRegionSize(x+30, y+20)
			end
			if data and data.days_survived and widget.DAYS_LIVED then
				local Text = require "widgets/text"
				widget.DAYS_LIVED:SetTruncatedString((data.days_survived or STRINGS.UI.MORGUESCREEN.UNKNOWN_DAYS).." "..StringTime(data.days_survived), widget.DAYS_LIVED._align.maxwidth, widget.DAYS_LIVED._align.maxchars, true)
			end
			if data and data.playerage and widget.PLAYER_AGE then
				local Text = require "widgets/text"
				local age_str = (data.playerage or STRINGS.UI.MORGUESCREEN.UNKNOWN_DAYS).." "..StringTime(tonumber(data.playerage))
				widget.PLAYER_AGE:SetTruncatedString(age_str, widget.PLAYER_AGE._align.maxwidth, widget.PLAYER_AGE._align.maxchars, true)
				if widget.SEEN_DATE and not widget.SEEN_DATE.RLPFixed then
					local OldSetString = widget.SEEN_DATE.SetString
					if OldSetString then
						local months = {Jan="Янв.",Feb="Февр.",Mar="Март",Apr="Апр.",May="Мая",Jun="Июня",Jul="Июля",Aug="Авг.",Sept="Сент.",Oct="Окт.",Nov="Нояб.",Dec="Дек."}
						function widget.SEEN_DATE:SetString(s, ...)
							s = s:gsub("(.-) (%d-), (%d-)",function(m, d, y)
								if not months[m] then return end
								return d.." "..months[m].." "..y
							end) or s
							local res = OldSetString(self, s, ...)
							return res
						end
						widget.SEEN_DATE.RLPFixed = true
						widget.SEEN_DATE:SetString(widget.SEEN_DATE:GetString())
					end
				end
			end
		end
	end)

	--Устарело
	--[[
	AddClassPostConstruct("screens/morguescreen", function(self) 
		if self.encounter_widgets then for _,v in ipairs(self.encounter_widgets) do
			if v.PLAYER_AGE and not v.PLAYER_AGE.RLPFixed then
				local x, y = v.PLAYER_AGE:GetRegionSize()
				v.PLAYER_AGE:SetRegionSize(x+20, y)
				local OldSetString = v.PLAYER_AGE.SetString
				if OldSetString then
					function v.PLAYER_AGE:SetString(s, ...)
						s = s:gsub("(%d-) (.*)",function(n,word)
							n = tonumber(n) or nil
							if not n then return end
							return tostring(n).." "..StringTime(n)
						end) or s
						local res = OldSetString(self, s, ...)
						return res
					end
					v.PLAYER_AGE.RLPFixed = true
					v.PLAYER_AGE:SetString(v.PLAYER_AGE:GetString())
				end
			end
			if v.SEEN_DATE and not v.SEEN_DATE.RLPFixed then
				local OldSetString = v.SEEN_DATE.SetString
				if OldSetString then
					local months = {Jan="Янв.",Feb="Февр.",Mar="Март",Apr="Апр.",May="Мая",Jun="Июня",Jul="Июля",Aug="Авг.",Sept="Сент.",Oct="Окт.",Nov="Нояб.",Dec="Дек."}
					function v.SEEN_DATE:SetString(s, ...)
						s = s:gsub("(.-) (%d-), (%d-)",function(m, d, y)
							if not months[m] then return end
							return d.." "..months[m].." "..y
						end) or s
						local res = OldSetString(self, s, ...)
						return res
					end
					v.SEEN_DATE.RLPFixed = true
					v.SEEN_DATE:SetString(v.SEEN_DATE:GetString())
				end
			end
		end end
	end)]]

	--Исправляем последовательность слов в заголовке окна настройки модов
	--[[
	AddClassPostConstruct("screens/modconfigurationscreen", function(self)
		for title,val in pairs(self.root.children) do
			if title.name and string.lower(title.name)=="text" then 
				local tmp=title:GetString()
				tmp=string.sub(tmp,1,#tmp-#STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX-1)
				title:SetString(STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX.." \""..tmp.."\"")
			end
		end
	end)]]


	--[[
	AddClassPostConstruct("screens/networkloginpopup", function(self)
		if self.menu and self.menu.items then
			for i,v in pairs(self.menu.items) do
				if v.text and v.text:GetString()==STRINGS.UI.MAINSCREEN.PLAYOFFLINE then 
					local sx, sy, sz = v.image.inst.UITransform:GetScale()
					v.image:SetScale(sx*1.15,sy)
					v:Nudge({x=10,y=0,z=0})
				end
			end
		end
	end)]]

	--Подвигаем всё красивенько в окне подписки
	AddClassPostConstruct("screens/emailsignupscreen", function(self)
		if self.bday_message then
			self.bday_message:SetSize(21)
			local dialog_width = 640
			local label_height = 40
			self.bday_message:SetRegionSize( dialog_width, label_height * 2+30 )
		end
		if self.bday_label then
			self.bday_label:SetSize(26)
			self.bday_label:Nudge({x=7,y=0,z=0})
		end
		if self.spinners then
			self.spinners:Nudge({x=10,y=0,z=0})
		end
	end)


	--Комплекс из двух подмен для того, чобы названия серверов слева в окне создания сервера были поменьше
	--Грязный хак, подменяем то, что, как нам кажется, будет только в ServerCreationScreen:MakeSaveSlotButton
	--Это нужно, чтобы строка оканчивалась тремя точками попозже, ведь шрифт будет поменьше
	if _G.FrontEnd and _G.FrontEnd.GetTruncatedString then
		local OldGetTruncatedString = _G.FrontEnd.GetTruncatedString
		function _G.FrontEnd:GetTruncatedString(str, font, size, maxwidth, maxchars, suffix, ...)
			if font==_G.NEWFONT and size==35 and maxwidth==140 and not maxchars and suffix then
				size = 28 --Надеюсь, это произойдёт только в ServerCreationScreen:MakeSaveSlotButton
			end
			local res = OldGetTruncatedString(self, str, font, size, maxwidth, maxchars, suffix, ...)
			return res
		end
	end
	--[[
	--Уменьшаем шрифт в окне создания сервера
	AddClassPostConstruct("screens/servercreationscreen", function(self)
		if self.save_slots then --Уменьшаем шрифт в слотах слева
			for _, slot in ipairs(self.save_slots) do
				if slot.SetTextSize then slot:SetTextSize(28) end
			end
		end
		if self.create_button then --Уменьшаем текст на кнопке "создать"
			self.create_button.text:SetSize(self.create_button.text.size-7)
		end
	end)]]
	--[[
	--Подвигаем текст в списках серверов
	local function ServerListingScreenPost(self)
		local _OnUpdate_Old = self.OnUpdate or (function() return end)
		function self:OnUpdate(...)
			_OnUpdate_Old(self, ...)
			self.NAME:SetPosition(-73,3)
			self.DETAILS:SetPosition(242,3)
			self.PLAYERS:SetPosition(420,3)
			self.PING:SetPosition(513,3)
			--"Присоединится" вылазит за кнопку
			self.join_button.text:SetSize(34)
			--Пишет "Просмотреть игр" всесто игры
			self.nav_bar.title:SetSize(40)
		end
	end
	
	AddClassPostConstruct("screens/serverlistingscreen", ServerListingScreenPost)
	AddClassPostConstruct("screens/redux/serverlistingscreen", ServerListingScreenPost)
	]]
	--Меняем меню создания сервера, чтоб текст не вылазил за кнопку
	local function ServerCreationScreenPost(self)
		local oldSetString=self.day_title and self.day_title.SetString
		if oldSetString then
			function self.day_title:SetString(str)
				if str:find("Лето")~=nil then
					if str:find("Ранняя")~=nil then
						str=str:gsub("Ранняя","Раннее")
					elseif str:find("Поздняя")~=nil then
						str=str:gsub("Поздняя","Позднее")
					end
				end
				oldSetString(self,str)
			end
		end
		
		if self.day_title then
			self.day_title:SetString(self.day_title:GetString())
		end
		
		local _OnUpdate_Old = self.OnUpdate or (function() return end)
		function self:OnUpdate(...)
			_OnUpdate_Old(self, ...)
			
			if self.create_button.text then
				self.create_button.text:SetSize(35)
			end
		end
	end
	
	--AddClassPostConstruct("screens/servercreationscreen", ServerCreationScreenPost)
	AddClassPostConstruct("screens/redux/servercreationscreen", ServerCreationScreenPost)

	
	--Слетали шрифты у кнопок выбора в первом слоте
	local function serversettingstabpost(self)
		for i,wgt in ipairs(self.privacy_type.buttons.buttonwidgets) do 
			wgt.button:SetFont(_G.NEWFONT)
		end
	end
	AddClassPostConstruct("widgets/serversettingstab", serversettingstabpost)
	--Клей отрубили подгрузку шрифтов, поэтому подменяем шрифты в попапах
	local function PopUpdialogPost(self)
		if self.title then
			self.title:SetFont(_G.HEADERFONT)
		end
		
		if self.text then
			self.text:SetFont(_G.CHATFONT)
		end

		if self.title and self.title.string==STRINGS.UI.MODSSCREEN.UPDATEALL_TITLE then
			self:SetTitleTextSize(27)
		end

		if self.title and self.title.string==STRINGS.UI.MODSSCREEN.CLEANALL_TITLE then
			self:SetTitleTextSize(27)
		end
	end
	
	AddClassPostConstruct("screens/popupdialog", PopUpdialogPost)
	AddClassPostConstruct("screens/redux/popupdialog", PopUpdialogPost)
	
	--Описание персов не вмещалось.
	--[[
	local function LobbyScreenPost(self)
		local _OnUpdate_Old = self.OnUpdate or (function() return end)
		function self:OnUpdate(...)
			_OnUpdate_Old(self, ...)
			if self.characterquote ~= nil then
				self.characterquote.text:SetSize(2)
				self.characterquote.text:SetRegionSize(650, 200)
			end
		end
	end
	
	AddClassPostConstruct("screens/lobbyscreen", LobbyScreenPost)
	AddClassPostConstruct("screens/redux/lobbyscreen", LobbyScreenPost)
	]]
	
	--Тут не переводилось, так что фиксим
	AddClassPostConstruct("screens/redux/optionsscreen", function(self)
		local SPINNERS = {
			"fullscreenSpinner",
			"displaySpinner",
			"refreshRateSpinner",
			"netbookModeSpinner",
			"smallTexturesSpinner",
			"bloomSpinner",
			"distortionSpinner",
			"screenshakeSpinner",
			"vibrationSpinner",
			"passwordSpinner",
			"wathgrithrfontSpinner",
			"automodsSpinner",
		}
		
		for _,v in pairs(SPINNERS) do
			--Небольшая проверка. Мы же не хотим крашей
			if not self[v] then
				return
			end
			
			local text = self[v]:GetSelectedText()
			if text == nil or type(text) ~= "string" then
				return
				print("ERROR! text == nil or type(text) ~= \"string\"")
			end
			
			if text == "Disabled" then
				self[v].text:SetString("Выключено")
			elseif text == "Enabled" then
				self[v].text:SetString("Включено")
			end
			
			local enableDisableOptions = { { text = "Выключено", data = false }, { text = "Включено", data = true } }
			self[v].options = enableDisableOptions
		end
		--Та же картина
		if self.title ~= nil then
			self.title.big:SetString("Настройки игры")
		end
	end)
	
	--Русификация модов. Подгружаем в самом конце (!!!)
	if t.IsModTranslEnabled ~= t.ModTranslationTypes.disabled then
		modimport("scripts/mod_rusification/mod_russification_main.lua")
	end
	
end --t.CurrentTranslationType~=t.TranslationTypes.ChatOnly
