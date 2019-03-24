local mk = t.RegisterRussianName
-------------------------------------------------Deluxe Campfires 2.11
--https://steamcommunity.com/sharedfiles/filedetails/?id=444235588
mk("DELUXE_FIREPIT","Роскошный костёр",1,"Роскошному костру",1,false)
mk("ENDO_FIREPIT", "Роскошный эндотермический костёр",1,"Роскошному эндотермическому костру", 1,false)
mk("HEAT_STAR","Звезда Гефеста",3,"Звезде Гефеста","Звезду Гефеста",false)
mk("ICE_STAR","Звезда Борея",3,"Звезде Борея","Звезду Борея",false)

--MODMAIN LUA

--Deluxe Firepit dialog
		STRINGS.RECIPE_DESC.DELUXE_FIREPIT = "Вау! Весьма неплохой костёр!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Почему-то он радует, даже когда потух.",
					EMBERS = "Топлива едва хватает.",
					LOW = "Идеально для барбекю.",
					NORMAL = "Осталось заиметь стены и крышу над головой...",
					HIGH = "Осторожно! Можно просто глазеть, и всё равно получить ожоги.",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "МНЕ НУЖНО ПЕРЕЗАГРУЗИТЬ ЕГО!",
		            EMBERS = "ОН ПОЧТИ ПОТУХ!",
		            LOW = "ДОСТАТОЧНО",
		            NORMAL = "ИДЕАЛЬНО ДЛЯ ЗИМНЕГО ВРЕМЕНИ ГОДА",
		            HIGH = "ПРЕДУПРЕЖДЕНИЕ: ТЕПЛО ВЫШЕ НОРМЫ",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Всему капут!",
					EMBERS = "Ему почти каюк!",
					LOW = "Идеально, чтобы готовить мясо.",
					NORMAL = "Могучий огонь.",
					HIGH = "Огонь невероятно сильный! Лучше мне отойти!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Эх, скука...",
					EMBERS = "Огонь такой же скучный, как моя жизнь.",
					LOW = "Потянет.",
					NORMAL = "Пламя выглядит неплохо... но чем больше - тем лучше!",
					HIGH = "АХАХАХАХА! Идеально!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Выглядит всё равно красиво.",
					EMBERS = "Может, стоит раздуть пламя?.",
					LOW = "Хорошо послужит моей цели.",
					NORMAL = "Идеально... для зимы!!",
					HIGH = "Такое пламя подойдёт разве что дл¤ пироманов!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Одна зола.",
					EMBERS = "Что угодно, только не книги...",
					LOW = "У такого костра можно и почитать.",
					NORMAL = "Согреет даже снежного человека.",
					HIGH = "Я думаю, я слишком перестаралась!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Холодные и чёрные угольки, как моё сердце.",
					EMBERS = "Выживут только самые живучие угольки.",
					LOW = "Не очень большое пламя",
					NORMAL = "Наверное, сойдёт.",
					HIGH = "Горячее только в аду!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Люси, кажется нам стоит нарубить дров.",
					EMBERS = "Люси, кажется он скоро потухнет...",
					LOW = "Если подойти поближе, то станет немного теплее",
					NORMAL = "Теперь это похоже на камин, который у меня дома.",
					HIGH = "Люси, держись от огня подальше... выглядит опасно!",
				}

		--if GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then 

			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DELUXE_FIREPIT  =
					{
						OUT = "Совсем потух!.",
						EMBERS = "Жалкие угольки!",
						LOW = "И так сойдёт!",
						NORMAL = "Такой огонь согреет воина!",
						HIGH = "Такой огонь слишком сильный даже для воина!!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.DELUXE_FIREPIT  =
					{
						OUT = "Всё пропало! Пропало!",
						EMBERS = "Искры над пеплом.",
						LOW = "Такой сойдёт.",
						NORMAL = "Теперь это то, что нам нужно.",
						HIGH = "Нам кажется, лучше отойти.",
					}
					
					-- ENDO Firepit dialog
		GLOBAL.STRINGS.NAMES.ENDO_FIREPIT = "Deluxe Endothermic Fire"
		STRINGS.RECIPE_DESC.ENDO_FIREPIT = "Чудесно! Холодно и светло!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Идеально для лета!",
					EMBERS = "Едва охлаждает.",
					LOW = "Почти не охлаждает... можно сделать лучше!",
					NORMAL = "Синее пламя выглядит завораживающе...",
					HIGH = "Лучше отойти подальше - можно получить обморожение!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "ТРЕБУЕТСЯ ПЕРЕЗАПУСК!",
					EMBERS = "ТЕМПЕРАТУРА ПОВЫШАЕТСЯ! ОН ПОТУХАЕТ!",
					LOW = "ОХЛАЖДЕНИЕ В ПРЕДЕЛАХ НОРМЫ",
					NORMAL = "ИДЕАЛЬНО ДЛЯ ЛЕТНЕГО ВРЕМЕНИ ГОДА",
					HIGH = "ПРЕДУПРЕЖДЕНИЕ: НЕВЕРОЯТНО НИЗКАЯ ТЕМПЕРАТУРА!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Всему капут!",
					EMBERS = "Ему почти каюк!",
					LOW = "Достаточно холодный...",
					NORMAL = "Могучее синее пламя!!",
					HIGH = "Огонь слишком сильно обжигает холодом даже Вольфганга!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Холодный? Огонь должен быть ТОЛЬКО горячим!",
					EMBERS = "Жалкие едва холодные уголёчки...",
					LOW = "Вполне сносно.",
					NORMAL = "Эти языки синего пламени выглядят красиво, и остужают меня.",
					HIGH = "АХАХАХА! ИДЕАЛЬНО! Может, даже огонь имеет право быть холодным...",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Выглядит всё равно неплохо.",
					EMBERS = "Наверное, стоит подбросить топлива",
					LOW = "Прекрасно послужит моей цели.",
					NORMAL = "Идеально... особенно летом!!",
					HIGH = "Даже мне стоит отойти подальше от этого огня!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "О холодном огне не сказано ни в одной из моей книг...",
					EMBERS = "Почти погас. Интересно, как он работает",
					LOW = "Этот холодный огонь идеально подходит для меня!",
					NORMAL = "Этот огонь прекрасен. Нужно обновить мои заметки.",
					HIGH = "Кажется, я разожгла слишком сильно!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Не впечатляет...",
					EMBERS = "Холодное синее пламя - прямо как моя душа",
					LOW = "Пока что работает",
					NORMAL = "Любая защита от солнца мне по душе",
					HIGH = "Он холоднее моего сердца!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Люси, нам нужно разжечь костёр",
					EMBERS = "Эй, Люси! Только взгляни на эти крошечные угольки...",
					LOW = "Спасет меня от солнечного удара",
					NORMAL = "Такой уровень холода идеально подойдет нам обоим...",
					HIGH = "Люси, держись подальше от этих языков пламени... Они заморозят твою душу!",
				}


			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ENDO_FIREPIT  =
					{
						OUT = "Потух!",
						EMBERS = "Этот синий огонь едва горит!",
						LOW = "И так сойдет",
						NORMAL = "Такой костёр остудит пыл воина!",
						HIGH = "Такой костёр может даже заморозить воина!!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.ENDO_FIREPIT  =
					{
						OUT = "Всё пропало! Пропало!!",
						EMBERS = "Маленькие, синие и едва прохладные угольки",
						LOW = "Для нас сойдёт.",
						NORMAL = "То, что нам нужно.",
						HIGH = "Мы думаем, лучше нам держаться подальше.",
					}
					
					--Heat Star dialog
		GLOBAL.STRINGS.NAMES.HEAT_STAR = "Звезда Гефеста"
		STRINGS.RECIPE_DESC.HEAT_STAR = "Создай своё собственное Солнце!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Выглядит великолепно, как мне перезапустить её снова?",
					EMBERS = "Всё еще не верится, что я создал звезду!  Быстрее, лучше добавить топлива!",
					LOW = "Выглядит маленькой",
					NORMAL = "Думаю, безопасно...",
					HIGH = "Будто бы Солнце.... только рядом со мной... ОЧЕНЬ ГОРЯЧАЯ!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.HEAT_STAR  =
				{
					OUT = "КРИТИЧЕСКАЯ ОШИБКА: ЗВЕЗДА ГЕФЕСТА - НЕ ОБНАРУЖЕНО;",
					EMBERS = "ОШИБКА: ОТРИЦАТЕЛЬНЫЙ КВАНТОВЫЙ ПОТОК :: НЕОБХОДИМО ВОССТАНОВЛЕНИЕ!",
					LOW = "ПРЕДУПРЕЖДЕНИЕ: ВОЛНЫ ЭНЕРГИИ МОГУТ БЫТЬ НЕСТАБИЛЬНЫМИ",
					NORMAL = "ПРЕДУПРЕЖДЕНИЕ: СТАБИЛЬНОСТЬ ГРАВИТАЦИИ НЕИЗВЕСТНА",
					HIGH = "ОПАСНОСТЬ: ПРЕВЫШЕН ЛИМИТ ТЕМПЕРАТУРЫ",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Куда всё делось?",
					EMBERS = "Требует тепла!",
					LOW = "Маленькая жалкая звезда - пфффф!!",
					NORMAL = "Невероятно!!",
					HIGH = "Не думал, что что-нибудь может быть красивее моих мускулов!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Нужно скорее вернуть ей красоту!",
					EMBERS = "Эта звезда выглядит жалко!",
					LOW = "Прекрасно выглядит, но можно разжечь СИЛЬНЕЕ!",
					NORMAL = "Лучшая вещь на свете!!",
					HIGH = "Я нашла свою любовь!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Прекрасно, как ни крути!",
					EMBERS = "Скоро потухнет!!",
					LOW = "Послужит моей цели.",
					NORMAL = "Просто чудесно!",
					HIGH = "Лучше отойти на несколько шагов. Это феноменально!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Такой звезды нет в моих книгах.",
					EMBERS = "Это почти и не звезда вовсе...",
					LOW = "Нужно задокументировать этот феномен",
					NORMAL = "Прекрасно, но выглядит грозно! Очень горячяя!",
					HIGH = "Это нарушает все законы физики!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Здесь есть пометка: 'Звезда Гефеста никогда не угаснет'. Ложь.",
					EMBERS = "Нет, не потухай!!",
					LOW = "Мне нужно заправить её, чтобы сохранить ей жизнь",
					NORMAL = "Еще один дух защитит меня и Абигейл от холода!",
					HIGH = "Хватит меня пугать, звезда! Я не боюсь твоего ужасающего жара!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Люси, кажется она не горит...",
					EMBERS = "Люси, кажется она теряет силы...",
					LOW = "Миниатюрная звезда! Люси, мне кажется, теперь я видел всё!",
					NORMAL = "Эй Люси, присмотрись, как она держится в воздухе?",
					HIGH = "Люси, держись подальше! Кажется, она вот-вот взорвётся!",
				}

--		if GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then 

			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HEAT_STAR  =
					{
						OUT = "Потухла! Потухла!",
						EMBERS = "Эта звезда скоро отправится в Вальгаллу!",
						LOW = "Нужно подзаправить её, пока она не потухла совсем!!",
						NORMAL = "Согреет целую армию воинов!",
						HIGH = "Величайший дух! Падаю на колени перед тобой!!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.HEAT_STAR  =
					{
						OUT = "Кажется, совсем перестала гореть...",
						EMBERS = "Нам нужно добавить топлива!",
						LOW = "Мы видали и поярче, нужно добавить тепла!!",
						NORMAL = "Теперь - то что нужно. Огромное горящее солнце прямиком в центре нашего лагеря!",
						HIGH = "Надеемся, оно не станет еще больше!!",
					}

--		end

	-- Heat Star config opions
	--
	
	--ICE STAR

--	if (GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)) then 

	-- Ice Star dialog
		GLOBAL.STRINGS.NAMES.ICE_STAR = "Star of Boreas"
		STRINGS.RECIPE_DESC.ICE_STAR = "Создайте звезду ИЗО ЛЬДА!!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICE_STAR  =
				{
					OUT = "Кажетя, погасла. Может, запустить снова?",
					EMBERS = "Не могу поверить, это ледяная звезда!  Интересно, что будет, когда она погаснет?!",
					LOW = "Выглядит меньше, но всё еще холодная!",
					NORMAL = "Спасибо, гигантская звезда... Твой холод остудит в любую жару!",
					HIGH = "Гигантская звезда изо льда.. Это явно небезопасно!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.ICE_STAR  =
				{
					OUT = "КРИТИЧЕСКАЯ ОШИБКА: ЗВЕЗДА БОРЕЯ - НЕ ОБНАРУЖЕНО;",
					EMBERS = "ОШИБКА: ОТРИЦАТЕЛЬНЫЙ КВАНТОВЫЙ ПОТОК :: НЕОБХОДИМО ВОССТАНОВЛЕНИЕ!",
					LOW = "ПРЕДУПРЕЖДЕНИЕ: ВОЛНЫ ЭНЕРГИИ МОГУТ БЫТЬ НЕСТАБИЛЬНЫМИ",
					NORMAL = "ПРЕДУПРЕЖДЕНИЕ: СТАБИЛЬНОСТЬ ГРАВИТАЦИИ НЕИЗВЕСТНА",
					HIGH = "ОПАСНОСТЬ: ПРЕВЫШЕН ЛИМИТ НИЗКОЙ ТЕМПЕРАТУРЫ",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ICE_STAR  =
				{
					OUT = "Куда всё делось?",
					EMBERS = "Требует топлива!",
					LOW = "Маленькая жалкая звезда - пфффф!!",
					NORMAL = "Невероятно!!",
					HIGH = "Не думал, что что-нибудь может быть красивее моих мускулов!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.ICE_STAR  =
				{
					OUT = "Это неправильно! Огонь должен быть ГОРЯЧИМ!!",
					EMBERS = "Выглядит убого! Фу! Синее пламя!",
					LOW = "Синее пламя ненатурально! Ненавижу! Где моя зажигалка?",
					NORMAL = "Пфф... Какой смысл в ЛЕДЯНОЙ звезде?!!",
					HIGH = "А теперь лучше просто взорвись!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ICE_STAR  =
				{
					OUT = "Прекрасно, как ни крути!",
					EMBERS = "Скоро потухнет!!",
					LOW = "Послужит моей цели.",
					NORMAL = "Просто чудесно!",
					HIGH = "Лучше отойти на несколько шагов. Это самая холодная вещь в мире!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ICE_STAR  =
				{
				    OUT = "Такой звезды нет в моих книгах.",
					EMBERS = "Это почти и не звезда вовсе...",
					LOW = "Нужно задокументировать этот феномен",
					NORMAL = "Прекрасно, но выглядит грозно! Очень холодная!",
					HIGH = "Это нарушает все законы физики!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.ICE_STAR  =
				{
					OUT = "Здесь есть пометка: 'Звезда Борея. Заморозит вас до костей'.",
					EMBERS = "Нет, не потухай!!",
					LOW = "Мне нужно заправить её, чтобы сохранить ей жизнь",
					NORMAL = "Еще один дух защитит меня и Абигейл от жары!",
					HIGH = "Хватит меня пугать, звезда! Я не боюсь твоего ужасающего холода!"
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.ICE_STAR  =
				{
					OUT = "Люси, я не доверяю этой звезде...",
					EMBERS = "Люси, кажется она теряет силы...",
					LOW = "Миниатюрная ледяная звезда! Люси, мне кажется, теперь я видел всё!",
					NORMAL = "Эй Люси, присмотрись, как она держится в воздухе?",
					HIGH = "Люси, держись подальше! Кажется, она вот-вот взорвётся!"
				}

			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ICE_STAR  =
					{
						OUT = "?цfлn дgдпn!",
						EMBERS = "Ћvлn thл mлдt is цffлndлd by yцьr wлдknлss!",
						LOW = "Cдll yцьrsлlf дn ice Star? I'vл bллn in sдьnдs coldлr thдn yць!!",
						NORMAL = "I sьppцsл this mдkлs Sьmmлr bдrлдblл",
						HIGH = "Mighty Spirit - Yцu'rл pцwлr is grлдtлr thдn I лvлr imaginлd!!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.ICE_STAR  =
					{
						OUT = "Потухла! Потухла!",
						EMBERS = "Эта звезда скоро отправится в Вальгаллу!",
						LOW = "Нужно подзаправить её, пока она не потухла совсем!!",
						NORMAL = "Охладит целую армию воинов!",
						HIGH = "Величайший дух! Падаю на колени перед тобой!!",
					}

--!!!!!!!!!!!!!!heat_star.lua
pp("STOP!!! I don't want to die... HOUND PROTECT ME!!!","СТОЙ!!! Я не желаю умирать. ГОНЧАЯ, ЗАЩИТИ МЕНЯ!!!")
pp("STOP!!! I don't want to die...","СТОЙ!!! Я не хочу умирать...")

pp("I feel like a Supernova!!!","Чувствую себя как Супернова!!!")
--section 1
pp("I'm fading... fuel me NOW or feel my wrath! My HOUNDS will protect me!!","Я гасну... накорми меня СЕЙЧАС ЖЕ или познаешь мой гнев! Мои ГОНЧИЕ меня защитят!!!")
pp("I'm fading... I don't want to be extinguished!","Я меркну... Я не хочу потухнуть!")
pp("Bless you for awakening my weakened spirit... I need a bit more fuel","Благослави тебя звезда Азуры...Прошу, дай мне немного топлива...")
--section 2
pp("You'll be sorry if you let me go out... I will leave a nasty suprise to HOUND you!!","Ты пожалеешь, если дашь мне умереть... Я натравлю на тебя ГОНЧИХ!!!")
pp("I beg you not to let my spirit die...","Прошу, не дай мне умереть..")
--section 3
pp("More... More... MORE!!!","Больше... Больше... БОЛЬШЕ!!!")
--section 4
pp("I'm starting to feel weak... FEED ME NOW!!!","Я слабею. Накорми меня. СЕЙЧАС ЖЕ!!!")
--section 6
pp("My Spirit is burning bright!","Моя душа горит ярким пламенем!")
--section 8
pp("I feel alive again!!","Я снова чувствую себя живой!!")


-- inst:ListenForEvent( "onbuilt", function()
pp("I am the Spirit of Anchiale - Fear my awesome POWER!!!","Я - воплощение богини огня. Познай мою НЕВЕРОЯТНУЮ МОЩЬ!!!")


--!!!!!!!!!!!!!!!!!!!ice_star.lua
--local function onhit(inst, worker)
pp("STOP!!! I don't want to die... HOUND PROTECT ME!!!","СТОЙ!!! Я не желаю умирать. ГОНЧАЯ, ЗАЩИТИ МЕНЯ!!!")
pp("STOP!!! I don't want to die...","СТОЙ!!! Я не хочу умирать...")

--if section == 10 then
pp("Haha! My wrath is unsurpassed - I am COLDER than a million Winters!!!","Хаха! Меня не остановить - я холоднее МИЛЛИОНА ВЕТРОВ!!!")

--section 1
pp("I'm fading... fuel me NOW or suffer! My HOUNDS will protect me!!","Я гасну... накорми меня СЕЙЧАС ЖЕ или познаешь мой гнев! Мои ГОНЧИЕ меня защитят!!!")
pp("I'm fading... I don't want to be extinguished!","Я меркну... Я не хочу потухнуть!")
pp("My spirit is alive... add more fuel to see what I can really do!","Моя душа жива... добавь еще топлива, и я покажу, на что способна!")
--section 2
pp("You'll be sorry if my spirit is extinguished... I will leave a nasty suprise to HOUND you!!","Ты пожалеешь, если дашь мне умереть... Я натравлю на тебя ГОНЧИХ!!!")
pp("I beg you not to let my spirit die...","Прошу, не дай мне умереть...")
--section 3
pp("More... More... MORE!!!  This feels so amazing","Больше... Больше... БОЛЬШЕ!!!  Это просто потрясно!")
--section 4
pp("I'm starting to feel weaker again - YOU MUST FEED ME NOW!!!","Я слабею. Ты обязан накормить меня. СЕЙЧАС ЖЕ!!!")
--section 6
pp("My Spirit is burning COLD!","Моя душа горит жгучим морозным пламенем!")
--section 8
pp("I feel alive again!!  My coldness will stretch throughout the land!","Я снова чувствую себя живой!!  Мой холод покроет всю землю!")


-- inst:ListenForEvent( "onbuilt", function()
pp("I am the Spirit of Boreas - Stay back from my deadly ICE STAR!!","Я - душа Борея! ДЕРЖИСЬ ПОДАЛЬШЕ ОТ МОЕГО ЖГУЧЕГО ЛЕДЯНОГО ПЛАМЕНИ!!!")

	-------------------------------ВСЁ
