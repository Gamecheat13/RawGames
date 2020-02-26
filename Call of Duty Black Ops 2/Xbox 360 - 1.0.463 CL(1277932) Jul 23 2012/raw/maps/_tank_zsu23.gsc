// _tank_zsu23.gsc

#include maps\_vehicle;
#include maps\_utility;
#include common_scripts\utility;

main( model, type )
{
	init_audio_turret();
	self thread turret_sound_init();
}

init_audio_turret()
{
	
	//-- Make this the same as the gaz63
	//println("test print line zsu23");
	
}
turret_sound_init()
{
	//Tuey - For now, do not use the GDT weapon fields as the turret fire rates don't work with audio nicely.  Use loops instead ( 3/18/2010)

	self.sound_org = spawn ("script_origin", self.origin);
	self.sound_org linkto( self);
	self.sound_org.soundalias = "wpn_gaz_quad50_turret_loop_npc";
	
	/*
	switch(self.vehicletype)
	{
		case "truck_gaz63_quad50":
			self.sound_org.soundalias = "wpn_gaz_quad50_turret_loop_npc";
		break;
		
		case "truck_gaz63_single50":
			self.sound_org.soundalias = "wpn_gaz_single50_turret_loop_npc";
		break;
		
		default:
			//Defaults to the Quad50 turret sound for now
			self.sound_org.soundalias = "wpn_gaz_quad50_turret_loop_npc";
		break;
	}
	
	*/	
	
	//TUEY - TODO - Add switch for flux on each gun type later.
	self.sound_org.flux = "wpn_gaz_quad50_flux_npc_l";
	
	self waittill( "death" );
	
	self.sound_org delete();
	
}