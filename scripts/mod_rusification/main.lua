local function LoadModLocalisation(file, type)
	-- if t.CurrentTranslationType ~= t.TranslationTypes.Full then	
		-- t.print("ERROR: Tried to load invalid fn!")
		-- return
	-- end
	if type ~= nil then
		modimport("scripts/mod_rusification/transl/"..file)
	else
		modimport("scripts/mod_rusification/mods/"..file)
	end
end

_G.TestModTranslator = function()
	LoadModLocalisation("hawaiian.lua", 1)
	LoadModLocalisation("loving_evil.lua", 1)
	LoadModLocalisation("pickle_it.lua")
	LoadModLocalisation("archery_mod.lua")
	LoadModLocalisation("waiter_101.lua")
	LoadModLocalisation("beefalo_milk.lua")
end

-- TestModTranslator()

--Засовываем ВЕСЬ старый перевод в post init, чтобы он уж точно работал, независимо от приоритета мода.
RegisterTranslation(function() ---НАЧАЛО
--Переводы от loving_evil
LoadModLocalisation("loving_evil.lua", 1)


---------------Storm Cellar
--http://steamcommunity.com/sharedfiles/filedetails/?id=382177939
ch_nm("CELLAR","Убежище",4,"Убежищу",1)
rec.CELLAR = "Так же, как у меня в подвале, - полно мусора."
--gendesc.CELLAR = "Оно мне уже нравится."
pp("I like it","Мне это нравится") --Слишком общая фраза, чтобы переводить конкретно.

--------------------Display food values
--http://steamcommunity.com/sharedfiles/filedetails/?id=347079953
--Автор мода отказался от добавления в свой мод нативной поддержки русского языка с автоопределением русификатора.
--Что ж, придется нам самим это сделать, так сказать, насильственно.
--Но из уважения к автору в описании укажем, что мод не переведен нами, а уже имеет нативную поддержку.
	s.DFV_HUNGER = "Голод"
	s.DFV_HEALTH = "Здоровье"
	s.DFV_SANITY = "Рассудок"
	s.DFV_SPOILSOON = "Скоро испортится"
	s.DFV_SPOILIN = "Испортится через"
	s.DFV_SPOILDAY = "дней"

---------------------DST Advanced Farming
--http://steamcommunity.com/sharedfiles/filedetails/?id=370373189
	nm.G_HOUSE = "Парник" --"Advance Farm"
	rec.G_HOUSE = "Это сельскохозяйственный прорыв!"
	pp("I won't starve this winter!","Я не буду голодать этой зимой!")

	ch_nm("HYBRID_BANANA_TREE","Банановое дерево",4) --"Hybrid Banana Tree"
	--rec.HYBRID_BANANA_TREE = " It's an agricultural breakthrough!" --было в дс версии
	rec.HYBRID_BANANA_TREE = "Хорошая вещь!"
	pp("It's fruit is absolutely delicious!","Эти плоды абсолютно восхитительны!")

	ch_nm("HYBRID_BANANA_SEEDS","Семена банана",5,"Семенам банана",1)
	rec.HYBRID_BANANA_SEEDS = "Генномодифицированные семена банана."
	pp("These are worth their weight in gold!","Эти семена на вес золота!")

	ch_nm("HYBRID_BANANA","Бананы",5)
	nm.HYBRID_BANANA_COOKED = "Жареные бананы"
	pp("Love these guys fresh!","Люблю их свежими!")
	pp("Well now my mouth is watering!", "Аж слюнки текут!")

-------------------------------------------Wall Gates [DST]
--http://steamcommunity.com/sharedfiles/filedetails/?id=357875628
--NOT FINISHED!
	mk("MECH_HAY_ITEM","Травяная ширма",3)
	rec.MECH_HAY_ITEM="Части травяных ворот."

	mk("MECH_WOOD_ITEM","Деревянная ширма",3)
	rec.MECH_WOOD_ITEM="Части деревянных ворот."

	nm.MECH_STONE_ITEM = "Каменный заслон"
	rec.MECH_STONE_ITEM = "Створки каменных ворот."

	nm.MECH_RUINS_ITEM = "Тулецитовый заслон"
	rec.MECH_RUINS_ITEM = "Створки тулецитовых ворот."

	--nm.MECH_HAY = nm.MECH_HAY_ITEM
	mk("MECH_HAY","Травяная ширма",3)
	--nm.MECH_WOOD = nm.MECH_WOOD_ITEM
	mk("MECH_WOOD","Деревянная ширма",3)
	nm.MECH_STONE = nm.MECH_STONE_ITEM
	nm.MECH_RUINS = nm.MECH_RUINS_ITEM
	
	--mk("LOCKED_MECH_STONE_ITEM", --jj?

	-- gendesc.MECH_HAY = "Сезам откройся!"
	-- gendesc.MECH_WOOD = "Сезам откройся!"
	-- gendesc.MECH_STONE = "Сезам откройся!"
	-- gendesc.MECH_RUINS = "Сезам откройся!"

	-- gendesc.MECH_HAY_ITEM = "Тук-тук!"
	-- gendesc.MECH_WOOD_ITEM = "Тук-тук!"
	-- gendesc.MECH_STONE_ITEM = "Тук-тук!"
	-- gendesc.MECH_RUINS_ITEM = "Тук-тук!"
	
	--Далее очень много реплик. И механика мода не ясна до конца.
	


----------------------------------Large Chest
--http://steamcommunity.com/sharedfiles/filedetails/?id=396026892
mk("LARGECHEST","Большой сундук")
rec.LARGECHEST = "Для хранения огромного количества вещей."
pp( "Looks so fancy!","Выглядит так модно!")

mk("LARGEICEBOX","Гигантский холодильник",1,"Гигантскому холодильнику")
rec.LARGEICEBOX = "Всё влезет."
pp("I have harnessed the power of cold!","Теперь я повелеваю холодом!")



---------------------------DST Path Lights
--http://steamcommunity.com/sharedfiles/filedetails/?id=385006082
mk("PATH_LIGHT","Свет для тропинки",1,0,1)
rec.PATH_LIGHT = "Освещает ваши дорожки."
pp("It's a light","Это свет") --Очень общая фраза! Осторожно!

--------------------------DST Freezer
--http://steamcommunity.com/sharedfiles/filedetails/?id=346962876
mk("FREEZER","Морозильник")
rec.FREEZER = "Мило!"
pp("Should Do Nicely","Если делать, то красиво")

--------------------------Birds and Berries and Trees and Flowers for Friends
--http://steamcommunity.com/sharedfiles/filedetails/?id=522117250
mk("BERRYBLUE","Куст черники")
pp("Mmmmmmmm......blue.","Мммммммммм....... синий.")

mk("DUG_BERRYBLUE","Куст черники")
pp("Blueberries where I want them.","Черника будет там, где я захочу.")

mk("BERRYBLU2","Куст черники")
mk("DUG_BERRYBLU2","Куст черники")

--
mk("BERRYBL","Черника",3)
pp("Squishy and tasty!","Хлюпкая и вкусная!") --Сомневаюсь, что "Squishy" встретится где-то еще.

mk("BERRYBL_COOKED","Жареная черника",3)
pp("So warm and juicy.","Такая тёплая и сочная.") --...Надеюсь, что уникальная...

mk("PINEAPPLE","Ананасовый цветок")
pp("A sweet treat for a sweet person","Сладкое угощение для ласкового персонажа")
mk("DUG_PINEAPPLE","Ананасовый цветок")

mk("PAPPFRUIT","Ананас")
pp("Juicy","Сочный") --Общая фраза

mk("PAPPFRUIT_COOKED","Печёный ананас")
pp("Tastes like summer","На вкус, как лето")

mk("PAPPDISH","Ананас с кусочками льда",1,0,1)
pp("Siesta time","Время сиесты")

mk("TREEAPPLE","Антоновка",3) --"Green Apple"
pp("Not my favourite snack","Не самая любимая закуска")

mk("TREEAPPLEPIE","Шарлотка",3) --"Apple pie"
pp("Delicious to the core","Вкусная начинка")

mk("APPLETREE","Яблоня",3)
--pp("Home grown and strong","???")

mk("BERRYGREE","Куст крыжовника",1,0,1)
pp("I don't think these are edible.","Не думаю, что они съедобные")
mk("DUG_BERRYGREE","Куст крыжовника",1,0,1)
pp("Edible poison.","Съедобный яд.")
mk("BERRYGRE2","Куст крыжовника",1,0,1)
mk("DUG_BERRYGRE2","Куст крыжовника",1,0,1)
pp("Spreadable poison.","Распространяемый яд.")

mk("BERRYGR","Крыжовник болотный",1,0,0,nil,"Крыжовником болотным")
pp("Smells a little off.","Слегка подванивает.")
mk("BERRYGR_COOKED","Жареный крыжовник")
pp("Might have improved a little.","Слегка получше.")

------------------------- Mining Machine [DST]
--http://steamcommunity.com/sharedfiles/filedetails/?id=516523980
mk("MININGMACHINEKIT_ITEM","Комплект запчастей")
--rec.MININGMACHINEKIT_ITEM = "Jury rigged Ikea" --jj: ???
--pp("I better get to building soon.","") --jj:???

mk("MININGMACHINEKIT","Комплект запчастей")

mk("MININGMACHINE","Буровая установка",3)
pp("It is more efficient if turned on...","Она более эффективна, когда включена.")
pp("The ground has foiled me.","Почва подвела меня.")
pp("I wonder what it will dig up.","Любопытно, что же она выкопает.")
pp("Like me, it's not working with an empty belly.","Как и я, она не работает на пустой желудок.")

mk("MININGMACHINE_DESTROYED","Остатки буровой установки",5) --jj: обломки?
pp("It won't dig much now...","Больше не будет копать...")

mk("MININGMACHINE_STORAGE","Хранилище буровой установки",4,"Хранилищу буровой установки")
pp("Which surprises are waiting for me in here?","Какие сюрпризы меня там ждут?")

mk("CRAPPYWRENCH","Деревянный ключ") --Разводной?
rec.CRAPPYWRENCH = "Сомнительное качество"
--pp("A jury rigged wrench"

mk("IRONWRENCH","Железный ключ")
rec.IRONWRENCH = "Немного более твёрдый"
pp("Something a bit more solid","Уже кое-что более твёрдое")

mk("MNZIRONORE","Железная руда",3)
pp("It might be dull, but it's useful","Может быть, звучит и глупо, но это полезно")

mk("WONKYSKELETON","Хрупкий скелет",1,"Хрупкому скелету")
pp("I guess I should be careful where I place my devices next time.",
	"Мне нужно быть осторожней с выбором места для моих устройств в следующий раз.")

--------------------------------Golden Spear [DST]
--http://steamcommunity.com/sharedfiles/filedetails/?id=386087632
mk("GOLDENSPEAR","Золотое копье",4)
rec.GOLDENSPEAR = "Золото более прочное?" 
pp("Gold is more durable?","Золото более прочное?")


	
	--jj: Плюс дополнительные реплики на всех персов

-------------------------------Sentries Mod [DST Version]
--http://steamcommunity.com/sharedfiles/filedetails/?id=508739792
mk("HEAVYSENTRY","Тяжеловесный часовой",2,"Тяжеловесному часовому","Тяжеловесного часового",nil,"Тяжеловесным часовым")
rec.HEAVYSENTRY = "Для ленивых ублюдков." --Дословный перевод. "For lazy bastards."
pp("Now I can sleep better at night.","Теперь я могу спать спокойнее ночью.")

mk("SENTRYARROW","Сторожевая стрела",3)
rec.SENTRYARROW = "Расходник для часовых."
pp("I'd better keep my sentries full of this.","Лучше я буду следить, чтобы часовые были всегда заряжены этим.")

---------------------------------8 Faced Fences Gates [DST]
--http://steamcommunity.com/sharedfiles/filedetails/?id=506204512
mk("WOODGATE_ITEM","Деревянные ворота",5,"Деревянным воротам",1)
rec.WOODGATE_ITEM = "Не пускайте самозванцев внутрь."
pp("Am I supposed to mount it myslef?","Я должен установить его самостоятельно?") --На момент создания была эта опечатка.
pp("Am I supposed to mount it myself?","Я должен установить его самостоятельно?")

mk("WOODGATE","Деревянные ворота",5,"Деревянным воротам",1)
pp("This doesn't look very strong...","Это выглядит не слишком крепко...")

RenameAction("OPENGATE","Открыть ворота")
RenameAction("CLOSEGATE","Закрыть ворота")
RenameAction("PLACEGATE","Поставить ворота")


----------------------------Sword MOD for DST
--http://steamcommunity.com/sharedfiles/filedetails/?id=387385956
mk("GOLDSWORD","Золотой меч")
rec.GOLDSWORD = "Когда хочешь убить паука, но меча уже мало."
pp("Ohh pointy and sharp! But best of all, IT'S MADE OF GOLD","Колет и режет! Но главное то, что сделано из ЗОЛОТА")

mk("STONESWORD","Меч")
rec.STONESWORD = "Когда хочешь убить паука, но копья уже мало."
pp("Ohh pointy and sharp!","Колет и режет!")

-------------------------------Spike Trap
--http://steamcommunity.com/sharedfiles/filedetails/?id=396822875
ch_nm("SPIKETRAP","Шипастая ловушка",3,0,0,nil,"Шипастой ловушкой")
rec.SPIKETRAP = "Удиви своих врагов!"
pp("That looks really sharp...","Выглядит очень остро...") --Общая фраза! Поэтому отказываемся от мн.числа.

ch_nm("SPIKETRAPSMALL","Ловушка-шип",3,"Ловушке-шипу",0,nil,"Ловушкой-шипом")
rec.SPIKETRAPSMALL = "Удиви своих врагов!"
--повтор

----------------------------More Actions
--http://steamcommunity.com/sharedfiles/filedetails/?id=447092740
RenameAction("WALLJUMP","Перепрыгнуть")
RenameAction("JUMPOVER","Прыгнуть")
RenameAction("TREEHIDE","Спрятаться (-5)")
RenameAction("TAKEREFUGE","Зайти в гости (-5)")
RenameAction("PUSH","Толкнуть") --jj: Что это??
RenameAction("SHOVE","Пнуть")
RenameAction("SEARCH","Обыскать")

----------------------------Personal Chesters
--http://steamcommunity.com/sharedfiles/filedetails/?id=463740026
--NB: мод не достоин упоминания.
mk("PERSONAL_CHESTER","Персональный честер",2,0,"Персонального честера")
mk("PERSONAL_CHESTER_EYEBONE","Персональный костеглаз")

-------------------------------Food Values - Item Tooltips (Server and Client)
--http://steamcommunity.com/sharedfiles/filedetails/?id=458940297
--NB: Как бы нативная поддержка (через опции). Здесь указывает насильственно.
--Не достоин упоминания.
	--s.DFV_HUNGER = "Голод" --Повтор из похожего мода
	--s.DFV_HEALTH = "Здоровье"
	--s.DFV_SANITY = "Рассудок"
	s.DFV_PERISHSOON = "Погибнет очень скоро"
	s.DFV_PERISHIN = "Погибнет в"
	--s.DFV_SPOILSOON = "Скоро испортится"
	--s.DFV_SPOILIN = "Испортится через"
	--s.DFV_SPOILDAY = "дней"
	s.DFV_STALESOON = "Пойдет черствый очень скоро"
	s.DFV_STALEIN = "Пойдет черствый в"
	s.DFV_REMAININGBURNTIME = "Оставшееся время записи: "
	s.DFV_TIMETILLMORNING = "Время до утра: "

----------------------------Growable Marble Trees
--http://steamcommunity.com/sharedfiles/filedetails/?id=363989569
--NB: Мелкий мод, не достоин упоминания.
mk("MARBLESEED","Мраморное семя",4,"Мраморному семени",1,nil,"Мраморным семенем")
mk("MARBLESEED_SAPLING","Молодое мраморное деревце",4)
pp("Looks just like a rock","Выглядит, как камень")
pp("Why would someone plant a rock?","Зачем кто-то посадил булыжник?")

----------------------------Stumps grow
--http://steamcommunity.com/sharedfiles/filedetails/?id=369083494
--jj: Мод нереально сложные, и названия зашиты где-то глубоко. К тому же там наверняка куча багов (жалобы есть на краши).

---------------------------------Koalefants' Family DST
--http://steamcommunity.com/sharedfiles/filedetails/?id=354533909
--NB: Не достоин упоминания из-за легкой багнутости
mk("BABY_KOALEFANT_SUMMER","Коалослонёнок",2,0,"Коалослонёнка")
pp("Aww. So adorable!","Ой какой прелестный!")

mk("BABY_KOALEFANT_WINTER","Зимующий коалослонёнок",2,0,"Зимующему коалослонёнку")
--pp("Aww. So adorable!" --Повтор

--Далее еще 10-20 реплик на стандартных персонажей.

----------------------------------Configurable Basic Wooden Club
--http://steamcommunity.com/sharedfiles/filedetails/?id=480228116
--NB: Аналогичная (другой арт, но префаб тот же) дубинка есть в другом моде (Ancient Items pack: DST).
ch_nm("WOODEN_CLUB","Деревянная дубинка",3)
rec.WOODEN_CLUB = "Простая пещерная дубинка из дерева."
pp("Not fine weaponry but it can still break some jaws.","Не самое лучшее оружие, но с ним всё еще можно набить кому-то морду.")

if FindName("Spider Blade DST") then
	----------------------------------Spider Blade DST
	--http://steamcommunity.com/sharedfiles/filedetails/?id=365170680
	--Есть еще один [fixed] мод. Похож на какую-то неудачную поделку. Но что там было "исправлено"?
	mk("SCYTHE","Паучий гребень")
	rec.SCYTHE = "Смертельное оружие, сделанное из смертельных когтей."
	pp("That's a sharp weapon!" ,"Это острое оружие!") --Общая фраза!

	mk("QUEEN_CLAW","Королевский коготь",1,"Королевскому когтю")
	pp("It's gross and very sharp." ,"Очень крупный и острый.")

	--jj: Далее стандартные персы имеют свои фразы
end

if FindName("Scythestest") then
	------------------------------------[DST]-Scythes
	--http://steamcommunity.com/sharedfiles/filedetails/?id=537902048
	mk("SCYTHE","Коса",3)
	rec.SCYTHE = "Коси врагов пачкками."
	pp("Mow down packs of enemies.","Коси врагов пачкками.")

	mk("SCYTHE_GOLDEN","Золотая коса",3)
	rec.SCYTHE_GOLDEN = "Более эффективный сбор."
	pp("Gathering more effective.","Более эффективный сбор.")
end


-------------------------------------Machete
--http://steamcommunity.com/sharedfiles/filedetails/?id=486322336
--NB: Слишком мелкий и не известный мод, чтобы упоминать
--Есть претензии к арту.
mk("MACHETE","Мачете",4,1,1,nil,1)
rec.MACHETE = "Стандартный охотничий инструмент. С изгибом."
pp("I really wouldn't want to get hit with that thing.","Я реально не хочу полчить этим по башке.")

--------------------------------------Magical Pouch v2
--http://steamcommunity.com/sharedfiles/filedetails/?id=399527034
--100%
mk("MAGICPOUCH","Волшебный мешочек")
rec.MAGICPOUCH = "Сжимает предметы, чтобы они поместились в кармане!"
pp("Shrinks items to fit in your pocket!","Сжимает предметы, чтобы они поместились в кармане!")

mk("ICEPOUCH","Охлаждающий волшебный мешочек")
rec.ICEPOUCH = "Магический мешочек, который хранит еду вечно!"
pp("A Magical Pouch that keeps food fresh forever!","Магический мешочек, который хранит еду вечно!")

-------------------------------------Turfed!
---http://steamcommunity.com/sharedfiles/filedetails/?id=514078314
STRINGS.TABS["Turf"] = "Покрытия"

mk("TURF_TEST","Тестовое покрытие",4)

mk("TURF_CARPETBLACKFUR","Ковёр из медвежьего меха",1,"Ковру из медвежьего меха",1,nil,"Ковром из медвежьего меха")
rec.TURF_CARPETBLACKFUR = "Рулон медвежьего ковра." 
pp("Warm and cozy carpet from the fur of a monster.","Теплый и уютный ковёр из меха монстра.")

mk("TURF_CARPETBLUE","Синий ковёр",1,"Синему ковру")
rec.TURF_CARPETBLUE = "Рулон синего ковра." 
pp("As blue as you.","Такой же синий, как и я, когда стою на нём.")

mk("TURF_CARPETCAMO","Камуфляж",1,0,0,nil,"Камуфляжем")
rec.TURF_CARPETCAMO = "Рулон камуфляжного ковра." 
pp("I bet you didn't see this carpet coming.","Бьюсь об заклад, вы не увидите этот ковёр.")

mk("TURF_CARPETFUR","Ковёр из меха бифало",1,"Ковру из меха бифало",1)
rec.TURF_CARPETFUR = "Рулон мехового ковра."
pp("Warm, snuggly, smelly.","Тёплый, уютный, ароматный.")

mk("TURF_CARPETPINK","Розовый ковёр",1,"Розовому ковру")
rec.TURF_CARPETPINK = "Рулон розового ковра."
pp("Pink carpet? As if!","Розовый ковер? Мне это кажется!")

mk("TURF_CARPETPURPLE","Фиолетовый ковёр",1,"Фиолетовому ковру")
rec.TURF_CARPETPURPLE = "Рулон фиолетового ковра."
pp("Purple is a royal color and also the color of this carpet.","Фиолетовый - королевский цвет, а также цвет этого ковра.")

mk("TURF_CARPETRED","Красный ковёр",1,"Красному ковру")
rec.TURF_CARPETRED = "Рулон красного ковра."
pp("Wash the white rug near the berries they said, it will be fine they told me...","Возьми густой вишневый сок и белый мамин... ковёр.\nЛей аккуратно сок на ковёр...")

mk("TURF_CARPETRED2","Бубновый ковёр",1,"Бубновому ковру")
rec.TURF_CARPETRED2 = "Рулон бубнового ковра."
pp("Shine bright like a blood diamond.","Сияет, как бриллиант в крови!")

mk("TURF_CARPETTD","Радужный ковёр",1,"Радужному ковру")
rec.TURF_CARPETTD = "Рулон радужного ковра."
pp("This carpet man, it like... whoa...","Приятель, этот ковёр... он... похож на... Вау! Просто Ах!")

mk("TURF_CARPETWIFI","Изолятор WiFi сигнала",1,0,1)
rec.TURF_CARPETWIFI = "Рулон анти-WiFi полотна."
pp("Can you feel me now? Good." ,"Никакого вредного излучения!")

--Nature
mk("TURF_NATUREASTROTURF","Искусственный газон")
rec.TURF_NATUREASTROTURF = "Рулон искусственного газона."
pp("Grass without the hassle!" ,"Трава без хлопот!")

mk("TURF_NATUREDESERT","Пустынный дёрн")
rec.TURF_NATUREDESERT = "Дёрн потрескавшейся почвы."
pp("Your own piece of dry, cracked, barren ground.","Собственный кусок сухой, потрескавшейся, бесплодной земли.")

--Rock
mk("TURF_ROCKBLACKTOP","Асфальт")
rec.TURF_ROCKBLACKTOP = "Асфальт"
pp("Blacktop, endless and pointless opportunities.","Щебеночно-асфальтовое покрытие, бесконечные и бессмысленные перспективы.")

mk("TURF_ROCKGIRAFFE","Дёрн а-ля жираф",1,"Дёрну а-ля жираф",1,nil,"Дёрном а-ля жираф")
rec.TURF_ROCKGIRAFFE = "Расцветка, как у жирафа."
pp("Made from freshly squeezed giraffe.","Сделано из свежевыжатого жирафа.")

mk("TURF_ROCKMOON","Лунное покрытие",4)
rec.TURF_ROCKMOON = "Лунное покрытие"
pp("Moon Rock turf phoooneee hooomeeee.","Хьюстон, у нас проблемы.")

mk("TURF_ROCKYELLOWBRICK","Желтый кирпич")
rec.TURF_ROCKYELLOWBRICK = "Желтый кирпич"
pp("Just follow it.","Просто иди по дороге из желтого кирпича.")

--Tile
mk("TURF_TILECHECKERBOARD","Шахматная плитка",3)
rec.TURF_TILECHECKERBOARD = "Шахматная плитка"
pp("Checkmate.","Шах и мат.")

mk("TURF_TILEFROSTY","Морозная плитка",3)
rec.TURF_TILEFROSTY = "Морозная плитка"
pp("Do you wanna build some tile?" ,"Хочешь еще наклепать плитки?")

mk("TURF_TILESQUARES","Мостовая",3,0,0,nil,"Мостовой")
rec.TURF_TILECHECKERBOARD = "Мощёная мрамором гостиная"
pp("Such tile, much squares." ,"Всем плиткам плитка. Больше прямоугольников!")

--Wood
mk("TURF_WOODCHERRY","Вишнёвый деревянный пол")
rec.TURF_WOODCHERRY = "Паркет из вишневого дерева."
pp("Where do you find cherries anyway?","Где вы нашли вишни?")

mk("TURF_WOODDARK","Пол из чёрного дерева",1,0,1)
rec.TURF_WOODDARK = "Паркет из эбенового дерева."
pp("Charlie's favorite color.","Это любимый цвет Чарли.")

mk("TURF_WOODPINE","Сосново-еловый пол",1,"Сосново-еловому полу")
rec.TURF_WOODPINE = "Тот же паркет, только с запахом ёлочки."
pp("Flooring that makes pinecones useful.","Покрытие, создание которого делает шишки полезными.")

------------------------------------ Buried Treasure
--http://steamcommunity.com/sharedfiles/filedetails/?id=384337948
--100%
--Tag: no tag
mk("BURIEDTREASURECHEST","Потайная ямка",3)
rec.BURIEDTREASURECHEST = "Обязательно запомни, где вырыто!"
pp("A safe place to hide my stuff!","Секретное место для хранения моих вещей.")
pp("Precious things might be hidden in there!","Драгоценности должны быть спрятаны здесь!")
pp("Wolfgang can hide things in here!","Тайники для слабых!")
pp("A crude, but effectively camouflaged, cache.","Не продуманный, но хорошо закамуфлированный секретный склад.")
pp("What secrets lie within?","Что за секрет прячет этот тайник?")
pp("A HIDDEN STORAGE SYSTEM.","СЕКРЕТНАЯ СИСТЕМА ХРАНЕНИЯ.")

--------------------------------zero_shadowarmor
--http://steamcommunity.com/sharedfiles/filedetails/?id=539519857
mk("JARMOR","Нулевая броня",3)
rec.JARMOR = "Безопасное мобильное убежище."
pp("Camouflages myself and can help me evade attacks except for AOE damage.","Скрывает меня и помогает уклоняться от нападений, кроме ударов по площади.")

-----------------------------------Pet Spat Family
--http://steamcommunity.com/sharedfiles/filedetails/?id=547727782
mk("BABYSPAT","Слиз-детёныш",2,"Слиз-детёнышу","Слиз-детёныша",nil,"Слиз-детёнышем")
pp("Their child is ugly, too","Их потомство тоже выглядит не очень.")

mk("EXPLOSIVEGAS","Взрывоопасный газ")
pp("A good gas explosive to blow down trees! ","Хорош для сдувания деревьев.")

mk("ARMORSTEEL","Стальная броня",3)
rec.ARMORSTEEL = "97.5% поглощение, 2000HP, 75% отражения"
pp("A good armor to reflect physic damage to your enemy ","Отличная броня, чтобы отражать физический урон.")

mk("HATSTEEL","Стальная шапка",3)
rec.HATSTEEL = "97.5% поглощение, 1500HP, 75% отражения"
pp("A good hat to reflect phlegem to your enemy ","Хорошая шапка, чтобы отражать атаки врагов.")

mk("PHLEGMSTAFF","Слиз-копьё",4,"Слиз-копью",1,nil,"Слиз-копьём")
rec.PHLEGMSTAFF = "Урон 74, использований 200, 10% липкость"
pp("A good staff randomly stick your enemy ","Хорошее оружие, чтобы приклеить врагов к земле.")

------------------------------------------Funny Turkey Friend
--http://steamcommunity.com/sharedfiles/filedetails/?id=556283641
mk("FEATHER_TURKEY","Перо индюка",4,0,1)
pp("Some useful feather","Полезное перо.")

mk("JMDZ","Ёршик")
pp("dust the enemy","Чисть врага! Чисть врага!")

mk("HAT_TURKEY","Индюшачья шляпа",3)
rec.HAT_TURKEY = "Ко-ко-ко." --В моде описание рецепта не задано вообще.
pp("just funny","Просто прикольно.")

--------------------------------------------Hostile Smart Mobs
--http://steamcommunity.com/sharedfiles/filedetails/?id=557024594
if STRINGS.CHARACTERS.GENERIC.DESCRIBE.DARKWIGFRID then
	mk("DARKWIGFRID","Враждебная Вигфрид",3,"Враждебной Вигфрид")
	pp(STRINGS.CHARACTERS.GENERIC.DESCRIBE.DARKWIGFRID,"О нет!")
	
	mk("DARKWOLFGANG","Враждебный Вольфганг",2,0,"Враждебного Вольфганга")
	pp(STRINGS.CHARACTERS.GENERIC.DESCRIBE.DARKWOLFGANG,"О нет!")
	
	mk("DARKWILLOW","Враждебная Уиллоу",3)
	pp(STRINGS.CHARACTERS.GENERIC.DESCRIBE.DARKWILLOW,"О нет!")
	
	mk("DARKWENDY","Враждебная Венди",3)
	pp(STRINGS.CHARACTERS.GENERIC.DESCRIBE.DARKWENDY,"О нет!")
	
	mk("DARKWX78","Враждебный робот",2,0,"Враждебного робота")
	pp(STRINGS.CHARACTERS.GENERIC.DESCRIBE.DARKWX78,"О нет!")
	
	mk("SUMMERFLY","Муха Цекотуха",3,"Мухе Цекотухе",0,true,"Мухой Цекотухой")
	pp(STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUMMERFL,"Это какая-то другая муха!")
	
	mk("BEARGER","Медведь-барсук",2,"Медведю-барсуку","Медведя-барсука")
	pp("РЬКЗФхГґЛАµДЈ¬±їЛАµДЈ¬2333", "Оп-па!")
end

------------------------------------------------The Palms
--http://steamcommunity.com/sharedfiles/filedetails/?id=422321826
--The Palms
ch_nm("DESERTPALM","Пальма",3)
pp("How do I procure said coconut?","Что еще можно встретить в пустыне?")

ch_nm("COCONUTMILK","Прохладительный напиток")
pp("Ahhhhh, chilly refreshment","Аааааах! Какой прохладный и свежий!")
pp("Beats eating ice","Круче, чем просто есть лёд.")

ch_nm("HAT_BEE_BW","Кокосовый шлем")
rec.HAT_BEE_BW = "Spoiling My Noggen" --Noggin - сленговое слово, означающее голову.

ch_nm("COCONUT","Кокос")
pp("I know it's good. How do I get it open","Я знаю, но полезен. Но как его открыть?")
pp("Mmmmmmm.....fuzzy","Ммммммм... Пушок")

------------------------------------------------Soulmates
--http://steamcommunity.com/sharedfiles/filedetails/?id=350811795
mk("BINDINGRING","Кольцо дружбы",4)
pp("I can use this to join my friend.","Я могу использовать его, чтобы найти друга.")
pp("It's so shiny. Almost as pretty as a fire.","Оно так горит жёлтым, словно огонь.")
--pp("Wolfgang does not wear jewellery. Could help Wolfgang, however?","")
pp("I can use this to return to the one person who understands my pain.","Оно мне нужно, чтобы найти родственную душу, которая понимает мою боль.")
pp("RELOCATION DEVICE. THE POWER SOURCE IS A MYSTERY.","УСТРОЙСТВО ПЕРЕМЕЩЕНИЯ. ИСТОЧНИК ЭНЕРГИИ - ДРУЖБА.")
pp("I've not done any research to back this up, but I have a hunch about this ring.","Мною не были проведены исследования, но у меня есть предчувствие, как оно работает.")
pp("It's like one of those tree rings, eh? But shinier. I bet Lucy would have loved this.","Это как одно из тех трех колец, да? Только круче. Люси понравится.")
pp("Now if only this ring would get me out of here.","Только это кольцо поможет мне убраться поскорее отсюда.")

-------------------------------------------------Claymore
--http://steamcommunity.com/sharedfiles/filedetails/?id=462498863
mk("CLAYMORE_GRAY","Клеймор")
rec.CLAYMORE_GRAY = "Это большой старинный изогнутый палаш."
pp("Its awfully sharp.","Неимоверно острое оружие")

end) -------------------------------------------------КОНЕЦ----------------------------------------------------


----------------------------------------------------Smarter Crock Pot
--http://steamcommunity.com/sharedfiles/filedetails/?id=365119238
--http://steamcommunity.com/sharedfiles/filedetails/?id=646342805 - серверная версия!
if FindName("SmartCrockPot") or FindName("Smarter Crock Pot (server)") then
	--Приоритет мода 10, а моего русифка 0.99. Авось мы попадем в точности куда надо и никто больше не перехватит.
	--В любом случае нужны проверки. ВЕЗДЕ.
	
	--Вытягивает локальные переменные из модуля по содержащейся в нем функции.
	--member_check - свойство таблицы, чтобы иметь полную уверенность, что это та самая таблица.
	local FindUpvalue = function(fn, upvalue_name, member_check)
		local info = debug.getinfo(fn, "u")
		local nups = info and info.nups
		if not nups then return end
		local getupvalue = debug.getupvalue
		local s = ''
		for i = 1, nups do
			local name, val = getupvalue(fn, i)
			if (name == upvalue_name)
				and ((not member_check) or (type(val)=="table" and val[member_check])) --Надежная проверка
			then
				return val, true
			end
		end
	end	
	
	--Мы надеемся, что в контейнерах уже подмененная функция containers.widgetsetup.
	--Именно она нам и нужна, чтобы получить доступ к локальным переменным мода.
	--Мы также надеемся, что между нами не вклинился другой мод.
	local containers = require "containers"
	local params = FindUpvalue(containers.widgetsetup, "params", "cookpot")
	if params and params.cookpot and params.cookpot.widget --Перестраховка по максимуму.
		and params.cookpot.widget.buttoninfo2
		and params.cookpot.widget.buttoninfo2.text == "Predict!" --Последняя проверка на то, та ли эта структура.
	then
		params.cookpot.widget.buttoninfo2.text = "Блюдо"
	end
end	

------ Переводы от Hawaiian ------
LoadModLocalisation("hawaiian.lua", 1)


--------------------------------------------------------------
-------------------- Hawaiian - ДОПОЛНИЛ ПЕРЕВОД СТАРА: ------
--------------------------------------------------------------

--------------------------------Beefalo Milk and Cheese
--http://steamcommunity.com/sharedfiles/filedetails/?id=436654027
if FindName("Beefalo Milk") then
	RegisterReplacedTranslation(function() --с подменой!!!
		LoadModLocalisation("beefalo_milk.lua")
	end)
end	

-------------------------- Waiter 101
--http://steamcommunity.com/sharedfiles/filedetails/?id=381565292
if FindName("Waiter 101 v") then
	RegisterReplacedTranslation(function() --с подменой!!!
		LoadModLocalisation("waiter_101.lua")
	end)
end	


-----------------Archery Mod [DST Version]
--http://steamcommunity.com/sharedfiles/filedetails/?id=488009136
if FindNameCut("Archery Mod") then
	RegisterTranslation(function() --без подмены
		LoadModLocalisation("archery_mod.lua")
	end)
end



-------------------------------Pickle it
--http://steamcommunity.com/sharedfiles/filedetails/?id=404983266
if FindName("Pickle It") then
	RegisterReplacedTranslation(function() --с подменой!!!
		LoadModLocalisation("pickle_it.lua")
	end)
end


--Коротенько переводим новые предметы
mk("MINISIGN","Мини-табличка",3)
mk("MINISIGN_ITEM","Мини-табличка",3)
rec.MINISIGN_ITEM = "Рисуй на ней карандашом."
mk("BUNDLEWRAP","Упаковочная обёртка",3)
rec.BUNDLEWRAP = "Продукты в ней не портятся."
mk("WAXPAPER","Восковая бумага",3)
rec.WAXPAPER = "Для упаковки вещей."
mk("BEESWAX","Пчелиный воск")
rec.BEESWAX = "Можно использовать, как консервант."
mk("DEER","Безглазый олень",2,0,"Безглазого оленя")
mk("DEER_GEMMED","Самоцветный олень",2,0,"Самоцветного оленя")
mk("DEER_ANTLER","Олений рог",1,"Оленьему рогу",1,nil,"Оленьим рогом")
mk("HIVEHAT","Пчелиная корона",3)
mk("KLAUSSACKKEY","Ключ Клауса",1,0,1)
mk("KLAUS","Клаус",2,0,"Клауса")
mk("KLAUS_SACK","Мешок с добром")
mk("PERDSHRINE","Индюшачья святыня",3)
rec.PERDSHRINE = 'Сделай подношения величавому индюку.'
mk("LUCKY_GOLDNUGGET","Счастливая золотая деталь",3,"Счастливой золотой детали")
mk("FIRECRACKERS","Красные Фейерверки",5)
rec.FIRECRACKERS = 'Празднуй с треском!'
mk("PERDFAN","Счастливый веер")
rec.PERDFAN = 'Особенно счастливый, особенно большой.'
mk("REDLANTERN","Красный фонарь")
rec.REDLANTERN = 'Фонарь удачи для освещения пути.'
mk("DRAGONHEADHAT","Голова чудовища",3,0,"Голову чудовища")
rec.DRAGONHEADHAT = 'Передняя часть костюма зверя.'
mk("DRAGONBODYHAT","Тело чудовища",4,0,1)
rec.DRAGONBODYHAT = 'Средняя часть костюма зверя.'
mk("DRAGONTAILHAT","Хвост чудовища",1,0,1)
rec.DRAGONTAILHAT = 'Задняя часть костюма зверя.'
mk("REDPOUCH","Красный мешочек")

----------------------- Marble Combat
--https://steamcommunity.com/sharedfiles/filedetails/?id=783732757
if FindName("Marble Combat") then
	mk("WHITEGEM","Белый камень")
	pp("An unnaturally white gemstone.","Неестественно белый камень.")
	rec.WHITEGEM = "Причудливый и блестящий." --"Bright and fancy." 

 
	mk("WHITESTAFF","Баллистический посох",1,"Баллистическому посоху")
	pp("Shoots a projectile made of heavy light.","Стреляет тяжёлым светом.")
	rec.WHITESTAFF = "По типу старой доброй магии из РПГ." --It's like old school RPG magic.

	mk("WHITEAMULET","Высасывающий амулет")
	pp("This amulet is ratiating exhaustion.", "Этот амулет излучает истощение.")
	pp("This amulet is radiating exhaustion.", "Этот амулет излучает истощение.")
	rec.WHITEAMULET = "Битва изнуряет."

	mk("MARBLEJAVELIN","Мраморное метательное копьё",4,"Мраморному метательному копью",1)
	pp("Throwable pain.","Приносящий боль.")
	rec.MARBLEJAVELIN = "Пронзай всех издалека." --"Stab anything from afar."

	mk("TRAP_MARBLE","Мраморный ёж",1,"Мраморному ежу","Мраморного ежа",nil,"Мраморным ежом")
	pp("Such a finely crafted trap.","Как прекрасно сделана эта ловушка!")
	rec.TRAP_MARBLE = "Замедляет цели."
	
	mk("MARBLEMACE","Мраморная булава",3)
	pp("Heavy and lethal.","Тяжелая и смертоносная.")
	rec.MARBLEMACE = "Разящий по площади тяжелый груз." --"Heavy load coming through."
end

------------------------ Whetstone Kit
--http://steamcommunity.com/sharedfiles/filedetails/?id=807543630
mk("WHETSTONE_KIT","Точильный камень")
rec.WHETSTONE_KIT = "Набор для заточки инструментов."
pp("A whetstone for sharpening my tools!" ,"Точильный брусок для моих инструментов!")

if FindName("Rifle") then
	RegisterReplacedTranslation(function() --с подменой!!! Строки заданы в префабах.
		mk("RIFLE","Винтовка",3)
		rec.RIFLE = "Винтовка Маузер 98k"
		
		mk("AMMO","Патроны",5)
		--rec.AMMO = "7.92 × 57 mm"
		pp("Ammo for Mauser 98k", "Патроны к винтовке Маузер 98k")
		
		mk("BAYONET","Штык")
		rec.BAYONET = "Только половина урона?"
		
		mk("RIFLEB","Винтовка со штыком",3)
		rec.RIFLEB = "Дай штыку полный урон."
	end)
end

--if FindName("SpringFestival") then
--end

------------------ Magic Bottle Lanterns (DST)
--http://steamcommunity.com/sharedfiles/filedetails/?id=787954095
if FindName("Magic Bottle Lanterns (DST)") or FindName("Magic Bottle Lanterns") then
	mk("MAGICLANTERN_WHITE","Светящийся флакон",1,"Светящемуся флакону",1,nil,"Светящимся флаконом")
	rec.MAGICLANTERN_WHITE = "Чтобы осветить твой путь."
	
	mk("MAGICLANTERN_RED","Угрожающий флакон")
	rec.MAGICLANTERN_RED = "Древняя сила."
	
	mk("MAGICLANTERN_BLUE","Ледяной флакон")
	rec.MAGICLANTERN_BLUE = "Успокаивающий свет."
	
	mk("MAGICLANTERN_PINK","Умиротворяющий флакон")
	rec.MAGICLANTERN_PINK = "Закат в бутылке."
	
	mk("MAGICLANTERN_PURPLE","Настойка",3)
	rec.MAGICLANTERN_PURPLE = "Мистическое свечение."
	
	mk("MAGICLANTERN_ORANGE", "Тлеющие угли",5,"Тлеющим углям")
	rec.MAGICLANTERN_ORANGE = "Подобно угасающему огню."
	
	mk("MAGICLANTERN_YELLOW", "Солнечный свет")
	rec.MAGICLANTERN_YELLOW = "Чтобы осветить ночь."
	
	mk("MAGICLANTERN_GREEN", "Флакон с ядом")
	rec.MAGICLANTERN_GREEN = "Нездоровое свечение."
end

------------------------ Portable cookpot
-- http://steamcommunity.com/sharedfiles/filedetails/?id=614931358
if FindName("Portable cookpot") then
	mk("PORTABLECOOKPOT", "Переносная кастрюля",3)
	mk("PORTABLECOOKPOT_ITEM", "Переносная кастрюля",3)
	rec.PORTABLECOOKPOT_ITEM = "Для путешественника."
	pp("Portable CookPot", "Возьму это с собой в путь-дорогу.")
end

----------------------Wooden Hut
-- http://steamcommunity.com/sharedfiles/filedetails/?id=768885735
if FindName("Wooden Hut") then
	mk("WOODGRASS_HUT", "Навес из листьев")
	rec.WOODGRASS_HUT = "Построй крышу над своей головой."
	pp("Shelter from the elements.", "Укрытие от стихий.")
end