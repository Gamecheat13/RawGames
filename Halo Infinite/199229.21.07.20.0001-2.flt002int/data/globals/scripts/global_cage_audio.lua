--## CLIENT

hstructure CageAudioInstance
	stack: cage_stack;
	transform: cage_transform_provider;
	orientationCallback: ifunction;
	emitters: table;
end


function CageAudio_OrientationUpdateLoop(self: CageAudioInstance)
	while self and self.orientationCallback do
		local vec = self.orientationCallback();
		local quat = Quaternion_FromForwardUp(vec, vector(0, 0, 1));
		Cage_TransformSetTargetRotation(self.transform, quat);
		Cage_StackForceUpdate(self.stack, 1);
		Sleep(1);
	end
end


function CageAudio_CreateEmitters(
	definition, stackName: string, player: player, orientation: ifunction, attachPoints: table): CageAudioInstance
	local result = hmake CageAudioInstance {
		stack = nil;
		transform = nil;
		orientationCallback = nil;
		emitters = {};
	};
	result.stack = Cage_StackGetOrCreate(stackName);
	result.transform = Cage_TransformCreateStaticProvider(vector(0, 0, 0), quaternion(0, 0, 0, 0));
	Cage_StackBlendTo(result.stack, result.transform, nil, 0);
	result.orientationCallback = orientation;
	for key, value in pairs(attachPoints) do
		local ref;
		if player then
			ref = cage_point_reference(definition, key, player);
		else
			ref = cage_point_reference(definition, key);
		end
		if ref then
			local id = CageAudio_CreateEmitter(ref, value, result.stack);
			result.emitters[key] = id;
		end
	end
	if result.orientationCallback then
		CreateThread([| CageAudio_OrientationUpdateLoop(result) ]);
	end
	return result;
end


function CageAudio_DestroyEmitters(instance: CageAudioInstance)
	if instance.emitters then
		for key, value in pairs(instance.emitters) do
			CageAudio_DestroyEmitter(value);
			instance.emitters[key] = nil;
		end
		instance.emitters = nil;
	end
	if instance.stack then
		Cage_StackRemove(instance.stack);
		instance.stack = nil;
	end
	instance.orientationCallback = nil;
end



