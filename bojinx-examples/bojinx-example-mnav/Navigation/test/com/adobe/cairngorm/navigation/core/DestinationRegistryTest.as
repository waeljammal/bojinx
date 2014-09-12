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
package com.adobe.cairngorm.navigation.core
{
	import flash.events.EventDispatcher;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	public class DestinationRegistryTest extends EventDispatcher
	{		
		[Test]
		public function shouldRegister():void
		{
			var registry:DestinationRegistry = new DestinationRegistry(this);
			registry.registerDestination("content.news");
			registry.registerDestination("content.chat");
			
			assertTrue("content", registry.hasDestination("content"));
			assertTrue("content.news", registry.hasDestination("content.news"));
			assertTrue("content.chat", registry.hasDestination("content.chat"));
		}
		
		[Test]
		public function shouldUnregister():void
		{
			var registry:DestinationRegistry = new DestinationRegistry(this);
			registry.registerDestination("content.news");
			registry.registerDestination("content.chat");
			
			registry.unregisterDestination("content.news");
			
			assertTrue("content", registry.hasDestination("content"));
			assertFalse("content.news", registry.hasDestination("content.news"));
		}	
		
		[Test]
		public function whenUnregisterAllThenChechForAnyDestinations():void
		{
			var registry:DestinationRegistry = new DestinationRegistry(this);
			registry.registerDestination("content.news");
			registry.registerDestination("content.chat");
			
			assertTrue("hasAnyDestinations before", registry.hasAnyDestinations);
			
			registry.unregisterDestination("content");
			registry.unregisterDestination("content.news");
			registry.unregisterDestination("content.chat");
			
			assertFalse("hasAnyDestinations after", registry.hasAnyDestinations);
		}
		
		
		[Test]
		public function shouldNotGetNextPendingWhenNoMatch():void
		{
			var registry:DestinationRegistry = new DestinationRegistry(this);
			registry.addPending("parent.child1");
			registry.addPending("parent.child2");
			registry.addPending("parent.child1.child1");
			registry.addPending("parent.child1.child2");
			
			assertNull(registry.getNextPending("foo.bar"));
		}
		
		[Test]
		public function shouldNotGetNextPendingWhenNoNextMatch():void
		{
			var registry:DestinationRegistry = new DestinationRegistry(this);
			registry.addPending("parent.child1");
			registry.addPending("parent.child2");
			registry.addPending("parent.child1.child1");
			registry.addPending("parent.child1.child2");
			
			assertNull(registry.getNextPending("parent.child2"));
		}
		
		[Test]
		public function shouldGetNextPendingWhenOneMatch():void
		{
			var registry:DestinationRegistry = new DestinationRegistry(this);
			registry.addPending("parent.child1");
			registry.addPending("parent.child1.child1");
			registry.addPending("parent.child1.child2");
			registry.addPending("parent.child2");			
			registry.addPending("parent.child3");
			registry.addPending("parent.child3.child1");

			assertEquals("parent.child3.child1", registry.getNextPending("parent.child3"));
		}
		
		[Test]
		public function shouldGetNextPendingWhenTwoMatches():void
		{
			var registry:DestinationRegistry = new DestinationRegistry(this);
			registry.addPending("parent.child1");
			registry.addPending("parent.child1.child1");
			registry.addPending("parent.child1.child2");
			registry.addPending("parent.child2");			
			registry.addPending("parent.child3");
			registry.addPending("parent.child3.child1");
			
			var next:String = registry.getNextPending("parent.child1");
			assertTrue("expected either parent.child1.child1 or parent.child1.child2", 
				"parent.child1.child1" == next || "parent.child1.child2" == next);
		}		
	}
}