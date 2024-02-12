# Creation of Objects

Creating an icon or spacer is rather simple, all it requires is a few arguments wrapped in a table:

### Icons

When inputting these into your table, they must be in correct order or the code will malfunction. The image can either be an id or a direct URI. The order is basically just the layout order, and will be correctly accomodated for depending on if it was placed on the left/right. The `Area` element decides which side the icon is on, `1` is the left side, while `2` is the right side. You can also use `UIShelf.HorizontalAlignment` if it's easier to remember.

If you're confused, here is an example of it layed out:

```lua
local Icon = UIShelf.CreateIcon({
	Name = "MyFavoriteIcon",
	Image = "rbxassetid://12515281752",
	Order = 1,
	Area = UIShelf.Area.Left,
})
```

This will create a new and basic topbar icon on the left side of the screen, with an order of `1`.

### Spacers

A UIShelf spacer object is what it is says it is: *it's a spacer.* This allows you to create spacers for other topbar items, such as an HD Admin topbar item. Please keep in mind that spacers and icons are mixed, so it's important to account for different orders.

An example spacer, requires no other functions to run:

```lua
local Spacer = UIShelf.CreateSpacer({
	Name = "MySpacer",
	Order = 1,
	Area = 1,
}) -- Same format as CreateIcon, just doesn't have image URI/ID element
```