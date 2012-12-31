// NSColor+NSColorAdditions

#import "NSColor+NSColorAdditions.h"

@implementation NSColor (NSColorAdditions)

- (CGColorRef)cgColorRef
{
	NSInteger			numberOfComponents = [ self numberOfComponents ];
    CGFloat				components[ numberOfComponents ];
    CGColorSpaceRef		colorSpace = nil;
	CGColorRef			outColor = NULL;
	
	colorSpace = [ [ self colorSpace ] CGColorSpace ];
	if( colorSpace )
	{
		[ self getComponents:(CGFloat*)&components ];

		outColor = CGColorCreate( colorSpace, components );
	}
	
	return outColor;
}

@end