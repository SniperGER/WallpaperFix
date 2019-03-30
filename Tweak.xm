@interface WallpaperItemImporter : NSObject
+ (id)_defaultStillsOrdering;
@end

%hook WallpaperItemImporter
- (id)_wallpaperItemsForFileLists:(NSDictionary*)arg1 withType:(long long)arg2 sortedIDs:(id)arg3 {
	// Store a mutable copy of the default wallpaper order
	NSMutableArray* modifiedOrdering = [[self.class _defaultStillsOrdering] mutableCopy];
	
	// Check which items are already inside the default order and store only new wallpaper IDs
	NSMutableArray* itemsToAdd = [NSMutableArray array];
	for (NSNumber* item in arg1.allKeys) {
		if (![modifiedOrdering containsObject:item]) {
			[itemsToAdd addObject:item];
		}
	}
	
	// Sort the new wallpaper IDs and append it to the default wallpaper order
	itemsToAdd = [[itemsToAdd sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
	[modifiedOrdering addObjectsFromArray:itemsToAdd];
	
	return %orig(arg1, arg2, modifiedOrdering);
}
%end	// %hook WallpaperItemImporter


%ctor {
	// File integrity check
	if (access("/var/lib/dpkg/info/ml.festival.wallpaperfix.list", F_OK) == -1) {
		return;
	}
	dlopen("/System/Library/PreferenceBundles/Wallpaper.bundle/Wallpaper", 2);
	%init();
}
