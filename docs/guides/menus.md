# Menus

To create a new menu for the icon, use the `Icon:NewMenu` method as so.

```lua
Icon:NewMenu({
    MenuItem
})
```

This method does require for you to use menuitems. These basically allow you to enter text and images into each of the individual buttons inside of the menu. They are objects that contain information useful internally. To create one, just enter the name and image. The name will be the text and the image will be what is displayed next to the text.

```lua
local MenuItem = UIShelf.MenuItem({
    Name = "My new menu!",
    Image = 1234567890
})
```