local t = mods.RussianLanguagePack
local mk = t.RegisterRussianName
s = _G.STRINGS
STRINGS = s
nm,ch,ch_nm,rec,gendesc = s.NAMES,s.CHARACTERS,mk,s.RECIPE_DESC,s.CHARACTERS.GENERIC.DESCRIBE
mk_gen = function (n,v) end --заглушка пока что
slang = function()end
arr=_G.rawget(_G,"arr")or function() end

-------------------------------------------------Steampunk DST
--http://steamcommunity.com/sharedfiles/filedetails/?id=418604101

--Приоритет мода больше, чем приоритет русификатора, так что все изменения можно смело писать без экранирования.

mk("GEAR_AXE","Механический топор",1,0,1,false,"Механическим топором")
mk("GEAR_MACE","Механическая булава",3,0,"Механическую булаву",false,"Механической булавой")
mk("GEAR_HAT","Механическая шляпа",3,0,"Механическую шляпу",false,"Механической шляпой")
mk("GEAR_MASK","Механическая маска",3,0,"Механическую маску",false,"Механической маской")
mk("GEAR_ARMOR","Механическая переносная печка",3,0,"Механическую переносную печку",false,"Механической переносной печкой")
mk("GEAR_HELMET","Механическая каска",3,0,"Механическую каску",false,"Механической каской")
mk("GEAR_WINGS","Механические крылья",5,0,"Механические крылья",false,"Механическими крыльями")
mk("SENTINEL","WS-01",2,1,1,true,1)
mk("WS_03","WS-03",2,1,1,true,1)
mk("GEAR_TORCH","Механический факел",1,0,"Механический факел",false,"Механическим факелом")
mk("BULBO","Лампочник",2,"Лампочнику","Лампочника",false,"Лампочником")


--ЗАМЕНИЛ В MODMAIN.LUA МОДА:


--- Strings for items
rec.GEAR_AXE = "Лучше топора может быть только механический топор!"
rec.GEAR_MACE = "Убийственно тяжелая булава!"
rec.GEAR_HAT = "Потрясающе элегантная шляпа!"
rec.GEAR_MASK = "Маска чумного доктора, специально для вас!"
rec.GEAR_ARMOR = "Переносная, но тяжелая!"
rec.GEAR_HELMET = "Тяжелая каска для сварки!"
rec.GEAR_WINGS = "Не летают, но зато ускоряют!"
rec.SENTINEL = "Ваш собственный механический подданный!"
rec.WS_03 = "Этот механический защитник может стать вашим!"
rec.GEAR_TORCH = "Забавная смесь факела и лампочки."


GLOBAL.STRINGS.NAMES.GEAR_TAB = "МЕХАНИЗМЫ"

STRINGS.TABS.GEAR_TAB = "Механизмы"

local gen = gendesc
gen.GEAR_AXE = "Время для рубки дров!"
gen.GEAR_MACE = "Думаю, пригодится!"
gen.GEAR_HAT = "Замечательная шляпа!"
gen.GEAR_MASK = "Очень жуткая вещица."
gen.GEAR_ARMOR = "Она довольно тяжелая, но отлично греет!"
gen.GEAR_HELMET = "Кажется на ней нацарапано имя...Ковач."
gen.GEAR_WINGS = "Теперь мне нужен только ветер."
gen.SENTINEL = "Машина, порожденная машиной."
gen.WS_03 = "Повезло, что он на моей стороне."
gen.BULBO = "Никогда бы не подумал, что такое вообще бывает."
gen.GEAR_TORCH = "Я использую это в благих целях."

--- Willow - items strings
pp(ch.WILLOW.DESCRIBE.GEAR_AXE, "Холодный и острый.")
pp(ch.WILLOW.DESCRIBE.GEAR_MACE, "Теперь мне нужно найти цель.")
pp(ch.WILLOW.DESCRIBE.GEAR_HAT, "Осталось прицепить лампочку на верхушку шляпы.")
pp(ch.WILLOW.DESCRIBE.GEAR_MASK, "Пугает. И мне это нравится.")
pp(ch.WILLOW.DESCRIBE.GEAR_ARMOR, "Приятно просто сесть и смотреть внутрь.")
pp(ch.WILLOW.DESCRIBE.GEAR_HELMET, "Эта штуковина решила встать между мной и огнём?!")
pp(ch.WILLOW.DESCRIBE.GEAR_WINGS, "Я могла бы поджечь их для эффективности. Но не стану.")
pp(ch.WILLOW.DESCRIBE.SENTINEL, "Он поможет мне в бою.")
pp(ch.WILLOW.DESCRIBE.WS_03, "Я создала нечто удивительное!")
pp(ch.WILLOW.DESCRIBE.BULBO, "Эй, милашка, дай тебя обнять!")
pp(ch.WILLOW.DESCRIBE.GEAR_TORCH, "Так много света внутри такой маленькой лампочки.")

--- Wolfgang - items strings
pp(ch.WOLFGANG.DESCRIBE.GEAR_AXE, "Довольно острый!")
pp(ch.WOLFGANG.DESCRIBE.GEAR_MACE, "С этой штуковиной Вольфганг еще сильнее!")
pp(ch.WOLFGANG.DESCRIBE.GEAR_HAT, "Прекрасная шляпа для могучего Вольфганга.")
pp(ch.WOLFGANG.DESCRIBE.GEAR_MASK, "Страшная. Правда, очень страшная.")
pp(ch.WOLFGANG.DESCRIBE.GEAR_ARMOR, "Перенос тяжестей - хорошая тренировка!")
pp(ch.WOLFGANG.DESCRIBE.GEAR_HELMET, "Вольфганг теперь непобедим!")
pp(ch.WOLFGANG.DESCRIBE.GEAR_WINGS, "Вольфганга они явно не поднимут!")
pp(ch.WOLFGANG.DESCRIBE.SENTINEL, "С дороги! Слабак!")
pp(ch.WOLFGANG.DESCRIBE.WS_03, "Могучий воин! Прямо как и Вольфганг!")
pp(ch.WOLFGANG.DESCRIBE.BULBO, "Я могу раздавить его одним пальцем!")
pp(ch.WOLFGANG.DESCRIBE.GEAR_TORCH, "Поможет мне в темноте.")

--- Wendy - items strings
pp(ch.WENDY.DESCRIBE.GEAR_AXE, "Уничтожать деревья еще никогда не было так приятно.")
pp(ch.WENDY.DESCRIBE.GEAR_MACE, "Теперь я смогу править миром... или маленькой частью.")
pp(ch.WENDY.DESCRIBE.GEAR_HAT, "Выгляжу в ней как леди.")
pp(ch.WENDY.DESCRIBE.GEAR_MASK, "Мрачная красивая маска, сделанная из мертвых ворон.")
pp(ch.WENDY.DESCRIBE.GEAR_ARMOR, "Выглядит зловеще. Мне нравится!")
pp(ch.WENDY.DESCRIBE.GEAR_HELMET, "Чувствую, как моя голова падает на землю.")
pp(ch.WENDY.DESCRIBE.GEAR_WINGS, "Надеюсь, они сделаны из костей.")
pp(ch.WENDY.DESCRIBE.SENTINEL, "Надеюсь, Абигейл не станет ревновать.")
pp(ch.WENDY.DESCRIBE.WS_03, "Всадник смерти.")
pp(ch.WENDY.DESCRIBE.BULBO, "Этот крошечный паук работает на электричестве.")
pp(ch.WENDY.DESCRIBE.GEAR_TORCH, "Защитит меня от темноты. Меня. От темноты. Ха-ха.")

--- WX-78 - items strings
pp(ch.WX78.DESCRIBE.GEAR_AXE, "РАСТЕНИЯ НЕ ИМЕЮТ ШАНСОВ")
pp(ch.WX78.DESCRIBE.GEAR_MACE, "УНИЧТОЖАЮЩЕЕ УСТРОЙСТВО ГОТОВО")
pp(ch.WX78.DESCRIBE.GEAR_HAT, "ЭЛЕГАНТНОЕ УСТРОЙСТВО ДЛЯ ГОЛОВЫ")
pp(ch.WX78.DESCRIBE.GEAR_MASK, "УСКОРЯЕТ РЕГЕНЕРАЦИЮ ЗДОРОВЬЯ НО ОТНИМАЕТ РАССУДОК")
pp(ch.WX78.DESCRIBE.GEAR_ARMOR, "ТЯЖЕЛЫЙ ИСТОЧНИК СВЕТА")
pp(ch.WX78.DESCRIBE.GEAR_HELMET, "ПОВЫШАЕТ ОГНЕСТОЙКОСТЬ")
pp(ch.WX78.DESCRIBE.GEAR_WINGS, "ОБЪЕКТ ПОВЫШАЕТ СКОРОСТЬ ПЕРЕДВИЖЕНИЯ")
pp(ch.WX78.DESCRIBE.SENTINEL, "ЗАЩИТНЫЙ ДРОИД АКТИВИРОВАН")
pp(ch.WX78.DESCRIBE.WS_03, "МЕХАНИЧЕСКИЙ РАЗРУШИТЕЛЬ ПРИВЕДЕН В БОЕВУЮ ГОТОВНОСТЬ")
pp(ch.WX78.DESCRIBE.BULBO, "ЭЛЕКТРИЧЕСКОЕ НАСЕКОМОЕ В ПОЛЕ ЗРЕНИЯ")
pp(ch.WX78.DESCRIBE.GEAR_TORCH, "НОВЫЙ СПОСОБ ИСПОЛЬЗОВАТЬ ЛАМПОЧКУ")

--- Wickerbottom - items strings
pp(ch.WICKERBOTTOM.DESCRIBE.GEAR_AXE, "Топор особого типа, сделанный из шестерёнок.")
pp(ch.WICKERBOTTOM.DESCRIBE.GEAR_MACE, "Это причудливое устройство не для неуклюжих работников.")
pp(ch.WICKERBOTTOM.DESCRIBE.GEAR_HAT, "По крайней мере, мне удастся поддерживать имидж.")
pp(ch.WICKERBOTTOM.DESCRIBE.GEAR_MASK, "Я не уверена, стоит ли лечиться таким способом.")
pp(ch.WICKERBOTTOM.DESCRIBE.GEAR_ARMOR, "Обеспечит меня теплом и светом.")
pp(ch.WICKERBOTTOM.DESCRIBE.GEAR_HELMET, "Обеспечивает надежную защиту от огня.")
pp(ch.WICKERBOTTOM.DESCRIBE.GEAR_WINGS, "Как практично.")
pp(ch.WICKERBOTTOM.DESCRIBE.SENTINEL, "Не такое уж и сложное устройство, как по мне.")
pp(ch.WICKERBOTTOM.DESCRIBE.WS_03, "Я создала его для своей защиты.")
pp(ch.WICKERBOTTOM.DESCRIBE.BULBO, "Интересный способ использовать лампочки.")
pp(ch.WICKERBOTTOM.DESCRIBE.GEAR_TORCH, "Он органический или нет?")

--- Woodie - items strings
pp(ch.WOODIE.DESCRIBE.GEAR_AXE, "Почти также хорош, как моя Люси.")
pp(ch.WOODIE.DESCRIBE.GEAR_MACE, "Сделана из ценных пород дерева. И какого-то хлама.")
pp(ch.WOODIE.DESCRIBE.GEAR_HAT, "Выглядит неплохо, должен признать.")
pp(ch.WOODIE.DESCRIBE.GEAR_MASK, "Ненавижу эту маску. Похожа на противную птицу.")
pp(ch.WOODIE.DESCRIBE.GEAR_ARMOR, "Ха! Теперь я могу рубить деревья даже ночью.")
pp(ch.WOODIE.DESCRIBE.GEAR_HELMET, "Защитит меня от щепок во время рубки.")
pp(ch.WOODIE.DESCRIBE.GEAR_WINGS, "Я буду глупо выглядить, если это надену.")
pp(ch.WOODIE.DESCRIBE.SENTINEL, "Он будет защищать меня, пока я буду рубить деревья.")
pp(ch.WOODIE.DESCRIBE.WS_03, "Может быть он будет рубить деревья для меня?!")
pp(ch.WOODIE.DESCRIBE.BULBO, "Страшно рубить деревья, если на них сидит такое существо!")
pp(ch.WOODIE.DESCRIBE.GEAR_TORCH, "Больше не такой съедобный.")

--- Waxwell - items strings
pp(ch.WAXWELL.DESCRIBE.GEAR_AXE, "Использовать этот топор почти не унизительно.")
pp(ch.WAXWELL.DESCRIBE.GEAR_MACE, "Надеюсь, этим можно вынести мозги.")
pp(ch.WAXWELL.DESCRIBE.GEAR_HAT, "Буду выглядить еще лучше, чем обычно.")
pp(ch.WAXWELL.DESCRIBE.GEAR_MASK, "Подходит к моей персоне. Просто шучу.")
pp(ch.WAXWELL.DESCRIBE.GEAR_ARMOR, "Жаль, что я не могу заставить кого-нибудь таскать это за меня.")
pp(ch.WAXWELL.DESCRIBE.GEAR_HELMET, "Иногда приходится жертвовать стилем. Ненадолго.")
pp(ch.WAXWELL.DESCRIBE.GEAR_WINGS, "Не могу поверить, что это смастерил я.")
pp(ch.WAXWELL.DESCRIBE.SENTINEL, "Я мог бы создать что-нибудь более захватывающее.")
pp(ch.WAXWELL.DESCRIBE.WS_03, "Неплохое изобретение!")
pp(ch.WAXWELL.DESCRIBE.BULBO, "Я почти и забыл об этом жалком создании.")
pp(ch.WAXWELL.DESCRIBE.GEAR_TORCH, "Чарли ненавидит этот свет.")

	--if GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then 

--- Wigfrid - items strings
pp(ch.WATHGRITHR.DESCRIBE.GEAR_AXE, "Стильный топор для разрушения!")
pp(ch.WATHGRITHR.DESCRIBE.GEAR_MACE, "Выглядит глупо, но бьет хорошо.")
pp(ch.WATHGRITHR.DESCRIBE.GEAR_HAT, "Это разве по мне?")
pp(ch.WATHGRITHR.DESCRIBE.GEAR_MASK, "Я должна полагаться на силу, а не на магию.")
pp(ch.WATHGRITHR.DESCRIBE.GEAR_ARMOR, "Даст мне тепло в походе.")
pp(ch.WATHGRITHR.DESCRIBE.GEAR_HELMET, "Какой-то неудобный шлем.")
pp(ch.WATHGRITHR.DESCRIBE.GEAR_WINGS, "Я смогу улететь прямиком в Вальгаллу!")
pp(ch.WATHGRITHR.DESCRIBE.SENTINEL, "Теперь он мой раб!")
pp(ch.WATHGRITHR.DESCRIBE.WS_03, "Могучий паук на моей стороне!")
pp(ch.WATHGRITHR.DESCRIBE.BULBO, "Он меня не интересует!")
pp(ch.WATHGRITHR.DESCRIBE.GEAR_TORCH, "Светится!")

--- Webber - items strings
pp(ch.WEBBER.DESCRIBE.GEAR_AXE, "Теперь мы сможем рубить деревья со вкусом.")
pp(ch.WEBBER.DESCRIBE.GEAR_MACE, "Слишком сложно для нас.")
pp(ch.WEBBER.DESCRIBE.GEAR_HAT, "Папе бы понравилась эта шляпа!")
pp(ch.WEBBER.DESCRIBE.GEAR_MASK, "Наполовину паук, наполовину ворона.")
pp(ch.WEBBER.DESCRIBE.GEAR_ARMOR, "Теперь мы сможем согреться!")
pp(ch.WEBBER.DESCRIBE.GEAR_HELMET, "Мы под защитой.")
pp(ch.WEBBER.DESCRIBE.GEAR_WINGS, "Лучший способ заполучить крылья - сплести паутину.")
pp(ch.WEBBER.DESCRIBE.SENTINEL, "Он так похож на нас!")
pp(ch.WEBBER.DESCRIBE.WS_03, "Мы создали идеального друга!")
pp(ch.WEBBER.DESCRIBE.BULBO, "Такой же паук, но с лампочкой вместо головы!")
pp(ch.WEBBER.DESCRIBE.GEAR_TORCH, "Свет без огня! Лучшее изобретение!")
	--end
	
	
--ТАМ ЖЕ, ФРАЗЫ НОВЫХ МОБОВ (НЕЗНАЮ, КАК ВЫКОВЫРЯТЬ ЭТИ СТРОЧКИ):


------------ Feeding
pp("HEALTH RESTORED!","ЗДОРОВЬЕ ВОССТАНОВЛЕНО!")
pp("ERROR!","ОШИБКА!")

---------- Main pet init function ---------
pp("FIRMWARE UPDATED!","ПРОШИВКА ОБНОВЛЕНА!")
pp("ACCESS GRANTED!","ДОСТУП РАЗРЕШЕН!")
pp("NEW ADMINISTRATOR!","НОВЫЙ АДМИНИСТРАТОР!")
pp("RESET FIRMWARE!","СБРОС ПРОШИВКИ!")
pp("HARD RESET!","СБРОС НАСТРОЕК!")
pp("SYSTEM PANIC!","СИСТЕМНАЯ ПАНИКА!")
pp("WRONG PASSWORD!","НЕПРАВИЛЬНЫЙ ПАРОЛЬ!")
	
------------------------------------------------------------------ВСЁ
