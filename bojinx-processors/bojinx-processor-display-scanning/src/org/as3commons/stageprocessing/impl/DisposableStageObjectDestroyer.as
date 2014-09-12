/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.stageprocessing.impl
{
	import com.bojinx.api.util.IDisposable;
	import flash.display.DisplayObject;
	
	/**
	 * <code>IStageObjectProcessor</code> implementation that checks if the specified <code>DisplayObject</code> passed to its <code>process()</code>
	 * method implements the <code>IDisposable</code> and, if so, invokes its <code>IDisposable.dispose()</code> method.
	 * @author Roland Zwaga
	 */
	public class DisposableStageObjectDestroyer extends AbstractStageObjectProcessor
	{
		
		/**
		 * Creates a new <code>DisposableStageObjectProcessor</code> instance.
		 */
		public function DisposableStageObjectDestroyer()
		{
			super( this );
		}
		
		/*============================================================================*/
		/*= PUBLIC METHODS                                                            */
		/*============================================================================*/
		
		/**
		  *	Checks if the specified <code>DisplayObject</code> implements the <code>IDisposable</code> and, if so, invokes its <code>IDisposable.dispose()</code> method.
		  * @param displayObject The specified <code>DisplayObject</code> that will be checked for an <code>IDisposable</code> implementation.
		  * @return The specified <code>DisplayObject</code>
		 */
		override public function destroy( displayObject:DisplayObject ):DisplayObject
		{
			var disposable:IDisposable = displayObject as IDisposable;
			
			if (( disposable != null ))
			{
				disposable.dispose();
			}
			
			return displayObject;
		}
		
		/**
		 * Does nothing, immediately returns the specified <code>DisplayObject</code>.
		 * @param displayObject
		 * @return
		 *
		 */
		override public function process( displayObject:DisplayObject ):DisplayObject
		{
			return displayObject;
		}
	}
}
