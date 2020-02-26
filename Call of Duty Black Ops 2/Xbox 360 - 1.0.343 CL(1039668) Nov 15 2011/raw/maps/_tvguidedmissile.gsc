//TV Guided missile script
#include maps\_utility;
#include common_scripts\utility;

init()
{
	precacheShader("tow_overlay");
	precacheShader("tow_filter_overlay");
}

watchForGuidedMissileFire()
{
	self endon("disconnect");
	self endon("death");

	for(;;)
	{
		self waittill( "missile_fire", missile, weap );

		switch(weap)
		{
		case "m220_tow_emplaced_sp":
		case "m220_tow_emplaced_khesanh_sp":
		case "flashpoint_m220_tow_sp":
		case "m220_tow_sp":
		case "uwb_m220_tow_sp":
			self thread setupGuidedMissile(missile);
			break;
		default:
			break;
		}
	}
}

setupGuidedMissile( missile )
{
	self thread guidedMissileOverlay();
	missile thread MissileDamageWatcher( self );
	self thread MissileImpactWatcher();
}

MissileImpactWatcher( )
{
	self endon("disconnect");
	self endon("death");
	self endon("guided_missile_exploded");

	self waittill("projectile_impact");

	self notify("guided_missile_exploded");
}

MissileDamageWatcher( player )
{
	player endon("disconnect");
	player endon("death");
	player endon("guided_missile_exploded");

	self waittill("death");

	player notify("guided_missile_exploded");
}

guidedMissileOverlay()
{
	guided_missile_overlay = newClientHudElem( self );
	guided_missile_overlay.x = 0;
	guided_missile_overlay.y = 0;
	guided_missile_overlay.alignX = "center";
	guided_missile_overlay.alignY = "middle";
	guided_missile_overlay.horzAlign = "center";
	guided_missile_overlay.vertAlign = "middle";
	guided_missile_overlay.foreground = true;
	guided_missile_overlay setshader ("tow_overlay", 480, 480);
	
	guided_missile_grain = newClientHudElem( self );
	guided_missile_grain.x = 0;
	guided_missile_grain.y = 0;
	guided_missile_grain.alignX = "left";
	guided_missile_grain.alignY = "top";
	guided_missile_grain.horzAlign = "fullscreen";
	guided_missile_grain.vertAlign = "fullscreen";
	guided_missile_grain.foreground = true;
	guided_missile_grain setshader ("tow_filter_overlay", 640, 480);
	guided_missile_grain.alpha = 1.0;
//	thread ac130ShellShock();

	self thread destroy_overlay_on_missile_done(guided_missile_overlay ,guided_missile_grain );
	self thread destroy_overlay_on_death(guided_missile_overlay, guided_missile_grain );
}

destroy_overlay_on_death(guided_missile_overlay, guided_missile_grain )
{
	self endon("disconnect");
	self endon("guided_missile_exploded");
	
	self waittill("death");
	
	guided_missile_overlay Destroy();
	guided_missile_grain Destroy();
}

destroy_overlay_on_missile_done(guided_missile_overlay, guided_missile_grain )
{
	self endon("disconnect");
	self endon("death");
	
	self waittill("guided_missile_exploded");
		
	guided_missile_overlay Destroy();
	guided_missile_grain Destroy();
}