
-------------------------------------------------Structures and More...
--http://steamcommunity.com/sharedfiles/filedetails/?id=580851939
--[[
ДОБАВИЛ В ТВОЙ МОД(по идее кроме строений в этом моде еще новая еда и паркет, ну т.е. новый пол, но они так себе и неинтересные, а вот новые строения крутые, их я и перевёл,
в настройках мода выбирается активировать ли новую еду, новый паркет или новые строения, поэтому можно просто отключить эти не переведенные, к тому же они действительно так себе)
--]]

mk("FIREFLYLAMP","Придорожный фонарь",1,"Придорожному фонарю","Придорожный фонарь",false)
mk("GARDENPARASOL","Садовый зонт",1,"Садовому зонту","Садовый зонт",false)
mk("ROTBOX","Компостный ящик",1,"Компостному ящику","Компостный ящик",false)
mk("SCARECROW","Пугало",4,"Пугалу","Пугало",false)	

--В STRINGS.LUA (непереведенные здесь - отсутствуют в игре, автор их еще тестирует, или наоборот убрал - об этом сказано где-то на страничке мода)

local RECIPE_DESC = 
	{

		-- STRUCUTRES
		FIREFLYLAMP = "Заправляемый источник света, освещающий путь.",
		FURNACE = "It heats like no other.",
		GARDENPARASOL = "Спасает от зноя и дождя.",
		RABBITBOXX = "Store your own rabbits.",
		ROTBOX = "Полезная в хозяйстве компостная куча.",
		SCARECROW = "Я его боюсь. И я не ворона.",
		WARDROBE = "Finally a place to store my clothing.",
	}
RegisterRecipes(RECIPE_DESC)

--далее перевод фраз персонажей, к каждому персонажу автор сделал отдельный!!! файл.

local speech_wx78 = {
-- STRUCTURES
		BONECHEST = "LIVESTOCK STORAGE DEVICE",
		FIREFLYLAMP = "ОСВЕЩАЕТ ПУТЬ",
		GARDENPARASOL = "БЛАГОДАРЯ ЭТОМУ Я НЕ ЗАРЖАВЕЮ",
		--RABBITBOX =
		--{
		--	GENERIC = "TEACH ME ABOUT THE TUNNELS",
		--	BURNT = "NOTHING BUT KINDLE NOW",
		--},
		ROTBOX = "ОБНАРУЖЕН ОМЕРЗИТЕЛЬНЫЙ ЗАПАХ",
		SCARECROW = "ОТГОНЯЕТ УМНЫХ ПТИЦ ОТ ГЛУПЫХ ЛЮДЕЙ",
		--WARDROBE = "FANCY STORAGE DEVICE, NEEDS MORE RAM",
}
RegisterCharacterPhrases("WX78",speech_wx78)

local speech_wendy = {
		-- STRUCTURES
		BONECHEST = "Used for killing things.",
		FIREFLYLAMP = "Освещает мне путь!",
		GARDENPARASOL = "Убежище от солнца и дождя.",
		--RABBITBOX =
		--{
		--	GENERIC = "We like these friends.",
		--	BURNT = "I hope they're okay.",
		--},
		ROTBOX = "Ужасно пахнет.",
		SCARECROW = "Это должно пугать?",
		--WARDROBE = "It helps repair my image.",
}
RegisterCharacterPhrases("WENDY",speech_wendy)

local speech_wathgrithr = {
	-- STRUCTURES
		BONECHEST = "Does the work for me!",
		FIREFLYLAMP = "Свет во тьме.",
		GARDENPARASOL = "Мне не нравится, но промокнуть мне не понравится больше.",
		--RABBITBOX =
		--{
		--	GENERIC = "Are they ready to be eaten yet?",
		--	BURNT = "Crispy, but still edible.",
		--},
		ROTBOX = "Внутри шевелится лето!",
		SCARECROW = "Вы забыли свое место в строю?",
		--WARDROBE = "Would be more useful as a weapon.",
}
RegisterCharacterPhrases("WATHGRITHR",speech_wathgrithr)

local speech_webber = {
-- STRUCTURES
		BONECHEST = "We should be careful not to get trapped in it.",
		FIREFLYLAMP = "Мы поймали шар света!",
		GARDENPARASOL = "Это может спасти нас от дождя.",
		--RABBITBOX =
		--{
		--	GENERIC = "We like these friends.",
		--	BURNT = "I hope they're okay.",
		--},
		ROTBOX = "Наша еда портится внутри быстрее.",
		SCARECROW = "Нам не нравится.",
		--WARDROBE = "I could fit inside of it.",
}
RegisterCharacterPhrases("WEBBER",speech_webber)

local speech_wickerbottom = {
	-- STRUCTURES
		BONECHEST = "This chest defies the laws of physics.",
		FIREFLYLAMP = "Возобновляемый источник света.",
		GARDENPARASOL = "Складной навес для содержания тела в сухости.",
		--RABBITBOX =
		--{
		--	GENERIC = "I used to have people to take care of these for me.",
		--	BURNT = "Finally, no reason to keep wasting food on them.",
		--},
		ROTBOX = "Внутри хранится компост.",
		SCARECROW = "Отпугивает птиц.",
		--WARDROBE = "We used to call it an armoire.",
}
RegisterCharacterPhrases("WICKERBOTTOM",speech_wickerbottom)

local speech_woodie = {
-- STRUCTURES
		BONECHEST = "Removes the good parts, eh?",
		FIREFLYLAMP = "Примитивные технологии!",
		GARDENPARASOL = "Это спасет мою шкуру от жары.",
		--RABBITBOX =
		--{
		--	GENERIC = "Made of wood, with meat inside!",
		--	BURNT = "Not worth much, eh?",
		--},
		ROTBOX = "Внутри что, кто-то умер?",
		SCARECROW = "Поможет отогнать птиц.",
		--WARDROBE = "Keeps my plaid clothing safe and secure.",
}
RegisterCharacterPhrases("WOODIE",speech_woodie)

local speech_wolfgang = {
-- STRUCTURES
		BONECHEST = "Wolfgang is confused by this contraption.",
		FIREFLYLAMP = "Прогоняет тьму.",
		GARDENPARASOL = "Спасает от дождя и зноя.",
		RABBITBOX =
		{
			GENERIC = "I caught you jumping meat!",
			BURNT = "No more jumping meat.",
		},
		ROTBOX = "Коробка воняет!",
		SCARECROW = "Страшно до жути!",
}
RegisterCharacterPhrases("WOLFGANG",speech_wolfgang)

local speech_wilson = {
-- STRUCTURES
		BONECHEST = "This is not a humane way of dealing with pests.",
		FIREFLYLAMP = "Немного света.",
		GARDENPARASOL = "Спасет меня от непогоды.",
		--RABBITBOX =
		--{
		--	GENERIC = "The Kingdom of the Bunnymen might be upset.",
		--	BURNT = "The Kingdom of the Bunnymen might be upset.",
		--},
		ROTBOX = "Я обуздал стихию навоза!",
		SCARECROW = "Ужасно!",
		--WARDROBE = "This makes my cloths look dapper.",
}
RegisterCharacterPhrases("GENERIC",speech_wilson)

local speech_willow = {
-- STRUCTURES
		BONECHEST = "Fire would be faster!",
		FIREFLYLAMP = "Огонь не предназначен для такого использования!",
		GARDENPARASOL = "Сухо и приятно.",
		--RABBITBOX =
		--{
		--	GENERIC = "Best idea I've ever had!",
		--	BURNT = "Burnt to a crisp, just the way I like it.",
		--},
		ROTBOX = "Эта коробка как раз по мне.",
		SCARECROW = "Ярко вспыхнет, если поджечь.",
		--WARDROBE = "Would look better burnt!",
}
RegisterCharacterPhrases("WILLOW",speech_willow)

local speech_waxwell = {
	-- STRUCTURES
		BONECHEST = "A way to get rid of all the nuisances.",
		FIREFLYLAMP = "Надеюсь, это разгонит их.",
		GARDENPARASOL = "Надеюсь, сработает.",
		--RABBITBOX =
		--{
		--	GENERIC = "Great just what this world needs...",
		--	BURNT = "Good riddance, nuisance.",
		--},
		ROTBOX = "Маленький кусочек лета внутри.",
		SCARECROW = "Похоже, родственник.",
		--WARDROBE = "Finally a real way to stay dapper.",
}
RegisterCharacterPhrases("WAXWELL",speech_waxwell)
		
------------------------------------------------ВРОДЁ ВСЁ
