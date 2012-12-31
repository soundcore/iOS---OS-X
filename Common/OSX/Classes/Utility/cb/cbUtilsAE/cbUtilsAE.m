/***************************************************************************************

File:			cbUtilsAE.m

Date:			5/5/09

Version:		1.0

Authors:		soundcore

				Copyright 2009 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Cocoa AE utils.
				
				Set tab width and indent width both to 4 In Project Builder's
				or XCode's Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF CODE BEAUTY, LLC

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

***************************************************************************************/

#import <Carbon/Carbon.h>

#import <cb.h>
#import <cbUtilsAE.h>

@implementation cbAEUtils

#pragma mark ------------
#pragma mark Init & term
#pragma mark ------------

- (id)init
{
	if( ( self = [ super init ] ) )
	{
	}
	
	return self;
}

- (void)dealloc
{
	[ super dealloc ];
}

////////////////
// Description
////////////////

- (NSString*)description
{
	NSString	*desc = nil;
	
	desc = [ NSString stringWithString:@"cbAEUtils" ];
	
	return desc;
}

#pragma mark ----------
#pragma mark AE Utils
#pragma mark ----------

///////////////////////////////////////////////////////////////////////
// Send the Finder a 'kResync' AE to force it to update its windows
// and custom icons there were set programatically. The AliasHandle
// passed in should point to the item which you want updated.
///////////////////////////////////////////////////////////////////////

- (BOOL)sendFinderResyncEvent:(AliasHandle)aliasH
{
	BOOL					result = NO;
	unsigned				i = 0;
	ProcessInfoRec			processInfo;
	AppleEvent				appleEvent = { typeNull, NULL };
	AppleEvent				aeReply = { typeNull, NULL };
	AEDesc					aeDesc = { typeNull, NULL };
	ProcessSerialNumber		psn = { kNoProcess, kNoProcess };
	OSStatus				err[ 16 ] = { noErr };
	OSStatus				err2 = noErr;
	
	memset( &processInfo, 0, sizeof( processInfo ) );
	
	if( aliasH )
	{
		processInfo.processInfoLength = sizeof( processInfo );
	
		for( err2 = GetNextProcess( &psn ); err2 == noErr; err2 = GetNextProcess( &psn ) )
		{
			err2 = GetProcessInformation( &psn, &processInfo );
			
			//	Find the Finder's PSN by searching all running processes...
			
			if ( ( processInfo.processSignature == kFinderCreatorType ) && ( processInfo.processType == kFinderProcessType ) )
			{
				break;
			}
		}
		
		err[ 1 ] = AECreateDesc( typeProcessSerialNumber, &psn, sizeof( psn ), &aeDesc );
		
		//	Create AppleEvent (kAEFinderSuite, kAESync)
				
		err[ 2 ] = AECreateAppleEvent( kAEFinderSuite, kAESync, &aeDesc, kAutoGenerateReturnID, kAnyTransactionID, &appleEvent );
		
		err[ 3 ] = AEDisposeDesc( &aeDesc );
		
		err[ 4 ] = AECreateDesc( typeAlias, *aliasH, GetHandleSize( (Handle)aliasH ), &aeDesc );
		
		err[ 5 ] = AEPutParamDesc( &appleEvent, keyDirectObject, &aeDesc );
		
		err[ 6 ] = AEDisposeDesc( &aeDesc );
		
		err[ 7 ] = AESend( &appleEvent, &aeReply, kAENoReply, kAENormalPriority, kNoTimeOut, NULL, NULL );		//	Send the AppleEvent to the Finder
		
		err[ 8 ] = AEDisposeDesc( &aeReply );
		
		err[ 9 ] = AEDisposeDesc( &appleEvent );
		
		// See if there was an error...
		
		for( i = 0; i < ( sizeof( err ) / sizeof( err[ 0 ] ) ); i++ )
		{
			if( ( err[ i ] == noErr ) )
			{
				result = YES;
			}
			else
			{
				result = NO;
				
				break;
			}
		}
	}
	
	return result;
}

@end

#pragma mark
#pragma mark ------------
#pragma mark C Wrappers
#pragma mark ------------

/////////////////////////////////////////////////
// C wrapper for -(BOOL)sendFinderResyncEvent.
// The AliasHandle passed in should point to
// the item which you want updated.
/////////////////////////////////////////////////

Boolean SendFinderResyncEvent( AliasHandle aliasH )
{
	int				result = 0;
	cbAEUtils		*utils = nil;
	
	if( aliasH )
	{
		// Make utils...
		
		utils = [ [ cbAEUtils alloc ] init ];
		if( utils )
		{
			result = [ utils sendFinderResyncEvent:aliasH ];
			
			// Clean up...
			
			[ utils release ];
			
			utils = nil;
		}
	}
	
	return result;
}