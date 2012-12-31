// UNIX stuff

#import <arpa/inet.h>
#import <asl.h>
#import <assert.h>
#import <ctype.h>
#import <dirent.h>
#import <err.h>
#import <errno.h>
#import <fcntl.h>
#import <getopt.h>
#import <ifaddrs.h>
#import <mach/boolean.h>
#import <mach/mach.h>
#import <mach/mach_error.h>
#import <mach/mach_interface.h>
#import <mach/mach_init.h>
#import <mach/mach_port.h>
#import <machine/limits.h>
#import <net/if.h>
#import <netdb.h>
#import <netinet/in.h>
#import <notify.h>
#import <paths.h>
#import <stdint.h>
#import <stdlib.h>
#import <stdio.h>
#import <stdbool.h>
#import <signal.h>
#import <string.h>
#import <strings.h>
#import <sys/appleapiopts.h>
#import <sys/attr.h>
#import <sys/cdefs.h>
#import <sys/ioctl.h>
#import <sys/kauth.h>
#import <sys/param.h>
#import <sys/mman.h>
#import <sys/mount.h>
#import <sys/socket.h>
#import <sys/ioctl.h>
#import <sys/socket.h>
#import <sys/stat.h>
#import <sys/statvfs.h>
#import <sys/syscall.h>
#import <sys/sysctl.h>
#import <sys/event.h>
#import <sys/time.h>
#import <sys/types.h>
#import <sys/ucred.h>
#import <sys/vm.h>
#import <sys/xattr.h>
#import <time.h>
#import <unistd.h>
#import <uuid/uuid.h>

#import <Availability.h>
#import <TargetConditionals.h>

#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SCDynamicStore.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <SystemConfiguration/SystemConfiguration.h>

#ifdef __OBJC__
	#import <AVFoundation/AVFoundation.h>
	#import <AVFoundation/AVVideoComposition.h>
	#import <Foundation/Foundation.h>
	#import <dispatch/dispatch.h>
	#import <MediaPlayer/MPMoviePlayerViewController.h>
	#import <MobileCoreServices/MobileCoreServices.h>
	#import <UIKit/UIKit.h>
#endif

// Our stuff

#import <cb.h>

/////////////
// Defines
/////////////

#define kiOSVersionThreeTwoDouble								3.199			// iOS 3.2
#define kiOSVersionFourDouble									3.9				// iOS 4.0
#define kiOSVersionFourOneDouble								4.099			// iOS 4.1
#define kiOSVersionFourTwoDouble								4.19			// iOS 4.2
#define kiOSVersionFiveDouble									5.0				// iOS 5.0
#define kiOSVersionFiveOneDouble								5.1				// iOS 5.1
#define kiOSVersionSixDouble									6.0				// iOS 6.0

#define kVisualEffectsSpeedCoeficient							1.0				// 1.0 for release.

// Standard segmented control for maps apps

#define kClassicSeg												0
#define kSatelliteSeg											1
#define kHybridSeg												2

// Standard text shadows

#define kTextShadowOffsetHeight									(CGFloat)1.0
#define kTextShadowOffset										CGSizeMake( kFloatZero, kTextShadowOffsetHeight )
#define kTextShadowRadius										(CGFloat)0.3
#define kWhiteShadowColor										[ [ UIColor whiteColor ] CGColor ]
#define kBlackShadowColor										[ [ UIColor blackColor ] CGColor ]
