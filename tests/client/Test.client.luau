local Icon = require(game:GetService("ReplicatedStorage").Packages.UIShelf).Icon
local Spacer = require(game:GetService("ReplicatedStorage").Packages.UIShelf).Spacer

local Icon1 = Icon.new({
	Name = "Icon1",
	Image = 12797061582,
	Order = 1,
	Area = Icon.Area.Left,
})

local Icon2 = Icon.new({
	Name = "Icon2",
	Image = 12663166329,
	Order = 1,
	Area = Icon.Area.Right,
})

local Icon3 = Icon.new({
	Name = "Icon3",
	Image = "rbxassetid://12515281752",
	Order = 2,
	Area = Icon.Area.Left,
	Text = "Text Icon"
})

Icon.new({
	Name = "Icon4",
	Order = 3,
	Area = Icon.Area.Left,
	Text = "Creepy Text Icon 👻",
	Font = Enum.Font.Creepster
})

Icon3:SetTooltip("Tooltip w/ Keycode")
Icon3:BindKeyCode(Enum.KeyCode.Q)
Icon1:SetTooltip("Normal Tooltip")

local Menu1 = Icon.CreateMenuItem({
	Name = "Item 1",
	Image = "rbxassetid://14187970401"
})

local Menu2 = Icon.CreateMenuItem({
	Name = "Item 2",
	Image = "rbxassetid://14187977869"
})

Icon2:CreateMenu({
	Menu1,
	Menu2
})

Icon2:SetTooltip("Automatically Offsetted Tooltip")

Menu1.Activated:Connect(function()
	print("Menu example!")
end)

Icon3.Activated:Connect(function()
	if Icon3:GetIconNotices() == 100 then
		Icon3:RemoveIconNotices()
	end
	Icon3:AddIconNotices()
end)