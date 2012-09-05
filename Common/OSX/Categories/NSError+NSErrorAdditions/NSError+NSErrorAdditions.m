/****************************************************************************

File:			NSError+NSErrorAdditions.h

Date:			3/6/12

Version:		1.0

Authors:		soundcore

				Copyright 2012 soundcore
				All rights reserved worldwide.

Notes:			Implementation for NSError+NSErrorAdditions

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

Changes:		See header.

******************************************************************************/

#import <NSError+NSErrorAdditions.h>

@implementation NSError ( NSErrorAdditions )

/////////////////////////////////////////////////////////////////////////////////////////////
// Return a simple NSError containing the domain, code, and string passed in - class method.
/////////////////////////////////////////////////////////////////////////////////////////////

+ (NSError*)simpleErrorFromDomain:(NSString*)domain andCode:(NSInteger)theCode andLocalizedDescription:(NSString*)localizedDescription
{
	NSDictionary	*errDict = nil;
	NSError			*err = nil;
	
	if( domain && localizedDescription )
	{
		errDict = [ NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey ];
		if( errDict )
		{
			err = [ [ [ NSError alloc ] initWithDomain:domain code:theCode userInfo:errDict ] autorelease ];
		}
	}
	
	return err;
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Return a simple NSError containing the domain, code, and string passed in - instance method.
////////////////////////////////////////////////////////////////////////////////////////////////

- (NSError*)simpleErrorFromDomain:(NSString*)domain andCode:(NSInteger)theCode andLocalizedDescription:(NSString*)localizedDescription
{
	NSDictionary	*errDict = nil;
	NSError			*err = nil;
	
	if( domain && localizedDescription )
	{
		errDict = [ NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey ];
		if( errDict )
		{
			err = [ NSError errorWithDomain:domain code:theCode userInfo:errDict ];
		}
	}
	
	return err;
}

@end
