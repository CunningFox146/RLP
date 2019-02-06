local t = mods.RussianLanguagePack
local RLPUpdater = {
	URL = "https://raw.githubusercontent.com/CunningFox146/RLP/master/DST.po",
	disabled = t.StorePath:find("workshop-") == nil,
}

function RLPUpdater:CancelDownloading()
	RLPUpdater.iscanceled = true
end

function RLPUpdater:StartUpdating(auto)
	if self.disabled then
		print("Disabling updating. We're on git branch")
		return
	end
	
	RLPUpdater.iscanceled = nil
	TheSim:QueryServer(RLPUpdater.URL, function (result, isSuccessful, resultCode)
		if resultCode ~= 200 or not isSuccessful or #result < 1 or RLPUpdater.iscanceled then
			TheGlobalInstance:PushEvent("rlp_updated", false)
			return
		end
		
		local f = io.open(t.StorePath..t.MainPOfilename, "w")
		if f then
			print("[RLP Updater] PO file was updated")
			f:write(result)
		else
			print("[RLP Updater] Failed to download the file")
		end
		TheGlobalInstance:PushEvent("rlp_updated", f ~= nil)
		f:close()
	end, "GET")
end

return RLPUpdater