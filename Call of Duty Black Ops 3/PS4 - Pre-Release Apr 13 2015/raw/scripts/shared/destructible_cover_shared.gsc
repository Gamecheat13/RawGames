#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace dev;



/#
function debug_sphere( origin, radius, color, alpha, time )
{
	if ( !isdefined(time) )
	{
		time = 1000;
	}
	if ( !isdefined(color) )
	{
		color = (1,1,1);
	}
	
	sides = Int(10 * ( 1 + Int(radius) % 100 ));
	sphere( origin, radius, color, alpha, true, sides, time );
}

function updateMinimapSetting()
{	
	// use 0 for no required map aspect ratio.
	requiredMapAspectRatio = GetDvarfloat( "scr_requiredMapAspectRatio");
	
	if (!isdefined(level.minimapheight)) {
		SetDvar("scr_minimap_height", "0");
		level.minimapheight = 0;
	}
	minimapheight = GetDvarfloat( "scr_minimap_height");
	if (minimapheight != level.minimapheight)
	{
		if ( minimapheight <= 0 )
		{
			util::getHostPlayer() CameraActivate( false );	
			level.minimapheight = minimapheight;
			level notify("end_draw_map_bounds");
		}
		
		if (minimapheight > 0)
		{
			level.minimapheight = minimapheight;
			
			players = GetPlayers();
			if (players.size > 0)
			{
				player = util::getHostPlayer();
				
				corners = getentarray("minimap_corner", "targetname");
				if (corners.size == 2)
				{
					viewpos = (corners[0].origin + corners[1].origin);
					viewpos = (viewpos[0]*.5, viewpos[1]*.5, viewpos[2]*.5);

					level thread minimapWarn( corners );

					maxcorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
					mincorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
					if (corners[1].origin[0] > corners[0].origin[0])
						maxcorner = (corners[1].origin[0], maxcorner[1], maxcorner[2]);
					else
						mincorner = (corners[1].origin[0], mincorner[1], mincorner[2]);
					if (corners[1].origin[1] > corners[0].origin[1])
						maxcorner = (maxcorner[0], corners[1].origin[1], maxcorner[2]);
					else
						mincorner = (mincorner[0], corners[1].origin[1], mincorner[2]);
					
					viewpostocorner = maxcorner - viewpos;
					viewpos = (viewpos[0], viewpos[1], viewpos[2] + minimapheight);
					
					northvector = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
					eastvector = (northvector[1], 0 - northvector[0], 0);
					disttotop = vectordot(northvector, viewpostocorner);
					if (disttotop < 0)
						disttotop = 0 - disttotop;
					disttoside = vectordot(eastvector, viewpostocorner);
					if (disttoside < 0)
						disttoside = 0 - disttoside;
					
					// extend map bounds to meet the required aspect ratio
					if ( requiredMapAspectRatio > 0 )
					{
						mapAspectRatio = disttoside / disttotop;
						if ( mapAspectRatio < requiredMapAspectRatio )
						{
							incr = requiredMapAspectRatio / mapAspectRatio;
							disttoside *= incr;
							addvec = vecscale( eastvector, vectordot( eastvector, maxcorner - viewpos ) * (incr - 1) );
							mincorner -= addvec;
							maxcorner += addvec;
						}
						else
						{
							incr = mapAspectRatio / requiredMapAspectRatio;
							disttotop *= incr;
							addvec = vecscale( northvector, vectordot( northvector, maxcorner - viewpos ) * (incr - 1) );
							mincorner -= addvec;
							maxcorner += addvec;
						}
					}
					
					if ( level.console )
					{
						aspectratioguess = 16.0/9.0;
						// .8 would be .75 but it needs to be bigger because of safe area
						angleside = 2 * atan(disttoside * .8 / minimapheight);
						angletop = 2 * atan(disttotop * aspectratioguess * .8 / minimapheight);
					}
					else
					{
						aspectratioguess = 4.0/3.0;
						angleside = 2 * atan(disttoside / minimapheight);
						angletop = 2 * atan(disttotop * aspectratioguess / minimapheight);
					}
					if (angleside > angletop)
						angle = angleside;
					else
						angle = angletop;
					
					znear = minimapheight - 1000;
					if (znear < 16) znear = 16;
					if (znear > 10000) znear = 10000;
					
					player CameraSetPosition( viewpos, ( 90, getnorthyaw(), 0 ) );
					player CameraActivate( true );	

					player TakeAllWeapons();

					SetDvar( "cg_drawGun", 0 );
					SetDvar( "cg_draw2D", 0 );
					SetDvar( "cg_drawFPS", 0 );
					SetDvar( "fx_enable", 0 );
					SetDvar( "r_fog", 0 );
					SetDvar( "r_highLodDist", 0 ); // (turns off lods)
					SetDvar( "r_znear", znear ); // (reduces z-fighting)
					SetDvar( "r_lodScaleRigid", 0.1 );
					SetDvar( "cg_drawVersion", 0 );
					SetDvar( "sm_enable", 1 );
					SetDvar( "player_view_pitch_down", 90 );
					SetDvar( "player_view_pitch_up", 0 );
					SetDvar( "cg_fov", angle );
					SetDvar( "cg_fovMin", 1 );
					SetDvar( "cg_drawMinimap", 1 );
					SetDvar( "r_umbranumthreads", 1 );
					SetDvar( "r_umbraDistanceScale", 0.1 );
					SetDvar( "r_useLensFov", 0 );

					SetDvar( "debug_show_viewpos", "0" );
					
					// hide 3D icons
					if ( isdefined( level.objPoints ) )
					{
						for ( i = 0; i < level.objPointNames.size; i++ )
						{
							if ( isdefined( level.objPoints[level.objPointNames[i]] ) )
								level.objPoints[level.objPointNames[i]] destroy();
						}
						level.objPoints = [];
						level.objPointNames = [];
					}
					
					thread drawMiniMapBounds(viewpos, mincorner, maxcorner);
				}
				else
					println("^1Error: There are not exactly 2 \"minimap_corner\" entities in the level.");
			}
			else
				SetDvar("scr_minimap_height", "0");
		}
	}
}

function vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}

function drawMiniMapBounds(viewpos, mincorner, maxcorner)
{
	level notify("end_draw_map_bounds");
	level endon("end_draw_map_bounds");
	
	viewheight = (viewpos[2] - maxcorner[2]);
	
	north = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
	
	diaglen = length(mincorner - maxcorner);

	/*diagonal = maxcorner - mincorner;
	side = vecscale(north, vectordot(diagonal, north));
	
	origcorner0 = mincorner;
	origcorner1 = mincorner + side;
	origcorner2 = maxcorner;
	origcorner3 = maxcorner - side;*/
	
	mincorneroffset = (mincorner - viewpos);
	mincorneroffset = vectornormalize((mincorneroffset[0], mincorneroffset[1], 0));
	mincorner = mincorner + vecscale(mincorneroffset, diaglen * 1/800);
	maxcorneroffset = (maxcorner - viewpos);
	maxcorneroffset = vectornormalize((maxcorneroffset[0], maxcorneroffset[1], 0));
	maxcorner = maxcorner + vecscale(maxcorneroffset, diaglen * 1/800);
	
	diagonal = maxcorner - mincorner;
	side = vecscale(north, vectordot(diagonal, north));
	sidenorth = vecscale(north, abs(vectordot(diagonal, north)));
	
	corner0 = mincorner;
	corner1 = mincorner + side;
	corner2 = maxcorner;
	corner3 = maxcorner - side;
	
	toppos = vecscale(mincorner + maxcorner, .5) + vecscale(sidenorth, .51);
	textscale = diaglen * .003;
	
	while(1)
	{
		line(corner0, corner1);
		line(corner1, corner2);
		line(corner2, corner3);
		line(corner3, corner0);

		/*line(origcorner0, origcorner1, (1,0,0));
		line(origcorner1, origcorner2, (1,0,0));
		line(origcorner2, origcorner3, (1,0,0));
		line(origcorner3, origcorner0, (1,0,0));*/
		
		print3d(toppos, "This Side Up", (1,1,1), 1, textscale);
		
		wait .05;
	}
}

function minimapWarn( corners )
{
	threshold = 10;
	
	width = Abs( corners[0].origin[0] - corners[1].origin[0] );
	width = Int( width );

	height = Abs( corners[0].origin[1] - corners[1].origin[1] );
	height = Int( height );

	if ( Abs( width - height ) > threshold )
	{
		for ( ;; )
		{
			iprintln( "^1Warning: Minimap corners do not form a square (width: " + width + " height: " + height + ")\n" );

			if ( height > width )
			{
				scale = height / width;
				iprintln( "^1Warning: The compass minimap might be scaled: " + scale + " units in height more than width\n" );
			}
			else
			{
				scale = width / height;
				iprintln( "^1Warning: The compass minimap might be scaled: " + scale + " units in width more than height\n" );
			}

			wait( 10 );
		}
	}
}

function body_customization_setup_helmet( helmet_index )
{
	foreach( player in GetPlayers() )
	{
		player SetCharacterHelmetStyle( helmet_index );
	}
}

function body_customization_setup_body( character_index, body_index )
{
	foreach( player in GetPlayers() )
	{
		player SetCharacterBodyType( character_index );
		player SetCharacterBodyStyle( body_index );
	}
}

function body_customization_process_command( character_index )
{
	split = StrTok( character_index, "+" );
	switch( split.size )
	{
		default:
			case 1: 
				command0 = StrTok( split[0], ":" );
				character_index = Int( command0[1] );
				body_index = 0;
				helmet_index = 0;
				body_customization_setup_helmet( helmet_index );
				body_customization_setup_body( character_index, body_index );
				break;
				
			case 2:
				command0 = StrTok( split[0], ":" );
				character_index = Int( command0[1] );
				command1 = StrTok( split[1], ":" );
				if( command1[0] == "bodystyle" )
				{
					body_index = Int( command1[1] );
					body_customization_setup_body( character_index, body_index );
				}
				else if( command1[0] == "helmet" )
				{
					helmet_index = Int( command1[1] );
					body_customization_setup_helmet( helmet_index );
				}
				break;				
	}		
}

function body_customization_populate( mode )
{
	bodies = GetAllHeroes( mode );
	body_customization_devgui_base = "devgui_cmd \"Player/Customization/Body/";
	foreach( playerbodytype in bodies )
	{
		body_name = MakeLocalizedString(GetCharacterDisplayName( playerbodytype, mode )) + " (" + GetCharacterAssetName( playerbodytype, mode ) + ")";
		
		//add default option
		AddDebugCommand( body_customization_devgui_base + body_name + "/Default" + "\" \"set "+"char_devgui"+" "+ "bodytype:" + playerbodytype +"\" \n");
		
		//populate all body models
		for( i = 0; i < GetHeroBodyModelCount( playerbodytype, mode ); i++ )
		{
			AddDebugCommand( body_customization_devgui_base + body_name + "/Body Styles/Body " + i +"\" \"set "+"char_devgui"+" "+ "bodytype:" + playerbodytype + "+" + "bodystyle:" + i +"\" \n");
		}
		
		//populate all head models
		for( i = 0; i < GetHeroHelmetModelCount( playerbodytype, mode ); i++ )
		{
			AddDebugCommand( body_customization_devgui_base + body_name + "/Helmets/Helmet " + i +"\" \"set "+"char_devgui"+" "+ "bodytype:" + playerbodytype + "+" + "helmet:" + i +"\" \n");
		}
	}
}

function body_customization_devgui( mode )
{
	body_customization_populate( mode );
	
	for ( ;; )
	{
		character_index = GetDvarString( "char_devgui" );

		if ( character_index != "" )
		{
			body_customization_process_command( character_index );
		}
	
		SetDvar( "char_devgui", "" );
		
		wait( 0.5 );
	}
}
#/
