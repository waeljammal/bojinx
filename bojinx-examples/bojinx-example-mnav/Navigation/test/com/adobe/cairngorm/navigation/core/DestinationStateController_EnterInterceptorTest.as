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

    import org.flexunit.assertThat;
    import org.hamcrest.object.equalTo;

    public class DestinationStateController_EnterInterceptorTest
    {
        private var controller:DestinationStateController;

        [Before]
        public function setUp():void
        {
            controller = new DestinationStateController("content.news");
            controller.hasEnterInterceptor = true;
        }

        [Test]
        public function whenFirstEnterThenIntercept():void
        {
            controller.hasFirstEntered = false;
            controller.isSelected = false;

            var action:String = controller.navigateTo("content.news");

            assertThat(action, equalTo(NavigationActionName.ENTER_INTERCEPT));
        }

        [Test]
        public function whenEnterThenIntercept():void
        {
            controller.hasFirstEntered = true;
            controller.isSelected = false;

            var action:String = controller.navigateTo("content.news");

            assertThat(action, equalTo(NavigationActionName.ENTER_INTERCEPT));
        }
    }
}