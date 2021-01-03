
#namespace table;

/@
"Name: load( <str_filename>, <str_table_start>, [b_convert_numbers] )"
"Summary: Load a table into an array indexed by the values in the first row and column ( table[ row ][ column ] )."
"Module: String"
"MandatoryArg: <string> : The string to strip."
"OptionalArg: [b_convert_numbers] : Convert number cells from strings to numbers."
"Example: table::load( "gamedata\tables\cp\blahblah.csv", "tableheader" );"
"SPMP: both"
@/
function load( str_filename, str_table_start, b_convert_numbers = true )
{
	a_table = [];
	
	n_header_row = TableLookupRowNum( str_filename, 0, str_table_start );
	
	Assert( n_header_row > -1, "Could not find start of table." );
	
	a_headers = TableLookupRow( str_filename, n_header_row );
	
	n_row = n_header_row + 1;
	
	do
	{
		a_row = TableLookupRow( str_filename, n_row );
		
		if ( isdefined( a_row ) && a_row.size > 0 )
		{
			index = StrStrip( a_row[ 0 ] );
			
			if ( index != "" )
			{
				if ( index == "table_end" )
				{
					break;
				}

				if ( b_convert_numbers )
				{
					index = str_to_num( index );
				}
				
				a_table[ index ] = [];
				
				for ( val = 1; val < a_row.size; val++ )
				{
					if ( StrStrip( a_headers[ val ] ) != "" && strStrip( a_row[ val ] ) != "" )
					{
						value = a_row[ val ];
						
						if ( b_convert_numbers )
						{
							value = str_to_num( value );
						}
						
						a_table[ index ][ a_headers[ val ] ] = value;
					}
				}
			}
		}
		
		n_row++;
	}
	while ( isdefined( a_row ) && a_row.size > 0 );
	
	return a_table;
}

function str_to_num( value )
{
	if ( StrIsInt( value ) )
	{
		value = Int( value );
	}
	else if ( StrIsFloat( value ) )
	{
		value = Float( value );
	}
	
	return value;
}
