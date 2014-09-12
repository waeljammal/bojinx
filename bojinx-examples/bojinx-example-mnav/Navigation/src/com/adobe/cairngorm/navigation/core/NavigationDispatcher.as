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
    import com.adobe.cairngorm.LogUtil;
    import com.adobe.cairngorm.navigation.NavigationUtil;
    
    import flash.events.IEventDispatcher;
    
    import mx.logging.ILogger;

    public class NavigationDispatcher
    {
        private static const LOG:ILogger = LogUtil.getLogger(NavigationDispatcher);

        private var dispatcher:IEventDispatcher;

        private var lastDestinationTracker:LastDestinationTracker;

        public function NavigationDispatcher(dispatcher:IEventDispatcher, lastDestinationTracker:LastDestinationTracker)
        {
            this.dispatcher = dispatcher;
            this.lastDestinationTracker = lastDestinationTracker;
        }

        public function reset(destinationItem:DestinationStateController):void
        {
            destinationItem.reset();
        }

        public function performActionAndReturnIfIntercept(destinationItem:DestinationStateController,
                                                          destination:String, finalDestination:String):Boolean
        {
            var hadIntercepted:Boolean;
            var action:String = performAction(destinationItem, destination, finalDestination);
            if (NavigationActionName.isInterceptor(action))
            {
                hadIntercepted = true;
            }
            return hadIntercepted;
        }

        public function navigateAwayAndReturnIfIntercept(destinationItem:DestinationStateController):Boolean
        {
            var hadIntercepted:Boolean;
            var action:String = destinationItem.navigateAway();
            if (action == NavigationActionName.EXIT_INTERCEPT)
            {
                hadIntercepted = true;
            }
            else if (action == NavigationActionName.EXIT)
            {
                dispatchActionChange(destinationItem.destination, destinationItem.destination,
                                     destinationItem.destination, action, destinationItem.destination);
            }
            return hadIntercepted;
        }

        private function performAction(destinationItem:DestinationStateController,
                                       destination:String, finalDestination:String):String
        {
            var action:String = destinationItem.navigateTo(destination);
            if (action != null)
            {
                dispatchEvents(action, destinationItem, destination, finalDestination);
            }

            return action;
        }

        private function dispatchEvents(action:String, destinationItem:DestinationStateController,
                                        destination:String, finalDestination:String):void
        {
            var destinations:Array;
            if (action == NavigationActionName.FIRST_ENTER || action == NavigationActionName.ENTER)
            {
                var oldDestination:String;
                var state:DestinationStateController = lastDestinationTracker.getLastDestination(destination);
                if (state)
                {
                    oldDestination = state.destination;
                }
                dispatchWaypointChange(oldDestination, destination, finalDestination);

                var commonOld:String;
                if (oldDestination != null)
                {
                    commonOld = NavigationUtil.getCommonBase(oldDestination, destination);
                    var last:String = oldDestination.split(".")[commonOld.split(".").length];
					if(last != null)
					{
						commonOld += "." + last;
					}
                }
                else
                {
                    commonOld = oldDestination;
                }

                dispatchDestinationChange(commonOld, destination, finalDestination);

                dispatchActionChange(destination, oldDestination, destination, action,
                                     finalDestination);

                dispatchEveryEnterAction(destination, oldDestination, destination,
                                         finalDestination);
            }
            else
            {

                dispatchActionChange(destinationItem.destination, destinationItem.destination,
                                     destination, action, finalDestination);
            }
        }

        private function dispatchWaypointChange(oldDestination:String, newDestination:String,
                                                finalDestination:String):void
        {
            var oldWaypoint:String = NavigationUtil.getParent(oldDestination);
            var newWaypoint:String = NavigationUtil.getParent(newDestination);
            if (oldWaypoint != newWaypoint)
            {
                var event:NavigationActionEvent = new NavigationActionEvent(NavigationActionEvent.WAYPOINT_CHANGE,
                                                                            oldDestination,
                                                                            newDestination,
                                                                            finalDestination);

                dispatcher.dispatchEvent(event);
                LOG.info(event.type + " " + newWaypoint);
            }
        }

        private function dispatchDestinationChange(oldDestination:String, newDestination:String,
                                                   finalDestination:String):void
        {
            var oldWaypoint:String = NavigationUtil.getParent(oldDestination);
            if (newDestination == null)
                return;
            var newWaypoint:String = NavigationUtil.getParent(newDestination);
            if (newWaypoint == null)
                return;

            if (isWithinWaypointOrFirstWaypoint(oldWaypoint, newWaypoint) && oldDestination != newDestination)
            {
                var event:NavigationActionEvent = new NavigationActionEvent(newWaypoint,
                                                                            oldDestination,
                                                                            newDestination,
                                                                            finalDestination);

                dispatcher.dispatchEvent(event);
                LOG.info(event.type);
            }
        }

        private function isWithinWaypointOrFirstWaypoint(oldWaypoint:String, newWaypoint:String):Boolean
        {
            return (oldWaypoint == newWaypoint || oldWaypoint == null);
        }

        private function dispatchActionChange(type:String, oldDestination:String,
                                              newDestination:String, action:String,
                                              finalDestination:String):void
        {
            var type:String = NavigationActionName.getEventName(type, action);
            var event:NavigationActionEvent = new NavigationActionEvent(type, oldDestination,
                                                                        newDestination,
                                                                        finalDestination);

            dispatcher.dispatchEvent(event);
            LOG.info(type);
        }

        private function dispatchEveryEnterAction(type:String, oldDestination:String,
                                                  newDestination:String, finalDestination:String):void
        {
            var type:String = NavigationActionName.getEventName(type, NavigationActionName.EVERY_ENTER);
            var event:NavigationActionEvent = new NavigationActionEvent(type, oldDestination,
                                                                        newDestination,
                                                                        finalDestination);

            dispatcher.dispatchEvent(event);
            LOG.info(type);
        }
    }
}