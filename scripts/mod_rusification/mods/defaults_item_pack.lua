local t = mods.RussianLanguagePack
local mk = t.RegisterRussianName
s = _G.STRINGS
STRINGS = s
nm,ch,ch_nm,rec,gendesc = s.NAMES,s.CHARACTERS,mk,s.RECIPE_DESC,s.CHARACTERS.GENERIC.DESCRIBE
mk_gen = function (n,v) end --заглушка пока что
slang = function()end
arr=_G.rawget(_G,"arr")or function() end


mk("CACTUSMACE","Кактусовая бита",3,0,"Кактусовую биту",false,"Кактусовой битой")
mk("DARK_AXE","Тёмный топор",1,0,"Тёмный топор",false,"Тёмным топором")
mk("DARK_PICKAXE","Тёмная кирка",3,0,"Тёмную кирку",false,"Тёмной киркой")
mk("EWECUSHAT","Рыцарский шлем",1,0,"Рыцарский шлем",false,"Рыцарским шлемом")
mk("FLYSWATTER","Мухобойка",3,0,"Мухобойку",false,"Мухобойкой")
mk("FRYINGPAN","Сковородка",3,0,"Сковородку",false,"Сковородкой")
mk("GROWTHSTAFF","Посох роста",1,0,"Посох роста",false,"Посохом роста")
mk("HOLLOWHAT","Треснувший череп",1,0,"Треснувший череп",false,"Треснувшим черепом")
mk("LIGHTNECKLACE","Светящееся ожерелье",4,0,"Светящееся ожерелье",false,"Светящимся ожерельем")
mk("SPARTAHELMUT","Золотой шлем",1,0,"Золотой шлем",false,"Золотым шлемом")
mk("SPARTASWURD","Острый меч",1,0,"Острый меч",false,"Острым мечом")
mk("SUMMERBANDANA","Летняя бандана",3,0,"Летнюю бандану",false,"Летней банданой")
mk("WOODENMACE","Деревянная булава",3,0,"Деревянную булаву",false,"Деревянной булавой")
mk("ARMORMOSQUITO","Комариный костюм",1,0,"Комариный костюм",false,"Комариным костюмом")
mk("BARONSUIT","Костюм барона",1,0,"Костюм барона",false,"Костюмом барона")
mk("BIRCHNUTHAT","Шипастый шлем",1,0,"Шипастый шлем",false,"Шипастым шлемом")
	

--В MODMAIN.LUA МОДА:


rec.CACTUSMACE = "Так им достанется еще больше."
pp(ch.GENERIC.DESCRIBE.CACTUSMACE, "Колючая бита.")
pp(ch.WILLOW.DESCRIBE.CACTUSMACE, "Ауч! Я укололась.")
pp(ch.WOLFGANG.DESCRIBE.CACTUSMACE, "На ней острые шипы.")
pp(ch.WENDY.DESCRIBE.CACTUSMACE, "Не задеть бы себя.")
pp(ch.WX78.DESCRIBE.CACTUSMACE, "МОЖЕТ НАНОСИТЬ УРОН МОИМ ВРАГАМ И МНЕ")
pp(ch.WICKERBOTTOM.DESCRIBE.CACTUSMACE, "Кактус покрыт острыми иглами.")
pp(ch.WOODIE.DESCRIBE.CACTUSMACE, "Выглядит опасно.")
pp(ch.WAXWELL.DESCRIBE.CACTUSMACE, "Это будет больно.")
pp(ch.WATHGRITHR.DESCRIBE.CACTUSMACE, "Что тебя не убивает - делает тебя сильнее!")
pp(ch.WEBBER.DESCRIBE.CACTUSMACE, "Уф, страшная штуковина.")

rec.DARK_AXE="Кошмарно рубит деревья."
pp(ch.GENERIC.DESCRIBE.DARK_AXE, "Страшный топор.")
pp(ch.WILLOW.DESCRIBE.DARK_AXE, "Мои кошмары помогут мне рубить деревья!")
pp(ch.WOLFGANG.DESCRIBE.DARK_AXE, "Таинственный призрачный топор.")
pp(ch.WENDY.DESCRIBE.DARK_AXE, "Ночной кошмар для каждого дерева.")
pp(ch.WX78.DESCRIBE.DARK_AXE, "НЕОПОЗНАННЫЙ ТОПОР")
pp(ch.WICKERBOTTOM.DESCRIBE.DARK_AXE, "Эктоплазма наделяет этот инструмент прозрачностью.")
pp(ch.WOODIE.DESCRIBE.DARK_AXE, "Холодный и резкий. Прямо, как люди в наше время, а?")
pp(ch.WAXWELL.DESCRIBE.DARK_AXE, "Это мой верный топор.")
pp(ch.WATHGRITHR.DESCRIBE.DARK_AXE, "Рубить с отвагой!")
pp(ch.WEBBER.DESCRIBE.DARK_AXE, "Рубить! Клац-клац.")

rec.DARK_PICKAXE="Кошмарный инструмент."
pp(ch.GENERIC.DESCRIBE.DARK_PICKAXE, "Страшная кирка.")
pp(ch.WILLOW.DESCRIBE.DARK_PICKAXE, "Мои кошмары разрушат скалы!")
pp(ch.WOLFGANG.DESCRIBE.DARK_PICKAXE, "ТАинственная призрачная кирка.")
pp(ch.WENDY.DESCRIBE.DARK_PICKAXE, "Кошмарный инструмент для добычи руды.")
pp(ch.WX78.DESCRIBE.DARK_PICKAXE, "НЕОПОЗНАННЫЙ ГОРНОДОБЫВАЮЩИЙ ИНСТРУМЕНТ")
pp(ch.WICKERBOTTOM.DESCRIBE.DARK_PICKAXE, "Эктоплазма наделяет этот инструмент прозрачностью.")
pp(ch.WOODIE.DESCRIBE.DARK_PICKAXE, "Холодная и резкая. Прямо, как люди в наше время, а?")
pp(ch.WAXWELL.DESCRIBE.DARK_PICKAXE, "Упрощает добычу руды.")
pp(ch.WATHGRITHR.DESCRIBE.DARK_PICKAXE, "Добывать руду с отвагой!")
pp(ch.WEBBER.DESCRIBE.DARK_PICKAXE, "Она полупрозрачная, но очень прочная.")

rec.EWECUSHAT= "Сделан из стали."
pp(ch.GENERIC.DESCRIBE.EWECUSHAT, "Прочный шлем.")
pp(ch.WILLOW.DESCRIBE.EWECUSHAT, "При большом огне он все равно расплавится.")
pp(ch.WOLFGANG.DESCRIBE.EWECUSHAT, "Мощный шлем для силачей.")
pp(ch.WENDY.DESCRIBE.EWECUSHAT, "Он защитит мое хрупкое тело.")
pp(ch.WX78.DESCRIBE.EWECUSHAT, "ГОЛОВНОЙ УБОР ИЗ МЕТАЛЛА")
pp(ch.WICKERBOTTOM.DESCRIBE.EWECUSHAT, "Прочный шлем.")
pp(ch.WOODIE.DESCRIBE.EWECUSHAT, "Неплохой шлем.")
pp(ch.WAXWELL.DESCRIBE.EWECUSHAT, "Выглядит неплохо, и защищает также.")
pp(ch.WATHGRITHR.DESCRIBE.EWECUSHAT, "Шлем для настоящего воина.")
pp(ch.WEBBER.DESCRIBE.EWECUSHAT, "Теперь нужен только меч.")

rec.FLYSWATTER="Прихлопнем этих насекомых!"
pp(ch.GENERIC.DESCRIBE.FLYSWATTER, "Прекрасно убивает мелких букашек.")
pp(ch.WILLOW.DESCRIBE.FLYSWATTER, "Хорошо убивает надоедливых букашек.")
pp(ch.WOLFGANG.DESCRIBE.FLYSWATTER, "Для убийства насекомых.")
pp(ch.WENDY.DESCRIBE.FLYSWATTER, "Прерывает жизни букашек быстрее.")
pp(ch.WX78.DESCRIBE.FLYSWATTER, "УСТРОЙСТВО ДЛЯ УНИЧТОЖЕНИЯ НАСЕКОМЫХ")
pp(ch.WICKERBOTTOM.DESCRIBE.FLYSWATTER, "Разработана специально для уничтожения мелких насекомых.")
pp(ch.WOODIE.DESCRIBE.FLYSWATTER, "Пригодится.")
pp(ch.WAXWELL.DESCRIBE.FLYSWATTER, "Удобно.")
pp(ch.WATHGRITHR.DESCRIBE.FLYSWATTER, "Оружие для славного боя с букашками!")
pp(ch.WEBBER.DESCRIBE.FLYSWATTER, "Наша паутина будет получше, но и это сойдет.")

rec.FRYINGPAN="Зададим им жару."
pp(ch.GENERIC.DESCRIBE.FRYINGPAN, "Довольно тяжелая.")
pp(ch.WILLOW.DESCRIBE.FRYINGPAN, "Я расплавлю их лица.")
pp(ch.WOLFGANG.DESCRIBE.FRYINGPAN, "Хорошо жарит, и еще лучше бьет.")
pp(ch.WENDY.DESCRIBE.FRYINGPAN, "Смерть от кухонной посуды, как иронично.")
pp(ch.WX78.DESCRIBE.FRYINGPAN, "СДЕЛАНА ИЗ МЕТАЛЛА, КАК И Я")
pp(ch.WICKERBOTTOM.DESCRIBE.FRYINGPAN, "Стальная сковорода для жарки.")
pp(ch.WOODIE.DESCRIBE.FRYINGPAN, "Теперь поджарим пару голов!")
pp(ch.WAXWELL.DESCRIBE.FRYINGPAN, "Ну, чтобы убивать врагов, мне подойдет любое оружие.")
pp(ch.WATHGRITHR.DESCRIBE.FRYINGPAN, "Из набора кухонного воина!")
pp(ch.WEBBER.DESCRIBE.FRYINGPAN, "Нам нравится ее звук.")

rec.GROWTHSTAFF="Быстрый рост!"
pp(ch.GENERIC.DESCRIBE.GROWTHSTAFF, "Он излучает энергию.")
pp(ch.WILLOW.DESCRIBE.GROWTHSTAFF, "Красиво выглядит.")
pp(ch.WOLFGANG.DESCRIBE.GROWTHSTAFF, "Вольфганг чувствует, как растут мышцы.")
pp(ch.WENDY.DESCRIBE.GROWTHSTAFF, "Помогает растениям быстрее умереть.")
pp(ch.WX78.DESCRIBE.GROWTHSTAFF, "ОРУДИЕ ДЛЯ УСКОРЕНИЯ РАЗВИТИЯ")
pp(ch.WICKERBOTTOM.DESCRIBE.GROWTHSTAFF, "По всей видимости, ускоряет рост ближайших растений.")
pp(ch.WOODIE.DESCRIBE.GROWTHSTAFF, "Я сделаю деревья больше.")
pp(ch.WAXWELL.DESCRIBE.GROWTHSTAFF, "Эта мясистая луковица хорошо служит цели.")
pp(ch.WATHGRITHR.DESCRIBE.GROWTHSTAFF, "Властвует над ростом растений.")
pp(ch.WEBBER.DESCRIBE.GROWTHSTAFF, "Выглядит очень дико.")

rec.HOLLOWHAT="Владелец становится невероятно быстрым."
pp(ch.GENERIC.DESCRIBE.HOLLOWHAT, "Жуткий череп.")
pp(ch.WILLOW.DESCRIBE.HOLLOWHAT, "Из него выйдет чудесная пепельница.")
pp(ch.WOLFGANG.DESCRIBE.HOLLOWHAT, "Череп на замену черепу Вольфганга.")
pp(ch.WENDY.DESCRIBE.HOLLOWHAT, "Кому-то он уже не пригодится.")
pp(ch.WX78.DESCRIBE.HOLLOWHAT, "ЧЕРЕП, УВЕЛИЧИВАЮЩИЙ СКОРОСТЬ ПЕРЕДВИЖЕНЯ")
pp(ch.WICKERBOTTOM.DESCRIBE.HOLLOWHAT, "Какое варварство.")
pp(ch.WOODIE.DESCRIBE.HOLLOWHAT, "Буэ, это чей-то череп.")
pp(ch.WAXWELL.DESCRIBE.HOLLOWHAT, "Он излучает темную энергию.")
pp(ch.WATHGRITHR.DESCRIBE.HOLLOWHAT, "Останки славного воина.")
pp(ch.WEBBER.DESCRIBE.HOLLOWHAT, "В этом шаре пусто!")

rec.LIGHTNECKLACE="Освещает путь."
pp(ch.GENERIC.DESCRIBE.LIGHTNECKLACE, "Его свечение может пригодиться.")
pp(ch.WILLOW.DESCRIBE.LIGHTNECKLACE, "В нем нет огня, но оно горит!")
pp(ch.WOLFGANG.DESCRIBE.LIGHTNECKLACE, "Ювелирная безделушка.")
pp(ch.WENDY.DESCRIBE.LIGHTNECKLACE, "И несколько цветов в локоны волос.")
pp(ch.WX78.DESCRIBE.LIGHTNECKLACE, "ОНО БЫСТРО ТУСКНЕЕТ")
pp(ch.WICKERBOTTOM.DESCRIBE.LIGHTNECKLACE, "Светящиеся лампочки, скрепленные вместе.")
pp(ch.WOODIE.DESCRIBE.LIGHTNECKLACE, "Женщинам бы понравилось.")
pp(ch.WAXWELL.DESCRIBE.LIGHTNECKLACE, "Какое-то украшение. Я становлюсь все элегантнее.")
pp(ch.WATHGRITHR.DESCRIBE.LIGHTNECKLACE, "Подходит женщинам, но не воинам!")
pp(ch.WEBBER.DESCRIBE.LIGHTNECKLACE, "Соответствует своему названию.")

rec.SPARTAHELMUT="Дорогой шлем."
pp(ch.GENERIC.DESCRIBE.SPARTAHELMUT, "Какой-то древний дизайн.")
pp(ch.WILLOW.DESCRIBE.SPARTAHELMUT, "Эта штука ярко красная и пушистая, прямо как огонь!")
pp(ch.WOLFGANG.DESCRIBE.SPARTAHELMUT, "По-дурацки выглядит.")
pp(ch.WENDY.DESCRIBE.SPARTAHELMUT, "Стоит больше моей жизни.")
pp(ch.WX78.DESCRIBE.SPARTAHELMUT, "МЕТАЛЛИЧЕСКИЙ ШЛЕМ ДЛЯ ЗАЩИТЫ ГОЛОВЫ")
pp(ch.WICKERBOTTOM.DESCRIBE.SPARTAHELMUT, "Спартанский шлем из золота.")
pp(ch.WOODIE.DESCRIBE.SPARTAHELMUT, "Это точно не канадский шлем.")
pp(ch.WAXWELL.DESCRIBE.SPARTAHELMUT, "Выглядит стильно.")
pp(ch.WATHGRITHR.DESCRIBE.SPARTAHELMUT, "С рогами было бы еще круче!")
pp(ch.WEBBER.DESCRIBE.SPARTAHELMUT, "Три сотни или меньше... Мы будем бороться!")

rec.SPARTASWURD="Не поранься!"
pp(ch.GENERIC.DESCRIBE.SPARTASWURD, "Соответствует названию.")
pp(ch.WILLOW.DESCRIBE.SPARTASWURD, "Действительно большой нож!")
pp(ch.WOLFGANG.DESCRIBE.SPARTASWURD, "Крепкое лезвие. Прямо как мои бицепсы!")
pp(ch.WENDY.DESCRIBE.SPARTASWURD, "Перережу пару глоток.")
pp(ch.WX78.DESCRIBE.SPARTASWURD, "ЭТО УПРОСТИТ БОЙ")
pp(ch.WICKERBOTTOM.DESCRIBE.SPARTASWURD, "Меч в спартанском стиле.")
pp(ch.WOODIE.DESCRIBE.SPARTASWURD, "Острее, чем мой топор!")
pp(ch.WAXWELL.DESCRIBE.SPARTASWURD, "И впрямь хороший клинок.")
pp(ch.WATHGRITHR.DESCRIBE.SPARTASWURD, "Мне нравится этот меч.")
pp(ch.WEBBER.DESCRIBE.SPARTASWURD, "Мы на шаг ближе к тому, чтобы стать рыцарем!")

rec.SUMMERBANDANA= "Для жарких летних деньков."
pp(ch.GENERIC.DESCRIBE.SUMMERBANDANA, "Может немного охладить.")
pp(ch.WILLOW.DESCRIBE.SUMMERBANDANA, "Это поможет моей голове не загореться от жары.")
pp(ch.WOLFGANG.DESCRIBE.SUMMERBANDANA, "Лето не подходит для Вольфганга!")
pp(ch.WENDY.DESCRIBE.SUMMERBANDANA, "Придется носить, чтобы не присоединиться к мертвецам.")
pp(ch.WX78.DESCRIBE.SUMMERBANDANA, "СРЕДНЯЯ ЗАЩИТА ОТ ТЕПЛА")
pp(ch.WICKERBOTTOM.DESCRIBE.SUMMERBANDANA, "Шляпа сделана из листов папируса.")
pp(ch.WOODIE.DESCRIBE.SUMMERBANDANA, "Как я смотрюсь в ней? А?")
pp(ch.WAXWELL.DESCRIBE.SUMMERBANDANA, "Бумажная шляпа? Эх.")
pp(ch.WATHGRITHR.DESCRIBE.SUMMERBANDANA, "Броня от солнца!")
pp(ch.WEBBER.DESCRIBE.SUMMERBANDANA, "Мы похожи на пирата!")

rec.WOODENMACE= "Снесем им головы."
pp(ch.GENERIC.DESCRIBE.WOODENMACE, "Бита, сделанная из дерева.")
pp(ch.WILLOW.DESCRIBE.WOODENMACE, "Хороша для боя и для костра.")
pp(ch.WOLFGANG.DESCRIBE.WOODENMACE, "Разве дерево достаточно прочно для рук Вольфганга?")
pp(ch.WENDY.DESCRIBE.WOODENMACE, "Инструмент насилия.")
pp(ch.WX78.DESCRIBE.WOODENMACE, "Я СДЕЛАЛ ДЕРЕВО БОЛЕЕ ПОЛЕЗНЫМ")
pp(ch.WICKERBOTTOM.DESCRIBE.WOODENMACE, "Булава, сделанная из бревна.")
pp(ch.WOODIE.DESCRIBE.WOODENMACE, "Мне нравится.")
pp(ch.WAXWELL.DESCRIBE.WOODENMACE, "Деревянная бита.")
pp(ch.WATHGRITHR.DESCRIBE.WOODENMACE, "Кусок дерева, готовый к битве.")
pp(ch.WEBBER.DESCRIBE.WOODENMACE, "С этой штуковиной мы можем сыграть в бейсбол!")

rec.ARMORMOSQUITO= "Восстановит ваше здоровье...кровью."
pp(ch.GENERIC.DESCRIBE.ARMORMOSQUITO, "Пахнет кровью.")
pp(ch.WILLOW.DESCRIBE.ARMORMOSQUITO, "Хорошо, что к нему не прилагается уродливого шлема.")
pp(ch.WOLFGANG.DESCRIBE.ARMORMOSQUITO, "Комариная броня.")
pp(ch.WENDY.DESCRIBE.ARMORMOSQUITO, "Кроваво и омерзительно.")
pp(ch.WX78.DESCRIBE.ARMORMOSQUITO, "ХОРОШЕЕ ИСПОЛЬЗОВАНИЕ КРАСНОЙ ТЕЛЕСНОЙ ЖИДКОСТИ")
pp(ch.WICKERBOTTOM.DESCRIBE.ARMORMOSQUITO, "Доспехи из комаров.")
pp(ch.WOODIE.DESCRIBE.ARMORMOSQUITO, "Наполнены кровью.")
pp(ch.WAXWELL.DESCRIBE.ARMORMOSQUITO, "Наконец-то эти кровопийцы пригодились.")
pp(ch.WATHGRITHR.DESCRIBE.ARMORMOSQUITO, "Видала доспехи и похуже.")
pp(ch.WEBBER.DESCRIBE.ARMORMOSQUITO, "Мы похожи на комара в ней?")

rec.BARONSUIT= "Очень чудной."
pp(ch.GENERIC.DESCRIBE.BARONSUIT, "Ну прямо костюм современного генерал-майора.")
pp(ch.WILLOW.DESCRIBE.BARONSUIT, "Красиво смотрится.")
pp(ch.WOLFGANG.DESCRIBE.BARONSUIT, "Нарядная мужская одежда.")
pp(ch.WENDY.DESCRIBE.BARONSUIT, "Наверное, чтобы носить такой нужно какое-нибудь посвящение.")
pp(ch.WX78.DESCRIBE.BARONSUIT, "Я ЕДИНСТВЕННЫЙ ЗАСЛУЖИВАЮ ЭТО НОСИТЬ")
pp(ch.WICKERBOTTOM.DESCRIBE.BARONSUIT, "Мягкий, фиолетовый костюм с нагрудником.")
pp(ch.WOODIE.DESCRIBE.BARONSUIT, "Красиво выглядит.")
pp(ch.WAXWELL.DESCRIBE.BARONSUIT, "Выглядит достойно.")
pp(ch.WATHGRITHR.DESCRIBE.BARONSUIT, "Латы предводителя.")
pp(ch.WEBBER.DESCRIBE.BARONSUIT, "С этим нагрудником мы не испачкаемся во время еды.")

rec.BIRCHNUTHAT= "Колючий. Очень."
pp(ch.GENERIC.DESCRIBE.BIRCHNUTHAT, "Ауч, осторожнее с шипами!")
pp(ch.WILLOW.DESCRIBE.BIRCHNUTHAT, "Остроконечный шлем.")
pp(ch.WOLFGANG.DESCRIBE.BIRCHNUTHAT, "Головные шипы!")
pp(ch.WENDY.DESCRIBE.BIRCHNUTHAT, "Внутри без шипов.")
pp(ch.WX78.DESCRIBE.BIRCHNUTHAT, "Я УНИЧТОЖИЛ МНОЖЕСТВО РАСТЕНИЙ РАДИ НЕГО")
pp(ch.WICKERBOTTOM.DESCRIBE.BIRCHNUTHAT, "Шипы нанесут урон любому, кто решит ударить.")
pp(ch.WOODIE.DESCRIBE.BIRCHNUTHAT, "Сделан из семян деревьев!")
pp(ch.WAXWELL.DESCRIBE.BIRCHNUTHAT, "Этот шлем будет сражаться за меня.")
pp(ch.WATHGRITHR.DESCRIBE.BIRCHNUTHAT, "Колючая броня для воинов!")
pp(ch.WEBBER.DESCRIBE.BIRCHNUTHAT, "Везде колючки!")

------------------------------------------------------------------ВСЁ