#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

#namespace stealth_debug;

/#

/* 
	STEALTH - Debugging
*/



/@
"Name: init()"
"Summary: Initialize stealth for an AI agent or Player or Level object"
"Module: Stealth"
"CallOn: AI or Player Entity or Level object"
"Example: level stealth_debug::init();"
"SPMP: singleplayer"
@/
function init( )
{
	if ( isDefined( self.stealth ) )
		self.stealth.debug_reason = "";	
	
	curDebug = GetDvarInt( "stealth_debug", -1 );
	if ( curDebug == -1 )
		SetDvar( "stealth_debug", 0 );
}

/@
"Name: enabled()"
"Summary: returns if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( stealth_debug::enabled() )"
"SPMP: singleplayer"
@/
function enabled( )
{
	return GetDvarInt( "stealth_debug", 0 );
}

/@
"Name: init_debug()"
"Summary: Initialize stealth debugging for an AI agent or Player or Level object"
"Module: Stealth"
"CallOn: AI or Player Entity or Level object"
"Example: aiGuy stealth_debug::init_debug();"
"SPMP: singleplayer"
@/
function init_debug( )
{
	if ( isActor( self ) )
	{
		self thread draw_awareness_thread();
		self thread draw_detect_cone_thread();
	}
}

/@
"Name: draw_awareness_thread( )"
"Summary: Thread to handle drawing of current awareness of ai agent"
"Module: Stealth"
"CallOn: Actor"
"Example: aiGuy thread stealth_debug::draw_awareness_thread();"
"SPMP: singleplayer"
@/
function draw_awareness_thread( )
{
	self notify( "draw_awareness_thread" );
	self endon( "draw_awareness_thread" );
	self endon( "death" );
	self endon( "stop_stealth" );
	
	while ( 1 )
	{
		if ( stealth_debug::enabled() )
		{
			origin = self.origin;
			
     		Print3d( origin, "" + self.awarenesslevelcurrent, stealth::awareness_color( self.awarenesslevelcurrent ), 1, 0.5, 1 );
     		origin = (origin[0], origin[1], origin[2] + 15 );
     		
     		if ( isDefined( self.stealth.debug_reason ) && self.stealth.debug_reason != "" && self.awarenesslevelcurrent != "unaware" )
     		{
     			Print3d( origin, self.stealth.debug_reason, stealth::awareness_color( self.awarenesslevelcurrent ), 1, 0.5, 1 );
	     		origin = (origin[0], origin[1], origin[2] + 15 );
     		}
     		
     		if ( isDefined( self.enemy ) )
     		{
     			Print3d( origin, "enemy < " + self.enemy GetEntityNumber() + " >", stealth::awareness_color( self.awarenesslevelcurrent ), 1, 0.5, 1 );
	     		origin = (origin[0], origin[1], origin[2] + 15 );
     		}

     		if ( isDefined( self.stealth.debug_msg ) && self.stealth.debug_msg != "" )
     		{
     			Print3d( origin, self.stealth.debug_msg, stealth::awareness_color( self.awarenesslevelcurrent ), 1, 0.5, 1 );
	     		origin = (origin[0], origin[1], origin[2] + 15 );
     		}

     		/*
  			foreach ( entity in self.stealth.debug_ignore )
     		{
     			Print3d( origin, "ignore < " + entity GetEntityNumber() + " >", stealth::awareness_color( self.awarenesslevelcurrent ), 1, 0.5, 1 );
	     		origin = (origin[0], origin[1], origin[2] + 15 );
     		}
     		*/
		}
			
		{wait(.05);};
	}
}

/@
"Name: draw_detect_cone_thread( )"
"Summary: Thread to handle drawing of field of view cone for an Actor"
"Module: Stealth"
"CallOn: Actor"
"Example: aiGuy thread stealth_debug::draw_detect_cone_thread();"
"SPMP: singleplayer"
@/
function draw_detect_cone_thread( )
{
    self notify( "draw_detect_cone_thread" );
    self endon( "draw_detect_cone_thread" );    
    self endon( "death" );
	self endon( "stop_stealth" );
	
	if ( !isActor( self ) )
		return;
    
    {wait(.05);};
        
    while( 1 )
    { 	
    	{wait(.05);};

    	if ( stealth_debug::enabled() )
    	{
	   		awareness = self stealth_aware::get_awareness();
	   		
	   		parm = level.stealth.parm.awareness[awareness];
	   		
	    	if ( stealth_debug::enabled() > 1 )
	    	{
	    		// Show sight cones
		    	v_eye_angles = (0, self GetTagAngles( "TAG_EYE" )[ 1 ], 0);
		    
				color = (0.50, 0.50, 0.50);
				foreach ( enemy in level.stealth.enemies[self.team] )
				{				
					if ( self CanSee( enemy ) )
					{
						color = (1.00, 0.50, 0.00);
						break;
					}
				}
		
				if ( awareness != "combat" )
					self draw_detect_cone( self.origin + ( 0, 0, 16 ), v_eye_angles, self.fovcosine, self.fovcosinez, sqrt( self.maxsightdistsqrd ), color );
		   	}
    	
    		// Show current points of interest when alerted
			pointOfInterest = self GetEventPointOfInterest();
			if ( isDefined( pointOfInterest ) )
			{
				color = stealth::awareness_color( awareness, true );
				Line( self.origin, pointOfInterest, color, 0, 1 );
				DebugStar( pointOfInterest, 1, color );
			}
    	}
	}
}

/@
"Name: draw_detect_cone( origin, angles, fovCosine, viewDist, color )"
"Summary: Draws a field of view cone"
"Module: Stealth"
"Example: stealth_debug::draw_detect_cone( self.origin + ( 0, 0, 16 ), angles, self.fovcosine, viewDist, color );"
"SPMP: singleplayer"
@/
function draw_detect_cone( origin, angles, fovCosine, fovCosineZ, viewDist, color )
{
	v_fov_yaw = ACos( fovcosine );
	v_fov_pitch = ACos( fovcosineZ );
	
	height = tan( v_fov_pitch ) * viewDist;
	fwd = AnglesToForward( ( 0, angles[1], 0 ) );
	
	v_leftdir	 = AnglesToForward( ( 0, angles[1] + v_fov_yaw, 0 ) );
	v_rightdir = AnglesToForward( ( 0, angles[1] - v_fov_yaw, 0 ) );
	
	v_left_end  = origin + v_leftdir * viewDist;
	v_right_end = origin + v_rightdir * viewDist;
	
	util::debug_line( origin, v_left_end, color, 1.0, 1, 1 );
	util::debug_line( origin, v_right_end, color, 1.0, 1, 1 );
	
	v_height0 = origin + fwd * viewDist;
	v_height1 = ( origin + fwd * viewDist ) + (0, 0, height);
	util::debug_line( v_height0, v_height1, color, 1.0, 1, 1 );
	util::debug_line( v_height1, origin, color, 1.0, 1, 1 );
	
	// FOV Arc
	a_arcpoints = [];
	v_angleFrac = ( v_fov_yaw * 2.0 ) / (10);
	
	for ( j = 1; j < (10) - 1; j++ )
	{
		n_angle	= angles[1] - v_fov_yaw + ( v_angleFrac * j );
		v_dir	= AnglesToForward( ( 0, n_angle, 0 ) );
		a_arcpoints[ a_arcpoints.size ] = ( v_dir * viewDist ) + origin;
	}
	
	a_arcpoints[ a_arcpoints.size ] = v_left_end;
	
	v_arc_seg_start = v_right_end;
	v_arc_seg_end	  = undefined;
	for ( j = 0;j < a_arcpoints.size;j++ )
	{
		v_arc_seg_end = a_arcpoints[ j ];
		util::debug_line( v_arc_seg_start, v_arc_seg_end, color, 1.0, 1, 1 );
		v_arc_seg_start = v_arc_seg_end;
	}	
}

/@
"Name: rising_text( text, color, alpha, scale, origin, life )"
"Summary: Draws debug text at a point in space and rises strait up "
"Module: Stealth"
"Example: self thread stealth_debug::rising_text( "saw something" );"
"SPMP: singleplayer"
@/
function rising_text( text, color, alpha, scale, origin, life )
{
	spacing = 10;
	riseRate = 3;
	
	if ( !isDefined( origin ) || !isDefined( text ) )
		return;

	start = GetTime();
	
	if ( !isDefined( self.stealth.debug_rising ) )
	{
		self.stealth.debug_rising = [];
		self.stealth.debug_rising_idx = -1;
	}

	self.stealth.debug_rising_idx++;
	myId = self.stealth.debug_rising_idx;
	self.stealth.debug_rising[myId] = origin;
	prevId = myId - 1;
	
	// bump other rising text elements on me by enough so that new item is clear to read
	while ( isDefined( self.stealth.debug_rising[prevId] ) )
    {
		delta = self.stealth.debug_rising[prevId][2] - self.stealth.debug_rising[prevId+1][2];
		
		if ( delta >= spacing )
			break;
		
		self.stealth.debug_rising[prevId] = (self.stealth.debug_rising[prevId][0], self.stealth.debug_rising[prevId][1], self.stealth.debug_rising[prevId+1][2] + spacing + delta );

		prevId = prevId - 1;
    }
				
	drawOrigin = self.stealth.debug_rising[myId];
		
	while ( (GetTime() - start) < (life * 1000) )
	{		
		{wait(.05);};
		if ( isDefined( self ) && isAlive( self ) && isDefined( self.stealth ) && isDefined( self.stealth.debug_rising ) && isDefined( self.stealth.debug_rising[myId] ) )
			drawOrigin = self.stealth.debug_rising[myId];
		Print3d( drawOrigin, text, color, alpha, scale, 1 );
		drawOrigin = (drawOrigin[0], drawOrigin[1], drawOrigin[2] + riseRate );
		if ( isDefined( self ) && isAlive( self ) && isDefined( self.stealth ) && isDefined( self.stealth.debug_rising ) && isDefined( self.stealth.debug_rising[myId] ) )
			self.stealth.debug_rising[myId] = ( self.stealth.debug_rising[myId][0], self.stealth.debug_rising[myId][1], self.stealth.debug_rising[myId][2] + riseRate );
	}
	
	if ( isDefined( self ) && isAlive( self ) && isDefined( self.stealth ) && isDefined( self.stealth.debug_rising ) && isDefined( self.stealth.debug_rising[myId] ) )
		self.stealth.debug_rising[myId] = undefined;
}

/@
"Name: debug_text( <varValue> )"
"Summary: converts a given variable to string value"
"SPMP: singleplayer"
@/
function debug_text( varValue )
{
	if ( !isDefined( varValue ) )
		return "<undefined>";
	
	if ( isWeapon( varValue ) )
	{
		return "weapon<" + varValue.name + ">";
	}

	if ( isEntity( varValue ) )
	{
		return "ent<" + varValue GetEntityNumber() + ">";
	}
	
	return "" + varValue;
}

#/
