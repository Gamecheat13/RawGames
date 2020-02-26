#include common_scripts\utility;
#include maps\_utility;
#include maps\_ambientpackage;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
 	//thread play_sam_radio();
 	//moved to la_sam
}

play_sam_ambience()
{
	wait_for_first_player();	
	
	level.player endon( "death" );
	level.player endon( "missileTurret_off" );
	
	level.player waittill( "missileTurret_on" );
	
	clientnotify( "mTon" );
	
	temp_ent = spawn( "script_origin", level.player.origin );
	temp_ent playloopsound( "wpn_sam_interface_loop", 1 );
	
	level.player thread end_looping_sound( temp_ent );
	level.player thread play_sam_radio();	
	level.player thread play_sam_creaking_sounds();
}

end_looping_sound( ent )	
{
	level.player waittill( "missileTurret_off" );
	
	clientnotify( "mToff" );
	
	ent stoploopsound( 1 );
	wait(1);
	ent delete();
}

play_sam_radio()
{
	level.player endon( "death" );
	level.player endon( "missileTurret_off" );
	
	while(1)
	{
		// TODO Make it kill sound on exit - Shawn J
		level.player playsound ("amb_sam_radio_chatter");
		wait (RandomIntRange(5,10));
	}	
}

play_sam_creaking_sounds()
{
	level.player endon( "death" );
	level.player endon( "missileTurret_off" );
	
	wait_max = undefined;
	
	while(1)
	{
		if( !isdefined( level.num_planes_shot ) )
		{
			wait_max = 15;
		}
		else
		{
			wait_max = get_wait_max();
		}
		
		level.player playsound( "evt_cougar_creak" );
		wait(randomintrange(2,wait_max));
	}
}

get_wait_max()
{
	if( level.num_planes_shot < 2 )
	{
		return 12;
	}
	else if( level.num_planes_shot < 6 )
	{
		return 8;
	}
	else if( level.num_planes_shot < 9 )
	{
		return 6;
	}
	else
	{
		return 4;
	}
}

play_post_cougar_blend()
{
	wait(20);
	radioent = spawn ("script_origin", (0,0,0));
//	iprintlnbold("playing blend track");
	radioent playloopsound ("vox_blend_post_la");
//	iprintlnbold("waiting for notify");
	level waittill ("player_on_turret");
//	iprintlnbold ("got notify, stopping sound");
	radioent stoploopsound(0.5);
	radioent delete();
}
