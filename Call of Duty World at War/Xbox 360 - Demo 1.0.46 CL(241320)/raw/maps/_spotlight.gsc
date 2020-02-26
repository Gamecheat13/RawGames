// _spotlight.gsc


#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include common_scripts\utility;
main( model, type )
{
	precachemodel( "anim_lights_searchlight" );
	precachemodel( "anim_lights_searchlight_on" );
	
	level._effect["search_light_fx"] = LoadFX( "misc/fx_spotlight_large" );
		
	build_template( "spotlight", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "anim_lights_searchlight_on", "anim_lights_searchlight_des" );
	build_deathmodel( "anim_lights_searchlight", "anim_lights_searchlight_des" );
	build_deathfx( "env/electrical/fx_elec_searchlight_burst", "tag_flash", "explo_metal_rand" );  // TODO change to actual explosion fx/sound when we get it
	build_life( 1, 2, 3 );

	build_team( "axis" );			
}

// When the vehicle spawns, it calls this function, so put vehicle-specific post-spawn stuff here.
// self = the vehicle
init_local()
{
	self endon("death");
		
	self thread light_on();
	self thread light_off_on_death();
	self.health = 10;
}

light_on()
{
	self endon("death");
		
	self.spotlight_org 				= spawn("script_model", self gettagorigin("tag_flash"));
	self.spotlight_org setmodel ("tag_origin");
	self.spotlight_org.angles = self gettagangles("tag_flash");
	self.spotlight_org linkto (self, "tag_flash");
	
	playfxontag(level._effect["search_light_fx"], self.spotlight_org, "tag_origin");
	self setmodel("anim_lights_searchlight_on");
}

light_off()
{
	self endon("death");
	
	if (isalive(self) && isdefined(self))
	{
		self.spotlight_org delete();	
		self setmodel("anim_lights_searchlight");
	}
}

light_off_on_death()
{
	self waittill ("death");
	
	self.spotlight_org delete();
}