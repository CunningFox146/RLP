local t = mods.RussianLanguagePack

--Пробрасываем в настройки каждого мода переменную russian для нативной русификации (при желании автора мода).
local ModIndex = KnownModIndex
if ModIndex and ModIndex.InitializeModInfoEnv then
    --Если PeterA услышал мольбы, то поступаем цивилизованно.
    local old_InitializeModInfoEnv = ModIndex.InitializeModInfoEnv
    ModIndex.InitializeModInfoEnv = function(self,...)
        local env = old_InitializeModInfoEnv(self,...)
		env.language = t.SelectedLanguage
		env.russian = true -- !!! Устаревшая ссылка. Через некоторое время будет удалена !!!
        return env
    end
else --Иначе извращаемся, как обычно.
    local temp_mark = false --Временная метка, означающая, что в следующий вызов RunInEnvironment надо добавить russian=true
   
    --Перехватываем "kleiloadlua", чтобы установить временную метку в случае загрузки "modinfo.lua"
    local old_kleiloadlua = kleiloadlua
    kleiloadlua = function(path,...)
        local fn = old_kleiloadlua(path,...)
        if fn and type(fn) ~= "string" and path:sub(-12) == "/modinfo.lua" then
			temp_mark = true
        end
        return fn
    end
   
    --Перехватываем RunInEnvironment, чтобы среагировать на метку (заодно сбросить ее)
    local old_RunInEnvironment = RunInEnvironment
    RunInEnvironment = function(fn, env, ...)
		if env and temp_mark then
			env.language = t.SelectedLanguage
			env.russian = true -- !!! Устаревшая ссылка. Через некоторое время будет удалена !!!
			temp_mark = false
		end
		return old_RunInEnvironment(fn, env, ...)
    end
end



--Функции ниже не инициализируются, если русификатор не в режиме «Полный перевод», т.е. если не нужно переводить предметы и действия
if t.CurrentTranslationType==t.TranslationTypes.Full then


	local genders_reg={"he","he2","she","it","plural","plural2", --numbers
		he="he",he2="he2",she="she",it="it",plural="plural",plural2="plural2"};
	--[[Функция регистрирует новое имя предмета со всеми данными, необходимыми для его корректного склонения.

		key - Ключ объекта. Например, MYITEM (из STRINGS.NAMES.MYITEM).
		val - Русский перевод названия объекта.
		gender - Пол объекта. Варианты: he, he2, she, it, plural, plural2. Род нужен для склонения префиксов жары и влажности.
			 "he" и "he2" - это мужской род, но не одно и то же, сравните: изучить влажный курган слизнепах (he),
			 но изучить влажного паука (he2). plural2 — одушевлённое во множественном числе (если слово, например, "Чайки",
			 то есть когда объект изначально получает название во множественном числе).
		walkto - Склонение при подстановке во фразу "Идти к" (кому? чему?). Задавайте слова с большой буквы.
		defaultaction - Подставляется ко всем действиям в игре, для которых не задано особое написание. Например "Осмотреть" (кого? что?).
		capitalized - Нужно ли писать имя с большой буквы. Маленькая буква в названии не станет большой.
				  Но если не указать true, то большая станет маленькой в фразах, где есть слово перед. Например: "Осмотреть лепестки".
		killaction - Используется только в DST во всех предметах, которые способны убить персонажа. В игре они могут появляться в сообщениях
			 типа "Был убит (кем? чем?)", то есть это творительный падеж.
		Вместо строковых значений пола можно использовать их номера: 1) he, 2) he2, 3) she, 4) it, 5) plural, 6) plural2.
		Вместо walkto, defaultaction и killaction можно использовать 0 или 1.
		0 означает пропуск параметра. То же, что не указать параметр вовсе. Значение не инициализируется. Используются значения из testname.
		1 означает "то же, что и базовая форма", т.е. val. Чтобы не дублировать одни и те же строки (val) можно просто указать единичку.
		
		Например: 
		RegisterRussianName("RESEARCHLAB2","Алхимический двигатель",1,"Алхимическому двигателю",1)
		Вместо пола указана 1, что означает "he".
		Вместо defaultaction указано 1, что означает повторение val, т.е. "Алхимический двигатель".
	]]


	function t.RegisterRussianName(key,val,gender,walkto,defaultaction,capitalized,killaction)
		local oldval = STRINGS.NAMES[string.upper(key)]
		STRINGS.NAMES[string.upper(key)]=val
		LanguageTranslator.languages[t.SelectedLanguage]["STRINGS.NAMES."..string.upper(key)] = val
		if gender and gender~=0 then 
			if (genders_reg[gender]) then
				t.NamesGender[genders_reg[gender]][string.lower(key)]=true
			--else
			--	print error............
			end
		end
		if walkto or defaultaction or killaction then
			if (walkto==1) then walkto=val end
			if (defaultaction==1) then defaultaction=val end
			if (killaction==1) then killaction=val end
			t.RussianNames[val]={}
			if walkto and walkto~=0 then t.RussianNames[val]["WALKTO"]=walkto end
			if defaultaction and defaultaction~=0 then t.RussianNames[val]["DEFAULTACTION"]=defaultaction end
			if killaction and killaction~=0 then t.RussianNames[val]["KILL"]=killaction end
		end
		if capitalized then t.ShouldBeCapped[string.lower(key)]=true end
		if t.SpeechHashTbl.NAMES and oldval then
			t.SpeechHashTbl.NAMES.Eng2Key[oldval]=string.upper(key)
			t.SpeechHashTbl.NAMES.Rus2Eng[val]=oldval
		end
	end

	-- !!! Устаревшая ссылка. Через некоторое время будет удалена !!!
	RegisterRussianName = t.RegisterRussianName --Временно оставлено для обратной совместимости по просьбе Star

	---Переименовывание действий по названию (id)
	function t.RenameAction(act, new_name)
		if rawget(GLOBAL,"ACTIONS") and ACTIONS[act] then
			ACTIONS[act].str = new_name
			if STRINGS.ACTIONS then
				STRINGS.ACTIONS[act] = new_name
			end
		end
	end

end