local UnibarMenu = Instance.new("Frame")
UnibarMenu.Name = "UnibarMenu"
UnibarMenu.AutomaticSize = Enum.AutomaticSize.XY
UnibarMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UnibarMenu.BackgroundTransparency = 0.3
UnibarMenu.BorderSizePixel = 0
UnibarMenu.LayoutOrder = 1
UnibarMenu.Size = UDim2.fromOffset(0, 44)
UnibarMenu.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
UnibarMenu.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
UnibarMenu.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
UnibarMenu.SelectionGroup = true

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = UnibarMenu

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Name = "UIListLayout"
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = UnibarMenu

return UnibarMenu