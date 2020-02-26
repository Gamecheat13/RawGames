//
// file: frontend_amb.csc
// description: clientside ambient script for frontend: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_busing;
#include clientscripts\_audio;

main()
{
		declareAmbientRoom( "interrogation_room" );//pretty self explanitory
		setAmbientRoomContext( "interrogation_room", "ringoff_plr", "indoor" );
		setAmbientRoomReverb ("interrogation_room","frontend_room", 1, 1);
		setAmbientRoomTone( "interrogation_room", "amb_trippy", 1, 1 );
		
		activateAmbientRoom( 0, "interrogation_room", 0 );

		declareMusicState ("TITLE_SCREEN");
			musicAliasloop("mus_titlecard_loop", 0, 4);	

		declareMusicState("INT_UNDERSCORE"); 
			musicAliasloop("mus_frontend_loop", 4, 4);	
			
		declareMusicState("ZOMBIE_TIME"); 
			musicAliasloop("mus_zombietime", 4, 4);	
			
	    //CREDITS
	    declareMusicState("CREDIT_ZERO"); 
			musicAliasloop("mus_devil", 2, 2);    
	    
	    declareMusicState("CREDIT_ONE"); 
			musicAliasloop("mus_eminem_backdown", 2, 2);
			
		declareMusicState("CREDIT_TWO"); 
			musicAliasloop("mus_in_chopper_loop", 2, 2);	
			
		declareMusicState("CREDIT_THREE"); 
			musicAliasloop("mus_credits", 2, 2);	
		
		declareMusicState("CREDIT_FOUR"); 
			musicAliasloop("mus_panthers_boat_arrive", 2, 2);
			
		declareMusicState("CREDIT_FIVE"); 
			musicAliasloop("mus_redglare_post_rocket", 2, 2);
			
		declareMusicState("CREDIT_SIX"); 
			musicAliasloop("mus_zombietron_zt_demo", 2, 2);
			
		declareMusicState("CREDIT_SEVEN"); 
			musicAliasloop("mus_zombietron_abra_macabre", 2, 2);						
			
		if(GetDvar("mapname") == "frontend")
		{
			println("spawn card snapshot threads\n");
			level thread title_screen_snapshot();
			level thread int_room_snapshot();
			level thread credits_snapshot();
		}
}

title_screen_snapshot()
{
	
	for(;;)
	{
		level waittill ("ts");
		snd_set_snapshot( "spl_cmn_music" );
		wait(0.1);
	}	
	
}

int_room_snapshot()
{
	for(;;)
	{
		level waittill ("nts");
		snd_set_snapshot( "default" );	
		wait(0.1);	
	}	
}

credits_snapshot()
{
    while(1)
    {
        level waittill( "crs" );
        snd_set_snapshot( "spl_cmn_music" );
        wait(0.1);
    }
}