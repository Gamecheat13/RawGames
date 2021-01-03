#namespace AnimationSelectorTable;

function RegisterAnimationSelectorTableEvaluator( functionName, functionPtr )
{
	if ( !IsDefined( level._astevaluatorscriptfunctions ) )
	{
		level._astevaluatorscriptfunctions = [];
	}
	
	functionName = ToLower( functionName );

	Assert( IsDefined( functionName ) && IsDefined( functionPtr ) );
	Assert( !IsDefined( level._astevaluatorscriptfunctions[functionName] ) );
	
	level._astevaluatorscriptfunctions[functionName] = functionPtr;
}