local UnibarToggleButton = Instance.new("Frame")
UnibarToggleButton.Name = "UnibarToggleButton"
UnibarToggleButton.BackgroundTransparency = 1
UnibarToggleButton.BorderSizePixel = 0
UnibarToggleButton.LayoutOrder = 1
UnibarToggleButton.Size = UDim2.fromOffset(44, 44)

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

Highlighter.Parent = UnibarToggleButton

local Background = Instance.new("ImageButton")
Background.Name = "Background"
Background.BackgroundTransparency = 1
Background.BorderSizePixel = 0
Background.SelectionOrder = 99
Background.Size = UDim2.fromScale(1, 1)
Background.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
Background.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
Background.SelectionGroup = true
Background.Parent = UnibarToggleButton

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

local Icon = Instance.new("Frame")
Icon.Name = "Icon"
Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Icon.BackgroundTransparency = 1
Icon.BorderSizePixel = 0
Icon.Size = UDim2.fromOffset(36, 36)

local Corner1 = Instance.new("UICorner")
Corner1.Name = "Corner"
Corner1.CornerRadius = UDim.new(1, 0)
Corner1.Parent = Icon

local Cube = Instance.new("ImageLabel")
Cube.Name = "Image"
Cube.AnchorPoint = Vector2.new(0.5, 0.5)
Cube.BackgroundTransparency = 1
Cube.Position = UDim2.fromScale(0.5, 0.5)
Cube.Size = UDim2.fromOffset(24, 24)
Cube.Parent = Icon

local X1 = Instance.new("Frame")
X1.Name = "X1"
X1.AnchorPoint = Vector2.new(0.5, 0)
X1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
X1.BorderSizePixel = 0
X1.Position = UDim2.fromScale(0.5, 0.5)
X1.Rotation = 45
X1.Size = UDim2.fromOffset(16, 2)
X1.Visible = false
X1.Parent = Icon

local X2 = Instance.new("Frame")
X2.Name = "X2"
X2.AnchorPoint = Vector2.new(0.5, 0)
X2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
X2.BorderSizePixel = 0
X2.Position = UDim2.fromScale(0.5, 0.5)
X2.Rotation = -45
X2.Size = UDim2.fromOffset(16, 2)
X2.Visible = false
X2.Parent = Icon

Icon.Parent = IconFrame

IconFrame.Parent = UnibarToggleButton

return UnibarToggleButton