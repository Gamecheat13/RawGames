-- object dws_trigger_volume

--## SERVER

hstructure dws_trigger_volume
	meta : table;
	instance : luserdata;
	components : userdata;

	dwsEventList:string;			--$$ METADATA {"visible": true}
	dwsState:string;				--$$ METADATA {"visible": true}
	interpTime:number;				--$$ METADATA {"visible": true}
	interpSteps:number;				--$$ METADATA {"visible": true}

	inVolume:boolean;
	dwsTriggered:boolean;
end

global g_VolumesStandingIn = {}

function dws_trigger_volume:init()
	self.dwsState = self.dwsState or "";
	if not self.dwsEventList or self.dwsEventList == "" then
		self.dwsEventList = self.dwsState;
	end
	self.interpTime = self.interpTime or 1;
	self.interpSteps = self.interpSteps or 10;

	self.inVolume = false;
	self.dwsTriggered = true;

	g_VolumesStandingIn[self.dwsState] = 0;
end

function dws_trigger_volume:ActivationVolumeEntered(activationVolume:activation_volume)
	self.inVolume = true;
	if Dws_IsStatePushed(Engine_ResolveStringId(self.dwsEventList), Engine_ResolveStringId(self.dwsState)) == false then
		self.dwsState = self.dwsState or "";
		self.interpTime = self.interpTime or 1;
		self.interpSteps = self.interpSteps or 10;
		Dws_PushEventList_StringId_OverrideMode(Engine_ResolveStringId(self.dwsEventList), Engine_ResolveStringId(self.dwsState), self.interpTime, self.interpSteps);
	end
	g_VolumesStandingIn[self.dwsState] = (g_VolumesStandingIn[self.dwsState] or 0) + 1;
	print(g_VolumesStandingIn[self.dwsState]);
end

function dws_trigger_volume:ActivationVolumeExited(activationvolume:activation_volume)
	if g_VolumesStandingIn[self.dwsState] == nil or g_VolumesStandingIn[self.dwsState] <= 1 then
		Dws_PopEventList_OverrideMode(Engine_ResolveStringId(self.dwsEventList), self.interpTime, self.interpSteps);
	end
	g_VolumesStandingIn[self.dwsState] = (g_VolumesStandingIn[self.dwsState] or 1) - 1;
	if g_VolumesStandingIn[self.dwsState] <= 0 then
		self.inVolume = false;
	end
	print(g_VolumesStandingIn[self.dwsState]);
end