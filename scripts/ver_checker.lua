local UpdateChecker = require("widgets/update_checker")
--А теперь виджет и принты
AddClassPostConstruct("screens/redux/multiplayermainscreen", function(self, ...)
	self.update_checker = self.fixed_root:AddChild(UpdateChecker())
	self.update_checker:SetScale(.7)
	self.update_checker:SetPosition(500, -100)
end)
