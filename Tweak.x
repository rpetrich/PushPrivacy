#import "Headers.h"

static NSDictionary *settings;

static BBBulletin *ModifiedBulletinForLockScreen(BBBulletin *bulletin)
{
	NSString *key = [@"PPPrivateOnLockScreen-" stringByAppendingString:bulletin.sectionID ?: @""];
	if ([[settings objectForKey:key] boolValue]) {
		BBContent *content = [bulletin.content copy];
		content.message = @"New Message";
		bulletin = [[bulletin copy] autorelease];
		bulletin.content = content;
		[content release];
	}
	return bulletin;
}

%hook SBAwayBulletinListController

- (void)observer:(BBObserver *)observer modifyBulletin:(BBBulletin *)bulletin
{
	bulletin = ModifiedBulletinForLockScreen(bulletin);
	%orig();
}

- (void)observer:(BBObserver *)observer addBulletin:(BBBulletin *)bulletin forFeed:(unsigned)feed
{
	bulletin = ModifiedBulletinForLockScreen(bulletin);
	%orig();
}

%end

static void LoadSettings(void)
{
	[settings release];
	settings = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.rpetrich.pushprivacy.plist"];
}

%ctor
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	LoadSettings();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (void *)LoadSettings, CFSTR("com.rpetrich.pushprivacy.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool drain];
}
