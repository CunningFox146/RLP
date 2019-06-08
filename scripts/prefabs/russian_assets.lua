local mods = rawget(_G, "mods") or {}
local t = mods.RussianLanguagePack

--Это подгружаем всегда
local assets =
{
    Asset( "ATLAS", "images/rus_button_icon.xml" ),
    Asset( "ATLAS", "images/frontscreen.xml" ),

    Asset("ANIM", "anim/text_sparkle.zip"),
    Asset("ANIM", "anim/mods_button.zip"),
	
    Asset("ATLAS", "images/rusif_icon.xml"),
	
	Asset("ATLAS","images/eyebutton.xml"),
	
	Asset("ATLAS","images/rus_group.xml"),
	
	Asset("ATLAS","images/rus_wiki.xml"),
	
	Asset("ATLAS","images/vk_group.xml"),
	
	Asset("ATLAS","images/web_button.xml"),
	
	Asset("ATLAS","images/text_bg.xml"),
	
	Asset("ATLAS","images/inf_btn.xml"),
}

if t.CurrentTranslationType ~= t.TranslationTypes.ChatOnly then --Всё остальное
	local ass = {
		Asset("ATLAS","images/gradient.xml"), --Градиент на слишком длинных строках лога в настройках перевода
		Asset("ATLAS","images/rus_mapgen.xml"), --Русифицированные пиктограммы в окне генерирования нового мира
		Asset("ATLAS","images/tradescreen_overflow.xml"), --Экран обмена
		Asset("ATLAS","images/tradescreen.xml"), --Экран обмена
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
		Asset("ATLAS","images/rus_names_winona.xml"),
		Asset("ATLAS","images/rus_names_wortox.xml"),
		Asset("ATLAS","images/rus_names_wormwood.xml"),
		Asset("ATLAS","images/rus_names_random.xml"),
		--Золото
		Asset("ATLAS","images/rus_names_gold_wickerbottom.xml"), 
		Asset("ATLAS","images/rus_names_gold_willow.xml"), 
		Asset("ATLAS","images/rus_names_gold_wilson.xml"), 
		Asset("ATLAS","images/rus_names_gold_woodie.xml"), 
		Asset("ATLAS","images/rus_names_gold_wes.xml"), 
		Asset("ATLAS","images/rus_names_gold_wolfgang.xml"), 
		Asset("ATLAS","images/rus_names_gold_wendy.xml"),
		Asset("ATLAS","images/rus_names_gold_wathgrithr.xml"),
		Asset("ATLAS","images/rus_names_gold_webber.xml"),
		Asset("ATLAS","images/rus_names_gold_waxwell.xml"),
		Asset("ATLAS","images/rus_names_gold_random.xml"),
		Asset("ATLAS","images/rus_names_gold_wx78.xml"),
		Asset("ATLAS","images/rus_names_gold_winona.xml"),
		Asset("ATLAS","images/rus_names_gold_wortox.xml"),
		Asset("ATLAS","images/rus_names_gold_wormwood.xml"),
	}

	for _, v in ipairs(ass) do
		table.insert(assets, v)
	end
end	


return Prefab("russian_assets", function() return CreateEntity() end, assets)
