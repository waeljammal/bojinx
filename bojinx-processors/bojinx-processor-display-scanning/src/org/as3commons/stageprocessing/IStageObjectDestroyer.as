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
package org.as3commons.stageprocessing {
	import flash.display.DisplayObject;

	/**
	 * Describes an object that can process objects that have been removed from the stage.
	 * @author Roland Zwaga
	 */
	public interface IStageObjectDestroyer extends IStageObjectProcessor {
		/**
		 * Performs a destroy operation on the specified <code>DisplayObject</code>.
		 * @param displayObject The object that will be destroyed.
		 * @return The destroyed object.
		 */
		function destroy(displayObject:DisplayObject):DisplayObject;
	}
}