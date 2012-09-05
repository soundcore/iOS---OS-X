
#import <CoreFoundation/CoreFoundation.h>
#import <Cocoa/Cocoa.h>

// Categories

@interface NSScreen ( NSScreenAdditions )

// Utils

+ (NSRect)deepestScreenFrame;

+ (NSRect)mainScreenFrame;

@end
