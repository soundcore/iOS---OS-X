/****************************************************************************

File:			NSObject+NSObjectAdditions.h

Date:			5/20/11

Version:		1.0

Authors:		soundcore

				Copyright 2011 soundcore. All rights reserved worldwide.

Notes:			Header for NSObject+NSObjectAdditions.m

				Some methods derived from Julian Mayer's SMARTReporter code.
 
				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE BE REDISTRIBUTED
				WITHOUT EXPRESS WRITTEN PERMISSION OF soundcore. ANY
				SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL PENALTIES
				AND IS A VIOLATION OF INTERNATIONAL COPYRIGHT LAW. VIOLATORS
				WILL BE PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	Cocoa/Foundation.

Changes:		5/20/11 MCA Initial version.

******************************************************************************/

#if TARGET_OS_IPHONE == 1
	#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC == 1
	#import <Cocoa/Cocoa.h>
#endif

////////////
// Classes
////////////

@interface NSObject ( NSObjectAdditions )

////////////
// Utils
////////////

+ (NSString*)bsdPathForVolume:(NSString*)volume;

+ (NSString*)ipAddress:(bool)ipv6;

+ (NSString*)ipName;

+ (NSString*)macAddress;

+ (NSString*)machineType;

+ (NSString*)nameForDevice:(NSInteger)deviceNumber;

// Bundle

- (NSArray*)allMainBundleLocalizations;

- (BOOL)mainBundleIsOnLockedVolume;

- (NSString*)preferredLocalization;

- (NSString*)preferredLocalizationCurrentLprojFolderFullPath;

// File

- (BOOL)addExtendedAttribute:(NSString*)attributeString toItemAtURL:(NSURL*)URL;

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL;
	
// Power

+ (BOOL)hasBattery;

+ (BOOL)runsOnBattery;

@end

////////////
// C Protos
////////////

#ifdef __cplusplus
extern "C" {
#endif
	
#if TARGET_OS_IPHONE == 0
	
kern_return_t	FindEthernetInterfaces( io_iterator_t *matchingServices );
	
kern_return_t	GetMACAddress( io_iterator_t intfIterator, UInt8 *MACAddress );
	
CFStringRef		IOPSGetProvidingPowerSourceType( CFTypeRef ps_blob );

CFBooleanRef	IOPSPowerSourceSupported( CFTypeRef ps_blob, CFStringRef ps_type );

#endif
	
#ifdef __cplusplus
}
#endif
