/*
   Copyright (c) 2007 Ultraweb Development

   This file is part of Bojinx.

   Bojinx is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Bojinx is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Bojinx.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.bojinx.utils.tasks
{
	import com.bojinx.api.context.IApplicationContext;
	
	public class MessageTaskGroup extends TaskGroup
	{
		
		/*============================================================================*/
		/*= PRIVATE PROPERTIES                                                        */
		/*============================================================================*/
		
		private var context:IApplicationContext;
		
		private var scope:String;
		
		public function MessageTaskGroup( context:IApplicationContext,
										  sequential:Boolean = true,
										  description:String = null )
		{
			super( sequential, description );
			
			this.scope = scope;
			this.context = context;
		}
		
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		public function addMessage( message:*, name:String = null ):Task
		{
			var task:MessageTask = new MessageTask( context, message, name );
			addTask( task );
			return task;
		}
	}
}
