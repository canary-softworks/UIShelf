# Tooltips

Tooltips are simple popups that display below the icon when they are hovered over. Here is how you would set a tooltip for any icon:

```lua
local Icon = UIShelf.Icon({
	Name = "MyFavoriteIcon",
	Image = "rbxassetid://12515281752",
	Order = 1,
	Area = UIShelf.Area.Left,
})

Icon:SetTooltip("Example Tooltip") -- Sets the label of the tooltip also while creating it
```

UIShelf tooltips also have a feature where if you have a tooltip *and* a bound keycode, the tooltip will also display the key below the text: 

```lua
local Icon = UIShelf.Icon({
	Name = "MyFavoriteIcon",
	Image = "rbxassetid://12515281752",
	Order = 1,
	Area = UIShelf.Area.Left,
})

Icon:BindKeyCode(Enum.KeyCode.Q)
Icon:SetTooltip("Example Tooltip") -- Sets the label of the tooltip also while creating it
```

Here is it what it looks like:

![Tooltip example with keycode](uishelf-images/tooltip-example.png)
