loadtreadfx( vehicle )
{
	treadfx = vehicle.treadfxnamearray;

	if( isdefined(treadfx) )
	{
		vehicle.treadfx = [];
		
		//load and cache fx handles
		fx_surface_names=array("asphalt","bark","brick","carpet","ceramic","cloth","concrete","cushion","none","dirt","flesh","foliage","fruit","glass","grass","gravel","ice","metal","mud","paintedmetal","plaster","rock","rubber","sand","snow","water","wood");
		for (i=0;i<fx_surface_names.size;i++)
		{
			if( isdefined(treadfx[fx_surface_names[i]]) && treadfx[fx_surface_names[i]] != "" )
			{
				if (!isdefined(level._effect[treadfx[fx_surface_names[i]]]))
					level._effect[treadfx[fx_surface_names[i]]]=loadfx( treadfx[fx_surface_names[i]] );
				vehicle.treadfx[fx_surface_names[i]] = level._effect[treadfx[fx_surface_names[i]]];
			}
		}
	}
	
	lightfx = vehicle.lightfxnamearray;
	
	if( lightfx.size > 0 )
	{
		self.light_fx = [];
	}
	
	for ( i = 0; i < lightfx.size; i++ )
	{
		if (!isdefined(level._effect[lightfx[i]]))
			level._effect[lightfx[i]]=loadfx(lightfx[i]);
		self.light_fx[self.light_fx.size] = level._effect[lightfx[i]];
	}
	
	if( IsDefined( self.friendlylightfxname ) && self.friendlylightfxname != "" )
	{
		if ( !isdefined( level._effect[self.friendlylightfxname] ) )
			level._effect[self.friendlylightfxname] = loadfx( self.friendlylightfxname );
		self.friendly_light_fx = level._effect[self.friendlylightfxname];
	}
	
	if( IsDefined( self.enemylightfxname ) && self.enemylightfxname != "" )
	{
		if ( !isdefined( level._effect[self.enemylightfxname] ) )
			level._effect[self.enemylightfxname] = loadfx( self.enemylightfxname );
		self.enemy_light_fx = level._effect[self.enemylightfxname];
	}
	
	if( vehicle.vehicletype == "boat_soct_player" )
	{
        vehicle.throttlefx = [];
        if (!isdefined(level._effect["water/fx_vwater_soct_wake_accelerate_1"]))
        	level._effect["water/fx_vwater_soct_wake_accelerate_1"]=loadfx("water/fx_vwater_soct_wake_accelerate_1");
        vehicle.throttlefx[0] = level._effect["water/fx_vwater_soct_wake_accelerate_1"];
        
        if (!isdefined(level._effect["water/fx_vwater_soct_wake_accelerate_2"]))
        	level._effect["water/fx_vwater_soct_wake_accelerate_2"]=loadfx("water/fx_vwater_soct_wake_accelerate_2");
        vehicle.throttlefx[1] = level._effect["water/fx_vwater_soct_wake_accelerate_2"];

		if (!isdefined(level._effect["water/fx_vwater_soct_wake_accelerate_3"]))
        	level._effect["water/fx_vwater_soct_wake_accelerate_3"]=loadfx("water/fx_vwater_soct_wake_accelerate_3");
        vehicle.throttlefx[2] = level._effect["water/fx_vwater_soct_wake_accelerate_3"];
        
        //vehicle.splashfx = loadfx( "vehicle/water/fx_wake_pbr_jump_splash" ); // Don’t use!
        //vehicle.splashfxright = loadfx( "vehicle/water/fx_wake_pbr_jump_splash" );
        //vehicle.splashfxleft = loadfx( "vehicle/water/fx_wake_pbr_jump_splash" );
        
        if (!isdefined(level._effect["water/fx_vwater_soct_churn_0"]))
        	level._effect["water/fx_vwater_soct_churn_0"]=loadfx("water/fx_vwater_soct_churn_0");
        vehicle.wakefx[0] = level._effect["water/fx_vwater_soct_churn_0"];    // reverse
        vehicle.wakefx[1] = level._effect["water/fx_vwater_soct_churn_0"];        // idle

        if (!isdefined(level._effect["water/fx_vwater_soct_churn_1"]))
        	level._effect["water/fx_vwater_soct_churn_1"]=loadfx("water/fx_vwater_soct_churn_1");
		vehicle.wakefx[2] = level._effect["water/fx_vwater_soct_churn_1"];        // forward slow
        if (!isdefined(level._effect["water/fx_vwater_soct_churn_2"]))
        	level._effect["water/fx_vwater_soct_churn_2"]=loadfx("water/fx_vwater_soct_churn_2");
        vehicle.wakefx[3] = level._effect["water/fx_vwater_soct_churn_2"];        // forward med
        if (!isdefined(level._effect["water/fx_vwater_soct_churn_3"]))
        	level._effect["water/fx_vwater_soct_churn_3"]=loadfx("water/fx_vwater_soct_churn_3");
        vehicle.wakefx[4] = level._effect["water/fx_vwater_soct_churn_3"];        // forward fast
	}
}