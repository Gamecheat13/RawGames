/*=============================================================================
_pegasus.gsc
-------------------------------------------------------------------------------
READ: pegasus model, tags and fx tags should be in the same order as
 		 they'd be grouped on the plane. For instance: element 0 of model array 
 		 should use element 0's tag from the tag array, and use element 0 of
 		 the fx tag array.
READ: body model should always come first since it has to call SetModel
=============================================================================*/

#include common_scripts\utility;
#include maps\_utility;

// get all the models that would be attached to the death model
_get_pegasus_death_model_array()
{
	a_models = Array( 	"veh_t6_drone_pegasus_wing_l_dead",
	                	"veh_t6_drone_pegasus_wing_r_dead" );
	return a_models;	
}

_get_pegasus_death_model_2x_array()
{
	a_models = Array( 	"veh_t6_drone_pegasus_wing_l_dead_x2",
	                	"veh_t6_drone_pegasus_wing_r_dead_x2" );
	return a_models;		
}

// get all the tags where the death model parts would be attached 
_get_pegasus_death_model_tag_array()
{
	a_model_tags = Array(	"tag_dead_wing_l",
							"tag_dead_wing_r" );
	return a_model_tags;
}

// get all the tags where the fx would play on the death model pieces
_get_pegasus_death_model_fx_tag_array()
{
	a_fx_tags = Array( 		//"tag_fx_dead_body_rear",
	                  		"tag_fx_dead_wing_l",
							"tag_fx_dead_wing_r" );
	return a_fx_tags;
}

precache_extra_models( is_2x = false )
{
	if ( is_2x )
	{
		a_models = _get_pegasus_death_model_2x_array();	
		
		// Super lame
		self.is_2x = true;
	}
	else
	{
		a_models = _get_pegasus_death_model_array();
	}
	
	for ( i = 0; i < a_models.size; i++ )
	{
		str_model = a_models[ i ];
		PrecacheModel( str_model );
	}
	
	// Kinda lame
	self._vehicle_load_fx = ::precache_crash_fx;
}

precache_crash_fx( is_2x )
{
	if ( !IsDefined( self.fx_crash_effects ) )
	{
		self.fx_crash_effects = [];
	}
	
	if ( IsDefined( self.is_2x ) )
	{
		self.fx_crash_effects["fire_trail_lg"] = LoadFx( "trail/fx_la2_trail_plane_smoke_damage" );
		self.fx_crash_effects["fireball_trail_lg"] = LoadFX( "trail/fx_la2_trail_plane_smoke_fireball" );	    	
	}
	else
	{
		self.fx_crash_effects["fire_trail_lg"] = LoadFx( "trail/fx_trail_drone_piece_damage_smoke" );
		self.fx_crash_effects["fireball_trail_lg"] = LoadFX( "trail/fx_trail_plane_smoke_fireball" );
	}	
}

set_deathmodel( v_point, v_dir )
{
	if ( !IsDefined( self ) )
		return;
	
	// get all models, model tags and fx tags
	a_models = _get_pegasus_death_model_array();
	a_model_tags = _get_pegasus_death_model_tag_array();
	a_fx_tags = _get_pegasus_death_model_fx_tag_array();
	
	str_deathmodel = self.deathmodel;
	//iprintlnbold( str_deathmodel );

	// set body model on first run through
	if ( IsDefined( self.deathmodel ) )
	{
		str_deathmodel = self.deathmodel;
		self SetModel( str_deathmodel );
		
		//SOUND - Shawn J
		//iprintlnbold( "pegasus_death" );
		self playsound ("evt_pegasus_explo");
		self playsound ("evt_drone_explo_close");
		playsoundatposition( "evt_debris_flythrough", self.origin );
		
		//if ( !IsDefined( self.e_crash_effect_ent ) )
		//{
			//self.e_crash_effect_ent = Spawn( "script_model", self.origin );
			//self.e_crash_effect_ent SetModel( "tag_origing" );
			//self.e_crash_effect_ent LinkTo( self, "tag_fx_dead" );
			
			PlayFxOnTag( self.fx_crash_effects["fireball_trail_lg"], self, "tag_origin" );
		//}
	}	
	
	deathmodel_pieces = [];
	
	for ( i = 0; i < a_models.size; i++ )
	{
		// get current model, model tag, and fx tag
		str_model = a_models[ i ];
		str_model_tag = a_model_tags[ i ];
		str_fx_tag = a_fx_tags[ i ];
			
		// spawn model
		deathmodel_pieces[i] = spawn( "script_model", self GetTagOrigin( str_model_tag ) );
		deathmodel_pieces[i].angles = self GetTagAngles( str_model_tag );
		deathmodel_pieces[i] SetModel( str_model );
			
		// link model to body
		deathmodel_pieces[i] LinkTo( self, str_model_tag );
		deathmodel_pieces[i] thread delete_deathmodel_piece();
	}

	if ( IsDefined( deathmodel_pieces ) )
	{
		// sort the pieces by distance to the impact point
		deathmodel_pieces = get_array_of_closest( v_point, deathmodel_pieces );
		
		num_pieces = 1;
		if ( IsDefined( self.last_damage_mod ) )
		{
			if ( self.last_damage_mod == "MOD_PROJECTILE" )
			{
				num_pieces = 2; //RandomIntRange( 1, deathmodel_pieces.size );				
			}
		}
		
		for ( i = 0; i < num_pieces; i++ )
		{
			vel_dir = VectorNormalize( self.velocity );
			
			deathmodel_pieces[i] UnLink();		
			deathmodel_pieces[i] MoveGravity( vel_dir * RandomIntRange( 2500, 3500 ) + ( RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ) ), 5 );
			deathmodel_pieces[i] thread rotate_dead_piece();
			deathmodel_pieces[i].b_launched = true;
			PlayFxOnTag( self.fx_crash_effects["fire_trail_lg"], deathmodel_pieces[i], "tag_origin" );	
		}
	}
}

update_objective_model()
{
	self endon( "death" );
	
	self thread clear_objective_model_on_death();
	
	while ( true )
	{
		self waittill( "missileLockTurret_locked" );
		
		if ( !IsDefined( self ) || self.health <= 0 )
			return;
		
		level.f35_lockon_target = self;
		self SetClientFlag( 15 );
		
		self waittill( "missileLockTurret_cleared" );
		
		level.f35_lockon_target = undefined;		
	    self ClearClientFlag( 15 );	
	}
}

update_damage_states()
{
	self endon( "death" );
	
	is_damaged = false;
	
	while ( !is_damaged )
	{
		self waittill( "damage" );
		
		if( self.health <= self.maxhealth * 0.5 )
		{
			PlayFxOnTag( self.fx_crash_effects["fire_trail_lg"], self, "tag_origin" );		// TODO: Change to a proper damage effect
			is_damaged = true;
		}
	}
}

clear_objective_model_on_death()
{
	self waittill( "death" );
	
	if ( IsDefined( self ) )
	{
		self ClearClientFlag( 15 );  // remove glowy outline shader
		
		if ( IsDefined( level.f35_lockon_target ) && level.f35_lockon_target == self )
		{
			level.f35_lockon_target = undefined;	
		}
	}
}

rotate_dead_piece()
{
	self endon( "death" );
	
	torque = ( 0, RandomIntRange( -90, 90 ), RandomIntRange( 90, 720 ) );
	if ( RandomInt( 100 ) < 50 )
	{
		torque = ( torque[0], torque[1], -torque[2] );
	}

	ang_vel = ( 0, 0, 0 );	
	
	while ( IsDefined(self) )
	{
		ang_vel += torque * 0.05;
		
		const max_angluar_vel = 500;
		if ( ang_vel[2] < max_angluar_vel * -1 )
		{
			ang_vel = ( ang_vel[0], ang_vel[1],  max_angluar_vel * -1 );
		}
		else if ( ang_vel[2] > max_angluar_vel )
		{
			ang_vel = ( ang_vel[0], ang_vel[1],  max_angluar_vel );
		}

		self.angles += ang_vel * 0.05;
		
		wait( 0.05 );
	}	
}

delete_deathmodel_piece()
{
	wait( 5 );
	self Delete();
}