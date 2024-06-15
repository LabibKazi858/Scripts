repeat wait() until game:IsLoaded()

-- // Booting Liabery \\ --

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttwizz/Roblox/master/Orion.lua", true))()

-- // Window \\ --

local Window = OrionLib:MakeWindow({Name = "L4BIB DEMON FALL",
                                    SaveConfig = true,
                                    ConfigFolder = "L4BIB HUB",
                                    IntroText = "Your Game Your Rules",
                                    IntroIcon = "https://i.ibb.co/SXrT6fJ/Dark-Blue-Purple-White-Tactical-Gaming-Discord-Logo.png",
                                    Icon = "https://i.ibb.co/SXrT6fJ/Dark-Blue-Purple-White-Tactical-Gaming-Discord-Logo.png"})

-- // Pre Scripts \\ --
game:GetService("UserInputService").MouseIconEnabled = true  ---- Shows You Your MOUSE  FUCK THAT DEMON FALL POINTER
game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end


-- // Vars \\ --
local plr           = game:GetService("Players").LocalPlayer
local TweenService  = game:GetService("TweenService")
local noclipE       = false
local antifall      = nil
local Settings      = {}

local function noclip()
	for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		if v:IsA("BasePart") and v.CanCollide == true then
			v.CanCollide = false
		end
	end
end

local function moveto(obj, speed)
    local info = TweenInfo.new(((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude)/ speed,Enum.EasingStyle.Linear)
    local tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, info, {CFrame = obj})

    if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
        antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
        antifall.Velocity = Vector3.new(0,0,0)
        noclipE = game:GetService("RunService").Stepped:Connect(noclip)
        tween:Play()
    end

    tween.Completed:Connect(function()
        antifall:Destroy()
        noclipE:Disconnect()
    end)
end

-- // AutoFarming \\ --
local AutoFarming = Window:MakeTab({
	Name = "AutoFarm",
	Icon = "rbxassetid://4483345998",
})

AutoFarming:AddLabel("Normal Mobs")

local mob_list = {
    -- Demon List
    "Green Demon",
    "GenericOni",
    "FrostyOni",
    "Blue Demon",
    "SlayerBoss",

    -- Slayer List
    "GenericSlayer",
    "Zenitsu",
}

AutoFarming:AddDropdown({
	Name = "Select Mobs",
	Default = "1",
	Options = mob_list,
	Callback = function(v)
		Settings["ChosenMob"] = v
	end
})

AutoFarming:AddToggle({
	Name = "AutoFarm Mobs",
	Default = false,
	Callback = function(v)
		Settings["autofarm_mobs"] = v
	end
})

AutoFarming:AddLabel("Bosses")

local boss_list = {
    "Okuro",
    "Rui",
    "Lower Moon 2",
    "Lower Moon 3",
    "Akaza",
    "Doma",
    "Kokushibo",
    "Kaigaku",
    "Gyutaro",
}

AutoFarming:AddDropdown({
	Name = "Select Bosses",
	Default = "1",
	Options = boss_list,
	Callback = function(v)
		Settings["ChosenBoss"] = v
	end
})

AutoFarming:AddToggle({
	Name = "AutoFarm Bosses",
	Default = false,
	Callback = function(v)
		Settings["autofarm_boss"] = v
	end
})

AutoFarming:AddLabel("AutoFarm Settings")

AutoFarming:AddSlider({
	Name = "Teleport Speed",
	Min = 0,
	Max = 75,
	Default = 75,
	Color = Color3.fromRGB(0, 255, 255),
	Increment = 1,
	Callback = function(v)
		Settings["TpSpeed"] = v
	end
})

-- // AutoFarm Functions \\ --

local function getMob()
    local dist, mob = math.huge
    for i,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == Settings.ChosenMob then
            local get_mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:GetModelCFrame().p).magnitude
            if get_mag < dist then
                dist = get_mag
                mob = v
            end
        end
    end
    return mob
end

local function getBosses()
    local dist, mob = math.huge
    for i,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == Settings.ChosenBoss then
            local get_mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:GetModelCFrame().p).magnitude
            if get_mag < dist then
                dist = get_mag
                mob = v
            end
        end
    end
    return mob
end

spawn(function()
    while wait() do
        if Settings.autofarm_mobs then
            pcall(function()
                local enemy_mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getMob():GetModelCFrame().p).magnitude

                if not getMob():FindFirstChild("Executed") then
                    moveto(getMob():GetModelCFrame() * CFrame.new(0,0,3), tonumber(Settings.TpSpeed or 75))
                end

                if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Model"):FindFirstChild("Blade") then
                    if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Model"):FindFirstChild("Equipped").Part0 == nil then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "R", false, game)
                    end
                end

                if getMob():FindFirstChild("Executed") then
                    wait(1)
                    getMob():Destroy()
                end

                if getMob():FindFirstChild("Down") then
                    moveto(getMob():GetModelCFrame() * CFrame.new(0,0,3), tonumber(Settings.TpSpeed or 75))
                    game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer("Character", "Execute")
                end

                for Index, Value in next, plr.Character:GetChildren() do
                    if Value.Name == "Stun"
                    or Value.Name == "SequenceCooldown"
                    or Value.Name == "HeavyCooldown"
                    or Value.Name == "Sequence"
                    or Value.Name == "SequenceFactor"
                    then
                        Value:Destroy()
                    end
                end

                if enemy_mag <= 10 then
                    if getMob():FindFirstChild("Block") then
                        game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Katana", "Heavy")
                    else
                        game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Katana", "Server")
                    end

                end

            end)
        end
    end
end)

spawn(function()
    while wait() do
        if Settings.autofarm_boss then
            pcall(function()
                local enemy_mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getBosses():GetModelCFrame().p).magnitude

                if not getBosses():FindFirstChild("Executed") then
                    moveto(getBosses():GetModelCFrame() * CFrame.new(0,0,3), tonumber(Settings.TpSpeed or 75))
                end

                if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Model"):FindFirstChild("Blade") then
                    if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Model"):FindFirstChild("Equipped").Part0 == nil then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "R", false, game)
                    end
                end

                if getBosses():FindFirstChild("Executed") then
                    wait(1)
                    getBosses():Destroy()
                end

                if getBosses():FindFirstChild("Down") then
                    moveto(getBosses():GetModelCFrame() * CFrame.new(0,0,3), tonumber(Settings.TpSpeed or 75))
                    game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer("Character", "Execute")
                end

                for Index, Value in next, plr.Character:GetChildren() do
                    if Value.Name == "Stun"
                    or Value.Name == "SequenceCooldown"
                    or Value.Name == "HeavyCooldown"
                    or Value.Name == "Sequence"
                    or Value.Name == "SequenceFactor"
                    then
                        Value:Destroy()
                    end
                end

                if enemy_mag <= 10 then
                    if getBosses():FindFirstChild("Block") then
                        game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Katana", "Heavy")
                    else
                        game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Katana", "Server")
                    end

                end

            end)
        end
    end
end)

-- // Misc / Extra \\ --

local Misc = Window:MakeTab({
	Name = "Misc / Extra",
	Icon = "rbxassetid://4483345998",
})

Misc:AddButton({
	Name = "GodMode",
	Callback = function()
        game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "FallDamageServer", 0/0)
  	end
})

Misc:AddButton({
	Name = "Normal Health",
	Callback = function()
        game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "FallDamageServer", 99999999999999999999999999999999999999999999999999999999999999999999)
  	end
})

Misc:AddToggle({
	Name = "No Swing Cooldown",
	Default = false,
	Callback = function(v)
		Settings["NoCD"] = v
	end
})

Misc:AddToggle({
	Name = "NoFall",
	Default = false,
	Callback = function(v)
		Settings["NoFall"] = v
	end
})

Misc:AddToggle({
	Name = "Anti Sun Burn",
	Default = false,
	Callback = function(v)
		Settings["AntiSun"] = v
	end
})

Misc:AddToggle({
	Name = "Anti Crow",
	Default = false,
	Callback = function(v)
		Settings["AntiCrow"] = v
	end
})

Misc:AddToggle({
	Name = "ChatLogger",
	Default = false,
	Callback = function(v)
		
	end
})

Misc:AddToggle({
	Name = "NoClip",
	Default = false,
	Callback = function(v)
        
	end
})

Misc:AddToggle({
	Name = "Anti-Combat",
	Default = false,
	Callback = function(v)
		Settings["AntiCombat"] = v
	end
})

local baditems = {
    "Combat",
    "Stun",
    "Damaged",
    "downCooldown",
    "Cooldown"
}

Misc:AddToggle({
	Name = "Pickup-Aura",
	Default = false,
	Callback = function(v)
		Settings["PickupAura"] = v
	end
})

Misc:AddToggle({
	Name = "AutoGourd",
	Default = false,
	Callback = function(v)
		Settings["AutoGourd"] = v
	end
})

Misc:AddToggle({
	Name = "Enhance-Visuals",
	Default = false,
	Callback = function(v)
		Settings["Visuals"] = v
	end
})

-- // Misc / Extra (Functions) \\ --

spawn(function()
    while wait() do
        if Settings.NoCD then
            pcall(function()
                for Index, Value in next, plr.Character:GetChildren() do
                    if Value.Name == "Stun" or Value.Name == "SequenceCooldown" or Value.Name == "HeavyCooldown" or Value.Name == "Sequence" or Value.Name == "SequenceFactor" then 
                        Value:Destroy()
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait() do 
        if Settings.PickupAura then 
            pcall(function()
                for i,v in pairs(workspace:GetChildren()) do
                    if v.Name == "DropItem" then 
                        local partmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).magnitude 
                        if partmag < 20 then 
                            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "Interaction", v)
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(0.1) do 
        if Settings.AutoGourd then 
            pcall(function()
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, true, game, 1)
                game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer("Clay", "Server2")
            end)
        end
    end
end)

spawn(function()
    while wait(1) do
        if Settings.Visuals then 
            game.Lighting.SunRays.Enabled = false
            game.Lighting.ColorCorrection.Enabled = false
            game.Lighting.Blur.Enabled = false
            game.Lighting.Bloom.Enabled = false

            for i,v in pairs(game.Lighting:GetChildren()) do
                if v.Name == "Atmosphere" then 
                    v.Density = 0 
                    v.Glare = 0 
                    v.Haze = 0
                end
            end
            if game.Lighting:FindFirstChild("Blind") then 
                game.Lighting:FindFirstChild("Blind"):Destroy()
            end
            if workspace:FindFirstChild("Folder") and workspace:FindFirstChild("Folder"):FindFirstChild("Part") then 
                workspace:FindFirstChild("Folder"):Destroy()
            end
        end
    end
end)

-- // Players \\ --

local Players = Window:MakeTab({
	Name = "Players",
	Icon = "rbxassetid://4483345998",
})

Players:AddLabel("LocalPlayer Items")

local mt = getrawmetatable(game)
local index = mt.__newindex

Players:AddSlider({
	Name = "WalkSpeed",
	Min = 18,
	Max = 150,
	Default = 18,
	Color = Color3.fromRGB(0,255,255),
	Increment = 1,
	Callback = function(v)
		Settings["WalkSpeed"] = v
	end
})

Players:AddToggle({
	Name = "Enable WalkSpeed",
	Default = false,
	Callback = function(v)
		Settings["TogWalk"] = v
	end    
})

Players:AddSlider({
	Name = "JumpPower",
	Min = 60,
	Max = 100,
	Default = 60,
	Color = Color3.fromRGB(0,255,255),
	Increment = 1,
	Callback = function(v)
		Settings["JumpPower"] = v
	end
})

Players:AddToggle({
	Name = "Enable JumpPower",
	Default = false,
	Callback = function(v)
		Settings["TogJump"] = v
	end
})

setreadonly(mt, false)
mt.__newindex = newcclosure(function(f,i,v)
    if tostring(f) == "Humanoid" and tostring(i) == "WalkSpeed" and Settings.TogWalk then
        return index(f,i,Settings.WalkSpeed)
    end

    if tostring(f) == "Humanoid" and tostring(i) == "JumpPower" and Settings.TogJump then 
        return index(f,i,Settings.JumpPower)
    end

    return index(f,i,v)
end)

setreadonly(mt, true)

Players:AddLabel("LocalPlayer Items")

local plr_table = {}

for i,v in pairs(game.Players:GetPlayers()) do
    if not table.find(plr_table, v.Name) then
        table.insert(plr_table, v.Name)
    end
end

Players:AddDropdown({
	Name = "Select Player",
	Default = "1",
	Options = plr_table,
	Callback = function(v)
		Settings["ChosenPlayer"] = v
	end
})

Players:AddButton({
	Name = "Refresh Player",
	Callback = function()
        table.clear(plr_table)
        Players:RemoveAll()

        for i,v in pairs(game.Players:GetPlayers()) do
            if not table.find(plr_table, v.Name) then 
                table.insert(plr_table, v.Name)
            end
        end
        
        for i,v in pairs(plr_table) do
            Players:AddValue(tostring(v))
        end
  	end
})

Players:AddToggle({
	Name = "Spectate",
	Default = false,
	Callback = function(v)
		if v then 
            workspace.Camera.CameraSubject = game.Players:FindFirstChild(Settings.ChosenPlayer).Character.Humanoid
        else
            workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
        end
	end
})

Players:AddButton({
	Name = "Refresh Player",
	Callback = function()
        moveto(game.Players:FindFirstChild(Settings.ChosenPlayer).Character.HumanoidRootPart.CFrame, tonumber(Settings.TpSpeed or 75))
    end
})

-- // Teleports \\ --

local Teleport = Window:MakeTab({
	Name = "Teleport",
	Icon = "rbxassetid://4483345998",
})

local breath_style = {
    ["SunBreath"] = "Tanjiro",
    ["MoonBreath"] = "Kokushibo",
    ["WaterBreath"] = "Urokodaki",
    ["ThunderBreath"] = "Kujima",
    ["FlameBreath"] = "Rengoku",
    ["WindBreath"] = "Grimm",
    ["MistBreath"] = "Tokito",
    ["InsectBreath"] = "Shinobu",
    ["SoundBreath"] = "Uzui",
}
local breath_names = {}
for i,v in pairs(breath_style) do
    table.insert(breath_names, i)
end

Teleport:AddDropdown({
	Name = "Select Breathing",
	Default = "1",
	Options = breath_style,
	Callback = function(v)
		Settings["ChosenBreathing"] = v
	end    
})

Teleport:AddButton({
	Name = "Teleport",
	Callback = function()
        moveto(workspace.Npcs:FindFirstChild(breath_style[Settings.ChosenBreathing]):GetModelCFrame(), tonumber(Settings.TpSpeed or 75))
    end
})

local npc_list = {}
for i,v in pairs(workspace.Npcs:GetChildren()) do
    if v:IsA("Model") and not table.find(npc_list, v.Name) then
        table.insert(npc_list, v.Name)
    end
end

Teleport:AddDropdown({
	Name = "Select NPC",
	Default = "1",
	Options = npc_list,
	Callback = function(v)
		Settings["ChosenNPC"] = v
	end
})

Teleport:AddButton({
	Name = "Teleport",
	Callback = function()
        moveto(workspace.Npcs:FindFirstChild(Settings.ChosenNPC):GetModelCFrame(), tonumber(Settings.TpSpeed or 75))
    end
})


-- // Items Farm \\ --

local Items = Window:MakeTab({
	Name = "Items",
	Icon = "rbxassetid://4483345998",
})

local ore_list = {
    "Sun Ore",
    "Iron Ore"
}

local Trinket_list = {
    "Ancient Coin",
    "Bronze Jar",
    "Copper Goblet",
    "Gold Crown",
    "Gold Goblet",
    "Gold Jar",
    "Golden Ring",
    "Green Jewel",
    "Perfect Crystal",
    "Red Jewel",
    "Rusty Goblet",
    "Silver Goblet",
    "Silver Jar",
    "Silver Ring",
}

Items:AddDropdown({
	Name = "Select Ore",
	Default = "1",
	Options = ore_list,
	Callback = function(v)
        Settings["ChosenOre"] = v
	end
})

Items:AddToggle({
	Name = "Farm Selected Ore",
	Default = false,
	Callback = function(v)
		Settings["FarmOre"] = v
	end
})

Items:AddDropdown({
	Name = "Select Trinket",
	Default = "1",
	Options = Trinket_list,
	Callback = function(v)
        Settings["ChosenTrinket"] = v
	end
})

Items:AddToggle({
	Name = "Farm Trinket",
	Default = false,
	Callback = function(v)
		Settings["TrinketFarm"] = v
	end
})


-- // Items Functions \\ --

local function getOre()
    local dist, ore = math.huge
    for i,v in pairs(game:GetService("Workspace").Map.Minerals:GetDescendants()) do
        if v.Name == "MineralName" and v.Value == Settings.ChosenOre then
            local oremag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).magnitude
            if oremag < dist then 
                dist = oremag
                ore = v.Parent
            end
        end
    end
    return ore
end


local function getTrinket()
    local dist, trin = math.huge
    for i,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == Settings.ChosenTrinket and v:FindFirstChild("PickableItem") then
            local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:GetModelCFrame().p).magnitude
            if mag < dist then
                dist = mag
                trin = v
            end
        end
    end
    return trin
end

spawn(function()
    while wait() do
        if Settings.TrinketFarm then
            local trinmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getTrinket():GetModelCFrame().p).magnitude
            if trinmag <= 20 then
                for i,v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("PickableItem") and v:FindFirstChild("Part") then
                        local partmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChild("Part").Position).magnitude 
                        if partmag < 20 then
                            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "Interaction", v.Part)
                        end
                    end
                end
            else
                moveto(getTrinket():GetModelCFrame() * CFrame.new(0,0,0), tonumber(Settings.TpSpeed or 75))
            end
        end
    end
end)

spawn(function()
    while wait() do
        if Settings.FarmOre then 
            local ore_mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getOre().Position).magnitude
            if ore_mag <= 5 then
                game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer("Pickaxe", "Server")
            else
                moveto(getOre().CFrame, tonumber(Settings.TpSpeed or 75))
            end
        end
    end
end)


-- // Settings \\ --

local Settings_Tab = Window:MakeTab({
	Name = "Settings",
	Icon = "rbxassetid://4483345998",
})

Settings_Tab:AddButton({
	Name = "ServerHop!",
	Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"

        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
        function ListServers(cursor)
        local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
        return Http:JSONDecode(Raw)
        end

        local Server, Next; repeat
        local Servers = ListServers(Next)
        Server = Servers.data[1]
        Next = Servers.nextPageCursor
        until Server

        TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
  	end
})

Settings_Tab:AddButton({
	Name = "Destroy GUI",
	Callback = function()
        OrionLib:Destroy()
  	end
})

Settings_Tab:AddLabel("Credits")

Settings_Tab:AddButton({
	Name = "Discord",
	Callback = function()
        setclipboard("https://discord.gg/yB8uENPJG9")

        OrionLib:MakeNotification({
            Name = "L4BIB HUB",
            Content = "Discord Link Copied",
            Image = "rbxassetid://4483345998",
            Time = 5
        })

  	end
})

-- // Finnish \\ --
OrionLib:Init()
