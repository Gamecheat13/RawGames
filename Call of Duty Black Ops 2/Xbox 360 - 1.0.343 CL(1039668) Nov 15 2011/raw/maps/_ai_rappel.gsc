#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\debug;
#include maps\_anim;

// --------------------------------------------------------------------------------
// ---- Module Rappel ----
// --------------------------------------------------------------------------------
#using_animtree( "generic_human" );
init_ai_rappel()
{
	level.scr_anim["generic"]["rappel_in"]	= %ai_rappel_in;
	level.scr_anim["generic"]["rappel"][0]  = %ai_rappel_loop_in_place;
	level.scr_anim["generic"]["rappel_out"] = %ai_rappel_out;    
	
	level.rappel_in_anim_length = GetAnimLength( level.scr_anim["generic"]["rappel_in"] );

	// calculate rappel_in animation vertical distance and save it
	move_delta 	 		 = GetMoveDelta( level.scr_anim["generic"]["rappel_in"] );
	move_delta 	 		 = ( 0, 0, move_delta[2] ); // only take vertical movement of the vector
	level.RAPPEL_IN_DIST = Length( move_delta );

	// calculate rappel_out animation vertical distance and save it
	move_delta 	  		  = GetMoveDelta( level.scr_anim["generic"]["rappel_out"] );
	move_delta 	  		  = ( 0, 0, move_delta[2] ); // only take vertical movement of the vector
	level.RAPPEL_OUT_DIST = Length( move_delta );

	level.MIN_RAPPEL_DIST = level.RAPPEL_IN_DIST + level.RAPPEL_OUT_DIST + 100;

	level.MIN_RAPPEL_TIME = 2.0; 

	level.rappel_initialized = true;
}

start_ai_rappel( time_to_rappel, rappel_point_struct, create_rope, delete_rope ) // self = AI
{
	self endon("death");
	
	// init rappel if it wasnt before
	if( !IsDefined( level.rappel_initialized ) )
		init_ai_rappel();		
	
	assert( IsAI( self ), "start_ai_rappel should only be called on AI." );

	// drop point is specified by the script then use that drop point
	if( IsDefined( rappel_point_struct ) )
	{		
		if( IsString( rappel_point_struct ) ) // as a string
			rappel_start = getstruct( rappel_point_struct, "targetname" );
		else
			rappel_start = rappel_point_struct;	// a struct passed in directly
	}
	else
	{
		// in this case, check if the AI is targetting the struct in radiant
		rappel_start = getstruct( self.target, "targetname" );
	}

	assert( IsDefined( rappel_start ), "No rappel_start struct for rappel is defined." );

	// set default angles if not specified
	if( !IsDefined( rappel_start.angles ) )
		rappel_start.angles = ( 0, 0, 0 );

	rappel_face_player = false;

	// get the end point for rappel
	if( IsDefined( rappel_start.target ) )
	{
		rappel_end = getstruct( rappel_start.target, "targetname" );
	}
	else
	{
		// rappel end is not defined, do a trace
		rappel_end_pos = PhysicsTrace( rappel_start.origin, rappel_start.origin - ( 0, 0, 10000 ) );
		rappel_end = SpawnStruct();
		
		rappel_end.origin = rappel_end_pos;

		// in this case we are going to use players position to face him as we rappel down
		rappel_face_player = true;
	}

	if( !IsDefined( rappel_end.angles ) )
	{
		rappel_end.angles = ( 0, 0, 0 );	
	
		// in this case we are going to use players position to face him as we rappel down
		rappel_face_player = true;	
	}
		
	// calculate in and out animation distances
	rappel_calulate_animation_points( rappel_start, rappel_end );

/#
	self thread debug_rappel( rappel_start.origin, rappel_end.origin );
#/

	// force teleport the AI to the rappel_start
	self forceteleport( rappel_start.origin, rappel_start.angles );

	// premature death while rappelling
	self thread rappel_handle_ai_death( rappel_start );

	// spawn a rope for rappeling down
	if( IsDefined( create_rope ) )
	{
		rappel_handle_rope_creation( rappel_start, rappel_end, create_rope );
	}

	// delete the rope if specified
	self thread rappel_handle_rope_deletion( rappel_start, delete_rope );
	
	self.allowDeath = true;

	// play in animation
	//self thread anim_single( self, "rappel_in", "generic" );

	// if time_to_rappel is not defined then calculate it based on the velocity around the end of the animation
	if( !IsDefined( time_to_rappel ) )
	{
		velocity = ( 0, 0, 200 ); // only vertical velocity
		dist = Distance( self.origin, self.out_point );

		time_to_rappel = dist / Length( velocity );

		if(time_to_rappel < level.MIN_RAPPEL_TIME  )
			time_to_rappel = level.MIN_RAPPEL_TIME;
	}
	
	//wait( level.rappel_in_anim_length );
	
	// spawn a script origin at the start point
	move_ent = Spawn( "script_model", self.origin );
	move_ent.angles = self.angles;

	self thread rappel_move_ent_think( move_ent );

/#
	self thread debug_in_position( rappel_end.origin );
#/
	// disable clientside linkto
	self DisableClientLinkTo();

	// link the AI to move entity, at this point AI should be at the start point
	self LinkTo( move_ent );

	// slide along the rope
	self thread rappel_move_ai_thread( move_ent, /*rappel_start, */rappel_end, time_to_rappel, rappel_face_player );

	// play rappel down animation
	self thread anim_generic_loop(self, "rappel");

	// wait untill exit notify
	self waittill("start_exit");

	// play out animation
	self StopAnimScripted();
	anim_single( self, "rappel_out", "generic" );

	// unlink the AI
	self UnLink();

	// delete move_ent as we dont need it anymore
	move_ent Delete();		

	// notify that the rappel is done
	self notify("rappel_done");
}

rappel_calulate_animation_points( rappel_start, rappel_end ) // self = AI
{
	// rappel start and end cant be away from each other vertically as in their x value should be the same	
	assert( rappel_start.origin[0] ==  rappel_end.origin[0], "rappel start and end cant be away from each other vertically, their origin[0] value should be the same." );

	// check if the distance for rappelling down is greater than minimum distance required		
	assert( Distance( rappel_start.origin, rappel_end.origin ) >= level.MIN_RAPPEL_DIST, "Minimum distance for rappel is " + level.MIN_RAPPEL_DIST );

	// AI will be moved to this point before playing rappel_out animation
	self.out_point = rappel_end.origin + ( 0, 0, level.RAPPEL_OUT_DIST );
}

//PARAMETER CLEANUP
rappel_move_ai_thread( move_ent, /*rappel_start, */rappel_end, time_to_rappel, rappel_face_player ) // self = AI
{
	self endon("death");

	// if true then spawn a thread that waits for half the time of rappel and tries to face the player
	if( rappel_face_player )
	{
		self thread rappel_face_player( move_ent, time_to_rappel );	
	}
	else
	{
		move_ent RotateTo( rappel_end.angles, RandomFloatRange(  1, time_to_rappel ) );
	}

	move_ent MoveTo( self.out_point, time_to_rappel, 1, 1 );

	move_ent waittill( "movedone" );

	self notify( "start_exit" );
}

rappel_face_player( move_ent, time_to_rappel ) // self = AI
{
	self endon("death");

	// waittill rappel is halfway done
	wait( time_to_rappel / 2 );

	// get the closest player and our yaw towards the player and try to rotate to the player
	player = get_closest_player( self.origin );

	angles = VectorToAngles( ( player.origin - self.origin ) );
	angles = ( 0, angles[1], 0 );

	move_ent RotateTo( angles, time_to_rappel / 2 );
}

rappel_move_ent_think( move_ent )
{
	self endon("rappel_done");

	// delete the move entity if this AI dies before rappelling is finished
	self waittill("death");
	
	move_ent Delete();	
}

// --------------------------------------------------------------------------------
// ---- Rappel rope handling ----
// --------------------------------------------------------------------------------

rappel_handle_rope_creation( rappel_start, rappel_end, create_rope ) // self = AI
{
	// create rope if needed
	if( IsDefined( create_rope ) && create_rope )
		rappel_start.rappel_rope = CreateRope( rappel_start.origin, rappel_end.origin, Distance( rappel_start.origin, rappel_end.origin ) * 0.8 );
}

rappel_handle_rope_deletion( rappel_start, delete_rope ) // self = AI
{
	self waittill_any( "death", "rappel_done" );

	// create rope if needed
	if( IsDefined( delete_rope ) && delete_rope && IsDefined( rappel_start.rappel_rope ) )
	{
		DeleteRope( rappel_start.rappel_rope );
		rappel_start.rappel_rope = undefined;
	}
}

rappel_struct_handle_rope_deletion()
{
	self endon("rappel_done");

	self waittill("delete_rope");

	// delete the rope on this struct if one exists
	if ( IsDefined( self.rappel_rope ) )
	{
		DeleteRope( self.rappel_rope );
		self.rappel_rope = undefined;	
	}
}

// --------------------------------------------------------------------------------
// ---- Handle AI death if for some reason rappel is disturbed ----
// --------------------------------------------------------------------------------
rappel_handle_ai_death( rappel_start )
{
	self endon("rappel_done");

	// if this AI has to stop rappel for some reason, just kill him
	self waittill( "stop_rappel" );
	
	self StartRagdoll();
	self DoDamage( self.health, self.origin );

	// delete the rope on this struct if one exists
	if ( IsDefined( rappel_start.rappel_rope ) )
	{
		DeleteRope( rappel_start.rappel_rope );
		rappel_start.rappel_rope = undefined;	
	}
}	

// --------------------------------------------------------------------------------
// ---- Debug Section ----
// --------------------------------------------------------------------------------
/#
debug_rappel( start, end )
{
	self endon("death");
	self endon("rappel_done");

	while(1)
	{
		if( GetDvarInt("ai_debugRappel") )
		{
			// draw point where out animation starts
			drawDebugCross( self.out_point, 1, ( 1, 1, 1 ), .6 );

			// draw start and end of the rappel
			recordLine( start, end, ( 1, 1, 1 ), "Script", self );
		}

		wait(0.05);
	}
}

debug_in_position( end )
{
	self endon("death");
	self endon("rappel_done");
	
	// save the current position
	pos = self.origin;

	while(1)
	{
		if( GetDvarInt("ai_debugRappel") )
		{
			// draw point where out animation starts
			drawDebugCross( pos, 1, ( 1, 1, 1 ), .6 );

			// draw loop start and end of the rappel
			recordLine( pos, end, ( 0, 1, 0 ), "Script", self );
		}

		wait(0.05);
	}
}

#/