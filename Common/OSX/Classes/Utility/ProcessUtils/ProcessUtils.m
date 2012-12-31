#import <NSString+NSStringAdditions.h>

#import "ProcessUtils.h"

@implementation ProcessUtils

#pragma mark-
#pragma mark Init & Term
#pragma mark-

////////////////////
// - init
////////////////////

- (id)init
{
	if( ( self = [ super init ] ) )
	{
	}
	
	return self;
}

////////////////////
// - dealloc
////////////////////

- (void)dealloc
{
	[ super dealloc ];
}

////////////////
// Description
////////////////

- (NSString*)description
{
	return [ NSString stringWithString:NSStringFromClass( [ self class ] ) ];
}

#pragma mark-
#pragma mark General process utils
#pragma mark-

//////////////////////////////////////////////////////////////////////////////
// Returns whether a given process is running or not. If it is running,
// on output, outPSN is the PSN of the running process. If not, outPSN
// will be undefined. The 'bundleIDStringRef' parameter identifies the app
// which you want to check for. If you want to see if an app is running by
// signature, use ProcessIsRunningBySignature instead. Note that as with most
// Cocoa objects, you can pass a CFStringRef from C code instead of an
// NSString for the bundleIDStringRef parameter. If a matching running
// process i found, return true, and return it's PSN in outPSN, else return
// false. We also return the number of running instances in numRunning. If
// numRunning > 1, outPSN is the PSN of the last instance in the process
// list.
//////////////////////////////////////////////////////////////////////////////

- (BOOL)processIsRunningByBundleID:(NSString*)bundleIDString andGetPSN:(ProcessSerialNumber*)outPSN andNumberRunning:(unsigned*)numRunning
{
	BOOL						aResult = NO;
	NSUInteger					ii = 0;
	NSUInteger					count = 0;
	NSWorkspace					*space = nil;
	NSArray						*array = nil;
	NSDictionary				*launchedAppDict = nil;
	NSString					*entryID = nil;
	
	UInt32						psnHighNum = 0;
	UInt32						psnLowNum = 0;
	NSString					*psnHigh = nil;
	NSString					*psnLow = nil;
	ProcessSerialNumber			foundPSN;
	
	memset( &foundPSN, 0, sizeof( foundPSN ) );
	
	if( bundleIDString && outPSN )
	{
		memset( outPSN, 0, sizeof( *outPSN ) );
		
		*numRunning = 0;
		
		// Get default workspace...
						
		space = [ NSWorkspace sharedWorkspace ];
		if( space )
		{
			// Get array of running apps...
			
			array = [ space launchedApplications ];
			if( array )
			{
				count = [ array count ];
				
				// Pull each app out of array so we can inspect it...
				
				for( ii = 0; ii < count; ii++ )
				{
					launchedAppDict = [ array objectAtIndex:ii ];
					if( launchedAppDict )
					{
						// Get the 'NSApplicationBundleIdentifier' key for this entry...
						
						entryID = [ launchedAppDict valueForKey:kNSApplicationBundleIdentifier ];
						if( entryID )
						{
							// See if it matches the one passed in...
							
							if( [ entryID isEqualToString:bundleIDString ] )
							{
								psnHigh = [ launchedAppDict valueForKey:kNSApplicationProcessSerialNumberHighKey ];
								
								psnLow = [ launchedAppDict valueForKey:NSApplicationProcessSerialNumberLowKey ];
								
								if( psnHigh && psnLow )
								{
									// Make numbers...
									
									psnHighNum = (UInt32)[ psnHigh intValue ];
									
									psnLowNum = (UInt32)[ psnLow intValue ];
									
									foundPSN.highLongOfPSN = psnHighNum;
									
									foundPSN.lowLongOfPSN = psnLowNum;
									
									// Copy PSN to output...
									
									memcpy( outPSN, &foundPSN, sizeof( ProcessSerialNumber ) );
								}
								
								// Increment number of copies of this app running...
								
								*numRunning += 1;
								
								// We have a match so bust out 'the loop...
								
								aResult = YES;
							}
						}
					}
				}
			}
		}
	}
	
	return aResult;
}

@end

#pragma mark-
#pragma mark By App
#pragma mark-

////////////////////////////////////////////////
// Return whether the Dock is running or not
////////////////////////////////////////////////

BOOL DockIsRunning( void )
{
	BOOL					running = false;
	ProcessSerialNumber		psn;
	
	memset( &psn, 0, sizeof( psn ) );
	
	running = (BOOL)ProcessIsRunningBySignature( kDockCreatorString, &psn );
	if( running  )
	{
		running = true;
	}
	
	return running;
}

////////////////////////////////////////////////
// Return whether the Finder is running or not
////////////////////////////////////////////////

BOOL FinderIsRunning( void )
{
	BOOL					running = false;
	ProcessSerialNumber		psn;
	
	memset( &psn, 0, sizeof( psn ) );
	
	running = (BOOL)ProcessIsRunningBySignature( kCarbonFinderCreatorOSType, &psn );
	if( running  )
	{
		running = true;
	}
	
	return running;
}

#pragma mark-
#pragma mark By Signature
#pragma mark-

//////////////////////////////////////////////////////////////////////////////
// Returns whether a given process is running or not. If it is running,
// on output, outPSN is the PSN of the running process. If not, outPSN
// will be undefined. The 'sig' parameter identifies the app which you want
// to check for. If you want to see if an app is running by bundle ID,
// use ProcessIsRunningByBundleID instead.
//////////////////////////////////////////////////////////////////////////////

BOOL ProcessIsRunningBySignature( OSType sig, ProcessSerialNumber *outPSN )
{
	BOOL						found = false;
	ProcessSerialNumber			inProcess;
	ProcessInfoRec				info;
	OSStatus					err2 = noErr;
	OSStatus					err = noErr;
	
	memset( &inProcess, 0, sizeof( inProcess ) );
	
	memset( &info, 0, sizeof( info ) );
	
	if( outPSN )
	{
		memset( outPSN, 0, sizeof( *outPSN ) );
		
		while( !err2 )
		{
			// Loop all running processes...
			
			err2 = GetNextProcess( &inProcess );
			if( err2 == noErr )
			{
				memset( &info, 0 ,sizeof( info ) );
		
				// Get next proc...
				
				err = GetProcessInformation( &inProcess, &info );
				if( info.processSignature == sig )
				{
					// This one is the requested process!!!
					
					(void)memmove( outPSN, &inProcess, sizeof( *outPSN ) );
					
					found = true;
				
					break;
				}
			}
		}
	}
	
	return found;
}

#pragma mark-
#pragma mark C Wrappers
#pragma mark-

/////////////////////////////////////////////////////////////////////////////////////////////
// We use this to transmorgify the results of
// -processIsRunningByBundleID:(NSString*)bundleIDStringRef (ProcessSerialNumber*)outPSN
// into C-callable form. This is so C/C++ apps can use our Cocoa method.
/////////////////////////////////////////////////////////////////////////////////////////////

BOOL ProcessIsRunningByBundleID( CFStringRef bundleIDStringRef, ProcessSerialNumber *outPSN, unsigned *numRunning )
{
	BOOL			procIsRunning = NO;
	ProcessUtils	*utils = nil;
	
	if( bundleIDStringRef && outPSN && numRunning )
	{
		// Make utils...
		
		utils = [ [ ProcessUtils alloc ] init ];
		if( utils )
		{
			procIsRunning = [ utils processIsRunningByBundleID:(NSString*)bundleIDStringRef andGetPSN:(ProcessSerialNumber*)outPSN andNumberRunning:numRunning ];
			
			// Clean up...
			
			[ utils release ];
		}
	}
	
	return procIsRunning;
}
