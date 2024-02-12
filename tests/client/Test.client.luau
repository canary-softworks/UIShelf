local UIShelf = require(game:GetService("ReplicatedStorage").Packages.UIShelf)

local Icon1 = UIShelf.Icon({
	Name = "Icon1",
	Image = 12797061582,
	Order = 1,
	Area = UIShelf.Area.Left,
})

local Icon2 = UIShelf.Icon({
	Name = "Icon2",
	Image = 12663166329,
	Order = 1,
	Area = UIShelf.Area.Right,
})

local Icon3 = UIShelf.Icon({
	Name = "Icon3",
	Image = "rbxassetid://12515281752",
	Order = 2,
	Area = UIShelf.Area.Left,
	Text = "Text Icon"
})

UIShelf.Icon({
	Name = "Icon4",
	Order = 3,
	Area = UIShelf.Area.Left,
	Text = "Creepy Text Icon 👻",
	Font = Enum.Font.Creepster
})

Icon3:SetTooltip("Tooltip w/ Keycode")
Icon3:BindKeyCode(Enum.KeyCode.Q)
Icon1:SetTooltip("Normal Tooltip")

local Menu1 = UIShelf.MenuItem({
	Name = "Item 1",
	Image = "rbxassetid://14187970401"
})

local Menu2 = UIShelf.MenuItem({
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