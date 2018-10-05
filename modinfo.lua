name = "Russification Pack for DST"
version = "1.11fix"

local desc = {
	en = "\nThe best russian localisation at the moment. Soure code was taken from the Russian Language Pack. Special thanks to Some1 and Alevastor!\n\nVersion: "..version,
	ru = "\nЛучший, на данный момент, русификатор. Код для базы был взят из мода Russian Language Pack. Огромное спасибо Some1'у и Alevastor'у за проделанную работу!\n\nНовый логотип был сделан Globalastick'ом.\n\t\nВерсия: "..version
}

description = language and desc[language] or desc["en"]

author = "Cunning fox, ma3ok, 何も, Hunger Artist, Sky Fly, Demi, Sinimolik" --Макс. 67 символов

forumthread = ""

api_version = 10

icon_atlas = "images/rusif_icon.xml"
icon = "rusif_icon.tex"

priority = .9999999999991 --Сразу после старого русификатора

dont_starve_compatible = false
dst_compatible = true

client_only_mod = true

forge_compatible = true
