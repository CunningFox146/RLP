local VerChecker = {
	URL = "https://cunningfox146.github.io/RLP.htm",
}

function VerChecker:GetData(fn)
	if VerChecker.data then
		fn(VerChecker.data)
	end
	-- Но всё равно обновляем
	TheSim:QueryServer(VerChecker.URL, function (result, isSuccessful, resultCode)
		if resultCode ~= 200 or not isSuccessful or #result < 1 then
			print("[VerChecker]: Server Error.")
			return
		end
		print("[VerChecker]: Got data:", result)
		VerChecker.data = json.decode(result)
	end, "GET")
end

return VerChecker