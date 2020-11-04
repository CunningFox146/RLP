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

POUpdater = require "po_updater"

local DEBUG_ENABLED = false
local DEBUG_ENABLE_ID = {
	["KU_YhiKhjfu"] = true,
	["OU_76561198137380697"] = true,
	["KU_gwxUn9lD"] = true,
	["OU_76561198089171367"] = true,
}

if DEBUG_ENABLE_ID[TheNet:GetUserID()] then
	CHEATS_ENABLED = true
	DEBUG_ENABLED = true
	t.debug = true
end

-- Удаляем уведомление о модах
Sim.ShouldWarnModsLoaded = function() return false end

modimport("scripts/rlp_fonts.lua")
modimport("scripts/rlp_settings.lua")

--Исправление бага с шрифтом в спиннерах
--Выполняем подмену шрифта в спиннере из-за глупой ошибки разрабов в этом виджете
AddClassPostConstruct("widgets/spinner", function(self, options, width, height, textinfo, ...)
	if textinfo then return end
	self.text:SetFont(BUTTONFONT)
end)

env.AddGamePostInit(function()
	if InGamePlay() or IsMigrating() or not TheFrontEnd then
		return
	end
	
	local PopupDialogScreen = require "screens/redux/popupdialog"
	
	if KnownModIndex:IsModEnabled("workshop-55043536") then
		TheFrontEnd:PushScreen(PopupDialogScreen(
		"Обнаружен устаревший\nмод!",
		"Внимание! В игре обнаружен переводчик модов (Russian For Mods). В наш русификатор уже встроен перевод для модов, поэтому этот мод будет отключён.",
		{
			{
				text="Хорошо",
				cb = function() 
					TheFrontEnd:PopScreen()
					KnownModIndex:DisableBecauseIncompatibleWithMode("workshop-55043536")
					
					ForceAssetReset()
					KnownModIndex:Save(function()
						SimReset()
					end)
				end
			}
		}))
	elseif KnownModIndex:IsModEnabled("workshop-354836336") then
		TheFrontEnd:PushScreen(PopupDialogScreen(
		"Обнаружен устаревший\nмод!",
		"Внимание! В игре обнаружен устаревший перевод (Russian Language Pack). Он будет отключен для корректной работы перевода.",
		{
			{
				text="Хорошо",
				cb = function() 
					TheFrontEnd:PopScreen()
					KnownModIndex:DisableBecauseIncompatibleWithMode("workshop-354836336")
					
					ForceAssetReset()
					KnownModIndex:Save(function()
						SimReset()
					end)
				end
			}
		}))
	end
end)

if t.CurrentTranslationType == t.TranslationTypes.FontsOnly then
	t.print("[RLP] Загрузка FontsOnly версии завершена.")
	return
end

--Загружаем русификацию
print("Загрузка PO файла")
env.LoadPOFile(t.StorePath..t.MainPOfilename, t.SelectedLanguage)
t.PO = LanguageTranslator.languages[t.SelectedLanguage]
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
						if SubSize(str, size -3)=="шина" then
							str=repsubstr(str,size -3,"шины")							
						elseif SubSize(str, size -3)=="Стол" then
							str=repsubstr(str,size -3,"Стол")							
						elseif SubSize(str, size -2)=="зой" then
							str=repsubstr(str,size -2,"зой")							
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
						elseif SubSize(str, size -2)=="ода" then
							str=repsubstr(str,size -2,"ода")							
						elseif SubSize(str, size -2)=="шок" then
							str=repsubstr(str,size -2,"шка")							
						elseif SubSize(str, size -2)=="ики" then
							str=repsubstr(str,size ,"ов")							
						elseif SubSize(str, size -2)=="уса" then
							str=str:utf8sub(1, -2)							
						elseif SubSize(str, size -2)=="нец" then
							str=repsubstr(str,size -2,"нец")							
						elseif SubSize(str, size -2)=="ало" then
							str=str:utf8sub(1, -2)							
						elseif SubSize(str, size -2)=="ота" then
							str=str:utf8sub(1, -2)							
						elseif SubSize(str, size -2)=="ий" then
							str=repsubstr(str,size -2,"ого")							
						elseif SubSize(str, size -1)=="зд" then
							str=str:utf8sub(1, -2)							
						elseif SubSize(str, size -1)=="ьё" then
							str=repsubstr(str,size -1,"ья")							
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
						elseif SubSize(str, size -1)=="па" then
							str=repsubstr(str,size -1,"пы")							
						elseif SubSize(str, size -1)=="ще" then
							str=repsubstr(str,size -1,"ща")							
						elseif SubSize(str, size -1)=="нь" then
							str=repsubstr(str,size -2,"ня")							
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
	return resstr
end
t.rebuildname = rebuildname

if DEBUG_ENABLED then
	rawset(_G, "testname" ,function(name,key)
		if name and (not key) and type(name)=="string" and rawget(STRINGS.NAMES,name:upper()) then key=name:upper() name=STRINGS.NAMES[key] end
		t.print("Идти к "..rebuildname(name,"WALKTO", key))
		t.print("Осмотреть "..rebuildname(name,"DEFAULTACTION", key))
		if key then
			t.print("Был убит "..rebuildname(name,"KILL",key))
		end
		t.print("Сменить скин у "..rebuildname(name,"reskin", key))
	end)
	
	
	--Сохраняет в файле fn все имена с действием, указанным в параметре action)
	rawset(_G, "printnames", function(fn, action, openfn)
		local filename = env.MODROOT..fn..".txt"
		local str1,str2
		local names={}
		local f=assert(io.open(env.MODROOT..(openfn or "names_new.txt"),"r"))
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
	end)
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
	return firstletter:lower()..tmp:utf8sub(2)
end

--первый символ в верхний регистр
local function firsttoupper(tmp)
	if not tmp then return end
	local firstletter=tmp:utf8sub(1,1)
	firstletter = LetterCasesHash.l2u[firstletter] or firstletter
	return firstletter:upper()..tmp:utf8sub(2)
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

--Склоняем названия вещей в пожитках
function GetSkinUsableOnString(item_type, popup_txt)
	local skin_data = GetSkinData(item_type)
	local skin_str = GetSkinName(item_type)
	
	local usable_on_str = ""
	if skin_data ~= nil and skin_data.base_prefab ~= nil then
		if skin_data.granted_items == nil then
			local item_str = rebuildname(STRINGS.NAMES[string.upper(skin_data.base_prefab)],"reskin",string.upper(skin_data.base_prefab))
			usable_on_str = subfmt(popup_txt and STRINGS.UI.SKINSSCREEN.USABLE_ON_POPUP or STRINGS.UI.SKINSSCREEN.USABLE_ON, { skin = skin_str, item = item_str })
		else
			local item1_str = rebuildname(STRINGS.NAMES[string.upper(skin_data.base_prefab)],"reskin",string.upper(skin_data.base_prefab))
			local item2_str = nil
			local item3_str = nil
			
			local granted_skin_data = GetSkinData(skin_data.granted_items[1])
			if granted_skin_data ~= nil and granted_skin_data.base_prefab ~= nil then
				item2_str = rebuildname(STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)],"reskin",string.upper(granted_skin_data.base_prefab))	
			end
			local granted_skin_data = GetSkinData(skin_data.granted_items[2])
			if granted_skin_data ~= nil and granted_skin_data.base_prefab ~= nil then
				item3_str = rebuildname(STRINGS.NAMES[string.upper(granted_skin_data.base_prefab)],"reskin",string.upper(granted_skin_data.base_prefab))
			end
			
			if item3_str == nil then
				usable_on_str = subfmt(popup_txt and STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE_POPUP or STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE, { skin = skin_str, item1 = item1_str, item2 = item2_str })
			else
				usable_on_str = subfmt(popup_txt and STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE_3_POPUP or STRINGS.UI.SKINSSCREEN.USABLE_ON_MULTIPLE_3, { skin = skin_str, item1 = item1_str, item2 = item2_str, item3 = item3_str })
			end
		end
	end
	
	return usable_on_str
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

if DEBUG_ENABLED then
	DumpModPhrases = function() printwrap("t.mod_phrases", t.mod_phrases) end
end

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
	message = t.TranslateToRussian(message, entity) or message --Переводим на русский
	return _Networking_Talk(guid, message, ...)
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
				killerkey=t.SpeechHashTbl.NAMES.Eng2Key[mentions] --Получаем ключ имени убийцы
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
					if table.contains(GetActiveCharacterList(), killerkey) then killerkey=nil end
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
	AddClassPostConstruct("widgets/text", function(self)
		local function IsWhiteSpace(charcode)
		    -- 32: space
		    --  9: \t
		    return charcode == 32 or charcode == 9
		end

		local function IsNewLine(charcode)
		    -- 10: \n
		    -- 11: \v
		    -- 12: \f
		    -- 13: \r
		    return charcode >= 10 and charcode <= 13
		end
		function self:SetMultilineTruncatedString(str, maxlines, maxwidth, maxcharsperline, ellipses)
		    if str == nil or #str <= 0 then
		        self.inst.TextWidget:SetString("")
		        return
		    end
		    local tempmaxwidth = type(maxwidth) == "table" and maxwidth[1] or maxwidth
		    if maxlines <= 1 then
		        self:SetTruncatedString(str, tempmaxwidth, maxcharsperline, ellipses)
		    else
		        self:SetTruncatedString(str, tempmaxwidth, maxcharsperline, false)
		        local line = self:GetString()
		        if #line < #str then
		            if IsNewLine(str:byte(#line + 1)) then
		                str = str:sub(#line + 2)
		            elseif not IsWhiteSpace(str:byte(#line + 1)) then
		                for i = #line, 1, -1 do
		                    if IsWhiteSpace(line:byte(i)) then
		                        line = line:sub(1, i)
		                        break
		                    end
		                end
		                str = str:sub(#line + 1)
		            else
		                str = str:sub(#line + 2)
		                while #str > 0 and IsWhiteSpace(str:byte(1)) do
		                    str = str:sub(2)
		                end
		            end
		            if #str > 0 then
		                if type(maxwidth) == "table" then
		                    if #maxwidth > 2 then
		                        tempmaxwidth = {}
		                        for i = 2, #maxwidth do
		                            table.insert(tempmaxwidth, maxwidth[i])
		                        end
		                    elseif #maxwidth == 2 then
		                        tempmaxwidth = maxwidth[2]
		                    end
		                end
		                self:SetMultilineTruncatedString(str, maxlines - 1, tempmaxwidth, maxcharsperline, ellipses)
		                self.inst.TextWidget:SetString(line.."\n"..(self.inst.TextWidget:GetString() or ""))
		            end
		        end
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
	local _ListSnapshots = NetworkProxy.ListSnapshots
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
	end

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

	AddClassPostConstruct("components/named_replica", function(self)
		local function OnNameDirtyMoose(inst)
			inst.name = inst.possiblenames[math.random(#inst.possiblenames)]
		end
		if self.inst.prefab == "moose" then
			self.inst.possiblenames = {STRINGS.NAMES.MOOSE1, STRINGS.NAMES.MOOSE2}
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
			for i,v in ipairs(self.privacy_type.buttons.buttonwidgets) do
				v.button.text:SetFont(NEWFONT)
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
												["starting_variety.tex"]=1,
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

end

--Перегоняем перевод в STRINGS
TranslateStringTable(STRINGS)

--Функция меняет окончания прилагательного prefix в зависимости от падежа, пола и числа предмета
local function FixPrefix(prefix, act, item)
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

--Перевод настроек приватности при создании сервера
AddClassPostConstruct("screens/redux/cloudserversettingspopup", function(self)
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
					["starting_variety.tex"]=1,
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

--Комплекс из двух подмен для того, чобы названия серверов слева в окне создания сервера были поменьше
--Грязный хак, подменяем то, что, как нам кажется, будет только в ServerCreationScreen:MakeSaveSlotButton
--Это нужно, чтобы строка оканчивалась тремя точками попозже, ведь шрифт будет поменьше
if FrontEnd and FrontEnd.GetTruncatedString then
	local OldGetTruncatedString = FrontEnd.GetTruncatedString
	function FrontEnd:GetTruncatedString(str, font, size, maxwidth, maxchars, suffix, ...)
		if font==NEWFONT and size==35 and maxwidth==140 and not maxchars and suffix then
			size = 28 --Надеюсь, это произойдёт только в ServerCreationScreen:MakeSaveSlotButton
		end
		local res = OldGetTruncatedString(self, str, font, size, maxwidth, maxchars, suffix, ...)
		return res
	end
end

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
		wgt.button:SetFont(NEWFONT)
	end
end
AddClassPostConstruct("widgets/serversettingstab", serversettingstabpost)
--Клей отрубили подгрузку шрифтов, поэтому подменяем шрифты в попапах
local function PopUpdialogPost(self)
	if self.title then
		self.title:SetFont(HEADERFONT)
	end
	
	if self.text then
		self.text:SetFont(CHATFONT)
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
			t.print("ERROR! text == nil or type(text) ~= \"string\"")
			return
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
		
		self.status_msg:SetString("")
		self.status_msg:SetString(phases[cloudServerRequestState] or "")
	end
end)

--"Достать печь"
--ACTIONS

--No warning about mods in events
AddClassPostConstruct("screens/redux/multiplayermainscreen", function(self)
	if mods.disabled_event_warning then
		return
	end
	
	local TheFrontEnd = TheFrontEnd
	local PopupDialogScreen = require "screens/redux/popupdialog"
	
	--I don't know how to get it from here, so just replacing it
	function self:OnFestivalEventButton()
		if TheFrontEnd:GetIsOfflineMode() or not TheNet:IsOnlineMode() then
			TheFrontEnd:PushScreen(PopupDialogScreen(STRINGS.UI.FESTIVALEVENTSCREEN.OFFLINE_POPUP_TITLE, STRINGS.UI.FESTIVALEVENTSCREEN.OFFLINE_POPUP_BODY[WORLD_FESTIVAL_EVENT], 
				{
					{text=STRINGS.UI.FESTIVALEVENTSCREEN.OFFLINE_POPUP_LOGIN, cb = function()
							SimReset()
						end},
					{text=STRINGS.UI.FESTIVALEVENTSCREEN.OFFLINE_POPUP_BACK, cb=function() TheFrontEnd:PopScreen() end },
				}))
		else
			self:_GoToFestfivalEventScreen()
		end
	end
	
	mods.disabled_event_warning = true
end)

local pugna_sayings = {
	["Ha!"] = "Ха!",
	["You are unworthy."] = "Вы недостойны.",
	["You never stood a chance."] = "У вас не было и шанса.",
	["Ha ha!"] = "Ха ха!",
	["Weak."] = "Слабаки.",
	["We are stronger."] = "Мы сильнее.",
	["Well struck!"] = "Хороший удар!",
	["At last, our realm returns to glory!"] = "Наконец, наше царство обретёт славу!",
	["Warriors, rekindle the Gateway..."] = "Воины, пробудите Врата...",
	["Today we take the Throne!"] = "Сегодня мы захватим Трон!",
	["It's good to have a challenge once again!"] = "Хорошо принять вызов снова!",
	["This should be fun."] = "Это должно быть весело.",
	["More pigs! Overwhelm them!"] = "Больше! Сокрушите их!",
	["More pigs!"] = "Больше свиней!",
	["What have we here?"] = "Что у нас здесь?",
	["Gatekeepers? Ha! Have you come to return us to the Throne?"] = "Хранители Врат? Ха! Вы пришли, чтобы вернуть нас к Трону?",
	["I am Battlemaster Pugna, and I protect what is mine."] = "Я - Военачальник Пугна, и я защищаю то, что принадлежит мне.",
	["Warriors. Release the pigs!"] = "Воины. Выпускайте свиней!",
	["For the Forge!"] = "За Кузню!",
	["Give the Gatekeepers no quarter!"] = "Не дайте Хранителям Врат и четвертака!",
	["Fly your banners proudly, warriors!"] = "Пусть ваши знамёна реют гордо, воины!",
	["Impressive. You handled our foot soldiers with ease."] = "Впечатляет. Вы легко справились с нашими пехотинцами.",
	["But our battalions are trained to work together."] = "Но наши батальоны натренированы работать вместе.",
	["Can you do the same? Crocommanders, to the ring!"] = "Сможете ли вы сделать то же самое? Крокомандиры, на ринг!",
	["We've endured more here than you know."] = "Мы вынесли здесь больше, чем вы можете представить.",
	["And as forging fires temper steel,"] = "И как огонь горна закаляет сталь,",
	["Hardship has only made us stronger."] = "Так и трудности только сделали нас сильнее.",
	["Now, Snortoises. Attack!"] = "А теперь, Бронепахи. Атакуйте!",
	["End this now my warriors!"] = "Покончите с этим сейчас же, мои воины!",
	["We... cannot lose the Forge..."] = "Мы... не можем потерять Кузню...",
	["No! How can this be?!"] = "Нет! Как такое может быть?!",
	["You have defeated the mighty Boarilla!"] = "Вы победили могучую Бориллу!",
	["You may have won the battle, Gatekeepers... but not the war!"] = "Возможно вы выиграли битву, Хранители Врат... но не войну!",
	["...Do you understand the forces you serve?"] = "...Вы понимаете силы, которым вы служите?",
	["They destroy all They touch..."] = "Они уничтожают всё, к чему прикасаются...",
	["We were severed from the Throne, trapped in a realm of stone and fire!"] = "Мы были отделены от Трона, захваченного царством камня и огня!",
	["That is why we cannot let you win."] = "Поэтому мы не можем позволить вам победить.",
	["Send in the Boarilla."] = "Послать Бориллу.",
	["Grand Forge Boarrior!"] = "Великий Боров-воин Кузни!",
	["The ring is yours! Destroy them, my champion!"] = "Ринг твой! Уничтожь их, мой чемпион!",
	["The Gatekeepers must not take the Forge!"] = "Хранители Врат не должны захватить Кузню!",
	["Drive the interlopers back!"] = "Верните нарушителей обратно!",
	["Do not hold back! Kill them!"] = "Не отступать! Убейте их!",
	["Why are the Gatekeepers still not dead?!"] = "Почему Хранители Врат все ещё живы?!",
	["Destroy them!!"] = "Уничтожьте их!!",
	["We will not live in the Throne's shadow!"] = "Мы не будем жить в тени Трона!",
	["What?! My champion!?!"] = "Что?! Мой чемпион!?!",
	["I see. You've demonstrated your might."] = "Я вижу. Вы показали своё могущество.",
	["...But we will live to fight again!!"] = "...Но мы будем жить, чтобы снова сражаться!!",
	["Know this, Gatekeepers:"] = "Запомните вот что, Хранители Врат:",
	["Once you are dead, we will activate the Gateway."] = "Как только вы умрёте, мы активируем Врата.",
	["We'll return to the hub and destroy the Throne."] = "Мы вернёмся и уничтожим Трон.",
	["We will end this, once and for all."] = "Мы покончим с этим раз и навсегда.",
	["You have won the battle,"] = "Вы выиграли битву,",
	["But the war rages on eternally."] = "Но война продолжается вечно.",
	["We are not ready to give up yet."] = "Мы ещё не готовы сдаться.",
	["We do not fear you."] = "Мы не боимся вас.",
	["But you will fear us!"] = "Но вы будете бояться нас!",
	["Fear my new champions! Fear the Rhinocebros!"] = "На колени перед моими новыми чемпионами! Бойтесь Нособуров!",
	["No! My Forge, felled by the Throne's lapdogs!"] = "Нет! Моя кузня пала от лап шавок Трона!",
	["Please. No more, Gatekeepers. We surrender."] = "Прошу. Довольно, Хранители Врат. Мы сдаёмся.",
	["The day is yours, as is the Gateway."] = "День ваш, как и Врата.",
	["You have had many victories, Gatekeepers..."] = "У вас было много побед, Хранители Врат...",
	["...but from our dungeons comes our most brutal warrior."] = "...но из подземелий выходит наш самый жестокий воин.",
	["Behold: The Infernal Swineclops!"] = "Бойтесь! Инфернальный Свиноклоп!",
}

AddPrefabPostInit("lavaarena_boarlord", function(inst)
	local _ontalkfn = inst.components.talker.ontalkfn
	local function OnTalk(inst, data)
		_ontalkfn(inst, data)
		if data ~= nil and data.message ~= nil and inst.speechroot then
			if pugna_sayings[data.message] then
				inst.speechroot.SetBoarloadSpeechString(pugna_sayings[data.message])
			end
		end
	end
	
	inst.components.talker.ontalkfn = OnTalk
	inst.components.talker.donetalkingfn = OnTalk
end)

env.AddClassPostConstruct("screens/redux/mainscreen", function(self)
	self.presents_image:SetTexture("images/frontscreen_ru.xml", "kleipresents.tex")
	self.legalese_image:SetTexture("images/frontscreen_ru.xml", "legalese.tex")
end)

-- В картинке более красиво
env.AddClassPostConstruct("widgets/itemselector", function(self)
	self.banner:SetTexture("images/tradescreen_ru.xml", "banner0_small.tex")
	self.title:Hide()
end)

local function PatchTradeOverflowImg(file, override)
	env.AddClassPostConstruct(file, function(self)
		local name = override or "title"
		self[name]:SetTexture("images/tradescreen_overflow_ru.xml", "TradeInnSign.tex")
	end)
end

PatchTradeOverflowImg("screens/tradescreen")
PatchTradeOverflowImg("screens/crowgamescreen")
PatchTradeOverflowImg("screens/snowbirdgamescreen")

local Text = require "widgets/text"
local function AddUpdtStr(parent)
	local self = parent:AddChild(Text(NEWFONT_OUTLINE, 25, nil, UICOLOURS.WHITE))
	self:SetClickable(false)
	self:MoveToFront()
	self:SetClickable(false)

	self:SetVAnchor(ANCHOR_TOP)
	self:SetHAnchor(ANCHOR_LEFT)

	local _SetString = self.SetString or (function() end)
	self.SetString = function (self, ...)
		_SetString(self, ...)
		local w, h = self:GetRegionSize()
		w, h = w * 0.5, h * 0.5
		self:SetPosition(w + 5, -h - 5)
	end

	return self
end

env.AddGamePostInit(function(test)		
	TheFrontEnd.consoletext:SetFont(BODYTEXTFONT) --Нужно, чтобы шрифт в консоли не слетал
	TheFrontEnd.consoletext:SetRegionSize(900, 404) --Чуть-чуть увеличил по вертикали, чтобы не обрезало буквы в нижней строке
	
	if not POUpdater:IsDisabled() and not InGamePlay() then
		if not TheFrontEnd.updt_str then
			TheFrontEnd.updt_str = AddUpdtStr(TheFrontEnd.overlayroot)
		end
		TheFrontEnd.updt_str:SetString("Проверка версии перевода...")
		POUpdater:ShouldUpdate(function(val)
			if val then
				TheFrontEnd.updt_str:SetString("Обновление перевода...")
				
				local function OnUpdateDone(_, data)
					TheFrontEnd.updt_str.inst:RemoveEventCallback("rlp_updated", OnUpdateDone, TheGlobalInstance)
					
					TheFrontEnd.updt_str:SetString(data and "Перевод обновлен успешно." or "Произошла ошибка при обновлении.")
					TheFrontEnd.updt_str.inst:DoTaskInTime(1, function()
						TheFrontEnd.updt_str:Kill()
					end)
				end
				
				TheFrontEnd.updt_str.inst:ListenForEvent("rlp_updated", OnUpdateDone, TheGlobalInstance)
				POUpdater:StartUpdating(true)
			else
				TheFrontEnd.updt_str:SetString("Перевод последней версии.")
				TheFrontEnd.updt_str.inst:DoTaskInTime(1, function()
					TheFrontEnd.updt_str:Kill()
					TheFrontEnd.updt_str = nil
				end)
			end
		end)
	end
end)

-- env.modimport("scripts/mod_translator.lua")

--Подменяем имена персонажей, создаваемых с консоли в игре.
local OldSetPrefabName = EntityScript.SetPrefabName
function EntityScript:SetPrefabName(name,...)
	OldSetPrefabName(self,name,...)
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
