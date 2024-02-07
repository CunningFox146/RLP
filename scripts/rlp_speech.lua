local t = mods.RussianLanguagePack
local rebuildname = t.rebuildname

--Строим хеш-таблицы
t.SpeechHashTbl={}

local function ExtractMeta(str, key)
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

--Строит хеш-таблицу по имени персонажа. Английские реплики персонажа должны быть в STRINGS.CHARACTERS
--russource - таблица, в которой находятся все русские реплики персонажа в виде ["ключ из STRINGS"]="русский перевод"
--Если она не указана, то используется стандартная таблица, в которую загружаются реплики из PO файлов LanguageTranslator.languages[t.SelectedLanguage]
local function BuildCharacterHash(charname, russource)
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
	if charname=="WILSON" then charname="GENERIC" end
	if charname=="MAXWELL" then charname="WAXWELL" end
	if charname=="WIGFRID" then charname="WATHGRITHR" end
	t.SpeechHashTbl[charname]={}
	CreateRussianHashTable(t.SpeechHashTbl[charname],STRINGS.CHARACTERS[charname],"STRINGS.CHARACTERS."..charname)
end
t.BuildCharacterHash = BuildCharacterHash

--Генерируем хеши для всех персонажей, перечисленных в STRINGS.CHARACTERS
for charname,v in pairs(STRINGS.CHARACTERS) do
	BuildCharacterHash(charname)
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

--Извлекаем мета-данные из названий скинов
for key, val in pairs(STRINGS.SKIN_NAMES) do
	local fullkey = "STRINGS.SKIN_NAMES."..key
	if t.PO[fullkey] then
		t.PO[fullkey] = ExtractMeta(t.PO[fullkey], key)
	end
end

--хеш-таблицы эпитафий
t.SpeechHashTbl.EPITAPHS={Eng2Rus={}}
for i,v in pairs(STRINGS.EPITAPHS) do
	t.SpeechHashTbl.EPITAPHS.Eng2Rus[v]=t.PO["STRINGS.EPITAPHS."..i] or v
	t.PO["STRINGS.EPITAPHS."..i]=nil
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
if TheNet:GetServerGameMode() == "quagmire" then
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
end

--[[ Юзалось в режиме только UI
	for charname,v in pairs(STRINGS.CHARACTERS) do
		t.SpeechHashTbl[charname]={}
	end

	t.SpeechHashTbl.EPITAPHS={}
	t.SpeechHashTbl.NAMES={Eng2Key={},Rus2Eng={}}
	t.SpeechHashTbl.PIGNAMES={Eng2Rus={}}
	t.SpeechHashTbl.BUNNYMANNAMES={Eng2Rus={}}

	for i,v in pairs(t.PO) do
		if string.sub(i,8+1,8+3)~="UI." then t.PO[i]=nil end
	end
end]]