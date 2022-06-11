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
                    Callback(Character, Manager.Settings[Type][Visual], nil, Visuals)
                end))

                if Player.Character and Player.Character.PrimaryPart then
                    Callback(Player.Character, Manager.Settings[Type][Visual], nil, Visuals)
                end
            end

            for _,v in next, Players:GetChildren() do
                OnNewCharacter(v)
            end

            table.insert(Connections, Players.PlayerAdded(OnNewCharacter))

            return Connections
        end
    },
    CreateVisuals = {
        ["Name"] = function(Object, Settings, Text, Visuals)
            if not Text then
                Text = Object.Name
            end

            table.insert(Visuals, ESP:Name(Object, Text, Settings))
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
            self.Objects[ObjectData](function(...)
                self.CreateVisuals[Name](...)
            end, Type, Name, self.Visuals[Type][Name])
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
end

return Manager
