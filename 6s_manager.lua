local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/HebraX/Libs/main/6th%20sense%202.lua",true))()

local Manager = {}
Manager = {
    Settings = {},

    Visuals = {},
    Objects = {
        ["Players"] = function(Callback, Type, Visual, Visuals)
            local Connections = {}

            local function OnNewCharacter(Player)
                table.insert(Connections, Player.CharacterAdded:Connect(function(Character)
                    Callback({
                        Object = Character, 
                        Settings = Manager.Settings[Type][Visual],
                        Visuals = Visuals
                    })
                end))

                if Player.Character and Player.Character.PrimaryPart then
                    Callback({
                        Object = Player.Character, 
                        Settings = Manager.Settings[Type][Visual],
                        Visuals = Visuals
                    })
                end
            end

            for _,v in next, Players:GetChildren() do
                OnNewCharacter(v)
            end

            table.insert(Connections, Players.PlayerAdded:Connect(OnNewCharacter))

            return Connections
        end,
        ["AI"] = function(Callback, Type, Visual, Visuals)
            local Connections = {}

            local function OnNewCharacter(Character)
                if Character then
                    Callback({
                        Object = Character, 
                        Settings = Manager.Settings[Type][Visual],
                        Visuals = Visuals
                    })
                end
            end

            for _,v in next, game.Workspace.AiZones:GetDescendants() do
                if v:IsA("Humanoid") then
                    OnNewCharacter(v.Parent)
                end
            end

            table.insert(Connections, game.Workspace.AiZones.DescendantAdded:Connect(function(Part)
                if Part and Part:IsA("Humanoid") then
                    Callback({
                        Object = Part.Parent, 
                        Settings = Manager.Settings[Type][Visual],
                        Visuals = Visuals
                    })
                end
            end))

            return Connections
        end,
    },
    CreateVisuals = {
        ["Name"] = function(Args)
            if not Args.Text then
                Args.Text = Args.Object.Name
            end

            table.insert(Args.Visuals, ESP:Name(Args.Object, Args.Text, Args.Settings))
        end,
        ["Box"] = function(Args)
            table.insert(Args.Visuals, ESP:Box(Args.Object, Args.Settings))
        end,
        ["Skeleton"] = function(Args)
            table.insert(Args.Visuals, ESP:Skeleton(Args.Object, Args.Settings))
        end,
        ["Chams"] = function(Args)
            table.insert(Args.Visuals, ESP:Chams(Args.Object, Args.Settings))
        end,
        ["HealthBar"] = function(Args)
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

    if State then
        if self.Objects[ObjectData] then
            local Connections = self.Objects[ObjectData](function(...)
                self.CreateVisuals[Name](...)
            end, Type, Name, self.Visuals[Type][Name])

            self.Visuals[Type][Name].Connections = Connections
        end
    else
        for i,v in pairs(self.Visuals[Type][Name]) do
            if i == "Connections" then
                for i2,v2 in pairs(v) do
                    v2:Disconnect()
                end
            else
                v:Remove()
            end
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
end

return Manager
