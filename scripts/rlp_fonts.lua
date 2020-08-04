local env = env
local modname = env.modname
local MODROOT = env.MODROOT
local t = mods.RussianLanguagePack

GLOBAL.setfenv(1, GLOBAL)

require("fonts")

local FONT_PREFIX = "ru_"
local FONT_POSTFIX = "__ru"

local CACHED_FONTS = {
	DEFAULTFONT = DEFAULTFONT,
	DIALOGFONT = DIALOGFONT,
	TITLEFONT = TITLEFONT,
	UIFONT = UIFONT,
	BUTTONFONT = BUTTONFONT,
	HEADERFONT = HEADERFONT,
	CHATFONT = CHATFONT,
	CHATFONT_OUTLINE = CHATFONT_OUTLINE,
	NUMBERFONT = NUMBERFONT,
	TALKINGFONT = TALKINGFONT,
	SMALLNUMBERFONT = SMALLNUMBERFONT,
	BODYTEXTFONT = BODYTEXTFONT,
	
	TALKINGFONT_WORMWOOD = TALKINGFONT_WORMWOOD,
	TALKINGFONT_HERMIT = TALKINGFONT_HERMIT,
	
	NEWFONT = NEWFONT,
	NEWFONT_SMALL = NEWFONT_SMALL,
	NEWFONT_OUTLINE = NEWFONT_OUTLINE,
	NEWFONT_OUTLINE_SMALL = NEWFONT_OUTLINE_SMALL,
}

--Имена шрифтов, которые нужно загрузить.
local LOCALIZED = {
	["talkingfont"] = true,
	["stint-ucr50"] = true,
	["stint-ucr20"] = true,
	["opensans50"] = true,
	["belisaplumilla50"] = true,
	["belisaplumilla100"] = true,
	["buttonfont"] = true,
	["hammerhead50"] = true,
	["bellefair50"] = true,
	["bellefair_outline50"] = true,

	["talkingfont_wormwood"] = true,
	["talkingfont_hermit"] = true,

	["spirequal"] = true,
	["spirequal_small"] = true,
	["spirequal_outline"] = true,
	["spirequal_outline_small"] = true,
}

--В этой функции происходит загрузка, подключение и применение русских шрифтов
local function ApplyLocalizedFonts()
	t.print("ApplyLocalizedFonts", CalledFrom())
	
	--ЭТАП ВЫГРУЗКИ: Вначале выгружаем шрифты, если они были загружены
	--Восстанавливаем оригинальные переменные шрифтов
	DEFAULTFONT = CACHED_FONTS.DEFAULTFONT
	DIALOGFONT = CACHED_FONTS.DIALOGFONT
	TITLEFONT = CACHED_FONTS.TITLEFONT
	UIFONT = CACHED_FONTS.UIFONT
	BUTTONFONT = CACHED_FONTS.BUTTONFONT
	HEADERFONT = CACHED_FONTS.HEADERFONT
	CHATFONT = CACHED_FONTS.CHATFONT
	CHATFONT_OUTLINE = CACHED_FONTS.CHATFONT_OUTLINE
	NUMBERFONT = CACHED_FONTS.NUMBERFONT
	TALKINGFONT = CACHED_FONTS.TALKINGFONT
	SMALLNUMBERFONT = CACHED_FONTS.SMALLNUMBERFONT
	BODYTEXTFONT = CACHED_FONTS.BODYTEXTFONT
	
	TALKINGFONT_WORMWOOD = CACHED_FONTS.TALKINGFONT_WORMWOOD
	TALKINGFONT_HERMIT = CACHED_FONTS.TALKINGFONT_HERMIT
	
	NEWFONT = CACHED_FONTS.NEWFONT
	NEWFONT_SMALL = CACHED_FONTS.NEWFONT_SMALL
	NEWFONT_OUTLINE = CACHED_FONTS.NEWFONT_OUTLINE
	NEWFONT_OUTLINE_SMALL = CACHED_FONTS.NEWFONT_OUTLINE_SMALL
	
	--Выгружаем локализированные шрифты, если они были до этого загружены
	t.print("Unloading RLP fonts")
	for FontName in pairs(LOCALIZED) do
		TheSim:UnloadFont(FONT_PREFIX..FontName)
	end
	TheSim:UnloadPrefabs({"RLP_fonts"}) --выгружаем общий префаб локализированных шрифтов

	--ЭТАП ЗАГРУЗКИ: Загружаем шрифты по новой
	t.print("Loading RLP fonts")
	--Формируем список ассетов
	local LocalizedFontAssets = {}
	for FontName in pairs(LOCALIZED) do 
		table.insert(LocalizedFontAssets, Asset("FONT", MODROOT.."fonts/"..FontName..FONT_POSTFIX..".zip"))
	end

	--Создаём префаб, регистрируем его и загружаем
	local LocalizedFontsPrefab = require("prefabs/rlp_fonts")(LocalizedFontAssets)
	RegisterPrefabs(LocalizedFontsPrefab)
	TheSim:LoadPrefabs({"RLP_fonts"})

	--Формируем список связанных с файлами алиасов
	for FontName in pairs(LOCALIZED) do
		TheSim:LoadFont(MODROOT.."fonts/"..FontName..FONT_POSTFIX..".zip", FONT_PREFIX..FontName)
	end

	--Строим таблицу фоллбэков для последующей связи шрифтов с доп-шрифтами
	local fallbacks = {}
	for _, v in pairs(FONTS) do
		local FontName = v.filename:sub(7, -5)
		if LOCALIZED[FontName] then
			fallbacks[FontName] = {v.alias, unpack(v.fallback)}
		end
	end
	--Привязываем к новым английским шрифтам локализированные символы
	for FontName in pairs(LOCALIZED) do
		TheSim:SetupFontFallbacks(FONT_PREFIX..FontName, fallbacks[FontName])
	end
	
	--Вписываем в глобальные переменные шрифтов наши алиасы
	DEFAULTFONT = FONT_PREFIX.."opensans50"
	DIALOGFONT = FONT_PREFIX.."opensans50"
	TITLEFONT = FONT_PREFIX.."belisaplumilla100"
	UIFONT = FONT_PREFIX.."belisaplumilla50"
	BUTTONFONT = FONT_PREFIX.."buttonfont"
	HEADERFONT = FONT_PREFIX.."hammerhead50"
	CHATFONT = FONT_PREFIX.."bellefair50"
	CHATFONT_OUTLINE = FONT_PREFIX.."bellefair_outline50"
	NUMBERFONT = FONT_PREFIX.."stint-ucr50"
	TALKINGFONT = FONT_PREFIX.."talkingfont"
	SMALLNUMBERFONT = FONT_PREFIX.."stint-ucr20"
	BODYTEXTFONT = FONT_PREFIX.."stint-ucr50"
	
	TALKINGFONT_WORMWOOD = FONT_PREFIX.."talkingfont_wormwood"
	TALKINGFONT_HERMIT = FONT_PREFIX.."talkingfont_hermit"
	
	NEWFONT = FONT_PREFIX.."spirequal"
	NEWFONT_SMALL = FONT_PREFIX.."spirequal_small"
	NEWFONT_OUTLINE = FONT_PREFIX.."spirequal_outline"
	NEWFONT_OUTLINE_SMALL = FONT_PREFIX.."spirequal_outline_small"
	
	-- Сжимаем немного новый шрифт
	TheSim:AdjustFontAdvance(CHATFONT, -2.5)
	TheSim:AdjustFontAdvance(HEADERFONT, -1)
	
	if rawget(_G, "TheFrontEnd") then
		TheFrontEnd.consoletext:SetFont(BODYTEXTFONT) --Нужно, чтобы шрифт в консоли не слетал
	end
end

local _UnregisterAllPrefabs = Sim.UnregisterAllPrefabs
Sim.UnregisterAllPrefabs = function(self, ...)
	_UnregisterAllPrefabs(self, ...)
	ApplyLocalizedFonts()
end

--Вставляем функцию, подключающую русские шрифты
local _RegisterPrefabs = ModManager.RegisterPrefabs --Подменяем функцию,в которой нужно подгрузить шрифты и исправить глобальные шрифтовые константы
ModManager.RegisterPrefabs = function(self, ...)
	_RegisterPrefabs(self, ...)
	ApplyLocalizedFonts()
end

local _Start = Start
function Start(...) 
	ApplyLocalizedFonts()
	return _Start(...)
end
