#ifndef __OBJC__
#pragma once
#endif

////////////////////////////////
// Defines
////////////////////////////////

#ifdef __OBJC__
#define kNSApplicationBundleIdentifier		@"NSApplicationBundleIdentifier"
#endif

/////////////
// Protos
/////////////

BOOL			DockIsRunning( void );

BOOL			FinderIsRunning( void );

BOOL			ProcessIsRunningBySignature( OSType sig, ProcessSerialNumber *outPSN );

// C wrapper protos for ProcessUtils.m - For C/C++ includes

BOOL			ProcessIsRunningByBundleID( CFStringRef bundleIDStringRef, ProcessSerialNumber *outPSN, unsigned *numRunning );

////////////////////////////////
// Classes
////////////////////////////////

@interface ProcessUtils : NSObject
{
}

// Init & term

- (id)init;

- (void)dealloc;

- (NSString*)description;

// General process utils

- (BOOL)processIsRunningByBundleID:(NSString*)bundleIDString andGetPSN:(ProcessSerialNumber*)outPSN andNumberRunning:(unsigned*)numRunning;

@end
