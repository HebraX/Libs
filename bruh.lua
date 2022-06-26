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
local l__ProjectileInflict__10 = game.ReplicatedStorage.Remotes.ProjectileInflict;
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
    local v22 = nil
	if p11.Item.Attachments:FindFirstChild("Front") then
		v22 = p11.Item.Attachments.Front:GetChildren()[1].Barrel;
		local l__Barrel__23 = p10.Attachments.Front:GetChildren()[1].Barrel;
	else
		v22 = p11.Item.Barrel;
		local l__Barrel__24 = p10.Barrel;
	end;
	local l__ItemRoot__25 = p10.ItemRoot;
	local v26 = l__RangedWeapons__2:FindFirstChild(p9.Name);
	local v27 = l__ReplicatedStorage__3.AmmoTypes:FindFirstChild(p13);
	local v28 = v26:GetAttribute("ProjectileColor");
	local v29 = v26:GetAttribute("BulletMaterial");
	local v30 = v27:GetAttribute("ProjectileDrop");
	local v31 = v27:GetAttribute("MuzzleVelocity");

    local OriginalProjectileDrop = v30
    local OriginalMuzzleVelocity = v31
    if Settings.FastBullet then
		if Settings.CurrentTargetPart then else
			v31 = 5000
		end
	end
    if Settings.NoBulletDrop then
        v30 = 0
    end

	local v32 = v27:GetAttribute("Tracer");
	local v33 = v26:GetAttribute("RecoilRecoveryTimeMod");
	local v34 = v27:GetAttribute("AccuracyDeviation");
	local v35 = v27:GetAttribute("Pellets");
	local v36 = v27:GetAttribute("Damage");
	local v37 = v27:GetAttribute("Arrow");
	local v38 = v27:GetAttribute("ProjectileWidth");
	if p15 and v26:FindFirstChild("RecoilPattern") then
		local v39 = #v26.RecoilPattern:GetChildren();
		if p15 == 1 then
			local v40 = {
				x = {
					Value = v26.RecoilPattern["1"].x.Value * math.random(-3, 3) * 0.33
				}, 
				y = {
					Value = v26.RecoilPattern["1"].y.Value
				}
			};
		else
			v40 = v26.RecoilPattern:FindFirstChild(tostring(p15));
		end;
	else
		v40 = {
			x = {
				Value = math.random(-5, 5) * 0.01
			}, 
			y = {
				Value = math.random(5, 10) * 0.01
			}
		};
	end;
	local v41 = p9.ItemProperties.Tool:GetAttribute("MuzzleDevice") and "Default" or "Default";
	local v42 = v27:GetAttribute("RecoilStrength");
	local v43 = v42;
	local v44 = v42;
	local l__Attachments__45 = p9:FindFirstChild("Attachments");
	if l__Attachments__45 then
		local v46 = l__Attachments__45:GetChildren();
		for v47 = 1, #v46 do
			local v48 = v46[v47]:FindFirstChildOfClass("StringValue");
			if v48 and v48.ItemProperties:FindFirstChild("Attachment") then
				local l__Attachment__49 = v48.ItemProperties.Attachment;
				local v50 = l__Attachment__49:GetAttribute("Recoil");
				if v50 then
					v43 = v43 + v50 * l__Attachment__49:GetAttribute("HRecoilMod");
					v44 = v44 + v50 * l__Attachment__49:GetAttribute("VRecoilMod");
				end;
				local v51 = l__Attachment__49:GetAttribute("MuzzleDevice");
				if v51 then
					v41 = v51;
					if p11.Item.Attachments.Muzzle:FindFirstChild(v48.Name):FindFirstChild("BarrelExtension") then
						v22 = p11.Item.Attachments.Muzzle:FindFirstChild(v48.Name):FindFirstChild("BarrelExtension");
						local l__BarrelExtension__52 = p10.Attachments.Muzzle:FindFirstChild(v48.Name):FindFirstChild("BarrelExtension");
					end;
				end;
			end;
		end;
	end;
	if v41 == "Suppressor" then
		if tick() - p14 < 0.8 then
			u3:PlaySoundV2(l__ItemRoot__25.FireSoundSupressed, l__ItemRoot__25.FireSoundSupressed.TimeLength, l__HumanoidRootPart__21);
		else
			u3:PlaySoundV2(l__ItemRoot__25.FireSoundSupressed, l__ItemRoot__25.FireSoundSupressed.TimeLength, l__HumanoidRootPart__21);
		end;
	elseif tick() - p14 < 0.8 then
		u3:PlaySoundV2(l__ItemRoot__25.FireSound, l__ItemRoot__25.FireSound.TimeLength, l__HumanoidRootPart__21);
	else
		u3:PlaySoundV2(l__ItemRoot__25.FireSound, l__ItemRoot__25.FireSound.TimeLength, l__HumanoidRootPart__21);
	end;
	if v26:GetAttribute("MuzzleEffect") == true then
		local v53 = l__VFX__4.MuzzleEffects:FindFirstChild(v41):GetChildren();
		local v54 = v53[math.random(1, #v53)];
		local v55 = v54.Particles:GetChildren();
		if v54:FindFirstChild("MuzzleLight") then
			local v56 = v54.MuzzleLight:Clone();
			v56.Enabled = true;
			l__Debris__5:AddItem(v56, 0.1);
			v56.Parent = v22;
		end;
		for v57 = 1, #v55 do
			if v55[v57].className == "ParticleEmitter" then
				local v58 = v55[v57]:Clone();
				local v59 = math.clamp(v36 / 45 / 2.5, 0, 0.6);
				if v35 then
					v59 = math.clamp(v36 * v35 / 45 / 2.5, 0, 0.6);
				end;
				v58.Lifetime = NumberRange.new(v58.Lifetime.Max * v59);
				v58.Size = u6(v58.Size, v59);
				v58.Parent = v22;
				local u12 = v58:GetAttribute("EmitCount") and 1;
				delay(0.01, function()
					v58:Emit(u12);
					l__Debris__5:AddItem(v58, v58.Lifetime.Max);
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
	local u18 = v31 / 2700;
	local function v60()
		u13 = u13 + 1;
		local v61 = RaycastParams.new();
		v61.FilterType = Enum.RaycastFilterType.Blacklist;
		local v62 = { l__Character__20, p11, u7 };
		v61.FilterDescendantsInstances = v62;
		v61.IgnoreWater = false;
		v61.CollisionGroup = "WeaponRay";
		local v63 = tick();
		local v64 = l__LookVector__14;
		local v65 = Vector3.new(l__p__15.X, l__p__15.Y + 1.6, l__p__15.Z);
		local v66 = v65 + l__LookVector__14 * 1000;

        if Settings.NoSpread then
            v34 = 0
        end

		if v34 then
			v66 = v66 + Vector3.new(math.random(-v34, v34), math.random(-v34, v34), math.random(-v34, v34));
			v64 = (v66 - v65).Unit;
		end;
		if u13 == 1 then
			u16 = v66.Y .. "posY" .. game.Players.LocalPlayer.UserId .. "Id" .. tick();
			l__FireProjectile__8:FireServer(v64, u16, false, {});
		elseif u13 > 1 then
			l__FireProjectile__8:FireServer(v64, u16, true, {});
		end;
		local v67 = nil;
		if v32 then
			v67 = l__VFX__4.MuzzleEffects.Tracer:Clone();
			v67.Name = u16;
			v67.Color = v28;
			l__Debris__5:AddItem(v67, 6);
			v67.Position = Vector3.new(0, -100, 0);
			v67.Parent = game.Workspace.NoCollision.Effects;
		end;
		local u19 = nil;
		local u20 = 0;
		local u21 = v65;
		local u22 = v64;
		local u23 = 0;
		local u24 = {};
		local u25 = false;
		local function u26()
			if v67 then
				v67:Destroy();
			end;
			u19:Disconnect();
		end;
		local u27 = {
			a1 = OriginalProjectileDrop, 
			a2 = OriginalMuzzleVelocity
		};
		u19 = game:GetService("RunService").Heartbeat:Connect(function(p16)
			if Settings.FastBullet then
				u20 = 1
			else
				u20 = u20 + p16;
			end
			if u20 > 0.008333333333333333 then
				local v68 = v31 * u20;
				local v69 = workspace:Raycast(u21, u22 * v68, v61);
				local v70 = nil;
				local v71 = nil;
				local v72 = nil;
                local v73 = nil;
				if v69 then
					v70 = v69.Instance;
					v73 = v69.Position;
					v71 = v69.Normal;
					v72 = v69.Material;
				else
					v73 = u21 + u22 * v68;
				end;
                if Settings.FastBullet then
                    if Settings.CurrentTargetPart then
						local RaycastParamsForTestRaycast = RaycastParams.new()
						RaycastParamsForTestRaycast.FilterType = Enum.RaycastFilterType.Whitelist
						RaycastParamsForTestRaycast.IgnoreWater = true
						RaycastParamsForTestRaycast.FilterDescendantsInstances = {Settings.CurrentTargetPart.Parent}

						local TestRaycast = workspace:Raycast(l__CurrentCamera__17.CFrame.Position, (Settings.CurrentTargetPart.Position - l__CurrentCamera__17.CFrame.Position).Unit * 99999, v61);
						if TestRaycast then
							v70 = TestRaycast.Instance;
							v73 = TestRaycast.Position;
							v71 = TestRaycast.Normal;
							v72 = TestRaycast.Material;
						else
							v70 = Settings.CurrentTargetPart
							v73 = Settings.CurrentTargetPart.Position
							v71 = Settings.CurrentTargetPart.CFrame.LookVector
							v72 = Settings.CurrentTargetPart.Material
						end
                    else
                        v30 = 5000
                    end
                end
				local l__magnitude__74 = (u21 - v73).magnitude;
				u23 = u23 + l__magnitude__74;
				if v67 and u23 > 100 then
					local v75 = math.clamp((l__CurrentCamera__17.CFrame.Position - v73).magnitude / 90, 0.4 * u18, 1.2 * u18);
					v67.Size = Vector3.new(v75, v75, l__magnitude__74);
					v67.CFrame = CFrame.new(u21, v73) * CFrame.new(0, 0, -l__magnitude__74 / 2);
				end;
				if v70 then
					table.insert(u24, {
						stepAmount = u20, 
						dropTiming = 0
					});
					local v76 = u3:FindDeepAncestor(v70, "Model");
					if v70:GetAttribute("PassThrough", 2) then
						table.insert(v62, v70);
						v61.FilterDescendantsInstances = v62;
						return;
					elseif v70:GetAttribute("PassThrough", 1) and v37 == nil then
						table.insert(v62, v70);
						v61.FilterDescendantsInstances = v62;
						return;
					elseif v70:GetAttribute("Glass") then
						u9.Impact(v70, v73, v71, v72, u22, "Ranged", true);
						table.insert(v62, v70);
						v61.FilterDescendantsInstances = v62;
						return;
					elseif v70.Name == "Terrain" then
						if u25 == false and v72 == Enum.Material.Water then
							u25 = true;
							v61.IgnoreWater = true;
							u9.Impact(v70, v73, v71, v72, u22, "Ranged", true);
							return;
						else
							u9.Impact(v70, v73, v71, v72, u22, "Ranged", true);
							u26();
							return;
						end;
					elseif v76:FindFirstChild("Humanoid") then
						l__ProjectileInflict__10:FireServer(v76, v70, u16, u24, v73, u11(l__HumanoidRootPart__21, v73, v66), v70.Position.X - v73.X, v70.Position.Z - v73.Z, u27);
						u9.Impact(v70, v73, v71, v72, u22, "Ranged", true);
						u26();
						return;
					else
						if v76.ClassName == "Model" and v76.PrimaryPart ~= nil and v76.PrimaryPart:GetAttribute("Health") then
							l__ProjectileInflict__10:FireServer(v76, v70, u16, u24, v73, u11(l__HumanoidRootPart__21, v73, v66), v70.Position.X - v73.X, v70.Position.Z - v73.Z, u27);
							if v76.Parent.Name ~= "SleepingPlayers" and v71 then
								u9.Impact(v70, v73, v71, v72, u22, "Ranged", true);
							end;
						else
							u9.Impact(v70, v73, v71, v72, u22, "Ranged", true);
						end;
						u26();
						return;
					end;
				else
					if u23 > 2500 or tick() - v63 > 60 then
						u26();
						return;
					end;
					u21 = v73;
					local v77 = tick() - v63;
					u22 = (u21 + u22 * 10000 - Vector3.new(0, v30 / 2 * v77 ^ 2, 0) - u21).Unit;
					table.insert(u24, {
						stepAmount = u20, 
						dropTiming = v77
					});
					u20 = 0;
				end;
			end;
		end);
	end;
	if v35 ~= nil then
		local u28 = 0;
		coroutine.wrap(function()
			while u28 < 3 do
				wait();			
			end;
            if not Settings.NoRecoil then
			    u9.RecoilCamera(l__LocalPlayer__7, l__CurrentCamera__17, p12, v43, v44, v33, v40);
            end
		end)();
		for v78 = 1, v35 do
			coroutine.wrap(v60)();
			u28 = u28 + 1;
		end;
	else
		coroutine.wrap(v60)();
        if not Settings.NoRecoil then
		    u9.RecoilCamera(l__LocalPlayer__7, l__CurrentCamera__17, p12, v43, v44, v33, v40);
        end
	end;
	return v43 / 200, v44 / 200, v41, v40;
end;
return v1;
