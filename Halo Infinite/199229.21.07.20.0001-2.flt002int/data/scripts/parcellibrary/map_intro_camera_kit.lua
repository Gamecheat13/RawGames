-- object map_intro_camera
-- Copyright (c) Microsoft. All rights reserved.

REQUIRES('globals/scripts/global_hstructs.lua');
REQUIRES('globals/scripts/global_cage.lua');

hstructure map_intro_camera
	meta:table;				-- required
	instance:luserdata;		-- required (must be first slot after meta to prevent crash)
	components:userdata;	-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")

	-- Base Properties
	order:number;			--$$ METADATA {"min": 1, "prettyName": "Sequence Order"}
	cameraType:string		--$$ METADATA {"prettyName": "Camera Blend", "source": ["Start", "End", "Custom"], "tooltip": "Part of the sequence that this camera is located. Determines timing and fade transitions."}
	cameraProperties:string;	--$$ METADATA {"prettyName": "Camera Settings", "source": ["Default", "Custom"], "tooltip": "Use default camera properties or enable the custom settings below"}

	-- Time Settings
	blendTime:number;		--$$ METADATA {"min": 0, "groupName": "Custom Blend Settings", "prettyName": "Blend Time", "tooltip": "Time in seconds to blend to this camera. Use 0 to cut."}
	duration:number;		--$$ METADATA {"min": 0.1, "groupName": "Custom Blend Settings", "prettyName": "Pause Time", "tooltip": "Time in seconds to pause on this camera once blend completes"}

	-- Fade Settings
	fadeType:string		--$$ METADATA {"groupName": "Custom Blend Settings", "prettyName": "Transition", "source": ["None", "Fade In", "Fade Out"], "tooltip": "Apply a fade transition"}

	-- Camera Settings
	hFOV:number;						--$$ METADATA {"min": 30, "max": 100, "groupName": "Custom Camera Settings", "prettyName": "Horizontal FOV"}
	focusDistance:number;				--$$ METADATA {"min": 1, "max": 100, "groupName": "Custom Camera Settings", "prettyName": "Focus Distance"}
	FStop:number;						--$$ METADATA {"min": 1, "max": 30, "groupName": "Custom Camera Settings"}
end

function map_intro_camera:init()
	self:ValidateDefaults();
end

function map_intro_camera:ValidateDefaults()
	self.order = self.order or 1;
	self.cameraType = self.cameraType or "Start";

	-- Determine Blend Time and Duration
	if (self.cameraType == "Start") then
		self.blendTime = 0;	-- Ensures we cut to this camera
		self.duration = 0;
		self.fadeType = "Fade In";
	elseif (self.cameraType == "End") then
		self.blendTime = 5;
		self.duration = 0;
		self.fadeType = "Fade Out";
	else
		self.blendTime = self.blendTime;
		self.duration = self.duration;
		self.fadeType = self.fadeType;
	end

	-- camera settings
	self.cameraProperties = self.cameraProperties or "Default";

	if (self.cameraProperties == "Default") then
		self.hFOV = 90;
		self.focusDistance = 10;
		self.FStop = 8;
	else
		self.hFOV = self.hFOV;
		self.focusDistance = self.focusDistance;
		self.FStop = self.FStop;
	end
end

function map_intro_camera:AddToStack(stack, isInitial:boolean):void -- Can't add typing to param since CageSystem isn't compiled first
	local locMatrix:matrix = ToLocation(self.components.camera_location).matrix;
	local transformProvider:cage_transform_provider = Cage_TransformCreateStaticProvider(locMatrix.pos, locMatrix.rot);
	local propertiesProvider:cage_properties_provider = Cage_PropertiesCreateCameraProvider(self.hFOV, self.focusDistance, self.FStop);

	Cage_TransformSetBlendCurve(transformProvider, curve_wrapper(CURVE_BUILT_IN.EaseOutQuad));
	Cage_TransformOSNSetRotationOffsetScale(transformProvider, vector(0.5, 0.5, 0.25));
	
	Cage_StackBlendTo(stack, transformProvider, propertiesProvider, self.blendTime);
end

function map_intro_camera:GetOrder():number
	return self.order;
end

function map_intro_camera:GetTotalTime():number
	return (self.blendTime + self.duration);
end

function map_intro_camera:GetFadeType():number
	return self.fadeType;
end