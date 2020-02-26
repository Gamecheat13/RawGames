-- object fo_fore_grav_lift

--## SERVER

function fo_fore_grav_lift:init()

	RegisterManCannonLaunchedObjectEvent(FOREGravliftLaunchedObject, self);

end

function FOREGravliftLaunchedObject(manCannon:object, launchedObject:object)
	RunClientScript("FOREGravliftLaunchedObjectClient",manCannon,launchedObject);
end

--## CLIENT

function remoteClient.FOREGravliftLaunchedObjectClient(manCannon:object, launchedObject:object)

	effect_new_on_object_marker(TAG('objects\levels\forge\fo_fore_grav_lift\fx\fo_fore_grav_lift_fire.effect'), manCannon, "fx_base" );
	effect_new_on_object_marker(TAG('objects\levels\forge\fo_fore_grav_lift\fx\fo_fore_grav_lift_launch_blur.effect'), launchedObject, "fx_shield_core" );

 end
 