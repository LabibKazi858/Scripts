
if game.PlaceId == 4855457388 or game.PlaceId == 5094651510 then
    print("Correct Game")

repeat task.wait() until game:IsLoaded()

repeat task.wait() until game:GetService("Players").LocalPlayer:FindFirstChild("GameLoaded")
wait(2)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JRL-lav/Scripts/main/U"))()
local Window = Library:CreateWindow("Swag Hub | Demonfall")

-- // Pre Scripts
game:GetService("UserInputService").MouseIconEnabled = true
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

-- // Farming \\ --
local farm = Window:AddFolder("Farm")

farm:AddLabel({text = "--- Autofarm Tween---"})

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

farm:AddList({
    text = "Select Mob",
    values = mob_list,
    callback = function(v)
        Settings["ChosenMob"] = v
    end
})

farm:AddToggle({
    text = "Autofarm Mob",
    state = false,
    callback = function(v)
        Settings["autofarm_mobs"] = v
    end
})

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

farm:AddList({
    text = "Select Boss",
    values = boss_list,
    callback = function(v)
        Settings["ChosenBoss"] = v
    end
})

farm:AddToggle({
    text = "Autofarm Boss",
    state = false,
    callback = function(v)
        Settings["autofarm_boss"] = v
    end
})

farm:AddSlider({
    text = "TP Speed",
    value = 75,
    min = 30,
    max = 75,
    float = 1,
    callback = function(v)
        Settings["TpSpeed"] = v
    end
})

farm:AddToggle({
    text = "AutoBreathe",
    state = false,
    callback = function(v)
        Settings["AutoBreathe"] = v
        if not v then
            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "Breath", false)
        end
    end
})

farm:AddToggle({
    text = "Equip-Sword",
    state = false,
    callback = function(v)
        Settings["AutoSword"] = v
    end
})

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

local function tpBypass()
    local args = {
        [1] = "Player",
        [2] = "SpawnCharacter"
        };
        game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer(unpack(args))
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
                    if Value.Name == "Stun" or Value.Name == "SequenceCooldown" or Value.Name == "HeavyCooldown" or Value.Name == "Sequence" or Value.Name == "SequenceFactor" then 
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
                    if Value.Name == "Stun" or Value.Name == "SequenceCooldown" or Value.Name == "HeavyCooldown" or Value.Name == "Sequence" or Value.Name == "SequenceFactor" then 
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

spawn(function()
    while wait() do
        if Settings.AutoBreathe then
            if game.Players.LocalPlayer.Character:FindFirstChild("Busy") then
                game.Players.LocalPlayer.Character:FindFirstChild("Busy"):Destroy()
            end

            if game.Players.LocalPlayer.Character:FindFirstChild("Slow") then 
                game.Players.LocalPlayer.Character:FindFirstChild("Slow"):Destroy()
            end
        end
    end
end)

spawn(function()
    while wait() do
        if Settings.AutoBreathe then
            if game:GetService("Players").LocalPlayer.Breathing.Value ~= 100 then 
                game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "Breath", true)
            end
            wait(2)
        end
    end
end)

spawn(function()
    while wait() do
        if Settings.AutoSword then
            pcall(function()
                if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Model"):FindFirstChild("Blade") then
                    if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Model"):FindFirstChild("Equipped").Part0 == nil then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "R", false, game)
                    end
                end
            end)
        end
    end
end)

-- // Misc / Extra \\ -- 
local misc = Window:AddFolder("Misc / Extra")

misc:AddToggle({
    text = "No Swing Cooldown",
    state = false,
    callback = function(v)
        Settings["NoCD"] = v
    end
})

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

misc:AddToggle({
    text = "NoFall",
    state = false,
    callback = function(v)
        Settings["NoFall"] = v
    end
})

misc:AddToggle({
    text = "Anti Sun Burn",
    state = false,
    callback = function(v)
        Settings["AntiSun"] = v
    end
})

misc:AddToggle({
    text = "Anti Crow",
    state = false,
    callback = function(v)
        Settings["AntiCrow"] = v
    end
})

local nofall

nofall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" and tostring(self) == "Async" and args[1] == "Character" and args[2] == "FallDamageServer" and Settings.NoFall then 
        return nil
    end

    if method == "FireServer" and tostring(self) == "Async" and args[1] == "Character" and args[2] == "DemonWeakness" and Settings.AntiSun then 
        return nil
    end

    if method == "FireServer" and tostring(self) == "Async" and args[1] == "Character" and args[2] == "Crow" and Settings.AntiCrow then 
        return nil
    end

    return nofall(self, ...)
end)



misc:AddToggle({
    text = "ChatLogger",
    state = false,
    callback = function(v)
        if v then
            plr.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = true
        else
            plr.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = false
        end
    end
})

local function InfJump(inputObject, gameProcessedEvent)
    if inputObject.KeyCode == Enum.KeyCode.Space then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(3)
    end
end

local connection
misc:AddToggle({
    text = "InfJump",
    state = false,
    callback = function(v)
        if v then 
            connection = game:GetService("UserInputService").InputBegan:connect(InfJump)
        else
            if connection then 
                connection:Disconnect()
            end
        end
    end
})

local noclipT
misc:AddToggle({
    text = "NoClip",
    state = false,
    callback = function(v)
        if v then 
            noclipT = game:GetService("RunService").Stepped:Connect(noclip)
        else
            if noclipT then 
                noclipT:Disconnect()
            end
        end
    end
})

misc:AddToggle({
    text = "Anti-Combat",
    state = false,
    callback = function(v)
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

spawn(function()
    while wait() do 
        if Settings.AntiCombat then
            pcall(function()
                for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if table.find(baditems, v.Name) then
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)

misc:AddToggle({
    text = "Pickup-Aura",
    state = false,
    callback = function(v)
        Settings["PickupAura"] = v
    end
})

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

misc:AddToggle({
    text = "AutoGourd",
    state = false,
    callback = function(v)
        Settings["AutoGourd"] = v
    end
})

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

misc:AddToggle({
    text = "Enhance-Visuals",
    callback = function(v)
        Settings["Visuals"] = v
        pcall(function()
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
            game.Lighting.Blind:Destroy()
        end)
    end
})

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

misc:AddLabel({text = "---Turn off NoFall---"})

misc:AddButton({
    text = "GodMode",
    callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "FallDamageServer", 0/0)
        end)
    end
})

misc:AddButton({
    text = "NormalHealth (Kills You)",
    callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "FallDamageServer", 99999999999999999999999999999999999999999999999999999999999999999999)
        end)
    end
})

misc:AddLabel({text = "---Turn off NoFall---"})

-- // Players \\ -- 
local plrs = Window:AddFolder("Players")

plrs:AddLabel({text = "----LocalPlayer Items"})

local mt = getrawmetatable(game)
local index = mt.__newindex

plrs:AddSlider({
    text = "WalkSpeed",
    value = 18,
    min = 18,
    max = 150,
    float = 1,
    callback = function(v)
        Settings["WalkSpeed"] = v
    end
})

plrs:AddToggle({
    text = "Enable WalkSpeed",
    state = false,
    callback = function(v)
        Settings["TogWalk"] = v
    end
})


plrs:AddSlider({
    text = "JumpPower",
    value = 60,
    min = 60,
    max = 100,
    float = 1,
    callback = function(v)
        Settings["JumpPower"] = v
    end
})

plrs:AddToggle({
    text = "Enable JumpPower",
    state = false,
    callback = function(v)
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


plrs:AddLabel({text = "----Player Items"})

local plr_table = {}
for i,v in pairs(game.Players:GetPlayers()) do
    if not table.find(plr_table, v.Name) then 
        table.insert(plr_table, v.Name)
    end
end

local plr_drop = plrs:AddList({
    text = "Select Player",
    values = plr_table,
    callback = function(v)
        Settings["ChosenPlayer"] = v
    end
})

plrs:AddButton({
    text = "Refresh Players",
    callback = function()
        table.clear(plr_table)
        plr_drop:RemoveAll()

        for i,v in pairs(game.Players:GetPlayers()) do
            if not table.find(plr_table, v.Name) then 
                table.insert(plr_table, v.Name)
            end
        end
        
        for i,v in pairs(plr_table) do
            plr_drop:AddValue(tostring(v))
        end
    end
})

plrs:AddToggle({
    text = "Spectate",
    state = false,
    callback = function(v)
        if v then 
            workspace.Camera.CameraSubject = game.Players:FindFirstChild(Settings.ChosenPlayer).Character.Humanoid
        else
            workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
        end
    end
})

plrs:AddButton({
    text = "Teleport",
    callback = function()
        moveto(game.Players:FindFirstChild(Settings.ChosenPlayer).Character.HumanoidRootPart.CFrame, tonumber(Settings.TpSpeed or 75))
    end
})

-- // Teleports \\ --

local tele = Window:AddFolder("Teleports")

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

tele:AddList({
    text = "Select Breathing",
    values = breath_names,
    callback = function(v)
        Settings["ChosenBreathing"] = v
    end
})

tele:AddButton({
    text = "Teleport Breathing",
    callback = function()
        moveto(workspace.Npcs:FindFirstChild(breath_style[Settings.ChosenBreathing]):GetModelCFrame(), tonumber(Settings.TpSpeed or 75))
    end
})

local npc_list = {}
for i,v in pairs(workspace.Npcs:GetChildren()) do
    if v:IsA("Model") and not table.find(npc_list, v.Name) then
        table.insert(npc_list, v.Name)
    end
end

tele:AddList({
    text = "Select NPC",
    values = npc_list,
    callback = function(v)
        Settings["ChosenNPC"] = v
    end
})

tele:AddButton({
    text = "Teleport NPC",
    callback = function()
        moveto(workspace.Npcs:FindFirstChild(Settings.ChosenNPC):GetModelCFrame(), tonumber(Settings.TpSpeed or 75))
    end
})

-- // Items Farm \\ -- 
local ores = Window:AddFolder("Items Farm")

local flower_list = {
    "Flower1",
    "Flower2",
    "Flower3"
}

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

ores:AddList({
    text = "Select Ore",
    values = ore_list,
    callback = function(v)
        Settings["ChosenOre"] = v
    end
})

ores:AddToggle({
    text = "FarmOre",
    state = false,
    callback = function(v)
        Settings["FarmOre"] = v
    end
})

ores:AddLabel({text = "--- If The Ore / Trinket Not Found ---"})
ores:AddLabel({text = "--- Rejoin Or Server Hop ---"})

ores:AddList({
    text = "Select Trinket",
    values = Trinket_list,
    callback = function(v)
        Settings["ChosenTrinket"] = v
    end
})


ores:AddToggle({
    text = "Trinket Farm",
    state = false,
    callback = function(v)
        Settings["TrinketFarm"] = v
    end
})

ores:AddList({
    text = "Select Flowers",
    values = flower_list,
    callback = function(v)
        Settings["ChosenFlower"] = v
    end
})

ores:AddToggle({
    text = "Flower Farm",
    state = false,
    callback = function(v)
        Settings["FlowerFarm"] = v
    end
})

local function getFlowers()
    local dist, flowers = math.huge
    for i,v in pairs(workspace.Map:GetChildren()) do
        if v:IsA("Model") and v.Name == Settings.ChosenFlower then
            local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:GetModelCFrame().p).magnitude
            if mag < dist then
                dist = mag
                flowers = v
            end
        end
    end
    return flowers
end

spawn(function()
    while wait() do
        if Settings.FlowerFarm then
            local trinmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getFlowers():GetModelCFrame().p).magnitude
            if trinmag <= 20 then
                for i,v in pairs(workspace.Map:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("PickableItem") and v:FindFirstChild("Part") then
                        local partmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChild("Part").Position).magnitude 
                        if partmag < 20 then
                            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "Interaction", v.Part)
                        end
                    end
                end
            else
                moveto(getFlowers():GetModelCFrame() * CFrame.new(0,0,0), tonumber(Settings.TpSpeed or 75))
            end
        end
    end
end)

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
local Settings_Tab = Window:AddFolder("Settings")
Settings_Tab:AddButton({
    text = "ServerHop",
    callback = function()
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

-- // Credits \\ --
local cred = Window:AddFolder("Credits")
cred:AddButton({text = "S W A G#6007", callback = function()
    setclipboard("S W A G#6007")
end})
cred:AddLabel({text = "MADE BY | S W A G#6007"})

-- // Init \\ -- 
Library:Init()

end
