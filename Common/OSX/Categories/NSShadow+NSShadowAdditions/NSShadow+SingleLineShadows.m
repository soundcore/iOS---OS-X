/****************************************************************************

File:			NSShadow+SingleLineShadows.m

Date:			10/11/11

Version:		1.0

Authors:		soundcore

				Copyright 2011 soundcore
				All rights reserved worldwide.

Notes:			Implementation for NSShadow+SingleLineShadows

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES
				SEVERE CRIMINAL AND CIVIL PENALTIES AND IS A VIOLATION
				OF INTERNATIONAL COPYRIGHT LAW. VIOLATORS WILL BE
				PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		10/11/11	MCA Initial version.

******************************************************************************/

#import <NSShadow+SingleLineShadows.h>

@implementation NSShadow (SingleLineShadows)
 
+ (void)setShadowWithOffset:(NSSize)offset blurRadius:(CGFloat)radius color:(NSColor*)shadowColor
{
    NSShadow *aShadow = [[[self alloc] init] autorelease];
    [aShadow setShadowOffset:offset];
    [aShadow setShadowBlurRadius:radius];
    [aShadow setShadowColor:shadowColor];
    [aShadow set];
}
 
+ (void)clearShadow
{
    NSShadow *aShadow = [[[self alloc] init] autorelease];
    [aShadow set];
}
 
@end