local RunService = game:GetService("RunService")

local Character = script.Parent
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Torso = Character:WaitForChild("Torso")

-- Configuration
local ANIMATION_SPEED = 10
local SWAY_AMPLITUDE_Y = 0.25      -- Vertical bounce (was 1/4)
local SWAY_AMPLITUDE_XZ = 1.5      -- Horizontal sway divisor (was 1.5)
local LERP_ALPHA = 0.3

-- Create Welds
local RightLegWeld = Instance.new("Weld")
RightLegWeld.Name = "RightLegWeld"
RightLegWeld.Part0 = Torso
RightLegWeld.Part1 = Character:WaitForChild("Right Leg")
RightLegWeld.C0 = CFrame.new(0.5, -2, 0)
RightLegWeld.Parent = Torso

local LeftLegWeld = Instance.new("Weld")
LeftLegWeld.Name = "LeftLegWeld"
LeftLegWeld.Part0 = Torso
LeftLegWeld.Part1 = Character:WaitForChild("Left Leg")
LeftLegWeld.C0 = CFrame.new(-0.5, -1, 0)
LeftLegWeld.Parent = Torso

-- Helper function to check if moving
local function IsMoving()
	return RootPart.Velocity.Magnitude > 1
end

RunService.Stepped:Connect(function()
	if Character:GetAttribute("Prone") == true then
		LeftLegWeld.Enabled = false
		RightLegWeld.Enabled = false
		return
	end

	local time = os.clock()
	local sineWave = math.sin(time * ANIMATION_SPEED)
	local cosineWave = math.cos(time * ANIMATION_SPEED)

	if IsMoving() then
		LeftLegWeld.Enabled = true
		RightLegWeld.Enabled = true

		local moveDir = Humanoid.MoveDirection
		local rootY = math.rad(RootPart.Orientation.Y)

		-- Calculate leg offsets
		-- Using Sine for Z (forward/back) and Cosine for Y (up/down) to create circular motion

		-- Left Leg Target
		local leftTarget = CFrame.new(-0.5, -1 + cosineWave * SWAY_AMPLITUDE_Y, 0)
			* CFrame.Angles(0, -rootY, 0) -- Cancel out root rotation for local space effect? Or align with movement?
			* CFrame.fromEulerAnglesXYZ(
				(-sineWave * moveDir.Z) / SWAY_AMPLITUDE_XZ,
				0,
				(-sineWave * -moveDir.X) / SWAY_AMPLITUDE_XZ
			)
			* CFrame.Angles(0, rootY, 0)
			* CFrame.new(0, -1, 0)

		-- Right Leg Target
		local rightTarget = CFrame.new(0.5, -1 - cosineWave * SWAY_AMPLITUDE_Y, 0)
			* CFrame.Angles(0, -rootY, 0)
			* CFrame.fromEulerAnglesXYZ(
				(sineWave * moveDir.Z) / SWAY_AMPLITUDE_XZ,
				0,
				(sineWave * -moveDir.X) / SWAY_AMPLITUDE_XZ
			)
			* CFrame.Angles(0, rootY, 0)
			* CFrame.new(0, -1, 0)

		-- Apply Lerp
		LeftLegWeld.C0 = LeftLegWeld.C0:Lerp(leftTarget, LERP_ALPHA)
		RightLegWeld.C0 = RightLegWeld.C0:Lerp(rightTarget, LERP_ALPHA)
	else

		LeftLegWeld.Enabled = false
		RightLegWeld.Enabled = false
	end
end)