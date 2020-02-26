/*=============================================================================
_f35.gsc
-------------------------------------------------------------------------------
READ: f35 model, tags and fx tags should be in the same order as
 		 they'd be grouped on the plane. For instance: element 0 of model array 
 		 should use element 0's tag from the tag array, and use element 0 of
 		 the fx tag array.
READ: body model should always come first since it has to call SetModel
=============================================================================*/

#include common_scripts\utility;
#include maps\_utility;

// get all the models that would be attached to the death model
_get_f35_death_model_array()
{
	a_models = Array( 	//	"veh_t6_drone_f35_dead",
	                 		"veh_t6_air_f35_dead_cockpit",
	                		"veh_t6_air_f35_dead_engine",
	                		"veh_t6_air_f35_dead_wing_l",
	                		"veh_t6_air_f35_dead_wing_r" );
	return a_models;	
}

// get all the tags where the death model parts would be attached 
_get_f35_death_model_tag_array()
{
	a_model_tags = Array( //	"tag_dead_body_rear",
	                     	"tag_dead_cockpit",
							"tag_dead_engine",
							"tag_dead_left_wing",
							"tag_dead_right_wing" );
	return a_model_tags;
}

// get all the tags where the fx would play on the death model pieces
_get_f35_death_model_fx_tag_array()
{
	a_fx_tags = Array( 		//"tag_fx_dead_body_rear",
	                  		"tag_fx_dead_cockpit",
							"tag_fx_dead_engine",
							"tag_fx_dead_left_wing",
							"tag_fx_dead_right_wing" );
	return a_fx_tags;
}

precache_extra_models()
{
	a_models = _get_f35_death_model_array();
	
	for ( i = 0; i < a_models.size; i++ )
	{
		str_model = a_models[ i ];
		PrecacheModel( str_model );
	}
}

set_deathmodel( v_point, v_dir )
{
	// get all models, model tags and fx tags
	a_models = _get_f35_death_model_array();
	a_model_tags = _get_f35_death_model_tag_array();
	a_fx_tags = _get_f35_death_model_fx_tag_array();
	
	str_deathmodel = self.deathmodel;
	//iprintlnbold( str_deathmodel );

	// set body model on first run through
	if ( IsDefined( self.deathmodel ) )
	{
		str_deathmodel = self.deathmodel;
		self SetModel( str_deathmodel );
		
		//SOUND - Shawn J
		//iprintlnbold( "f35_death" );
		self playsound ("evt_f35_explo");
	}	
	
	self.deathmodel_pieces = [];
	
	for ( i = 0; i < a_models.size; i++ )
	{
		// get current model, model tag, and fx tag
		str_model = a_models[ i ];
		str_model_tag = a_model_tags[ i ];
		str_fx_tag = a_fx_tags[ i ];
			
		// assert if model isn't in memory
		b_is_model_in_memory = IsAssetLoaded( "xmodel", str_model );
		Assert( b_is_model_in_memory, str_model + " xmodel is not loaded in memory. Include vehicle_f35 in your level CSV!" );
		
		// spawn model
		self.deathmodel_pieces[i] = spawn( "script_model", self GetTagOrigin( str_model_tag ) );
		self.deathmodel_pieces[i].angles = self GetTagAngles( str_model_tag );
		self.deathmodel_pieces[i] SetModel( str_model );
			
		// link model to body
		self.deathmodel_pieces[i] LinkTo( self, str_model_tag );
	}

	if ( IsDefined( self.deathmodel_pieces ) )
	{
		// sort the pieces by distance to the impact point
		self.deathmodel_pieces = get_array_of_closest( v_point, self.deathmodel_pieces );
		
		num_pieces = 1;
		if ( IsDefined( self.last_damage_mod ) )
		{
			if ( self.last_damage_mod == "MOD_PROJECTILE" || self.last_damage_mod == "MOD_EXPLOSIVE" )
			{
				num_pieces = RandomIntRange( 2, self.deathmodel_pieces.size );				
			}
		}
		
		for ( i = 0; i < num_pieces; i++ )
		{
			vel_dir = VectorNormalize( self.velocity );
			
			self.deathmodel_pieces[i] UnLink();
			self.deathmodel_pieces[i] PhysicsLaunch( v_point, vel_dir * 1000 );
			self.deathmodel_pieces[i].b_launched = true;
		}
	}
}




 