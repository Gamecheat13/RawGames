-- Copyright (c) Microsoft. All rights reserved.

-- clamber control functions
function clamber_enter()
	local clamberEnterBlend:table = AnimGraph.DuplicateReturnNodeForVisualScripting(AnimGraph.CreateBlendSpace1D(-45.0, 45.0));
	local clamberEnterAnims = {};
	local clamberProgress = AnimGraph.CreateFloatControlParameter("clamber_progress_0to1");

	for key, entry in ipairs(clamber_enter_blendspace()) do
		local animationName = entry.animationName;
		clamberEnterAnims[animationName..entry.playbackRate] = AnimGraph.CreateAnimationWithGroupName(animationName, entry.looping, entry.mode, entry.groupName, entry.playbackRate);
		AnimGraph.AddBlendSpaceInputPose1D(clamberEnterBlend, entry.A, clamberEnterAnims[animationName..entry.playbackRate].Out);

		NG.CreateLink(clamberProgress.Out, clamberEnterAnims[animationName..entry.playbackRate].Position);
	end

	return clamberEnterBlend;
end

function clamber_exit()
	local clamberExitBlend:table = AnimGraph.DuplicateReturnNodeForVisualScripting(AnimGraph.CreateBlendSpace1D(-45.0, 45.0));
	local clamberExitAnims = {};
	local clamberProgress = AnimGraph.CreateFloatControlParameter("clamber_progress_0to1");

	for key, entry in ipairs(clamber_exit_blendspace()) do
		local animationName = entry.animationName;
		clamberExitAnims[animationName..entry.playbackRate] = AnimGraph.CreateAnimationWithGroupName(animationName, entry.looping, entry.mode, entry.groupName, entry.playbackRate);
		AnimGraph.AddBlendSpaceInputPose1D(clamberExitBlend, entry.A, clamberExitAnims[animationName..entry.playbackRate].Out);

		NG.CreateLink(clamberProgress.Out, clamberExitAnims[animationName..entry.playbackRate].Position);
	end

	return clamberExitBlend;
end
