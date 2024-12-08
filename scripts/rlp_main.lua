local env = env
local t = mods.RussianLanguagePack
local AddPrefabPostInit = AddPrefabPostInit
local AddClassPostConstruct = env.AddClassPostConstruct
local modimport = env.modimport

GLOBAL.setfenv(1, GLOBAL)

require("constants")

local VerChecker = require "ver_checker"
t.VerChecker = VerChecker
VerChecker:LoadVersion()

global("POUpdater")
POUpdater = require "po_updater"

local DEBUG_ENABLED = false
local DEBUG_ENABLE_ID = {
	["KU_YhiKhjfu"] = true,
	["OU_76561198137380697"] = true,
	["KU_gwxUn9lD"] = true,
	["OU_76561198089171367"] = true,
	["KU_llXKvJxA"] = true, -- Олег
}

local CHEATS_ENABLE_ID = {
	["KU_YhiKhjfu"] = true,
	["OU_76561198137380697"] = true,
	["KU_gwxUn9lD"] = true,
	["OU_76561198089171367"] = true,
}

if CHEATS_ENABLE_ID[TheNet:GetUserID()] then
	CHEATS_ENABLED = true
end

if DEBUG_ENABLE_ID[TheNet:GetUserID()] then
	DEBUG_ENABLED = true
	t.debug = true
	t.mod_startup_t = os.clock()

	t.ModLoaded = function()
		t.print("MOD WAS LOADED IN ", os.clock() - t.mod_startup_t)
	end
end

-- Удаляем уведомление о модах
Sim.ShouldWarnModsLoaded = function() return false end

modimport("scripts/rlp_fonts.lua")
modimport("scripts/rlp_settings.lua")

-- используемый CHATFONT_OUTLINE не поддерживает иконки кнопок мыши и отображает их знаками ?
AddClassPostConstruct("widgets/redux/loadingwidget", function(self)
	if self and self.loading_tip_text then -- если советы отключены
		self.loading_tip_text:SetFont(CHATFONT) 
	end
end)

if t.CurrentTranslationType == t.TranslationTypes.FontsOnly then
	t.print("[RLP] Загрузка FontsOnly версии завершена.")
	if DEBUG_ENABLED then
		t.ModLoaded()
	end

	--Исправление бага с шрифтом в спиннерах
	--Выполняем подмену шрифта в спиннере из-за глупой ошибки разрабов в этом виджете
	--ниже есть версия для фикса перевода настроек--
	AddClassPostConstruct("widgets/spinner", function(self, options, width, height, textinfo, ...)
		if textinfo then return end
		self.text:SetFont(BUTTONFONT)
	end)

	return
end

--Загружаем русификацию
print("Загрузка PO файла")
env.LoadPOFile(t.StorePath..t.MainPOfilename, t.SelectedLanguage)
t.PO = LanguageTranslator.languages[t.SelectedLanguage]

-- TODO: Сделать внешний скрипт для этого
for k, v in pairs(t.PO) do
	if v == "<пусто>" or v:find("*PLACEHOLDER") then
		t.PO[k] = nil
	end
end
print("PO файл загружен!")

--Возвращает корректную форму слова день (или другого, переданного вторым параметром)
local function StringTime(n,s)
	local pl_type=n%10==1 and n%100~=11 and 1 or(n%10>=2 and n%10<=4
			and(n%100<10 or n%100>=20)and 2 or 3)
	s=s or {"день","дня","дней"}
	return s[pl_type]
end

--Пытается сформировать правильные окончания в словах названия предмета str1 в соответствии действию action
--objectname - название префаба предмета
local function rebuildname(str1, action, objectname)
	local function repsubstr(str, pos, substr)--вставить подстроку substr в строку str в позиции pos	
		local dontrebuild = {"для", "за", "на", "в"}; -- слова которые не нужно склонять
			for _,v in ipairs(dontrebuild) do 
				if str == v then
					return v
				end
			end

		pos = pos - 1
		return str:utf8sub(1, pos)..substr..str:utf8sub(pos+substr:utf8len()+1, str:utf8len())
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
	
	if objectname then
		objectname = string.lower(objectname)
	end

	-- Оптимизация обрезки. Сохраняем все обрезки чтоб каждый раз не резать заново
	local subbed = setmetatable({}, {__mode = "k"})
	local function SubSize(str, num)
		if not subbed[str] then
			subbed[str] = {}
		end
		if not subbed[num] then
			subbed[str][num] = str:utf8sub(num)
		end
		return subbed[str][num]
	end

	for i=1,str1len do
		delimetr=str1:utf8sub(i,i)
		if delimetr~=" " and delimetr~="-" then
			str=str..delimetr
		elseif #str>0 and (delimetr==" " or delimetr=="-") then
			counter=counter+1
			local size = str:utf8len()
			if action=="KILL" and objectname and size >2 then -- был убит (кем? чем?) Творительный
				--Особый случай, в objectname передаём имя префаба для более точного анализа его пола
				--Действие "KILL" не генерируется игрой, а используется только в этом моде для формирования сообщений о смерти в DST
				local function testnoun()
					if t.NamesGender["she"][objectname] then --женский род
						if SubSize(str, size -1)=="ца" or SubSize(str, size -1)=="ча" or SubSize(str, size -1)=="ша" then
							str=repsubstr(str,size ,"ей") FoundNoun=delimetr~="-"
						elseif SubSize(str, size )=="а" then
							str=repsubstr(str,size ,"ой") FoundNoun=delimetr~="-"
						elseif str:utf8sub(-4)=="роня" then
							str=repsubstr(str,size ,"ёй") FoundNoun=delimetr~="-"
						elseif str:utf8sub(-3)=="мля" then
							str=repsubstr(str,size ,"ёй") FoundNoun=delimetr~="-"
						elseif SubSize(str, size )=="я" and size >3 then
							str=repsubstr(str,size ,"ей") FoundNoun=delimetr~="-"
						elseif SubSize(str, size )=="ь" then
							str=str.."ю" FoundNoun=delimetr~="-"
						end
					elseif t.NamesGender["it"][objectname] then --средний род
						if str:utf8sub(-1)~="и" then
							str=str.."м" FoundNoun=delimetr~="-"
						end
					elseif t.NamesGender["plural"][objectname] or
						   t.NamesGender["plural2"][objectname] then --множественное число
						if SubSize(str, size )=="а" or SubSize(str, size )=="ы" then
							str=repsubstr(str,size ,"ами") FoundNoun=delimetr~="-"
						elseif SubSize(str, size )=="я" then
							str=repsubstr(str,size ,"ями") FoundNoun=delimetr~="-"
						elseif SubSize(str, size )=="и" then
							if sogl2[SubSize(str, size -1,size -1)] then
								str=repsubstr(str,size ,"ами") FoundNoun=delimetr~="-"
							else
								str=repsubstr(str,size ,"ями") FoundNoun=delimetr~="-"
							end
						end
					else --мужской род
						if str:utf8sub(-3,-3)=="о" and SubSize(str, size )=="ь" and not sogl3[str:utf8sub(-4,-4) or "р"] then
							str=SubSize(str, 1,-4)..str:utf8sub(-2,-2).."ём" FoundNoun=delimetr~="-"
						elseif SubSize(str, size -1)=="ок" then
							str=repsubstr(str,size -1,"ком") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -2)=="чек" then
							str=repsubstr(str,size -1,"ком") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -1)=="ец" then
							str=repsubstr(str,size -1,"цем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -2)=="ень" then
							str=repsubstr(str,size -2,"нем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -1)=="дь" then
							str=repsubstr(str,size ,"ем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -2)=="арь" then
							str=repsubstr(str,size ,"ём") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -1)=="рь" then
							str=repsubstr(str,size ,"ем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -1)=="ёр" then
							str=repsubstr(str,size -1,"ром") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -1)=="уй" then
							str=repsubstr(str,size ,"ем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -1)=="ай" then
							str=repsubstr(str,size ,"ем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -2)=="лей" then --улей
							str=repsubstr(str,size -1,"ьем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -2)=="йль" then
							str=repsubstr(str,size ,"ем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -2)=="ель" then
							str=repsubstr(str,size ,"ем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size -2)=="ень" then
							str=repsubstr(str,size ,"ем") FoundNoun=delimetr~="-"
						elseif SubSize(str, size )=="ь" then
							str=repsubstr(str,size ,"ём") FoundNoun=delimetr~="-"
						elseif sogl[str:utf8sub(-1)] then
							str=str.."ом" FoundNoun=delimetr~="-"
						end
					end
				end
				if counter~=wordcount and size >3 then --Если это не последнее слово, то это может быть прилагательное
					if t.NamesGender["she"][objectname] then --женский род
						if SubSize(str, size -1)=="ая" then
							str=repsubstr(str,size -1,"ой")
						elseif SubSize(str, size -1)=="яя" then
							str=repsubstr(str,size -1,"ей")
						elseif SubSize(str, size -1)=="ья" then
							str=repsubstr(str,size ,"ей")
						elseif str:utf8sub(-4)=="аяся" then
							str=repsubstr(str,size -3,"ейся")
						elseif not  FoundNoun then testnoun() end
					elseif t.NamesGender["it"][objectname] then --средний род
						if SubSize(str, size -2)=="кое" then
							str=repsubstr(str,size -1,"им")
						elseif SubSize(str, size -1)=="ое" then
							str=repsubstr(str,size -1,"ым")
						elseif SubSize(str, size -1)=="ее" then
							str=repsubstr(str,size -1,"им")
						elseif not  FoundNoun then testnoun() end
					elseif t.NamesGender["plural"][objectname] or
						   t.NamesGender["plural2"][objectname] then --множественное число
						if SubSize(str, size -1)=="ые" then
							str=repsubstr(str,size -1,"ыми")
						elseif SubSize(str, size -1)=="ие" then
							str=repsubstr(str,size -1,"ими")
						elseif SubSize(str, size -1)=="ьи" then
							str=repsubstr(str,size -1,"ими")
						elseif not  FoundNoun then testnoun() end
					else --мужской род
						if SubSize(str, size -1)=="ый" then
							str=repsubstr(str,size -1,"ым")
						elseif SubSize(str, size -1)=="ий" then
							str=repsubstr(str,size -1,"им")
						elseif SubSize(str, size -1)=="ой" then
							str=repsubstr(str,size -1,"ым")
						elseif not  FoundNoun then testnoun() end
					end
				else
					if not  FoundNoun then testnoun() end
				end
			elseif action=="WALKTO" then --идти к (кому? чему?) Дательный
				if SubSize(str, size -1)=="ая" and resstr=="" then
					str=repsubstr(str,size -1,"ой")
				elseif SubSize(str, size -1)=="ая" then
					str=repsubstr(str,size -1,"ей")
				elseif SubSize(str, size -1)=="ей" then
					str=repsubstr(str,size -1,"ью")
				elseif SubSize(str, size -1)=="яя" then
					str=repsubstr(str,size -1,"ей")
				elseif SubSize(str, size -1)=="ец" then
					str=repsubstr(str,size -1,"цу")
				elseif SubSize(str, size -1)=="ый" then
					str=repsubstr(str,size -1,"ому")
				elseif SubSize(str, size -1)=="ий" then
					str=repsubstr(str,size -1,"ему")
				elseif SubSize(str, size -1)=="ое" then
					str=repsubstr(str,size -1,"ому")
				elseif SubSize(str, size -1)=="ее" then
					str=repsubstr(str,size -1,"ему")
				elseif SubSize(str, size -1)=="ые" then
					str=repsubstr(str,size -1,"ым")
				elseif SubSize(str, size -1)=="ой" and resstr=="" then
					str=repsubstr(str,size -1,"ому")
				elseif SubSize(str, size -1)=="ья" and resstr=="" then
					str=repsubstr(str,size -1,"ьей")
				elseif SubSize(str, size -2)=="орь" then
					str=SubSize(str, 1,size -3).."рю"
				elseif SubSize(str, size -1)=="ек" then
					str=SubSize(str, 1,size -2).."ку"
					wasnoun=true
				elseif SubSize(str, size -2)=="ень" then
					str=SubSize(str, 1,size -3).."ню"
				elseif SubSize(str, size -1)=="ок" then
					str=repsubstr(str,size -1,"ку")
					wasnoun=true
				elseif SubSize(str, size -1)=="ть" then
					str=repsubstr(str,size ,"и")
					wasnoun=true
				elseif SubSize(str, size -1)=="вь" then
					str=repsubstr(str,size ,"и")
					wasnoun=true
				elseif SubSize(str, size -1)=="ль" then
					str=repsubstr(str,size ,"и")
					wasnoun=true
				elseif SubSize(str, size -1)=="зь" then
					str=repsubstr(str,size ,"и")
					wasnoun=true
				elseif SubSize(str, size -1)=="нь" then
					str=repsubstr(str,size ,"ю")
					wasnoun=true
				elseif SubSize(str, size -1)=="рь" then
					str=repsubstr(str,size ,"ю")
					wasnoun=true
				elseif SubSize(str, size -1)=="ьи" then
					str=str.."м"
				elseif SubSize(str, size -1)=="ки" and not wasnoun then
					str=repsubstr(str,size ,"ам")
					wasnoun=true
				elseif SubSize(str, size )=="ы" and not wasnoun then
					str=repsubstr(str,size ,"ам")
					wasnoun=true
				elseif SubSize(str, size )=="ы" and not wasnoun then
					str=repsubstr(str,size ,"ам")
					wasnoun=true
				elseif SubSize(str, size )=="а" and not wasnoun then
					str=repsubstr(str,size ,"е")
					wasnoun=true
				elseif SubSize(str, size )=="я" and not wasnoun then
					str=repsubstr(str,size ,"е")
					wasnoun=true
				elseif SubSize(str, size )=="о" and not wasnoun then
					str=repsubstr(str,size ,"у")
					wasnoun=true
				elseif SubSize(str, size -1)=="це" and not wasnoun then
					str=repsubstr(str,size -1,"цу")
					wasnoun=true
				elseif SubSize(str, size )=="е" and not wasnoun then
					str=repsubstr(str,size ,"ю")
					wasnoun=true
				elseif sogl[SubSize(str, size )] and not wasnoun then
					str=str.."у"
					wasnoun=true
				end
			-- (Кого? Чего?) Изменяет внешний вид у (кого? чего?) Родительный
			elseif action=="reskin" then
						if SubSize(str, size -5)=="камень" then
							str=repsubstr(str,size -5,"камня"):utf8sub(1, -2)
						elseif SubSize(str, size -5)=="Сказки" then
							str=repsubstr(str,size -5,"Сказок")
						elseif SubSize(str, size -4)=="льная" then
							str=repsubstr(str,size -4,"льной")
						elseif SubSize(str, size -4)=="дство" then
							str=repsubstr(str,size -4,"дства")
						elseif SubSize(str, size -3)=="алун" then
							str=repsubstr(str,size -3,"алуна")
						elseif SubSize(str, size -3)=="свая" then
							str=repsubstr(str,size -3,"сваи")
						elseif SubSize(str, size -3)=="весы" then
							str=repsubstr(str,size -3,"весов")
						elseif SubSize(str, size -3)=="Весы" then
							str=repsubstr(str,size -3,"Весов")
						elseif SubSize(str, size -3)=="шина" then
							str=repsubstr(str,size -3,"шины")
						elseif SubSize(str, size -3)=="ация" then
							str=repsubstr(str,size -3,"ации")
						elseif SubSize(str, size -3)=="всём" then
							str=repsubstr(str,size -3,"всём")
						elseif SubSize(str, size -3)=="ляры" then
							str=repsubstr(str,size -3,"ляров")
						elseif SubSize(str, size -3)=="ское" then
							str=repsubstr(str,size -3,"ского")
						elseif SubSize(str, size -3)=="атур" then
							str=repsubstr(str,size -3,"атуры")
						elseif SubSize(str, size -3)=="ение" then
							str=repsubstr(str,size -3,"ения")
						elseif SubSize(str, size -3)=="ание" then
							str=repsubstr(str,size -3,"ания")
						elseif SubSize(str, size -3)=="едия" then
							str=repsubstr(str,size -3,"едии")
						elseif SubSize(str, size -3)=="эрма" then
							str=repsubstr(str,size -3,"эрма")
						elseif SubSize(str, size -3)=="ночь" then
							str=repsubstr(str,size -3,"ночь")
						elseif SubSize(str, size -3)=="обие" then
							str=repsubstr(str,size -3,"обия")
						elseif SubSize(str, size -3)=="Стол" then
							str=repsubstr(str,size -3,"Стол")
						elseif SubSize(str, size -3)=="Улей" then
							str=repsubstr(str,size -3,"Улья")
						elseif SubSize(str, size -3)=="Пана" then
							str=repsubstr(str,size -3,"Пана")
						elseif SubSize(str, size -3)=="чина" then
							str=repsubstr(str,size -3,"чины")
						elseif SubSize(str, size -3)=="жина" then
							str=repsubstr(str,size -3,"жины")
						elseif SubSize(str, size -3)=="пуса" then
							str=repsubstr(str,size -3,"пуса")
						elseif SubSize(str, size -3)=="Вилы" then
							str=str:utf8sub(1, -2)
						elseif SubSize(str, size -3)=="вилы" then
							str=str:utf8sub(1, -2)
						elseif SubSize(str, size -3)=="стей" then
							str=repsubstr(str,size -3,"стей")
						elseif SubSize(str, size -3)=="ория" then
							str=repsubstr(str,size -3,"ории")
						elseif SubSize(str, size -3)=="мина" then
							str=repsubstr(str,size -3,"мины")
						elseif SubSize(str, size -3)=="фало" then
							str=repsubstr(str,size -3,"фало")
						elseif SubSize(str, size -2)=="зой" then
							str=repsubstr(str,size -2,"зой")
						elseif SubSize(str, size -2)=="йца" then
							str=repsubstr(str,size -2,"йца")
						elseif SubSize(str, size -2)=="для" then
							str=repsubstr(str,size -2,"для")
						elseif SubSize(str, size -2)=="арь" then
							str=repsubstr(str,size -2,"аря")
						elseif SubSize(str, size -2)=="Тэм" then
							str=repsubstr(str,size -2,"Тэм")
						elseif SubSize(str, size -2)=="тёр" then
							str=repsubstr(str,size -2,"тра")
						elseif SubSize(str, size -2)=="ейл" then
							str=repsubstr(str,size -2,"ейл")
						elseif SubSize(str, size -2)=="ина" then
							str=repsubstr(str,size ,"а")
						elseif SubSize(str, size -2)=="лун" then
							str=repsubstr(str,size -2,"лун")
						elseif SubSize(str, size -2)=="асы" then
							str=repsubstr(str,size -2,"асов")
						elseif SubSize(str, size -2)=="лей" then
							str=repsubstr(str,size -2,"лей")
						elseif SubSize(str, size -2)=="ода" then
							str=repsubstr(str,size -2,"ода")
						elseif SubSize(str, size -2)=="ера" then
							str=repsubstr(str,size -2,"ера")
						elseif SubSize(str, size -2)=="ний" then
							str=repsubstr(str,size -2,"него")
						elseif SubSize(str, size -2)=="щий" then
							str=repsubstr(str,size -2,"щего")
						elseif SubSize(str, size -2)=="ьей" then
							str=repsubstr(str,size -2,"ьей")
						elseif SubSize(str, size -2)=="еля" then
							str=repsubstr(str,size -2,"еля")
						elseif SubSize(str, size -2)=="ыга" then
							str=repsubstr(str,size -2,"ыги")
						elseif SubSize(str, size -2)=="шок" then
							str=repsubstr(str,size -2,"шка")							
						elseif SubSize(str, size -2)=="ина" then
							str=repsubstr(str,size -2,"ины")						
						elseif SubSize(str, size -2)=="ово" then
							str=repsubstr(str,size -2,"ова")
						elseif SubSize(str, size -2)=="ики" then
							str=repsubstr(str,size ,"ов")
						elseif SubSize(str, size -2)=="уса" then
							str=str:utf8sub(1, -2)
						elseif SubSize(str, size -2)=="нец" then
							str=repsubstr(str,size -2,"нец")
						elseif SubSize(str, size -2)=="ное" then
							str=repsubstr(str,size -2,"ного")
						elseif SubSize(str, size -2)=="чий" then
							str=repsubstr(str,size -2,"чего")
						elseif SubSize(str, size -2)=="ало" then
							str=str:utf8sub(1, -2)
						elseif SubSize(str, size -2)=="ота" then
							str=str:utf8sub(1, -2)
						elseif SubSize(str, size -1)=="ий" then
							str=repsubstr(str,size -1,"ого")
						elseif SubSize(str, size -1)=="ьё" then
							str=repsubstr(str,size -1,"ья")
						elseif SubSize(str, size -1)=="зд" then
							str=repsubstr(str,size -1,"зд")
						elseif SubSize(str, size -1)=="на" then
							str=repsubstr(str,size ,"ы")
						elseif SubSize(str, size -1)=="ль" then
							str=repsubstr(str,size ,"я")
						elseif SubSize(str, size -1)=="ые" then
							str=repsubstr(str,size -1,"ых")
						elseif SubSize(str, size -1)=="ок" then
							str=repsubstr(str,size -1,"ка")
						elseif SubSize(str, size -1)=="ка" then
							str=repsubstr(str,size -1,"ки")
						elseif SubSize(str, size -1)=="та" then
							str=repsubstr(str,size -1,"ты")
						elseif SubSize(str, size -1)=="ян" then
							str=repsubstr(str,size -1,"ян")
						elseif SubSize(str, size -1)=="ой" then
							str=repsubstr(str,size -1,"ого")
						elseif SubSize(str, size -1)=="ая" then
							str=repsubstr(str,size -1,"ой")
						elseif SubSize(str, size -1)=="ля" then
							str=str:utf8sub(1, -2)
						elseif SubSize(str, size -1)=="ло" then
							str=repsubstr(str,size -1,"ла")
						elseif SubSize(str, size -1)=="ол" then
							str=repsubstr(str,size -1,"ола")
						elseif SubSize(str, size -1)=="ом" then
							str=repsubstr(str,size -1,"ома")
						elseif SubSize(str, size -1)=="ья" then
							str=repsubstr(str,size -1,"ьей")
						elseif SubSize(str, size -1)=="ия" then
							str=repsubstr(str,size -1,"ий")
						elseif SubSize(str, size -1)=="из" then
							str=repsubstr(str,size -1,"из")
						elseif SubSize(str, size -1)=="па" then
							str=repsubstr(str,size -1,"пы")
						elseif SubSize(str, size -1)=="ще" then
							str=repsubstr(str,size -1,"ща")
						elseif SubSize(str, size -1)=="нь" then
							str=repsubstr(str,size -1,"ня")
						elseif SubSize(str, size -1)=="яя" then
							str=repsubstr(str,size -1,"ей")
						elseif SubSize(str, size -1)=="це" then
							str=repsubstr(str,size -1,"ца")
						elseif SubSize(str, size -1)=="ей" then
							str=repsubstr(str,size -1,"ья")
						elseif SubSize(str, size -1)=="ый" then
							str=repsubstr(str,size -1,"ого")
						elseif SubSize(str, size )=="ь" then
							str=repsubstr(str,size ,"и")
						elseif SubSize(str, size )=="я" then
							str=repsubstr(str,size ,"и")
						elseif SubSize(str, size )=="а" then
							str=repsubstr(str,size ,"ы")
						elseif sogl[SubSize(str, size )] then
							str=str.."а"
						-- end
				else
					if t.NamesGender["she"][objectname] then --женский род
						if SubSize(str, size -1)=="ая" then
							str=repsubstr(str,size -1,"ой")
						elseif SubSize(str, size -1)=="яя" then
							str=repsubstr(str,size -1,"ей")
						elseif SubSize(str, size -1)=="ья" then
							str=repsubstr(str,size ,"ей")
						elseif str:utf8sub(-4)=="аяся" then
							str=repsubstr(str,size -3,"ейся")
						end
					elseif t.NamesGender["it"][objectname] then --средний род
						if SubSize(str, size -2)=="кое" then
							str=repsubstr(str,size -1,"ого")
						elseif SubSize(str, size -1)=="ое" then
							str=repsubstr(str,size -1,"ого")
						elseif SubSize(str, size -1)=="ее" then
							str=repsubstr(str,size -1,"его")
						end
					elseif t.NamesGender["plural"][objectname] or
						   t.NamesGender["plural2"][objectname] then --множественное число
						if SubSize(str, size -1)=="ые" then
							str=repsubstr(str,size -1,"ых")
						elseif SubSize(str, size -1)=="ие" then
							str=repsubstr(str,size -1,"их")
						elseif SubSize(str, size -1)=="ьи" then
							str=repsubstr(str,size -1,"их")
						end
					elseif t.NamesGender["he"][objectname] or t.NamesGender["he2"][objectname] then--мужской род
						if SubSize(str, size -1)=="ый" then
							str=repsubstr(str,size -1,"ого")
						elseif SubSize(str, size -1)=="ий" then
							str=repsubstr(str,size -1,"его")
						elseif SubSize(str, size -1)=="ой" then
							str=repsubstr(str,size -1,"ого")
						end
					end
				end
			--Изучить (Кого? Что?) Винительный
			--применительно к имени свиньи или кролика
			elseif action and objectname and (objectname=="pigman" or objectname=="pigguard" or objectname=="bunnyman" or objectname:find("critter")~=nil) then
				if SubSize(str, size -2)=="нок" then
					str=SubSize(str, 1,size -2).."ка"
				elseif SubSize(str, size -2)=="лец" then
					str=SubSize(str, 1,size -2).."ьца"
				elseif SubSize(str, size -2)=="ный" then
					str=SubSize(str, 1,size -2).."ого"
				elseif SubSize(str, size -1)=="ец" then
					str=SubSize(str, 1,size -2).."ца"
				elseif SubSize(str, size )=="а" then
					str=SubSize(str, 1,size -1).."у"
				elseif SubSize(str, size )=="я" then
					str=SubSize(str, 1,size -1).."ю"
				elseif SubSize(str, size )=="ь" then
					str=SubSize(str, 1,size -1).."я"
				elseif SubSize(str, size )=="й" then
					str=SubSize(str, 1,size -1).."я"
				elseif sogl[SubSize(str, size )] then
					str=str.."а"
				end
			elseif action and not(objectname and objectname=="sketch") then --Изучить (Кого? Что?) Винительный
				if SubSize(str, size -1)=="ая" then
					str=repsubstr(str,size -1,"ую")
				elseif SubSize(str, size -1)=="яя" then
					str=repsubstr(str,size -1,"юю")
				elseif SubSize(str, size )=="а" then
					str=repsubstr(str,size ,"у")
				elseif SubSize(str, size )=="я" then
					str=repsubstr(str,size ,"ю")
				end
			end
			resstr=resstr..str..delimetr
			str=""
		end
	end
	resstr=resstr:utf8sub(1,resstr:utf8len()-1)
	subbed = nil
	--print("action: "..action.."resstr: "..resstr)
	return resstr
end
t.rebuildname = rebuildname

-- Для тестировки имен
if DEBUG_ENABLED then
	require("rlp_debug")
end

t.RussianNames = {} --Таблица с особыми формами названий предметов в различных падежах
t.ShouldBeCapped = {} --Таблица, в которой находится список названий, первое слово которых пишется с большой буквы

--Таблица со списками имён, отсортированными по полам
t.NamesGender={
	he = {},
	he2 = {},
	she = {},
	it = {},
	plural = {},
	plural2 = {},
}

--Объявляем таблицу особых тегов, присущих персонажам.
--Порядковый номер тега определяет его приоритет.
t.CharacterInherentTags={}
for char in pairs(GetActiveCharacterList()) do
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
	return firstletter..tmp:utf8sub(2)
end

--первый символ в верхний регистр
local function firsttoupper(tmp)
	if not tmp then return end
	local firstletter=tmp:utf8sub(1,1)
	firstletter = LetterCasesHash.l2u[firstletter] or firstletter
	return firstletter..tmp:utf8sub(2)
end

local function isupper(letter)
	if not letter or type(letter)~="string" then return end
	return LetterCasesHash.u2l[letter] or (#letter==1 and letter>="A" and letter<="Z")
end

local function islower(letter)
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
		res = res..letter
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
		res = res..letter
	end
	return res
end


--Функция меняет окончания прилагательного prefix в зависимости от падежа, пола и числа предмета
local FixPrefix
do
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
	endings["ASSESSPLANTHAPPINESS"] = endings["gen"]
	endings["PLANTREGISTRY_RESEARCH"] = endings["acc"]	
	endings["INTERACT_WITH"] = endings["abl"]
	endings["STEER_BOAT"] = endings["abl"]	
	endings["CHARGE_FROM"] = endings["gen"]	

	-- для рода реликвий, т.к. имеем одно выводимое имя, но разные префабы
	local relics = {ruins_chair=1, ruins_table=1, ruins_vase=1, ruins_plate=1, ruins_bowl=1, ruins_chipbowl=1}

	FixPrefix = function(prefix, act, item)
		if not t.NamesGender then return prefix end
		--Определим пол
		local gender="he"
		if endings["nom"][item] then --Если item содержит непосредственно пол
			gender = item
		else
			if t.NamesGender["he2"][item] then gender="he2"
			elseif t.NamesGender["she"][item] then gender="she"
			elseif t.NamesGender["it"][item] then gender="it"
			elseif t.NamesGender["plural"][item] then gender="plural"
			elseif t.NamesGender["plural2"][item] then gender="plural2"
			elseif relics[item] then gender="she" 
			end
		end		

		--Особый случай. Для действия "Собрать" у меня есть три записи с заменённым текстом. Там получается множественное число.
		if act=="PICK" and item and t.RussianNames[STRINGS.NAMES[string.upper(item)]] and t.RussianNames[STRINGS.NAMES[string.upper(item)]][act] then gender="plural" end
 
		--Смена пола префикса для ВЫРОСШЕГО урожая на грядках, пол берём из плода
		--пример: для выросшей моркови "NAMES.FARM_PLANT_CARROT" пол берётся из "NAMES.CARROT"
		if act=="PICK" and item then
			local plant = ""

		 	if item:utf8sub(1,11)=="farm_plant_" then
				plant = item:utf8sub(12)
			elseif item:utf8sub(1,5)=="weed_" then 
				plant = item:utf8sub(6)
			else 
				plant = string.lower(item)	-- гниль, ...
			end

			if plant then
				if t.NamesGender["he"][plant] then gender="he"
				elseif t.NamesGender["she"][plant] then gender="she"
				elseif t.NamesGender["it"][plant] then gender="it"
				end
			end
		end			

		--Ищем переданное действие в таблице выше
		act = endings[act] and act or (item and "DEFAULTACTION" or "nom")

		local words=string.split(prefix," ") --разбиваем на слова
		prefix=""
		for _, word in ipairs(words) do
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
			if CHARACTER_GENDERS.MALE and table.contains(CHARACTER_GENDERS.MALE, char) then gender="he"
			elseif CHARACTER_GENDERS.FEMALE and table.contains(CHARACTER_GENDERS.FEMALE, char) then gender="she"
			elseif CHARACTER_GENDERS.ROBOT and table.contains(CHARACTER_GENDERS.ROBOT, char) then gender="he"
			elseif CHARACTER_GENDERS.IT and table.contains(CHARACTER_GENDERS.IT, char) then gender="it"
			elseif CHARACTER_GENDERS.NEUTRAL and table.contains(CHARACTER_GENDERS.IT, char) then gender="neutral"
			elseif CHARACTER_GENDERS.PLURAL and table.contains(CHARACTER_GENDERS.PLURAL, char) then gender="plural" end
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

-- Загружаем спич
require("rlp_speech")

--Подменяем названия режимов игры
if rawget(_G, "GAME_MODES") and STRINGS.UI.GAMEMODES then
	for i,v in pairs(GAME_MODES) do
		for ii,vv in pairs(STRINGS.UI.GAMEMODES) do
			if v.text==vv then
				GAME_MODES[i].text = t.PO["STRINGS.UI.GAMEMODES."..ii] or GAME_MODES[i].text
			end
			if v.description==vv then
				GAME_MODES[i].description = t.PO["STRINGS.UI.GAMEMODES."..ii] or GAME_MODES[i].description
			end
		end
	end
end

-- cклоняем названия вещей в пожитках
function GetSkinUsableOnString(item_type, popup_txt)
	local skin_data = GetSkinData(item_type)

	local skin_str = GetSkinName(item_type)

	local usable_on_str
	if skin_data ~= nil and skin_data.base_prefab ~= nil then
        local item1_str, item2_str, item3_str
        item1_str = t.RussianNames[STRINGS.NAMES[string.upper(skin_data.base_prefab)]] and t.RussianNames[STRINGS.NAMES[string.upper(skin_data.base_prefab)]]["RESKIN"] or rebuildname(STRINGS.NAMES[string.upper(skin_data.base_prefab)], "reskin", string.upper(skin_data.base_prefab))
        if skin_data.granted_items ~= nil then
            local granted_skin_data = GetSkinData(skin_data.granted_items[1])
            if granted_skin_data ~= nil and granted_skin_data.base_prefab ~= nil then
                item2_str = t.RussianNames[STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)]] and t.RussianNames[STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)]]["RESKIN"] or rebuildname(STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)], "reskin", string.upper(granted_skin_data.base_prefab))
                if item2_str == item1_str then
                    item2_str = nil
                end
            end
            granted_skin_data = GetSkinData(skin_data.granted_items[2])
            if granted_skin_data ~= nil and granted_skin_data.base_prefab ~= nil then
                item3_str = t.RussianNames[STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)]] and t.RussianNames[STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)]]["RESKIN"] or rebuildname(STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)],"reskin",string.upper(granted_skin_data.base_prefab))
                if item2_str == nil and item3_str ~= item1_str then
                    item2_str = item3_str
                    item3_str = nil
                elseif item1_str == item3_str or item2_str == item3_str then
                    item3_str = nil
                end
            end
        end
        if item2_str == nil then
            usable_on_str = subfmt(popup_txt and STRINGS.UI.SKINSSCREEN.USABLE_ON_POPUP or STRINGS.UI.SKINSSCREEN.USABLE_ON, { skin = skin_str, item = item1_str })
        elseif item3_str == nil then
            usable_on_str = subfmt(popup_txt and STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE_POPUP or STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE, { skin = skin_str, item1 = item1_str, item2 = item2_str })
        else
            usable_on_str = subfmt(popup_txt and STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE_3_POPUP or STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE_3, { skin = skin_str, item1 = item1_str, item2 = item2_str, item3 = item3_str })
        end
	end

	return usable_on_str or ""
end

require("widgets/eventannouncer")
--Переопределяем глобальную функцию, формирующую анонс-сообщение о смерти
--Делаем это тут, потому что она объявлена в классе eventannouncer, и не видна до обращения к этому классу.
--Тут нам нужно позаботиться об выводе имени убийцы на английском языке.
local _GetNewDeathAnnouncementString = GetNewDeathAnnouncementString
function GetNewDeathAnnouncementString(theDead, source, pkname)
	local str = _GetNewDeathAnnouncementString(theDead, source, pkname)
	if TheWorld and not TheWorld.ismastersim then return str end
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
--Сообщение о том, что кто-то был оживлён. Тут нужно подменить на английский источник оживления
local _GetNewRezAnnouncementString = GetNewRezAnnouncementString
function GetNewRezAnnouncementString(theRezzed, source, ...)
	source = source and (t.SpeechHashTbl.NAMES.Rus2Eng[source] or source) --Переводим имя на английский
	return _GetNewRezAnnouncementString(theRezzed, source, ...)
end

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
		message = (type(message)=="table") and GetRandomItem(message) or message
		if char=="WATHGRITHR" and Profile:IsWathgrithrFontEnabled() then
			message = message:gsub("о","ö"):gsub("О","Ö") or message
		end
		-- if umlautified then
		-- 	if rawget(_G, "GetSpecialCharacterPostProcess") then
		-- 		--подменяем русские на английские, чтобы работала Umlautify
		-- 		local tmp = message:gsub("о","o"):gsub("О","O") or message
		-- 		message = GetSpecialCharacterPostProcess("wathgrithr", tmp) or message
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

--[[
--Формирует тестовую функцию для проверки перевода
if not rawget(_G,"test") then
	ch_nm("HE","he","he")
	ch_nm("HE2","he2","he2")
	ch_nm("SHE","she","she")
	ch_nm("IT","it","it")
	ch_nm("PLURAL","plural","plural")
	ch_nm("PLURAL2","plural2","plural2")

	local genders_reg={"he","he2","she","it","plural","plural2", --numbers
		he="he",he2="he2",she="she",it="it",plural="plural",plural2="plural2"};
	rawset(_G,"test",function(name,gender)
		print('-------------------------------------')
		if genders_reg[gender] then
			gender = genders_reg[gender]
			testname(name,gender)
			print("("..gender..")")
		else
			testname(name,"he")
			print("(he - default)")
		end
	end)
	--Пример работы функции: test("Пастила","she")
	--Или: test("Пастила",3) --был убит пастилой
	--Или неправильный вариант: test("Пастила",2) --был убит пастила
end
]]

--Переводит сообщение на русский, пользуясь хеш-таблицами
--message - сообщение на английском
--entity - ссылка на говорящего это сообщение персонажа
function t.TranslateToRussian(message, entity)
	t.print("t.TranslateToRussian", message, entity.prefab)

	if not (entity and entity.prefab and entity.components.talker and type(message)=="string") then return message end

	local new_line = string.find(message,"\n",1,true)
	if new_line ~= nil then
		local mess1 = message:sub(1, new_line - 1)
		if t.mod_phrases[mess1] then
			local mess2 = message:sub(new_line)
			return t.mod_phrases[mess1] .. mess2
		end
	elseif t.mod_phrases[message] then
		return t.mod_phrases[message]
	end

	if entity:HasTag("playerghost") then --Если это реплика игрока-привидения
		message=string.gsub(message, "h", "у")
		return message
	end

	if entity.prefab == "quagmire_goatmum" then
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
	elseif entity.prefab == "monkeyqueen" then -- реплики Королевы лунной пристани
		if t.SpeechHashTbl.MONKEY_QUEEN.Eng2Rus[message] then
			message = t.SpeechHashTbl.MONKEY_QUEEN.Eng2Rus[message] or message
		end
	elseif entity.prefab == "mermking" then -- реплики Короля мэрмов
		if t.SpeechHashTbl.MERM_KING.Eng2Rus[message] then
			message = t.SpeechHashTbl.MERM_KING.Eng2Rus[message] or message
		end
	end

	-- осмотр надгробий	
	if t.SpeechHashTbl.EPITAPHS.Eng2Rus[message] then
		message = t.SpeechHashTbl.EPITAPHS.Eng2Rus[message] or message
	end

	local ent = entity
	entity = entity.prefab:upper()
	if entity == "WILSON" or entity == "WONKEY" then entity = "GENERIC" end
	if entity == "MAXWELL" then entity = "WAXWELL" end
	if entity == "WIGFRID" then entity = "WATHGRITHR" end

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
					if not t.ShouldBeCapped[killerkey:lower()] and not table.contains(GetActiveCharacterList(), killerkey:lower()) then
						mentions[2]=firsttolower(mentions[2])
					end
					killerkey=killerkey:lower()
					if table.contains(GetActiveCharacterList(), killerkey) then killerkey=nil end
				end
			end
		end
		--Подстраиваем сообщение под пол персонажа
		message=(t.ParseTranslationTags(message, ent.prefab, nil, killerkey)) or message
		--Добавляем записям вида "число%" дополнительный знак % для работы функции string.format
		message=string.gsub(message, "%d%%", "%1%%")
		--Подставляем имена, если они есть
		message=string.format(message, unpack(mentions or {"","","",""}))
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
local _Networking_Talk = Networking_Talk
function Networking_Talk(guid, message, ...)
	local entity = Ents[guid]
	t.print("Networking_Talk", entity, message)
	message = t.TranslateToRussian(message, entity) or message --Переводим на русский
	return _Networking_Talk(guid, message, ...)
end

-- исправление умлаутов Вигфрид в чате
local _Networking_Say = Networking_Say
function Networking_Say(guid, userid, name, prefab, message, ...)
	if prefab=="wathgrithr" and Profile:IsWathgrithrFontEnabled() then
		message = message:gsub("о","ö"):gsub("О","Ö") or message
	end
	return _Networking_Say(guid, userid, name, prefab, message, ...)
end

--Перевод на русский произносимого на сервере
local _Talker = NetworkProxy.Talker
NetworkProxy.Talker = function(self, message, entity, ...)
	t.print("entity", entity)
	local inst = entity and entity:GetGUID() or nil
	inst = inst and Ents[inst] or nil --определяем инстанс персонажа по entity

	if inst and message then
		message = t.TranslateToRussian(message, inst) or message --переводим
	end

	return _Talker(self, message, entity, ...)
end

--Сообщения о событиях в игре
AddClassPostConstruct("widgets/eventannouncer", function(self)
	--Вывод любых анонсов на экран. Тут подменяем все нестандартные фразы, и не только
	local _ShowNewAnnouncement = self.ShowNewAnnouncement
	if _ShowNewAnnouncement then function self:ShowNewAnnouncement(announcement, ...)

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

		-- Даем возможность модам переводить аннонсы
		for eng, rus in pairs(t.mod_announce) do
			test(nil, eng, rus)
		end

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
					if not t.ShouldBeCapped[killerkey:lower()] and not table.contains(GetActiveCharacterList(), killerkey:lower()) then
						name2=firsttolower(name2)
					end
					killerkey=killerkey:lower()
					if table.contains(GetActiveCharacterList(), killerkey) then killerkey=nil end
				end
			end
		end
		if name and RussianMessage then
			announcement = string.format((t.ParseTranslationTags(RussianMessage, "wilson", "announce", killerkey)), name or "", name2 or "", "" ,"") or announcement
		end
		return _ShowNewAnnouncement(self, announcement, ...)
	end end
end) -- для AddClassPostConstruct "widgets/eventannouncer"

--Тут мы должны переделать описание скелета, чтобы в него не попал русский
-- Жуть какая. Столько кода просто для перевода скелета
AddPrefabPostInit("skeleton_player", function(inst)
	local function reassignfn(inst) --функция переопределяет функцию. Туповато, но менять лень
		inst.components.inspectable.Oldgetspecialdescription=inst.components.inspectable.getspecialdescription
		function inst.components.inspectable.getspecialdescription(inst, viewer, ...)
			local oldGetDescription=GetDescription
			GetDescription=function(viewer1, inst1, tag)
				local ret=oldGetDescription(viewer1, inst1, tag)
				ret=t.ParseTranslationTags(ret, inst1.cause, nil, nil)
				return ret
			end
			local message=inst.components.inspectable.Oldgetspecialdescription(inst, viewer, ...)
			GetDescription=oldGetDescription
			if not message then return message end

			local player=ThePlayer
			local key=player and player.prefab:upper() or "GENERIC"
--				local key=inst.char:upper()
			local deadgender=GetGenderStrings(inst.char)
			local m=STRINGS.CHARACTERS[key] and STRINGS.CHARACTERS[key].DESCRIBE and STRINGS.CHARACTERS[key].DESCRIBE.SKELETON_PLAYER and STRINGS.CHARACTERS[key].DESCRIBE.SKELETON_PLAYER[deadgender] or STRINGS.CHARACTERS.GENERIC.DESCRIBE.SKELETON_PLAYER[deadgender]
			m=t.ParseTranslationTags(m, inst.cause, nil, nil)
			if not m then return message end
			local dead,killer=string.match(message,(string.gsub(m,"%%s","(.*)"))) --вытаскиваем имена из сообщения
			if not (m and dead and killer) then return message end

			dead=inst.playername or t.SpeechHashTbl.NAMES.Rus2Eng[dead] or dead --переводим на английский имя убитого
			if t.SpeechHashTbl.NAMES.Rus2Eng[killer] and inst.pkname == nil then
				local mentions=t.SpeechHashTbl.NAMES.Rus2Eng[killer]
				local killerkey=t.SpeechHashTbl.NAMES.Eng2Key[mentions] --Получаем ключ имени убийцы
				t.print("[RLP DEBUG] 2302 "..killerkey)

				if not killerkey and key=="WX78" then --тут только полный перебор, т.к. он говорит всё в верхнем регистре
					for eng, key in pairs(t.SpeechHashTbl.NAMES.Eng2Key) do
						if eng:upper()==mentions then killerkey = key break end
					end
				end

				mentions=killerkey and STRINGS.NAMES[killerkey] or mentions
				if killerkey then
					mentions=t.RussianNames[mentions] and t.RussianNames[mentions]["KILL"] or rebuildname(mentions,"KILL",killerkey) or mentions
					if not t.ShouldBeCapped[killerkey:lower()] and not table.contains(GetActiveCharacterList(), killerkey:lower()) then
						mentions=firsttolower(mentions)
					end

					killerkey=killerkey:lower()
					if table.contains(GetActiveCharacterList(), killerkey) then
						killerkey=nil
					end
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
-- TODO: проверить работу AddPrefabPostInit
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

--Остальное не выполняется, если перевод в режиме только чата
do
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
					Old(obj, unpack(params))
					if DoAfter then fn(obj, ...) end
				end
			end
		end
	end

	--Подменяем портреты
	local TRANSLATED_LIST = {
		wortox = true,
		warly = true,
		wanda = true,
		wurt = true,
		winona = true,
		wickerbottom = true,
		waxwell = true,
		willow = true,
		wilson = true,
		woodie = true,
		wes = true,
		wolfgang = true,
		wendy = true,
		wathgrithr = true,
		webber = true,
		wormwood = true,
		walter = true,

		random = true,
	}

	require("characterutil")

	local _SetHeroNameTexture_Grey = SetHeroNameTexture_Grey
	local _SetHeroNameTexture_Gold = SetHeroNameTexture_Gold

	function SetHeroNameTexture_Grey(w, hero, ...)
		if TRANSLATED_LIST[hero] then
			w:SetTexture("images/rus_names_"..hero..".xml", "rus_"..hero..".tex")
			return true
		end
		return _SetHeroNameTexture_Grey(w, hero, ...)
	end

	function SetHeroNameTexture_Gold(w, hero, ...)
		if TRANSLATED_LIST[hero] then
			w:SetTexture("images/rus_names_gold_"..hero..".xml", "rus_"..hero..".tex")
			return true
		end
		return _SetHeroNameTexture_Gold(w, hero, ...)
	end

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
		local _UpdateData = self.UpdateData
		function self:UpdateData(data)
			_UpdateData(self, data)
			if self.age and data.playerage then
				local newstr=self.age:GetString()
				newstr = newstr:gsub("Прожито", StringTime(data.playerage, {"Прожит", "Прожито", "Прожиты"}),1)
				self.age:SetString(newstr:gsub("Дней", StringTime(data.playerage),1))
			end
		end
	end)

	--Переводим названия дней недели
	-- неактуально? 10/2023
	--[[local _ListSnapshots = NetworkProxy.ListSnapshots
	NetworkProxy.ListSnapshots = function(self, ...)
		local lis t =_ListSnapshots(self, ...) or {}
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
	end]]

	--Окно просмотра серверов, двигаем контролсы, исправляем надписи
	local function ServerListingScreenPost1(self)
		if self.filters then
			for i, v in pairs(self.filters) do
				if v.label and v.label.SetFont then
					v.label:SetFont(CHATFONT)
				end
				if v.spinner and v.spinner.SetFont then
					v.spinner:SetFont(CHATFONT)
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


	do
		-- Named игнорит перевод и отправляет сроку прям с сервера
		local NAMES_OVERRIDE = {
			moose = {STRINGS.NAMES.MOOSE1, STRINGS.NAMES.MOOSE2},
			mooseegg = { STRINGS.NAMES.MOOSEEGG1, STRINGS.NAMES.MOOSEEGG2 },
		}

		AddClassPostConstruct("components/named_replica", function(self)
			local possible_names = NAMES_OVERRIDE[self.inst]

			local function OnNameDirty(inst)
				if inst.prefab == "sketch" then
					local sketch_name = ""

					if not TheWorld.ismastersim then
						sketch_name = inst.name:gsub("(%a+)%sFigure%sSketch", "%1")
						sketch_name = "CHESSPIECE_"..sketch_name:gsub(" ", ""):upper()
						sketch_name = STRINGS.NAMES[sketch_name] or inst.name
						sketch_name = sketch_name:gsub("Фигура", "Эскиз фигуры")
					else
						sketch_name = inst.name:gsub("Фигура", "фигуры")
					end

					inst.name = sketch_name
				elseif possible_names ~= nil then
					inst.name = possible_names[math.random(#inst.possible_names)]
				end
			end

			self.inst:ListenForEvent("namedirty", OnNameDirty)
			self.inst:DoTaskInTime(0, OnNameDirty)
		end)
	end

	--Сохраняем непереведённый текст настроек приватности серверов в свойствах мира (см. ниже)
	local privacy_options = {}
	for i,v in pairs(STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY) do
		privacy_options[v] = i
	end

	-- перевод ServerDetailIcon HoverText
	-- согласование окончания сезона, разделение дня
	AddClassPostConstruct("widgets/redux/serversaveslot", function(self)		
		self.cloud:SetHoverText(STRINGS.UI.SERVERLISTINGSCREEN.CLOUD_SAVE_HOVER)
		self.mods:SetHoverText(STRINGS.UI.SERVERLISTINGSCREEN.MODS_ICON_HOVER)
		self.pvp:SetHoverText(STRINGS.UI.SERVERLISTINGSCREEN.PVP_ICON_HOVER)

		local oldSetSaveSlot = self.SetSaveSlot
		function self:SetSaveSlot(slot, server_data)
			oldSetSaveSlot(self, slot, server_data)
			self.slot = slot

			local Levels = require "map/levels"	
			local server_data = server_data or ShardSaveGameIndex:GetSlotServerData(self.slot)
			local privacy_options = { 
				STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY.PUBLIC,
				STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY.FRIENDS,
				STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY.LOCAL,
				STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY.CLAN,
			}			

			if server_data and server_data.privacy_type then
				self.privacy:SetHoverText(privacy_options[server_data.privacy_type+1])
			end

			if server_data and server_data.playstyle then
				local playstyle_def = server_data.playstyle ~= nil and Levels.GetPlaystyleDef(server_data.playstyle) or nil

				if playstyle_def ~= nil then
					self.playstyle:SetHoverText(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[playstyle_def.default_preset])
				end
			end

			local DayAndSeasonText = self.serverslotscreen:GetDayAndSeasonText(self.slot)
			if DayAndSeasonText:find("Лето") ~= nil then
				if DayAndSeasonText:find("Ранняя") ~= nil then
					DayAndSeasonText = DayAndSeasonText:gsub("Ранняя","Раннее")
				elseif DayAndSeasonText:find("Поздняя") ~= nil then
					DayAndSeasonText = DayAndSeasonText:gsub("Поздняя","Позднее")
				end
			end
			if DayAndSeasonText:find(" День") ~= nil then
				DayAndSeasonText = DayAndSeasonText:gsub(" День",", День")
			end

			DayAndSeasonText = firsttoupper(russianlower(DayAndSeasonText))

			self.day_and_season:SetString(DayAndSeasonText)
		end
	end)

	-- перевод настроек приватности сервера
	AddClassPostConstruct("widgets/redux/serversettingstab", function(self)
		local oldUpdateSlot = self.UpdateSlot
		function self:UpdateSlot()
			oldUpdateSlot(self)
			for i,v in ipairs(self.privacy_type.buttons.buttonwidgets) do
				v.button.text:SetFont(NEWFONT)
				v.button:SetTextSize(self.privacy_type.buttons.buttonsettings.font_size-2)
			end
		end

		if self.privacy_type and self.privacy_type.buttons and self.privacy_type.buttons.buttonwidgets then
			for _,option in pairs(self.privacy_type.buttons.options) do
				if privacy_options[option.text] then
					option.text = STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY[ privacy_options[option.text] ]
				end

			end
		end
	end)

	-- перевод виджета выбора свойств мира
	AddClassPostConstruct("widgets/redux/worldsettings/settingslist", function(self)
		local num_columns = 3

		function self:RefreshOptionItems()			
			local opts_text = { ["No Day"]="Без дня", ["No Dusk"]="Без вечера", ["No Night"]="Без ночи", ["Long Day"]="Длинный день", 
							  ["Long Dusk"]="Длинный вечер", ["Long Night"]="Длинная ночь", ["Only Day"]="Только день", 
							  ["Only Dusk"]="Только вечер", ["Only Night"]="Только ночь", ["Auto"]="Авто", ["Underground"]="Под землёй" }

		    if not self.scroll_list then return end
		    self.options = self.parent_widget:GetOptions()
		    self.optionitems = {}
		    local lastgroup = nil

		    for i,v in ipairs(self.options) do
		        if v.group ~= lastgroup then
		            local wrapped_index = #self.optionitems % num_columns
		            if wrapped_index > 0 then
		                for col = wrapped_index + 1, num_columns do
		                    table.insert(self.optionitems, {is_empty = true})
		                end
		            end
					-- добавление и перевод заголовков
		            table.insert(self.optionitems, {heading_text = STRINGS.UI.SANDBOXMENU[t.SpeechHashTbl.SANDBOXMENU.Eng2Key[v.grouplabel]] or v.grouplabel})
		            for col = 2, num_columns do
		                table.insert(self.optionitems, {is_empty = true})
		            end
		            lastgroup = v.group
		        end
				if v.options then
					for ii,vv in pairs(v.options) do
						-- добавление и перевод значений спинеров
						v.options[ii].text = opts_text[vv.text] or STRINGS.UI.SANDBOXMENU[t.SpeechHashTbl.SANDBOXMENU.Eng2Key[vv.text]] or vv.text
					end
				end
		        table.insert(self.optionitems, {option = v})
		    end
		    local wrapped_index = #self.optionitems % num_columns
		    if wrapped_index > 0 then
		        for col = wrapped_index + 1, num_columns do
		            table.insert(self.optionitems, {is_empty = true})
		        end
		    end

		    self.forceupdate = true
		    self.scroll_list:SetItemsData(self.optionitems)
		    self.forceupdate = false
		    self.scroll_list:SetPosition(self.scroll_list:CanScroll() and -15 or 0, 0)
		end
	end)

	-- расширение блока описания стиля игры сервера
	AddClassPostConstruct("screens/redux/playstyleselectscreen", function(self)
		local oldUpdateStyleInfo = self.UpdateStyleInfo
		function self:UpdateStyleInfo(w)
			if self and self.description and w and w.settings_desc then
				self.description:SetMultilineTruncatedString(w.settings_desc, 3, 750, nil, true, true)
			end
		end
	end)

--Перегоняем перевод в STRINGS
TranslateStringTable(STRINGS)

	do
		local Levels = require("map/levels")

		-- шаблоны настроек (пресеты) при создании мира [для presetpopupscreen]
		-- перевод имени
		local oldGetList = Levels.GetList
		Levels.GetList = function(category, ...)		
			local ret = oldGetList(category, ...)		
			for i, data in ipairs(ret) do
				if data.text ~= nil then
					ret[i].text = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[data.data] or data.text
				end
			end		

			return ret
		end
		-- перевод описания [для presetpopupscreen]
		local oldGetDataForSettingsID = Levels.GetDataForSettingsID
		Levels.GetDataForSettingsID = function(data, ...)
			local ret = oldGetDataForSettingsID(data, ...)		
			ret.settings_desc = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC[data] or ret.settings_desc

			return ret
		end

		-- имя и описание стиля игры
		local oldGetPlaystyleDef = Levels.GetPlaystyleDef
		Levels.GetPlaystyleDef = function(playstyle_id)
			local ret = oldGetPlaystyleDef(playstyle_id)		
			ret.name = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[ret.default_preset] or ret.name
			ret.desc = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC[ret.default_preset] or ret.desc

			return ret
		end
	end

	--Исправление перевода спиннеров в настройках
	--Исправление бага с шрифтом в спиннерах
	--выше есть версия для фикса только шрифта--
	AddClassPostConstruct("widgets/spinner", function(self, options, width, height, textinfo, ...)
		local spinners_text = { ["All"]="Все", ["Tips Only"]="Только советы", ["Lore Only"]="Лор игры", ["None"]="Нет", 
									["Separated"]="Отдельное", ["Integrated"]="Совмещённое", ["Most"]="Большинство", ["Important"]="Важные" }

		local oldUpdateText = self.UpdateText
		function self:UpdateText(msg)
			local text = STRINGS.UI.OPTIONS[string.upper(msg)] or spinners_text[msg] or msg
			oldUpdateText(self, text)
		end

		if textinfo then return end
		self.text:SetFont(BUTTONFONT)
	end)

	-- перевод выбранного пресета
	AddClassPostConstruct("widgets/redux/worldsettings/worldsettingsmenu", function(self)
		local Levels = require "map/levels"

		local oldGetNameForID = Levels.GetNameForID
		Levels.GetNameForID = function(levelcategory, preset)
			local ret = oldGetNameForID(levelcategory, preset)
			if ret and STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[preset] then
				ret = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[preset]
			end
			return ret
		end

		local oldGetDescForID = Levels.GetDescForID
		Levels.GetDescForID = function(levelcategory, preset)
			local ret = oldGetDescForID(levelcategory, preset)
			if ret and STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC[preset] then
				ret = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC[preset]
			end
			return ret
		end
	end)

	-- перевод playstyle HoverText
	AddClassPostConstruct("widgets/redux/worldsettings/presetbox", function(self)
		local Levels = require "map/levels"
		local oldSetPlaystyleIcon = self.SetPlaystyleIcon

		function self:SetPlaystyleIcon(playstyle_id)
			oldSetPlaystyleIcon(self, playstyle_id)
			local playstyle_def = playstyle_id ~= nil and Levels.GetPlaystyleDef(playstyle_id) or nil

			if playstyle_def ~= nil then
				self.playstyle.icon:SetHoverText(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[playstyle_def.default_preset])
			end
		end

		-- и чтоб влезало
		self.presetdesc:SetSize(18)
		self.presetdesc:SetRegionSize(230, 160)
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

end

--Дядька, продающий скины должен склонять слова под названия вещей
AddClassPostConstruct("widgets/skincollector", function(self)
	if not self.Say then return end
	if self.text then
		self.text:SetSize(self.text.size-5)
	end
	local OldSay = self.Say
	function self:Say(text, rarity, name, number, ...)
		if type(text) == "table" then
			text = GetRandomItem(text)
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

-- применяем шрифт при выборе скина в меню крафта предмета
AddClassPostConstruct("widgets/redux/craftingmenu_skinselector", function(self)
	self.spinner.text:SetFont(UIFONT)
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

--Исправляем жёстко зашитые надписи на кнопках в контейнерах
do
	local CONTAINER_TEXT = {
		"COOK",
		"SPICE",
		"WRAPBUNDLE",
		"APPLYCONSTRUCTION",
	}

	TRANSLATED_BTNS = {
		[STRINGS.ACTIONS.ACTIVATE.GENERIC] = t.PO["STRINGS.ACTIONS.ACTIVATE.GENERIC"],
	}

	for _, str in ipairs(CONTAINER_TEXT) do
		TRANSLATED_BTNS[STRINGS.ACTIONS[str]] = t.PO["STRINGS.ACTIONS."..str]
	end

	AddClassPostConstruct("widgets/containerwidget", function(self)
		local _Open = self.Open
		function self:Open(container, doer, ...)
			_Open(self, container, doer, ...)
			if self.button then
				local text = self.button:GetText()
				if text and TRANSLATED_BTNS[text] then
					self.button:SetText(TRANSLATED_BTNS[text])
				end
			end
		end
	end)
end

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

				if (self.skins_options and #self.skins_options == 1) or not self.skins_options then
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
						local function NewSetTruncatedString(self1,str, maxwidth, maxcharsperline, ellipses)
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

AddClassPostConstruct("widgets/quagmire_recipepopup", function(self) --Для горга то же самое
	local _Refresh = self.Refresh or function(...) end

	function self:Refresh(...)
		_Refresh(self, ...)

		if self.desc then
			self.desc:SetSize(28)
			--Перезаписмываем строку
			self.desc:SetString("")
			self.desc:SetMultilineTruncatedString(STRINGS.RECIPE_DESC[string.upper(self.recipe.product) or "ERROR!"], 2, 320, nil, true)
		end
	end
end)

--Перевод настроек приватности при создании сервера (неактуально? 23.11.24)
--[[AddClassPostConstruct("screens/redux/cloudserversettingspopup", function(self)
	local oldRefreshPrivacyButtons = self.RefreshPrivacyButtons
	function self:RefreshPrivacyButtons()
		oldRefreshPrivacyButtons(self)
		for i,v in ipairs(self.privacy_type.buttons.buttonwidgets) do
			v.button.text:SetFont(NEWFONT)
			v.button:SetTextSize(self.privacy_type.buttons.buttonsettings.font_size-2)
		end
	end
	if self.privacy_type and self.privacy_type.buttons and self.privacy_type.buttons.buttonwidgets then
		for _,option in pairs(self.privacy_type.buttons.options) do
			if option.data==PRIVACY_TYPE.PUBLIC then
				option.text = STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY.PUBLIC
			end
			if option.data==PRIVACY_TYPE.CLAN then
				option.text = STRINGS.UI.SERVERCREATIONSCREEN.PRIVACY.CLAN
			end
		end
		for i,v in ipairs(self.privacy_type.buttons.buttonwidgets) do
			v.button.text:SetFont(NEWFONT)
			v.button:SetTextSize(self.privacy_type.buttons.buttonsettings.font_size-2)
		end
	end
	self.privacy_type.buttons:UpdateButtons()
end)]]

do
	local translations = {
		["Cancel"] = "Отмена",
		["Random"] = "Случайно",
		["Write it!"] = "Написать!",
	}

	AddClassPostConstruct("widgets/writeablewidget", function(self)
		if self.menu and self.menu.items then
			for i,v in pairs(self.menu.items) do
				if v.text and translations[v.text:GetString()] then
					v.text:SetString(translations[v.text:GetString()])
				end
			end
		end
	end)
end

--сочетаем слово "День" с количеством дней
AddClassPostConstruct("widgets/truescrolllist", function(self)
	local months = {Jan="Янв.",Feb="Февр.",Mar="Март",Apr="Апр.",May="Мая",Jun="Июня",Jul="Июля",Aug="Авг.",Sept="Сент.",Oct="Окт.",Nov="Нояб.",Dec="Дек."}
	local list={["day.tex"]=1,
				["season.tex"]=1,
				["season_start.tex"]=1,
				["world_size.tex"]=1,
				["world_branching.tex"]=1,
				["world_loop.tex"]=1,
				["world_map.tex"]=1,
				["world_start.tex"]=1,
				["starting_variety.tex"]=1,
				["winter.tex"]=1,
				["summer.tex"]=1,
				["autumn.tex"]=1,
				["spring.tex"]=1}

	local oldupdate_fn=self.update_fn
	self.update_fn=function(context, widget, data, index)
		oldupdate_fn(context, widget, data, index)
		if widget.opt_spinner and widget.opt_spinner.spinner.options then
			if data and data.option and data.option.image then
				if list[data.option.image] then
					widget.opt_spinner.image:SetTexture("images/rus_mapgen.xml", "rus_"..data.option.image)
					widget.opt_spinner.image:SetSize(50,50)
				end
			end
		end
		--[[if data and data.item_type and widget.text then
			local x, y = widget.text:GetRegionSize()
			widget.text:SetRegionSize(x+30, y+20)   -- По неизвестной причине затрагивает и вкладку "Магазин", тем самым смещая описание "Сундуков" левее @Никита
		end]]
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


--Слетали шрифты у кнопок выбора в первом слоте
local function serversettingstabpost(self)
	for i,wgt in ipairs(self.privacy_type.buttons.buttonwidgets) do
		wgt.button:SetFont(NEWFONT)
	end
end
AddClassPostConstruct("widgets/serversettingstab", serversettingstabpost)

-- Не показываем настройки языка. Ультрамегахак
do
	local optionsscreen = require("screens/redux/optionsscreen")
	local __ctor = optionsscreen._ctor
	optionsscreen._ctor = function(self, prev_screen, ...) print("_ctor") return __ctor(self, nil, ...) end
	

	-- исправления интерфейса
	local TEMPLATES = require "widgets/redux/templates"
	local oldLabelSpinner = TEMPLATES.LabelSpinner	
	function TEMPLATES.LabelSpinner(labeltext, spinnerdata, width_label, width_spinner, height, spacing, font, font_size, horiz_offset, ...)
		local ActiveScreen = "none"
		if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name then ActiveScreen = TheFrontEnd:GetActiveScreen().name end
		if ActiveScreen == "MultiplayerMainScreen" then
			local width_label = width_label and width_label+14 or 220
			local font_size = font_size or 22
			local horiz_offset = horiz_offset and horiz_offset+10 or 0
			local width_spinner = width_spinner and width_spinner-10 or 150

			return oldLabelSpinner(labeltext, spinnerdata, width_label, width_spinner, height, spacing, font, font_size, horiz_offset, ...)
		else
			return oldLabelSpinner(labeltext, spinnerdata, width_label, width_spinner, height, spacing, font, font_size, horiz_offset, ...)
		end
	end

	local oldLabelNumericSpinner = TEMPLATES.LabelNumericSpinner	
	function TEMPLATES.LabelNumericSpinner(labeltext, min, max, width_label, width_spinner, height, spacing, font, font_size, horiz_offset, ...)
		local ActiveScreen = "none"
		if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name then ActiveScreen = TheFrontEnd:GetActiveScreen().name end
		if ActiveScreen == "MultiplayerMainScreen" then
			local width_label = width_label+14 or 220
			local font_size = font_size or 22
			local horiz_offset = horiz_offset and horiz_offset+10 or 0
			local width_spinner = width_spinner and width_spinner-10 or 150

			return oldLabelNumericSpinner(labeltext, min, max, width_label, width_spinner, height, spacing, font, font_size, horiz_offset, ...)
		else
			return oldLabelNumericSpinner(labeltext, min, max, width_label, width_spinner, height, spacing, font, font_size, horiz_offset, ...)
		end
	end

	local oldOptionsLabelCheckbox = TEMPLATES.OptionsLabelCheckbox	
	function TEMPLATES.OptionsLabelCheckbox(onclick, labeltext, checked, width_label, width_button, height, checkbox_size, spacing, font, font_size, horiz_offset, ...)
		local ActiveScreen = "none"
		if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name then ActiveScreen = TheFrontEnd:GetActiveScreen().name end
		if ActiveScreen == "MultiplayerMainScreen" then
			local font_size = font_size or 22
			local horiz_offset = horiz_offset and horiz_offset+10 or 0

			return oldOptionsLabelCheckbox(onclick, labeltext, checked, width_label, width_button, height, checkbox_size, spacing, font, font_size, horiz_offset, ...)
		else
			return oldOptionsLabelCheckbox(onclick, labeltext, checked, width_label, width_button, height, checkbox_size, spacing, font, font_size, horiz_offset, ...)
		end
	end


	local oldCurlyWindow = TEMPLATES.CurlyWindow	
	function TEMPLATES.CurlyWindow(sizeX, sizeY, title_text, bottom_buttons, button_spacing, body_text)
		local w = oldCurlyWindow(sizeX, sizeY, title_text, bottom_buttons, button_spacing, body_text)

		if title_text then
			w.title:SetRegionSize(680, 50)
            w.title:SetSize(35)
        end  

	    if body_text then
	    	w.body:SetSize(24)
	    end

		return w
	end
end

AddClassPostConstruct("screens/redux/optionsscreen", function(self)
	local function UpdateSpinners(items)
		self.screenFlashSpinner.options = { { text = STRINGS.UI.OPTIONS.DEFAULT, data = 1 }, { text = STRINGS.UI.OPTIONS.DIM, data = 2 } , { text = STRINGS.UI.OPTIONS.DIMMEST, data = 3 } }
		self.screenFlashSpinner:SetSelectedIndex(self.screenFlashSpinner.selectedIndex)
		for _, item in pairs(items) do
			if item.options then -- Проверяем чайлда спинер он или нет
				local opts = item.options
				if #opts == 2 and opts[1].data == false then
					--Настройки рюкзака тоже булеан. Проверяем
					local txt = item ~= self.integratedbackpackSpinner and
					{
						STRINGS.UI.OPTIONS.DISABLED,
						STRINGS.UI.OPTIONS.ENABLED,
					}
					or
					{
						STRINGS.UI.OPTIONS.INTEGRATEDBACKPACK_DISABLED,
						STRINGS.UI.OPTIONS.INTEGRATEDBACKPACK_ENABLED,
					}

					opts[1].text = txt[1]
					opts[2].text = txt[2]

					--Обновляем и текст
					item:SetSelectedIndex(item.selectedIndex)
				end
			end
		end
	end

	if self.right_spinners then
		UpdateSpinners(self.right_spinners)
	end
	if self.left_spinners then
		UpdateSpinners(self.left_spinners)
	end

	if self.title then
		self.title.big:SetString("Настройки игры")
	end
end) 

AddClassPostConstruct("screens/redux/scrapbookscreen", function(self)
	local Text = require "widgets/text"
	function Text:SetString(str)
		if str ~= nil then
			if t.PO["STRINGS.SCRAPBOOK.DATA_USES"] and string.match(str,"^(%d*)"..t.PO["STRINGS.SCRAPBOOK.DATA_USES"].."$") then 
				local splitstr = split(str, " ")
				str = splitstr[1] .. StringTime(splitstr[1],{" ПРИМЕНЕНИЕ"," ПРИМЕНЕНИЯ"," ПРИМЕНЕНИЙ"}) or str
			elseif t.PO["STRINGS.SCRAPBOOK.DATA_DAYS"] and string.match(str,"^(%d*)%s"..t.PO["STRINGS.SCRAPBOOK.DATA_DAYS"].."$") then
				local splitstr = split(str, " ")
				str = splitstr[1] .. StringTime(splitstr[1],{" ДЕНЬ"," ДНЯ"," ДНЕЙ"}) or str
			elseif t.PO["STRINGS.SCRAPBOOK.DATA_STACK"] and string.match(str,"^(%d*)%s"..t.PO["STRINGS.SCRAPBOOK.DATA_STACK"].."$") then
				local splitstr = split(str, " ")
				str = splitstr[1] .. StringTime(splitstr[1],{" ШТУКА"," ШТУКИ"," ШТУК"}) or str
			end

		    self.string = str
		    self.inst.TextWidget:SetString(str or "")
		end
	end
end)

AddClassPostConstruct("screens/redux/caveselectscreen", function(self)
	if self.headertext then
		self.headertext:SetString("С пещерами или без пещер?")
	end

	local srv_desc = {
		["Play with Caves, requires more PC Power as it runs multiple servers"] = {"С пещерами", "Игра с пещерами требует больше мощности ПК, так как работает на нескольких серверах"}, 
		["Play with no Caves, sad, but not as demanding on a computer"] = {"Без пещер", "Играть без пещер, грустно, но не так требовательно к компьютеру"}
	}

	local oldUpdateStyleInfo = self.UpdateStyleInfo
	function self:UpdateStyleInfo(w)
		self.description:SetMultilineTruncatedString(srv_desc[w.settings_desc][2], 3, 700, nil, true, true)

		if w.button and w.button.text then
			w.button.text:SetString(srv_desc[w.settings_desc][1])
		end
	end
	
end)

--Не переводится т.к. таблица создаётся до загрузки модов.
AddClassPostConstruct("screens/redux/hostcloudserverpopup", function(self)
	local phases =
	{
		t.PO["STRINGS.UI.FESTIVALEVENTSCREEN.HOST_GETTINGREGIONS"],         -- eRequestingPingServers,
		t.PO["STRINGS.UI.FESTIVALEVENTSCREEN.HOST_DETERMININGREGION"],      -- eWaitingForPingEndpoints,
		t.PO["STRINGS.UI.FESTIVALEVENTSCREEN.HOST_DETERMININGREGION"],      -- eReadyToPing,
		t.PO["STRINGS.UI.FESTIVALEVENTSCREEN.HOST_REQUESTINGSERVER"],       -- eWaitingForPingResults,
		t.PO["STRINGS.UI.FESTIVALEVENTSCREEN.HOST_REQUESTINGSERVER"],       -- eReadyToRequestServer,
		t.PO["STRINGS.UI.FESTIVALEVENTSCREEN.HOST_WAITINGFORWORLD"],        -- eWaitingForServer,
		t.PO["STRINGS.UI.FESTIVALEVENTSCREEN.HOST_CONNECTINGTOSERVER"],     -- eServerReady,
	}

	local _OnUpdate = self.OnUpdate or function(...) end
	function self:OnUpdate(dt)
		_OnUpdate(self, dt)

		local cloudServerRequestState = TheNet:GetCloudServerRequestState() or 0

		if cloudServerRequestState >= 8 then return end

		self.status_msg:SetString(phases[cloudServerRequestState] or "")
	end
end)

if TheNet:GetServerGameMode() == "lavaarena" then
	local pugna_sayings = require("rlp_pugna_speech")

	AddPrefabPostInit("lavaarena_boarlord", function(inst)
		local _ontalkfn = inst.components.talker.ontalkfn
		local function OnTalk(inst, data, ...)
			_ontalkfn(inst, data, ...)
			if data ~= nil and data.message ~= nil and inst.speechroot then
				if pugna_sayings[data.message] then
					inst.speechroot.SetBoarloadSpeechString(pugna_sayings[data.message])
				end
			end
		end

		inst.components.talker.ontalkfn = OnTalk
		inst.components.talker.donetalkingfn = OnTalk
	end)
end

env.AddClassPostConstruct("screens/redux/mainscreen", function(self)
	self.presents_image:SetTexture("images/frontscreen_ru.xml", "kleipresents.tex")
	self.legalese_image:SetTexture("images/frontscreen_ru.xml", "legalese.tex")
end)

-- В картинке более красиво
env.AddClassPostConstruct("widgets/itemselector", function(self)
	self.banner:SetTexture("images/tradescreen_ru.xml", "banner0_small.tex")
	self.title:Hide()
end)

do
	local function PatchTradeOverflowImg(file, override)
		env.AddClassPostConstruct(file, function(self)
			local name = override or "title"
			self[name]:SetTexture("images/tradescreen_overflow_ru.xml", "TradeInnSign.tex")
		end)
	end

	PatchTradeOverflowImg("screens/tradescreen")
	PatchTradeOverflowImg("screens/crowgamescreen")
	PatchTradeOverflowImg("screens/snowbirdgamescreen")
	PatchTradeOverflowImg("screens/redbirdgamescreen")
end

-- env.modimport("scripts/mod_translator.lua")

--Подменяем имена персонажей, создаваемых с консоли в игре.
local OldSetPrefabName = EntityScript.SetPrefabName
function EntityScript:SetPrefabName(name, ...)
	OldSetPrefabName(self,name, ...)
	if not self.entity:HasTag("player") then return end
	self.name=t.SpeechHashTbl.NAMES.Rus2Eng[self.name] or self.name
end

--Новая версия функции, выдающей качество предмета
local _GetAdjective = EntityScript.GetAdjective
function EntityScript:GetAdjective()
	local str = _GetAdjective(self)
	if str and self.prefab and ThePlayer then
		local player = ThePlayer
		local act = player.components.playercontroller:GetLeftMouseAction() --Получаем текущее действие
		if act then act = act.action.id or "NOACTION" else act = "NOACTION" end
		str = FixPrefix(str,act,self.prefab) --склоняем окончание префикса
		if act ~= "NOACTION" then --если есть действие, то нужно сделать с маленькой буквы
			str = firsttolower(str)
		end
	end
	return str
end

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

local _GetDisplayName = EntityScript.GetDisplayName --сохраняем старую функцию, выводящую название предмета
function EntityScript:GetDisplayName(act, ...) --Подмена функции, выводящей название предмета. В ней реализовано склонение в зависимости от действия (переменная аct)
	-- Fox: В старой верссии act не передавался. Баг?
	local name = _GetDisplayName(self, act, ...)
	local player = ThePlayer

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
		--Солим блюда правильно
		local puresalt = STRINGS.NAMES.QUAGMIRE_SALTED_FOOD_FMT:utf8sub(1,7)
		if string.sub(name,1,#puresalt)==puresalt then Prefix=puresalt end

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
	-- перевод растений на грядке
	local isSeed = false 
	if self:HasTag("farm_plant") and self.components and self.components.growable then
		-- определяем степень роста
		local stage_data = self.components.growable:GetCurrentStageData()

		if stage_data.inspect_str and stage_data.inspect_str then
			local seed_name = ""
			local farm_plant_seed_ru = ""
			local knowsseed = false
			local knowsplantname = false
			local knowsweedname = false
			local player_is_farmplantidentifier = (ThePlayer ~= nil and ThePlayer:HasTag("farmplantidentifier"))
			local plant_stage = stage_data.inspect_str -- узнаём состояние роста

			-- проверяем иследованность сорняка
			if self.weed_def and self.weed_def.plantregistryinfo then
					local plantregistryinfo = self.weed_def.plantregistryinfo
					local registry_key = self:GetPlantRegistryKey()	
					
					knowsweedname = ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo)
					--print("knowsweedname="..tostring(knowsweedname))			
			end
			
			if self.plant_def then
				-- проверяем иследованность растения
				if self.plant_def.plantregistryinfo then						
					local plantregistryinfo = self.plant_def.plantregistryinfo
					local registry_key = self:GetPlantRegistryKey()
					
					knowsseed = ThePlantRegistry:KnowsSeed(registry_key, plantregistryinfo)
					knowsplantname = ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo)

					--print("knowsseed="..tostring(knowsseed).." knowsplantname="..tostring(knowsplantname).." player_is_farmplantidentifier="..tostring(player_is_farmplantidentifier))					
				end

				-- формируем имя семени
				if plant_stage == "SEED" and self.plant_def.seed then
					isSeed = true

					seed_name = string.upper(self.plant_def.seed) -- определяем семя
					
					if (player_is_farmplantidentifier or (knowsseed and knowsplantname)) and not self.plant_def.is_randomseed then  -- если исследовано
						seed_name = "KNOWN_"..seed_name
					end

					if STRINGS.NAMES[seed_name] ~= nil then 
						seed_name=STRINGS.NAMES[seed_name] -- определяем название на русском
					end	

					if act then --если есть действие
						-- выбираем вариант склонения по действию для имени семени 
						if t.RussianNames[seed_name] ~= nil and (t.RussianNames[seed_name][act.action and act.action.id] or t.RussianNames[seed_name]["DEFAULTACTION"]) ~= nil then
							seed_name = t.RussianNames[seed_name][act.action and act.action.id] or t.RussianNames[seed_name]["DEFAULTACTION"]
							seed_name = firsttolower(seed_name)
						end
						-- выбираем вариант склонения по действию для farm_plant_seed (слово "посаженные")
						if t.RussianNames["Посаженные {seed}"] ~= nil and (t.RussianNames["Посаженные {seed}"][act.action and act.action.id] or t.RussianNames["Посаженные {seed}"]["DEFAULTACTION"]) ~= nil  then
							farm_plant_seed_ru = t.RussianNames["Посаженные {seed}"][act.action and act.action.id] or t.RussianNames["Посаженные {seed}"]["DEFAULTACTION"]
						end					
					end
					name = (farm_plant_seed_ru or "Посаженные").." "..seed_name
				end					
			end
			-- склоняем префикс при намокании
			if Prefix and act then
				Prefix = "влажный" -- сбрасываем префикс и склоняем заново с учетом полученных данных	
				-- ещё растущие сорняки и растения
				if (self.prefab:utf8sub(1,4) == "weed" and plant_stage ~= "FULL_WEED" and not (player_is_farmplantidentifier or knowsweedname)) or (self.prefab:utf8sub(1,4) == "farm" and plant_stage == "GROWING" and not (player_is_farmplantidentifier or knowsplantname)) then
					Prefix = FixPrefix(Prefix,act.action and act.action.id or "NOACTION","farm_plant_unknown")
				-- только посаженные семена
				elseif (self.prefab:utf8sub(1,4) == "farm" and plant_stage == "SEED") then
					Prefix = FixPrefix(Prefix,act.action and act.action.id or "NOACTION","farm_plant_seed")
				-- гниль
				elseif (self.prefab:utf8sub(1,4) == "farm" and plant_stage == "ROTTEN") then
					Prefix = FixPrefix(Prefix,act.action and act.action.id or "NOACTION","spoiled_food")
				else
					Prefix = FixPrefix(Prefix,act.action and act.action.id or "NOACTION",self.prefab)
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
				if not isSeed then 
					name=rebuildname(name,act,self.prefab)
				end
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

	if act and name then
		if act=="SLEEPIN" or act=="JUMPIN" then		
			name=Prefix and "во "..name or "в "..name
		end 
		if act=="OPEN_CRAFTING" and self.prefab and (self.prefab == "madscience_lab" or self.prefab == "wintersfeastoven") then		
			name=Prefix and "во "..name or "в "..name
		end
	end 
	if act and act=="INTERACT_WITH" and name then name="с "..name end --Чтобы не было фразы "Поговорить с" с надетой шляпой садовника 
	return name
end

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

if DEBUG_ENABLED then
	t.ModLoaded()
end
