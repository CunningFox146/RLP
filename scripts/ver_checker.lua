local t = mods.RussianLanguagePack
local VerChecker = {
	URL = "https://raw.githubusercontent.com/CunningFox146/RLP/"..(t.IsBeta and "wip" or "master").."/modinfo.lua",
}

-- local VerChecker = require("ver_checker") VerChecker:GetVersion(function(data) print(data) end)
function VerChecker:LoadVersion(fn)
	print("[RLP VerChecker] Downloading mod version")
	TheSim:QueryServer(self.URL, function (result, isSuccessful, resultCode)
		if resultCode ~= 200 or not isSuccessful or #result < 1 then
			print("[RLP VerChecker]: Server Error", resultCode, isSuccessful)
			return
		end
		
		local anim = (result:match("version = [%S]+"))
		self.data = anim and (anim:gsub("version = ", "")):sub(2, -2)
		
		if fn then
			fn(self.data)
		end
		print("[RLP VerChecker] Done!")
	end, "GET")
end

function VerChecker:GetVersion(fn)
	if self.data then
		fn(self.data)
	end
	
	-- Продолжаем проверку. Вдруг мы обновились за это время?
	self:LoadVersion(not self.data and fn)
end

return VerChecker
