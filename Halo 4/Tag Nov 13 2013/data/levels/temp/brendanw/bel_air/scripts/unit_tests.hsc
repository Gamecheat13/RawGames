
// script unit testing.

// globals

global long g_long = -1;
global short g_short = -2;
global real g_real = -3.1;

static long s_long = -4;
static short s_short = -5;
static real s_real = -6.2;

script static void fv0()
	print("fv0");
end

script static void fv1(long p0)
	print("fv1");
	inspect(p0);
end

script static void fv2(long p0, short p1)
	print("fv2");
	inspect(p0);
	inspect(p1);
end

script static void fv3(long p0, short p1, real p2)
	print("fv3");
	inspect(p0);
	inspect(p1);
	inspect(p2);
end

script static long passthrough(long val)
	val;
end

script static real passthrough_r(real val)
	val;
end

script static boolean passthrough_b(boolean val)
	val;
end

script static long local_increment(long i)
	print("increment");
	local long l = i + 1;
	l;
end

script static real local_increment_r(real i)
	print("increment_r");
	local real l = i + 1.0;
	l;
end

script static long static_keep_count()
	static long callcount = 0;
	callcount = callcount + 1;
	callcount;
end

global boolean dormant0_awake = false;
script dormant dormant0()
	print("dormant0");
	dormant0_awake = true;
end

global boolean dormant1_awake = false;
script dormant dormant1()
	print("dormant1");
	dormant1_awake = true;
end


global boolean thread0_finished = false;
script static long thread0()
	print("thread0");
	thread0_finished = true;
	0;
end

global boolean thread1_finished = false;
script static long thread1(long p0)
	print("thread1");
	thread1_finished = true;
	1;
end

global boolean thread2_finished = false;
script static long thread2(long p0, short p1)
	print("thread2");
	thread2_finished = true;
	2;
end

global boolean thread3_finished = false;
script static long thread3(long p0, short p1, real p3)
	print("thread3");
	thread3_finished = true;
	3;
end

script static object_list getplayers0()
	print("GetPlayers0");
	local object_list p = players();
	p;
end

script static object_list passthroughplayers(object_list players)
	print("PassthroughPlayers");
	players;
end

script static void objectlisttest()
	print("Object list destructors");
	
	local object_list lol = players();
	lol = getplayers0();
	lol = passthroughplayers(lol);
	lol = passthroughplayers(passthroughplayers(passthroughplayers(lol)));
end

script static void objectscripttest()
	print("Object script tests");
	
	inspect(a->isinitialized());
	inspect(b->isinitialized());
	inspect(c->isinitialized());
	
	print("Static");
	local real temp = a->staticget();
	inspect(temp);
	
	b->staticset(22.7);
	inspect(b->staticget());
	inspect(a->staticget());
	inspect(c->staticget());
	
	b->staticset(10.5);
	temp = a->staticset(c->staticset(b->staticget()));
	inspect(temp);
	
	print("Instanced");
	temp = a->get();
	inspect(temp);
	temp = a->incvar();
	inspect(temp);
	
	b->set(22.7);
	temp = b->get();
	inspect(temp);
	
	temp = a->set(c->set(b->get()));
	inspect(temp);
	
	print("Passthrough");
	local long l0 = -1;
	local short l1 = -2;
	local real l2 = -3.5;
	inspect(l0);
	inspect(l1);
	inspect(l2);
	a->f3(passthrough(l0+2), passthrough(l1/2), passthrough(l2*-2.0));
	
	print("Thread");
	inspect(l0);
	inspect(l1);
	inspect(l2);
	thread(a->f3(passthrough(l0+2), passthrough(l1/2), passthrough(l2*-2.0)));
	sleep(10);
	
	thread(a->f3(passthrough(l0+2), passthrough(l1/2), passthrough(l2*-2.0)));
	// kill object to test cleanup
	object_destroy(a);
	
	object_create(a);
	sleep(5);
	inspect(a->isinitialized());
	
end

script static void globalscripttest()
	print("GlobalScriptTest");
	local long l0 = -1;
	local short l1 = -2;
	local real l2 = -3.5;
	inspect(l0);
	inspect(l1);
	inspect(l2);
	
	print("Simple");
	g_f3(l0, l1, l2);
	
	print("Passthrough");
	g_f3(passthrough(l0), passthrough(l1), passthrough_r(l2));
	g_f3(g_passthrough(l0), g_passthrough(l1), g_passthrough_r(l2));
	g_f3(passthrough(l0+2), g_passthrough(l1/2), g_passthrough_r(l2*-2.0));
	
	print("Thread");
	thread(g_thread3(passthrough(l0+2), g_passthrough(l1/2), g_passthrough_r(l2*-2.0)));
	sleep_until(g_thread3_finished, 1);
	g_thread3_finished = true;
	
end

script static boolean lessthan(long a, long b)
	print("LessThan");
	inspect(a);
	inspect(b);
	if (a < b) then
		a;
	else
		b;
	end
end

script static void conditionaltest()
	print("ConditionalTest");
	
	local long x = 0;
	local long y = 1;
	local boolean result = lessthan(x, y);
	inspect(result);

end

script static void nullobjectnametest()
	local object_name objname = none;
	inspect(objname);
	
	if (objname == none) then
		print("ObjName is corrently none");
	end
	
	objname = bsp0;
	if (objname != none) then
		print("ObjName correctly no longer none");
	end
end

script static void testmain()
	
	local long l_long = 1;
	local short l_short = 2;
	local real l_real = 3.5;
	
	local short casttest = 0;
	casttest = passthrough_b(true);
	
	print("Simple");
	fv0();
	fv1(l_long);
	fv2(l_long, l_short);
	fv3(l_long, l_short, l_real);
	
	print("Nested");
	fv1(passthrough(l_long));
	fv2(passthrough(l_long), passthrough(l_short));
	fv3(passthrough(l_long), passthrough(l_short), passthrough_r(l_real)); 
	
	print("Nested 2");
	fv1(passthrough(passthrough(l_long)));
	fv2(passthrough(passthrough(l_long)), passthrough(passthrough(l_short)));
	fv3(passthrough(passthrough(l_long)), passthrough(passthrough(l_short)), passthrough_r(passthrough_r(l_real))); 
	
	print("Globals");
	inspect(g_long);
	inspect(g_short);
	inspect(g_real);
	g_long = local_increment(g_long);
	g_short = local_increment(g_short);
	g_real = local_increment_r(g_real);
	inspect(g_long);
	inspect(g_short);
	inspect(g_real);
	
	print("Statics");
	inspect(g_long);
	inspect(g_short);
	inspect(g_real);
	s_long = local_increment(s_long);
	s_short = local_increment(s_short);
	s_real = local_increment_r(s_real);
	inspect(g_long);
	inspect(g_short);
	inspect(g_real);
	
	print("Function statics");
	local long temp = static_keep_count();
	inspect(temp);
	temp = static_keep_count();
	inspect(temp);
	temp = static_keep_count();
	inspect(temp);
	
	print("Wake & Dormants");
	temp = game_tick_get();
	wake(dormant0);
	sleep_until(dormant0_awake);
	inspect(dormant0_awake);
	inspect(game_tick_get() - temp); // ticks elapsed between wake and sleep_until reawakening main
	
	temp = game_tick_get();
	wake(dormant1);
	sleep_until(dormant1_awake, 1);
	inspect(dormant1_awake);
	inspect(game_tick_get() - temp); // ticks elapsed between wake and sleep_until reawakening main
	
	wake(dormant0);
	wake(dormant1);
	
	print("Threads");
	temp = game_tick_get();
	thread(thread0());
	thread(thread1(l_long));
	thread(thread2(l_long, l_short));
	thread(thread3(l_long, l_short, l_real));
	sleep_until(thread0_finished and thread1_finished and thread2_finished and thread3_finished, 1);
	inspect(game_tick_get() - temp);
	print("Threads with passthrough");
	thread0_finished = false;
	thread1_finished = false;
	thread2_finished = false;
	thread3_finished = false;
	temp = game_tick_get();
	thread(thread0());
	thread(thread1(passthrough(l_long)));
	thread(thread2(passthrough(l_long), passthrough(l_short)));
	thread(thread3(passthrough(l_long), passthrough(l_short), passthrough_r(l_real)));
	sleep_until(thread0_finished and thread1_finished and thread2_finished and thread3_finished, 1);
	inspect(game_tick_get() - temp);
	
	conditionaltest();
	objectlisttest();
	objectscripttest();
	globalscripttest();
	
	nullobjectnametest();
end

script startup main()
	testmain();
end

// one-off tests

script static void effecttest()
	effect_new("environments\solo\m30_cryptum\fx\electricity\pylon_beam.effect", cf_bsp0);
	effect_new("environments\solo\m30_cryptum\fx\electricity\pylon_burst.effect", cf_bsp1);
end