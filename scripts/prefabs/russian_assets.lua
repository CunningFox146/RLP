local mods = rawget(_G, "mods")

if not mods then
	mods = {}
	rawset(_G, "mods", mods)
end

local t = mods.RussianLanguagePack

--Это подгружаем всегда
local assets =
{
    Asset("ANIM", "anim/text_sparkle.zip"),
    Asset("ANIM", "anim/mods_button.zip"),
	
    Asset("ATLAS", "images/modicon.xml"),
    Asset("IMAGE", "images/modicon.tex"),
	
	Asset("ATLAS","images/eyebutton.xml"),
	Asset("IMAGE","images/eyebutton.tex"),
	
	Asset("ATLAS","images/rus_group.xml"),
	Asset("IMAGE","images/rus_group.tex"),
	
	Asset("ATLAS","images/rus_wiki.xml"),
	Asset("IMAGE","images/rus_wiki.tex"),
	
	Asset("ATLAS","images/vk_group.xml"),
	Asset("IMAGE","images/vk_group.tex"),
	
	Asset("ATLAS","images/web_button.xml"),
	Asset("IMAGE","images/web_button.tex"),
	
	Asset("ATLAS","images/text_bg.xml"),
	Asset("IMAGE","images/text_bg.tex"),
	
	Asset("ATLAS","images/black_fill.xml"),
	Asset("IMAGE","images/black_fill.tex"),
	
	Asset("ATLAS","images/inf_btn.xml"),
	Asset("IMAGE","images/inf_btn.tex"),
}

if t.CurrentTranslationType ~= t.TranslationTypes.ChatOnly then --Всё остальное
	local function AddAssets(arr)
		for i,v in ipairs(arr) do
			table.insert(assets, v)
		end
	end

	AddAssets({
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
		Asset("ATLAS","images/rus_names_winona.xml"),
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
	})
end	
	
--На самом деле префаб не деаем. Это только для assets
local function fn()
    return CreateEntity()
end

return Prefab("russian_assets", fn, assets)
