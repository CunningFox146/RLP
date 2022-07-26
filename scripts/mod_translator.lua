local env = env
local t = mods.RussianLanguagePack

_G.setfenv(1, _G)

--По-любому надо составить список модов.
mod_by_name = {} --true - активен, false - не активен, nil - отсутствует.
mod_by_name_cut = {} --аналогично, только в качестве ключа - название мода без версии (цифры и точка).
do
	local function SearchForModsByName()
		if not (KnownModIndex and KnownModIndex.savedata and KnownModIndex.savedata.known_mods) then
			t.print("Mod Translation: ERROR! Can't find KnownModIndex!")
			return
		end
		for name, mod in pairs(KnownModIndex.savedata.known_mods) do
			if mod and mod.modinfo and mod.modinfo.name and type(mod.modinfo.name) == "string" then
				local active = false
				if (mod.enabled or mod.temp_enabled or KnownModIndex:IsModForceEnabled(name)) --Мод активен
					and not mod.temp_disabled --И не отключен
				then
					active = true
				end
				if active == true then
					mod_by_name[mod.modinfo.name] = true --true
					local cut = mod.modinfo.name:gsub("^(.-)[0-9 .x]*$","%1")
					mod_by_name_cut[cut] = true
				end
			end
		end
	end
	SearchForModsByName()
	--arr(mod_by_name_cut)
end

env.ModExists = function(fancy) --fancy - реальное название.
	return mod_by_name[fancy] ~= nil --true or false means exists
end

env.ModActive = function(fancy)
	return mod_by_name[fancy] --only true means active
end

--Возвращает true, если есть обрезанный вариант мода. Например, "Waiter 101 v" (вместо "Waiter 101 v1.2.3")
--Название нужно указывать точно (обрезанное).
env.FindName = function(cut_fancy)
	return mod_by_name_cut[cut_fancy]
end

--Эта функция еще более продвинутая. Она ищет название мода по первым словам в нем.
--Само собой поиск в уже кастрированных от версии названиях.
env.FindNameCut = function(cut_fancy)
	for k,v in pairs(mod_by_name_cut) do
		if string.find(k,cut_fancy,1,true) == 1 then
			return true
		end
	end
end

function RegisterRussianPhrase(old_eng, new_rus) --Register Phrase
	if old_eng == nil then
		return
	end
	if t.mod_phrases[old_eng] ~= nil then
		t.print("ERROR RUS MODS!")
		t.print("String \""..tostring(old_eng).."\" already exists!")
		t.print("Rus translation: "..tostring(t.mod_phrases[old_eng]))
		t.print("Failed translation: "..tostring(new_rus))
	end
	t.mod_phrases[old_eng] = new_rus
end

env.RegisterRussianPhrase = RegisterRussianPhrase
-- Делаем затычку для старых переводов.
mods.RusMods = {
	pp = RegisterRussianPhrase --Старая ссылка
}

env.pp = RegisterRussianPhrase --Короткое название (алиас), чтобы было проще вбивать перевод, без копипаста этого длиннющего названия функции.
t.pp = RegisterRussianPhrase

-- Делаем затычку для старых переводов.
mods.RusMods.pp = RegisterRussianPhrase --Старая ссылка

-- Добавляет перевод аннонса
function AddModAnnounce(eng, rus)
	t.mod_announce[eng] = rus
end

env.AddModAnnounce = AddModAnnounce
t.ma = AddModAnnounce
t.AddModAnnounce = AddModAnnounce

local ch = STRINGS.CHARACTERS
--Регистрирует реплики стандартного персонажа.
env.RegisterCharacterPhrases = function(char_name, arr)
	if not ch[char_name] then
		ch[char_name] = {DESCRIBE={}} --Нужно, чтобы брать отсюда реплики (чтобы не было краша, если их еще нет).
	end
	local desc = ch[char_name].DESCRIBE
	for k,v in pairs(arr) do
		if type(v) == "table" then --Обходим дерево второго уровня.
			if desc[k] == nil then desc[k] = {} end
			for kk, vv in pairs(v) do
				pp(desc[k][kk],vv)
			end
		else
			pp(desc[k],v) --Регистрируем реплики построчно.
		end
	end
end

local after_init = {} --Функции пост инициализации.
--При создании мира все префабы уже загружены, поэтому это самое удачное время для исправления строк.
local after_init_trans = {} --А это функции, которые не подозревают, что в теле мода. Хитрая подстановка переменных.
env.AddPrefabPostInit("world", function(inst)
	for i,fn in ipairs(after_init) do
		fn()
	end
	local s1,s2 = _G, STRINGS --Запоминаем от греха подальше.
	STRINGS = {
		RECIPE_DESC={},
		NAMES = {}, --Эту мы просто пропускаем. Просто лень вырезать это.
		CHARACTERS={
			GENERIC={DESCRIBE={},ACTIONFAIL={}},
			WILLOW={DESCRIBE={}},
			WOLFGANG={DESCRIBE={}},
			WENDY={DESCRIBE={}},
			WX78={DESCRIBE={}},
			WICKERBOTTOM={DESCRIBE={}},
			WOODIE={DESCRIBE={}},
			WAXWELL={DESCRIBE={}},
			WATHGRITHR={DESCRIBE={}},
			WEBBER={DESCRIBE={}},
			--WES={DESCRIBE={}},
		},
	}
	_G = {STRINGS=STRINGS}
	for i,fn in ipairs(after_init_trans) do --Функции с подменой глобалов.
		fn() --Заполняем фейковые структуры данными.
	end
	do --Затем надо извлечь полученные данные
		for k,v in pairs(STRINGS.RECIPE_DESC) do
			rec[k] = v
		end
		--Дальше реплики персонажей. Рекурсивно
		local function replace_str(t1,t2) --t1 - новая таблица, t2- старая (настоящая)
			for k,v in pairs(t1) do
				if type(v) == "string" then
					pp(t2[k], v) --существующая реплика, перевод.
				elseif type(v) == "table" and type(t2[k]) == "table" then
					replace_str(v, t2[k])
				end
			end
		end
		replace_str(STRINGS.CHARACTERS, ch)
	end
	_G,STRINGS = s1,s2 --Возвращаем значения. Хотя зачем? Но для красоты и автономности  - надо.
end)

env.RegisterTranslation = function(fn)
	table.insert(after_init, fn)
end

env.RegisterReplacedTranslation = function(fn)
	table.insert(after_init_trans, fn)
end

if t.IsModTranslEnabled ~= t.ModTranslationTypes.Disabled and t.CurrentTranslationType == t.TranslationTypes.Full then
	--Простые переменные.
	env.mk = t.RegisterRussianName
	env.ch_nm = t.RegisterRussianName
	env.arr = rawget(_G, "arr") or function() end
	
	env.s = STRINGS
	env.STRINGS = STRINGS
	env.RenameAction = t.RenameAction
	
	env.nm = STRINGS.NAMES
	env.ch = STRINGS.CHARACTERS
	env.rec = STRINGS.RECIPE_DESC
	env.gendesc = STRINGS.CHARACTERS.GENERIC.DESCRIBE

	env.modimport("scripts/mod_rusification/main.lua")
end