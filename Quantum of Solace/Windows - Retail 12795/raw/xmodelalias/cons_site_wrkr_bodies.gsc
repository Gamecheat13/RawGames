// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	a[0] = "cons_worker_1_body";
	a[1] = "cons_worker_2_body";
	a[2] = "cons_worker_3_body";
	return a;
}


getnextmodel()
{
	if( !isdefined( level.nextXModel ) )
	{
		level.nextXModel = [];
	}

	if( !isdefined( level.nextXModel["cons_site_wrkr_bodies_Body"] ) )
	{
		startIndex = randomint(3);
		level.nextXModel["cons_site_wrkr_bodies_Body"] = startIndex;
	}
	index = level.nextXModel["cons_site_wrkr_bodies_Body"];
	level.nextXModel["cons_site_wrkr_bodies_Body"] = index+1;

	if( level.nextXModel["cons_site_wrkr_bodies_Body"] >= 3 )
		level.nextXModel["cons_site_wrkr_bodies_Body"] = 0;

	if( (index >= 3) || (index < 0))
		index = randomint(3);

	a = main();
	return a[ index ];
}