local GenericWaitingPopup = require "screens/redux/genericwaitingpopup"
local PopupDialogScreen = require "screens/redux/popupdialog"

local UpdateScreen = Class(GenericWaitingPopup, function(self)
    GenericWaitingPopup._ctor(self, "UpdateScreen", "Скачивание обновления")
	
	if POUpdater:IsDisabled() then
		self.inst:DoTaskInTime(0, function()
			TheFrontEnd:PopScreen(self)
			TheFrontEnd:PushScreen(PopupDialogScreen("Обновление невозможно",
			"Вы находитесь на GitHub версии. Пожалуйста, обновите мод вручную, или используйте версию из воркшопа.",
				{
					{text="Понятно", cb = function()
						TheFrontEnd:PopScreen()
					end},
				}
			))
		end)
	else
		self.dialog.title:SetString("Проверка версии")
	
		POUpdater:ShouldUpdate(function(val)
			if val then
				self.dialog.title:SetString("Скачивание обновления")
				
				local function OnUpdateDone(_, updated)
					self.inst:RemoveEventCallback("rlp_updated", OnUpdateDone, TheGlobalInstance)
			
					TheFrontEnd:PopScreen(self)
					TheFrontEnd:PushScreen(PopupDialogScreen("Обновление завершено", updated and 
					"Перевод успешно загружен. Для того, чтобы изменения вступили в силу, необходимо перезапустить игру." or
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
				end
				
				self.inst:ListenForEvent("rlp_updated", OnUpdateDone, TheGlobalInstance)
				POUpdater:StartUpdating(true)
			else
				TheFrontEnd:PopScreen(self)
				TheFrontEnd:PushScreen(PopupDialogScreen("Перевод уже обновлен",
				"У вас уже и так установлена последняя версия перевода",
					{
						{text="Ура!", cb = function()
							TheFrontEnd:PopScreen()
						end},
					}
				))
			end
		end)
		
		POUpdater:StartUpdating()
	end
end)

function UpdateScreen:OnCancel()
    self:Disable()
	POUpdater:CancelDownloading()
    TheFrontEnd:PopScreen()
end

return UpdateScreen
