#import <Cocoa/Cocoa.h>

// Defines

#define kStandardMAGradientViewAngle	(CGFloat)270.0

// Classes

@interface MAGradientView : NSView
{
	NSColor								*startingColor;
	NSColor								*endingColor;
	int									angle;
}

// Define the variables as properties

@property (nonatomic, retain) NSColor	*startingColor;
@property (nonatomic, retain) NSColor	*endingColor;
@property (nonatomic) int				angle;

// Init & Term (Required Overrides)

- (id)init;

- (id)initWithFrame:(NSRect)frame;

- (void)dealloc;

- (void)awakeFromNib;

@end


