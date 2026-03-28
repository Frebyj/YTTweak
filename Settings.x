// Settings.x
// Injects a "YTTweak" section into YouTube's native Settings screen
// Uses Logos hooks on YTSettingsSectionItemManager

#import "YTTweak.h"

// ─────────────────────────────────────────────
// MARK: - Helper: Toggle preference and show toast
// ─────────────────────────────────────────────

static void setPreference(NSString *key, BOOL value) {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

static BOOL getPreference(NSString *key) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

// ─────────────────────────────────────────────
// MARK: - Settings Section Injection
// ─────────────────────────────────────────────

// YTLite-style: hook into the settings item manager to inject a new section
%hook YTSettingsSectionItemManager

// Called by YouTube to build each settings section.
// We inject our own section at the bottom.
- (NSArray *)itemsForSection:(NSInteger)section {
    NSArray *originalItems = %orig;

    // Section 999 is our custom section identifier (arbitrary unused number)
    if (section != 999) return originalItems;

    NSMutableArray *items = [NSMutableArray array];

    // ── General ─────────────────────────────

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"Background Playback"
               titleComment:@"Allow audio to continue when app is backgrounded"
        accessibilityIdentifier:@"YTTweakBackgroundPlayback"
                     switchOn:getPreference(@"YTTweakBackgroundPlayback")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakBackgroundPlayback", on);
             }]];

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"Block Ads"
               titleComment:@"Suppress pre-roll and banner advertisements"
        accessibilityIdentifier:@"YTTweakBlockAds"
                     switchOn:getPreference(@"YTTweakBlockAds")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakBlockAds", on);
             }]];

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"OLED / Pure Black Mode"
               titleComment:@"Forces a true-black background for OLED screens"
        accessibilityIdentifier:@"YTTweakOLEDMode"
                     switchOn:getPreference(@"YTTweakOLEDMode")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakOLEDMode", on);
             }]];

    // ── Interface ────────────────────────────

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"Remove Shorts Tab"
               titleComment:@"Hides the Shorts button from the tab bar"
        accessibilityIdentifier:@"YTTweakRemoveShortsTab"
                     switchOn:getPreference(@"YTTweakRemoveShortsTab")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakRemoveShortsTab", on);
             }]];

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"Remove Explore Tab"
               titleComment:@"Hides the Explore/Search browse tab"
        accessibilityIdentifier:@"YTTweakRemoveExploreTab"
                     switchOn:getPreference(@"YTTweakRemoveExploreTab")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakRemoveExploreTab", on);
             }]];

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"Hide Annotations"
               titleComment:@"Remove end-screen cards and overlay annotations"
        accessibilityIdentifier:@"YTTweakHideAnnotations"
                     switchOn:getPreference(@"YTTweakHideAnnotations")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakHideAnnotations", on);
             }]];

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"Hide Comments"
               titleComment:@"Collapses the comments section on all videos"
        accessibilityIdentifier:@"YTTweakHideComments"
                     switchOn:getPreference(@"YTTweakHideComments")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakHideComments", on);
             }]];

    // ── Player ───────────────────────────────

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"Default 1080p Quality"
               titleComment:@"Automatically selects 1080p when available"
        accessibilityIdentifier:@"YTTweakDefaultHDQuality"
                     switchOn:getPreference(@"YTTweakDefaultHDQuality")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakDefaultHDQuality", on);
             }]];

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"Speed Gesture (Long Press = 2×)"
               titleComment:@"Hold the player to temporarily play at 2× speed"
        accessibilityIdentifier:@"YTTweakSpeedGesture"
                     switchOn:getPreference(@"YTTweakSpeedGesture")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakSpeedGesture", on);
             }]];

    // ── Premium ──────────────────────────────

    [items addObject:[YTSettingsSectionItem
        switchItemWithTitle:@"Hide Premium Upsell Dialogs"
               titleComment:@"Suppresses YouTube Premium subscription prompts"
        accessibilityIdentifier:@"YTTweakHideUpsell"
                     switchOn:getPreference(@"YTTweakHideUpsell")
             switchToggleBlock:^(id cell, BOOL on) {
                 setPreference(@"YTTweakHideUpsell", on);
             }]];

    return items;
}

%end

// ─────────────────────────────────────────────
// MARK: - Register the Section in Settings VC
// ─────────────────────────────────────────────

%hook YTSettingsViewController

- (void)viewDidLoad {
    %orig;

    // Register our custom section (section ID 999) with a title
    // YouTube iterates sections by integer IDs — we claim an unused one
    [self setSectionItems:[self.sectionItemManager itemsForSection:999]
               forCategory:999
                     title:@"YTTweak"
         titleDescription:nil
               headerHidden:NO];
}

%end
