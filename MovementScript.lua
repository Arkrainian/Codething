
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local Animations = RS.ClientAnimations.Animations.Player

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Camera = workspace.CurrentCamera

local Bodyparts ={
	Head = Character:WaitForChild("Head") :: BasePart,
	RightArm = Character:WaitForChild("Right Arm") :: BasePart,
	LeftArm = Character:WaitForChild("Left Arm") :: BasePart,
	RightLeg = Character:WaitForChild("Right Leg") :: BasePart,
	LeftLeg = Character:WaitForChild("Left Leg") :: BasePart,
	Torso = Character:WaitForChild("Torso") :: BasePart
}

local Settings = {
	Cooldown = 0.1,
	HipHeight = {
		Normal = 0,
		Crouch = -1,
		Prone = -1.3,
	},

}

Character:SetAttribute("Prone", false)





RunService:BindToRenderStep("CameraOffset",Enum.RenderPriority.Camera.Value-1,function()
	TweenService:Create(Humanoid,TweenInfo.new(0.3),{CameraOffset = (HumanoidRootPart.CFrame+Vector3.new(0,1.5,0)):pointToObjectSpace(Bodyparts.Head.CFrame.p)}):Play()
end)

local PlayerAnimations = {
	CrouchingIdle = Humanoid:LoadAnimation(Animations.Movement.CrouchIdle),
	CrouchingWalk = Humanoid:LoadAnimation(Animations.Movement.CrouchWalk),
	ProneIdle = Humanoid:LoadAnimation(Animations.Movement.ProneIdle),
	ProneWalk = Humanoid:LoadAnimation(Animations.Movement.ProneWalk),
	ProneRight = Humanoid:LoadAnimation(Animations.Movement.Prone.ProneRight),
	ProneLeft = Humanoid:LoadAnimation(Animations.Movement.Prone.ProneLeft),
	ProneBack = Humanoid:LoadAnimation(Animations.Movement.Prone.ProneBack),

}

PlayerAnimations.ProneIdle.Priority = Enum.AnimationPriority.Movement
PlayerAnimations.ProneRight.Priority = Enum.AnimationPriority.Movement
PlayerAnimations.ProneLeft.Priority = Enum.AnimationPriority.Movement
PlayerAnimations.ProneBack.Priority = Enum.AnimationPriority.Movement
PlayerAnimations.ProneWalk.Priority = Enum.AnimationPriority.Movement


local isCrouching = false
local isProne = false
local weightthing = 0
local Wdown = false
local Sdown = false
local Adown = false
local Ddown = false



local function IsPlayerMoving() --function
	if Humanoid.MoveDirection.Magnitude == 0 then --if the movedirection is equal to 0 then the following will happen;
		return false
	elseif Humanoid.MoveDirection.Magnitude > 0 then --if the movedirection is greater than 0 then the following will happen;
		return true
	end
end

function prone()
	if not isProne then 

		isProne = true
		if RS:FindFirstChild("ReplicateProne") then RS.ReplicateProne:FireServer(true) end
		Character:SetAttribute("Prone", true)
		Humanoid.HipHeight = Settings.HipHeight.Prone
		PlayerAnimations.ProneIdle:Play()
		PlayerAnimations.ProneWalk:Play()
		PlayerAnimations.ProneRight:Play()
		PlayerAnimations.ProneLeft:Play()
		PlayerAnimations.ProneBack:Play()
		Humanoid.WalkSpeed = 4
	else
		-- stop prone


		isProne = false
		Humanoid.AutoRotate = true
		if RS:FindFirstChild("ReplicateProne") then RS.ReplicateProne:FireServer(false) end
		Character:SetAttribute("Prone", false)
		Humanoid.HipHeight = Settings.HipHeight.Normal
		PlayerAnimations.ProneIdle:Stop()
		PlayerAnimations.ProneWalk:Stop()
		PlayerAnimations.ProneRight:Stop()
		PlayerAnimations.ProneLeft:Stop()
		PlayerAnimations.ProneBack:Stop()
		Humanoid.WalkSpeed = 12
	end
end




UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.C then
		Humanoid.AutoRotate = true
		PlayerAnimations.ProneIdle:Stop()
		PlayerAnimations.ProneWalk:Stop()
		PlayerAnimations.ProneRight:Stop()
		PlayerAnimations.ProneLeft:Stop()
		PlayerAnimations.ProneBack:Stop()
		isProne = false
		-- crouching
		print(isCrouching)
		if not isCrouching then 
			isCrouching = true
			Character:SetAttribute("Prone", false)
			Humanoid.HipHeight = Settings.HipHeight.Crouch
			--	PlayerAnimations.CrouchingWalk:Play()
			Humanoid.WalkSpeed = 6
		else
			-- stop crouching
			isCrouching = false
			Humanoid.HipHeight = Settings.HipHeight.Normal
			--	PlayerAnimations.CrouchingWalk:Stop()
			Humanoid.WalkSpeed = 12
		end
	elseif input.KeyCode == Enum.KeyCode.Z then
		--	PlayerAnimations.CrouchingWalk:Stop()
		isCrouching = false
		-- prone
		print(isProne)
		prone()
	elseif input.KeyCode == Enum.KeyCode.LeftAlt then
		if isProne then return end


		if Wdown then
			local bv = Instance.new("BodyVelocity")
			bv.Velocity = (HumanoidRootPart.CFrame.LookVector * 40) + (HumanoidRootPart.CFrame.UpVector * 10)
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.Parent = HumanoidRootPart
			Debris:AddItem(bv, 0.1)

			--	PlayerAnimations.CrouchingWalk:Stop()
			isCrouching = false
			-- prone
			print(isProne)


			prone()


		elseif Sdown then
			local bv = Instance.new("BodyVelocity")
			bv.Velocity = (HumanoidRootPart.CFrame.LookVector * 40) + (HumanoidRootPart.CFrame.UpVector * 10)
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.Parent = HumanoidRootPart
			Debris:AddItem(bv, 0.1)

			--	PlayerAnimations.CrouchingWalk:Stop()
			isCrouching = false
			-- prone
			print(isProne)


			prone()
		elseif Ddown then
			local bv = Instance.new("BodyVelocity")
			bv.Velocity = (HumanoidRootPart.CFrame.LookVector * 40) + (HumanoidRootPart.CFrame.UpVector * 10)
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.Parent = HumanoidRootPart
			Debris:AddItem(bv, 0.1)

			--	PlayerAnimations.CrouchingWalk:Stop()
			isCrouching = false
			-- prone
			print(isProne)




			prone()



		elseif Adown then
			local bv = Instance.new("BodyVelocity")
			bv.Velocity = (HumanoidRootPart.CFrame.LookVector * 40) + (HumanoidRootPart.CFrame.UpVector * 10)
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.Parent = HumanoidRootPart
			Debris:AddItem(bv, 0.1)


			--	PlayerAnimations.CrouchingWalk:Stop()
			isCrouching = false
			-- prone
			print(isProne)

			prone()
		end
	end

end)

local aiming = false

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = true
	end
end)
UserInputService.InputEnded:Connect(function(input, gp)
	if gp then return end

	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = false
	end
end)
local LookDP = 0

local RightDP =0


local onback = false
local onrightorleft = false
local onfront = false
RunService.RenderStepped:Connect(function()


	LookDP = (Camera.CFrame.LookVector*Vector3.new(1,0,1)).Unit:Dot(HumanoidRootPart.CFrame.LookVector.Unit)
	RightDP = (Camera.CFrame.RightVector*Vector3.new(1,0,1)).Unit:Dot(HumanoidRootPart.CFrame.LookVector.Unit)
	--if aiming == true then return end


	if isCrouching then
		if IsPlayerMoving() then

			--	PlayerAnimations.CrouchingWalk:AdjustSpeed(1)
		else
			--	
			--		PlayerAnimations.CrouchingWalk:AdjustSpeed(0)
		end
	else

		--	PlayerAnimations.CrouchingWalk:AdjustSpeed(0)
	end

	if isProne then

		PlayerAnimations.ProneIdle:AdjustWeight(LookDP)
		PlayerAnimations.ProneWalk:AdjustWeight(LookDP)
		PlayerAnimations.ProneBack:AdjustWeight(-LookDP)
		PlayerAnimations.ProneRight:AdjustWeight(-RightDP)
		PlayerAnimations.ProneLeft:AdjustWeight(RightDP)
		
		
		Character:SetAttribute("ProneIdleWeight", PlayerAnimations.ProneIdle.WeightCurrent)
		Character:SetAttribute("ProneWalkWeight", PlayerAnimations.ProneWalk.WeightCurrent)
		Character:SetAttribute("ProneBackWeight", PlayerAnimations.ProneBack.WeightCurrent)
		Character:SetAttribute("ProneLeftWeight", PlayerAnimations.ProneLeft.WeightCurrent)
		Character:SetAttribute("ProneRightWeight", PlayerAnimations.ProneRight.WeightCurrent)


		print("ProneIdle Weight is " , PlayerAnimations.ProneIdle.WeightCurrent)
		print("ProneBack Weight is " , PlayerAnimations.ProneBack.WeightCurrent)
		print("ProneLeft Weight is " , PlayerAnimations.ProneLeft.WeightCurrent)
		print("ProneRight Weight is " , PlayerAnimations.ProneRight.WeightCurrent)

		if PlayerAnimations.ProneRight.WeightCurrent > 0.4 or PlayerAnimations.ProneLeft.WeightCurrent> 0.4 then
			Humanoid.HipHeight = -0.8
			onrightorleft = true
			onfront = false
			onback = false
		elseif PlayerAnimations.ProneIdle.WeightCurrent > 0.9 or PlayerAnimations.ProneWalk.WeightCurrent> 0.9 then
			Humanoid.HipHeight = -1.3
			onfront = true
			onrightorleft = false
			onback = false
		elseif PlayerAnimations.ProneBack.WeightCurrent > 0.9 then
			onback = true
			onrightorleft = false
			onfront = false
		end


		if PlayerAnimations.ProneIdle.WeightCurrent < 0 then
			Humanoid.WalkSpeed = 0
		else
			Humanoid.WalkSpeed = 4
		end

		local currentProneState = "Idle"
		if onback then
			currentProneState = "Back"
		elseif onrightorleft then
			if PlayerAnimations.ProneRight.WeightCurrent > PlayerAnimations.ProneLeft.WeightCurrent then
				currentProneState = "Right"
			else
				currentProneState = "Left"
			end
		elseif onfront then
			if IsPlayerMoving() then
				currentProneState = "Walk"
			else
				currentProneState = "Idle"
			end
		end
		Character:SetAttribute("ProneState", currentProneState)
		print(currentProneState)
		if IsPlayerMoving() then
			if onfront then
				Humanoid.AutoRotate = true
				PlayerAnimations.ProneWalk:Play()
				PlayerAnimations.ProneWalk:AdjustSpeed(1)
			end
		else
			Humanoid.AutoRotate = false
			PlayerAnimations.ProneWalk:Stop()
			PlayerAnimations.ProneWalk:AdjustSpeed(0)
		end
	else

		PlayerAnimations.ProneWalk:AdjustSpeed(0)
	end



	if UIS:IsKeyDown(Enum.KeyCode.W) then
		Wdown = true

		PlayerAnimations.ProneWalk:AdjustSpeed(1)
	else
		Wdown = false
	end

	if UIS:IsKeyDown(Enum.KeyCode.S) then
		Sdown = true

		PlayerAnimations.ProneWalk:AdjustSpeed(-1)
	else
		Sdown = false
	end

	if UIS:IsKeyDown(Enum.KeyCode.D) then

		Ddown = true
	else
		Ddown = false
	end

	if UIS:IsKeyDown(Enum.KeyCode.A) then
		Adown = true
	else
		Adown = false
	end
end)


local context = game:GetService("ContextActionService")

context:BindAction("CameraMovement", function(_,_,input)
	print("x is: "..tostring(input.Delta.X), "y is: "..tostring(input.Delta.Y))
end, false, Enum.UserInputType.MouseMovement)

local ikon = false

local offsets = {Right = CFrame.new(0.5, -1, 0), Left = CFrame.new(-0.5, -1, 0)}
local IK = require(script:WaitForChild("IKHandler")).New(Character)

local legs = {"Left", "Right"}
local lastLeft = Vector3.zero
local lastRight = Vector3.zero



local Camera = game.Workspace.CurrentCamera

local tweenService = game:GetService("TweenService")

local char = Player.Character

local origRightS = char:WaitForChild("Torso"):WaitForChild("Right Shoulder").C0

local origLeftS = char:WaitForChild("Torso"):WaitForChild("Left Shoulder").C0

local origNeck = char:WaitForChild("Torso"):WaitForChild("Neck").C0

local m = Player:GetMouse()

local UIS = game:GetService("UserInputService")

local IsEquipped = false






--Changes the player's arm and head position to your mouse


--Enables if tool is equipped (If you want a specific tool to not move arm, add a value in the tool called HoldArmsStill)
char.ChildAdded:Connect(function()
	for i,v in pairs(char:GetChildren()) do
		if v:IsA("Tool") then
			if v:FindFirstChild("HoldArmsStill") then

			else
				IsEquipped = true

			end
		end
	end
end)

char.ChildRemoved:Connect(function(child)
	if child:IsA("Tool") then
		IsEquipped = false
	end
end)

