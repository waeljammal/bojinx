/**
 *  Copyright (c) 2007 - 2009 Adobe
 *  All rights reserved.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining
 *  a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included
 *  in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 *  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 *  IN THE SOFTWARE.
 */
package com.adobe.cairngorm.navigation.state
{
    import flash.utils.Dictionary;

    public class SelectedStates implements ISelectedIndex, ISelectedName
    {
        private var states:Dictionary = new Dictionary(true);

        private var _selectedIndex:int;

        public function get selectedIndex():int
        {
            return _selectedIndex;
        }

        public function set selectedIndex(value:int):void
        {
            _selectedIndex = value;
            broadcastChangeFor(ISelectedIndex, value);
        }

        private var _selectedName:String;

        public function get selectedName():String
        {
            return _selectedName;
        }

        public function set selectedName(value:String):void
        {
            _selectedName = value;
            broadcastChangeFor(ISelectedName, value);
        }

        private function broadcastChangeFor(stateType:Class, value:Object):void
        {
            var stateObject:AbstractOneParameterObservable = states[stateType];
            if (stateObject != null)
            {
                stateObject.broadcastChange(value);
            }
        }

        public function subscribe(listener:Object):void
        {
            if (listener is ISelectedIndex)
            {
                addStateObject(ISelectedIndex, SelectedIndexState, listener);
            }
            if (listener is ISelectedName)
            {
                addStateObject(ISelectedName, SelectedNameState, listener);
            }
        }

        public function unsubscribe(listener:Object):void
        {
            if (listener is ISelectedIndex)
            {
                this.states[ISelectedIndex] = null;
            }
            if (listener is ISelectedName)
            {
                this.states[ISelectedName] = null;
            }
        }

        private function addStateObject(stateType:Class, stateObjectType:Class, listener:Object):void
        {
            var states:AbstractOneParameterObservable = this.states[stateType];
            if (states == null)
            {
                states = this.states[stateType] = new stateObjectType();
            }
            states.subscribe(listener);
        }
    }
}