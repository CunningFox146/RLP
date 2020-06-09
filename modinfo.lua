name = "Russification Pack for DST"
version = "3.0"

local desc = {
	en = "\nThe best russian localisation at the moment. Soure code was taken from the Russian Language Pack. Special thanks to Some1 and Alevastor!\n\nVersion: "..version,
	ru = "\nЛучший, на данный момент, русификатор. Код для базы был взят из мода Russian Language Pack. Огромное спасибо Some1'у и Alevastor'у за проделанную работу!\n\nНовый логотип был сделан Globalastick'ом.\n\t\nВерсия: "..version
}

description = language and desc[language] or desc["en"]

name = language and language == "ru" and " Русификатор для DST" or "Russification Pack for DST"

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
	name = name.." (GitHub "..(language and language == "ru" and "Версия" or "Version")..")"
	description = description.."\n\n" .. (language and language == "ru" and "Не забывайте обновлять мод вручную!" or "Don't forget to update RLP manually!")
end

author = "Cunning fox, ma3ok, 何も, Hunger Artist, Sky Fly, Demi, Sinimolik" --Макс. 67 символов

forumthread = ""

api_version = 10

icon_atlas = "images/rusif_icon.xml"
icon = "rusif_icon.tex"

priority = 10.1251526619

dont_starve_compatible = false
dst_compatible = true

client_only_mod = true

forge_compatible = true
