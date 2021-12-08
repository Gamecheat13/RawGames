-- Copyright (c) Microsoft. All rights reserved.

function locomotion_blendspace()
    AnimGraph_VisualScripting["combat:locomotion_Source"] = {

	{animationName = 'locomote_walk_inplace',               looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 0, A = 0, autoDetectSpeed = true, autoDetectAngle = true},

		-- {animationName = 'locomote_walk_front',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .5, B = 0, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_frontright',            looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .5, B = 45, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_right',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .5, B = 90, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_backright',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .5, B = 135, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_back',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .5, B = 180, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_backleft',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .5, B = 215, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_left',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .5, B = 270, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_frontleft',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .5, B = 315, A = .5, autoDetectSpeed = true, autoDetectAngle = true},

		-- {animationName = 'locomote_walk_front',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .66, B = 0, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_frontright',            looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .66, B = 45, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_right',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .66, B = 90, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_backright',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .66, B = 135, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_back',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .66, B = 180, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_backleft',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .66, B = 215, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_left',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .66, B = 270, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_frontleft',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .66, B = 315, A = .5, autoDetectSpeed = true, autoDetectAngle = true},

		{animationName = 'locomote_walk_front',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 0, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_frontright',            looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 45, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_right',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 90, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_backright',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 135, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_back',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 180, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_backleft',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 215, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_left',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 270, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_frontleft',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 315, A = .5, autoDetectSpeed = true, autoDetectAngle = true},

		-- {animationName = 'locomote_walk_front',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1.2, B = 0, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_frontright',            looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1.2, B = 45, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_right',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1.2, B = 90, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_backright',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1.2, B = 135, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_back',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1.2, B = 180, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_backleft',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1.2, B = 215, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_left',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1.2, B = 270, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_walk_frontleft',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1.2, B = 315, A = .5, autoDetectSpeed = true, autoDetectAngle = true},

		-- {animationName = 'locomote_run_front',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .8, B = 0, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_run_frontright',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .8, B = 45, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_run_right',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .8, B = 90, A = 1, autoDetectSpeed = true,  autoDetectAngle = true},
		-- {animationName = 'locomote_run_backright',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .8, B = 135, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_run_back',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .8, B = 180, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_run_backleft',               looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .8, B = 215, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_run_left',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .8, B = 270, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		-- {animationName = 'locomote_run_frontleft',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = .8, B = 315, A = 1, autoDetectSpeed = true, autoDetectAngle = true},

		{animationName = 'locomote_run_front',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 0, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_frontright',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 45, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_right',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 90, A = 1, autoDetectSpeed = true,  autoDetectAngle = true},
		{animationName = 'locomote_run_backright',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 135, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_back',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 180, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_backleft',               looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 215, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_left',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 270, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_frontleft',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 315, A = 1, autoDetectSpeed = true, autoDetectAngle = true},

		{animationName = 'locomote_run_front',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 0, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_frontright',             looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 45, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_right',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 90, A = 1, autoDetectSpeed = true,  autoDetectAngle = true},
		{animationName = 'locomote_run_backright',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 135, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_back',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 180, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_backleft',               looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 215, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_left',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 270, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_frontleft',              looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 315, A = 1, autoDetectSpeed = true, autoDetectAngle = true}
    }
    return AnimGraph_VisualScripting["combat:locomotion_Source"]
end

function brute_locomotion_blendspace()
    local anims = {

	{animationName = 'locomote_walk_inplace',               looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 0, A = 0, autoDetectSpeed = true, autoDetectAngle = true},

		{animationName = 'locomote_walk_front',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 0, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_right',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 90, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_back',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 180, A = .5, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_walk_left',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 270, A = .5, autoDetectSpeed = true, autoDetectAngle = true},

		{animationName = 'locomote_run_front',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 0, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_right',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 90, A = 1, autoDetectSpeed = true,  autoDetectAngle = true},
		{animationName = 'locomote_run_back',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 180, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_left',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 1, B = 270, A = 1, autoDetectSpeed = true, autoDetectAngle = true},

		{animationName = 'locomote_run_front',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 0, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_right',                  looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 90, A = 1, autoDetectSpeed = true,  autoDetectAngle = true},
		{animationName = 'locomote_run_back',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 180, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
		{animationName = 'locomote_run_left',                   looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].combat_locomotion, playbackRate = 2, B = 270, A = 1, autoDetectSpeed = true, autoDetectAngle = true},
    }
    return anims
end

function airborne_blendspace()

    local jump_float =  control_airborne_progress_0to1()
    AnimGraph_VisualScripting["combat:airborne"] = {
                  
		{animationName = 'airborne_arc_center',                looping = false, mode = 2, groupName = AnimGraph_VisualScripting["groupNames"].airborne, playbackRate = 1, position = jump_float,B = 0, A = 0},
        
		{animationName = 'airborne_arc_front',                 looping = false, mode = 2, groupName = AnimGraph_VisualScripting["groupNames"].airborne, playbackRate = 1, position = jump_float, B = 0, A = 3},
		{animationName = 'airborne_arc_left',                  looping = false, mode = 2, groupName = AnimGraph_VisualScripting["groupNames"].airborne, playbackRate = 1, position = jump_float, B = 90, A = 3},
		{animationName = 'airborne_arc_back',                  looping = false, mode = 2, groupName = AnimGraph_VisualScripting["groupNames"].airborne, playbackRate = 1, position = jump_float, B = 180, A = 3},
		{animationName = 'airborne_arc_right',                 looping = false, mode = 2, groupName = AnimGraph_VisualScripting["groupNames"].airborne, playbackRate = 1, position = jump_float, B = 270, A = 3}
    }
    return AnimGraph_VisualScripting["combat:airborne"]
end
 

function turn_left_blendspace()
    AnimGraph_VisualScripting["turn_left_blendspace"] = {
                  
		{animationName = 'turn_left_slow',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].turn_left, playbackRate = 1.0 / 6.0, A = 6.0},
		{animationName = 'turn_left_slow',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].turn_left, playbackRate = 1, A = 36.666},
		{animationName = 'turn_left',                      looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].turn_left, playbackRate = 1, A = 200.0},
		{animationName = 'turn_left_fast',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].turn_left, playbackRate = 1, A = 360.0}
    }
    return AnimGraph_VisualScripting["turn_left_blendspace"]
end
 
function turn_right_blendspace()
    AnimGraph_VisualScripting["turn_right_blendspace"] = {
                  
		{animationName = 'turn_right_slow',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].turn_right, playbackRate = 1.0 / 6.0, A = -6.0},
		{animationName = 'turn_right_slow',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].turn_right, playbackRate = 1, A = -36.666},
		{animationName = 'turn_right',                      looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].turn_right, playbackRate = 1, A = -200.0},
		{animationName = 'turn_right_fast',                 looping = true, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].turn_right, playbackRate = 1, A = -360.0}
    }
    return AnimGraph_VisualScripting["turn_right_blendspace"]
end

function clamber_enter_blendspace()
	AnimGraph_VisualScripting["clamber_enter_blendspace"] = {
		{animationName = 'clamber_enter_topleft',				looping = false, mode = 2, groupName = "clamber_enter", playbackRate = 1, position = 0, A = -45.0},
		{animationName = 'clamber_enter_top',					looping = false, mode = 2, groupName = "clamber_enter", playbackRate = 1, position = 0, A = 0.0},
		{animationName = 'clamber_enter_topright',				looping = false, mode = 2, groupName = "clamber_enter", playbackRate = 1, position = 0, A = 45.0},
	}
	return AnimGraph_VisualScripting["clamber_enter_blendspace"]
end

function clamber_exit_blendspace()
	AnimGraph_VisualScripting["clamber_exit_blendspace"] = {
		{animationName = 'clamber_exit_left',					looping = false, mode = 2, groupName = "clamber_exit", playbackRate = 1, position = 0, A = -45.0},
		{animationName = 'clamber_exit_front',					looping = false, mode = 2, groupName = "clamber_exit", playbackRate = 1, position = 0, A = 0.0},
		{animationName = 'clamber_exit_right',					looping = false, mode = 2, groupName = "clamber_exit", playbackRate = 1, position = 0, A = 45.0},
	}
	return AnimGraph_VisualScripting["clamber_exit_blendspace"]
end

function land_soft_blendspace()
    AnimGraph_VisualScripting["combat:land_soft"] = {
		{animationName = 'land_soft_center',                looping = false, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].land_soft, playbackRate = 1, B = 0, A = 0},

		{animationName = 'land_soft_front',                 looping = false, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].land_soft, playbackRate = 1, B = 0, A = 3},
		{animationName = 'land_soft_left',                  looping = false, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].land_soft, playbackRate = 1, B = 90, A = 3},
		{animationName = 'land_soft_back',                  looping = false, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].land_soft, playbackRate = 1, B = 180, A = 3},
		{animationName = 'land_soft_right',                 looping = false, mode = 1, groupName = AnimGraph_VisualScripting["groupNames"].land_soft, playbackRate = 1, B = 270, A = 3}
    }
    return AnimGraph_VisualScripting["combat:land_soft"]
end

function banking_1d_blend()
	local anims = {}

	--these are creating animations from a single output animation 'banking', using the third argument to change the animation mode to frame mode(0)
	anims['right_pose'] = AnimGraph.CreateAnimationWithGroupName("banking", false, 0, "banking", 1.000000)
	anims['center_pose'] = AnimGraph.CreateAnimationWithGroupName("banking", false, 0, "banking", 1.000000)
	anims['left_pose'] = AnimGraph.CreateAnimationWithGroupName("banking", false, 0, "banking", 1.000000)

	--create floats to input into the animations to create 
	local zero = AnimGraph.CreateConstantFloat(0.0)
	local one = AnimGraph.CreateConstantFloat(1.0)
	local two = AnimGraph.CreateConstantFloat(2.0)

	--connect the floats to the animations to set the frame with the .Position input pin
	NG.CreateLink(zero.Out, anims['right_pose'].Position)
	NG.CreateLink(one.Out, anims['center_pose'].Position)
	NG.CreateLink(two.Out, anims['left_pose'].Position)

	--create the 1D blendspace with am alpha min of -1 and max of 1 
	local one_d_blendpspace = AnimGraph.CreateBlendSpace1D(-1, 1)

	--add the animations to the one_d_blendspace and place then on the alpha coordinates
	AnimGraph.AddBlendSpaceInputPose1D(one_d_blendpspace, -1, anims['right_pose'])
	AnimGraph.AddBlendSpaceInputPose1D(one_d_blendpspace, 0, anims['center_pose'])
	AnimGraph.AddBlendSpaceInputPose1D(one_d_blendpspace, 1, anims['left_pose'])

	--create the control parameter
	local control_parameter = AnimGraph.CreateFloatControlParameter('banking_factor')

	--connect the control parameter to the one_d_blendspace.  This changes the input position to blend the different poses
	NG.CreateLink(control_parameter.Out, one_d_blendpspace.Alpha)
	
	--return the blendspace to be used in a different graph
	return one_d_blendpspace
end