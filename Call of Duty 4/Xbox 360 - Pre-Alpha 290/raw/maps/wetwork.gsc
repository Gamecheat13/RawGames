#include maps\_utility;

main()
{
//	maps\_load::main(1);
	maps\scriptgen\wetwork_scriptgen::main();

	maps\_guide::main(); // temp guide for prescripted levels.

	thread maps\_utility::PlayerUnlimitedAmmoThread();
}
