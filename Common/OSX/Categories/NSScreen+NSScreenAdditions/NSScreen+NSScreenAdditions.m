#import <cb.h>

#import "NSScreen+NSScreenAdditions.h"

@implementation NSScreen ( NSScreenAdditions )

/////////////////////////////////
// Return deepest screen's rect.
/////////////////////////////////

+ (NSRect)deepestScreenFrame
{
	NSRect	theRect = kJustInitCGRectWithZeros;
	
	theRect = [ [ NSScreen deepestScreen ] frame ];
	
	return theRect;
}

///////////////////////////////
// Return main screen's rect.
///////////////////////////////

+ (NSRect)mainScreenFrame
{
	NSRect	theRect = kJustInitCGRectWithZeros;
	
	theRect = [ [ NSScreen mainScreen ] frame ];
	
	return theRect;
}

@end
