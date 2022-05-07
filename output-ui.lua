-- Custom VSB Output UI by Darkceius
-- plz ignore my PascalCase variables and stuff!! i made this like 9999 weeks ago and um i use camcelCase now ok stupid


if not game:GetService("RunService"):IsClient() then
	return error("Must be ran using l/ or rl/")
end

local Tween = game:GetService("TweenService")

local UI = owner.PlayerGui:FindFirstChild("SB_OutputGUI")

local Main = UI.Main
local Control = Main.Control
local Output = Main.Output
local Scripts = Main.Scripts

local Task = UI.Task

local Theme = Color3.fromRGB(85, 170, 255)

Task.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Main.BackgroundColor3 = Color3.fromRGB(26, 26, 26)

UI.Tip.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
UI.Tip.BackgroundTransparency = .3
UI.Tip.TextColor3 = Theme

Task.UICorner.CornerRadius = UDim.new(0, 5)
Main.UICorner.CornerRadius = UDim.new(0, 5)

Control.ToolMode.Visible = false

function HandleButton(btn)
	for i,v in pairs(btn:GetDescendants()) do
		if v.Name:sub(1,2)=="m-" then
			v:Destroy()
		end
	end

	btn.Style = Enum.ButtonStyle.RobloxButton
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 17

	if btn.Name == "TogglePlayerGui" then
		local Box = btn.Box
		Box.BackgroundColor3 = Color3.new(0.164706, 0.164706, 0.164706)
		Box.BackgroundTransparency = .5
		Box.Image.Image = "rbxassetid://82724486"
		Box.Image.ImageColor3 = Theme
	end

	btn.MouseEnter:Connect(function()
		Tween:Create(btn, TweenInfo.new(.3), {
			TextColor3 = Theme
		}):Play()
	end)
	btn.MouseLeave:Connect(function()
		Tween:Create(btn, TweenInfo.new(.3), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end)
end

Control.UIListLayout.Padding = UDim.new(0, 1)

Output.Header.Line.Visible = false
Output.Header.FPS.Visible = false

do
	local function HandleLine(v)
		v.Visible = true
		v.BackgroundColor3 = Color3.fromRGB(155,155,155)
	end

	HandleLine(Main.Line)
	HandleLine(Scripts.Line)
	HandleLine(Output.Line)
end

do
	local Entries = Output.Entries

	local function Connect(v)
		local function res()
			if v.TextColor3 == Color3.fromRGB(0, 255, 0) then
				v.TextColor3 = Color3.fromRGB(85, 255, 127)
			end
			if v.TextColor3 == Color3.fromRGB(102, 127, 255) then
				v.TextColor3 = Theme
			end

			if v.TextColor3 == Color3.fromRGB(255, 25, 25) then
				v.TextColor3 = Color3.fromRGB(255, 64, 64)
			end
		end

		res()
		v.RichText = true
		v.Changed:Connect(function(a)
			if a == "TextColor3" then res() end
		end)
	end

	task.spawn(function()
		for i,v in pairs(Entries:GetChildren()) do
			Connect(v)
		end
	end)
	Entries.ChildAdded:Connect(Connect)
end

do
	local Entries = Scripts.Entries

	local function Connect(v)
		if v:IsA("UIListLayout") then
			return
		end
		local function res()
			if v.TextColor3 == Color3.fromRGB(0, 255, 0) then
				Tween:Create(v, TweenInfo.new(.3), {TextColor3=Theme}):Play()
			end
		end
		
		res()
		v.Changed:Connect(function(a)
			if a == "TextColor3" then res() end
		end)
	end

	task.spawn(function()
		for i,v in pairs(Entries:GetChildren()) do
			Connect(v)
			task.wait()
		end
	end)
	Entries.ChildAdded:Connect(Connect)
end

Output.Entries.ScrollBarImageColor3 = Theme
Output.Entries.ScrollBarThickness = 1
UI.Oof.Visible = true

Scripts.Entries.ScrollBarImageColor3 = Theme
if Scripts.Entries.ScrollBarThickness ~= 0 then
	Scripts.Entries.ScrollBarThickness = 1
end
Scripts.Entries.Changed:Connect(function(a)
	if a == "ScrollBarThickness" then
		if Scripts.Entries.ScrollBarThickness ~= 0 then
			Scripts.Entries.ScrollBarThickness = 1
		end
	end
end)

Control.ToggleTheme.Visible = true
Control.ToggleTheme.Text = "Respawn"
Control.ToggleTheme.Size = UDim2.new(0, 70, 1, 0)

local Server = NS([[
local Remote = Instance.new("RemoteEvent", script)
Remote.Name = "Respawn"

Remote.OnServerEvent:Connect(function(a)
if a == owner then owner:LoadCharacter() end
end)
]], workspace)

Control.ToggleTheme.MouseButton1Down:Connect(function()
	Server:FindFirstChild("Respawn"):FireServer()
end)

for i,v in pairs(Control:GetChildren()) do if not v:IsA("UIListLayout") then HandleButton(v) end end

-- tool mode button left

warn("Thanks for loading Dark's custom output UI for VSB.")
warn("Please suggest me a feature for this script (like the respawn button). It will show as a button.")
