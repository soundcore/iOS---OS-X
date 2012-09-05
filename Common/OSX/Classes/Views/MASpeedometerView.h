#import <Cocoa/Cocoa.h>

// Defines

#define kSpeedometerBackingImageFileName @"speed_backing.png"

// Classes

@interface MASpeedometerView : NSView
{
	NSImage		*dialImage;
	CALayer		*needleLayer;
	double		needleAngle;
	double		lastSpeed;
	double		currentSpeed;
}

// Init & Term (Required Overrides)

- (id)init;

- (id)initWithFrame:(NSRect)frame;

- (void)dealloc;

- (void)awakeFromNib;

// Getters

- (NSImage*)dialImage;

- (CALayer*)needleLayer;

- (double)needleAngle;

- (double)lastSpeed;

- (double)currentSpeed;

// Setters

- (void)setDialImage:(NSImage*)newImage;

- (void)setNeedleLayer:(CALayer*)newLayer;

- (void)setNeedleAngle:(double)newAngle;

- (void)setLastSpeed:(double)newLastSpeed;

- (void)setCurrentSpeed:(double)newCurrentSpeed;

@end


