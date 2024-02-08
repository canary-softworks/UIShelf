# Respond to Input

To respond to input of almost any type, you can use the `TopBarIcon.Activated` event. This event will fire every time the icon is clicked, whether that be by a mouse, keycode, touch tap, or gamepad, it will fire. This also has a [`Enum.UserInputType`](https://create.roblox.com/docs/reference/engine/enums/UserInputType) argument indicating which input type fired the event. Here's an example below, nothing special.

```lua
Icon.Activated:Connect(function(inputType) 
	print(inputType) -- Output: Enum.UserInputType.MouseButton1
end)
```