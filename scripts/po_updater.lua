local t = mods.RussianLanguagePack

local POUpdater = {
	VER_URL = "https://raw.githubusercontent.com/CunningFox146/RLP/master/po_ver.txt",
	URL = "https://raw.githubusercontent.com/CunningFox146/RLP/master/DST.po",
	
	git_ver = "0.0",
	
	disabled = not t.StorePath:find("workshop-"),
}

function POUpdater:StartUpdating(auto)
	if self.disabled then
		print("[PO Updater] Disabling updating. We're on git branch")
		return
	end
	
	POUpdater.iscanceled = nil
	TheSim:QueryServer(POUpdater.URL, function (result, isSuccessful, resultCode)
		if resultCode ~= 200 or not isSuccessful or #result < 1 or POUpdater.iscanceled then
			TheGlobalInstance:PushEvent("rlp_updated", false)
			return
		end
		
		local f = io.open(t.StorePath..t.MainPOfilename, "w")
		if f then
			f:write(result)
			f:close()
			print("[PO Updater] PO file was updated")
		else
			print("[PO Updater] Failed to write PO file")
		end
		
		local ver_f = io.open(t.StorePath.."po_ver.txt", "w")
		if ver_f then
			ver_f:write(self.git_ver)
			ver_f:close()
		else
			print("[PO Updater]: Error: failed to save PO version")
		end
		
		TheGlobalInstance:PushEvent("rlp_updated", f ~= nil)
	end, "GET")
end

function POUpdater:GetGitVer(fn)
	TheSim:QueryServer(self.VER_URL, function (result, isSuccessful, resultCode)
		if resultCode ~= 200 or not isSuccessful or #result < 1  then
			print("[PO Updater] Failed to get PO version")
			fn()
			return
		end
		
		fn(result)
		
		print("[PO Updater] Got PO version", result)
	end, "GET")
end

function POUpdater:ShouldUpdate(fn)
	self:GetGitVer(function(ver)
		local f = io.open(t.StorePath.."po_ver.txt", "r")
		if f then
			local curr_ver = f:read("*all")
			f:close()
			if ver and curr_ver and ver ~= curr_ver then
				self.git_ver = ver
				fn(true)
			else
				fn(false)
			end
		else
			print("[PO Updater] Failed to open version file")
			fn(false)
		end
	end)
end

function POUpdater:CancelDownloading()
	self.iscanceled = true
end

function POUpdater:IsDisabled()
	return self.disabled
end

return POUpdater