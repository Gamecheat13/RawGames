#include clientscripts\_utility; 
#include clientscripts\_music;
#include clientscripts\_audio;

//SELF = Player Horse
init()
{
    self thread play_horse_sounds();
    //self thread play_wind_sounds();
}

play_horse_sounds()
{
	self endon( "entityshutdown" );
	self endon( "death" );
	
	moto_ent = spawn( 0, (0,0,0), "script_origin" );
	idle_ent = spawn( 0, (0,0,0), "script_origin" );
	
	moto_ent LinkTo( self, "tag_wheel_front" );
	idle_ent LinkTo( self, "tag_wheel_front" );
	
	level thread delete_ents( moto_ent, idle_ent );

	while(1)
	{
	    
		wait( .05 );
	}
}

play_wind_sounds()
{
    self endon( "entityshutdown" );
	self endon( "death" );
    
    wind_ent = spawn( 0, (0,0,0), "script_origin" );
    self thread delete_ents( wind_ent );
    
//    wind_id = undefined;
//    volume = 0;
    
    /*
    while(1)
    {
        while( self.is_accelerating )
        {
            if( volume > 1 )
                volume = 1;
            if( volume < 0 )
                volume = 0;
                
            wind_id = wind_ent PlayLoopSound( "veh_moto_wind", .05 );
	        setsoundvolume( wind_id, volume );
	        wait(.05);
	        volume = volume + .025;
        }
        while( !self.is_accelerating )
        {
            if( !IsDefined( wind_id ) )
            {
                wait(.05);
                continue;
            }
                
            setsoundvolume( wind_id, volume );
            wait(.05);
            volume = volume - .025;
        }
    }
    */
}

delete_ents( ent1, ent2 )
{
    level waittill( "evM" );
    wait(2);
    ent1 stoploopsound(.5);
    
    if(IsDefined(ent2))
        ent2 stoploopsound(.5);
    
    wait(1);
    ent1 Delete();
    
    if(IsDefined(ent2))
        ent2 Delete();
}