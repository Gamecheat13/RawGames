main(model)
{
	level.vehicleInitThread["crusader_player"][model] = maps\_crusader::init_local;
	maps\_crusader::main(model);
}