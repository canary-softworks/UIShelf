local UnibarButton = Instance.new("Frame")
UnibarButton.Name = "UnibarButton"
UnibarButton.BackgroundTransparency = 1
UnibarButton.BorderSizePixel = 0
UnibarButton.LayoutOrder = 3
UnibarButton.Position = UDim2.fromOffset(88, 0)
UnibarButton.Size = UDim2.fromOffset(44, 44)
UnibarButton.ZIndex = 3

local IconFrame = Instance.new("Frame")
IconFrame.Name = "IconFrame"
IconFrame.BackgroundTransparency = 1
IconFrame.BorderSizePixel = 0
IconFrame.Size = UDim2.fromScale(1, 1)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Name = "UIListLayout"
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = IconFrame

local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.BackgroundTransparency = 1
Icon.Size = UDim2.fromOffset(36, 36)
Icon.Parent = IconFrame

IconFrame.Parent = UnibarButton

local Highlighter = Instance.new("Frame")
Highlighter.Name = "Highlighter"
Highlighter.AnchorPoint = Vector2.new(0.5, 0.5)
Highlighter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Highlighter.BackgroundTransparency = 0.9
Highlighter.BorderSizePixel = 0
Highlighter.Position = UDim2.fromScale(0.5, 0.5)
Highlighter.Size = UDim2.fromOffset(36, 36)
Highlighter.Visible = false

local Corner = Instance.new("UICorner")
Corner.Name = "corner"
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Highlighter

Highlighter.Parent = UnibarButton

local Background = Instance.new("ImageButton")
Background.Name = "Background"
Background.BackgroundTransparency = 1
Background.BorderSizePixel = 0
Background.SelectionOrder = 97
Background.Size = UDim2.fromScale(1, 1)
Background.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
Background.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
Background.SelectionGroup = true
Background.Parent = UnibarButton

return UnibarButton