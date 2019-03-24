------------------------workshop-356435289 Fish Farm
mk("W_POND","Рыбная ферма",3)
rec.W_POND = "Я смогу остаться дома подольше."
--pp("Fish like honey,who knew?","Рыбы любят мёд, кто знал?")
pp("Fish like honey,who knew?","Рыбы очень любят мёд! Почему и кто поймёт?\nВ самом деле, почему. Мёд так нравится кому?\nРыбам! Да!")

------------------------ Tungsten
mk("TUNGSTEN","Вольфрамовое Копье",4) --Tungsten Spear
rec.TUNGSTEN = "Выковано в огне."
mk("THERMAL_TETRAHEDRON","Термальный тетраэдр",1) --Thermal Tetrahedron
rec.THERMAL_TETRAHEDRON = "Лучший способ хранить тепло"
mk("SHIRUKEN","Бэторанг",1) --Batarang
rec.SHIRUKEN = "Сильное, одноразовое оружие"
mk("TUNGSTENORE","Вольфрамовый самородок",1) --Tungsten Nugget
rec.TUNGSTENORE = "Металлический материал"
mk("ROCK_TOUGH","Твёрдый валун",1) --Tough Stone
mk("TUNGSTEN_FIREPIT","Вольфрамовый костёр",1)
rec.TUNGSTEN_FIREPIT = "Улучшенный костёр, даёт больше тепла"
mk("TUNGSTEN_AXE","Порочный резак",1) -- Corrupt Cutter
rec.TUNGSTEN_AXE = "Ненавидит деревья"
mk("ARMOR_TUNGSTEN","Нулевой по Кельвину костюм",1) -- Zero Kelvin Suit
rec.ARMOR_TUNGSTEN = "Холодный, как глубокий космос"
mk("FIREBLADE","Огненный Флёр",1) --Fire Fleur
rec.FIREBLADE = "Может быть чересчур жарким для вас"
mk("WALL_TUNGSTEN_ITEM","Вольфрамовая стена",3) --Tungsten Wall
rec.WALL_TUNGSTEN_ITEM = "Лучшая защита для вашей базы"
mk("WALL_TUNGSTEN","Вольфрамовая стена",3)
mk("TUNGSTEN_PICKAXE","Бескирка",3) --Infiniminer
rec.TUNGSTEN_PICKAXE = "Праздник на крови ваших врагов"
mk("TUNGSTEN_HARDHAT","Вольфрамовая каска",3) --Tungsten Hardhat
rec.TUNGSTEN_HARDHAT = "Сожжет ваши ночные кошмары"
mk("TRAP_TESLA","Тесла ловушка",3,"Тесла ловушке",nil,nil,"Тесла ловушкой") --Tesla Trap
rec.TRAP_TESLA = "Эффективная оборона базы"
------------------------Musha
if STRINGS.CHARACTERS.MUSHA then
	STRINGS.NAMES.MUSHA = "Муша"
	STRINGS.CHARACTER_TITLES.musha = "Королева пёсиков Муша в DST"
	STRINGS.CHARACTER_NAMES.musha = "Муша"
	STRINGS.CHARACTER_QUOTES.musha = "\" Я настоящая принцесса ! \""
	STRINGS.CHARACTERS.MUSHA.DESCRIBE.MUSHA = {"Она прикольная", "Напоминает меня.."}
	pp("maybe she can join my Books club members.","Может быть она присоединится к моему клубу читателей.")
	pp("Royal blood ? Hmm...","Королевская кровь? Хмм...")
	pp("she can transform?..no, maybe not","Она может превратиться?..скорее всего нет")
	pp("She is weak force .. but seems going to help us.","Она слабая .. но кажется, поможет нам")
	pp("I feel a strong spirit..","Я чувствую сильный дух..")
	pp("I feel my heart.","Я чувствую моё сердце.")
	pp("Feels good!","Приятная!")
	pp("Fight fight fight","Драка драка драка")
	pp("Assasin!","Убийца!")
	pp("Return..","Вернись..")
	pp("go away !","Уходи!")
	--Реплики Муши ^_^
	pp("Musha can't move arms anymore...","Муша больше не может пошевелить руками...")
	pp("Wood hit Musha! Musha throws that bad wood!","Деревяшка ударила Мушу! Муша бросает эту плохую деревяшку!")
	pp("Something behind Musha!","Что-то у Муши за спиной!")
	pp("Stop biting Musha's head! Musha will beat you!","Прекрати кусать Мушу за голову! Муша тебя побьёт!")
	pp("Ah! Musha's fingers are freezing!","Ах! Пальчики Муши замерзают!")
	pp("Musha's soles are burning!","Мушины подошвы горят!")
	pp("Sun has gone!\nMusha have to prepare a light!","Солнце село!\nМуша должна подготовить свет!")
	pp("Yum!","Ням!")
	pp("Ew!","Фу!")
	pp("IT IS NOT FOOD! Bleh!","ЭТО НЕ ЕДА! Гадость!")
	pp("Bleh!","Гадость!")
	pp("Musha never lay down here!\n Musha's back would be freeze!","Муша не ляжет здесь!\n Муша замёрзла бы!")
	--FIRESUPPRESSOR
	pp("It require many fuel. Don't forget it.","Она требует много топлива. Не забывай это.")
	pp("Fuel is running low. Musha checked it.","Топливо на исходе. Муша проверила.")
	--COOKPOT
	pp("It require long time.","Это займёт много времени.")
	pp("It can cook very shot time.","Это приготовится очень быстро")
	pp("Musha likes that! How about you?","Муше это нравится! А тебе?")
	pp("No one use that. Now it is Musha's turn.","Никто не пользуется. Теперь очередь Муши.")
	pp("Why does that stone burned out?","Почему этот камень сгорел?")

	---РЕЦЕПТЫ И ПРЕДМЕТЫ
	--Ямчи-
	mk("MUSHA_EGG","Яйцо Феникса",4,nil,1)
	mk("MUSHA_EGG_CRACKED","Яйцо Феникса",4,nil,1)
	mk("MUSHA_EGGS1","Яйцо Феникса (Ур 2)",4,nil,1)
	mk("MUSHA_EGG_CRACKEDS1","Яйцо Феникса",4,nil,1)
	mk("MUSHA_EGGS2","Яйцо Феникса (Ур 3)",4,nil,1)
	mk("MUSHA_EGG_CRACKEDS2","Яйцо Феникса",4,nil,1)
	mk("MUSHA_EGGS3","Яйцо Феникса (Ур 4)",4,nil,1)
	mk("MUSHA_EGG_CRACKEDS3","Яйцо Феникса",4,nil,1)
	mk("MUSHA_EGG1","Яйцо Феникса (Ур 5)",4,nil,1)
	mk("MUSHA_EGG_CRACKED1","Яйцо Феникса",4,nil,1)
	mk("MUSHA_EGG2","Яйцо Феникса (Ур 6)",4,nil,1)
	mk("MUSHA_EGG_CRACKED2","Яйцо Феникса",4,nil,1)
	mk("MUSHA_EGG3","Яйцо Феникса (Ур 7)",4,nil,1)
	mk("MUSHA_EGG_CRACKED3","Яйцо Феникса",4,nil,1)
	mk("MUSHA_EGG8","Яйцо Феникса (Ур 8)",4,nil,1)
	mk("MUSHA_EGG_CRACKED8","Яйцо Феникса",4,nil,1)
	rec.MUSHA_EGG = "Яйцо Феникса(Ур 1)"
	rec.MUSHA_EGGS1 = "Яйцо Феникса(Ур 2)"
	rec.MUSHA_EGGS2 = "Яйцо Феникса(Ур 3)"
	rec.MUSHA_EGGS3 = "Яйцо Феникса(Ур 4)"
	rec.MUSHA_EGG1 = "Яйцо Феникса(Ур 5)"
	rec.MUSHA_EGG2 = "Яйцо Феникса(Ур 6)"
	rec.MUSHA_EGG3 = "Яйцо Феникса(Ур 7)"
	rec.MUSHA_EGG8 = "Яйцо Феникса(Ур макс.)"
	pp("Phoenix Egg","Яйцо Феникса")
	pp("Phoenix Egg(LV 2)","Яйцо Феникса (Ур 2)")
	pp("Phoenix Egg(LV 3)","Яйцо Феникса (Ур 3)")
	pp("Phoenix Egg(LV 4)","Яйцо Феникса (Ур 4)")
	pp("Phoenix Egg(LV 5)","Яйцо Феникса (Ур 5)")
	pp("Phoenix Egg(LV 6)","Яйцо Феникса (Ур 6)")
	pp("Phoenix Egg(LV 7)","Яйцо Феникса (Ур 7)")
	pp("Phoenix Egg(LV 8)","Яйцо Феникса (Ур 8)")
	pp("It is not mine. Musha said that is Yamche bud.","Это не моё. Муша сказала, что это бутон Ямчи")
	pp("What a little bird!","Какая маленькая птичка!")
	pp("It... Yes. Yamche. Yamche grows really fast.","Это... Да. Ямчи. Ямчи растёт очень быстро.")
	pp("Yamche eats anything. So glad.","Ямчи ест что угодно. Так радует.")
	pp("How useful bird it is!","Насколько же полезна эта птичка!")
	pp("Yamche is not just a bird. It is a friend to me.","Ямчи не просто птица. Он мне друг")
	pp("Yes. I agree. We are family.","Да. Я согласна. Мы семья.")
	pp("Travel with Together. It is great.","Путешествовать вместе. Это замечательно.")
	pp("Don't starve partner.","Не голодай, партнёр.")
	mk("GHOSTHOUND","Призрачная гончая",3)
	mk("GHOSTHOUND2","Призрачный щеночек",2,nil,"Призрачного щеночка")
	pp("Musha summoned a ghost.","Муша вызвала призрака")
	mk("SHADOWMUSHA","Тень Муши",3,"Мушиной Тени")-----------------???
	pp("That Shadow looks like a Musha.","Эта тень выглядит как Муша.")
	mk("TENTACLE_FROST","Морозное щупальце")
	--
	rec.REDGEM = "Алхимия камней (Cапфир->Аметист)"
	rec.BLUEGEM = "Алхимия камней (Аметист->Cапфир)"
	rec.NITRE =  "Алхимия золота (Золото->Селитра)"
	--
	mk("MUSHASWORD_BASE","Сломанный меч",1)
	rec.MUSHASWORD_BASE = "Сломанный Меч Феникса, Меняется визуально"
	mk("MUSHASWORD","Меч Феникса",1,nil,1)
	rec.MUSHASWORD = "Прокачивается, Меняется визуально"
	mk("MUSHASWORD_FROST","Ледяной Меч Феникса")
	rec.MUSHASWORD_FROST = "Прокачивается, Меняется визуально"
	--pp("It is fixable sword by elemental.","")
	--pp("It is fixable flame sword by elemental.","")
	--pp("It is fixable frost sword by elemental.","")
	mk("MUSHA_FLUTE","Флейта Муши",3)
	rec.MUSHA_FLUTE = "Исцеляющая музыка. Починка: Сияющая пыль, Лампочка"
	mk("GLOWDUST","Сияющая пыль",3,"Сияющей пыли",nil,nil,"Сияющей пылью")-----------------???
	rec.GLOWDUST = "Пыль света"
	mk("CRISTAL","Кристальная конфета",3)
	--rec.CRISTAL = "Summon=>bulb-plant,Yamche=>EGG"
	pp("Looks like a unusual crystal.","Похоже это необычный кристалл.")
	mk("EXP","Энергетическая сущность",3)
	pp("It give some exp to player.","Она даёт некоторый опыт игроку.")
	mk("EXP1000CHEAT","Читерская сущность",3)
	pp("It give tons of exp to player.","Она даёт тонну опыта игроку.")
	rec.EXP = "Энергетическая сущность. Может чинить снаряжение Муши."
	rec.EXP10 = "Добавляет 10 опыта"
	rec.EXP50 = "Добавляет 50 опыта"
	rec.EXP100 = "Добавляет 100 опыта"
	
	mk("FROSTHAMMER","Ледяной Молот",1)
	rec.FROSTHAMMER = "Прокачивается, Чинится, Молот, Холодильник"
	pp("Heavy blue hammer.","Тяжелый, синий молот")
	
	mk("BROKEN_FROSTHAMMER","Ледяная броня",3)
	rec.BROKEN_FROSTHAMMER = "Прокачивается, Чинится, Холодильник, Меняется визуально"
	pp("It got a multiple function.","У неё множество функций")
	
	mk("HAT_MPHOENIX","Шлем Феникса",1,nil,"Шлем Феникса")
	rec.HAT_MPHOENIX = "Прокачивается, Снимаемая маска (Правый клик)"
	pp("A mediaeval helm.","Средневековый шлем.")
	
	mk("HAT_MPRINCESS","Корона Принцессы Пёсиков",3)
	rec.HAT_MPRINCESS = "Щит, Регенерация рассудка, Меняется визуально"
	pp("A golden little crown.","Маленькая, золотая корона.")
	
	mk("HAT_MCROWN","Корона Королевы Пёсиков",3)
	rec.HAT_MCROWN = "Щит, Регенерация рассудка, Специальная опция"
	pp("Looks so nice.","Так замечательно выглядит.")
	
	mk("HAT_MBUNNY","Шапка Заячьего Скаута",3,nil,"Шапку Заячьего Скаута")
	rec.HAT_MBUNNY = "Прокачивается, Снимаемые очки (Правый клик)"
	pp("Looks like a bunny ears.","Смотрится как заячьи ушки")
	
	mk("ARMOR_MUSHAA","Броня Муши",3)
	rec.ARMOR_MUSHAA = "Прокачивается, имеет рюкзак"
	pp("It is a billow dress.","Это парадное платье.")
	
	mk("ARMOR_MUSHAB","Броня Принцессы",3)
	rec.ARMOR_MUSHAB = "Прокачивается, имеет рюкзак"
	pp("It is billow, but safe." ,"Она парадная, но надёжная.")
	
	--[[STRINGS.PHOENIXS=
{    --random
"Captain Yamche","Hulk Yamche","Iron Yamche","Torr Yamche","Yamche","Brave Yamche","Cutie Yamche","Owl Yamche","Sunny Yamche","Moon Yamche","Seoul Yamche","Suri Yamche","Vilja Yamche","Sunny Yamche","Sunnyholic","Musha Yamche","Mellisa Yamche","Lidia Yamche ","Battleborn Yamche ","Grey Yamche","Sky Yamche","Lucia Yamche","Khajit Yamche","Pig Yamche","Mjoll Yamche","Lioness Yamche","Muiri Yamche","Ysolda Yamche","Rayya Yamche","Falkas Yamche","Vilkas Yamche","Aela Yamche","Huter Yamche","Huntress Yamche","Queen Yamche","Fire Yamche","Cicero Yamche","Top Yamche","Lina Yamche","Totoro Yamche","Yu-na Yamche","Winter Yamche","White Yamche","Mellisa Yamche","Riften Yamche","Dawnstar Yamche","Windhelm Yamche","Pho Yamche","Sneaky Yamche","Kiwis Yamche","Coco Yamche","Moon Yamche","Pizza Yamche","Sugar Yamche","Orc Yamche","Elf Yamche","Knight Yamche","Lich Yamche","Azeroth Yamche","Tauren Yamche","Troll Yamche","Thrall Yamche","Narugar Yamche","Yancook Yamche","Tirano Yamche","Honey Yamche","Isis Yamche","Bosom Yamche","Esmeralda Yamche","Pluvia Yamche","Doraemon Yamche","Dooly Yamche","Apple Yamche","IU Yamche","Gandalf Yamche","Frodo Yamche","Sam Yamche","Regolas Yamche","Gimli Yamche","Boromir Yamche","Wilxon Yamche","Willo Yamche","Wolfkong Yamche","Wenil Yamche","WX79 Yamche","Wickerbi Yamche","Woorie Yamche","Wex Yamche","Maximus Yamche","Wigfreedom Yamche","Webbers Yamche","Naruto Yamche","Sasuke Yamche","Withcer",
 }]]
	--
end