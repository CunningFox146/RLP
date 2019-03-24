local mk = t.RegisterRussianName

mk("BOW","Деревянный лук")
rec.BOW = "Полезно, если вы умеете целиться."
pp("I used to be a good archer... then I took an arrow in the knee.","Раньше я был хорошим лучником...")

mk("QUIVER","Колчан")
rec.QUIVER = "Храни здесь свои стрелы!"
pp("With this stuff, I will look like a serious archer.","С этой штукой я буду смотреться, как серьезный лучник.")

mk("ARROW","Простая стрела",3,0,0,nil,"Простой стрелой")
rec.ARROW = "Не бросай её голыми руками."
pp("Probably best used with a bow...","Наверное, лучше использовать с луком...")

mk("GOLDARROW","Золотая стрела",3)
rec.GOLDARROW = "Охота со стилем."
pp("I'm sure I could have found a better use this...","Уверен, с этой стрелой выйдет больше толка...")

mk("MOONSTONEARROW","Лунная стрела",3)
rec.MOONSTONEARROW = "Дорогая, но эффективная."
pp("Sharp and shiny!","Острая и сверкающая!") --Осторожно! Общая фраза!..

mk("FIREARROW","Огненная стрела",3)
rec.FIREARROW = "Лучше быть осторожным с этим."
pp("I should probably avoid using it in the middle of my camp...","Мне не следует использовать её в центре моей базы...")

mk("ICEARROW","Ледяная стрела",3)
rec.ICEARROW = "Оставайся холодной."
pp("Should I keep it in the fridge?","Следует ли мне хранить её в холодильнике?")

mk("THUNDERARROW","Громовая стрела",3) --jj: Надо уточнить рецепт...
rec.THUNDERARROW = "Шторм приближается."
pp( "The red wire on the plus...","Красный провод на плюс ...")
mk("DISCHARGEDTHUNDERARROW","Разряженная громовая стрела",3)
pp("It looks like it is not active anymore.","Похоже, что она больще не активна.")

mk("CROSSBOW","Арбалет")
rec.CROSSBOW = "Тяжелый и мощный."
pp("This stuff is bigger than me.","Эта штука больше, чем я.") --!!! Общая фраза.

mk("BOLT","Простой болт")
rec.BOLT = "Не зубочистка."
pp("Small projectile for such a big weapon...","Такой маленький снаряд для такого большого оружия...")

mk("POISONBOLT","Ядовитый болт")
rec.POISONBOLT = "С мышьяком."
pp("Did it have to be so ugly?","Разве это должно быть так некрасиво?")

mk("EXPLOSIVEBOLT","Разрывной болт")
rec.EXPLOSIVEBOLT = "Не используйте в упор."
pp("Is it really a good idea?","Действительно ли это хорошая идея?")

mk("MAGICBOW","Магический лук")
rec.MAGICBOW = "Так же, как и в сказках."
pp("I expect a rainbow farting unicorns anytime soon.","Надеюсь на единорогов, пукающих радугой, в скором времени.")

mk("MUSKET","Мушкет")
rec.MUSKET = "Это громко. Вы предупреждены."
pp("Am I the fifth musketeer?","Я - пятый мушкетер?")

mk("MUSKET_BULLET","Мушкетный патрон")
rec.MUSKET_BULLET = "Пора на охоту."
pp("It looks like marbles","Это похоже на мрамор")

mk("Z_FIREFLIESBALL","Шар светлячков")
rec.Z_FIREFLIESBALL = "Не съедобно"
pp("It's probably useful for something. Don't ask me what.","Возможно, это полезно для чего-то.\nНе спрашивайте меня, для чего.")

mk("Z_BLUEGOOP","Синее вещество",4)
rec.Z_BLUEGOOP = "Не стреляйте в ваших противников."
pp("It looks gross.","Это сильно раздуто.") --jj. брутто валовой грубый большой крупный плотный макроскопический толстый грязный вульгарный

------------------ Дополнение от Hawaiian ----------------

--добавляет recipenew tab archery (Стрельба), но я потерял, где эта строчка
STRINGS.TABS["Archery"] = "Стрельба"

pp("I should first get a quiver!", "Для начала мне нужен колчан!")
pp("My quiver is empty!", "Мой колчан пуст!")
pp("This won't fit it my current weapon...","Эти боеприпасы не подойдут...")
pp("It's too late now...","Слишком поздно...")
pp("There's no potential target on sight.","Здесь не во что стрелять.")
pp("It looks like this stuff ran out of juice.","Кажется, у нас протечка.")

--5 повторов

--далее
pp("I do not have anything to put in...", "Кажется, закончились боеприпасы...")
pp("If I pull even more on this stuff it will break...","Боеприпасов итак полно...")
pp("It is probably not a good idea to pile it up...","Возможно, это не лучшая идея, итак полно...")

--еще 5+5+3 = 13 повторов

-----------------------------ВСЁ
