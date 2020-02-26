-- object ms_grav_lift_a


--## SERVER

function ms_grav_lift_a:init()

	RegisterManCannonLaunchedObjectEvent(MSManCannonLaunchedObject, self);

end

function MSManCannonLaunchedObject(manCannon:object, launchedObject:object)
	print ("Cannon Launched");
	RunClientScript("MSManCannonLaunchedObjectClient", manCannon, launchedObject);
 end
 
 --## CLIENT

 function remoteClient.MSManCannonLaunchedObjectClient(manCannon:object, launchedObject:object)

	print ("gravlift Launched");

	effect_new_on_object_marker(TAG('levels\assets\osiris\props\mp_midship\ms_grav_lift_a\fx\midship_gravlift_use.effect'), manCannon, "fx_01_mkr" );
	effect_new_on_object_marker(TAG('levels\assets\osiris\props\mp_midship\ms_grav_lift_a\fx\midship_gravlift_launch_blur.effect'), launchedObject, "fx_shield_core" );

 end
