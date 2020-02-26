-- object fo_unsc_grav_lift

--## SERVER

function fo_unsc_grav_lift:init()

	RegisterManCannonLaunchedObjectEvent(UNSCGravLiftLaunchedObject, self);

end

function UNSCGravLiftLaunchedObject(gravLift:object, launchedObject:object)
	RunClientScript("UNSCGravLiftLaunchedObjectClient",gravLift,launchedObject);
end

--## CLIENT

function remoteClient.UNSCGravLiftLaunchedObjectClient(gravLift:object, launchedObject:object)

	print ("Grav Launched",gravLift,launchedObject);

	effect_new_on_object_marker(TAG('objects\levels\forge\fo_unsc_grav_lift\fx\fo_unsc_grav_lift_launch.effect'), gravLift, "fx_launch" );
	effect_new_on_object_marker(TAG('objects\levels\forge\fo_unsc_grav_lift\fx\fo_unsc_grav_lift_launch_blur.effect'), launchedObject, "fx_shield_core" );

 end
 
 