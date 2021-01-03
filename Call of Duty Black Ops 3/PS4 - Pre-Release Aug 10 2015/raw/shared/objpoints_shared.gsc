#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#precache( "material", "objpoint_default" );

#namespace objpoints;

function autoexec __init__sytem__() {     system::register("objpoints",&__init__,undefined,undefined);    }
	
function __init__()
{
	level.objPointNames = [];
	level.objPoints = [];
	
	if ( ( isdefined( level.splitscreen ) && level.splitscreen ) )
	{
		level.objPointSize = 15;
	}
	else
	{
		level.objPointSize = 8;
	}
	
	level.objpoint_alpha_default = 1.0;
	level.objPointScale = 1.0;
}

function create( name, origin, team, shader, alpha, scale )
{
	assert( isdefined( level.teams[team] ) || team == "all" );
	
	objPoint = get_by_name( name );
	
	if ( isdefined( objPoint ) )
		objpoints::delete( objPoint );
	
	if ( !isdefined( shader ) )
		shader = "objpoint_default";

	if ( !isdefined( scale ) )
		scale = 1.0;
		
	if ( team != "all" )
		objPoint = newTeamHudElem( team );
	else
		objPoint = newHudElem();
	
	objPoint.name = name;
	objPoint.x = origin[0];
	objPoint.y = origin[1];
	objPoint.z = origin[2];
	objPoint.team = team;
	objPoint.isFlashing = false;
	objPoint.isShown = true;
	objPoint.fadeWhenTargeted = true;
	objPoint.archived = false;
	
	objPoint setShader( shader, level.objPointSize, level.objPointSize );
	objPoint setWaypoint( true );
	
	if ( isdefined( alpha ) )
		objPoint.alpha = alpha;
	else
		objPoint.alpha = level.objpoint_alpha_default;
	objPoint.baseAlpha = objPoint.alpha;
		
	objPoint.index = level.objPointNames.size;
	level.objPoints[name] = objPoint;
	level.objPointNames[level.objPointNames.size] = name;
	
	return objPoint;
}


function delete( oldObjPoint )
{
	assert( level.objPoints.size == level.objPointNames.size );
	
	if ( level.objPoints.size == 1 )
	{
		assert( level.objPointNames[0] == oldObjPoint.name );
		assert( isdefined( level.objPoints[oldObjPoint.name] ) );
		
		level.objPoints = [];
		level.objPointNames = [];
		oldObjPoint destroy();
		return;
	}
	
	newIndex = oldObjPoint.index;
	oldIndex = (level.objPointNames.size - 1);
	
	objPoint = get_by_index( oldIndex );
	level.objPointNames[newIndex] = objPoint.name;
	objPoint.index = newIndex;
	
	level.objPointNames[oldIndex] = undefined;
	level.objPoints[oldObjPoint.name] = undefined;
	
	oldObjPoint destroy();
}


function update_origin( origin )
{
	if ( self.x != origin[0] )
		self.x = origin[0];

	if ( self.y != origin[1] )
		self.y = origin[1];

	if ( self.z != origin[2] )
		self.z = origin[2];
}


function set_origin_by_name( name, origin )
{
	objPoint = get_by_name( name );
	objPoint update_origin( origin );
}


function get_by_name( name )
{
	if ( isdefined( level.objPoints[name] ) )
		return level.objPoints[name];
	else
		return undefined;
}

function get_by_index( index )
{
	if ( isdefined( level.objPointNames[index] ) )
		return level.objPoints[level.objPointNames[index]];
	else
		return undefined;
}

function start_flashing()
{
	self endon("stop_flashing_thread");
	
	if ( self.isFlashing )
		return;
	
	self.isFlashing = true;
	
	while ( self.isFlashing )
	{
		self fadeOverTime( 0.75 );
		self.alpha = 0.35 * self.baseAlpha;
		wait ( 0.75 );
		
		self fadeOverTime( 0.75 );
		self.alpha = self.baseAlpha;
		wait ( 0.75 );
	}
	
	self.alpha = self.baseAlpha;
}

function stop_flashing()
{
	if ( !self.isFlashing )
		return;

	self.isFlashing = false;
}
