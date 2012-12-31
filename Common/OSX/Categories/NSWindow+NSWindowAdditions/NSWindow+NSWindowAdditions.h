#import <Cocoa/Cocoa.h>
#import <CoreFoundation/CoreFoundation.h>
#import <QuartzCore/QuartzCore.h>

// Defines

#define kWindowTitlePlaceholderChar			@"#"
#define kPerfectDisplayInsetInPixels		(CGFloat)3.0

// General

#define kGloominputEV						-.05
#define kGloominputSaturation				0.15	
#define kGloominputIntensity				0.05
#define kGloominputBlur						2.0	

// Categories

@interface NSWindow ( NSWindowAdditions )

// Utils

- (void)bestDefaultWindowSizeAndPositionForMainScreenAndCenter:(BOOL)centerIt;

- (void)gloomWindow:(NSNumber*)gloomIt windowsBlankingView:(NSView*)bView;

- (BOOL)isOnMainScreen;

- (BOOL)isOnScreen:(NSScreen*)screen;

- (void)makeKeyAndOrderFrontWithFadeIn:(id)sender;

- (void)moveWindowToUpperLeftScreenCorner:(NSScreen*)screen;

- (void)moveWindowToUpperRightScreenCorner:(NSScreen*)screen;

- (void)offsetWindowByY:(NSUInteger)y andX:(NSUInteger)x animate:(BOOL)anim;

- (NSPoint)perfectUpperLeftWindowScreenPointForScreen:(NSScreen*)screen;

- (void)replaceWindowTitlePlaceholderCharsWithLocalizedString:(NSString*)stringKey;

- (void)restoreLastSavedWindowPositionForDefaultsKeyOrCenter:(NSString*)defaultsStringKey fromRect:(NSRect)startingZoomRect compensateForDockHeight:(BOOL)compensate;

- (float)titleBarHeight;

- (void)zoomToMaxBestFitSizeForMainScreen;

@end

////////////
// C protos
////////////

#ifdef __cplusplus
extern "C" {
#endif

void CenterWindowOnScreen( NSWindow *window, NSScreen *screen, BOOL compensateForDockHeight );

#ifdef __cplusplus
}
#endif
