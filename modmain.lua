env._G = GLOBAL

mods = _G.rawget(_G, "mods")
if not mods then
	mods = {}
	_G.rawset(_G, "mods", mods)
end
_G.mods = mods

PrefabFiles = {
	"russian_assets"
}

local SteamID = "1240565842"

mods.RussianLanguagePack = {
	modinfo = modinfo,
	
	StorePath = MODROOT,
	
	mod_phrases = {},
	mod_announce = {},
	
	debug = nil,
	print = function(...) if mods.RussianLanguagePack.debug then print("[RLP_DEBUG]", ...)  end end,
	
	UpdateLogFileName = "updatelog.txt",
	MainPOfilename = "DST.po",
	ModsPOfilename = "MODS.po",
	TranslationTypes = {Full = "1", FontsOnly = "0"},
	ModTranslationTypes = {enabled = "1", disabled = "0"},
	CurrentTranslationType = nil,
	IsModTranslEnabled = nil,
	SteamID = SteamID,
	SteamURL = "http://steamcommunity.com/sharedfiles/filedetails/?id="..SteamID,
	SelectedLanguage = "ru",

	--Склонения
	AdjectiveCaseTags = {
		nominative = "nom", --Именительный	Кто/что
		accusative = "acc", --Винительный	Кого/что
		dative = "dat",		--Дательный		Кому/чему
		ablative = "abl",	--Творительный	Кем/чем
		genitive = "gen",	--Родительный	Кого/чего
		vocative = "voc",	--Звательный
		locative = "loc",	--Предложный	О ком/о чём
		instrumental = "ins"--unused
	},
	DefaultActionCase = "accusative",
}

print("About to load RLP ver. ", modinfo.version)

modimport("scripts/rlp_main.lua")
