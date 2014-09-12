/**
 * Copyright (c) 2007 - 2009 Adobe
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
package com.adobe.cairngorm.navigation.state
{
    import asmock.framework.Expect;
    import asmock.framework.MockRepository;
    import asmock.integration.flexunit.IncludeMocksRule;

    public class SelectedStatesTest
    {
		[Rule]
		public var mocks:IncludeMocksRule = new IncludeMocksRule([ISelectedName, ISelectedIndex]);
				
        private var states:SelectedStates;

        [Before]
        public function createStates():void
        {
            states = new SelectedStates();
        }

        [Test]
        public function shouldSetSelectedIndexListener():void
        {
            var mockRepository:MockRepository = new MockRepository();
            var selectedIndex:ISelectedIndex = ISelectedIndex(
                mockRepository.createStrict(ISelectedIndex));

            Expect.call(selectedIndex.selectedIndex = 1);

            mockRepository.replayAll();

            states.subscribe(selectedIndex);
            states.selectedIndex = 1;

            mockRepository.verifyAll();
        }

        [Test]
        public function shouldSetTwoSelectedIndexListeners():void
        {
            var mockRepository:MockRepository = new MockRepository();
            var selectedIndex:ISelectedIndex = ISelectedIndex(
                mockRepository.createStrict(ISelectedIndex));
            var selectedIndex2:ISelectedIndex = ISelectedIndex(
                mockRepository.createStrict(ISelectedIndex));

            Expect.call(selectedIndex.selectedIndex = 2);
            Expect.call(selectedIndex2.selectedIndex = 2);

            mockRepository.replayAll();

            states.subscribe(selectedIndex);
            states.subscribe(selectedIndex2);
            states.selectedIndex = 2;

            mockRepository.verifyAll();
        }

        [Test]
        public function shouldSetSelectedNameListener():void
        {
            var mockRepository:MockRepository = new MockRepository();
            var selectedName:ISelectedName = ISelectedName(
                mockRepository.createStrict(ISelectedName));

            Expect.call(selectedName.selectedName = "test");

            mockRepository.replayAll();

            states.subscribe(selectedName);
            states.selectedName = "test";

            mockRepository.verifyAll();
        }

        [Test]
        public function shouldSetTwoSelectedNameListeners():void
        {
            var mockRepository:MockRepository = new MockRepository();
            var selectedName:ISelectedName = ISelectedName(
                mockRepository.createStrict(ISelectedName));
            var selectedName2:ISelectedName = ISelectedName(
                mockRepository.createStrict(ISelectedName));

            Expect.call(selectedName.selectedName = "test");
            Expect.call(selectedName2.selectedName = "test");

            mockRepository.replayAll();

            states.subscribe(selectedName);
            states.subscribe(selectedName2);
            states.selectedName = "test";

            mockRepository.verifyAll();
        }

        [Test]
        public function shouldUnsubscribeSelectedIndexListener():void
        {
            var mockRepository:MockRepository = new MockRepository();
            var selectedIndex:ISelectedIndex = ISelectedIndex(
                mockRepository.createStrict(ISelectedIndex));

            Expect.call(selectedIndex.selectedIndex = 1).repeat.never();

            mockRepository.replayAll();

            states.subscribe(selectedIndex);
            states.unsubscribe(selectedIndex);
            states.selectedIndex = 1;

            mockRepository.verifyAll();
        }

        [Test]
        public function shouldUnsubscribeSelectedNameListener():void
        {
            var mockRepository:MockRepository = new MockRepository();
            var selectedName:ISelectedName = ISelectedName(
                mockRepository.createStrict(ISelectedName));

            Expect.call(selectedName.selectedName = "test").repeat.never();

            mockRepository.replayAll();

            states.subscribe(selectedName);
            states.unsubscribe(selectedName);
            states.selectedName = "test";

            mockRepository.verifyAll();
        }
    }
}