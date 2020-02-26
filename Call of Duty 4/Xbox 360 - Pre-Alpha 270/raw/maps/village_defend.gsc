/****************************************************************************

Level: 		The Village (village_defend.bsp)
Location:	Northern Azerbaijan
Campaign: 	British SAS Woodland Scheme
Objectives:	1. Obtain orders from Captain Price. (filler objective for the dead time at the start of the level)
			2. Defend the lower hill approach. (note: level does not progress without player participation)
			3. Man the minigun and hold the flank. (required to progress, friendlies don't budge otherwise)
			4. Eliminate the enemy armor approaching from the north. (required to progress)
			5. Survive until the exfiltration force arrives. (Time Remaining: ~6 minutes, freeform gameplay)
			6. Destroy the enemy attack helicopter. (Appearing/Disappearing recurring objective X 4, optional but accumulates)
			7. Board the rescue helicopter before it leaves. (achievement for carrying a buddy back to the helo)

Planning Movie:
	Explosives diagramming

Start:
	
	1. The Intro and the Exploding Bell Tower
	
	Russian Loudspeaker: "Foreign soldiers, surrender at once and you will be spared. I am sure you will make the right choice given your situation."
	
	Russian Loudspeaker: "Drop your weapons and surrender at once. This is your last chance..."

	Price:	"Ignore that load of bollocks. Their counterattack is imminent. Spread out and cover the southern approach."
	Redshirt: 	(radio) "Bell tower here. Two enemy squads forming up to the south."
	Price:	"Any vehicles?"
	Redshirt:	(radio) "Negative. Wait - oh shit! Harris get ouuuuutt-"(BOOM) 
	
	Bell tower explodes.
	
	Pinky:	(radio) "Shit. Parker and Harris are dead. Sir, they're slowly coming up the hill. Just say when."
	
	Barbed wire barricade all around the top of the ridge so player can't go down to the river yet.
	
	2. The Southern Hill Ambush
	
	Price:	(radio) "Do it." (radio/live conditional on distance), arriving at the fence.
	Pinky:	"Ka-boom."
	
	Electronic beeping from explosive devices planted on the hill.
	
	Russians:	"what the hell?" "huh?" "What was that?"
	
	Line of explosives detonates!!! 
	
	Price:	"OOOPEN FIRRRRRRE!!!!"
	
	SAW opens fire across hill, tracer madness. Sniper fire madness.
	
	Lazyboy:	(radio) "Target down."
	Lazyboy:	(radio) "Got him."
	Lazyboy:	(radio)	"Target eliminated."
	Lazyboy:	(radio)	"Goodbye."
	
	Pinky:	(radio) "Sir, Ivan's bringin' in a recreational vehicle..."
	
	Price: (radio) "Take it out."
	
	Pinky:	(radio) "With pleasure sir. Firing Javelin!"
	
	Javelin leaps into sky and drops onto tank at base of hill by gas station.
	
	Lazyboy: 	"Nice shot mate."
	
	Pinky: "Blast, can't get a lock on the other one. Someone else'll have to do it."
	
	SAS3:	"Movement on the road."
	
	Price: "Squad, hold your ground, we'll make 'em think we're a larger force than we really are."
	
	Tracking player killcount and time elapsed, about two minutes and 40 kills. 
	Smoke only on right side of hill approach, enemy still trying to go left. Friendlies fight forever against these dudes.
	
	Pinky: 	"They're putting up smokescreens. Mac - you see anything?"
	
	Mac:	"Not much movement on the road. They might be moving to our west."
	
	3. Falling Back to The Minigun
	
	Price:	"Right. Soap, get to the minigun and cover the western flank. Go." (radio/live contingent on range)
	Price:	"Soap, get to the minigun! Move! It's attached to the crashed helicopter." (radio/live contingent on range)
	Price:	"Soap, I need you to operate the minigun! Get your arse moving!" (radio/live contingent on range)
	
	Game plays endlessly until player gets onto the minigun while enemies run up the hill on the left side.
	
	Player nears the minigun where he can't see over the helicopter at the graveyard.
	
	Price:	(radio)"Soap, they're already in the graveyard! Get on that bloody gun!"
	
	Player gets on the minigun. 
	
	Price and company start moving back.
	
	Price:	(radio) "Price moving."
	
	Price moves to the smoldering building.
	
	Pinky:	(radio) "Two, falling back."
	
	Pinky with the SAW moves to the open hut building and sets up and starts mowing drones there.
	
	Lazyboy:(radio)"Three, on the move."
	
	Lazyboy goes to where the player is and covers his back with his own M21 sniper rifle.
	
	Lazyboy:(radio)"Lazyboy here. Pinky's in the far eastern building. We've got the eastern road locked down."
	
	Price:	(radio)"Copy that. I'll cover the center from the smoldering building."
	
	Lazyboy:(radio)"Copy."
	
	Lazyboy:"Oi! Soap! Keep the minigun spooled up! Fire in short controlled bursts! 30 seconds max!"

	4. Minigun Action and Second Wave Defense

	Barbed wire explodes on hill so enemies can come in. 
	
	Price: (radio) "Here they come lads!"
	
	Tracking player killcount and time elapsed, about two minutes and 80 kills, otherwise no progression.
	Enemies running across at right angles to minigun axis, always trying to outflank visually.
	Player can jump off the minigun but it makes it harder.
	Drones to the east until player gets too close.
	
	Smokescreen forms across minigun field of fire.
	
	5. The Independence Day Deployment
	
	Pinky: 	(radio) "We've got a problem here...heads up!"
	
	Music, helicopter UFOs, Independence Day moment.
	
	Lazyboy:	(radio) "Bloody hell, that's a lot of helos innit?"
	
	Price: (radio) "Spread out. Don't stay in one spot too long and don't forget about the demo charges."
	
	Pinky:	(radio) "Yeah, use the detonators at the windows. There's at least one in each building tied to a particular killzone."
	Pinky:	(radio) "Oh and one more thing - don't forget about the Mark-19. It's on the wall beneath the water tower."
	
	6. The Blender
	
	Helicopter drops of enemies, plus some magic spawning of enemies in convenient locations.
	Enemy breach and clear of buildings.
	Enemy magic spawn and magic grenading of building hiding spots.
	Enemy chase down player and his buddies but need a special spread-out function for goalentitying to player to avoid man-trains.
	Smokescreens with hunter-killer parties moving at right angles and flanking the player.
	
	KA-50 Hokum attack helicopter comes in periodically to kill the player with guns and rockets.
	KA-50 Hokum attack helicopter shoots and blows up chunks of buildings where the player is likely to hide.
	
	Price: (radio) "Enemy attack helo! Get to cover!!!"
	Price: (radio) "Soap! Grab a Stinger missile and take it down!!!"
	
	Stinger missiles.
	
	ZSU AA missile batteries.
	
	Window based diagrammed killzone detonators.
	Mark-19 automatic grenade launcher.
	Minigun.
	RPGs.
	
	7. The Javelin Field
	
	Before the player can reach the barn...trigger activated or time based if not triggered, for thirty seconds in.
	
	Mac:	"We have enemy tanks approaching from the north! (sounds of fighting for a second) Fuck I'm hit! Aaaa!!!! (static)"
	
	Price: "Mac's in trouble! Soap! Get to the barn at the northern end of the village and stop those tanks!"
	
	Javelins against enemy tanks near the barn.
	
	Price is secretly deleted at this point so that he can be at the helicopter first at the end.
	
	~5 seconds after the Javelin objective, the radio comes on.
	
	8. The Countdown
	
	Friendlies stay between 800 and 1600 units of the player at all times.
	Friendlies have extra health and don't die easily. Also respawn new ones secretly.
	
	Helicopter Pilot: (radio) "Bravo Six, this is Gryphon Two-Seven. We're your ticket outta there.
	We've just crossed into Azerbaijani airspace. E.T.A. Six minutes. Be ready for pickup."
	
	Start the visible countdown.
	
	9. The Sea Knight Arrives
	
	The Sea Knight will choose the least convenient location relative to the player.
	
	Helicopter Pilot: (radio) "Bravo Six, we'll try to land in the fields at the northern end of the village. You gotta secure that LZ
	before we can touch down over."
	
	Helicopter Pilot: (radio) "Bravo Six, we'll try to land closer to the bottom of the hill to keep a low radar profile."
	
	Helicopter Pilot: (radio) "Bravo Six, we're gonna try and touch down at the eastern tip of the village."
	
	8. Get To The Choppah
	
	Helicopter Pilot: (radio) "And be advised we are low on fuel. You guys have three minutes before we have to leave without you."
	
	Music starts.
	
	New 'time to dustoff' countdown appears.
	
	Price:	(radio) "Copy Two-Seven! Everyone - head for the landing zone! It's our last chance! Move!"
	
	Helicopter Pilot: (radio) "Ninety seconds to dustoff."
	
	Helicopter Pilot: (radio) "This is Gryphon Two-Seven. We're at bingo fuel. We gotta leave in one minute."
	
	9. Leave No Man Behind?
	
	As the player gets close to the helicopter...about 1000 units away.
	
	The rest are fighting. 
	
	SAS2:	(radio) "Ah!!! I'm hit!!! Fuck!!!" 

	SAS3:	(radio) "We've got a man down! He's still alive! He's activated his transponder!"
	
	Compass objective location changes to the man's location.
	
	Price:	(radio) "Soap, go get him if you can! We'll defend the helicopter and buy you some time!"
	
	SAS2: 	(radio) "Forget about me! You won't make it back in time! Just go!"
	
	SAS2: 	"Grrrrraaaahhh!!!! Aaagh!"
	
	10. Departure
	
	The Sea Knight leaves and locks the player inside as soon as he gets far enough inside of it.
	
	Helicopter Pilot: (radio) "Ok we're outta here."
	
	It's very tightly timed. If the player rescued the fallen buddy and carried him back, the fallen buddy says,
	
	SAS2: "I owe you one mate. Thanks for comin' back for me." Achievement unlocked.
	
	Helicopter Pilot: (radio) "Baseplate this is Gryphon Two-Seven. We got 'em and we're comin' home. Out."

Moments:

	- Church tower blows up ("Parker get ouutt!!!!")
	- Ultranationalists use megaphones from helicopters to convince the player's team to surrender after 1st obj, and then...
	- Independence Day helicopter swarm dropping troops into the level all around, music
	- Enemy attack helicopter shooting buildings and breaking them where player is hiding
	- UAZ jeeps and BMPs driving in and unloading troops
	- Friendly troops emerge from back of Sea Knight and then run back on board before it leaves
	- Sea Knight lands in unpredictable location far from the player due to "it's too hot" and player has to run for it, music
	- Enemy troops heard squawking through radios before storming buildings the player is hiding inside of
	- Enemy troops flashbanging and storming buildings the player is hiding inside of
	- Man down and transponder on
	- Sea Knight leaves with rear door closing if player doesn't make it
	
	Survival Mode Extreme Edition - Surrender or Die!

	1. Features (memory is a problem)
	
		Helicopters:
		
		- unarmed enemy MI-17 transport helicopters with fastrope deployments
		- armed enemy KA-50 attack helicopters doing ground attack with rockets and machine guns against the player
			- blow holes in buildings that the player is hiding inside of, preceded by nearby enemy radio voice cues
		- shooting down KA-50 and MI-17 helicopters with RPGs and/or Stingers
		- KA-50 and MI-17 helicopters crashing outside of the level, out of sight
		- Sea Knight arrives and opens rear door to let people on board
		- Sea Knight has side door gunner(s) firing mounted guns
		
		Ground Vehicles:
		
		- BMP with soldiers unloading from them
		- BMP gets destroyed by minigun, RPG, AT/4
		- T-72 gets destroyed by Javelin
		- UAZ jeeps with soldiers unloading from them
		
		Minigun:
		
		- mounted minigun capable of shooting down helicopters and destroying ground vehicles 
			- winds up to full rotational speed with left trigger, then starts to fire bullets with right trigger
			- overheats after 30 seconds of sustained fire, so you have to control your firing, but can keep it spooled up
			- unlimited ammo
		
		Mk-19 Automatic Grenade Launcher Turret:
			- behaves like a fully automatic M203 in turret form
			- grenades fire with an arc like the M203
			- unlimited ammo
			
		Preplanned Explosive Killzones:
		
		- preplanned explosive detonator switches and marked killzones 
			- special textures showing hand drawn top down diagrams of the killzones next to each detonation station
			- players have to figure it out and learn the level by playing it
			- one detonator clacker per window+diagram combo
			- some scripted moments where AI out of player's sight report on the radio and the killzone explodes automatically
			
		Player Weapons Caches:
		
		- weapons caches (RPGs/Stingers, Machine Guns, Sniper Rifles, Submachine Guns, Novelty Weapons, Various Grenades) 
	
	2. Story integration
		- Al-Asad gets killed at the outset
		- Al-Asad must survive
	
	3. Player falling back early
		- make the battle indefinite until the player meets a participation metric like pegasusday
		- the timer doesn't start until later in the level when they receive a radio transmission from HQ
	
	4. Player not falling back at all or staying on the minigun forever
		- activate smokescreens for the enemy to run through
	
	5. Player hiding in a corner waiting for the timer to run out
		- solve this by having AI track down the player
			- manual player location volume detection for each building
				- use nearby custom spawners for known hiding locations
				- flashbang and clear rooms and kill player
				- magic grenade spam through windows where player is hiding
			- automatic player goalentitying for outdoor hiding spots
				- player execution routine for AI in both indoor and outdoor spots
				- use helicopters to flush out player in outdoor hiding places without top cover
		
Rules used in Pegasusday:
	1. The first battle would go on forever until the player satisfied a participation metric - X kills && X time elapsed.
		- didn't matter how far away he was, could snipe from far away if he wanted to
		- the player could run away but would encounter token resistance away from the main battle
			- token resistance spawned rarely to make it clear where the main battle was
	2. The fall back to the machine gun and cover the squad objective was required, or the war would go on indefinitely.
	3. The timer starts when the player is going to be attacked from all sides.
	4. Enemy threat escalates to introduce tanks which have several ways of killing the player caught in the open.
		- These are not required to win but are presented as optional objectives
		- They accumulate but do not display a count remaining on the objective text
		- The player has several options built into the level with which to destroy the tanks.
			- Fixed weapon
			- Normal anti-tank weapons
	5. There are almost no perfect hiding places where the player is safe with his back to a wall. Maybe the guard hut.
		
*****************************************************************************/

#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;

main()
{
	level.xenon = false;
    
	if (isdefined( getdvar("xenonGame") ) && getdvar("xenonGame") == "true" )
		level.xenon = true;
	
	//add_start( "zpu", ::start_zpu );
	//add_start( "cobras", ::start_cobras );
	//add_start( "end", ::start_end );
	add_start( "southern_hill", ::start_southern_hill );
	default_start( ::start_village_defend );
	
	createthreatbiasgroup( "player" );
	
	maps\_t72::main( "vehicle_t72_tank" );
	
	maps\village_defend_fx::main();
	maps\village_defend_anim::main();
	maps\_load::main();	
	level thread maps\village_defend_amb::main();	

	level.killzoneBigExplosion_fx = loadfx( "explosions/artilleryExp_dirt_brown" );
	level.killzoneMudExplosion_fx = loadfx( "explosions/grenadeExp_mud_1" );
	level.killzoneDirtExplosion_fx = loadfx( "explosions/grenadeExp_dirt_1" );
	level.killzoneFuelExplosion_fx = loadfx( "explosions/grenadeExp_fuel" );

	killzoneFxProgram();

	maps\createart\village_defend_art::main();	

	maps\_compass::setupMiniMap("compass_map_village_defend");
	
	level.price = getent( "price", "targetname" );
	level.price make_hero();
	level.price.animname = "price";
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	flag_init( "intro_tank_fire_authorization" );
	flag_init( "church_tower_explodes" );
	flag_init( "stop_ambush_music" );
	flag_init( "objective_price_orders_southern_hill" );
	flag_init( "objective_player_on_ridgeline" );
	flag_init( "objective_price_on_ridgeline" );
	flag_init( "objective_price_orders_minigun" );
	
	flag_init( "southern_hill_action_started" );
	flag_init( "southern_hill_killzone_detonate" );
	flag_init( "southern_mg_openfire" );
	
	level.encroachMinWait = 3;
	level.encroachMaxWait =	5;
	assertEX( level.encroachMinWait < level.encroachMaxWait, "encroachMinWait must be less than encroachMaxWait!" );
	
	level thread objectives();
	level thread southern_hill_ambush_mg();
	level thread friendly_setup();
	level thread music();
	
	level.player setthreatbiasgroup( "player" );
	
	setignoremegroup( "axis", "allies" );	// allies ignore axis
	setignoremegroup( "allies", "axis" ); 	// axis ignore allies
	setignoremegroup( "player", "axis" );	// axis ignore player
}

start_village_defend()
{
	thread intro();
	level.start_intro = true;
}

start_southern_hill()
{
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_player_on_ridgeline" );
	//flag_set( "objective_price_on_ridgeline" );
	
	playerStart = getnode( "player_southern_start", "targetname" );
	level.player setorigin (playerStart.origin);
	
	priceStart = getnode( "price_southern_start", "targetname" );
	level.price = getent( "price", "targetname" );
	level.price teleport (priceStart.origin);
	
	aRedshirtStarts = getnodearray( "redshirt_southern_start" , "script_noteworthy" );
	aRedshirts = getentarray( "redshirt", "targetname" );
	
	assertEX( aRedshirts.size == aRedshirtStarts.size , "You're supposed to have the same number of start points as friendlies here." );
	
	for( i = 0; i < aRedshirts.size; i++ )
	{
		aRedshirts[ i ] teleport (aRedshirtStarts[ i ].origin);
	}
	
	introHillTrigs = getentarray( "introHillTrig", "targetname" );
	for( i = 0 ; i < introHillTrigs.size; i++ )
	{
		introHillTrigs[ i ] notify ("trigger");
	}
	
	thread intro_tankdrive();
	thread southern_hill_defense();
}

intro()
{
	thread intro_loudspeaker();
	
	aAllies = getaiarray( "allies" );
	
	for( i = 0 ; i < aAllies.size; i++ )
	{
		aAllies[i].dontavoidplayer = true;
	}
	
	aAllies = remove_heroes_from_array( aAllies );
	
	for( i = 0 ; i < aAllies.size; i++ )
	{
		aAllies[i] allowedstances ("crouch");
		aAllies[i].disableArrivals = true;
	}
	
	introTrigs = getentarray( "introTrig", "targetname" );
	for( i = 0 ; i < introTrigs.size; i++ )
	{
		introTrigs[ i ] notify ("trigger");
	}
	
	for( i = 0 ; i < aAllies.size; i++ )
	{
		aAllies[i] allowedStances ("stand", "crouch", "prone");
	}
	
	price_intro_route = getnode( "price_intro_route", "targetname" );
	
	redshirt_routes = [];
	redshirt_routes[ 0 ] = getnode( "sas1_intro_route", "targetname" );
	redshirt_routes[ 1 ] = getnode( "sas2_intro_route", "targetname" );
	
	level.price thread followScriptedPath( price_intro_route, undefined, "prone" );
	
	aRedshirts = [];
	aRedshirts = getentarray( "redshirt", "targetname" );
	for( i = 0 ; i < aRedshirts.size ; i++ )
	{
		aRedshirts[ i ] thread followScriptedPath( redshirt_routes[ i ], 0.75, "prone" );
		wait 1;
	}
	
	thread intro_tankdrive();
	
	//TEMP DIALOGUE
	//"Ignore that load of bollocks. Their counterattack is imminent. Spread out and cover the southern approach."
	iprintln( "Their counterattack is imminent. Spread out and cover the southern approach." );
	level.price anim_single_queue( level.price, "spreadout" );
	
	flag_set( "objective_price_orders_southern_hill" );
	
	thread intro_ridgeline_check( level.player, "player_southern_start" );
	//thread intro_ridgeline_check( level.price, "price_southern_start" );
	
	//"Bell tower here. Two enemy squads forming up to the south."
	iprintln( "Bell tower here. Two enemy squads forming up to the south." );
	radio_dialogue( "belltowerhere" );
	
	//"Any vehicles?"
	iprintln( "Any vehicles?" );
	level.price anim_single_queue( level.price, "anyvehicles" );
	
	thread intro_church_tower_explode();
	
	//"Negative. Wait - oh shit! Harris get ouuuuutt- (BOOM)"
	iprintln( "Negative. Wait - oh shit! Harris get ouuuuutt- (BOOM)" );
	radio_dialogue( "negativewait" );

	thread southern_hill_defense();
	
	wait 1;
	
	//"Bloody hell. Parker and Harris are dead."
	iprintln( "Bloody hell. Parker and Harris are dead." );
	radio_dialogue( "parkerharrisdead" );
}

intro_church_tower_explode()
{
	//TEMP FX

	wait 3.25;
	flag_set( "intro_tank_fire_authorization" );
	wait 0.25;
	temp_tower_sequence = getent( "intro_tank_tower_target", "targetname" );
	//incoming tracer and explosion
	exploder( 1000 );
	wait 1.1;
	exploder( 1001 );
	temp_tower_sequence playsound( "exp_bell_tower" );	
	earthquake( 0.65, 1, temp_tower_sequence.origin, 3000 );
	
	flag_set( "church_tower_explodes" );
}

intro_ridgeline_check( guy, nodename )
{
	ridgelinePos = getnode( nodename, "targetname" );
	
	dist = length(level.player.origin - ridgelinePos.origin);
	
	//Wait for guy to reach his place on the ridgeline
	
	while(dist > 256)
	{
		dist = length(guy.origin - ridgelinePos.origin);
		wait 0.1;
	}
	
	if( guy == level.price )
		flag_set( "objective_price_on_ridgeline" );
		
	if( guy == level.player )
		flag_set( "objective_player_on_ridgeline" );
}

intro_loudspeaker()
{
	//Ultranationalist Russian commander demanding the surrender of the SAS troops
	
	aSpeakerTalk = [];
	
	//TEMP DIALOGUE
	//"Surrender at once and your lives will be spared. I am sure you will make the right choice given the circumstances."
	//aSpeakerTalk[ 0 ] = "villagedef_rul_surrenderatonce";
	
	//TEMP DIALOGUE
	//"Drop your weapons and surrender at once. You will not be harmed if you surrender."
	//aSpeakerTalk[ 1 ] = "villagedef_rul_dropyourweapons";
	
	//TEMP DIALOGUE
	//"We know you are hiding in the village. You are surrounded, there is nowhere to run. Surrender and make it easy on yourselves."
	//aSpeakerTalk[ 2 ] = "villagedef_rul_weknowyourehiding";
	
	aSpeakers = getentarray( "russian_loudspeaker", "targetname" );
	speakerCount = aSpeakers.size;
	j = 0;
	
	for( i = 0; i < aSpeakerTalk.size; i++ )
	{
		if( j >= speakerCount)
			j = 0;
			
		play_sound_in_space( aSpeakerTalk[ i ], aSpeakers[ j ].origin);
		wait randomfloatrange( 5 , 8);
		j++;
	}
}

southern_hill_defense()
{
	thread southern_hill_vanguard_setup();
	thread southern_hill_intro();
	thread southern_hill_javelin();
	thread southern_hill_killzone_sequence();
	thread southern_hill_ambush();
	thread southern_hill_primary_attack();
}

southern_hill_primary_attack()
{
	level endon ( "temp_demo_stopspawning" );	//TEMP LEVEL STOP FOR DEMOING PURPOSES ONLY
	
	startNode = getnode( "southern_hill_waypoint", "targetname" );
	unitName = "southern_hill_assaulter";
	endonMsg = "southern_hill_attack_stop";
	
	squad1 = "spawnRock";
	squad2 = "spawnRoad";
	squad3 = "spawnGas";
	
	level endon ( endonMsg );
	
	flag_wait( "southern_hill_killzone_detonate" );
	wait 1;

	while( 1 )
	{
		thread encroach_start( startNode, unitName, endonMsg, squad1);
		thread encroach_start( startNode, unitName, endonMsg, squad2);
		thread encroach_start( startNode, unitName, endonMsg, squad3);
		
		wait randomfloat( 6, 8 );
		
		thread encroach_start( startNode, unitName, endonMsg, squad2);
		thread encroach_start( startNode, unitName, endonMsg, squad2);
		thread encroach_start( startNode, unitName, endonMsg, squad3);
		
		wait randomfloat( 8, 10 );
		
		thread encroach_start( startNode, unitName, endonMsg, squad1);
		thread encroach_start( startNode, unitName, endonMsg, squad3);
		thread encroach_start( startNode, unitName, endonMsg, squad2);
		
		wait randomfloat( 10, 12 );
	}
}

southern_hill_vanguard_setup()
{
	flag_wait( "objective_player_on_ridgeline" );
	//flag_wait( "objective_price_on_ridgeline" );
	
	vanguards = [];
	vanguards = getentarray( "vanguard", "targetname" );
	
	for( i = 0; i < vanguards.size; i++ )
	{
		//vanguards[ i ] enable_cqbwalk();
		vanguards[ i ].animname = "axis";
		vanguards[ i ] set_run_anim( "patrolwalk_" + ( randomint(5) + 1 ) );
		vanguards[ i ] thread southern_hill_vanguard_nav();
	}
}

southern_hill_vanguard_nav()
{
	self endon ( "death" );
	
	node = undefined;
	
	if( !isdefined( self.script_noteworthy ) )
	{
		node = getnode( "default_vanguard_dest", "targetname" );	
	}
	else
	{
		nodes = getnodearray( "vanguard_node", "targetname" );	
		for( i = 0; i < nodes.size; i++ )
		{
			assertEX( isdefined( nodes[ i ].script_noteworthy ), "vanguard_node without a script_noteworthy" );
			if( self.script_noteworthy == nodes[ i ].script_noteworthy )
			{
				node = nodes[ i ];
				break;
			}
		}
	}
	
	self setgoalnode( node );
	//self thread southern_hill_vanguard_aim();
}

southern_hill_vanguard_aim()
{
	self endon ( "death" );
	
	aimpoints = [];
	aimpoints = getentarray( "vanguard_aimpoint", "targetname" );
	
	while( 1 )
	{
		i = randomint( aimpoints.size );
		self cqb_aim ( aimpoints[ i ] );
		wait randomfloat(1, 2);
	}
}

southern_hill_intro()
{
	flag_wait( "objective_player_on_ridgeline" );
	//flag_wait( "objective_price_on_ridgeline" );
		
	//"Sir, they're slowly coming up the hill. Just say when."
	iprintln( "Sir, they're slowly coming up the hill. Just say when." );
	radio_dialogue( "justsaywhen" );
	
	wait 3;
	
	if( !flag( "southern_hill_action_started" ) ) 
	{
		//"Do it."
		iprintln( "Do it." );
		radio_dialogue( "doit" );
	}
		
		//"Ka-boom."
		iprintln( "Ka-boom." );
		radio_dialogue( "kaboom" );
	
	if( !flag( "southern_hill_action_started" ) ) 
	{
		//TEMP DIALOGUE
		//RUSSIAN SURPRISE AND ACTIVATION BEEPS FROM EXPLOSIVES

		flag_set( "southern_hill_killzone_detonate" );
		
		wait 0.5;
		
		flag_set( "southern_hill_action_started" );
	}
	else
	{	
		flag_set( "southern_hill_killzone_detonate" );
	}
}

southern_hill_ambush()
{
	flag_wait( "southern_hill_action_started" );
	
	//"OPEN FIIRRRRRE!!!!!"
	iprintln( "OPEN FIIRRRRRE!!!!!" );
	level.price thread anim_single_queue( level.price, "openfire" );
	
	//wait 0.15;
	
	//battlechatter_on( "allies" );
	
	flag_set( "southern_mg_openfire" );
	
	//wait 0.3;
	
	setthreatbias( "axis", "allies", 1000 );	// allies fight axis
	setthreatbias( "allies", "axis", 1000 ); 	// axis fight allies
	setthreatbias( "player", "axis", 1000 );	// axis fight player
}

southern_hill_killzone_sequence()
{
	flag_wait( "southern_hill_killzone_detonate" );
	
	killzone1 = getent( "southern_hill_killzone_1", "targetname" );
	killzone2 = getent( "southern_hill_killzone_2", "targetname" );
	
	battlechatter_on( "axis" );

	thread killzone_detonation( killzone1 );
	wait 0.75;
	thread southern_hill_panic_screaming();
	wait 0.5;
	thread killzone_detonation( killzone2 );
	
	wait 15;
	
	level notify ( "temp_demo_stopspawning" );	//TEMP LEVEL STOP FOR DEMOING PURPOSES ONLY
	
	flag_set( "stop_ambush_music" );
	musicStop( 15 );
	
	wait 25;
	
	level notify ( "temp_demo_stopshooting" );	//TEMP LEVEL STOP FOR DEMOING PURPOSES ONLY
}

southern_hill_panic_screaming()
{
	level endon ( "temp_demo_stopshooting" );	//TEMP LEVEL STOP FOR DEMOING PURPOSES ONLY
	
	speakers = getentarray( "ambush_speaker", "targetname" );
	for( j = 0; j < 4; j++ )
	{
		for( i = 0; i < speakers.size; i++ )
		{
			speaker = speakers[ i ];
			play_sound_in_space( "RU_1_reaction_casualty_generic", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_move_generic", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_attack_infantry", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_action_coverme", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_inform_suppressed_generic", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_action_suppress", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_response_ack_covering", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_response_ack_follow", speaker.origin );	
			wait 1;	
		}
	}
}

southern_hill_ambush_mg()
{
	southern_sas_mg = getent( "southern_house_manual_mg", "targetname" );
	southern_sas_mg setmode( "manual" );
	southern_sas_mg thread southern_hill_mg_targeting();
	
	flag_wait( "southern_mg_openfire" );
	
	southern_sas_mg thread manual_mg_fire();
}

southern_hill_mg_targeting()
{
	level endon ( "temp_demo_stopshooting" );
	level endon ( "sawgunner_moving" ); 
	
	targets = getentarray( self.target, "targetname" );
	n = 0;
	
	while( 1 )
	{
		target = random( targets );
		
		self settargetentity( target );
		
		wait( randomfloatrange( 1, 5 ) );
		
		n++;
		
		//Occasionally pick off a bad guy
		
		if( n > 8 )
		{
			aAxis = [];
			aAxis = getaiarray( "axis" );
			target = random( aAxis );
			self settargetentity( target );
			wait( randomfloatrange( 1, 2 ) );
			
			n = 0;
			aAxis = undefined;
		}
	}
}

manual_mg_fire()
{	
	level endon ( "temp_demo_stopshooting" );
	level endon( "sawgunner_moving" );
	self.turret_fires = true;
	n = 0;
	for ( ;; )
	{
		timer = randomfloatrange( 0.4, 0.7 ) * 20;
		if ( self.turret_fires )
		{
			for ( i = 0; i < timer; i++ )
			{
				self shootturret();
				wait( 0.05 );
			}
		}
		
		n++;
		
		//time between bursts
		wait( randomfloat( 3.3, 6 ) );
		
		if(n >= 10)
		{
			//pretend reloading
			wait randomfloat( 6.1, 7.4 );
			n = 0;
		}
	}
}

southern_hill_javelin()
{
	flag_wait( "southern_hill_action_started" );
	
	//"Sir, Ivan's bringin' in a recreational vehicle…" REWRITE TEMP
	iprintln( "Got a lock on the T-72." );
	//radio_dialogue( "recreationalvehicle" );
	
	//"Take it out."
	iprintln( "Take it out." );
	radio_dialogue( "takeitout" );
	
	//"With pleasure sir. Firing Javelin."
	iprintln( "With pleasure sir. Firing Javelin." );
	radio_dialogue( "firingjavelin" );
	
	tank = getent( "intro_tank", "targetname" );
	//fakeJavelin = getent( "fake_javelin_launch", "targetname" );
	//magicbullet( "javelin", fakeJavelin.origin, tank.origin );
	//wait 4;
	radiusDamage( tank.origin, 512, 100500, 100500 );
}

intro_tankdrive()
{
	tank = spawn_vehicle_from_targetname_and_drive( "intro_tank" );
	node = getVehicleNode( "intro_tank_church_aim", "targetname" );
	targetpoint = getent( "intro_tank_tower_target", "targetname" );

	tank setwaitnode(node);
	tank waittill ("reached_wait_node");
	tank setTurretTargetEnt( targetpoint );
	tank waittill_notify_or_timeout( "turret_rotate_stopped", 5.0 );
	
	flag_wait( "intro_tank_fire_authorization" );
	tank fireweapon();
}

objectives()
{
	objective_add( 1, "active", "Obtain new orders from Captain Price.", ( level.price.origin ) );
	objective_current( 1 );
	
	flag_wait( "objective_price_orders_southern_hill" );
	
	objective_state( 1 , "done" );
	
	playerDefensePos = getnode( "player_southern_start", "targetname" );
	
	objective_add( 2, "active", "Take up a defensive position along the ridgeline.", ( playerDefensePos.origin ) );
	objective_current( 2 );
	
	flag_wait( "objective_player_on_ridgeline" );
	
	objective_state( 2 , "done" );
	
	objective_add( 3, "active", "Defend the southern hill approach.", ( level.price.origin ) );
	objective_current( 3 );
	
	autosave_by_name( "ready_for_ambush" );
	
	flag_wait( "objective_price_orders_minigun" );
	
	/*
	1. Obtain new orders from Captain Price.
	2. Take up a defensive position along the ridgeline. (note: level does not progress until player reaches his spot)
	3. Defend the southern hill approach. (note: level does not progress without player participation)
	4. Man the minigun and hold the flank. (required to progress, friendlies don't budge otherwise)
	5. Eliminate the enemy armor approaching from the north. (required to progress)
	6. Survive until the exfiltration force arrives. (Time Remaining: ~6 minutes, freeform gameplay)
	7. Destroy the enemy attack helicopter. (Appearing/Disappearing recurring objective X 4, optional but accumulates)
	8. Board the rescue helicopter before it leaves. (achievement for carrying a buddy back to the helo)
	*/
}

music()
{
	flag_wait( "church_tower_explodes" );
	while( !flag( "stop_ambush_music" ) )
	{
		musicPlay( "village_defend_ambush_music" );
		wait 20;
	}
}

//Datatables and Utilities

killzone_detonation( ent )
{
	squibs = [];
	
	while( 1 )
	{
		squibs[ squibs.size ] = ent;
		
		if( isdefined( ent.target ) )
		{
			ent = getent( ent.target, "targetname" );
		}
		else
		{
			break;
		}
	}
	
	n = 0;
	
	for( i = 0 ; i < squibs.size; i++ )
	{
		squib = squibs[ i ];
		vfx = level.killZoneFxProgram[ n ];
		soundfx = level.killZoneSfx[ n ];
		
		playfx( vfx, squib.origin );
		squib playsound( soundfx );	
		earthquake( 0.1, 0.5, level.player.origin, 1250 );
		radiusDamage(squib.origin, 128, 100500, 100500);	//radiusDamage(origin, range, maxdamage, mindamage);
		
		n++;
		if( n >= level.killZoneFxProgram.size )
		{
			n = 0;
		}	
		
		wait randomfloatrange( 0.05 , 0.15 );
	}
}

killzoneFxProgram()
{
	level.killZoneFxProgram = [];
	
	level.killZoneFxProgram[ 0 ] = level.killzoneBigExplosion_fx;
	level.killZoneFxProgram[ 1 ] = level.killzoneMudExplosion_fx;
	level.killZoneFxProgram[ 2 ] = level.killzoneBigExplosion_fx;
	level.killZoneFxProgram[ 3 ] = level.killzoneFuelExplosion_fx;
	level.killZoneFxProgram[ 4 ] = level.killzoneDirtExplosion_fx;
	level.killZoneFxProgram[ 5 ] = level.killzoneMudExplosion_fx;
	level.killZoneFxProgram[ 6 ] = level.killzoneBigExplosion_fx;
	level.killZoneFxProgram[ 7 ] = level.killzoneFuelExplosion_fx;
	level.killZoneFxProgram[ 8 ] = level.killzoneDirtExplosion_fx;
	level.killZoneFxProgram[ 9 ] = level.killzoneBigExplosion_fx;
	
	level.killZoneSfx = [];
	
	level.killZoneSfx[ 0 ] = "explo_mine";
	level.killZoneSfx[ 1 ] = "explo_tree";
	level.killZoneSfx[ 2 ] = "explo_mine";
	level.killZoneSfx[ 3 ] = "explo_rock";
	level.killZoneSfx[ 4 ] = "explo_roadblock";
	level.killZoneSfx[ 5 ] = "explo_tree";
	level.killZoneSfx[ 6 ] = "explo_mine";
	level.killZoneSfx[ 7 ] = "explo_rock";
	level.killZoneSfx[ 8 ] = "explo_roadblock";
	level.killZoneSfx[ 9 ] = "explo_mine";
	
	assertEX( level.killZoneFxProgram.size == level.killZoneSfx.size, "Fx and Sfx programs should have equal number of entries." );
}

followScriptedPath( node, delayTime, stance )
{
	if( !isdefined( delayTime ) )
		delayTime = 0;
		
	wait delayTime;
	
	nodes = [];
	
	while( 1 )
	{
		nodes[ nodes.size ] = node;
		
		if( isdefined( node.target ) )
		{
			node = getnode( node.target, "targetname" );
		}
		else
		{
			break;
		}
	}
	
	self.disableArrivals = true;
	
	for( i = 0; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		self setgoalnode( node );
		
		if( isdefined( node.script_stance ) )
			self allowedstances( node.script_stance );
		
		self waittill( "goal" );
		if( !isdefined( node.target ) )
			self notify ("reached_last_node_in_chain");
		if( !isdefined( node.script_noteworthy ) )
			continue;
		if( node.script_noteworthy == "tower_reaction" )
			iprintln( "Team reacts to bell tower explosion!" );
			//TEMP ANIM OF REACTION TO BELL TOWER EXPLOSION
	}	
	
	self.disableArrivals = false;
}

friendly_setup()
{
	aAllies = getaiarray( "allies" );	
	for( i = 0; i < aAllies.size; i++ )
	{
		aAllies[ i ] thread hero();
	}
}

hero()
{
	self thread magic_bullet_shield();
	self.IgnoreRandomBulletDamage = true;
}

//self set_run_anim( "path_slow" );
//self clear_run_anim();

encroach_start( node, groupname, msg, squadname )
{
	//node - ent - starting main node for enemy infantry attack run
	//groupname - str - targetname of enemy spawners;
	//msg - str - endon
	//squadname - str - script_noteworthy of enemy spawners' starting area on spawner; 
	
	level endon ( msg );
	
	aGroup = [];
	aSquad = [];
	guy = undefined;
	
	aGroup = getentarray( groupname, "targetname" );
	for( i = 0; i < aGroup.size; i++ )
	{
		if( isdefined( aGroup[ i ].script_noteworthy ) )
		{
			if( aGroup[ i ].script_noteworthy == squadname )
			{
				aSquad[ aSquad.size ] = aGroup[ i ];
			}
		}
	}
	
	for( i = 0; i < aSquad.size; i++ )
	{
		aSquad[ i ].count = 1;
		guy = aSquad[ i ] stalingradSpawn();
		if( spawn_failed( guy ) )
		{
			return;
		}
		
		guy thread encroach_nav( node, msg );
	}
}

encroach_nav( node, msg )
{
	level endon ( msg );
	self endon ( "death" );
	
	aRoutes = [];
	startNode = node;
	n = undefined;
	while( 1 )
	{
		aRoutes[ aRoutes.size ] = startNode;
		if( isdefined( startNode.target ) )
		{
			aBranchNodes = getnodearray( startNode.target, "targetname" );
			assertEX( aBranchNodes.size > 0, "At least one node should be targeted for encroach_nav routes" );
			
			n = randomint( aBranchNodes.size );
			startNode = aBranchNodes[ n ];
		}
		else
		{
			break;
		}
	}
	
	for( i = 0; i < aRoutes.size; i++ )
	{
		self setgoalnode( aRoutes[ i ] );
		self waittill ( "goal" );
		wait randomfloatrange( level.encroachMinWait, level.encroachMaxWait );
	}
}