// EMPTY ANIMSCRIPT AS WE DO NOT NEED AI TO RUN ANYTHING HERE

function main()
{

}

function end_script()
{
	// This callback will be called when AI will change states from AIS_BEHAVE to AIS_SCRIPTED
	// i.e when it will go from behavior state to animscripted state
	
	if( IsDefined( self.___ArchetypeOnAnimscriptedCallback ) )
		[[self.___ArchetypeOnAnimscriptedCallback]]( self );
}
