package avmplus
{
	
	public class DescribeTypeJSON
	{
		/*============================================================================*/
		/*= STATIC PUBLIC PROPERTIES                                                  */
		/*============================================================================*/
		
		public static function get instances():int
		{
			return INCLUDE_BASES
				| INCLUDE_INTERFACES
				| INCLUDE_VARIABLES
				| INCLUDE_ACCESSORS
				| INCLUDE_METHODS
				| INCLUDE_METADATA
				| INCLUDE_CONSTRUCTOR
				| INCLUDE_TRAITS
				| HIDE_OBJECT
				| USE_ITRAITS;
		}
		
		public static function get jsonType():Function
		{
			try
			{
				return describeTypeJSON;
			}
			catch ( e:Error )
			{
			}
			
			return null;
		}
		
		public static function get statics():int
		{
			return INCLUDE_INTERFACES
				| INCLUDE_VARIABLES
				| INCLUDE_ACCESSORS
				| INCLUDE_METHODS
				| INCLUDE_METADATA
				| HIDE_OBJECT
				| INCLUDE_TRAITS;
		}
	}
}
