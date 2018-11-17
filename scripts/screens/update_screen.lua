local GenericWaitingPopup = require "screens/redux/genericwaitingpopup"
local PopupDialogScreen = require "screens/redux/popupdialog"

local UpdateScreen = Class(GenericWaitingPopup, function(self)
    GenericWaitingPopup._ctor(self, "UpdateScreen", "Скачивание обновления")
	self.inst:ListenForEvent("rlp_updated", function(_, updated)
		TheFrontEnd:PopScreen(self)
		TheFrontEnd:PushScreen(PopupDialogScreen("Обновление завершено", updated and 
		"Перевод был успешно обновлен. Для того, чтоб изменения вступили в силу, необходимо перезапустить игру." or
		"Не удалось обновить перевод. Перезапустите игру и попробуйте еще раз.",
			{
				{text="Продолжить", cb = function()
					if updated then
						SimReset()
					end
					TheFrontEnd:PopScreen()
				end},
			}
		))
	end, TheGlobalInstance)
	TheRLPUpdater:StartUpdating()
end)

function UpdateScreen:OnCancel()
    self:Disable()
	TheRLPUpdater:CancelDownloading()
    TheFrontEnd:PopScreen()
end

return UpdateScreen
