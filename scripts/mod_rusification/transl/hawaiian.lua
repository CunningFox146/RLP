------ Переводы от Hawaiian ------

local function LoadModTranslation(file)
	modimport("scripts/mod_rusification/mods/"..file)
end

-------------------------------------------------Steampunk DST
--http://steamcommunity.com/sharedfiles/filedetails/?id=418604101
if FindName("Steampunk DST") then
	LoadModTranslation "steampunk.lua"
end

-------------------------------------------------<default>'s item pack (DST)
--http://steamcommunity.com/sharedfiles/filedetails/?id=436897772
if FindName("<default>'s item pack") then
	LoadModTranslation "defaults_item_pack.lua"
end
-------------------------------------------------Structures and More...
--http://steamcommunity.com/sharedfiles/filedetails/?id=580851939
if FindName("Structures and More") then
	RegisterTranslation(function()
		LoadModTranslation "structures_and_more.lua"
	end)
end

-------------------------------------------------DST In Wilson's House
--http://steamcommunity.com/sharedfiles/filedetails/?id=346968521
if FindName("DST Wilson's House") then
	mk("WILSON_HOUSE","Жилище",4,"Жилищу",1,false)
	--оставил в modmain.lua
	RegisterTranslation(function()
		rec.WILSON_HOUSE = "Дом, милый дом!!"
		pp(gendesc.WILSON_HOUSE, "Уютный домишко!")
	end)
end

-------------------------------------------------Portable cookpot
--http://steamcommunity.com/sharedfiles/filedetails/?id=614931358
if FindName("Portable cookpot") then
	mk("PORTABLECOOKPOT","Походный котелок",1,"Походному котелку",1,false)
	mk("PORTABLECOOKPOT_ITEM","Походный котелок",1,"Походному котелку",1,false)
	RegisterTranslation(function()
		rec.PORTABLECOOKPOT_ITEM = "Удобный походный котелок"
		pp(gendesc.PORTABLECOOKPOT_ITEM, "Я могу носить его с собой!")
	end)
end

--------------------------Deluxe Campfires 2.11
--http://steamcommunity.com/sharedfiles/filedetails/?id=444235588
if FindName("Deluxe Campfires") then
	RegisterReplacedTranslation(function() --с подменой!!!
		LoadModTranslation "deluxe_campfires.lua"
	end)
end

--------------------------Too many items
--http://steamcommunity.com/sharedfiles/filedetails/?id=551338671
if FindName("[DST]Too Many Items") then
	RegisterTranslation(function() --без подмены
		LoadModTranslation "too_many_items.lua"
	end)
end

------------------------Craftable gears
--Тонны модов делают это, поэтому нет смысла указывать какой-то конкретный.
rec.GEARS = "Полезное механическое... барахло."	
-----------------------Configurable Craftable Living Logs
--Аналогично.
rec.LIVINGLOG = "Возможно, оно и говорить умеет?"

----------------------------------------------DST Survival Gear
--http://steamcommunity.com/sharedfiles/filedetails/?id=393441469
--кое-как получилось вписать в игру (в modmain.lua)
mk("CAVE_ARMOR","Пальто из шерсти Бифало",4,1,1,false,1)
rec.CAVE_ARMOR = "В нем очень тепло!"
gendesc.CAVE_ARMOR = "Стоит поблагодарить Бифало!"
--p.s. там еще две деревянных биты, но они очень так себе нарисованы. и я их из мода удалил и не стал переводить.		

