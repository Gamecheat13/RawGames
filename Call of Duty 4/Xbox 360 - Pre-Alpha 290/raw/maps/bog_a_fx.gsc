#include maps\_utility;

main()

{
	level._effect["firelp_small_pm"]				= loadfx ("fire/firelp_small_pm");
	level._effect["firelp_small_pm_a"]				= loadfx ("fire/firelp_small_pm_a");
	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");	
	level._effect["firelp_barrel_pm"]				= loadfx ("fire/firelp_barrel_pm");
	level._effect["fog_bog_a"]						= loadfx ("weather/fog_bog_a");
	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");	
	level._effect["antiair_runner"]					= loadfx ("misc/antiair_runner_night");	
	level._effect["tunnel_smoke_bog_a"]				= loadfx ("smoke/tunnel_smoke_bog_a");
	level._effect["battlefield_smokebank_S"]		= loadfx ("smoke/battlefield_smokebank_bog_a");
	level._effect["hallway_smoke_dark"]				= loadfx ("smoke/hallway_smoke_dark");
	level._effect["heli_explosion"]					= loadfx ("explosions/helicopter_explosion_cobra_low");	
	level._effect["heli_aerial_explosion"]			= loadfx ("explosions/aerial_explosion");	
	level._effect["heli_aerial_explosion_large"]	= loadfx ("explosions/aerial_explosion_large");	
	level._effect["smoke_trail_heli"]				= loadfx ("fire/fire_smoke_trail_L");	
	//level._effect["fire_trail_heli"]				= loadfx ("fire/fire_smoke_trail_M");
	
	level._effect["wall_explosion_pm"]				= loadfx ("explosions/wall_explosion_pm");	
	level._effect["wall_explosion_pm_a"]			= loadfx ("explosions/wall_explosion_pm_a");
	level._effect["wall_explosion_pm_b"]			= loadfx ("explosions/wall_explosion_pm_b");	
	
	level._effect["exploder"]["1006"]				= loadfx( "explosions/wall_explosion_pm" );
	level._effect["exploder"]["1000"]				= loadfx( "explosions/wall_explosion_pm_a" );
	level._effect["exploder"]["1007"]				= loadfx( "explosions/wall_explosion_pm_b" );
	
	level._effect["exploder"]["1005"]				= loadfx( "explosions/wall_explosion_pm" );
	level._effect["exploder"]["1004"]				= loadfx( "explosions/wall_explosion_pm_a" );
	level._effect["exploder"]["1003"]				= loadfx( "explosions/wall_explosion_pm_b" );
	
	level._effect["exploder"]["1002"]				= loadfx( "explosions/wall_explosion_pm" );
	level._effect["exploder"]["1001"]				= loadfx( "explosions/wall_explosion_pm_a" );
	level._effect["exploder"]["1008"]				= loadfx( "explosions/wall_explosion_pm_b" );

	maps\_treadfx::setallvehiclefx( "cobra", undefined ); //disables cobras treads

	//Light flashes in sky
	level._effect["lightning"]						= loadfx ("weather/horizon_flash_runner");	
	level._effect["lightning_bolt_lrg"]				= loadfx ("weather/horizon_flash_runner");
	level._effect["lightning_bolt"]					= loadfx ("weather/horizon_flash_runner");
	
	thread horizon_flashes();

}

horizon_flashes()
{
	while(1)
	{
		time = randomfloatrange(1, 4); //this is the min - max range of time it will wait between exploders
		exp = randomint(3);//if you add more exploders...increase this number to reflect the amount of exploders
		wait time;
		
		//if you wanted to play a sound - this is where you would do it....or you could hook up a sound to the exploder
		exploder(10 + exp);	
	}	
}
