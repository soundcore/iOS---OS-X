#import <cb.h>

#import "NSMenu+NSMenuAdditions.h"

@implementation NSMenu (PopUpRegularMenuAdditions)

+ (void)popUpMenu:(NSMenu*)menu forView:(NSView*)view pullsDown:(BOOL)pullsDown
{
    NSMenu				*popMenu = nil;
    NSRect				frame = kJustInitCGRectWithZeros;
    NSPopUpButtonCell	*popUpButtonCell = nil;
	
	if( menu && view )
	{
		popMenu = [ [ menu copy ] autorelease ];
	
		frame = [ view frame ];
		frame.origin.x = 0.0;
		frame.origin.y = 0.0;

		if( pullsDown )
		{
			[ popMenu insertItemWithTitle:kEmptyStringKey action:NULL keyEquivalent:kEmptyStringKey atIndex:0 ];
		}
		
		popUpButtonCell = [ [ [ NSPopUpButtonCell alloc ] initTextCell:kEmptyStringKey pullsDown:pullsDown ] autorelease ];
	   
		[ popUpButtonCell setMenu:popMenu ];
		
		if( !pullsDown )
		{
			[ popUpButtonCell selectItem:nil ];
		}
		
		[ popUpButtonCell performClickWithFrame:frame inView:view ];
	}
}

@end
