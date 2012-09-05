#import <CoreFoundation/CoreFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

////////////
// C protos
////////////

#ifdef __cplusplus
extern "C" {
#endif

#ifdef TARGET_OS_MAC

#if TARGET_OS_IPHONE == 0

CGFloat DockHeight( void );

CGFloat ScreenHeight( NSScreen *screen );

#endif

#endif

#ifdef __cplusplus
}
#endif
