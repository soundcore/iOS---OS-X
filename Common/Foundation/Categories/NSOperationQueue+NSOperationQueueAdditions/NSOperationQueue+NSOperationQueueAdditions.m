/****************************************************************************

File:			NSOperationQueue+NSOperationQueueAdditions.m

Date:			9/6/11

Version:		1.0

Authors:		soundcore

				Copyright 2011 soundcore
				All rights reserved worldwide.

Notes:			Implementation for NSOperationQueue+NSOperationQueueAdditions

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore.

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE FULL EXTENT OF
				INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		

9/6/11			MCA Initial version.

******************************************************************************/

#import <NSOperationQueue+NSOperationQueueAdditions.h>

@implementation NSOperationQueue ( NSOperationQueueAdditions )

////////////////////////////////////////////////////////////////////////////////////////////////////
// Cancel ALL operations on any NSOperationQueue, using a predicate.
//
// Example usage:
//
// NSPredicate *filter = [ NSPredicate predicateWithFormat:@"SELF.interestedObject == %@", self ];
// [ q cancelOperationsFilteredByPredicate:filter ];
//
// Make or get new NSOperation object...
// [ op setInterestedObject:self ];
// [ q addOperation:op ];
/////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)cancelOperationsFilteredByPredicate:(NSPredicate*)predicate
{
	NSArray *ops = nil;
	
	if( predicate )
	{
		// Get array of NSOperations filtered by the predicate passed in...
		
		ops = [ [ self operations ] filteredArrayUsingPredicate:predicate ];
		if( ops )
		{
			// Loop array of NSOperations...
			
			for( NSOperation *op in ops )
			{
				// See if it's doing something...
				
				if( ![ op isExecuting ] && ![ op isFinished ] && ![ op isCancelled ] )
				{
					// Kill it...
					
					[ op cancel ];
				}
			}
		}
	}
}

@end
