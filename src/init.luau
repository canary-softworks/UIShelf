local UIShelf = {}
local Icon = {}
local Spacer = {}

-- // Variables

Spacer.__index = Spacer
Icon.__index = Icon
UIShelf.TopBarEnabled = true

local PlayerService = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

assert(RunService:IsClient(), "UI can only be handled on the client")

local CurrentCamera = workspace.CurrentCamera

local Player = PlayerService.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local TopbarScreenGui = require(script.TopBarApp):Clone()
local TooltipScreenGui = require(script.TooltipLayer):Clone()

local TopBarFrame = TopbarScreenGui:WaitForChild("TopBarFrame") :: Frame
local LeftFrame = TopBarFrame:WaitForChild("LeftFrame") :: Frame
local RightFrame = TopBarFrame:WaitForChild("RightFrame") :: Frame

local TopbarIconBadge = require(script.Badge)
local TopbarIcon = require(script.Icon)
local TopbarSpacer = require(script.Spacer)
local IconTooltip = require(script.Tooltip)
local MenuObject = require(script.MenuObject)
local SelectionImageObject = require(script.SelectionImageObject)
local MenuSelectionImageObject = require(script.SelectionImageObjectMenu)

local Signal = require(script.Parent.Signal)

local DEFAULT_TRANSPARENCYOUT_TWEENINFO = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local DEFAULT_TRANSPARENCYIN_TWEENINFO = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local NOTICE_UI_PADDING = 14
local NOTICE_UI_MARGIN = 24
local NOTICE_UI_MARGIN_24X24 = 0
local DEFAULT_ICON_SIZE = 44

local STATEOVERLAY_PROPERTIES: {[Enum.GuiState]: {any}} = {
	[Enum.GuiState.Idle] = {
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	},
	[Enum.GuiState.Hover] = {
		BackgroundTransparency = 0.9,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	},
	[Enum.GuiState.Press] = {
		BackgroundTransparency = 0.7,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	},
}

local STATEOVERLAY_MENU_PROPERTIES: {[Enum.GuiState]: {any}} = {
	[Enum.GuiState.Idle] = {
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	},
	[Enum.GuiState.Hover] = {
		BackgroundTransparency = 0.9,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	},
	[Enum.GuiState.Press] = {
		BackgroundTransparency = 0.7,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	},
}

local DISALLOWED_NAMES = {
	"LeftFrame",
	"RightFrame",
	"Layout"
}

local KEYCODE_TRANSLATIONS = {
	[Enum.KeyCode.Escape] = "Esc",
	[Enum.KeyCode.Backquote] = "`",
}

local DEFAULT_ICON_SIZE_UDIM = UDim2.fromOffset(DEFAULT_ICON_SIZE, DEFAULT_ICON_SIZE)

local DEFAULT_PADDING_SIZE_LEFT_UDIM,
_DEFAULT_PADDING_SIZE_RIGHT_UDIM = UDim.new(0, 42), UDim.new(0, 12)

local NOIMAGE_PADDING_SIZE_LEFT_UDIM,
NOIMAGE_PADDING_SIZE_RIGHT_UDIM = UDim.new(0, 12), UDim.new(0, 12)

local NOIMAGE_ICON_SIZE_UDIM = UDim2.fromOffset(0, DEFAULT_ICON_SIZE)

local INITIAL_TOPBAR_INSET = GuiService:GetGuiInset()
local BUTTON_OFFSET = INITIAL_TOPBAR_INSET.Y - (44 + 2)

local CurrentlyOpenMenu = {Button = nil, Menu = nil}

for _, object in TopbarScreenGui:GetDescendants() do
	if object:IsA("UIListLayout") then
		object.Padding = UDim.new(0, BUTTON_OFFSET)
	end
end

if BUTTON_OFFSET == 6 and INITIAL_TOPBAR_INSET.Y > 36 then
	local NewNegativePadding = Instance.new("UIPadding")
	NewNegativePadding.PaddingLeft = UDim.new(0, -6)
	NewNegativePadding.Parent = LeftFrame
end

TopbarScreenGui.Parent = PlayerGui
TooltipScreenGui.Parent = PlayerGui

-- // Types

type IconProperties = {
	Name: string,
	Image: string | number?,
	Order: number,
	Area: number,
	Text: string?,
	Font: Font | Enum.Font?,
}

type SpacerProperties = {
	Name: string,
	Order: number,
	Area: number,
}

type MenuItemProperties = {
	Name: string,
	Image: string | number,
}

-- // Functions

local function UpdateTopbar()
	local Inset = GuiService.TopbarInset

	TopBarFrame.Size = UDim2.fromOffset(
		Inset.Width, TopBarFrame.Size.Y.Offset
	)
end

local function ConflictingOrderCheck(icon: Frame)
	for _, element in TopbarScreenGui:GetDescendants() do
		if element:IsA("Frame") and element ~= icon and not table.find(DISALLOWED_NAMES, element.Name) then
			if element.LayoutOrder == icon.LayoutOrder and element:GetAttribute("Area") == icon:GetAttribute("Area") then
				error(`Cannot have two conflicting orders with spacers/icons! ({element.Name} and {icon.Name})`, 0)
			end
		end
	end
end

local function SetTopbar(enabled: boolean)
	TopbarScreenGui.Enabled = enabled
	UIShelf.TopBarEnabled = enabled
end

local function NewMenuItem(properties: MenuItemProperties)
	local MenuItemObject = { }

	if type(properties.Image) == "number" then
		properties.Image = `rbxassetid://{properties.Image}`
	end

	MenuItemObject.Name = properties.Name
	MenuItemObject.Image = properties.Image

	MenuItemObject.Activated = Signal() :: Signal.Signal<>

	return MenuItemObject
end

local function NewIcon(properties: IconProperties)
	local self = setmetatable({ }, Icon)
	local IconClone = TopbarIcon:Clone()

	local IconBackground = IconClone:WaitForChild("Background") :: ImageButton
	local IconImage = IconBackground:WaitForChild("Icon") :: ImageLabel
	
	IconBackground.SelectionImageObject = SelectionImageObject

	self._Element = IconClone
	self._Tooltip = nil
	self._TooltipTweens = nil
	self.TooltipText = ""
	
	self.Name = nil
	self.Image = nil
	self.Order = nil
	self.Area = nil
	self.Text = nil
	
	self.TextEnabled = if properties.Text then true else false
	self.ImageEnabled = if properties.Image then true else false
	
	self.StateChanged = Signal() :: Signal.Signal<Enum.GuiState>
	self.Activated = Signal() :: Signal.Signal<InputObject>
	self.NoticeAdded = Signal() :: Signal.Signal<number>
	self.NoticeRemoving = Signal() :: Signal.Signal<number?>

	self.NoticeCap = "99+"
	self.NoticeCapNum = 99

	self.CurrentState = Enum.GuiState.Idle
	self.TooltipEnabledNextHover = true

	self._KeyCodeConnection = nil
	self._NoticeConnection = nil
	self._TooltipConnection = nil
	self._GuiBindConnection = nil
	self._PositionConnection = nil
	self._MouseUpConnection = nil -- guistate isn't sufficient enough to replace this
	
	if type(properties.Image) == "number" then
		properties.Image = `rbxassetid://{properties.Image}`
	end

	if properties.Order <= 0 then
		error("Order cannot be less than 0", 0)
	end

	if properties.Area == 2 then
		properties.Order = -properties.Order
	end

	for name, value in properties :: any do
		self[name] = value
	end

	IconBackground.Activated:Connect(function(inputObject)
		self.Activated:Fire(inputObject)
	end)
	
	self:SetText(properties.Text, properties.Font)
	self:SetImage(properties.Image)

	IconBackground:GetPropertyChangedSignal("GuiState"):Connect(function()
		self:UpdateStateOverlay(IconBackground.GuiState)

		if not self._Tooltip then
			return
		end

		local CurrentState = IconBackground.GuiState

		if CurrentState == Enum.GuiState.Idle then
			self.TooltipEnabledNextHover = true
			self:SetTooltipEnabled(false)
			return
		end
		
		task.wait(0.75)

		if self.CurrentState == Enum.GuiState.Hover and self._Tooltip and self.TooltipEnabledNextHover then
			self:SetTooltipEnabled(true)
		end
	end)

	if self.Area == 1 then
		assert(not LeftFrame:FindFirstChild(properties.Name), "Cannot have duplicate icon/unibar names in left frame")
		IconClone.Parent = LeftFrame
	elseif self.Area == 2 then
		assert(not RightFrame:FindFirstChild(properties.Name), "Cannot have duplicate icon/unibar names in right frame")
		IconClone.Parent = RightFrame
	end

	if table.find(DISALLOWED_NAMES, properties.Name) then
		error(`{properties.Name} is part of the reserved naming list`, 0)
	end

	IconClone:SetAttribute("Notices", 0)
	IconClone:SetAttribute("Area", properties.Area)

	IconClone.Name = properties.Name
	IconClone.LayoutOrder = properties.Order

	ConflictingOrderCheck(self._Element)
	
	if properties.Image then
		IconImage.Image = properties.Image
	end

	self._Element.Size = UDim2.fromOffset(IconBackground.AbsoluteSize.X, 44)
	
	return self
end

function NewSpacer(properties: SpacerProperties)
	local self = setmetatable({ }, Spacer)
	local SpacerClone = TopbarSpacer:Clone()

	if properties.Order <= 0 then
		error("Order cannot be less than 0", 0)
	end

	if properties.Area == 2 then
		properties.Order = -properties.Order
	end

	self._Element = SpacerClone
	self.Name = properties.Name
	self.Order = properties.Order
	self.Area = properties.Area

	if self.Area == 1 then
		SpacerClone.Parent = LeftFrame
	elseif self.Area == 2 then
		SpacerClone.Parent = RightFrame
	end

	SpacerClone.Name = properties.Name
	SpacerClone.LayoutOrder = properties.Order

	ConflictingOrderCheck(self._Element)

	return self
end

function Icon:SetEnabled(enabled: boolean)
	self._Element.Visible = enabled
end

function Icon:BindGuiObject(guiObject: GuiObject?)
	if not guiObject then
		self._GuiBindConnection:Disconnect()
		return
	end

	if not self._GuiBindConnection then
		self._GuiBindConnection = self.Activated:Connect(function()
			guiObject.Visible = not guiObject.Visible
		end)
	end
end

function Icon:SetText(text: string?, textFont: Enum.Font | Font?)
	local IconBackground = self._Element.Background
	local IconText = IconBackground.Text
	
	if not text then
		assert(self.ImageEnabled, "Must have at least image or text on icon")
		self.ImageEnabled = true
		IconText.Visible = false
			
		UpdateTopbar()
		self.TextEnabled = false
		self._Element.Size = UDim2.fromOffset(IconBackground.AbsoluteSize.X, 44)
		return
	end
	
	self.TextEnabled = true
	
	IconBackground.Text.Visible = true
	IconBackground.Text.Text = text

	if textFont then
		IconBackground.Text.FontFace = if typeof(textFont) == "Font" then textFont else Font.fromEnum(textFont)
	end

	if not self.ImageEnabled then
		self.ImageEnabled = false
		IconBackground.Text.Inset.PaddingLeft = NOIMAGE_PADDING_SIZE_LEFT_UDIM
		IconBackground.Text.Inset.PaddingRight = NOIMAGE_PADDING_SIZE_RIGHT_UDIM
		IconBackground.Size = NOIMAGE_ICON_SIZE_UDIM
	end

	UpdateTopbar()
	self._Element.Size = UDim2.fromOffset(IconBackground.AbsoluteSize.X, 44)
end

function Icon:SetImage(image: string | number?)
	local IconBackground = self._Element.Background
	local IconText = IconBackground.Text
	local IconImage = IconBackground.Icon
	
	if not image then
		assert(self.TextEnabled, "Must have at least image or text on icon")
		IconImage.Image = ""
		self.TextEnabled = true
		IconText.Inset.PaddingLeft = NOIMAGE_PADDING_SIZE_LEFT_UDIM
		IconText.Inset.PaddingRight = NOIMAGE_PADDING_SIZE_RIGHT_UDIM
			
		IconBackground.Size = NOIMAGE_ICON_SIZE_UDIM
		UpdateTopbar()
		self.ImageEnabled = false
		self._Element.Size = UDim2.fromOffset(IconBackground.AbsoluteSize.X, 44)
		return
	end
	
	self.ImageEnabled = true
	IconText.Inset.PaddingLeft = DEFAULT_PADDING_SIZE_LEFT_UDIM
	
	if type(image) == "number" then
		image = `rbxassetid://{image}`
	end
	
	IconImage.Image = image
	IconBackground.Size = DEFAULT_ICON_SIZE_UDIM
	
	UpdateTopbar()
	self._Element.Size = UDim2.fromOffset(IconBackground.AbsoluteSize.X, 44)
end

function Icon:SetTooltip(text: string?)
	if not text then
		self._Tooltip:Destroy()
		self._Tooltip = nil

		for _, tween in self._TooltipTweens do
			tween:Destroy()
		end

		table.clear(self._TooltipTweens)
		return
	end

	if not self._Tooltip then
		self._Tooltip = IconTooltip:Clone()
		self._Tooltip.Parent = TooltipScreenGui

		self._TooltipTweens = {
			[false] = TweenService:Create(self._Tooltip, DEFAULT_TRANSPARENCYOUT_TWEENINFO, {
				GroupTransparency = 1
			}),
			[true] = TweenService:Create(self._Tooltip, DEFAULT_TRANSPARENCYIN_TWEENINFO, {
				GroupTransparency = 0
			}),
		}
	end

	local IconTooltipElement = self._Tooltip
	local TooltipHeader = IconTooltipElement.Box.Header
	local TooltipCaret = IconTooltipElement.Caret
	local TopBarIcon = self._Element

	if TooltipHeader.Text == text then
		return
	end

	TooltipHeader.Text = text
	IconTooltipElement.Name = self.Name

	local TOOLTIP_POSITION = TopBarIcon.AbsolutePosition.X + (TopBarIcon.AbsoluteSize.X / 2)
	local SHADOW_SIZE = UDim2.fromOffset(self._Tooltip.Box.AbsoluteSize.X + 8, self._Tooltip.Box.AbsoluteSize.Y + 8)

	IconTooltipElement.Position = UDim2.fromOffset(TOOLTIP_POSITION, 56)
	IconTooltipElement.Size = UDim2.fromOffset(self._Tooltip.Box.AbsoluteSize.X + 8, 53)
	IconTooltipElement.DropShadow.Size = SHADOW_SIZE

	TooltipCaret.Position = UDim2.fromOffset(TOOLTIP_POSITION - IconTooltipElement.AbsolutePosition.X, 4)

	self.MouseUpConnection = self._Element.Background.MouseButton1Up:Connect(function()
		self:SetTooltipEnabled(false)
		self.TooltipEnabledNextHover = false
	end)

	if self.Area == 2 and self._Element.LayoutOrder <= -1 then
		TooltipCaret.Position = UDim2.fromOffset(
			IconTooltipElement.Box.AbsoluteSize.X - 22, 4
		)

		IconTooltipElement.Position = UDim2.fromOffset(
			CurrentCamera.ViewportSize.X - 8 - (IconTooltipElement.Box.AbsoluteSize.X / 2), 56
		)
		
		UpdateTopbar()
		return
	end

	self._PositionConnection = self._Element:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		IconTooltipElement.Position = UDim2.fromOffset(
			TopBarIcon.AbsolutePosition.X + (TopBarIcon.AbsoluteSize.X / 2),
		 	if IconTooltipElement.Visible then 60 else 56
		)
	end)

	UpdateTopbar()
end

function Icon:SetTooltipEnabled(enabled: boolean)
	assert(self._Tooltip, "Icon must already have a tooltip set")

	self._Tooltip:TweenPosition(
		UDim2.fromOffset(self._Tooltip.Position.X.Offset, if enabled then 60 else 56),
		if enabled then Enum.EasingDirection.In else Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.15
	)

	if enabled then
		self._Tooltip.Visible = enabled
		self._TooltipTweens[enabled]:Play()
	else
		self._TooltipTweens[enabled]:Play()
		task.delay(0.15, function()
			self._Tooltip.Visible = enabled
		end)
	end
end

function Icon:NewMenu(menuContents: {{[string]: any}})
	local TopBarIcon = self._Element
	local MenuContainer = TopBarIcon.MenuContainer

	if MenuContainer.ScrollingFrame:FindFirstChildOfClass("ImageButton") then
		for _, instance in MenuContainer.ScrollingFrame:GetChildren() do
			if instance:IsA("ImageButton") then
				instance:Destroy()
			end
		end
	end

	for _, menuContents in menuContents do
		local MenuObjectClone = MenuObject:Clone()
		local MenuObjectLabel = MenuObjectClone.StyledTextLabel
		local MenuObjectIcon = MenuObjectClone.IconHost.IntegrationIconFrame.IntegrationIcon

		MenuObjectClone:GetPropertyChangedSignal("GuiState"):Connect(function()
			self:UpdateStateOverlayMenu(MenuObjectClone.GuiState, MenuObjectClone)
		end)

		MenuObjectClone.MouseButton1Up:Connect(function()
			MenuContainer.Visible = false
			menuContents.Activated:Fire()
		end)

		MenuObjectClone.Name = string.lower(menuContents.Name)
		MenuObjectClone.SelectionImageObject = MenuSelectionImageObject
		MenuObjectLabel.Text = menuContents.Name
		MenuObjectIcon.Image = menuContents.Image

		MenuObjectClone.Parent = MenuContainer.ScrollingFrame
	end

	MenuContainer.Position = UDim2.new(1, 0, 0, 54)
	
	if self.Area == 1 then
		MenuContainer.Position = UDim2.fromOffset(0, 54)
		MenuContainer.AnchorPoint = Vector2.new(0, 0)
	end

	self.Activated:Connect(function()
		MenuContainer.Visible = not MenuContainer.Visible
		if MenuContainer.Visible then
			CurrentlyOpenMenu.Menu = MenuContainer :: any
			CurrentlyOpenMenu.Button = self._Element :: any
		else
			CurrentlyOpenMenu.Menu = nil
			CurrentlyOpenMenu.Button = nil
		end
	end)
end

function Icon:UpdateStateOverlayMenu(newState: Enum.GuiState, button: any)
	for property, value in STATEOVERLAY_MENU_PROPERTIES[newState] do
		if button[property] then
			button[property] = value
		end
	end
end

function Icon:UpdateStateOverlay(newState: Enum.GuiState)
	local IconBackground = self._Element:FindFirstChild("Background")
	
	if not IconBackground then
		return
	end

	local IconStateOverlay = IconBackground.StateOverlayRound

	if newState == Enum.GuiState.Press and UserInputService.TouchEnabled then
		IconStateOverlay.Transparency = 0.7
		IconStateOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		return
	end

	for property, value in STATEOVERLAY_PROPERTIES[newState] do
		IconStateOverlay[property] = value
	end

	self.CurrentState = newState
	self.StateChanged:Fire(newState)
end

function Icon:SetImageRect(rectSize: Rect, rectOffset: Rect)
	local IconImage = self._Element.Background.Icon

	IconImage.ImageRectOffset = rectOffset
	IconImage.ImageRectSize = rectSize
end

function Icon:GetNotices(): number
	return self._Element:GetAttribute("Notices")
end

function Icon:AddNotices(notices: number?, noticeCap: number?)
	noticeCap = noticeCap or 99
	notices = notices or 1

	if notices and notices <= 0 then
		error("Cannot notify 0 notifications", 0)
		return
	end

	local TopBarIcon = self._Element
	local BadgeContainer = TopBarIcon.BadgeContainer
	
	if not TopbarIcon:GetAttribute("Notices") then
		TopbarIcon:SetAttribute("Notices", 0)
	end

	if not BadgeContainer:FindFirstChild("Badge") then
		local TopbarIconBadgeClone = TopbarIconBadge:Clone()
		TopbarIconBadgeClone.Parent = BadgeContainer
	end

	local Badge = BadgeContainer.Badge
	local BadgeText = Badge.Inner.TextLabel

	if noticeCap and noticeCap ~= self.NoticeCapNum then
		self.NoticeCap = `{noticeCap}+`
	end

	if not self._NoticeConnection then
		self._NoticeConnection = TopBarIcon:GetAttributeChangedSignal("Notices"):Connect(function()
			local NewValue = TopBarIcon:GetAttribute("Notices")
			BadgeText.Text = NewValue

			if NewValue >= 1 then
				BadgeContainer.Visible = true
			elseif NewValue == 0 then
				BadgeContainer.Visible = false
			end

			if NewValue > noticeCap then
				BadgeText.Text = self.NoticeCap
			end
			
			if NewValue <= 9 then
				Badge.Size = UDim2.fromOffset(24, 24)
				Badge.Position = UDim2.new(1, NOTICE_UI_MARGIN_24X24, 0, 0)
				return
			end
			
			Badge.Size = UDim2.fromOffset(BadgeText.TextBounds.X + NOTICE_UI_PADDING, 24)
			Badge.Position = UDim2.new(1, BadgeText.TextBounds.X + NOTICE_UI_PADDING - NOTICE_UI_MARGIN, 0, 0)
		end)
	end

	TopBarIcon:SetAttribute("Notices", TopBarIcon:GetAttribute("Notices") + notices)
	self.NoticeAdded:Fire(TopBarIcon:GetAttribute("Notices"))
end

function Icon:RemoveNotices(notices: number?)
	local TopBarIcon = self._Element

	self.NoticeRemoving:Fire(notices)
	if not notices then
		TopBarIcon:SetAttribute("Notices", 0)
		return
	end

	if notices <= 0 then
		error("Cannot remove 0 notifications", 0)
		return
	end

	TopBarIcon:SetAttribute(
		"Notices",
		TopBarIcon:GetAttribute("Notices") - notices
	)
end

function Icon:BindKeyCode(keyCode: Enum.KeyCode?)
	if not keyCode then
		if self._Tooltip then
			local HotKeyFrame = self._Tooltip.Box.Hotkeys
			local FirstHotKey = HotKeyFrame["1"]

			HotKeyFrame.Visible = false
			FirstHotKey.LabelContent.Text = "nil"
		end

		if self._KeyCodeConnection then
			self._KeyCodeConnection:Disconnect()
		end
		
		return
	end

	if self._Tooltip then
		local HotKeyFrame = self._Tooltip.Box.Hotkeys
		local FirstHotKey = HotKeyFrame["1"]
		local KeyCodeName = if KEYCODE_TRANSLATIONS[keyCode] then KEYCODE_TRANSLATIONS[keyCode] else keyCode.Name
		
		HotKeyFrame.Visible = true
		FirstHotKey.LabelContent.Text = KeyCodeName

		local SHADOW_SIZE = UDim2.fromOffset(self._Tooltip.Box.AbsoluteSize.X + 8, self._Tooltip.Box.AbsoluteSize.Y + 8)
		self._Tooltip.DropShadow.Size = SHADOW_SIZE
	end

	self._KeyCodeConnection = UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) 
		if gameProcessedEvent then
			return
		end

		if input.KeyCode == keyCode then
			self.Activated:Fire(input.UserInputType)
		end
	end)
end

function Icon:SetImageSize(imageSize: Vector2)
	local TopBarIcon = self._Element
	local TopBarIconImage = TopBarIcon.Background.Icon

	TopBarIconImage.Size = UDim2.fromOffset(imageSize.X, imageSize.Y)
end

function Icon:Destroy()
	if self._KeyCodeConnection then
		self._KeyCodeConnection:Disconnect()
	end

	if self._NoticeConnection then
		self._NoticeConnection:Disconnect()
	end

	for _, value in self do
		if typeof(value) == "Instance" then
			value:Destroy()
			continue
		end

		self[value] = nil
	end

	setmetatable(self, nil)
end

function Spacer:SetEnabled(enabled: boolean)
	local TopBarSpacer = self._Element

	TopBarSpacer.Visible = enabled
end

function Spacer:SetSize(size: number)
	local TopBarSpacer = self._Element

	TopBarSpacer.Size = UDim2.fromOffset(size, TopBarSpacer.Size.Y.Offset)
end

function Spacer:Destroy()
	for _, value in self do
		if typeof(value) == "Instance" then
			value:Destroy()
			continue
		end

		self[value] = nil
	end

	setmetatable(self, nil)
end

-- // Connections

GuiService.MenuOpened:Connect(function()
	TopbarScreenGui.Enabled = false
	TooltipScreenGui.Enabled = false
end)

GuiService.MenuClosed:Connect(function()
	TopbarScreenGui.Enabled = UIShelf.TopBarEnabled
	TooltipScreenGui.Enabled = UIShelf.TopBarEnabled
end)

GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(UpdateTopbar)

RunService.Heartbeat:Connect(function()
	if not GuiService.SelectedObject then
		return
	end
	
	MenuSelectionImageObject.UIStroke.GradientChild.Rotation += 1
	SelectionImageObject.UIStroke.GradientChild.Rotation += 1
end)

UserInputService.InputBegan:Connect(function(input)
	if not (CurrentlyOpenMenu.Button and CurrentlyOpenMenu.Menu) then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end
	
	local Position = input.Position
	local GuiObjectsAtPosition = PlayerGui:GetGuiObjectsAtPosition(Position.X, Position.Y)
	
	if not (table.find(GuiObjectsAtPosition, CurrentlyOpenMenu.Button) or table.find(GuiObjectsAtPosition, CurrentlyOpenMenu.Menu)) then
		CurrentlyOpenMenu.Menu.Visible = false
	end
end)

-- // Actions

UpdateTopbar()

return {
	Spacer = NewSpacer,
	Icon = NewIcon,
	MenuItem = NewMenuItem,
	SetTopbar = SetTopbar,
	Area = {Left = 1, Right = 2},
}