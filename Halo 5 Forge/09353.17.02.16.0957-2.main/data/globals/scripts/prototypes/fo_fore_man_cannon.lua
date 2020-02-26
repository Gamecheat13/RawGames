-- object fo_fore_man_cannon

--## SERVER

function fo_fore_man_cannon:init()

	RegisterManCannonLaunchedObjectEvent(FOREManCannonLaunchedObject, self);

end

function FOREManCannonLaunchedObject(manCannon:object, launchedObject:object)
	RunClientScript("FOREManCannonLaunchedObjectClient",manCannon,launchedObject);
end

--## CLIENT

function remoteClient.FOREManCannonLaunchedObjectClient(manCannon:object, launchedObject:object)

	effect_new_on_object_marker(TAG('objects\levels\forge\fo_fore_man_cannon\fx\fo_fore_man_cannon_fire.effect'), manCannon, "fx_rear" );
	effect_new_on_object_marker(TAG('objects\levels\forge\fo_fore_man_cannon\fx\fo_fore_man_cannon_launch_blur.effect'), launchedObject, "fx_shield_core" );

 end
 