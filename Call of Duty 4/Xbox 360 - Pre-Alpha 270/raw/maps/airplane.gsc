#include maps\_utility;
#include maps\_anim;
#include maps\mo_tools;

main()
{
	maps\scriptgen\airplane_scriptgen::main();
	playerInit();
	
	flag_init("heroes_ready");
	flag_init("part1");
	flag_init("part2");
	flag_init("part3");
	flag_init("part4");
	flag_init("part5");
	
	flag_set("part1");
	flag_set("part2");
	flag_set("part3");
	flag_set("part4");
	flag_set("part5");
	
	setupanim();
	
	trigger = getent("hero_spawners","target");
	trigger notify("trigger");
	
	thread initial_setup();
	VisionSetNaked( "airplane", .25 );
	//setsaveddvar("sm_sunSampleSizeNear", ".1");
	thread lite();
	demo_walkthrough();
	
}

#using_animtree("generic_human");
setupanim()
{
	level.scr_anim[ "guy" ][ "onme" ]							= %CQB_stand_wave_on_me;
	level.scr_anim[ "guy" ][ "go" ]								= %CQB_stand_wave_go_v1;
	level.scr_anim[ "guy" ][ "stand2run" ]					= %stand_2_run_F_2;
}

initial_setup()
{
	wait .1;
	ai = getaiarray("allies");
	
	level.heroes = [];
	
	for(i=0; i<ai.size; i++)
	{
		switch( ai[i].script_noteworthy )
		{
			case "alavi":
				level.heroes[ "alavi" ]	= ai[i];
				break;
			case "price":
				level.heroes[ "price" ]	= ai[i];
				break;
			case "grigsby":
				level.heroes[ "grigsby" ] = ai[i];
				break;
		}
	}
	battlechatter_off();
	flag_set("heroes_ready");
}

playerInit()
{	
	level.player takeAllWeapons();
	level.player giveWeapon("Beretta");
	level.player giveWeapon("mp5_silencer");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");	
	level.player switchToWeapon("mp5_silencer");
}



lite()
{
	wait .1;
	
	rays = getentarray("godray","targetname");
	
	level.new_lite_offset = (0,0,0);
	string = getdvar("r_lightTweakSunDirection");
	token = strtok(string, " ");
	level.lite_settings = (int(token[0]), int(token[1]), int(token[2]));
	level.new_lite_settings = level.lite_settings;
	
	offset = (-40, -15, 0);
	liteoffset = vector_multiply(offset, .4);
	time = 10;
	interval = .05;
	numcycles = int(time * 20);
	totalcycles = numcycles;
	increment = vector_multiply(liteoffset, ( 1.0 / ( numcycles ) ) );
	
	increment = (increment[0] * -1, increment[1], increment[2]);
	
	array_thread( rays, ::godray, time, offset);
	
	while( numcycles )
	{
		numcycles--;				
		level.new_lite_settings = level.new_lite_settings + increment;
		setsaveddvar("r_lightTweakSunDirection", (level.new_lite_settings[0] + " " +  level.new_lite_settings[1] + " " +  level.new_lite_settings[2]));	
		wait interval;
	}	
}

godray(time, offset)
{
	self rotateto(offset, time);
}

demo_walkthrough()
{
	flag_wait("heroes_ready");
	
	keys = getarraykeys(level.heroes);
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		level.heroes[ key ] enable_cqbwalk();
		level.heroes[ key ].interval = 60;
		level.heroes[ key ].disableexits = true;
	}
	
	delays = [];
	delays[ "alavi" ]	= .85;
	delays[ "grigsby" ]	= 0;
	delays[ "price" ]	= .5;
	
	thread hallways_heroes("part1", "nothing", undefined, delays);
	
	wait 4.25; 
	level.heroes[ "price" ] handsignal("onme");
	//hallways_heroes("part2", "nothing", undefined, delays);
}

hallways_heroes(name, _flag, msgs, delays, exits)
{
	if( !isdefined(msgs) )
	{
		msgs = [];
		msgs["alavi"] 	= undefined;
		msgs["grigsby"] = undefined;
		msgs["price"] 	= undefined;
	}
	
	if( !isdefined(exits) )
	{
		exits = [];
		exits["alavi"] 	= undefined;
		exits["grigsby"] = undefined;
		exits["price"] 	= undefined;
	}
	
	if( !isdefined(delays) )
	{
		delays = [];
		delays["alavi"] 	= 0;
		delays["grigsby"] = 1;
		delays["price"] 	= 2;
	}
	
	keys = getarraykeys( level.heroes );
	
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		level.heroes[ key ] delaythread(delays[ key ], ::hallways_heroes_solo, name, _flag, msgs[ key ], exits[ key ] );
	}
			
	level endon(_flag);
	
	array_wait(level.heroes, "hallways_heroes_ready");
	flag_wait(name);
}

hallways_heroes_solo(name, _flag, msg, exit)
{
	self pushplayer(true);
	level endon(_flag);
	
	//self.animplaybackrate = 1;
	
	nodes = getnodearray(name,"targetname");
	node = undefined;
	
	for(i=0; i<nodes.size;i++)
	{
		if( nodes[i].script_noteworthy == self.script_noteworthy )
		{
			node = nodes[i];
			break;	
		}
	}	
	
	while( isdefined( node ) )
	{
		self setgoalnode( node );
		if( node.radius )
			self.goalradius = node.radius;
		else
			self.goalradius = 80;
		
		if( isdefined( exit ) )
		{
			reenableexits = true;
			if(isdefined(self.disableexits) && self.disableexits == true)
				reenableexits = false;
			self.disableexits = true;
			ref = undefined;
			
			if( exit == "stand2run180" )
				ref = self;
			else if( isdefined(self.node) && distance(self.node.origin, self.origin) < 4 )
				ref = self.node;
			else if(isdefined(self.goodnode) && distance(self.goodnode.origin, self.origin) < 4)
				ref = self.goodnode;
			else
				ref = self;
				
			pos = spawn("script_origin", ref.origin);
			pos.angles = ref.angles;
			
			self.hackexit = pos;
			
			if( exit == "stand2run180" )
				pos.angles += (0,32,0);
			
			if(ref != self)
			{
				if( issubstr(exit, "cornerleft" ) )
					pos.angles += (0,90,0);
				else if( issubstr(exit, "cornerright" ) )
					pos.angles -= (0,90,0);
			}
				
			self.animname = "guy";
			length = getanimlength( level.scr_anim[ self.animname ][ exit ] );
			pos thread anim_single_solo(self, exit);		
			wait length - .2;
			self stopanimscripted();
			pos delete();
			exit = undefined;
			if(reenableexits)
				self.disableexits = false;
		}
		
		self waittill("goal");
		if( isdefined( node.script_parameters ) )
		{
			attr = strtok( node.script_parameters, ":;, " );
			for(j=0;j<attr.size; j++)
			{
				switch( attr[j] )
				{
					case "disable_cqb":
						if(isdefined(node.target))
							self disable_cqbwalk_ign_demo_wrapper();
						else
							self delaythread(1.5, ::disable_cqbwalk_ign_demo_wrapper);
						break;
					case "enable_cqb":
						if(isdefined(node.target))
							self enable_cqbwalk_ign_demo_wrapper();
						else
							self delaythread(1.5, ::enable_cqbwalk_ign_demo_wrapper);
						break;
				}
			}
		}	
	
		if( isdefined( node.target ) )
			node = getnode( node.target, "targetname" );
		else
			node = undefined;
	}
	
	if( isdefined(msg) )
		radio_msg_stack( msg );
	
	self notify("hallways_heroes_ready");
}

decanim(rate)
{
	while(	self.animplaybackrate != rate )
	{
		self.animplaybackrate -= .05;
		wait .1;
	}	
}

handsignal(xanim, ender, waiter)
{
	if(isdefined(ender))
		level endon(ender);
	if(isdefined(waiter))
		level waittill(waiter);
	
	switch(xanim)
	{
		case "go":
			self setanim( %CQB_stand_wave_go_v1, 1, 0, 1.1 );
			break;	
		case "onme":
			level.heroes["grigsby"] thread decanim(.65);
			level.heroes["alavi"] thread decanim(.75);
			wait .3;
			self.animname = "guy";
			xanim = self getanim("onme");
			length = getanimlength( xanim );
			node = self.node;
			//self.node thread anim_single_solo(self, "onme");
			self setanimknoball( xanim, %body, 1, .2, 1.25 );
			wait length * (1/1.25) - .25;
			
			xanim = self getanim("stand2run");
			length = getanimlength( xanim );
			
			node thread anim_single_solo(self, "stand2run");
			wait length - .2;
			self stopanimscripted();
			self setgoalnode(getnode("pricenode2", "targetname"));
			level.heroes["grigsby"].animplaybackrate =1;
			level.heroes["alavi"].animplaybackrate = 1;
			//self stopanimscripted();
			break;
	}
	
	
}