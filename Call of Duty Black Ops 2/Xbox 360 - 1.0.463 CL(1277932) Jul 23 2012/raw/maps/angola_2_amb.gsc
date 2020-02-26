//
// file: angola_2_amb.gsc
// description: level ambience script for angola_2
// scripter: 
//

#include common_scripts\utility;
#include maps\_utility;
#include maps\_music;

main()
{
 	level thread heli_alarm();
    SetSavedDvar( "vehicle_sounds_cutoff", 30000 );//setting this so you can hear the helicopter weapons

}

heli_alarm()
{
	while(1)
	{
		level waittill( "hel_alrm_on" );
	
		temp_ent = spawn( "script_origin", level.player.origin );
		temp_ent playloopsound( "veh_heli_alarm", 1 );
		
		level waittill( "hel_alrm_off" );
		
		temp_ent stoploopsound( .5 );
		
		wait(.75);
		temp_ent delete();
	}
}

sndBoatRamSnapshotOn( guy )
{
	level clientnotify( "boatram_on" );
}
sndBoatRamSnapshotOff( guy )
{
	level clientnotify( "boatram_off" );
}
sndFindWoodsSnapshot( guy )
{
	clientnotify( "woods_snp_on" );
	level waittill( "sndDeactivateSnapshot" );
	clientnotify( "woods_snp_off" );
}
sndFindWoodsRoom( guy )
{
	clientnotify( "woods_room_on" );
	level waittill( "sndDeactivateRoom" );
	clientnotify( "woods_room_off" );
}