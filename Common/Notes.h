/*
 
///////////////
// iOS NOTES
///////////////

*** iOS Events ***
 
The UIApplication object and each UIWindow object dispatches events in the sendEvent: method. ( These classes declare a method with the same signature).
Because these methods are funnel points for events coming into an application, you can subclass UIApplication or UIWindow and override the
sendEvent: method to monitor events (which is something few applications would need to do). If you override these methods, be sure to call the
superclass implementation (that is, [super sendEvent:theEvent]); never tamper with the distribution of events.

When the system delivers a touch event, it first sends it to a specific view. For touch events, that view is the one returned by hitTest:withEvent:
for “shaking” -motion events, remote-control events, action messages, and editing-menu messages, that view is the first responder.

If the initial view doesn’t handle the event, it travels up the responder chain along a particular path:
1. The hit-test view or first responder passes the event or message to its view controller if it has one; if the view doesn’t have a view controller, it passes the event or message to its superview.
2. If a view or its view controller cannot handle the event or message, it passes it to the superview of the view.
3. Each subsequent superview in the hierarchy follows the pattern described in the first two steps if it cannot handle the event or message.
4. The topmost view in the view hierarchy, if it doesn’t handle the event or message, passes it to the window object for handling.
5. The UIWindow object, if it doesn’t handle the event or message, passes it to the singleton application object.
If the application object cannot handle the event or message, it discards it.

If you implement a custom view to handle “shaking”-motion events, remote-control events, action messages, or editing-menu messages, you
should not forward the event or message to nextResponder directly to send it up the responder chain. Instead invoke the superclass
implementation of the current event-handling method—let UIKit handle the traversal of the responder chain.

Core Motion is apart from UIKit architectures and conventions. There is no connection with the UIEvent model and there is no notion of
first responder or responder chain. It delivers motion events directly to applications that request them. The CMMotionManager class is 
the central access point for Core Motion. You create an instance of the class, specify an update interval (either explicitly or implicitly),
request that updates start, and handle the motion events as they are delivered. An alternative to Core Motion, at least for accessing 
accelerometer data, is the UIAccelerometer class of the UIKit framework. When you use this class, accelerometer events are delivered as
UIAcceleration objects. Although UIAccelerometer is part of UIKit, it is also separate from the UIEvent and responder-chain architectures.
TheUIAccelerometerandUIAccelerationclasseswillbedeprecatedinafuturerelease, so if your application handles accelerometer events,
it should transition to the Core Motion API. In iOS 3.0 and later, if you are trying to detect specific types of motion as gestures—specifically
shaking motions—you should consider handling motion events (UIEventTypeMotion) instead of using the accelerometer interfaces.
If you want to receive and handle high-rate, continuous motion data, you should instead use the Core Motion accelerometer API. 

Multitouch Events
 
Touch events in iOS are based on a Multi-Touch model. iOS 4.0 still reports touches on iPhone 4 (and on future high-resolution devices) in a 320x480 coordinate space to maintain source compatibility, but the resolution is twice as high in each dimension for applications built for iOS 4.0 and later releases. In concrete terms, that means that touches for applications built for iOS 4 running on iPhone 4 can land on half-point boundaries where on older devices they land only on full point boundaries. If you have any round-to-integer code in your touch-handling path you may lose this precision.
Many classes in UIKit handle multitouch events in ways that are distinctive to objects of the class. This is especially true of subclasses of UIControl, such as UIButton and UISlider. Objects of these subclasses—known as control objects—are receptive to certain types of gestures, such as a tap or a drag in a certain direction; when properly configured, they send an action message to a target object when that gesture occurs. Other UIKit classes handle gestures in other contexts; for example, UIScrollView provides scrolling behavior for table views, text views, and other views with large content areas.
Some applications may not need to handle events directly; instead, they can rely on the classes of UIKit for that behavior. However, if you create a custom subclass of UIView—a common pattern in iOS development—and if you want that view to respond to certain touch events, you need to implement the code required to handle those events. Moreover, if you want a UIKit object to respond to events differently, you have to create a subclass of that framework class and override the appropriate event-handling methods.

Events and Touches

In iOS, a touch is the presence or movement of a finger on the screen that is part of a unique multitouch sequence. For example, a pinch-close gesture has two touches: two fingers on the screen moving toward each other from opposite directions. There are simple single-finger gestures, such as a tap, or a double-tap, a drag, or a flick (where the user quickly swipes a finger across the screen). An application might recognize even more complicated gestures; for example, an application might have a custom control in the shape of a dial that users “turn” with multiple fingers to fine-tune some variable.
A UIEvent object of type UIEventTypeTouches represents a touch event. The system continually sends these touch-event objects (or simply, touch events) to an application as fingers touch the screen and move across its surface. The event provides a snapshot of all touches during a multitouch sequence, most importantly the touches that are new or have changed for a particular view.
An application receives event objects during each phase of any touch. 

UITouchPhaseBegan
UITouchPhaseMoved
UITouchPhaseEnded

Touches, which are represented by UITouch objects, have both temporal and spatial aspects. The temporal aspect, called a phase, indicates when a touch has just begun, whether it is moving or stationary, and when it ends—that is, when the finger is lifted from the screen.
The spatial aspect of touches concerns their association with the object in which they occur as well as their location in it. When a finger touches the screen, the touch is associated with the underlying window and view and maintains that association throughout the life of the event. If multiple touches arrive at once, they are treated together only if they are associated with the same view. Likewise, if two touches arrive in quick succession, they are treated as a multiple tap only if they are associated with the same view. A touch object stores the current location and previous location (if any) of the touch in its view or window.
 
 An event object contains all touch objects for the current multitouch sequence and can provide touch objects specific to a view or window (see Figure 2-2). A touch object is persistent for a given finger during a sequence, and UIKit mutates it as it tracks the finger throughout it. The touch attributes that change are the phase of the touch, its location in a view, its previous location, and its timestamp. Event-handling code may evaluate these attributes to determine how to respond to a touch event.
 
 Because the system can cancel a multitouch sequence at any time, an event-handling application must be prepared to respond appropriately. Cancellations can occur as a result of overriding system events, such as an incoming phone call.
 
 Approaches for Handling Touch Events
 
 Most applications that are interested in users’ touches on their custom views are interested in detecting and handling well-established gestures. These gestures include tapping (one or multiple times), pinching (to zoom a view in or out), swiping , panning or dragging a view, and using two fingers to rotate a view.
 You could implement the touch-event handling code to recognize and handle these gestures, but that code would be complex, possibly buggy, and take some time to write. Alternatively, you could simplify the interpretation and handling of common gestures by using one of the gesture recognizer classes introduced in iOS 3.2. To use a gesture recognizer, you instantiate it, attach it to the view receiving touches, configure it, and assign it an action selector and a target object.
 You can implement a custom gesture recognizer by subclassing UIGestureRecognizer. A custom gesture recognizer requires you to analyze the stream of events in a multitouch sequence to recognize your distinct gesture.
 
 Regulating Touch Event Delivery
 
 UIKit gives applications programmatic means to simplify event handling or to turn off the stream of UIEvent objects completely. The following list summarizes these approaches:
 Turning off delivery of touch events - A view also does not receive events if it’s hidden or if it’s transparent.
 Turning off delivery of touch events for a period. An application can call the UIApplication method beginIgnoringInteractionEvents and later call the
 endIgnoringInteractionEvents method. You sometimes want to turn off event delivery while your code is performing animations.
 Turning on delivery of multiple touches - By default, a view ignores all but the first touch during a multitouch sequence. If you want the view to handle multiple
 touches you must enable this capability for the view. You do this programmatically by setting the multipleTouchEnabled property of your view to YES, or in Interface Builder
 by setting the related attribute in the inspector for the related view.
 Restricting event delivery to a single view. By default, a view’s exclusiveTouch property is set to NO, which means that this view does not block other views
 in a window from receiving touches. If you set the property to YES, you mark the view so that, if it is tracking touches, it is the only view in the window that is tracking touches.
 If a finger contacts an exclusive-touch view, then that touch is delivered only if that view is the only view tracking a finger in that window. If a finger
 touches a non-exclusive view, then that touch is delivered only if there is not another finger tracking in an exclusive-touch view.
 Restricting event delivery to subviews. A custom UIView class can override hitTest:withEvent: to restrict the delivery of multitouch events to its subviews.
 
 Handling Multitouch Events
 
 To handle multitouch events, you must first create a subclass of a responder class. This subclass could be any one of the following:
 A custom view (subclass of UIView)
 A subclass of UIViewController or one of its UIKit subclasses
 A subclass of a UIKit view or control class, such as UIImageView or UISlider A subclass of UIApplication or UIWindow (although this would be rare)
 A view controller typically receives, via the responder chain, touch events initially sent to its view if that view does not override the touch-handling methods.
 For instances of your subclass to receive multitouch events, your subclass must implement one or more of the UIResponder methods for touch-event handling, described
 below. In addition, the view must be visible (neither transparent or hidden) and must have its userInteractionEnabled property set to YES, which is the default.
 
 During a multitouch sequence, the application dispatches a series of event messages to the target responder. To receive and handle these messages, the class of a
 responder object must implement at least one of the following methods declared by UIResponder, and, in some cases, all of these methods:
 
 - (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
 - (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
 - (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
 - (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
 
 Each message that invokes an event-handling method passes in two parameters. The first is a set of UITouch objects that represent new or changed touches for the
 given phase. The second parameter is a UIEvent object representing this particular event. From the event object you can get all touch objects for the event or a
 subset of those touch objects filtered for specific views or windows. Some of these touch objects represent touches that have not changed since the previous event
 message or that have changed but are in different phases.
 
 Basics of Touch-Event Handling
 
 You frequently handle an event for a given phase by getting one or more of the UITouch objects in the passed-in set, evaluating their properties or getting their
 locations, and proceeding accordingly. The objects in the set represent those touches that are new or have changed for the phase represented by the implemented
 event-handling method. If any of the touch objects will do, you can send the NSSet object an anyObject message
 An important UITouch method is locationInView:, which, if passed a parameter of self, yields the location of the touch in the coordinate system of the receiving
 view. A parallel method tells you the previous location of the touch (previousLocationInView:). Properties of the UITouch instance tell you how many taps have
 been made (tapCount), when the touch was created or last mutated (timestamp), and what phase it is in (phase).
 If for some reason you are interested in touches in the current multitouch sequence that have not changed since the last phase or that are in a phase other than
 the ones in the passed-in set, you can request them from the passed-in UIEvent object.
 If on the other hand you are interested in only those touches associated with a specific window, you would send the UIEvent object a touchesForWindow: message.
 If you want to get the touches associated with a specific view, you would call touchesForView: on the event object.
 If a responder creates persistent objects while handling events during a multitouch sequence, it should implement touchesCancelled:withEvent: to dispose of
 those objects when the system cancels the sequence.
 If your custom responder class is a subclass of UIView or UIViewController, you should implement all of the methods described in “The Event-Handling Methodss.
 If your class is a subclass of any other UIKit responder class, you do not need to override all of the event-handling methods.
 All views that process touches, including your own, expect (or should expect) to receive a full touch-event stream. If you prevent a UIKit responder object from
 receiving touches for a certain phase of an event, the resulting behavior may be undefined and probably undesirable.
 
Handling Tap Gestures
 
To determine the number of times the user tapped a responder object, you get the value of the tapCount property
of a UITouch object. The best places to find this value are the methods touchesBegan:withEvent: and touchesEnded:withEvent:.
In many cases, the latter method is preferred because it corresponds to the touch phase in which the user lifts a finger
from a tap. By looking for the tap count in the touch-up phase (UITouchPhaseEnded), you ensure that the finger is really
tapping and not, for instance, touching down and then dragging.
 
Detecting a double-tap gesture:
 
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	for( UITouch *touch in touches )
	{
		if( touch.tapCount >= 2 )
		{
			[ self.superview bringSubviewToFront:self ];
		}
	}
}
 
A complication arises when a responder object wants to handle a single-tap and a double-tap gesture in different ways.
For example, a single tap might select the object and a double tap might display a view for editing the item that was
double-tapped. How is the responder object to know that a single tap is not the first part of a double tap?
Listing 2-2 (page 25) illustrates an implementation of the event-handling methods that increases the size of the
receiving view upon a double-tap gesture and decreases it upon a single-tap gesture.

In touchesEnded:withEvent:, when the tap count is one, the responder object sends itself a performSelector:withObject:afterDelay:
message. The selector identifies another method implemented by the responder to handle the single-tap gesture; the second
parameter is an NSValue or NSDictionary object that holds some state of the UITouch object; the delay is some reasonable
interval between a single- and a double-tap gesture. Because a touch object is mutated as it proceeds through a multitouch
sequence, you cannot retain a touch and assume that its state remains the same. And you cannot copy a touch object because
UITouch does not adopt the NSCopying protocol. Thus if you want to preserve the state of a touch object, you should store
those bits of state in a NSValue object, a dictionary, or a similar object. In touchesBegan:withEvent:, if the tap count is
two, the responder object cancels the pending delayed-perform invocation by calling the cancelPreviousPerformRequestsWithTarget:
method of NSObject, passing itself as the argument. If the tap count is not two, the method identified by the selector in the
previous step for single-tap gestures is invoked after the delay. In touchesEnded:withEvent:, if the tap count is two,
the responder performs the actions necessary for handling double-tap gestures.
 
Listing 2-2 Handling a single-tap gesture and a double-tap gesture
 
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *aTouch = [ touches anyObject ];
	
	if( aTouch.tapCount == 2 )
	{
		[ NSObject cancelPreviousPerformRequestsWithTarget:self ];
	}
}
 
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *theTouch = [ touches anyObject ];
	
	if( theTouch.tapCount == 1 )
	{
		NSDictionary *touchLoc = [ NSDictionary dictionaryWithObject:[ NSValue valueWithCGPoint:[ theTouch locationInView:self ] ] forKey:@"location" ];
		 
		[ self performSelector:@selector( handleSingleTap: ) withObject:touchLoc afterDelay:0.3 ];
	}
	else if ( theTouch.tapCount == 2 )
	{
		// Double-tap: increase image size by 10%"
		
		CGRect myFrame = self.frame;
		
		myFrame.size.width += self.frame.size.width * 0.1;
		myFrame.size.height += self.frame.size.height * 0.1;
		myFrame.origin.x -= (self.frame.origin.x * 0.1) / 2.0;
		myFrame.origin.y -= (self.frame.origin.y * 0.1) / 2.0;
		
		[ UIView beginAnimations:nil context:NULL ];
		 
		[ self setFrame:myFrame ];
		
		[ UIView commitAnimations ];
	}
}
 
- (void)handleSingleTap:(NSDictionary*)touches
{
	// Single-tap: decrease image size by 10%"
 
	CGRect myFrame = self.frame;
	
	myFrame.size.width -= self.frame.size.width * 0.1;
	myFrame.size.height -= self.frame.size.height * 0.1;
	myFrame.origin.x += ( self.frame.origin.x * 0.1 ) / 2.0;
	myFrame.origin.y += ( self.frame.origin.y * 0.1 ) / 2.0;
	
	[ UIView beginAnimations:nil context:NULL ];
	 
	[ self setFrame:myFrame ];
	 
	[ UIView commitAnimations ];
}
 
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
}

Handling Swipe and Drag Gestures

To detect a swipe gesture, you have to track the movement of the user’s finger along the desired axis of motion,
but it is up to you to determine what constitutes a swipe. In other words, you need to determine whether the user’s
finger moved far enough, if it moved in a straight enough line, and if it went fast enough. You do that by storing
the initial touch location and comparing it to the location reported by subsequent touch-moved events.
Listing 2-3 shows some basic tracking methods you could use to detect horizontal swipes in a view. In this example,
the view stores the initial location of the touch in a startTouchPosition instance variable. As the user’s finger
moves, the code compares the current touch location to the starting location to determine whether it is a swipe.
If the touch moves too far vertically, it is not considered to be a swipe and is processed differently. If it
continues along its horizontal trajectory, however, the code continues processing the event as if it were a swipe.

Listing 2-3 Tracking a swipe gesture in a view

#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    4

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *touch = [ touches anyObject ];
	
	// startTouchPosition is an instance variable
	
	startTouchPosition = [ touch locationInView:self ];
￼￼￼￼￼￼￼}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *touch = [ touches anyObject ];
	CGPoint	currentTouchPosition = [ touch locationInView:self ];

	// To be a swipe, direction of touch must be horizontal and long enough.

	if( fabsf( startTouchPosition.x - currentTouchPosition.x ) >= HORIZ_SWIPE_DRAG_MIN && fabsf( startTouchPosition.y - currentTouchPosition.y ) <= VERT_SWIPE_DRAG_MAX )
	{
		// It appears to be a swipe.
 
		if ( startTouchPosition.x < currentTouchPosition.x )
		{
			[ self myProcessRightSwipe:touches withEvent:event ];
		}
		else
		{
			[ self myProcessLeftSwipe:touches withEvent:event ];
		}
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	startTouchPosition = CGPointZero;
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
	startTouchPosition = CGPointZero;
}
 
Listing 2-4 shows an even simpler implementation of tracking a single touch, but this time for the purposes of dragging the receiving view around the screen.
In this instance, the responder class fully implements only the touchesMoved:withEvent: method, and in this method computes a delta value between the touch's
current location in the view and its previous location in the view. It then uses this delta value to reset the origin of the view’s frame.
 
Listing 2-4 Dragging a view using a single touch
 
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
}
 
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *aTouch = [touches anyObject];
	CGPoint loc = [aTouch locationInView:self];
	CGPoint prevloc = [aTouch previousLocationInView:self];
	CGRect myFrame = self.frame;
	float deltaX = loc.x - prevloc.x;
	float deltaY = loc.y - prevloc.y;
	myFrame.origin.x += deltaX;
	myFrame.origin.y += deltaY;
	[self setFrame:myFrame];
 }
 
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
}
 
Handling a Complex Multitouch Sequence
 
 Taps, drags, and swipes are simple gestures, typically involving only a single touch. Handling a touch event consisting of two or more touches
 is a more complicated affair. You may have to track all touches through all phases, recording the touch attributes that have changed and altering
 internal state appropriately. There are a couple of things you should do when tracking and handling multiple touches:
 Set the multipleTouchEnabled property of the view to YES.
 Use a Core Foundation dictionary object (CFDictionaryRef) to track the mutations of touches through
 their phases during the event.
 When handling an event with multiple touches, you often store initial bits of each touch’s state for later comparison with the mutated UITouch
 instance. As an example, say you want to compare the final location of each touch with its original location. In the touchesBegan:withEvent:
 method, you can obtain the original location of each touch from the locationInView: method and store those in a CFDictionaryRef object using
 the addresses of the UITouch objects as keys. Then, in the touchesEnded:withEvent: method you can use the address of each passed-in UITouch
 object to obtain the object’s original location and compare that with its current location. ( You should use a CFDictionaryRef type rather
 than an NSDictionary object; the latter copies its keys, but the UITouch class does not adopt the NSCopying protocol, which is required for object copying.)
 Listing 2-5 illustrates how you might store beginning locations of UITouch objects in a Core Foundation dictionary.
 
 Listing 2-5 Storing the beginning locations of multiple touches
 
 - (void)cacheBeginPointForTouches:(NSSet *)touches
 {
 if ([touches count] > 0) {
 for (UITouch *touch in touches) {
 touch);
 } }
 CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints,
 if (point == NULL) {
 point = (CGPoint *)malloc(sizeof(CGPoint));
 CFDictionarySetValue(touchBeginPoints, touch, point);
 }
 *point = [touch locationInView:view.superview];
 }
 
 Listing 2-6 illustrates how to retrieve those initial locations stored in the dictionary. It also gets the current locations of the same touches.
 It uses these values in computing an affine transformation (not shown).
 
 Listing 2-6 Retrieving the initial locations of touch objects
 
 - (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches {
 NSArray *sortedTouches = [[touches allObjects]
 sortedArrayUsingSelector:@selector(compareAddress:)];
 // other code here ...
 UITouch *touch1 = [sortedTouches objectAtIndex:0];
 UITouch *touch2 = [sortedTouches objectAtIndex:1];
 CGPoint beginPoint1 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints,
 touch1);
 CGPoint currentPoint1 = [touch1 locationInView:view.superview];
 CGPoint beginPoint2 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints,
 touch2);
 CGPoint currentPoint2 = [touch2 locationInView:view.superview];
 // compute the affine transform...
 }
 
 Although the code example in Listing 2-7 doesn’t use a dictionary to track touch mutations,
 it also handles multiple touches during an event. It shows a custom UIView object responding
 to touches by animating the movement of a “Welcome” placard around the screen as a finger
 moves it and changing the language of the welcome when the user makes a double-tap gesture. 
 The code in this example comes from the MoveMe sample code project, which you can examine
 to get a better understanding of the event-handling context.)
 
 Listing 2-7 Handling a complex multitouch sequence
 
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [[event allTouches] anyObject];
 // Only move the placard view if the touch was in the placard view
 if ([touch view] != placardView) {
 // On double tap outside placard view, update placard's display string
 if ([touch tapCount] == 2) {
 [placardView setupNextDisplayString];
 }
 return; }
 // "Pulse" the placard view by scaling up then down
 // Use UIView's built-in animation
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:0.5];
 CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
 placardView.transform = transform;
 [UIView commitAnimations];
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:0.5];
 transform = CGAffineTransformMakeScale(1.1, 1.1);
 placardView.transform = transform;
 [UIView commitAnimations];
 // Move the placardView to under the touch
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:0.25];
 placardView.center = [self convertPoint:[touch locationInView:self]
 fromView:placardView];
 [UIView commitAnimations];
 }
 
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [[event allTouches] anyObject];
 // If the touch was in the placardView, move the placardView to its location
 if ([touch view] == placardView) {
 CGPoint location = [touch locationInView:self];
 location = [self convertPoint:location fromView:placardView];
 placardView.center = location;
 return;
 } }
 
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [[event allTouches] anyObject];
 // If the touch was in the placardView, bounce it back to the center
 if ([touch view] == placardView) {
 // Disable user interaction so subsequent touches don't interfere with
 animation
 ￼￼￼} }
 self.userInteractionEnabled = NO;
 [self animatePlacardViewToCenter];
 return;
 
 Note Customviewsthatredrawthemselvesinresponsetoeventstheyhandlegenerallyshould only set drawing state in the event-handling methods and perform all of the 
 drawing in the drawRect: method. To learn more about drawing view content, see View Programming Guide for iOS .
 
 To find out when the last finger in a multitouch sequence is lifted from a view, compare the number of UITouch objects in the passed-in set with the 
 number of touches for the view maintained by the passed-in UIEvent object. If they are the same, then the multitouch sequence has concluded.
 
 Listing 2-8 Determining when the last touch in a multitouch sequence has ended
 
 - (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
 if ([touches count] == [[event touchesForView:self] count]) {
 // last finger has lifted....
 }
 }
 
 Remember that the passed-in set contains all touch objects associated with the receiving view that are new or changed for the given phase
 whereas the touch objects
 returned from touchesForView: includes all objects associated with the specified view.
 
 Hit-Testing
 
*********************
*** CORE ANIMATION **
*********************

Snippets:



CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];

anim.duration = DURATION;
anim.toValue = [ NSNumber numberWithInt:self.view.bounds.size.height / 8 ];
anim.fillMode = kCAFillModeBoth; anim.removedOnCompletion = NO;
anim.delegate = self;
[ self.view.layer.mask addAnimation:anim forKey:@"scale" ];



- (void)viewDidLoad 
{
	self.view.layer.contentsScale = [ [ UIScreen mainScreen ] scale ];
	
	self.view.layer.contents = (id)self.splashImage.CGImage; 

	self.view.contentMode = UIViewContentModeBottom;
	
	if( !self.transition )
	{
		self.transition = ClearFromRight;
	}
}
 
 


*********************
*** NOTIFICATIONS ***
*********************
 
 
***************
*** iCloud ***
***************
  
 iCloud App Design
 
 About Incorporating iCloud Into Your App
 
 The core idea behind iCloud is to eliminate explicit synchronization between devices.
 
 There is one important case for which Cocoa adopts iCloud for you. A document-based app for OS X v10.8 or later requires very little iCloud adoption
 work, thanks to the capabilities of the NSDocument class.
 
 Three Kinds of iCloud Storage iCloud supports three kinds of storage. To pick the right one (or combination) for your app, make sure you understand
 the intent and capabilities of each. The three kinds of iCloud storage are:
 
 Key-value storage for discrete values, such as preferences, settings, and simple app state.
 
 Document storage for user-visible file-based information such as word processing documents, drawings, and complex app state.
 
 Core Data storage for shoebox-style apps and server-based, multi-device database solutions for structured content. iCloud Core Data storage is built
 on document storage and employs the same iCloud APIs.
 
 In iOS, there is an exception to automatic iCloud data transfer. For the first-time download of an iCloud-based document in iOS, your app actively
 requests the document.
 
 To save data to iCloud, your app places the data in special file system locations known as ubiquity containers . A ubiquity container serves as the
 local representation of corresponding iCloud storage. It is outside of your app’s sandbox container
 
 The first ubiquity container identified in the iCloud Containers list is special in the following ways:
 
 ● It is your app’s primary ubiquity container, and, in OS X, it is the container whose contents are displayed in the NSDocument app-specific open and save dialogs.
 
 ● Its identifier string must be the bundle identifier for the current target, or the bundle identifier for another app of yours that was previously
 submitted for distribution in the App Store and whose entitlements use the same team ID.
 
 Container identifier strings must not contain any wildcard (‘*’) characters.
 
 The structure of a newly-created ubiquity container is minimal—having only a Documents subdirectory. You can write files and create subdirectories
 within the Documents subdirectory. You can create files or additional subdirectories in any directory you create. Perform all such operations using an
 NSFileManager object using file coordination.
 
 The Documents subdirectory is the public face of a ubiquity container. When a user examines the iCloud storage for your app (using Settings in iOS
 or System Preferences in OS X), files or file packages in the Documents subdirectory are listed and can be deleted individually. Files outside of the
 Documents subdirectory are treated as private to your app. If a user wants to delete anything outside of the Documents subdirectories of your ubiquity
 containers, they must delete everything outside of those subdirectories.
 
 To see the user’s view of iCloud storage, do the following, first ensuring that you have at least one iCloud-enabled app installed:
 
 In iOS, open Settings. Then navigate to iCloud > Storage & Backup > Manage Storage.
 
 In OS X, open System Preferences. Then choose the iCloud preference pane and click Manage.
 
 DO store the following in iCloud:
 
 User documents
 
 App-specific files containing user-created data
 
 Preferences and app state (using key-value storage, which does not count against a user’s iCloud storage allotment)
 
 Change log files for a SQLite database (a SQLite database’s store file must never be stored in iCloud)
 
 DO NOT store the following in iCloud:
 
 Cache files
 Temporary files
 App support files that your app creates and can recreate
 Large downloaded data files
 
 There may be times when a user wants to delete content from iCloud. Provide UI to help your users understand that deleting a document from iCloud removes it
 from the user’s iCloud account and from all of their iCloud-enabled devices. Provide users with the opportunity to confirm or cancel deletion.
 
 The System Manages Local iCloud Storage
 
 A user’s iCloud data lives on Apple’s iCloud servers, and a cache lives locally on each of the user’s devices.
 
 Your App Can Help Manage Local Storage in Some Cases
 
 Apps usually do not need to manage the local availability of iCloud files and should let the system handle eviction of files. There are two exceptions:
 
 If a user file is a) not currently needed and b) unlikely to be needed soon, you can help the system by explicitly evicting that file from the ubiquity
 container by calling the NSFileManager method evictUbiquitousItemAtURL:error:.
 
 Conversely, if you explicitly want to ensure that a file is available locally, you can initiate a download to a ubiquity container by calling the
 NSFileManager method startDownloadingUbiquitousItemAtURL:error:.
 
 Use iCloud exclusively or use local storage exclusively; in other words, do not attempt to mirror documents between your ubiquity container and your sandbox
 container. Never prompt the user again about whether they want to use iCloud vs. local storage, unless they delete and reinstall your app.
 
 Early in your app launch process—in the application:didFinishLaunchingWithOptions: method (iOS) or applicationDidFinishLaunching: method (OS X), check for
 iCloud availability by calling the NSFileManager method ubiquityIdentityToken
 
 The return value is a unique token representing the user’s currently active iCloud account. You can compare tokens to detect if the current account is
 different from the previously-used one, as explained in the next section. To enable comparisons, archive the newly-acquired token in the user defaults database.
 
 Although the ubiquityIdentityToken method tells you if a user is signed in to an iCloud account, it does not prepare iCloud for use by your app. In iOS,
 make your ubiquity containers available by calling the NSFileManager method URLForUbiquityContainerIdentifier: for each of your app’s ubiquity containers.
 
 There are circumstances when iCloud is not available to your app, such as if a user disables the Documents & Data feature or signs out of iCloud. If the
 current iCloud account becomes unavailable while your app is running or in the background, your app must be prepared to remove references to user iCloud
 files and to reset or refresh user interface elements that show data from those files.
 
 To handle changes in iCloud availability, implement a method to be invoked on receiving an NSUbiquityIdentityDidChangeNotification notification.
 Your method needs to perform the following work:
 
 1) Call the ubiquityIdentityToken method and store its return value.
 2) Compare the new value to the previous value, to find out if the user signed out of their account or signed in to a different account.
 3) If the previously-used account is now unavailable, save the current state locally as needed, empty your iCloud-related data caches,
 and refresh all iCloud-related user interface elements. If you want to allow users to continue creating content with iCloud unavailable,
 store that content in your app’s sandbox container. When the account is again available, move the new content to iCloud.
 It’s usually best to do this without notifying the user or requiring any interaction from the user.
 
 Actively Resolve Key-Value Conflicts
 
 The implementation of iCloud key-value storage makes conflicts unlikely, but you must design your app to handle them should they occur. This section
 describes a key-value conflict scenario and explains how to handle it.
 
 When your app’s state or configuration changes (such as, in this example, when the user reaches a new level in the game), first write the value to
 your user defaults database using the NSUserDefaults class. Then compare that local value to the value in key-value storage. If the values differ,
 your app needs to resolve the conflict by picking the appropriate winner.
 
 Essentially for stored values that can have different values, conflict resolution via a compare on the device at the time the remote data change is
 received is necessary. ICloud itself cannot resolve these kinds of conflicts - the device itself must resolve them by doing a compare,
 
 Exercise Care When Using NSData Objects as Values Using an NSData object lets you store arbitrary data as a single value in key-value storage. For
 example, in a game app, you can use it to upload complex game state to iCloud, as long as it fits within the 1 MB quota.
 
 Don’t Use Key-Value Storage in Certain Situations Every app submitted to the App Store or Mac App Store should adopt key-value storage, but some types
 of data are not appropriate for key-value storage. In a document-based app, for example, it is usually not appropriate to use key-value storage for state
 information about each document, such as current page or current selection. Instead, store document-specific state, as needed, with each document.
 
 Designing for Documents in iCloud
 
 
 
 
 
Documents in cloud
 
 Searching for Existing Documents in iCloud
 
 Searching for documents in iCloud is necessary because the list of documents can change while your app is not running. Documents can be created on
 different devices and the user can delete documents that are no longer needed. Your app uses a metadata query object to search for documents and
 detect changes to the document list.
 
 In your shipping apps, though, you should not include values for entitlements that your app does not use.
 
 You must specify the provisioning profile you created specifically for your app. You cannot use the generic Team Provisioning Profile to test iCloud apps.
 
 Before you attempt to use iCloud for the first time, you need to call the URLForUbiquityContainerIdentifier: method and give the system a chance to
 prepare your app for iCloud use. The first time you call this method, it modifies your app sandbox so that it can access its container directories.
 It also performs other checks to see if iCloud is actually available and configured on the current device. Because these checks can take some time,
 you should call it early in your app’s launch cycle so that it has time to complete before your app needs access to any files. If your app has access
 to multiple container directories, you must call the method separately for each one.
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ if ([[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] != nil) NSLog(@"iCloud is available\n");
 else NSLog(@"This tutorial requires iCloud, but it is not available.\n"); }); }
 
 Your own apps can use this early call of the URLForUbiquityContainerIdentifier: method to perform some app-specific tasks related to iCloud availability.
 For example, you might use the result to configure your app’s data structures differently. You might also use it to set configuration options for your
 user interface. Because this method might return its value either before or after your user interface is configured, you should not attempt to modify
 your interface directly from here. Instead, set a flag and notify the appropriate interface objects that the app configuration has changed. Those
 objects should then take appropriate action based on the value of the flag.
 
 Classes
 
 NSUbiquitousKeyValueStore
 
 Use the iCloud key-value store to make preference, configuration, and app-state data available to every instance of your app on every device connected to a
 user’s iCloud account. You can store scalar values such as BOOL, as well as values containing any of the property list object types: NSNumber, NSString,
 NSDate, NSData, NSArray, and NSDictionary. Changes your app writes to the key-value store object are initially held in memory, then written to disk by the
 system at appropriate times. The system automatically reconciles your local, on-disk keys and values with those on the iCloud server. Any device running
 your app, and attached to the same iCloud account, can upload key-value changes to iCloud.
 
 Obtain the keys and values from iCloud (which may be newer than those that are local) by calling the synchronize method. You need not call the synchronize
 method again during your app’s life cycle, unless your app design requires fast-as-possible upload to iCloud after you change a value.
 
 The total amount of space available in your app’s key-value store, for a given user, is 1 MB. The maximum length for key strings for the iCloud key-value
 store is 64 bytes using UTF8 encoding. Attempting to write a value to a longer key name results in a runtime error.
 
 -syncronize does not force new keys and values to be written to iCloud. Rather, it lets iCloud know that new keys and values are available to be uploaded.
 Do not rely on your keys and values being available on other devices immediately. The system controls when those keys and values are uploaded. The frequency
 of upload requests for key-value storage is limited to several per minute. During synchronization between memory and disk, this method updates your in-memory
 set of keys and values with changes previously received from iCloud.
 
 

 
 
///////////////
// Mac NOTES
///////////////
 
 * * * USB KEXT Notes * * *
 
 KEXT info.plist Keys
 
 OSBundleRequired – this tells IOKit if this driver is needed for early, boot time, driver matching. Set this to Local-Root if you need to load your KEXT at boot time.
 However, if you need to compete with OS provided drivers like USB Mass Storage Class or USB HID Class drivers, which a re loaded early in the the boot processes, set this to Root.
 IOKitPersonalities – this is a dictionary containing one or morematching dictionar ies for this KEXT. Each matching dic- tionary deﬁnes a different personality for the KEXT.
 It is pos- sible for a driver with multiple personalities to be instantiated more than once if several personalities match.
 Your driver can have more than one personality for a variety of reasons. It could be that the driver (as packaged in the KEXT) supports more than one type of device,
 or multiple versions of the same type of device, or you have multiple drivers packaged in the KEXT.
 that are used by I/O Kit for driver matching. Some are com- mon to all personalities (like CFBundleIdentifier, IOClass, and IOProviderClass), others are deﬁned by a family.
 The IOUSB- Family deﬁnes the keys found in IOKitPersonalities dictionaries for USB drivers. IOUSBFamily passive matching crite- ria is from the USB Common Class Speciﬁcation
 section 3.10. Add the ﬁelds from the speciﬁcation(e.g., idProduct, and idDevice) to the personality. War ning: Follow the speciﬁcation to the letter.
 If you add one extra key-value pair more than speciﬁed, the matching dictionary will fail!
 
 IOClass – a matching dictionary key. The name of the C++ driver class I/O Kit will instantiate for probing. IOProviderClass – a matching dictionary key.
 This key iden- tiﬁes the name of the nub class that this personality matches to. For USB drivers the IOProviderClass will be IOUSBDevice or IOUSBInterface.
 IOKitDebug – an optional key used to turn on I/O Kit debug- ging. This key makes I/O Kit dump additional data to the system.log. This can be helpful when debugging drivers.
 This is especially helpful when you are having difﬁculty get- ting your driver to load (most likely a matching problem).
 
 Code Listing 2 – Info.plist for the Cypress USB Storage driver. 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 <key>IOKitPersonalities</key>
 <dict> <!-- Each personality has a different name. --> <key>FX</key> <dict> <!-- The name of the bundle the IOClass will be called from.
 Usually, this will be the same -- as the CFBundleIdentifier for this KEXT but it doesn’t have to be. --> <key>CFBundleIdentifier</key> <string>com.cy.iokit.Morpheus</string>
 <!-- The name of the class IOKit will instantiate when probing. -- for each of three example matching dictionaries. --> <key>IOClass</key> <string>com_isd_driver_CYMSC_Device</string>
 <!-- IOKit matching properties -- All drivers must include the IOProviderClass key, giving -- the name of the nub class that they attach to.
 The provider -- class then determines the remaining match keys. A personality -- matches if all match keys do; it is possible for a driver -- with multiple personalities to be instantiated more than once -- if several personalities match. -->
 <key>IOProviderClass</key> <string>IOUSBInterface</string> <!-- IOUSBFamily passive matching criteria. -- This personality matches on IOUSBInterface so the following key-value pairs identify that -- interface. -->
 <key>bConfigurationValue</key> <integer>1</integer> <key>bInterfaceNumber</key> <integer>0</integer> <key>idProduct</key> Notice this class is different
 
 <integer>10256</integer> <key>idVendor</key> <integer>1351</integer> </dict> <key>ISD105-GNS</key> <dict> <key>CFBundleIdentifier</key> <string>com.cy.iokit.Morpheus</string> <key>IOClass</key>
 <string>com_isd_driver_USS725_Device</string> <!-- IOKit matching properties -- This personality will match on an IOUSBDevice object. --> <key>IOProviderClass</key> <string>IOUSBDevice</string>
 <!-- IOUSBFamily passive matching criteria. -- idProduct and idVendor identify this driver as a USB device driver. --> <key>idProduct</key> <integer>513</integer> <key>idVendor</key>
 <integer>1451</integer> </dict> <key>ISD200-MSC ATAPI</key> <dict> <key>CFBundleIdentifier</key> <string>com.cy.iokit.Morpheus</string> <key>IOClass</key> <string>com_isd_driver_ISDMSC_Device</string>
 <key>IOKitDebug</key> <integer>65535</integer> <key>IOProviderClass</key> <string>IOUSBDevice</string> <key>idProduct</key> <integer>48</integer> <key>idVendor</key> <integer>1451</integer>
 </dict> <!-- ... some dictionaries not shown ... --> </dict>
 
 The IOService object controls the startup sequence of the driver life cycle. Since all objects in I/O Kit inherit from IOSer- vice it’s important to understand the steps that occur.
 During the startup sequence there are two tasks that occur – driver matching and driver startup. A developer can overr ide any of these methods, so is important to
 know the order methods are called and their function.
 Driver matching • • • init – called by I/O Kit when KMOD is loaded into memory. – called by the provider to temporarily attach the KEXT to it in the I/O Registry.
 attach probe – called by I/O Kit to determine if KEXT supports the device.
 probe passed or failed. The driver needs to be aware that this will occur. detach free – • • • called if probe fails. Driver startup – called if you pass the probe method.
 The KEXT is put into the I/O Registry. attach – called to do one time initialization and perform I/O with the device to complete the matching process.
 
 IOUSBFamily Workloop
 
 The workloop is one of the most misunderstood technologies to kernel driver developers. Ever y driver has to work on the wor kloop. There is one workloop for every
 interrupt source (one per IOUSBController – most Macs have two USB control- lers). Ever y member of the USBFamily that is attached to a particular controller and every
 driver for a USB device at- tached to that USB controller, participates on the same work-loop
 The workloop is a ser ialization mechanism for I/O calls. What this means to developers is that your driver has to be careful about kind of calls it makes. For example,
 a synchronous call to USB from an asynchro- nous callback routine will deadlock the system. In order for the synchronous call to complete, an interrupt has to come in on
 a different thread but that interrupt is not able to execute on the workloop because the workloop is locked by your driv- er’s callback routine. Thus, a deadlock occurs.
 A kernel driver developer needs to be ver y aware of the execution context when developing drivers. There are two mechanisms that are useful in working with workloop execution contexts.
 The getWorkloop method re- turns the USB controller’s Workloop. This is useful when you want to do work on the Workloop. And if you want to do work outside of the Wor kloop you can use the
 thread_call mechanism.
 Writing a driver using I/O Kit Inheritance Driver inheritance in I/O Kit has confused a lot of developers being exposed to I/O Kit for the ﬁrst time. At ﬁrst it may seem
 logical that a USB driver would inherit from classes in the IOUSBFamily, but this is not the case. USB drivers are not members of and do not inherit from the IOUSBFamily.
 They use the IOUSBFamily for their transport mechanism and are thus clients of the USB family classes. Let’s look at some examples. The AppleUSBAudioDevice class is a subclass
 of the IOAudioDe- vice which is a subclass of IOService. IOService being the base class for all I/O Kit objects. So this driver is a member of the Audio Family.
 Client AppleUSBAudioDevice <- IOAudioDevice <- IOService IOUSBInterface (provider)
 The IOUSBHIDDriver class is a subclass of the IOHIDDevice which is a subclass of IOService. IOService being the base class for all I/O Kit objects. So this driver is a member
 of the HID Family. The fact that this driver is bundled with the IOUS- BFamily only serves to confuse us. IOHIDSystem (client) IOUSBHIDDriver <- IOHIDDevice <- IOService IOUSBInterface (provider)
 
 Code-less Kernel Extension Examples
 
 Code-less kernel extensions are kernel extensions that have no code, only an Info.plist. A code-less kernel extension will provide a personality that I/O Kit will match to the USB
 device but the personality will point to another ker nel extention. The following examples are not only nifty tricks for solving the problems presented, but they also provide additional
 insight in to the way driver matching works on Mac OS X.
 Vendor-Speciﬁc Composite Device <key>IOKitPersonalities</key> <dict> <key>V-S Composite driver</key> <dict> <key>CFBundleIdentifier</key> <string>com.apple.driver.AppleUSBCompos- ite</string>
 <key>IOClass</key> <string>AppleUSBComposite</string> <key>IOProviderClass</key> <string>IOUSBDevice</string> <key>idProduct</key> <integer>10256</integer> <key>idVendor</key> <integer>1351</integer> </dict> </dict>
 
 USB User Space Driver Development
 
 The UserClient and the DeviceInterface objects always come in pairs to bridge the kernel boundary. The IOUSBFamily provides two UserClient classes: IOUSBInterfaceUserClient and IOUSBDeviceUserCient.
 These two classes allow us- er-space drivers to communicate with the three main kernel objects: IOUSBPipe, IOUSBInterface and IOUSBDevice.
 User-space drivers do not compete in the matching process at the same time as kernel-space drivers. In some cases a code-less kernel extension may have to be used to claim the device.
 The I/O Kit model and the IOUSBFamily force exclusive access to devices. However, there is a protocol for user-space and kernel-space drivers to communicate a desire to share a device.
 Drivers need to add support for the following messag- es in order to play nice together. - kIOMessageServiceIsRequestingClose – is received when an- other entity is requesting access to a device.
 - kIOMessageServiceIsAttemptingOpen – is received when an- other entity has attempted to open a device. It’s a clue that someone else would like to use the device and a driver should close
 down access to the device if possible. A driver can also register for I/O Kit notiﬁcation when a driver has closed its access to the device. The notiﬁcation set to the driver will be the message: - kIOMessageServiceWasClosed
 Blocking I/O for User Space drivers There are many USB APIs that can "block" until the USB transaction completes. Using blocking I/O can simplify driver designs. Synchronous calls from
 user-space drivers are something that is always safe to do. You make a synchronous call, your thread blocks, and when the call completes, your thread picks up again. Graphical user
 interface applications that directly access USB devices should create a separate thread for controlling the USB device from the thread(s) controlling the user inter- face. Otherwise,
 the user interface will feel sluggish or may appear to the user to hang.
 
 In user space you don’t really have to be worried about the issues with synchronous versus asynchronous I/O, as is the case with ker nel drivers. Because user space threads are never
 running on the workloop, deadlocks are not possible. However, if your driver design lends it’s self better to doing asynchronous I/O, callbacks to user space are possible.
 
 
* * * Apress Kernel Development Book Summary * * *
 
 The Mach time KPI consists of three functions: void clock_get_uptime(uint64_t* result); void clock_get_system_nanotime(uint32_t* secs, uint32_t* nanosecs);
 void clock_get_calendar_nanotime(uint32_t* secs, uint32_t* nanosecs);
 Device Pager: Used for managing memory mappings of hardware devices, such as PCI devices that map registers into memory. Mapped memory is commonly used by I/O Kit drivers,
 and I/O Kit provides abstractions for working with such memory.
 
 Memory Allocation in Mach
 Some fundamental routines for memory allocation in Mach are: kern_return_t kmem_alloc(vm_map_t map, vm_offset_t *addrp, vm_size_t size);
 kern_return_t kmem_alloc_contig(vm_map_t map, vm_offset_t *addrp, vm_size_t size, vm_offset_t mask, int flags); void kmem_free(vm_map_t map, vm_offset_t addr, vm_size_t size);
 kmem_alloc() provides the main interface to obtaining memory in Mach. In order to allocate memory, you must provide a VM map.
 For most work within the kernel, kernel_map is defined and points to the VM map of kernel_task. The second variant, kmem_alloc_contig(), attempts to allocate memory that is
 physically contiguous, as opposed to the former, which allocates virtually contiguous memory. Apple recommends against making this type of allocation, as there is a significant
 penalty incurred in searching for free contiguous blocks. Mach also provides kmem_alloc_aligned() function, which allocates memory aligned to a power of two, as well as a few
 other variants that are less commonly used. The kmem_free() function is provided to free allocated memory. You have to take care to pass the same VM map as you used when you
 allocated, as well as the size of the original allocation.
 
 Available system calls are defined in /usr/include/sys/syscall.h
 
 The I/O Kit is based around three major concepts: • • • Families Drivers Nubs Families represent common abstractions for devices of a particular type. For example, an IOUSBFamily
 handles many of the technicalities of implementing support for USB related devices.
 Drivers are responsible for managing a specific device or bus. A driver may have a relationship with more than one family. In the case of a USB-based storage device, it might
 depend on the IOUSBFamily, as well as the IOStorageFamily. Nubs are interfaces for a controllable entity, such as a PCI or USB device, which a higher-level driver may use to
 communicate with the device.
 The Libkern Library The libkern library, unlike Mach and BSD, which provide APIs for interacting with the system, provides supporting routines and classes to the rest of the
 kernel, and in particular the I/O Kit. That is, building blocks and utilities useful to the kernel itself, as well as extensions. The limited C++ runtime is implemented in libkern,
 which provides implementation for services such as the new and delete operators. In addition to standard C++ runtime, libkern also provides a number of useful classes, the most
 fundamental being OSObject, the superclass of every class in I/O Kit. It provides support for reference counting, which works conceptually the same as NSObject in Cocoa, or Cocoa Touch
 in user space. Other classes of interest include OSDictionary, OSArray, OSString, and OSInteger. These classes, and others, are also used to provide a dictionary of values from the
 kernel extension’s Info.plist. The libkern library is not all about core C++ classes and runtime, as it also provides the implementation of many functions normally found in the
 standard C library. Examples of this are the printf() and sccanf() functions, as well as others such as strtol() and strsep(). Other functions provided by libkern include cryptographic
 hash algorithms (MD5 and SHA-1), UUID generation, and the zlib compression library. The library is also home to kxld, the library used to manage dynamically loaded kernel extensions.
 Last, but not least, we find functions, such as OSMalloc(), for allocating memory and for the implementation of locking mechanisms and synchronization primitives.
 The platform expert is responsible for the initial construction of the I/O Kit device tree after the system boots (known as the I/O Registry). The platform expert itself
 will form the root node of the tree, IOPlatformExpertDevice.
 
 
 
 
 
 
 

 
 
 
 
 
 
 
 

 
 
 
 
 
 
 
 
 
 
 
 
*/