local UnibarDivider = Instance.new("Frame")
UnibarDivider.Name = "UnibarDivider"
UnibarDivider.BackgroundTransparency = 1
UnibarDivider.BorderSizePixel = 0
UnibarDivider.LayoutOrder = 2
UnibarDivider.Position = UDim2.fromOffset(181, 0)
UnibarDivider.Size = UDim2.new(0, 5, 1, 0)

local DividerBar = Instance.new("Frame")
DividerBar.Name = "DividerBar"
DividerBar.AnchorPoint = Vector2.new(0, 0.5)
DividerBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DividerBar.BackgroundTransparency = 0.8
DividerBar.BorderSizePixel = 0
DividerBar.Position = UDim2.new(0, 2, 0.5, 0)
DividerBar.Size = UDim2.fromOffset(1, 28)
DividerBar.Parent = UnibarDivider

return UnibarDivider