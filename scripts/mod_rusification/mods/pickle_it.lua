local t = mods.RussianLanguagePack
local mk = t.RegisterRussianName
s = _G.STRINGS
STRINGS = s
nm,ch,ch_nm,rec,gendesc = s.NAMES,s.CHARACTERS,mk,s.RECIPE_DESC,s.CHARACTERS.GENERIC.DESCRIBE
mk_gen = function (n,v) end --заглушка пока что
slang = function()end
arr=_G.rawget(_G,"arr")or function() end

-------------------------------Pickle it
pp("If I want that potato, I'll need a shovel","Если я хочу эту картошку, то мне нужна лопата.")

ch_nm("PICKLE_SWORD","Дурацкий меч",1,"Дурацкому мечу")

mk("RADISH_SEEDS","Семена редиса",5,"Семенам редиса",1)


mk("RADISH","Редиска",3)
pp("What is small, red, and whispers?\nA hoarse radish!","Что такое маленькое, красное, и шепчет? Хрен!")
pp("This veggie is so rad(ish)","Хрен редьки не слаще.")
pp("I can pickle that!","Я могу это замариновать!")

mk("RADISH_COOKED","Печеная редиска",3)
pp("Delicious and healthy","Вкусное и здоровое питание")
pp("Sweeter and softer than a raw radish","Слаще и мягче, чем сырая редька")

mk("RADISH_PICKLED","Маринованный редис")
pp("Sweet, tangy, and pink","Сладкий, острый, и розовый")
pp("This would make a great garnish","Это мог бы быть хороший гарнир")

mk("RADISH_PLANTED","Редиска",3) --которая растёт на земле
pp("It's a little wild radish","Это маленькая дикая редиска")

mk("PIGS_FOOT_COOKED","Шкварки",5)
pp("Best eaten while watching football","Best eaten while watching football")
pp("A crunchy snack made from meat!","Хрустящая закуска, сделанная из мяса!")

mk("PIGS_FOOT_PICKLED", "Маринованная свинина", 3)
pp("Who thought this was a good idea?","Кто думал, что это была хорошая идея?")
pp("I don't think a starving raptor would even eat this","Я  думаю, даже голодный хищник не стал бы это есть.")

mk("PUMPKIN_PICKLED","Маринованная тыква",3)
pp("Peter Piper pickled a peck of pickled pumpkins... err, peppers","Какой любимый спорт у тыквы?\nСквош!") --непереводимая игра слов
pp("What's a pumpkin's favorite sport?\nSquash!","Какой любимый спорт у тыквы?\nСквош!")

mk("ONION_PLANTED","Лук")
pp("Look, a wild onion!","Смотрите! Дикий лук!")

mk("ONION_SEEDS","Семена лука",5,"Семенам лука",1)
pp("It's a seed.","Это семена.")

mk("PICKLE_BARREL","Бочонок рассола",1,"Бочонку рассола",1)
pp("Pickle your food so it lasts longer!","Маринованные продукты дольше хранятся, так ведь?")
pp("Mmm, salty goodness","Ммммм, солёная вкуснятина")
pp("Not to be confused with pickleball","Чтобы еда замариновалась, придется подождать")
pp("Serves sandwiches, right?","Сегодня подаём бутерброды, верно?")

mk("PIGS_FOOT","Свиная ножка",3)
pp("Poor Wilbur...","Жаль, что так вышло.")
pp("This little piggy isn't going to the market anymore","Этот маленький поросёнок больше не пойдёт в магазин.")

mk("MUSH_PICKLED","Солёная кашица",3)
pp("Better not eat this", "Лучше не есть это.")
pp("Pickled into oblivion, I guess", "Лёгкий путь в рай, я надеюсь.")

mk("PIGS_FOOT_DRIED","Вяленые свиные ножки",5,"Вяленым свиным ножкам",1)

mk("ONION","Лук")
pp("*Sob* Who's cutting onions?","*рыдает* Кто режет лук?")
pp("Ogres are like onions","Чудовища как луковицы.")
pp("Onions always make me cry","Из-за лука я всегда плачу горькими слезами.")
--pp("I can pickle that!","Я могу его замариновать!") --Повтор

mk("ONION_COOKED","Жареные кольца лука",5,"Жареным кольцам лука",1)
pp("If you like it, you should put an onion ring on it","Если вы это любите, то вы должны сложить кольца вместе.")
--pp("If you hear an onion ring, answer it",--игра слов. ring=кольцо и ring=звонок
pp("I guess this makes me the Lord of the Onion Rings","Я надеюсь, хоть одно сделает меня Хозяином Кольца Лука.")

mk("ONION_PICKLED","Маринованный лук")
pp("What's round, white, and giggles?\nA tickled onion!","Что такое: круглое, белое и хихикает?\nМаринованный лук!")
pp("Beautiful and zesty... yum!","Красиво и пикантно... хрум!")

mk("EGG_PICKLED","Маринованные яйца",5,"Маринованным яйцам",1)
pp("Am I supposed to actually eat this?", "А что, я должен на самом деле это съесть?")
pp("Who decided this should be edible?","Кто решил, что это должно быть съедобным?")

mk("FISH_PICKLED","Селёдка",3)
pp("Whoa, this is pungent!", "Вау, это пикантно!")
pp("Catch a pickled herring, put it in your pocket","Рыбку поймал - в карман положил.")
pp("At least it's not lutefisk","По крайней мере, это не лютефиск.")

mk("MUSHROOM_PICKLED","Маринованные грибы",5)
pp("Why did the fungi leave the party?\nThere wasn't mushroom.", "А что еще делать с этими несъедобными грибами?")
pp("Why do people like Mr. Mushroom?\nBecause he's a fungi!","А что еще делать с этими несъедобными грибами?")
--[[mk_gen("MUSHROOM_PICKLED", {   
	--"Why did the fungi leave the party?\nThere wasn't mushroom.",  --игра слов
	--"Why do people like Mr. Mushroom?\nBecause he's a fungi!", --игра слов
	"А что еще делать с этими несъедобными грибами?"
})--]]

mk("CUCUMBER_GOLDEN_PICKLED","Золотой солёный огурец")
mk("CUCUMBER_COOKED","Нарезанные огурцы",5)
pp("It'll never become a pickle now", "Теперь их не засолишь.")
pp("Tastes like grilled water", "На вкус, как обычная вода.")
pp("Poor Larry","Бедный Ларри")

mk("CUCUMBER_PICKLED","Солёный огурец")
pp("This is quite a pickle", "Уже достаточно солёный.")
--pp("Why do gherkins giggle? They're PICKLish!",--глупо. И не переводится нормально.
pp("If only I had a hamburger to put this on","Если бы у меня только был гамбургер, чтобы засунуть в него солёный огурец.")

mk("CUCUMBER_SEEDS","Семена огурца",5,"Семенам огурца",1)

mk("EGGPLANT_PICKLED","Маринованный баклажан")
pp("Lasts longer than a regular eggplant","Хранится дольше, чем обычный баклажан.")
pp("You don't steal a bitter eggplant","Никто не украдёт горький баклажан.")

mk("CABBAGE_SEEDS","Семена капусты",5,"Семенам капусты",1)

mk("CARROT_PICKLED","Маринованная морковь",3)
pp("Lasts longer than a normal carrot", "Хранится дольше, чем обычная морковь.")
pp("Some prefer carrots, while others like cabbage.","Некоторые предпочитают морковь, в то время как другие - капусту.")

mk("CORN_PICKLED","Консервированная кукуруза",3)
pp("Lasts longer than regular corn","Хранится дольше, чем обычная кукуруза")
pp("What did the corn say when he got complimented?\nAww, shucks!","Мальчик, объевшийся кукурузы, лопнул в солярии.\nНо с этой такого не случится.")--шутка, да?) окей, шутка

mk("CUCUMBER","Огурец")
--pp("Looks cumbersome... cucumbersome", --игра слов
pp("I bet this would make a fine pickle", "Бьюсь об заклад, это будет прекрасный маринад.") --стишок, однако
pp("Cool as a cucumber","Холодный, как огурец")
pp("I shall call him Larry","Я назову его Ларри")
--pp("I can pickle that!", --Повтор

mk("BEET_SEEDS","Семена свёклы",5,"Семенам свёклы",1)

mk("CABBAGE","Капуста",3)
--pp("A guy named Cabbage invented the computer... \nno wait, that was Babbage", --опять шутка, игра слов
pp("About as large and wise as a man's head","Большая и мудрая, как голова человека") --это должно быть смешно что ли?
pp("I heard that kids hang out around cabbage patches","Я слышал, что дети рождаются из кочана капусты.")
--pp("I can pickle that!", --повтор

mk("CABBAGE_COOKED","Жареная капуста",3)
pp("Crunchy and tasty", "Хрустящая и вкусная")
pp("So easy to make, just slice and cook", "Так легко приготовить, просто нарезать и прожарить.")


mk("CABBAGE_PICKLED","Кислая капуста",3)
pp("My grandpa puts sauerkraut in his chocolate cakes", "Мой дедушка кладёт квашеную капусту в шоколадные пирожные.")
pp("Try substituting sauerkraut for coconut when baking","Попробуйте заменить кокос квашеной капустой при выпечке.")
--pp("Also known as liberty cabbage",--свободная капуста? ват?

mk("BEET_PICKLED","Маринованная свёкла",3)
--pp("I hear people really like pickled beets.\nMaybe I should give them a try.",
pp("They actually look kinda tasty","Они и вправду выглядят любопытно вкусно.")

mk("BEET_PLANTED","Свёкла",3)
pp("Looks like a beet","Похоже на... свёклу.")

mk("BEET","Свёкла",3)
pp("Fact: bears eat beets. Bears, beets, Battlestar Galactica","Факт: медведи едят свёклу.") -- Медведи, свекла, Battlestar Galactica", --этот американский юмор уже надоел
pp("Nobody likes beets. Maybe I should have grown candy instead.","Никто не любит свёклу. Может быть, стоит вырастить конфеты?")
pp("Let's have a garden party.\nLettuce turnip the beet.","Внучка за бабку, бабка за дедку, дедка за репку.")--стишок, ок
--pp("I can pickle that!",--Повтор

mk("BEET_COOKED","Жареная свёкла",3)
pp("Roasted beets have a sweet earthy flavor", "Жареная свёкла имеет сладкий земляной привкус.")
pp("Sweeter than unroasted beets", "Слаще необжаренной свёклы.")

ch_nm("POTATO","Картофель",1,"Картофелю")
ch_nm("POTATO_COOKED","Печёный картофель",1,"Печёному картофелю")
ch_nm("POTATO_PLANTED","Картофель",1,"Картофелю")
ch_nm("POTATO_SEEDS","Семена картофеля",5,"Семенам картофеля",1) --Их пока что не существует.

ch_nm("WATERMELON_PICKLED","Арбузные корки",5)

--mk("BERRIES_PICKLED","Маринованные ягоды",5,"Маринованным ягодам")
ch_nm("BERRIES_PICKLED","Забродившие ягоды",5,"Забродившим ягодам")

--В связи с переименованием некоторых блюд на адаптивные русские названия нужно пропатчить систему приготовления блюд.
--Ямс = лукфель = картофель во многих случаях в некотором приближении.


--[[
--В целом это не имеет смысла, т.к. фильтруется на выделенном сервере. Правильнее написать автору мода о багах.
local cooking = _G.require("cooking")
local ingredients = cooking.ingredients
--Функция мягкого изменения значений ингредиентов без полной перезаписи. Для полной совместимости с любыми модами.
AddIngredientValues = function(names, tags, cancook, candry)
	for _,name in pairs(names) do
		if not ingredients[name] then --No breaking!
			ingredients[name] = { tags= {}}
		end
		if cancook and not ingredients[name.."_cooked"] then --No breaking!
			ingredients[name.."_cooked"] = {tags={}}
		end
		if candry and not ingredients[name.."_dried"] then --No breaking!
			ingredients[name.."_dried"] = {tags={}}
		end
		for k,v in pairs(tags) do
			ingredients[name].tags[k] = v
			if cancook then
				ingredients[name.."_cooked"].tags.precook = 1
				ingredients[name.."_cooked"].tags[k] = v
			end
			if candry then
				ingredients[name.."_dried"].tags.dried = 1
				ingredients[name.."_dried"].tags[k] = v
			end
		end
	end
end

--Надо бы переместить в Foodie
AddIngredientValues({"pigs_foot_dried"},{meat=0.5}) --Микроскопический фикс известного бага.
AddIngredientValues({"potato"},{veggie=1, tuber=1}) 
AddIngredientValues({"mushroom_pickled"},{veggie=0.5,fungus=1,mushrooms=1}) --compatible with waiter 101
AddIngredientValues({"fish_pickled"},{meat=.5,fish=1,seafood=1}) --compatible with waiter 101
AddIngredientValues({"corn_pickled","pumpkin_pickled"},{veggie=0.5,starch=1})
--]]

---------------- Дополниение от Hawaiian ----------------
-------------------------------------------------------------------------------------Pickle it

--pickleit_strings.lua

STRINGS.NAMES.PICKLE = "Мариновать"

-- Pickle Barrel

STRINGS.NAMES.PICKLE_BARREL = "Pickle Barrel"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.PICKLE_BARREL_PICKLING = {	
	"Теперь нужно подождать", 
	"Мариновка займет какое-то время", 
	"Скорее я сам замаринуюсь, чем будет готово",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PICKLE_BARREL_GENERIC = {	
	"Pickle your food so it lasts longer!", 
	"Mmm, salty goodness", 
	"Not to be confused with pickleball",
	"Serves sandwiches, right?",
}

STRINGS.CHARACTERS.GENERIC.DESCRIBE.PICKLE_BARREL = STRINGS.CHARACTERS.GENERIC.DESCRIBE.PICKLE_BARREL_GENERIC

STRINGS.RECIPE_DESC.PICKLE_BARREL = "Маринованная еда хранится дольше!"

-- Pickle Sword

STRINGS.NAMES.PICKLE_SWORD = "Pickle Sword"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.PICKLE_SWORD = {
	"Сразись со мной на огурцах!",
	"Мой огурец больше твоего!",
	"Огуречный сюрприз!",
}

STRINGS.RECIPE_DESC.PICKLE_SWORD = "Сражайтесь солёным огурцом!"

-- Beet

STRINGS.NAMES.BEET = "Beet"
STRINGS.NAMES.BEET_COOKED = "Roasted Beet"
STRINGS.NAMES.BEET_SEEDS = "Beet Seeds"
STRINGS.NAMES.BEET_PICKLED = "Pickled Beet"
STRINGS.NAMES.BEET_PLANTED = "Beet"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET = {	
	"Fact: bears eat beets. Bears, beets, Battlestar Galactica",
	"Nobody likes beets. Maybe I should have grown candy instead.",
	"Let's have a garden party.\nLettuce turnip the beet.",
	"I can pickle that!",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_COOKED = {	
	"Roasted beets have a sweet earthy flavor", 
	"Sweeter than unroasted beets", 
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_SEEDS = {	
	"It's a seed.", 
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_PICKLED = {	
	"Может, стоит попробовать?.", 
	"They actually look kinda tasty",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEET_PLANTED = {	
	"Looks like a beet",
}

-- Berries

STRINGS.NAMES.BERRIES_PICKLED = "Pickled Berries"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BERRIES_PICKLED = {
	"Маринованные ягоды со щепоткой специй",
	"С сыром будет вкусно",
}STRINGS.CHARACTERS.GENERIC.DESCRIBE.POTATO = {	
	"Уничтожу, раскромсаю, раздавлю...в пюре!",
	"Каррррр! Тофель!",
	"У чего есть глазки но нет зрения?\nУ картошки!",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POTATO_COOKED = {	
	"Просто, быстро и вкусно!", 
	"Ароматный жареный картофель", 
}
	
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PIGS_FOOT_DRIED = {	
	"Вкусные вяленые свиные ножки...",
}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATERMELON_PICKLED = {
	"Кто придумал мариновать арбузные корки?",
	"Хорошо сочетается с сырными крэкерами",
}





