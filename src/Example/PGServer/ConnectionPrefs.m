
#import "ConnectionPrefs.h"
#import <PGServerKit/PGServerKit.h>

@implementation ConnectionPrefs

-(void)readDefaults {
	// retrieve defaults
	NSUserDefaults* theDefaults = [NSUserDefaults standardUserDefaults];
	[self setAllowRemoteConnections:[theDefaults boolForKey:@"allowRemoteConnections"]];
	[self setPort:[theDefaults integerForKey:@"port"]];
}

-(void)writeDefaults {
	// retrieve defaults
	NSUserDefaults* theDefaults = [NSUserDefaults standardUserDefaults];
	[theDefaults setBool:[self allowRemoteConnections] forKey:@"allowRemoteConnections"];
	[theDefaults setInteger:[self port] forKey:@"port"];
	[theDefaults synchronize];
}


-(void)awakeFromNib {
	[self readDefaults];
}

-(NSString* )hostname {
	if([self allowRemoteConnections]) {
		return @"*";
	} else {
		return nil;
	}
}

-(IBAction)ibConnectionChangeState:(id)sender {
	if([self allowRemoteConnections]) {
		[self setCustomPortEnabled:YES];
	} else {
		[self setCustomPortEnabled:NO];
		[self setSelectedPortOption:0];
	}
	[self ibSetDefaultCustomPort:sender];
}

-(IBAction)ibSetDefaultCustomPort:(id)sender {
	if([self selectedPortOption]==0) {
		// Default port option
		[self setPort:PGServerDefaultPort];
		[self setCustomPortEditable:NO];
	} else {
		// Custom port option
		[self setCustomPortEditable:YES];
	}
}

-(IBAction)ibToolbarConnectionSheetOpen:(NSWindow* )sender {
	[self ibConnectionChangeState:nil];
	[NSApp beginSheet:[self ibWindow] modalForWindow:sender modalDelegate:self didEndSelector:@selector(endSheet:returnCode:contextInfo:) contextInfo:nil];
}

-(IBAction)ibToolbarConnectionSheetClose:(NSButton* )theButton {
	NSParameterAssert([theButton isKindOfClass:[NSButton class]]);
	// Cancel and Restart buttons
	if([[theButton title] isEqualToString:@"Cancel"]) {
		[NSApp endSheet:[theButton window] returnCode:NSCancelButton];
	} else {
		[NSApp endSheet:[theButton window] returnCode:NSOKButton];
	}
}

-(void)endSheet:(NSWindow *)theSheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	[theSheet orderOut:self];
	if(returnCode==NSOKButton) {
		[self writeDefaults];
		// DO MORE HERE
	}
}

@end