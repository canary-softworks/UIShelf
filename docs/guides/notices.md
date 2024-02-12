# Add Notices

Since the chat icon in the topbar has notices when the player hasn't opened their chat, so do UIShelf icons. These notices are created 1:1 with the original and by default have a notice cap of 99. This means when 100 notices is hit, the display will turn into 99+ instead of 100. Notifications aren't technically 'capped', rather just a display cap.

The API to add notices takes two parameters;

1. The amount of notices to add, leaving nil is 1
2. The notice cap, leaving nil is 99

Here's an example of a single notice being added when the icon is clicked:

```lua
local Icon = UIShelf.CreateIcon({
	Name = "MyFavoriteIcon",
	Image = "rbxassetid://12515281752",
	Order = 1,
	Area = UIShelf.Area.Left,
})

Icon.Activated:Connect(function() 
	Icon:SetIconNotices(1, nil) -- Prefered to leave nil if you don't need to change the limit. This cuts down on string interpolation since the result is cached
end)
```

This will have the desired effect of adding a notice once per click/activation.