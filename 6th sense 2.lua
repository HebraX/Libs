local RunService = game:GetService("RunService")

local WorldToViewportPoint = workspace.CurrentCamera.WorldToViewportPoint
 
local ESP = {}
 
ESP.ActiveObjects = {}
ESP.Connections = {}

function ESP:CheckObject(Object)
    if not ESP.ActiveObjects[Object] then
        ESP.ActiveObjects[Object] = {}
    end
end

function ESP:Box(Object, Settings)
    Settings = Settings or {}

    Settings.Color = Settings.Color or Color3.fromRGB(255, 255, 255)
    Settings.Thickness = Settings.Thickness or 2
    Settings.Filled = Settings.Filled or false
    Settings.VisCheck = false
    Settings.HideVisCheck = false

    if Object and not Object.PrimaryPart then
        return nil
    end
    ESP:CheckObject(Object)
 
    local BoxESP = {}
 
    BoxESP.Type = "Box"
    BoxESP.DrawingObject = Drawing.new("Square")
    BoxESP.DrawingObject.Color = Settings.Color or Color3.fromRGB(255, 255, 255)
    BoxESP.DrawingObject.Thickness = Settings.Thickness or 2
    BoxESP.DrawingObject.Filled = Settings.Filled or false
    BoxESP.Object = Object
    BoxESP.Part = Settings.Part and Settings.Part.Name or Object.PrimaryPart.Name
    BoxESP.Removed = false
 
    function BoxESP:Update()
        if Settings.VisCheck then
            local VisCheckRayParams = RaycastParams.new()
            VisCheckRayParams.IgnoreWater = true
            VisCheckRayParams.FilterType = Enum.RaycastFilterType.Blacklist
            VisCheckRayParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, BoxESP.Object, workspace.CurrentCamera}

            local PartToCheck = BoxESP.Object:FindFirstChild("Head") or BoxESP.Object.PrimaryPart
            local RayDirection = (PartToCheck.Position - workspace.CurrentCamera.CFrame.Position).Unit * (workspace.CurrentCamera.CFrame.Position - PartToCheck.Position).Magnitude

            local Raycast = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, RayDirection, VisCheckRayParams)
            
            if Raycast then
                BoxESP.DrawingObject.Color = Settings.VisColor or Settings.Color
                if Settings.HideVisCheck then
                    BoxESP.DrawingObject.Visible = false
                    return
                end
            else
                BoxESP.DrawingObject.Color = Settings.Color
            end
        end

        local HeadCFrame = BoxESP.Object.Head.CFrame + Vector3.new(0, BoxESP.Object.Head.Size.Y, 0)
        local RootCFrame = BoxESP.Object.PrimaryPart.CFrame
        local LegCFrame = RootCFrame - Vector3.new(0, 4, 0)

        Settings.FaceCamera = true
        if Settings.FaceCamera then
            HeadCFrame = CFrame.new(HeadCFrame.Position, workspace.Camera.CFrame.Position)
            RootCFrame = CFrame.new(RootCFrame.Position, workspace.Camera.CFrame.Position)
            LegCFrame = CFrame.new(LegCFrame.Position, workspace.Camera.CFrame.Position)
        end

        local RootVector, IsVisible = WorldToViewportPoint(workspace.CurrentCamera, RootCFrame.Position)
        local HeadVector = WorldToViewportPoint(workspace.CurrentCamera, HeadCFrame.Position)
        local LegVector = WorldToViewportPoint(workspace.CurrentCamera, LegCFrame.Position)
        
        if IsVisible then
            BoxESP.DrawingObject.Size = Vector2.new(workspace.CurrentCamera.ViewportSize.X / (RootCFrame.Position - workspace.CurrentCamera.CFrame.Position).Magnitude, HeadVector.Y - LegVector.Y)
            BoxESP.DrawingObject.Position = Vector2.new(RootVector.X - BoxESP.DrawingObject.Size.X / 2, (RootVector.Y - (BoxESP.DrawingObject.Size.Y)))

            BoxESP.DrawingObject.Visible = true
        else
            BoxESP.DrawingObject.Visible = false
        end
    end

    function BoxESP:ChangeSetting(Setting, Value)
        Settings[Setting] = Value
    end

    function BoxESP:Hide()
        BoxESP.DrawingObject.Visible = false
    end

    function BoxESP:Remove()
        if BoxESP.DrawingObject.__OBJECT_EXISTS == true then
            BoxESP.DrawingObject:Remove()
        end

        BoxESP.Removed = true
    end
 
    table.insert(ESP.ActiveObjects[Object], BoxESP)

    return BoxESP
end
 
function ESP:Skeleton(Object, Settings)
    Settings = Settings or {}

    Settings.Color = Settings.Color or Color3.fromRGB(255, 255, 255)
    Settings.Thickness = Settings.Thickness or 2
    Settings.Filled = Settings.Filled or false
    Settings.VisCheck = false
    Settings.HideVisCheck = false

    if Object and not Object.PrimaryPart then
        return nil
    end
    ESP:CheckObject(Object)
 
    local SkeletonESP = {}
    SkeletonESP.Type = "Skeleton"

    local DrawingObjects = {}
    DrawingObjects.Neck = Drawing.new("Line")
    DrawingObjects.LowerTorsoUpperTorso = Drawing.new("Line")
    DrawingObjects.RootToRightUpperArm = Drawing.new("Line")
    DrawingObjects.RightUpperToDownArm = Drawing.new("Line")
    DrawingObjects.RightDownToHand = Drawing.new("Line")
    DrawingObjects.RootToLeftUpperArm = Drawing.new("Line")
    DrawingObjects.LeftUpperToDownArm = Drawing.new("Line")
    DrawingObjects.LeftDownToHand = Drawing.new("Line")
    DrawingObjects.Waist = Drawing.new("Line")
    DrawingObjects.WaistToLeftUpperLeg = Drawing.new("Line")
    DrawingObjects.LeftUpperLegToDownLeg = Drawing.new("Line")
    DrawingObjects.LeftDownLegToFoot = Drawing.new("Line")
    DrawingObjects.WaistToRightUpperLeg = Drawing.new("Line")
    DrawingObjects.RightUpperLegToDownLeg = Drawing.new("Line")
    DrawingObjects.RightDownLegToFoot = Drawing.new("Line")
    
    for i,v in pairs(DrawingObjects) do
        v.Color = Settings.Color or Color3.fromRGB(255, 255, 255)
        v.Thickness = Settings.Thickness or 2
    end

    SkeletonESP.DrawingObjects = DrawingObjects
    SkeletonESP.Object = Object
    SkeletonESP.Part = Settings.Part and Settings.Part.Name or Object.PrimaryPart.Name
    SkeletonESP.Removed = false
 
    function SkeletonESP:Update()
        local BoundingCFrame, BoundingSize = SkeletonESP.Object:GetBoundingBox()
        BoundingSize /= 2
        
        Settings.FaceCamera = true
        if Settings.FaceCamera then
            BoundingCFrame = CFrame.new(BoundingCFrame.Position, workspace.Camera.CFrame.Position)
        end

        local CharacterData = {}
        local IsAllVisible = true
        for _,v in next, Object:GetChildren() do
            if v:IsA("BasePart") then
                local vSize = v.Size
                local BottomVector = workspace.CurrentCamera:WorldToViewportPoint((v.CFrame * CFrame.new(0, -(vSize.Y/2 - 0.2), 0)).Position)
                --local BottomVector = workspace.CurrentCamera:WorldToViewportPoint(v.Position - Vector3.new(0, v.Size.Y/2, 0))
                local LeftVector = workspace.CurrentCamera:WorldToViewportPoint(v.Position - (v.CFrame.RightVector * v.Size.X/2))
                local LeftVector_4 = workspace.CurrentCamera:WorldToViewportPoint(v.Position - (v.CFrame.RightVector * v.Size.X/4))
                local Vector, IsVisible = workspace.CurrentCamera:WorldToViewportPoint(v.Position)
                local TopVector = workspace.CurrentCamera:WorldToViewportPoint((v.CFrame * CFrame.new(0, (vSize.Y/2 - 0.2), 0)).Position)
                --local TopVector = workspace.CurrentCamera:WorldToViewportPoint(v.Position + Vector3.new(0, v.Size.Y/2, 0))
                local RightVector = workspace.CurrentCamera:WorldToViewportPoint(v.Position + (v.CFrame.RightVector * v.Size.X/2))
                local RightVector_4 = workspace.CurrentCamera:WorldToViewportPoint(v.Position + (v.CFrame.RightVector * v.Size.X/4))
                if not IsVisible then
                    IsAllVisible = false
                end

                CharacterData[v.Name] = {
                    LeftVector_4 = LeftVector_4,
                    LeftVector = LeftVector,
                    BottomVector = BottomVector,
                    Vector = Vector,
                    TopVector = TopVector,
                    RightVector = RightVector,
                    RightVector_4 = RightVector_4,
                    IsVisible = IsVisible,
                }
            end
        end
        
        if IsAllVisible then
            for i,v in pairs(SkeletonESP.DrawingObjects) do
                v.Visible = true
            end

            local function ToVector2(Vector)
                return Vector2.new(Vector.X, Vector.Y)
            end

            if Object:FindFirstChild("Torso") and CharacterData and CharacterData["Torso"] and CharacterData["Left Leg"] and CharacterData["Right Leg"] and CharacterData["Left Arm"] and CharacterData["Right Arm"] then
                SkeletonESP.DrawingObjects.Neck.From = ToVector2(CharacterData["Torso"].BottomVector)
                SkeletonESP.DrawingObjects.Neck.To = ToVector2(CharacterData["Head"].Vector)

                SkeletonESP.DrawingObjects.WaistToLeftUpperLeg.From = ToVector2(CharacterData["Torso"].BottomVector)
                SkeletonESP.DrawingObjects.WaistToLeftUpperLeg.To = ToVector2(CharacterData["Left Leg"].TopVector)
                SkeletonESP.DrawingObjects.LeftUpperLegToDownLeg.From = ToVector2(CharacterData["Left Leg"].TopVector)
                SkeletonESP.DrawingObjects.LeftUpperLegToDownLeg.To = ToVector2(CharacterData["Left Leg"].BottomVector)

                SkeletonESP.DrawingObjects.WaistToRightUpperLeg.From = ToVector2(CharacterData["Torso"].BottomVector)
                SkeletonESP.DrawingObjects.WaistToRightUpperLeg.To = ToVector2(CharacterData["Right Leg"].TopVector)
                SkeletonESP.DrawingObjects.RightUpperLegToDownLeg.From = ToVector2(CharacterData["Right Leg"].TopVector)
                SkeletonESP.DrawingObjects.RightUpperLegToDownLeg.To = ToVector2(CharacterData["Right Leg"].BottomVector)

                SkeletonESP.DrawingObjects.RootToRightUpperArm.From = ToVector2(CharacterData["Torso"].TopVector)
                SkeletonESP.DrawingObjects.RootToRightUpperArm.To = ToVector2(CharacterData["Right Arm"].TopVector)
                SkeletonESP.DrawingObjects.RightUpperToDownArm.From = ToVector2(CharacterData["Right Arm"].TopVector)
                SkeletonESP.DrawingObjects.RightUpperToDownArm.To = ToVector2(CharacterData["Right Arm"].BottomVector)

                SkeletonESP.DrawingObjects.RootToLeftUpperArm.From = ToVector2(CharacterData["Torso"].TopVector)
                SkeletonESP.DrawingObjects.RootToLeftUpperArm.To = ToVector2(CharacterData["Left Arm"].TopVector)
                SkeletonESP.DrawingObjects.LeftUpperToDownArm.From = ToVector2(CharacterData["Left Arm"].TopVector)
                SkeletonESP.DrawingObjects.LeftUpperToDownArm.To = ToVector2(CharacterData["Left Arm"].BottomVector)
            elseif Object:FindFirstChild("UpperTorso") and CharacterData and CharacterData["Torso"] and CharacterData["Left Leg"] and CharacterData["Right Leg"] and CharacterData["Left Arm"] and CharacterData["Right Arm"] then
                SkeletonESP.DrawingObjects.LowerTorsoUpperTorso.From = ToVector2(CharacterData["LowerTorso"].Vector)
                SkeletonESP.DrawingObjects.LowerTorsoUpperTorso.To = ToVector2(CharacterData["UpperTorso"].Vector)

                SkeletonESP.DrawingObjects.Neck.From = ToVector2(CharacterData["UpperTorso"].Vector)
                SkeletonESP.DrawingObjects.Neck.To = ToVector2(CharacterData["Head"].TopVector)

                SkeletonESP.DrawingObjects.Waist.From = ToVector2(CharacterData["LowerTorso"].LeftVector)
                SkeletonESP.DrawingObjects.Waist.To = ToVector2(CharacterData["LowerTorso"].RightVector)

                SkeletonESP.DrawingObjects.WaistToLeftUpperLeg.From = ToVector2(CharacterData["LowerTorso"].LeftVector_4)--ToVector2(CharacterData["LeftUpperLeg"].TopVector)
                SkeletonESP.DrawingObjects.WaistToLeftUpperLeg.To = ToVector2(CharacterData["LeftUpperLeg"].BottomVector)
                SkeletonESP.DrawingObjects.LeftUpperLegToDownLeg.From = ToVector2(CharacterData["LeftUpperLeg"].BottomVector)--ToVector2(CharacterData["LeftLowerLeg"].TopVector)
                SkeletonESP.DrawingObjects.LeftUpperLegToDownLeg.To = ToVector2(CharacterData["LeftLowerLeg"].BottomVector)

                SkeletonESP.DrawingObjects.WaistToRightUpperLeg.From = ToVector2(CharacterData["LowerTorso"].RightVector_4)--ToVector2(CharacterData["RightUpperLeg"].TopVector)
                SkeletonESP.DrawingObjects.WaistToRightUpperLeg.To = ToVector2(CharacterData["RightUpperLeg"].BottomVector)
                SkeletonESP.DrawingObjects.RightUpperLegToDownLeg.From = ToVector2(CharacterData["RightUpperLeg"].BottomVector)--ToVector2(CharacterData["RightLowerLeg"].TopVector)
                SkeletonESP.DrawingObjects.RightUpperLegToDownLeg.To = ToVector2(CharacterData["RightLowerLeg"].BottomVector)

                SkeletonESP.DrawingObjects.RootToLeftUpperArm.From = ToVector2(CharacterData["UpperTorso"].TopVector)
                SkeletonESP.DrawingObjects.RootToLeftUpperArm.To = ToVector2(CharacterData["LeftUpperArm"].TopVector)
                SkeletonESP.DrawingObjects.LeftUpperToDownArm.From = ToVector2(CharacterData["LeftUpperArm"].TopVector)
                SkeletonESP.DrawingObjects.LeftUpperToDownArm.To = ToVector2(CharacterData["LeftUpperArm"].BottomVector)
                SkeletonESP.DrawingObjects.LeftDownToHand.From = ToVector2(CharacterData["LeftUpperArm"].BottomVector)
                SkeletonESP.DrawingObjects.LeftDownToHand.To = ToVector2(CharacterData["LeftHand"].Vector)

                SkeletonESP.DrawingObjects.RootToRightUpperArm.From = ToVector2(CharacterData["UpperTorso"].TopVector)
                SkeletonESP.DrawingObjects.RootToRightUpperArm.To = ToVector2(CharacterData["RightUpperArm"].TopVector)
                SkeletonESP.DrawingObjects.RightUpperToDownArm.From = ToVector2(CharacterData["RightUpperArm"].TopVector)
                SkeletonESP.DrawingObjects.RightUpperToDownArm.To = ToVector2(CharacterData["RightUpperArm"].BottomVector)
                SkeletonESP.DrawingObjects.RightDownToHand.From = ToVector2(CharacterData["RightUpperArm"].BottomVector)
                SkeletonESP.DrawingObjects.RightDownToHand.To = ToVector2(CharacterData["RightHand"].Vector)
            end
        else
            for i,v in pairs(SkeletonESP.DrawingObjects) do
                v.Visible = false
            end
        end
    end

    function SkeletonESP:ChangeSetting(Setting, Value)
        Settings[Setting] = Value
    end

    function SkeletonESP:Hide()
        for i,v in pairs(SkeletonESP.DrawingObjects) do
            v.Visible = false
        end
    end

    function SkeletonESP:Remove()
        for i,v in pairs(SkeletonESP.DrawingObjects) do
            if v.__OBJECT_EXISTS == true then
                v:Remove()
            end
        end

        SkeletonESP.Removed = true
    end
 
    table.insert(ESP.ActiveObjects[Object], SkeletonESP)

    return SkeletonESP
end

function ESP:Name(Object, Text, Settings)
    Settings = Settings or {}

    Settings.Location = Settings.Location or "Top"
    Settings.ShowDistance = Settings.ShowDistance or false
    Settings.ShowHealth = Settings.ShowHealth or false
    Settings.VisCheck = false
    Settings.HideVisCheck = false

    if Object and not Object.PrimaryPart then
        return nil
    end
    ESP:CheckObject(Object)
 
    local NameESP = {}
    NameESP.Type = "Skeleton"
 
    NameESP.DrawingObject = Drawing.new("Text")
    NameESP.DrawingObject.Font = 3
    NameESP.DrawingObject.Size = Settings.Size or 12
    NameESP.DrawingObject.Color = Settings.Color or Color3.fromRGB(255, 255, 255)
    NameESP.DrawingObject.Text = Text
    NameESP.DrawingObject.Center = true
    NameESP.DrawingObject.Outline = Settings.Outline or false
    NameESP.Text = Text
    NameESP.ExtraText = ""
    NameESP.Object = Object
    NameESP.Part = Settings.Part and Settings.Part.Name or NameESP.Object.PrimaryPart.Name
    NameESP.Offset = Vector3.new(0, NameESP.Object:FindFirstChild(NameESP.Part).Size.Y, 0)
    NameESP.Removed = false
    NameESP.Connections = {}
 
    function NameESP:UpdateText(NewText)
        NameESP.Text = NewText
    end
 
    function NameESP:Update()
        if Settings.VisCheck then
            local VisCheckRayParams = RaycastParams.new()
            VisCheckRayParams.IgnoreWater = true
            VisCheckRayParams.FilterType = Enum.RaycastFilterType.Blacklist
            VisCheckRayParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, NameESP.Object, workspace.CurrentCamera}

            local PartToCheck = NameESP.Object:FindFirstChild("Head") or NameESP.Object.PrimaryPart
            local RayDirection = (PartToCheck.Position - workspace.CurrentCamera.CFrame.Position).Unit * (workspace.CurrentCamera.CFrame.Position - PartToCheck.Position).Magnitude

            local Raycast = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, RayDirection, VisCheckRayParams)
            
            if Raycast then
                NameESP.DrawingObject.Color = Settings.VisColor or Settings.Color
                if Settings.HideVisCheck then
                    NameESP.DrawingObject.Visible = false
                    return
                end
            else
                NameESP.DrawingObject.Color = Settings.Color
            end
        end

        local BoundingCFrame, BoundingSize = Object:GetBoundingBox()
        local NewCFrame = CFrame.new(BoundingCFrame.Position, workspace.Camera.CFrame.Position)
        local Offset

        local FinalText = NameESP.Text
        if Settings.ShowHealth and NameESP.Object:FindFirstChild("Humanoid") then
            FinalText ..= " [" .. math.round(NameESP.Object.Humanoid.Health) .. "/" .. NameESP.Object.Humanoid.MaxHealth .. "]"
        end
        if Settings.ShowDistance then
            FinalText ..= " " .. math.round((NameESP.Object:FindFirstChild(NameESP.Part).Position - workspace.CurrentCamera.CFrame.Position).Magnitude) .. " studs"
        end
        FinalText ..= NameESP.ExtraText
        NameESP.DrawingObject.Text = FinalText

        if Settings.Location == "Left" then
            NewCFrame += Vector3.new(-BoundingSize.X/2, -BoundingSize.Y, 0)
            Offset = Vector2.new()
        elseif Settings.Location == "Right" then
            NewCFrame += Vector3.new(BoundingSize.X/2, -BoundingSize.Y, 0)
            Offset = Vector2.new()
        elseif Settings.Location == "Bottom" then
            NewCFrame += Vector3.new(0, -BoundingSize.Y/2, 0)
            Offset = Vector2.new(0, NameESP.DrawingObject.TextBounds.Y/2)
        elseif Settings.Location == "Top" then
            NewCFrame += Vector3.new(0, BoundingSize.Y/2 + 0.5, 0)
            Offset = Vector2.new(0, -NameESP.DrawingObject.TextBounds.Y)
        end

        local Vector, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(NewCFrame.Position)

        NameESP.DrawingObject.Visible = OnScreen

        if OnScreen then
            local NewObjectPosition = Vector2.new(Vector.X, Vector.Y) + Offset
            NameESP.DrawingObject.Position = NewObjectPosition
        end
    end

    function NameESP:ChangeSetting(Setting, Value)
        print("changing setting", Setting, Value)
        Settings[Setting] = Value
    end

    function NameESP:Hide()
        NameESP.DrawingObject.Visible = false
    end

    function NameESP:Remove()
        if NameESP.DrawingObject.__OBJECT_EXISTS == true then
            NameESP.DrawingObject:Remove()

            for i,v in pairs(NameESP.Connections) do
                v:Disconnect()
            end
        end

        NameESP.Removed = true
    end
 
    table.insert(ESP.ActiveObjects[Object], NameESP)
 
    return NameESP
end

function ESP:HealthBar(Object, Settings)
    Settings = Settings or {}

    Settings.Thickness = Settings.Thickness or 4
    Settings.Color = Settings.Color or Color3.fromRGB(0, 170, 0)
    Settings.Location = Settings.Location or "Left"
    Settings.KeepMiddle = Settings.KeepMiddle or nil
    Settings.VisCheck = false
    Settings.HideVisCheck = false

    if Object and not Object.PrimaryPart then
        return nil
    end
    ESP:CheckObject(Object)
 
    local HealthBarESP = {}
    HealthBarESP.Type = "HealthBar"

    HealthBarESP.DrawingObjectBackground = Drawing.new("Line")
    HealthBarESP.DrawingObject = Drawing.new("Line")
    HealthBarESP.DrawingObject.Thickness = Settings.Thickness or 4
    HealthBarESP.DrawingObject.Color = Settings.Color or Color3.fromRGB(170, 0, 0)
    HealthBarESP.DrawingObject.ZIndex = 2
    HealthBarESP.DrawingObjectBackground.Color = Color3.fromRGB(34, 34, 34)
    HealthBarESP.DrawingObjectBackground.Thickness = Settings.Thickness + 2 -- + 1 or 5
    HealthBarESP.DrawingObjectBackground.ZIndex = 1
    HealthBarESP.Object = Object
    HealthBarESP.Part = HealthBarESP.Object.PrimaryPart.Name
    HealthBarESP.Removed = false

    function HealthBarESP:Update()
        if Settings.VisCheck then
            local VisCheckRayParams = RaycastParams.new()
            VisCheckRayParams.IgnoreWater = true
            VisCheckRayParams.FilterType = Enum.RaycastFilterType.Blacklist
            VisCheckRayParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, HealthBarESP.Object, workspace.CurrentCamera}

            local PartToCheck = HealthBarESP.Object:FindFirstChild("Head") or HealthBarESP.Object.PrimaryPart
            local RayDirection = (PartToCheck.Position - workspace.CurrentCamera.CFrame.Position).Unit * (workspace.CurrentCamera.CFrame.Position - PartToCheck.Position).Magnitude

            local Raycast = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, RayDirection, VisCheckRayParams)
            
            if Raycast then
                if Settings.HideVisCheck then
                    HealthBarESP.DrawingObject.Visible = false
                    return
                end
            end
        end

        local HeadCFrame = HealthBarESP.Object.Head.CFrame + Vector3.new(0, HealthBarESP.Object.Head.Size.Y, 0)
        local RootCFrame = HealthBarESP.Object.PrimaryPart.CFrame
        local LegCFrame = RootCFrame - Vector3.new(0, 4, 0)

        Settings.FaceCamera = true
        if Settings.FaceCamera then
            HeadCFrame = CFrame.new(HeadCFrame.Position, workspace.Camera.CFrame.Position)
            RootCFrame = CFrame.new(RootCFrame.Position, workspace.Camera.CFrame.Position)
            LegCFrame = CFrame.new(LegCFrame.Position, workspace.Camera.CFrame.Position)
        end

        local RootVector, IsVisible = WorldToViewportPoint(workspace.CurrentCamera, RootCFrame.Position)
        local HeadVector = WorldToViewportPoint(workspace.CurrentCamera, HeadCFrame.Position)
        local LegVector = WorldToViewportPoint(workspace.CurrentCamera, LegCFrame.Position)
        
        if IsVisible then
            local DistanceY = math.clamp((Vector2.new(HeadVector.X, HeadVector.Y) - Vector2.new(RootVector.X, RootVector.Y)).Magnitude, 2, math.huge)

            local d = (Vector2.new(RootVector.X - DistanceY, RootVector.Y - DistanceY*2) - Vector2.new(RootVector.X - DistanceY, RootVector.Y + DistanceY*2)).Magnitude 
            local healthoffset = Object.Humanoid.Health/Object.Humanoid.MaxHealth * d

            HealthBarESP.DrawingObject.From = Vector2.new(RootVector.X - DistanceY - 5, RootVector.Y + DistanceY*4)
            HealthBarESP.DrawingObject.To = Vector2.new(RootVector.X - DistanceY - 5, RootVector.Y + DistanceY*4 - healthoffset)

            HealthBarESP.DrawingObjectBackground.From = Vector2.new(RootVector.X - DistanceY - 5, RootVector.Y + DistanceY*4)
            HealthBarESP.DrawingObjectBackground.To = Vector2.new(RootVector.X - DistanceY - 5, RootVector.Y + DistanceY*4)

            local Green = Color3.fromRGB(0, 255, 0)
            local Red = Color3.fromRGB(255, 0, 0)

            HealthBarESP.DrawingObject.Color = Red:Lerp(Green, Object.Humanoid.Health/Object.Humanoid.MaxHealth)

            HealthBarESP.DrawingObject.Visible = true
            HealthBarESP.DrawingObjectBackground.Visible = true
        else
            HealthBarESP.DrawingObject.Visible = false
            HealthBarESP.DrawingObjectBackground.Visible = false
        end
    end

    function HealthBarESP:ChangeSetting(Setting, Value)
        Settings[Setting] = Value
    end

    function HealthBarESP:Hide()
        HealthBarESP.DrawingObjectBackground.Visible = false
        HealthBarESP.DrawingObject.Visible = false
    end

    function HealthBarESP:Remove()
        if HealthBarESP.DrawingObject.__OBJECT_EXISTS == true then
            HealthBarESP.DrawingObjectBackground:Remove()
            HealthBarESP.DrawingObject:Remove()
        end

        HealthBarESP.Removed = true
    end

    table.insert(ESP.ActiveObjects[Object], HealthBarESP)

    return HealthBarESP
end

function ESP:Chams(Object, Settings)
    Settings = Settings or {}

    Settings.DepthMode = Settings.DepthMode or Enum.HighlightDepthMode.AlwaysOnTop
    Settings.FillColor = Settings.FillColor or Color3.fromRGB(255, 0, 0)
    Settings.FillTransparency = Settings.FillTransparency or 0.5
    Settings.OutlineColor = Settings.OutlineColor or Color3.fromRGB(255, 255, 255)
    Settings.OutlineTransparency = Settings.OutlineTransparency or 0

    ESP:CheckObject(Object)

    local ChamsESP = {}
    ChamsESP.Type = "HealthBar"

    ChamsESP.Object = Instance.new("Highlight")
    ChamsESP.Object.DepthMode = Settings.DepthMode
    ChamsESP.Object.FillColor = Settings.FillColor
    ChamsESP.Object.FillTransparency = Settings.FillTransparency
    ChamsESP.Object.OutlineColor = Settings.OutlineColor
    ChamsESP.Object.OutlineTransparency = Settings.OutlineTransparency
    ChamsESP.Object.Parent = game.CoreGui
    ChamsESP.Object.Adornee = Object

    function ChamsESP:ChangeSetting(Setting, Value)
        Settings[Setting] = Value
    end

    function ChamsESP:Update()
        ChamsESP.Object.Enabled = true
    end

    function ChamsESP:Hide()
        ChamsESP.Object.Enabled = false
    end

    function ChamsESP:Remove()
        if ChamsESP.Object then
            ChamsESP.Object:Destroy()
            ChamsESP.Object = nil
        end

        ChamsESP.Removed = true
    end

    table.insert(ESP.ActiveObjects[Object], ChamsESP)
    return ChamsESP
end

function ESP:Start()
    ESP.Connections.MainConnection = RunService.RenderStepped:Connect(function()
        for i,ObjectTable in pairs(ESP.ActiveObjects) do
            for i2,v in pairs(ObjectTable) do
                if i.Parent and i.PrimaryPart and v.Part and v.Removed == false then
                    v:Update()
                else
                    if v.Removed == false then
                        v.Visible = false
                        v:Remove()
                        ESP.ActiveObjects[i][i2] = nil
                    else
                        ESP.ActiveObjects[i][i2] = nil
                    end
                end
            end
        end
 
    end)
end
 
function ESP:Stop()
    ESP.Connections.MainConnection:Disconnect()

    for i,ObjectTable in pairs(ESP.ActiveObjects) do
        for i2,v in pairs(ObjectTable) do
            if v and v.Hide then
                v:Hide()
            end
        end
    end
end

return ESP
