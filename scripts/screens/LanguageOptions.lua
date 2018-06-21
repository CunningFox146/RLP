local t = mods.RussianLanguagePack

--require("constants")
local Widget = require "widgets/widget"
local Screen = require "widgets/screen"
local ImageButton = require "widgets/imagebutton"
local Spinner = require "widgets/spinner"
local Text = require "widgets/text"
local Image = require "widgets/image"
local ThreeSlice = require "widgets/threeslice"
local UIAnim = require "widgets/uianim"

local EyeButton = require "widgets/eye_button"
local GroupButton = require "widgets/group_button"
local WikiButton = require "widgets/wiki_button"
local VKButton = require "widgets/vk_button"
local RLPModButton = require "widgets/mod_settings_button"
--local Puppet = require "widgets/skinspuppet"

local TranslationTypeSave = nil

local LanguageOptions = Class(Screen, function(self)
    Screen._ctor(self, "LanguageOptions")
	
	if kleifileexists("images/bg_redux_dark_right.xml") then
		self.bg = self:AddChild(Image("images/bg_redux_dark_right.xml", "dark_right.tex"))
	else
		self.bg = self:AddChild(Image("images/bg_spiral.xml", "bg_spiral.tex"))
	end
	
	self.bg:SetVRegPoint(ANCHOR_MIDDLE)
	self.bg:SetHRegPoint(ANCHOR_MIDDLE)
	self.bg:SetVAnchor(ANCHOR_MIDDLE)
	self.bg:SetHAnchor(ANCHOR_MIDDLE)
	self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)
    
	self.scaleroot = self:AddChild(Widget("scaleroot"))
	self.scaleroot:SetVAnchor(ANCHOR_MIDDLE)
	self.scaleroot:SetHAnchor(ANCHOR_MIDDLE)
	self.scaleroot:SetPosition(0,-15,0)
	self.scaleroot:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.root = self.scaleroot:AddChild(Widget("root"))
	self.root:SetScale(.9)

	local left_col =-RESOLUTION_X*.25 - 70
	local right_col = RESOLUTION_X*.25 - 130
	local buttonshift=30

	self.ControlButtonPressed=false
    
	self.backbutton = self.root:AddChild(ImageButton("images/ui.xml", "button_large.tex", "button_large_over.tex", "button_large_over.tex"))
	self.backbutton:SetText("Применить")
	self.backbutton:SetOnClick(function() self:Cancel() end )
	self.backbutton:SetTextSize(36)

	self.OldLogRecord=nil
	self.Oldlogpage=nil
	self.HistoryButton = self.root:AddChild(ImageButton("images/ui.xml", "button_large.tex", "button_large_over.tex", "button_large_over.tex"))
	self.HistoryButton:SetPosition(left_col, -140-buttonshift, 0)
--	self.HistoryButton:SetText("Вернуть лог")
	self.HistoryButton:SetText("История изменений")
	self.HistoryButton:Disable()
	local function HistoryButtonClick()
		if self.HistoryButton:GetText()=="История изменений" then
			local tmp1=self.CurrentLogRecord
			local tmp2=self.logpage

			self.UpdateLog={}
			self.logtextlines=0 --Количество текстовых строк, в которых отображается лог (на всех страницах вместе)
			self:LoadHistory()
			self.CurrentLogRecord=self.OldLogRecord or #self.UpdateLog
			self.OldLogRecord=tmp1
			self.logpage=self.Oldlogpage or 1
			self.Oldlogpage=tmp2
			self:ChangeLogRecord(0)
			self:UpdatePageNumbers()
			self.HistoryButton:SetText("Вернуть лог")
		else
			local tmp1=self.CurrentLogRecord
			local tmp2=self.logpage
			self.UpdateLog={}
			self.logtextlines=0 --Количество текстовых строк, в которых отображается лог (на всех страницах вместе)
			self:LoadUpdateLog() --Загрузим все записи в UpdateLog
			self.CurrentLogRecord=self.OldLogRecord or #self.UpdateLog
			self.OldLogRecord=tmp1
			self.logpage=self.Oldlogpage or 1
			self.Oldlogpage=tmp2
			self:ChangeLogRecord(0)
			self:UpdatePageNumbers()
			self.HistoryButton:SetText("История изменений")
		end
	end
	self.HistoryButton:SetOnClick( HistoryButtonClick )
	self.HistoryButton:SetTextSize(36)


	self.URLButton = self.root:AddChild(ImageButton("images/ui.xml", "button_large.tex", "button_large_over.tex", "button_large_over.tex"))
	self.URLButton:SetText("Страница\nпроекта")
	self.URLButton:SetOnClick( function() VisitURL("https://github.com/CunningFox146/RLP") end )
	self.URLButton:SetTextSize(30)


	--set up the device spinner
    self.updateoptionspanel = self.root:AddChild(Widget("updateoptionspanel"))
    self.updateoptionspanel:SetPosition(left_col,65,0)
	
    self.updateoptionstitle = self.updateoptionspanel:AddChild(Image("images/ui.xml", "update_banner.tex"))
	self.updateoptionstitle:SetScale(1.4, 1.625, 1)
	
    self.updateoptionstitle.text = self.updateoptionstitle:AddChild(Text(TITLEFONT, 35))
    self.updateoptionstitle.text:SetHAlign(ANCHOR_MIDDLE)
    self.updateoptionstitle.text:SetRegionSize( 400, 75 )
	self.updateoptionstitle.text:SetPosition(0, 8, 1)
    self.updateoptionstitle.text:SetString("Русификация")
	
	--Добавляем анимацию для добавления к тексту fx'а
	self.updateoptionstitle_fx = self.updateoptionstitle:AddChild(UIAnim())
	self.updateoptionstitle_fx:SetPosition(57, 18, 1)
	self.updateoptionstitle_fx:GetAnimState():SetBuild("text_sparkle")
	self.updateoptionstitle_fx:GetAnimState():SetBank("text_sparkle")
	
	self.updateoptionstitle_fx:SetClickable(false)
	self.updateoptionstitle_fx:SetScale(.4)
	self.updateoptionstitle_fx:Hide()
	
	self.updateoptionstitle.modicon = self.updateoptionstitle:AddChild(Image("images/rusif_icon.xml", "rusif_icon.tex"))
	self.updateoptionstitle.modicon:SetScale(.380, .380, 1)
	self.updateoptionstitle.modicon:Hide()
	
	self.updateoptionstitle.modicon.version = self.updateoptionstitle.modicon:AddChild(Image("images/ui.xml", "button_small.tex"))
	self.updateoptionstitle.modicon.version:SetPosition(100, -137, 1)
	self.updateoptionstitle.modicon.version:SetScale(1.5, 1.5, 1)
	
    self.updateoptionstitle.modicon.version.text = self.updateoptionstitle.modicon.version:AddChild(Text(UIFONT, 25))
    self.updateoptionstitle.modicon.version.text:SetString("Версия: "..t.modinfo.version)
	
	
	--Красивая шту4ка
	self.updateoptionstitle:MoveTo(Vector3(0, 350, 1), Vector3(0, 295, 1), .5, function()
		self.updateoptionstitle.modicon:Show()
		self.updateoptionstitle.modicon:MoveTo(Vector3(0, 295, 1), Vector3(0, -85, 1), 1, function()
			self.updateoptionstitle_fx:Show()
			self.updateoptionstitle_fx:GetAnimState():PushAnimation("anim")
			
			self.inst:DoTaskInTime(.5, function()
				self.updateoptionstitle_fx:Hide()
			end)
		end)
	end)
	
	--Настройки самой русификации
	
	--бг
	self.updateoptionspanelbg = self.updateoptionspanel:AddChild(Image("images/fepanels.xml", "panel_controls.tex"))
	self.updateoptionspanelbg:SetPosition(0,-183)
	self.updateoptionspanelbg:SetScale(.678,.55, 1)
	--Делаем бг для текста
	self.TranslationTypeText = self.updateoptionspanel:AddChild(Widget("RLPTranslationTextBG"))
	--self.TranslationTypeText:SetPosition(7, -10, 1) 
	self.TranslationTypeText:MoveTo(Vector3(7, -80, 1), Vector3(7, -10, 1), .7)
	
	self.TranslationTypeText.bg = self.TranslationTypeText:AddChild(Image("images/text_bg.xml", "text_bg.tex"))
	self.TranslationTypeText.bg:SetScale(.7, .95, 1)
	self.TranslationTypeText.bg:SetPosition(0, 22.5, 0)

	self.TranslationTypeText.text = self.TranslationTypeText:AddChild(Text(UIFONT, 32))
	self.TranslationTypeText.text:SetHAlign(ANCHOR_LEFT)
	self.TranslationTypeText.bg:SetPosition(0, 15, 0)
	self.TranslationTypeText.text:SetRegionSize( 320, 70 )
	self.TranslationTypeText.text:SetString("Варианты русификации")
	self.TranslationTypeText.text:SetHAlign(ANCHOR_MIDDLE)

	local transtype = Profile:GetLocalizaitonValue("translation_type")
	if not transtype then --Если нет записи о типе, то делаем по умолчанию полный перевод
		transtype = t.TranslationTypes.Full
		Profile:SetLocalizaitonValue("translation_type", transtype)
	end
	TranslationTypeSave = transtype --сохраняем то значение, которое у нас при входе в это окно

	self.TranslationTypeOptions={
		{text = "Полная", data = t.TranslationTypes.Full, description = "Переведено всё, включая интерфейс, чат, названия предметов и реплики персонажей."},
		{text = "Интерфейс и чат", data = t.TranslationTypes.InterfaceChat, description = "Переведён только интерфейс и чат. Пригодится тем, кто привык к оригинальной английской терминологии."},
		{text = "Только чат", data = t.TranslationTypes.ChatOnly, description = "Подойдёт тем, кто не хочет перевода игры. Подгружаются только русские шрифты."}
	}
	
	--Под этим всем нужна чтука, перекрывающая штуку сверху
	self.SeparatorBG = self.updateoptionspanelbg:AddChild(Image("images/black_fill.xml", "black_fill.tex"))
	self.SeparatorBG:SetScale(.525, .5, 1)
	self.SeparatorBG:SetPosition(0,-55,1)
	
	--Нам нужен bg. Выше спинера
	self.SpinnerBG = self.updateoptionspanel:AddChild(Image("images/ui.xml", "single_option_bg_large_gold.tex"))
	self.SpinnerBG.bg = self.SpinnerBG:AddChild(Image("images/ui.xml", "single_option_bg_large.tex"))--Да-да
	self.SpinnerBG:SetScale(.695,.525,1)
	--Сам спинер
	self.TranslationTypeSpinner = self.updateoptionspanel:AddChild(Spinner(self.TranslationTypeOptions, 350, nil, nil, nil, nil, nil, true, nil, nil, .7, .7))	
	
	for i,v in ipairs(self.TranslationTypeOptions) do --Скроллер должен показывать текущий режим русификатора
		if v.data==transtype then
			self.TranslationTypeSpinner:SetSelectedIndex(i)
			break
		end
	end
	self.TranslationTypeSpinner:SetPosition(0, -75, 0)
	self.TranslationTypeSpinner:SetTextColour(0,0,0,1)
	self.TranslationTypeSpinner.OnChanged =
		function( _, data )
			self.TranslationTypeDescriptionText:SetString(self.TranslationTypeOptions[self.TranslationTypeSpinner:GetSelectedIndex()].description)
			Profile:SetLocalizaitonValue("translation_type",t.TranslationTypes[self.TranslationTypeSpinner:GetSelectedData()])
		end
	self.TranslationTypeSpinner:SetWrapEnabled(true)
	--БГ следут за спинером.
	self.SpinnerBG:SetPosition(self.TranslationTypeSpinner:GetPosition())

	self.TranslationTypeDescriptionText = self.updateoptionspanel:AddChild(Text(BODYTEXTFONT, 22))
	self.TranslationTypeDescriptionText:SetColour(.75,.75,.75,1)
	self.TranslationTypeDescriptionText:SetVAlign(ANCHOR_TOP)
	self.TranslationTypeDescriptionText:SetHAlign(ANCHOR_LEFT)
	self.TranslationTypeDescriptionText:SetPosition(7, -315, 0)
	self.TranslationTypeDescriptionText:SetRegionSize(320, 400)
	self.TranslationTypeDescriptionText:EnableWordWrap(true)
	self.TranslationTypeDescriptionText:SetString(self.TranslationTypeOptions[self.TranslationTypeSpinner:GetSelectedIndex()].description)
	------------------------------------------------------------------------------------------------------------------------------------------
	--Добавляе настройку перевода модов.
	self.Separator1 = self.updateoptionspanel:AddChild(Image("images/ui.xml", "line_horizontal_2.tex"))
	self.Separator1:SetPosition(2, -195, 1)
	self.Separator1:SetScale(.675, 1, 1)
	
	self.ModTransTypeButton = self.updateoptionspanel:AddChild(RLPModButton())
	self.ModTransTypeButton:SetPosition(-65, -285, 1)
	
	self.ModTransTypeText = self.updateoptionspanel:AddChild(Text(UIFONT, 32))
	self.ModTransTypeText:SetHAlign(ANCHOR_LEFT)
	self.ModTransTypeText:SetRegionSize( 320, 70 )
	self.ModTransTypeText:SetPosition(7, -215, 1)
	self.ModTransTypeText:SetString("Русификация модов")
	self.ModTransTypeText:SetHAlign(ANCHOR_MIDDLE)
	------------------------------------------------------------------------------------------------------------------------------------------
	--self.HistoryButton:Hide()
	--Перезаписываем расположение
	self.URLButton:SetPosition(left_col-100, -320-buttonshift, 0)
	self.backbutton:SetPosition(left_col+100, -320-buttonshift, 0)
	--И для текста (он будет чуть выше)
	self.backbutton.text:SetPosition(0, 7, 0)
	self.URLButton.text:SetPosition(0, 7, 0)
	
	--Зададим порядок переключения фокуса при нажатии клавиш
	self.TranslationTypeSpinner:SetFocusChangeDir(MOVE_DOWN, self.URLButton)
	self.URLButton:SetFocusChangeDir(MOVE_UP, self.TranslationTypeSpinner)
	self.URLButton:SetFocusChangeDir(MOVE_DOWN, self.backbutton)
	self.backbutton:SetFocusChangeDir(MOVE_UP, self.URLButton)
	----------------------------------------------------------------------
	
	self.logspanel = self.root:AddChild(Widget("logspanel"))
	self.logspanel:SetPosition(right_col,0,0)
	
	--обавляем менюшку с кнопками справа
	--Кнопки вылазит из-под понели
	self.eyebutton = self.logspanel:AddChild(EyeButton())
	self.eyebutton:SetScale(.85, .85, 1)
	self.eyebutton:Hide()
	
	self.groupbutton = self.logspanel:AddChild(GroupButton())
	self.groupbutton:SetScale(.85, .85, 1)
	self.groupbutton:Hide()
	
	self.wikibutton = self.logspanel:AddChild(WikiButton())
	self.wikibutton:SetScale(.85, .85, 1)
	self.wikibutton:Hide()
	
	self.vkbutton = self.logspanel:AddChild(VKButton())
	self.vkbutton:SetScale(.85, .85, 1)
	self.vkbutton:Hide()
	
	self.inst:DoTaskInTime(.75, function()
		self.eyebutton:Show()
		self.eyebutton:MoveTo(Vector3(250,0,1), Vector3(425,240,1), .75)
		
		self.inst:DoTaskInTime(.25, function()
			self.groupbutton:Show()
			self.groupbutton:MoveTo(Vector3(250,0,1), Vector3(425,80,1), .75)
			
			self.inst:DoTaskInTime(.25, function()
				self.vkbutton:Show()
				self.vkbutton:MoveTo(Vector3(250,0,1), Vector3(425,-80,1), .75)
				
				self.inst:DoTaskInTime(.25, function()
					self.wikibutton:Show()
					self.wikibutton:MoveTo(Vector3(250,0,1), Vector3(425,-240,1), .75)
				end)
			end)
		end)
	end)
	-----------------------------------

	
	self.logspanelbg = self.logspanel:AddChild(Image("images/fepanels.xml", "panel_controls.tex"))
	self.logspanelbg:SetScale(1,1.07,1)
	self.logspanelbg:SetPosition(0,5,1)

	self.logstitle = self.logspanel:AddChild(Text(TITLEFONT, 50))
	self.logstitle:Hide()	
	self.logstitle:SetHAlign(ANCHOR_MIDDLE)
	self.logstitle1 = self.logspanel:AddChild(Text(TITLEFONT, 30))
	self.logstitle1:Hide()	
	self.logstitle2 = self.logspanel:AddChild(Text(TITLEFONT, 30))
	self.logstitle2:Hide()	


	self.UpdateLog={} --Весь лог попадает сюда
	self.logtextlines=0 --Количество текстовых строк, в которых отображается лог (на всех страницах вместе)
	self.logtext={} --Массив текст-виджетов, выводящих строки перевода
	self.logtextbg={}
	self.logpage=1 --Текущая страница в текущей записи лога
	self.logpages=0 --Количество страниц в текущей записи лога


	self:LoadUpdateLog() --Загрузим все записи в UpdateLog
	self.CurrentLogRecord=#self.UpdateLog --Текущий порядковый номер лога - последний
	self:UpdateLogsTitle()

	self.tf3 = Widget("tf3")
	self.tf3:SetVAnchor(ANCHOR_MIDDLE)
	self.tf3:SetHAnchor(ANCHOR_MIDDLE)
	self.tf3:SetPosition(0,0,0)
	self.tf3:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.tf2 = self.tf3:AddChild(Widget("tf2"))
	self.tf2:SetScale(.9)
	self.tf1 = self.tf2:AddChild(Widget("tf1"))
	self.tf1:SetPosition(right_col,0,0)
	self.textfade = self.tf1:AddChild(Image("images/gradient.xml", "gradient.tex")) --затемнение справа для сильно длинных строк
	self.textfade:ScaleToSize(90,480,1)
	self.textfade:SetPosition(245,-25)


	self.logtextpagenumber={}
	for i=1,4 do
		self.logtextpagenumber[i]=self.logspanel:AddChild(Text(NUMBERFONT, 8+i*5))
		self.logtextpagenumber[i]:Hide()
		self.logtextpagenumber[i]:SetPosition(-205+i*(30), -295, 0)
		self.logtextpagenumber[i]:SetColour(0.4+i/10,0.4+i/10,0.4+i/10,1)
		self.logtextpagenumber[10-i]=self.logspanel:AddChild(Text(NUMBERFONT, 8+i*5))
		self.logtextpagenumber[10-i]:Hide()
		self.logtextpagenumber[10-i]:SetPosition(215-i*(30), -295, 0)
		self.logtextpagenumber[10-i]:SetColour(0.4+i/10,0.4+i/10,0.4+i/10,1)
	end
	self.logtextpagenumber[5]=self.logspanel:AddChild(Text(NUMBERFONT, 60))
	self.logtextpagenumber[5]:Hide()
	self.logtextpagenumber[5]:SetPosition(10, -295, 0)


	self.nextpage = self.logspanel:AddChild(ImageButton("images/ui.xml", "arrow_right.tex", "arrow_right_over.tex", "arrow_right.tex"))
	self.nextpage:Hide()
	self.nextpage:SetPosition(50, -295, 0)
	self.nextpage:SetOnClick( function() self:ChangeLogPage(1) end)
	self.nextpage:SetScale(0.5,0.35,1)
	
	self.prevpage = self.logspanel:AddChild(ImageButton("images/ui.xml", "arrow_right.tex", "arrow_right_over.tex", "arrow_right.tex"))
	self.prevpage:Hide()
	self.prevpage:SetPosition(-50, -295, 0)
	self.prevpage:SetScale(-0.5,0.35,1)
	self.prevpage:SetOnClick( function() self:ChangeLogPage(-1) end)	


	self:UpdateLogText() --Выводим весь текст
	self:UpdatePageNumbers() --Обновляем номера страниц


	self.rightbutton = self.logspanel:AddChild(ImageButton("images/ui.xml", "arrow_right.tex", "arrow_right_over.tex", "arrow_right.tex"))
	self.rightbutton:Hide()
	self.rightbutton:SetPosition(330, 0, 0)
	self.rightbutton:SetScale(.6, .7, 1)
	self.rightbutton:SetOnClick( function() self:ChangeLogRecord(1) self:UpdatePageNumbers() end)
	
	self.leftbutton = self.logspanel:AddChild(ImageButton("images/ui.xml", "arrow_right.tex", "arrow_right_over.tex", "arrow_right.tex"))
	self.leftbutton:Hide()
	self.leftbutton:SetPosition(-330, 0, 0)
	self.leftbutton:SetScale(-.6, .7, 1)
	self.leftbutton:SetOnClick( function() self:ChangeLogRecord(-1) self:UpdatePageNumbers() end)	
	
    
	self:ChangeLogRecord(0)

--	self.updateoptionsspinner:SetFocus()
--	self.default_focus = self.updateoptionsspinner
	self.default_focus = self.TranslationTypeSpinner
	self.TranslationTypeSpinner:SetFocus()
	self.urlbutton=ImageButton("images/eyebutton.xml", "eyebutton1.tex", "eyebutton2.tex", "eyebutton3.tex")
	self.urlbutton:SetPosition(-265,-12)
	self.urlbutton:SetScale(0.4)
	self.urlbutton:Hide()
	HistoryButtonClick()
	
	--Его делаем выше всех
	--self.puppet = self.logspanel:AddChild(Puppet())
end)


--Обновляет номера страниц и кнопки навигации по ним
function LanguageOptions:UpdatePageNumbers()
	if self.logpages>1 then
		self.logtextpagenumber[5]:SetString(tostring(self.logpage))
		if not self.logtextpagenumber[5].shown then self.logtextpagenumber[5]:Show() end
		for i=1,4 do
			if self.logpage-i>=1 then
				self.logtextpagenumber[5-i]:SetString(tostring(self.logpage-i))
				if not self.logtextpagenumber[5-i].shown then self.logtextpagenumber[5-i]:Show() end
			else
				if self.logtextpagenumber[5-i].shown then self.logtextpagenumber[5-i]:Hide() end
			end
			if self.logpage+i<=self.logpages then
				self.logtextpagenumber[5+i]:SetString(tostring(self.logpage+i))
				if not self.logtextpagenumber[5+i].shown then self.logtextpagenumber[5+i]:Show() end
			else
				if self.logtextpagenumber[5+i].shown then self.logtextpagenumber[5+i]:Hide() end
			end
		end
		if not self.nextpage.shown and self.logpage<self.logpages then self.nextpage:Show() end
		if not self.prevpage.shown and self.logpage>1 then self.prevpage:Show() end
	else
		for _,v in pairs(self.logtextpagenumber) do
			if v.shown then v:Hide() end
		end
		if self.nextpage.shown then self.nextpage:Hide() end
		if self.prevpage.shown then self.prevpage:Hide() end
	end
end


--Меняет номера страниц
function LanguageOptions:ChangeLogPage(dir)
	if #self.UpdateLog==0 then
		return nil
	end
	self.logpage=self.logpage+dir
	self:UpdatePageNumbers()
	if dir>0 then -- Листаем вперёд
		if not self.prevpage.shown then
			self.prevpage:Show()
		end
		if self.logpage==self.logpages then
			self.nextpage:Hide()
		end
		self:UpdateLogText()
		self:UpdatePageNumbers()
	elseif dir<0 then-- Листаем назад
		if not self.nextpage.shown then
			self.nextpage:Show()
		end
		if self.logpage==1 then
			self.prevpage:Hide()
		end
		self:UpdateLogText()
		self:UpdatePageNumbers()
	else
		if self.logpage>1 and not self.prevpage.shown then self.prevpage:Show() end
		if self.logpage<self.logpages and not self.nextpage.shown then self.nextpage:Show() end
	end
end




--Обновляет строки в окне логов
function LanguageOptions:UpdateLogText()
	local function clean_logtextbg(i)
		self.logtextbg[i]:SetSize(0,0)
		self.logtextbg[i]:SetTint(1,1,1,0)
		self.logtextbg[i].OnGainFocus=nil
		self.logtextbg[i].OnLoseFocus=nil
	end
	local function DoDownload(...)
		self.urlbutton:Enable()
		if ... then --пустые они будут если сервер не вернёт ответа или в самый первый раз
			local tbl={...}
			if tbl and #tbl==3 and tbl[3]==200 then --получили ответ от сервера и он положителен
				local id=string.match(tbl[1],"<tr id='o(.-)'")
				local head=string.match(tbl[1],"action=\"/book/45556/(%d+)")
				if id and head then
					VisitURL(t.SteamURL..head.."/"..id) -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!НЕ РАБОТАЕТ
				end
			end
		end
	end

	if #self.UpdateLog==0 then
		for i,text in ipairs(self.logtext) do
			if text.shown then
				clean_logtextbg(i)
				text:Hide()
			end
		end
		self.logpages=0
		return
	end
	if self.urlbutton and self.urlbutton.shown then self.urlbutton:Hide() end

	local starty=200 --Начальная координата строчек по вертикали
	local endy=-260 --Конечная координата строчек по вертикали
	local y=starty
	local linespacingbefore={22,12,10,12}
	local linespacingafter={12,12,10,12}
	local lineindent={-18,2,22,22}
	local logtextbgheight=linespacingafter[2]+linespacingafter[3]+linespacingafter[4]+linespacingbefore[3]+linespacingbefore[4]+11

	local colors={
		{.8,.8,1},
		{.7,.7,.7},
		{1,1,1},
		{1,1,1}
	}
	
	local i=1
	local log=self.UpdateLog[self.CurrentLogRecord]
	local s_chapter,s_tag,s_old,s_new,s_none=1,2,3,4,5
	local currentstringtype=s_chapter
	local currenttag=1

	local currentchapter=1 --Должно зависить от текущей страницы
	local page=1

	while i<=self.logtextlines do
		if y<=endy then
			y=starty
			page=page+1
		end
		if currentstringtype==s_chapter then
			if self.logstitle1:GetString()=="Обновление за" then --Это глава обновлений
				if page~=self.logpage and self.logtext[i].shown then
					self.logtext[i]:Hide()
					clean_logtextbg(i)
				elseif page==self.logpage then
					self.logtextbg[i]:SetPosition(lineindent[currentstringtype], y, 0)
					clean_logtextbg(i)
					self.logtext[i]:SetPosition(0, 0)
					self.logtext[i]:SetColour(colors[currentstringtype][1],colors[currentstringtype][2],colors[currentstringtype][3],1)
					self.logtext[i]:SetString(log.chapters[currentchapter].textname.." ("..log.chapters[currentchapter].name..")")
					if not self.logtext[i].shown then self.logtext[i]:Show() end
				end
				y=y-linespacingafter[currentstringtype]
				currentstringtype=s_tag
				y=y-linespacingbefore[currentstringtype]
			else  --Это запись истории перевода
				if page~=self.logpage and self.logtext[i].shown then
					self.logtext[i]:Hide()
					clean_logtextbg(i)
				elseif page==self.logpage then
					self.logtextbg[i]:SetPosition(0, y, 0)
					clean_logtextbg(i)
					self.logtext[i]:SetPosition(0, 0)
					self.logtext[i]:SetColour(.8,.8,.8,1)
					self.logtext[i]:SetString(log.chapters[currentchapter].firstline)
					if not self.logtext[i].shown then self.logtext[i]:Show() end
				end
				if #log.chapters[currentchapter].nextlines>0 then --Если у текущей записи многострочка
					y=y-23
					currentstringtype=s_tag
					currenttag=1
				else --если это однострочка
					if currentchapter<#log.chapters then --если есть ещё записи
						currentchapter=currentchapter+1
						y=y-35
					else
						currentstringtype=s_none
					end
				end
			end
		elseif currentstringtype==s_tag and self.logstitle1:GetString()=="Версия" then --Это допстроки записи истории перевода
			if page~=self.logpage and self.logtext[i].shown then
				self.logtext[i]:Hide()
				clean_logtextbg(i)
			elseif page==self.logpage then
				self.logtextbg[i]:SetPosition(12, y, 0)
				clean_logtextbg(i)
				self.logtext[i]:SetPosition(0, 0)
				self.logtext[i]:SetColour(.8,.8,.8,1)
				self.logtext[i]:SetString(log.chapters[currentchapter].nextlines[currenttag])
				if not self.logtext[i].shown then self.logtext[i]:Show() end
			end
			if currenttag<#log.chapters[currentchapter].nextlines then --Если есть ещё строки многострочки
				y=y-23
				currenttag=currenttag+1
			else --кончились строки многострочки
				if currentchapter<#log.chapters then --если есть ещё записи
					currentchapter=currentchapter+1
					currentstringtype=s_chapter
					currenttag=1
					y=y-35
				else
					currentstringtype=s_none
				end
			end
		elseif currentstringtype==s_tag and self.logstitle1:GetString()=="Обновление за" then --Это глава обновлений
			if y-(logtextbgheight/2)<=endy then
				y=starty
				page=page+1
			end
			if page~=self.logpage and self.logtext[i].shown then
				self.logtext[i]:Hide()
				clean_logtextbg(i)
			elseif page==self.logpage then
				self.logtextbg[i]:SetPosition(0, y+11-logtextbgheight/2, 0)
				self.logtextbg[i]:SetSize(570, logtextbgheight)
				self.logtextbg[i]:SetTint(1,1,1,0)	                                    
				self.logtext[i]:SetPosition(lineindent[currentstringtype], -11+logtextbgheight/2, 0)
				self.logtext[i]:SetColour(colors[currentstringtype][1],colors[currentstringtype][2],colors[currentstringtype][3],1)
				self.logtext[i]:SetString(log.chapters[currentchapter].log[currenttag].tag)
				self.logtextbg[i]["tag"]=log.chapters[currentchapter].log[currenttag].tag
				self.logtextbg[i]["chapter"]=log.chapters[currentchapter].index
				self.logtextbg[i].OnGainFocus=function(self2)
					Widget.OnGainFocus(self2)
					self2:SetTint(1,1,1,.1)	
					if self.urlbutton then

						if self.urlbutton.parent then
							self.urlbutton.parent.children[self.urlbutton] = nil
						end
						self2:AddChild(self.urlbutton)
						if not self.ControlButtonPressed then
							self.urlbutton:SetOnClick( function() VisitURL(t.SteamURL..t.ChaptersList[self2.chapter].id.."?show=5&to="..self2.tag) end )
						else
							self.urlbutton:SetOnClick( function()
								TheSim:QueryServer( t.SteamURL..t.ChaptersList[self2.chapter].id.."?show=5&to="..self2.tag, DoDownload, "GET" )
								self.urlbutton:Disable()
							end )
						end
						if not self.urlbutton.shown then self.urlbutton:Show() end
					end
				end
				self.logtextbg[i].OnLoseFocus=function(self2)
					Widget.OnLoseFocus(self2)
					self2:SetTint(1,1,1,0)	
					if self.urlbutton then
						if self.urlbutton.parent==self2 then
							self.urlbutton.parent.children[self.urlbutton] = nil
							if self.urlbutton.shown then self.urlbutton:Hide() end
						end
					end
				end
				if not self.logtext[i].shown then self.logtext[i]:Show() end
			end
			y=y-linespacingafter[currentstringtype]
			currentstringtype=s_old
			y=y-linespacingbefore[currentstringtype]
		elseif currentstringtype==s_old then
			if page~=self.logpage and self.logtext[i].shown then
				self.logtext[i]:Hide()
				clean_logtextbg(i)
			elseif page==self.logpage then
				self.logtextbg[i]:SetPosition(lineindent[currentstringtype], y, 0)
				clean_logtextbg(i)
				self.logtext[i]:SetPosition(0, 0)
				self.logtext[i]:SetColour(colors[currentstringtype][1],colors[currentstringtype][2],colors[currentstringtype][3],1)
				self.logtext[i]:SetString(log.chapters[currentchapter].log[currenttag].orig)
				if not self.logtext[i].shown then self.logtext[i]:Show() end
			end
			y=y-linespacingafter[currentstringtype]
			currentstringtype=s_new
			y=y-linespacingbefore[currentstringtype]
		elseif currentstringtype==s_new then
			if page~=self.logpage and self.logtext[i].shown then
				self.logtext[i]:Hide()
				clean_logtextbg(i)
			elseif page==self.logpage then
				self.logtextbg[i]:SetPosition(lineindent[currentstringtype], y, 0)
				clean_logtextbg(i)
				self.logtext[i]:SetPosition(0, 0)
				self.logtext[i]:SetColour(colors[currentstringtype][1],colors[currentstringtype][2],colors[currentstringtype][3],1)
				self.logtext[i]:SetString(log.chapters[currentchapter].log[currenttag].new)
				if not self.logtext[i].shown then self.logtext[i]:Show() end
			end
			y=y-linespacingafter[currentstringtype]
			if currenttag<#log.chapters[currentchapter].log then
				currenttag=currenttag+1
				currentstringtype=s_tag
				y=y-linespacingbefore[currentstringtype]
			else
				if currentchapter<#log.chapters then
					currentchapter=currentchapter+1
					currentstringtype=s_chapter
					y=y-linespacingbefore[currentstringtype]
					currenttag=1
				else
					currentstringtype=s_none
				end
			end
		elseif currentstringtype==s_none then
			for k=i,self.logtextlines do
				self.logtext[k]:SetString("")
				if self.logtext[k].shown then self.logtext[k]:Hide() clean_logtextbg(k) end
			end
			i=self.logtextlines
			if y==starty then page=page-1 end --Если на этой странице нет ни одной записи, то эта страница лишняя
		end
		i=i+1
	end
	self.logpages=page
end


--Обновляет заголовок в логах в соответствии с выбранной записью в логах
function LanguageOptions:UpdateLogsTitle()
	if #self.UpdateLog~=0 then
		self.logstitle:SetString(" "..self.UpdateLog[self.CurrentLogRecord].date.." ")
		self.logstitle2:SetString(self.UpdateLog[self.CurrentLogRecord].time)
		local w,_=self.logstitle:GetRegionSize()
		local w1,_=self.logstitle1:GetRegionSize()
		local w2,_=self.logstitle2:GetRegionSize()
		local pos=(w+w1+w2)/2
		self.logstitle1:SetPosition(-pos+w1/2, 240, 0)
		self.logstitle2:SetPosition(pos-w2/2, 240, 0)
		self.logstitle:SetPosition(-pos+w1+w/2, 245, 0)
		if not self.logstitle.shown then
			self.logstitle:Show()	
			self.logstitle1:Show()
			self.logstitle2:Show()	
		end
	else
		if self.logstitle.shown then
			self.logstitle:Hide()	
			self.logstitle1:Hide()	
			self.logstitle2:Hide()	
		end
	end
end

local function parsedate(dat)
	local months={"января","февраля","марта","апреля","мая","июня","июля","августа","сентября","октября","ноября","декабря"}
	local t=string.split(dat," ")
	local date=t[1]
	local time=t[2]
	date=string.split(date,".")
	local t1,t2,t3=string.match(time,"(%d+)%D+(%d+)%D+(%d+)")
	if #t1==1 then t1="0"..t1 end
	if #t2==1 then t2="0"..t2 end
	if #t3==1 then t3="0"..t3 end
	return date[1].." "..months[tonumber(date[2])].." "..date[3],t1..":"..t2..":"..t3
end

--Загружает в панель лога историю сообщений
function LanguageOptions:LoadHistory()
	if self.textfade then self.textfade:Hide() end
	local maxlinewidth=560

	local function fittext(line) --возвращает массив строк, которые гарантированно влезают
		if not line or #line==0 then return {""} end
		local t=Text(BODYTEXTFONT, 25)
		t:SetString(line)
		local w0 = t:GetRegionSize()
		local approxlen=math.floor(#line*maxlinewidth/w0+0.5) --Приблизительное кол-во символов, которое вместится в 1 строке
		local lines={}

		local function findpartlen() --ищет то количество символов от начала строки, которое влезет
			local function ShiftOneWordForward()
				approxlen=approxlen+1
				while approxlen<#line and string.sub(line.." ",approxlen+1,approxlen+1)~=" " do approxlen=approxlen+1 end
			end
			local function ShiftOneWordBackward()
				approxlen=approxlen-1
				while approxlen>1 and string.sub(line,approxlen,approxlen)~=" " do approxlen=approxlen-1 end
			end
			local maxlinewidth=maxlinewidth
			t:SetString(string.sub(line,1,approxlen))
			local w = t:GetRegionSize()
			local wasfit = w<maxlinewidth
			while true do
				t:SetString(string.sub(line,1,approxlen))
				w = t:GetRegionSize()
				if w>=maxlinewidth then --не вмещается
					ShiftOneWordBackward()
					if wasfit then break end
					wasfit=false
				end
				if w<maxlinewidth then --вмещается
					if not wasfit or #line<=approxlen then break end
					ShiftOneWordForward()
					wasfit=true
				end
			end
			return approxlen
		end
		while line and #line>0 do
			local len=findpartlen()
			table.insert(lines,string.sub(line,1,len))
			line=string.sub(line,len+1)
		end
		t:Kill()
		return lines
	end
	self.logstitle1:SetString("Версия")
	if self.urlbutton then
		if self.urlbutton.parent then
			self.urlbutton.parent.children[self.urlbutton] = nil
			if self.urlbutton.shown then self.urlbutton:Hide() end
		end
	end
	for i=1,#self.logtext do --Удаляем виджеты-тексты, если они были
		self.logtext[i]:Hide()
		self.logtext[i]:Kill()
	end
	for i=1,#self.logtextbg do
		self.logtextbg[i]:Kill()
	end
	self.logpages=0
	self.UpdateLog={}
	self.logtextlines=0
	local lines=0
	local f=io.open(t.StorePath.."scripts/history.txt","r")
	if f then for line in f:lines() do 
		line=t.escapeR(line) --избавляемся от \r для юникс систем
		if line:utf8sub(1,6)=="Версия" then --Найдено описание новой версии
			if lines~=0 then --до этого шло описание другой версии
				if self.logtextlines<lines then self.logtextlines=lines end
			end
			lines=0
			local ver,dat = string.match(line,"Версия ([^%(]*) %((.*)%)")
			dat=parsedate(dat.." 11:11:11")
			table.insert(self.UpdateLog,{date=ver,time="от "..dat,chapters={}})
		else --Если это не описание новой версии, значит одно из изменений версии
			line=string.gsub(line,"[\150\151]","-")
			for i,data in ipairs(fittext(line)) do
				if i==1 then
					table.insert(self.UpdateLog[#self.UpdateLog].chapters,{firstline=data,nextlines={}})
				else
					table.insert(self.UpdateLog[#self.UpdateLog].chapters[#self.UpdateLog[#self.UpdateLog].chapters].nextlines,data)
				end
				lines=lines+1
			end
		end
		
	end f:close() end

	local function ReverseTable(t)
		local reversedTable = {}
		local itemCount = #t
		for k, v in ipairs(t) do
			reversedTable[itemCount + 1 - k] = v
		end
		return reversedTable
	end
	self.UpdateLog=ReverseTable(self.UpdateLog)
	self.logtext={}
	self.logtextbg={}
	for i=1,self.logtextlines do --создаём текстовые виджеты заново в соответствии с нужным количеством.
		table.insert(self.logtextbg,self.logspanel:AddChild(Image("images/global.xml", "square.tex")))
		self.logtextbg[#self.logtextbg]:SetSize(0, 0)
		self.logtextbg[#self.logtextbg]:SetTint(1,1,1,0)	
		table.insert(self.logtext,self.logtextbg[#self.logtextbg]:AddChild(Text(BODYTEXTFONT, 25)))
		self.logtext[#self.logtext]:Hide()
		self.logtext[#self.logtext]:SetRegionSize(maxlinewidth, 40)
		self.logtext[#self.logtext]:SetHAlign(ANCHOR_LEFT)
		self.logtext[#self.logtext]:SetVAlign(ANCHOR_MIDDLE)
	end
	self.CurrentLogRecord=#self.UpdateLog

end

--Загружает данные из лога обновлений для страниц.
function LanguageOptions:LoadUpdateLog()
	if self.urlbutton then
		if self.urlbutton.parent then
			self.urlbutton.parent.children[self.urlbutton] = nil
			if self.urlbutton.shown then self.urlbutton:Hide() end
		end
	end
	for i=1,#self.logtext do --Удаляем виджеты-тексты, если они были
		self.logtext[i]:Hide()
		self.logtext[i]:Kill()
	end
	for i=1,#self.logtextbg do
		self.logtextbg[i]:Kill()
	end
	self.logpages=0
	self.logtext={}
	self.logtextbg={}
	self.logstitle1:SetString("Обновление за")
	self.UpdateLog={}
	if not kleifileexists(t.StorePath..t.UpdateLogFileName) then
		return nil
	end
	if self.textfade then self.textfade:Show() end
	local UpdateLog={}
	local logdata={}

	local f=io.open(t.StorePath..t.UpdateLogFileName,"r")
	if f then for line in f:lines() do 
		table.insert(logdata,t.escapeR(line))
	end f:close() end
	local i=1
	local record=nil
	local chapter=nil
	while i<#logdata do
		if logdata[i]=="------------------------------------------------------------------------------------------" then
			local dat=string.match(logdata[i+1],"%-([^%-]+)%-")
			table.insert(UpdateLog,{date=dat,chapters={}})
			record=#UpdateLog
			chapter=nil
			i=i+4
		end
		if record then
			if string.sub(logdata[i],1,5)=="Глава" then
				local chapt,txt=string.match(logdata[i],"^Глава%s([%S]+)%s%((.+)%)$")
				table.insert(UpdateLog[record].chapters,{name=chapt,textname=txt,log={}})
				chapter=#UpdateLog[record].chapters
				for i,v in ipairs(t.ChaptersList) do
					if v.name==chapt then
						UpdateLog[record].chapters[chapter]["index"]=i
						break
					end
				end
			elseif chapter and string.sub(logdata[i],1,1)=="\t" then
				local tag1=string.sub(logdata[i],2)
				local orig1=string.gsub(string.sub(logdata[i+1],7),"\\\"","\"")
				local new1=string.gsub(string.sub(logdata[i+2],9),"\\\"","\"")
				table.insert(UpdateLog[record].chapters[chapter].log,{tag=tag1,orig=orig1,new=new1})
				i=i+2
			end
		end
		i=i+1
	end

	--Записываем только те, в которых что нибудь есть.
	for _,record in ipairs(UpdateLog) do
		if record.chapters and #record.chapters~=0 then
			local tempchapters={}
			for _,chapter in ipairs(record.chapters) do
				if chapter.log and #chapter.log~=0 then
					table.insert(tempchapters,chapter)
				end
			end
			if #tempchapters~=0 then
				local dat,tim=parsedate(record.date)
				table.insert(self.UpdateLog,{date=dat,time=tim,chapters=tempchapters})
			end
		end

	end

	self.logtextlines=0 --Определяем необходимое количество строк
	for _,v in ipairs(self.UpdateLog) do
		local lines=1
		for _,i in ipairs(v.chapters) do
			lines=lines+1
			for _,p in ipairs(i.log) do
				lines=lines+3
			end
		end
		if lines>self.logtextlines then --Ищем главу с самым большим количеством строк
			self.logtextlines=lines
		end
	end
	--Инициализируем строки окна лога
	for i=1,self.logtextlines do --создаём текстовые виджеты заново в соответствии с нужным количеством.
		table.insert(self.logtextbg,self.logspanel:AddChild(Image("images/global.xml", "square.tex")))
		self.logtextbg[#self.logtextbg]:SetSize(0, 0)
		self.logtextbg[#self.logtextbg]:SetTint(1,1,1,0)	
		table.insert(self.logtext,self.logtextbg[#self.logtextbg]:AddChild(Text(BODYTEXTFONT, 25)))
		self.logtext[#self.logtext]:Hide()
		self.logtext[#self.logtext]:SetRegionSize(530, 40)
		self.logtext[#self.logtext]:SetHAlign(ANCHOR_LEFT)
		self.logtext[#self.logtext]:SetVAlign(ANCHOR_MIDDLE)
	end

	if self.urlbutton then
		self.urlbutton:Hide()
		self.urlbutton.image:Hide()
		self.urlbutton:Kill()
		self.urlbutton=ImageButton("images/eyebutton.xml", "eyebutton1.tex", "eyebutton2.tex", "eyebutton3.tex")
		self.urlbutton:SetPosition(-265,-12)
		self.urlbutton:SetScale(0.4)
		self.urlbutton:Hide()
	end
end



--Меняет текущую запись лога
function LanguageOptions:ChangeLogRecord(dir)
	if #self.UpdateLog==0 then
		if self.rightbutton.shown then self.rightbutton:Hide() end
		if self.leftbutton.shown then self.leftbutton:Hide() end
		self:UpdateLogsTitle()
		return nil
	end
	self.CurrentLogRecord=self.CurrentLogRecord+dir

	if self.CurrentLogRecord==0 then --Если вдруг мы обновили, появились записи, а номер записи остался нулевым
		self.CurrentLogRecord=1
	end
	self:UpdateLogsTitle()
	if dir>0 then -- Листаем вперёд
		if not self.leftbutton.shown then
			self.leftbutton:Show()
		end
		if self.CurrentLogRecord==#self.UpdateLog then
			self.rightbutton:Hide()
		end
		self.logpage=1
		self.logpages=0
		self:UpdateLogText()
	elseif dir<0 then -- Листаем назад
		if not self.rightbutton.shown then
			self.rightbutton:Show()
		end
		if self.CurrentLogRecord==1 then
			self.leftbutton:Hide()
		end
		self.logpage=1
		self.logpages=0
		self:UpdateLogText()
	else
		if self.CurrentLogRecord<#self.UpdateLog and not self.rightbutton.shown then
			self.rightbutton:Show()
		elseif self.CurrentLogRecord==#self.UpdateLog and self.rightbutton.shown then
			self.rightbutton:Hide()
		end
		if self.CurrentLogRecord>1 and not self.leftbutton.shown then
			self.leftbutton:Show()
		elseif self.CurrentLogRecord==1 and self.leftbutton.shown then
			self.leftbutton:Hide()
		end
		self:UpdateLogText()
	end
end


function LanguageOptions:Cancel()
	if self.urlbutton then self.urlbutton:Kill() end
	self.tf3:Kill()
	
	--Если выбран другой тип русификации, то перегружаем систему.
	if TranslationTypeSave and TranslationTypeSave~=self.TranslationTypeSpinner:GetSelectedData() then
		if not( (TranslationTypeSave==t.TranslationTypes.Full and self.TranslationTypeSpinner:GetSelectedData()==t.TranslationTypes.InterfaceChat) or
		(TranslationTypeSave==t.TranslationTypes.InterfaceChat and self.TranslationTypeSpinner:GetSelectedData()==t.TranslationTypes.Full) ) then
			--TheFrontEnd:Fade(FADE_IN, SCREEN_FADE_TIME, function()
				SimReset()
			--end)
		end
	end

	--Музло
	TheFrontEnd:GetSound():KillSound("rlp_ragtime") 
	TheFrontEnd:GetSound():PlaySound(FE_MUSIC, "FEMusic")
	--TheFrontEnd:GetSound():PlaySound("dontstarve/together_FE/portal_idle_vines", "FEPortalSFX")
	
	--Делаем красивую штуку
	--TheFrontEnd:FadeToScreen(TheFrontEnd:GetActiveScreen(), function() return MMScreen() end)
	TheFrontEnd:FadeBack()
end


function LanguageOptions:OnRawKey(key, down)
	if down and key == KEY_LCTRL then self.ControlButtonPressed=true end
	if not down and key == KEY_LCTRL then self.ControlButtonPressed=false end
end


function LanguageOptions:OnControl(control, down)
    if LanguageOptions._base.OnControl(self, control, down) then return true end
    
    if down then
    	if (rawget(_G,"CONTROL_PAGERIGHT") and control == CONTROL_PAGERIGHT) or
		   (rawget(_G,"CONTROL_SCROLLFWD") and control == CONTROL_SCROLLFWD) then
    		if self.nextpage.shown then
    			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:ChangeLogPage(1)
    		end
    	elseif (rawget(_G,"CONTROL_PAGELEFT") and control == CONTROL_PAGELEFT) or
    		   (rawget(_G,"CONTROL_SCROLLBACK") and control == CONTROL_SCROLLBACK) then
    		if self.prevpage.shown then
    			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:ChangeLogPage(-1)
    		end
		elseif control == CONTROL_ACTION then
			if self.updateoptionsspinner and self.updateoptionsspinner.focus then
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
				self.updateoptionsspinner:Next(true)
			end
			if self.TranslationTypeSpinner.focus then
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
				self.TranslationTypeSpinner:Next(true)
			end
		elseif control == CONTROL_FOCUS_LEFT and self.CurrentLogRecord>1 then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:ChangeLogRecord(-1)
			self:UpdatePageNumbers()
		elseif control == CONTROL_FOCUS_RIGHT and self.CurrentLogRecord<#self.UpdateLog then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:ChangeLogRecord(1)
			self:UpdatePageNumbers()
    	end

    end

    if not down then
		if control == CONTROL_CANCEL then
			self:Cancel()
			return true
		end
    end
end



function LanguageOptions:GetHelpText()
	local t = {}
	local controller_id = TheInput:GetControllerID()

	if self.prevpage.shown then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_PAGELEFT) .. " " .. STRINGS.UI.HELP.SCROLLBACK)
	end
	if self.nextpage.shown then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_PAGERIGHT) .. " " .. STRINGS.UI.HELP.SCROLLFWD)
	end
	if self.leftbutton.shown then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_FOCUS_LEFT) .. " Предыдущая запись")
	end
	if self.rightbutton.shown then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_FOCUS_RIGHT) .. " Следующая запись")
	end

	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)
	return table.concat(t, "  ")
end

return LanguageOptions