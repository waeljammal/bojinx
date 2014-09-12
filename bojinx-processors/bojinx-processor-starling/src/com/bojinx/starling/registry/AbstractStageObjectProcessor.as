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
package com.bojinx.starling.registry {

	import com.bojinx.api.util.IDisposable;
	import flash.errors.IllegalOperationError;
	import starling.display.DisplayObject;

	/**
	 * Abstract base class for <code>IStageProcessor</code> implementations.
	 * @author Roland Zwaga
	 */
	public class AbstractStageObjectProcessor implements IStageObjectDestroyer, IDisposable {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Abstract constructor
		 * @throws flash.errors.IllegalOperationError When called directly
		 */
		public function AbstractStageObjectProcessor(self:AbstractStageObjectProcessor) {
			super();
			initAbstractStageProcessor(self);
		}

		protected function initAbstractStageProcessor(self:AbstractStageObjectProcessor):void {
			if (self !== this) {
				throw new IllegalOperationError("AbstractStageProcessor is abstract");
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// isDisposed
		// ----------------------------

		private var _isDisposed:Boolean = false;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @throws flash.errors.IllegalOperationError When called directly, must be implemented in sub class
		 * @inheritDoc
		 */
		public function process(displayObject:DisplayObject):DisplayObject {
			throw new IllegalOperationError("Not implemented in abstract base class");
		}

		/**
		 * @throws flash.errors.IllegalOperationError When called directly, must be implemented in sub class
		 * @inheritDoc
		 */
		public function destroy(displayObject:DisplayObject):DisplayObject {
			throw new IllegalOperationError("Not implemented in abstract base class");
		}

		public function dispose():void {
			_isDisposed = true;
		}

	}
}
