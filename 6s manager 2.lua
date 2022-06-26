local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/HebraX/Libs/main/6th%20sense%202.lua",true))()

local Manager = {}
Manager = {
    Settings = {},

    Visuals = {},
    CurrentObjects = {},
    Objects = {
        ["Players"] = {},
        ["AI"] = {}
    },
    CreateVisuals = {
        ["Name"] = function(Args)
            if not Args.Text then
                Args.Text = Args.Object.Name
            end

            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:Name(Args.Object, Args.Text, Args.Settings))
        end,
        ["Box"] = function(Args)
            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:Box(Args.Object, Args.Settings))
        end,
        ["Skeleton"] = function(Args)
            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:Skeleton(Args.Object, Args.Settings))
        end,
        ["Chams"] = function(Args)
            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:Chams(Args.Object, Args.Settings))
        end,
        ["HealthBar"] = function(Args)
            if Args.Object and Args.Object.Parent ~= nil then else
                return
            end

            table.insert(Args.Visuals, ESP:HealthBar(Args.Object, Args.Settings))
        end
    }
}

function Manager:toggle(State)
    if State then
        ESP:Start()
    else
        ESP:Stop()
    end
end

function Manager:vtoggle(Type, Name, State, ObjectData)
    if not self.Visuals[Type] then
        self.Visuals[Type] = {}
    end

    if not self.Visuals[Type][Name] then
        self.Visuals[Type][Name] = {}
    end

    if not self.Settings[Type] then
        self.Settings[Type] = {}
    end

    if not self.Settings[Type][Name] then
        self.Settings[Type][Name] = {}
    end

    self.Settings[Type][Name].Enabled = State

    if State then
        if self.Objects[ObjectData] then
            for i,v in pairs(self.Objects[ObjectData]) do
                self.CreateVisuals[Name]({
                    Object = v,
                    Visuals = self.Visuals[Type][Name],
                    Settings = self.Settings[Type][Name]
                })
            end
        end
    else
        for i,v in pairs(self.Visuals[Type][Name]) do
            v:Remove()
        end
        
        self.Visuals[Type][Name] = nil
    end
end

function Manager:UpdateSetting(Type, Visual, Setting, Value)
    if not self.Settings[Type] then
        self.Settings[Type] = {}
    end

    if not self.Settings[Type][Visual] then
        self.Settings[Type][Visual] = {}
    end

    self.Settings[Type][Visual][Setting] = Value

    if self.Visuals[Type] and self.Visuals[Type][Visual] then
        for i,v in pairs(self.Visuals[Type][Visual]) do
            if v and v.ChangeSetting then
                v:ChangeSetting(Setting, Value)
            end
        end
    end
end

-- Players
function SetupPlayer(Player)
    local function OnCharacter(Character)
        coroutine.wrap(function()
            repeat
                task.wait()
            until Character:FindFirstChild("Humanoid") and Character.PrimaryPart and Character:FindFirstChild("Head")

            table.insert(Manager.Objects["Players"], Character)

            if Manager.Settings["Players"] then
                for i,v in pairs(Manager.Settings["Players"]) do
                    if v.Enabled then
                        Manager.CreateVisuals[i]({
                            Object = Character,
                            Visuals = Manager.Visuals["Players"][i],
                            Settings = Manager.Settings["Players"][i]
                        })
                    end
                end
            end
        end)()
    end

    Player.CharacterAdded:Connect(function(Character)
        OnCharacter(Character)
    end)

    if Player.Character then
        OnCharacter(Player.Character)
    end
end

Players.PlayerAdded:Connect(function(Player)
    SetupPlayer(Player)
end)
for _,v in pairs(Players:GetPlayers()) do
    if v ~= Players.LocalPlayer then
        SetupPlayer(v)
    end
end
-- AI
function SetupAI(Character)
    coroutine.wrap(function()
        repeat
            task.wait()
        until Character:FindFirstChild("Humanoid") and Character.PrimaryPart and Character:FindFirstChild("Head")

        table.insert(Manager.Objects["AI"], Character)

        if Manager.Settings["AI"] then
            for i,v in pairs(Manager.Settings["AI"]) do
                if v.Enabled then
                    Manager.CreateVisuals[i]({
                        Object = Character,
                        Visuals = Manager.Visuals["AI"][i],
                        Settings = Manager.Settings["AI"][i]
                    })
                end
            end
        end
    end)()
end
game.Workspace.AiZones.DescendantAdded:Connect(function(Part)
    if Part:IsA("Humanoid") then
        SetupAI(Part.Parent)
    end
end)
for _,v in next, game.Workspace.AiZones:GetDescendants() do
    if v:IsA("Humanoid") then
        SetupAI(v.Parent)
    end
end

return Manager
