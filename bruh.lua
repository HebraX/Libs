-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = require(game.ReplicatedStorage.Modules:WaitForChild("UniversalTables"));
local l__Players__3 = game:GetService("Players");
local l__ReplicatedStorage__4 = game:GetService("ReplicatedStorage");
local l__Remotes__5 = l__ReplicatedStorage__4:WaitForChild("Remotes");
local l__Modules__6 = game.ReplicatedStorage:WaitForChild("Modules");
local l__SFX__7 = l__ReplicatedStorage__4:WaitForChild("SFX");
local l__LocalPlayer__8 = l__Players__3.LocalPlayer;
local v9 = l__ReplicatedStorage__4:WaitForChild("Players"):WaitForChild(l__LocalPlayer__8.Name);
local v10 = { "LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg", "LowerTorso", "RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg", "RightUpperLeg", "UpperTorso", "Head", "FaceHitBox", "HeadTopHitBox" };
local function u1(p1, p2)
	local v11 = p1.Origin - p2;
	local l__Direction__12 = p1.Direction;
	return p2 + (v11 - v11:Dot(l__Direction__12) / l__Direction__12:Dot(l__Direction__12) * l__Direction__12);
end;
local l__RangedWeapons__2 = l__ReplicatedStorage__4:WaitForChild("RangedWeapons");
local u3 = require(game.ReplicatedStorage.Modules:WaitForChild("FunctionLibraryExtension"));
local l__VFX__4 = game.ReplicatedStorage:WaitForChild("VFX");
local l__Debris__5 = game:GetService("Debris");
local function u6(p3, p4)
	local v13 = nil;
	local v14 = nil;
	local v15 = nil;
	local v16 = nil;
	local l__Keypoints__17 = p3.Keypoints;
	for v18 = 1, #l__Keypoints__17 do
		if v18 == 1 then
			v13 = NumberSequenceKeypoint.new(l__Keypoints__17[v18].Time, l__Keypoints__17[v18].Value * p4);
		elseif v18 == 2 then
			v14 = NumberSequenceKeypoint.new(l__Keypoints__17[v18].Time, l__Keypoints__17[v18].Value * p4);
		elseif v18 == 3 then
			v15 = NumberSequenceKeypoint.new(l__Keypoints__17[v18].Time, l__Keypoints__17[v18].Value * p4);
		elseif v18 == 4 then
			v16 = NumberSequenceKeypoint.new(l__Keypoints__17[v18].Time, l__Keypoints__17[v18].Value * p4);
		end;
	end;
	return NumberSequence.new({ v13, v14, v15, v16 });
end;
local u7 = v2.ReturnTable("GlobalIgnoreListProjectile");
local l__RootScanHeight__8 = v2.UniversalTable.GameSettings.RootScanHeight;
local l__FireProjectile__9 = game.ReplicatedStorage.Remotes.FireProjectile;
local u10 = require(game.ReplicatedStorage.Modules:WaitForChild("VFX"));
local l__ProjectileInflict__11 = game.ReplicatedStorage.Remotes.ProjectileInflict;
local function u12(p5, p6, p7)
	local l__p__19 = p5.CFrame.p;
	local v20 = Vector3.new(l__p__19.X, l__p__19.Y + 1.6, l__p__19.Z);
	return u1(Ray.new(v20, (p7 - v20).unit * 7500), p6).Y;
end;
function v1.CreateBullet(p8, p9, p10, p11, p12, p13, p14, p15, p16, Settings)
	local l__Character__21 = l__LocalPlayer__8.Character;
	local l__HumanoidRootPart__22 = l__Character__21.HumanoidRootPart;
	if not l__Character__21:FindFirstChild(p9.Name) then
		return;
	end;
    local v23
	if p11.Item.Attachments:FindFirstChild("Front") then
		v23 = p11.Item.Attachments.Front:GetChildren()[1].Barrel;
		local l__Barrel__24 = p10.Attachments.Front:GetChildren()[1].Barrel;
	else
		v23 = p11.Item.Barrel;
		local l__Barrel__25 = p10.Barrel;
	end;
	local l__ItemRoot__26 = p10.ItemRoot;
	local v27 = l__RangedWeapons__2:FindFirstChild(p9.Name);
	local v28 = l__ReplicatedStorage__4.AmmoTypes:FindFirstChild(p13);
	local v29 = v27:GetAttribute("ProjectileColor");
	local v30 = v27:GetAttribute("BulletMaterial");
	local v31 = v28:GetAttribute("ProjectileDrop");
	local v32 = v28:GetAttribute("MuzzleVelocity");

    local OriginalProjectileDrop = v31
    local OriginalMuzzleVelocity = v32
    if Settings.FastBullet then
		if Settings.CurrentTargetPart then else
			v32 = 5000
		end
	end
    if Settings.NoBulletDrop then
        v31 = 0
    end

	local v33 = v28:GetAttribute("Tracer");
	local v34 = v27:GetAttribute("RecoilRecoveryTimeMod");
	local v35 = v28:GetAttribute("AccuracyDeviation");
	local v36 = v28:GetAttribute("Pellets");
	local v37 = v28:GetAttribute("Damage");
	local v38 = v28:GetAttribute("Arrow");
	local v39 = v28:GetAttribute("ProjectileWidth");
    local v40
    local v41
	if p15 and v27:FindFirstChild("RecoilPattern") then
		v40 = #v27.RecoilPattern:GetChildren();
		if p15 == 1 then
			v41 = {
				x = {
					Value = v27.RecoilPattern["1"].x.Value * math.random(-3, 3) * 0.33
				}, 
				y = {
					Value = v27.RecoilPattern["1"].y.Value
				}
			};
		else
			v41 = v27.RecoilPattern:FindFirstChild(tostring(p15));
		end;
	else
		v41 = {
			x = {
				Value = math.random(-5, 5) * 0.01
			}, 
			y = {
				Value = math.random(5, 10) * 0.01
			}
		};
	end;
	local v42 = p9.ItemProperties.Tool:GetAttribute("MuzzleDevice") and "Default" or "Default";
	local v43 = v28:GetAttribute("RecoilStrength");
	local v44 = v43;
	local v45 = v43;
	local l__Attachments__46 = p9:FindFirstChild("Attachments");
	if l__Attachments__46 then
		local v47 = l__Attachments__46:GetChildren();
		for v48 = 1, #v47 do
			local v49 = v47[v48]:FindFirstChildOfClass("StringValue");
			if v49 and v49.ItemProperties:FindFirstChild("Attachment") then
				local l__Attachment__50 = v49.ItemProperties.Attachment;
				local v51 = l__Attachment__50:GetAttribute("Recoil");
				if v51 then
					v44 = v44 + v51 * l__Attachment__50:GetAttribute("HRecoilMod");
					v45 = v45 + v51 * l__Attachment__50:GetAttribute("VRecoilMod");
				end;
				local v52 = l__Attachment__50:GetAttribute("MuzzleDevice");
				if v52 then
					v42 = v52;
					if p11.Item.Attachments.Muzzle:FindFirstChild(v49.Name):FindFirstChild("BarrelExtension") then
						v23 = p11.Item.Attachments.Muzzle:FindFirstChild(v49.Name):FindFirstChild("BarrelExtension");
						local l__BarrelExtension__53 = p10.Attachments.Muzzle:FindFirstChild(v49.Name):FindFirstChild("BarrelExtension");
					end;
				end;
			end;
		end;
	end;
	if v42 == "Suppressor" then
		if tick() - p14 < 0.8 then
			u3:PlaySoundV2(l__ItemRoot__26.FireSoundSupressed, l__ItemRoot__26.FireSoundSupressed.TimeLength, l__HumanoidRootPart__22);
		else
			u3:PlaySoundV2(l__ItemRoot__26.FireSoundSupressed, l__ItemRoot__26.FireSoundSupressed.TimeLength, l__HumanoidRootPart__22);
		end;
	elseif tick() - p14 < 0.8 then
		u3:PlaySoundV2(l__ItemRoot__26.FireSound, l__ItemRoot__26.FireSound.TimeLength, l__HumanoidRootPart__22);
	else
		u3:PlaySoundV2(l__ItemRoot__26.FireSound, l__ItemRoot__26.FireSound.TimeLength, l__HumanoidRootPart__22);
	end;
	if v27:GetAttribute("MuzzleEffect") == true then
		local v54 = l__VFX__4.MuzzleEffects:FindFirstChild(v42):GetChildren();
		local v55 = v54[math.random(1, #v54)];
		local v56 = v55.Particles:GetChildren();
		if v55:FindFirstChild("MuzzleLight") then
			local v57 = v55.MuzzleLight:Clone();
			v57.Enabled = true;
			l__Debris__5:AddItem(v57, 0.1);
			v57.Parent = v23;
		end;
		for v58 = 1, #v56 do
			if v56[v58].className == "ParticleEmitter" then
				local v59 = v56[v58]:Clone();
				local v60 = math.clamp(v37 / 45 / 2.5, 0, 0.6);
				if v36 then
					v60 = math.clamp(v37 * v36 / 45 / 2.5, 0, 0.6);
				end;
				v59.Lifetime = NumberRange.new(v59.Lifetime.Max * v60);
				v59.Size = u6(v59.Size, v60);
				v59.Parent = v23;
				local u13 = v59:GetAttribute("EmitCount") and 1;
				delay(0.01, function()
					v59:Emit(u13);
					l__Debris__5:AddItem(v59, v59.Lifetime.Max);
				end);
			end;
		end;
	end;
	local u14 = 0;
	local l__LookVector__15 = p16.CFrame.LookVector;
    if Settings.CurrentTargetPart then
        l__LookVector__15 = CFrame.new(v23.CFrame.Position, Settings.CurrentTargetPart.Position).LookVector
    end
	local l__p__16 = l__HumanoidRootPart__22.CFrame.p;
	local u17 = "";
	local l__CurrentCamera__18 = workspace.CurrentCamera;
	local u19 = v32 / 2700;
	local function v61()
		u14 = u14 + 1;
		local v62 = RaycastParams.new();
		v62.FilterType = Enum.RaycastFilterType.Blacklist;
		local v63 = { l__Character__21, p11, u7 };
		v62.FilterDescendantsInstances = v63;
		v62.IgnoreWater = false;
		v62.CollisionGroup = "WeaponRay";
		local v64 = tick();
		local v65 = l__LookVector__15;
		local v66 = Vector3.new(l__p__16.X, l__p__16.Y + l__RootScanHeight__8, l__p__16.Z);
		local v67 = v66 + l__LookVector__15 * 1000;
        if Settings.NoSpread then
            v35 = 0
        end
		if v35 then
			v67 = v67 + Vector3.new(math.random(-v35, v35), math.random(-v35, v35), math.random(-v35, v35));
			v65 = (v67 - v66).Unit;
		end;
		if u14 == 1 then
			u17 = v67.Y .. "posY" .. game.Players.LocalPlayer.UserId .. "Id" .. tick();
			l__FireProjectile__9:FireServer(v65, u17, false, {});
		elseif u14 > 1 then
			l__FireProjectile__9:FireServer(v65, u17, true, {});
		end;
		local v68 = nil;
		if v33 then
			v68 = l__VFX__4.MuzzleEffects.Tracer:Clone();
			v68.Name = u17;
			v68.Color = v29;
			l__Debris__5:AddItem(v68, 6);
			v68.Position = Vector3.new(0, -100, 0);
			v68.Parent = game.Workspace.NoCollision.Effects;
		end;
		local u20 = nil;
		local u21 = 0;
		local u22 = v66;
		local u23 = v65;
		local u24 = 0;
		local u25 = {};
		local u26 = false;
		local function u27()
			if v68 then
				v68:Destroy();
			end;
			u20:Disconnect();
		end;
		local u28 = {
			a1 = OriginalProjectileDrop, 
			a2 = OriginalMuzzleVelocity
		};
		u20 = game:GetService("RunService").Heartbeat:Connect(function(p17)
            if Settings.FastBullet then
				u21 = 1
			else
				u21 = u21 + p17;
			end
			u21 = u21 + p17;
			if u21 > 0.008333333333333333 then
				local v69 = v32 * u21;
				local v70 = workspace:Raycast(u22, u23 * v69, v62);
				local v71 = nil;
				local v72 = nil;
				local v73 = nil;
                local v74 = nil;
				if v70 then
					v71 = v70.Instance;
					v74 = v70.Position;
					v72 = v70.Normal;
					v73 = v70.Material;
				else
					v74 = u22 + u23 * v69;
				end;
                if Settings.FastBullet then
                    if Settings.CurrentTargetPart then
						local RaycastParamsForTestRaycast = RaycastParams.new()
						RaycastParamsForTestRaycast.FilterType = Enum.RaycastFilterType.Whitelist
						RaycastParamsForTestRaycast.IgnoreWater = true
						RaycastParamsForTestRaycast.FilterDescendantsInstances = {Settings.CurrentTargetPart.Parent}

						local TestRaycast = workspace:Raycast(l__CurrentCamera__18.CFrame.Position, (Settings.CurrentTargetPart.Position - l__CurrentCamera__18.CFrame.Position).Unit * 99999, v62);
						if TestRaycast then
							v71 = TestRaycast.Instance;
							v74 = TestRaycast.Position;
							v72 = TestRaycast.Normal;
							v73 = TestRaycast.Material;
						else
							v71 = Settings.CurrentTargetPart
							v74 = Settings.CurrentTargetPart.Position
							v72 = Settings.CurrentTargetPart.CFrame.LookVector
							v73 = Settings.CurrentTargetPart.Material
						end
                    else
                        v31 = 5000
                    end
                end
				local l__magnitude__75 = (u22 - v74).magnitude;
				u24 = u24 + l__magnitude__75;
				if v68 and u24 > 100 then
					local v76 = math.clamp((l__CurrentCamera__18.CFrame.Position - v74).magnitude / 90, 0.4 * u19, 1.2 * u19);
					v68.Size = Vector3.new(v76, v76, l__magnitude__75);
					v68.CFrame = CFrame.new(u22, v74) * CFrame.new(0, 0, -l__magnitude__75 / 2);
				end;
				if v71 then
					table.insert(u25, {
						stepAmount = u21, 
						dropTiming = 0
					});
					local v77 = u3:FindDeepAncestor(v71, "Model");
					if v71:GetAttribute("PassThrough", 2) then
						table.insert(v63, v71);
						v62.FilterDescendantsInstances = v63;
						return;
					elseif v71:GetAttribute("PassThrough", 1) and v38 == nil then
						table.insert(v63, v71);
						v62.FilterDescendantsInstances = v63;
						return;
					elseif v71:GetAttribute("Glass") then
						u10.Impact(v71, v74, v72, v73, u23, "Ranged", true);
						table.insert(v63, v71);
						v62.FilterDescendantsInstances = v63;
						return;
					elseif v71.Name == "Terrain" then
						if u26 == false and v73 == Enum.Material.Water then
							u26 = true;
							v62.IgnoreWater = true;
							u10.Impact(v71, v74, v72, v73, u23, "Ranged", true);
							return;
						else
							u10.Impact(v71, v74, v72, v73, u23, "Ranged", true);
							u27();
							return;
						end;
					elseif v77:FindFirstChild("Humanoid") then
						l__ProjectileInflict__11:FireServer(v77, v71, u17, u25, v74, u12(l__HumanoidRootPart__22, v74, v67), v71.Position.X - v74.X, v71.Position.Z - v74.Z, u28);
						u10.Impact(v71, v74, v72, v73, u23, "Ranged", true);
                        local HitmarkerSound = Instance.new("Sound")
                        HitmarkerSound.Parent = game.SoundService
                        HitmarkerSound.SoundId = "rbxassetid://4753603610"
                        HitmarkerSound.Volume = 8
                        HitmarkerSound:Play()
                        l__Debris__5:AddItem(HitmarkerSound, 5)
						u27();
						return;
					else
						if v77.ClassName == "Model" and v77.PrimaryPart ~= nil and v77.PrimaryPart:GetAttribute("Health") then
							l__ProjectileInflict__11:FireServer(v77, v71, u17, u25, v74, u12(l__HumanoidRootPart__22, v74, v67), v71.Position.X - v74.X, v71.Position.Z - v74.Z, u28);
							if v77.Parent.Name ~= "SleepingPlayers" and v72 then
								u10.Impact(v71, v74, v72, v73, u23, "Ranged", true);
							end;
						else
							u10.Impact(v71, v74, v72, v73, u23, "Ranged", true);
						end;
						u27();
						return;
					end;
				else
					if u24 > 2500 or tick() - v64 > 60 then
						u27();
						return;
					end;
					u22 = v74;
					local v78 = tick() - v64;
					u23 = (u22 + u23 * 10000 - Vector3.new(0, v31 / 2 * v78 ^ 2, 0) - u22).Unit;
					table.insert(u25, {
						stepAmount = u21, 
						dropTiming = v78
					});
					u21 = 0;
				end;
			end;
		end);
	end;
	if v36 ~= nil then
		local u29 = 0;
		coroutine.wrap(function()
			while u29 < 3 do
				wait();			
			end;
            if not Settings.NoRecoil then
			    u10.RecoilCamera(l__LocalPlayer__8, l__CurrentCamera__18, p12, v44, v45, v34, v41);
            end
		end)();
		for v79 = 1, v36 do
			coroutine.wrap(v61)();
			u29 = u29 + 1;
		end;
	else
		coroutine.wrap(v61)();
        if not Settings.NoRecoil then
		    u10.RecoilCamera(l__LocalPlayer__8, l__CurrentCamera__18, p12, v44, v45, v34, v41);
        end
	end;
    if not v41 then
        v41 = {
			x = {
				Value = 0
			}, 
			y = {
				Value = 0
			}
		};
    end
	return v44 / 200, v45 / 200, v42, v41;
end;
return v1;
