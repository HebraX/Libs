-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local l__Players__2 = game:GetService("Players");
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local l__Remotes__4 = l__ReplicatedStorage__3:WaitForChild("Remotes");
local l__Modules__5 = game.ReplicatedStorage:WaitForChild("Modules");
local l__SFX__6 = l__ReplicatedStorage__3:WaitForChild("SFX");
local l__LocalPlayer__7 = l__Players__2.LocalPlayer;
local v8 = l__ReplicatedStorage__3:WaitForChild("Players"):WaitForChild(l__LocalPlayer__7.Name);
local v9 = { "LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg", "LowerTorso", "RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg", "RightUpperLeg", "UpperTorso", "Head", "FaceHitBox", "HeadTopHitBox" };
local function u1(p1, p2)
	local v10 = p1.Origin - p2;
	local l__Direction__11 = p1.Direction;
	return p2 + (v10 - v10:Dot(l__Direction__11) / l__Direction__11:Dot(l__Direction__11) * l__Direction__11);
end;
local l__RangedWeapons__2 = l__ReplicatedStorage__3:WaitForChild("RangedWeapons");
local u3 = require(game.ReplicatedStorage.Modules:WaitForChild("FunctionLibraryExtension"));
local l__VFX__4 = game.ReplicatedStorage:WaitForChild("VFX");
local l__Debris__5 = game:GetService("Debris");
local function u6(p3, p4)
	local v12 = nil;
	local v13 = nil;
	local v14 = nil;
	local v15 = nil;
	local l__Keypoints__16 = p3.Keypoints;
	for v17 = 1, #l__Keypoints__16 do
		if v17 == 1 then
			v12 = NumberSequenceKeypoint.new(l__Keypoints__16[v17].Time, l__Keypoints__16[v17].Value * p4);
		elseif v17 == 2 then
			v13 = NumberSequenceKeypoint.new(l__Keypoints__16[v17].Time, l__Keypoints__16[v17].Value * p4);
		elseif v17 == 3 then
			v14 = NumberSequenceKeypoint.new(l__Keypoints__16[v17].Time, l__Keypoints__16[v17].Value * p4);
		elseif v17 == 4 then
			v15 = NumberSequenceKeypoint.new(l__Keypoints__16[v17].Time, l__Keypoints__16[v17].Value * p4);
		end;
	end;
	return NumberSequence.new({ v12, v13, v14, v15 });
end;
local u7 = require(game.ReplicatedStorage.Modules:WaitForChild("UniversalTables")).ReturnTable("GlobalIgnoreListProjectile");
local l__FireProjectile__8 = game.ReplicatedStorage.Remotes.FireProjectile;
local u9 = require(game.ReplicatedStorage.Modules:WaitForChild("VFX"));
local l__ProjectileInfIict__10 = game.ReplicatedStorage.Remotes.ProjectileInfIict;
local function u11(p5, p6, p7)
	local l__p__18 = p5.CFrame.p;
	local v19 = Vector3.new(l__p__18.X, l__p__18.Y + 1.6, l__p__18.Z);
	return u1(Ray.new(v19, (p7 - v19).unit * 7500), p6).Y;
end;
function v1.CreateBullet(p8, p9, p10, p11, p12, p13, p14, p15, Settings)
	local l__Character__20 = l__LocalPlayer__7.Character;
	local l__HumanoidRootPart__21 = l__Character__20.HumanoidRootPart;
	if not l__Character__20:FindFirstChild(p9.Name) then
		return;
	end;
    local v22 = nil;
	local v23 = nil;
	if p11.Item.Attachments:FindFirstChild("Front") then
		v22 = p11.Item.Attachments.Front:GetChildren()[1].Barrel;
		v23 = p10.Attachments.Front:GetChildren()[1].Barrel;
	else
		v22 = p11.Item.Barrel;
		v23 = p10.Barrel;
	end;
	local l__ItemRoot__24 = p10.ItemRoot;
	local v25 = l__RangedWeapons__2:FindFirstChild(p9.Name);
	local v26 = l__ReplicatedStorage__3.AmmoTypes:FindFirstChild(p13);
	local v27 = v25:GetAttribute("ProjectileColor");
	local v28 = v25:GetAttribute("BulletMaterial");
	local v29 = v26:GetAttribute("ProjectileDrop");
	local v30 = v26:GetAttribute("MuzzleVelocity");
	local v31 = v26:GetAttribute("Tracer");
	local v32 = v25:GetAttribute("RecoilRecoveryTimeMod");
	local v33 = v26:GetAttribute("Shotgun");
	local v34 = v26:GetAttribute("Damage");
	local v35 = v26:GetAttribute("Arrow");
	local v36 = v26:GetAttribute("ProjectileWidth");
	local v37 = nil;
	if p15 and v25:FindFirstChild("RecoilPattern") then
		local v38 = #v25.RecoilPattern:GetChildren();
		v37 = v25.RecoilPattern:FindFirstChild(tostring(p15));
	end;
	local v39 = p9.ItemProperties.Tool:GetAttribute("MuzzleDevice") and "Default";
	local v40 = v26:GetAttribute("RecoilStrength");
	local v41 = v40;
	local v42 = v40;
	local l__Attachments__43 = p9:FindFirstChild("Attachments");
	if l__Attachments__43 then
		local v44 = l__Attachments__43:GetChildren();
		for v45 = 1, #v44 do
			local v46 = v44[v45]:FindFirstChildOfClass("StringValue");
			if v46 and v46.ItemProperties:FindFirstChild("Attachment") then
				local l__Attachment__47 = v46.ItemProperties.Attachment;
				local v48 = l__Attachment__47:GetAttribute("Recoil");
				if v48 then
					v41 = v41 + v48 * l__Attachment__47:GetAttribute("HRecoilMod");
					v42 = v42 + v48 * l__Attachment__47:GetAttribute("VRecoilMod");
				end;
				local v49 = l__Attachment__47:GetAttribute("MuzzleDevice");
				if v49 then
					v39 = v49;
					if p11.Item.Attachments.Muzzle:FindFirstChild(v46.Name):FindFirstChild("BarrelExtension") then
						v23 = p11.Item.Attachments.Muzzle:FindFirstChild(v46.Name):FindFirstChild("BarrelExtension");
					end;
				end;
			end;
		end;
	end;
	if v39 == "Suppressor" then
		if tick() - p14 < 0.8 then
			u3:PlaySoundV2(l__ItemRoot__24.FireSoundSupressed, l__ItemRoot__24.FireSoundSupressed.TimeLength, l__HumanoidRootPart__21, l__ItemRoot__24.FireSoundSupressed.Volume * 1);
		else
			u3:PlaySoundV2(l__ItemRoot__24.FireSoundSupressed, l__ItemRoot__24.FireSoundSupressed.TimeLength, l__HumanoidRootPart__21, 1.7);
		end;
	elseif tick() - p14 < 0.8 then
		u3:PlaySoundV2(l__ItemRoot__24.FireSound, l__ItemRoot__24.FireSound.TimeLength, l__HumanoidRootPart__21, l__ItemRoot__24.FireSound.Volume * 1);
	else
		u3:PlaySoundV2(l__ItemRoot__24.FireSound, l__ItemRoot__24.FireSound.TimeLength, l__HumanoidRootPart__21, 1.7);
	end;
	if v25:GetAttribute("MuzzleEffect") == true then
		local v50 = l__VFX__4.MuzzleEffects:FindFirstChild(v39):GetChildren();
		local v51 = v23.MuzzleLight:Clone();
		v51.Enabled = true;
		l__Debris__5:AddItem(v51, 0.1);
		v51.Parent = v22;
		local v52 = v50[math.random(1, #v50)]:GetChildren();
		for v53 = 1, #v52 do
			if v52[v53].className == "ParticleEmitter" then
				local v54 = v52[v53]:Clone();
				local v55 = math.clamp(v34 / 45 / 2.5, 0, 0.6);
				if v33 then
					v55 = math.clamp(v34 * v33.Value / 45 / 2.5, 0, 0.6);
				end;
				v54.Lifetime = NumberRange.new(v54.Lifetime.Max * v55);
				v54.Size = u6(v54.Size, v55);
				v54.Parent = v22;
				local u12 = v54:GetAttribute("EmitCount") and 1;
				delay(0.01, function()
					v54:Emit(u12);
					l__Debris__5:AddItem(v54, v54.Lifetime.Max);
				end);
			end;
		end;
	end;
	local u13 = 0;
	local l__LookVector__14 = v22.CFrame.LookVector;
    if Settings.CurrentTargetPart then
        l__LookVector__14 = CFrame.new(v22.CFrame.Position, Settings.CurrentTargetPart.Position).LookVector
    end
	local l__p__15 = l__HumanoidRootPart__21.CFrame.p;
	local u16 = "";
	local l__CurrentCamera__17 = workspace.CurrentCamera;
	local u18 = v30 / 2700;
	local function v56()
		u13 = u13 + 1;
		local v57 = RaycastParams.new();
		v57.FilterType = Enum.RaycastFilterType.Blacklist;
		local v58 = { l__Character__20, p11, u7 };
		v57.FilterDescendantsInstances = v58;
		v57.IgnoreWater = false;
		v57.CollisionGroup = "WeaponRay";
		local v59 = tick();
		local v60 = Vector3.new(l__p__15.X, l__p__15.Y + 1.6, l__p__15.Z);
        local Range = Settings.InfRange and 99999 or 1000
		local v61 = v60 + l__LookVector__14 * Range + Vector3.new(math.random(0, 0), math.random(0, 0), math.random(0, 0));
		if v33 == nil then

		end;
		if u13 == 1 and v33 ~= nil or v33 == nil then
			u16 = v61.Y .. "posY" .. game.Players.LocalPlayer.UserId .. "Id" .. tick();
			l__FireProjectile__8:FireServer(v61, u16, false, {});
		elseif u13 > 1 and v33 ~= nil and u13 < v33.Value - 2 then
			l__FireProjectile__8:FireServer(v61, u16, true, {});
		end;
		local v62 = nil;
		if v31 then
			v62 = l__VFX__4.MuzzleEffects.Tracer:Clone();
			v62.Name = u16;
			v62.Color = v27;
			l__Debris__5:AddItem(v62, 6);
			v62.Position = Vector3.new(0, -100, 0);
			v62.Parent = game.Workspace.NoCollision.Effects;
		end;
		local u19 = nil;
		local u20 = 0;
		local u21 = v60;
		local u22 = l__LookVector__14;
		local u23 = 0;
		local u24 = {};
		local u25 = false;
		local function u26()
			if v62 then
				v62:Destroy();
			end;
			u19:Disconnect();
		end;
		u19 = game:GetService("RunService").Heartbeat:Connect(function(p16)
			u20 = u20 + p16;
			if u20 > 0.008333333333333333 then
				local v63 = v30 * u20;
				local v64 = workspace:Raycast(u21, u22 * v63, v57);
				local v65 = nil;
				local v66 = nil;
				local v67 = nil;
                local v68 = nil;
				if v64 then
					v65 = v64.Instance;
					v68 = v64.Position;
					v66 = v64.Normal;
					v67 = v64.Material;
				else
					v68 = u21 + u22 * v63;
				end;
                if Settings.FastBullet then
                    if Settings.CurrentTargetPart then
                        v65 = Settings.CurrentTargetPart
                        v68 = Settings.CurrentTargetPart.Position
                        v66 = Settings.CurrentTargetPart.CFrame.LookVector
                        v67 = Settings.CurrentTargetPart.Material
                    else
                        v30 = 5000
                    end
                end
				local l__magnitude__69 = (u21 - v68).magnitude;
				u23 = u23 + l__magnitude__69;
				if v62 and u23 > 100 then
					local v70 = math.clamp((l__CurrentCamera__17.CFrame.Position - v68).magnitude / 90, 0.4 * u18, 1.2 * u18);
					v62.Size = Vector3.new(v70, v70, l__magnitude__69);
					v62.CFrame = CFrame.new(u21, v68) * CFrame.new(0, 0, -l__magnitude__69 / 2);
				end;
				if v65 then
					table.insert(u24, {
						stepAmount = u20, 
						dropTiming = 0
					});
					local v71 = u3:FindDeepAncestor(v65, "Model");
					if v65:GetAttribute("PassThrough", 2) then
						table.insert(v58, v65);
						v57.FilterDescendantsInstances = v58;
						return;
					elseif v65:GetAttribute("PassThrough", 1) and v35 == nil then
						table.insert(v58, v65);
						v57.FilterDescendantsInstances = v58;
						return;
					elseif v65:GetAttribute("Glass") then
						u9.Impact(v65, v68, v66, v67, u22, "Ranged", true);
						table.insert(v58, v65);
						v57.FilterDescendantsInstances = v58;
						return;
					elseif v65.Name == "Terrain" then
						if u25 == false and v67 == Enum.Material.Water then
							u25 = true;
							v57.IgnoreWater = true;
							u9.Impact(v65, v68, v66, v67, u22, "Ranged", true);
							return;
						else
							u9.Impact(v65, v68, v66, v67, u22, "Ranged", true);
							u26();
							return;
						end;
					elseif v71:FindFirstChild("Humanoid") then
						l__ProjectileInfIict__10:FireServer(v71, v65, u16, u24, v68, u11(l__HumanoidRootPart__21, v68, v61), v65.Position.X - v68.X, v65.Position.Z - v68.Z);
						u9.Impact(v65, v68, v66, v67, u22, "Ranged", true);
						u26();
                        local HitmarkerSound = Instance.new("Sound")
                        HitmarkerSound.Parent = game.SoundService
                        HitmarkerSound.SoundId = "rbxassetid://4753603610"
                        HitmarkerSound:Play()
                        l__Debris__5:AddItem(HitmarkerSound, 5)
						return;
					else
						if v71.ClassName == "Model" and v71.PrimaryPart ~= nil and v71.PrimaryPart:GetAttribute("Health") then
							l__ProjectileInfIict__10:FireServer(v71, v65, u16, u24, v68, u11(l__HumanoidRootPart__21, v68, v61), v65.Position.X - v68.X, v65.Position.Z - v68.Z);
							if v71.Parent.Name ~= "SleepingPlayers" and v66 then
								u9.Impact(v65, v68, v66, v67, u22, "Ranged", true);
							end;
						else
							u9.Impact(v65, v68, v66, v67, u22, "Ranged", true);
						end;
						u26();
						return;
					end;
				else
					if u23 > 2500 or tick() - v59 > 60 then
						u26();
						return;
					end;
					u21 = v68;
					local v72 = tick() - v59;
					u22 = (u21 + u22 * 10000 - Vector3.new(0, v29 / 2 * v72 ^ 2, 0) - u21).Unit;
					table.insert(u24, {
						stepAmount = u20, 
						dropTiming = v72
					});
					u20 = 0;
				end;
			end;
		end);
	end;
	if v33 ~= nil then
		local u27 = 0;
		coroutine.wrap(function()
			while u27 < 3 do
				wait();			
			end;
            if not Settings.NoRecoil then
			    u9.RecoilCamera(l__LocalPlayer__7, l__CurrentCamera__17, p12, v41, v42, v32, v37);
            end
		end)();
		for v73 = 1, v33.Value do
			coroutine.wrap(v56)();
			u27 = u27 + 1;
		end;
	else
		coroutine.wrap(v56)();
        if not Settings.NoRecoil then
		    u9.RecoilCamera(l__LocalPlayer__7, l__CurrentCamera__17, p12, v41, v42, v32, v37);
        end
	end;
	return v41 / 200, v42 / 200, v39;
end;
return v1;
