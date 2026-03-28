// YTTweak.x
// Main tweak entry point — hooks into YouTube's internal Objective-C classes
// Uses Theos + Logos syntax (%hook, %orig, %new, %ctor)

#import "YTTweak.h"

// ─────────────────────────────────────────────
// MARK: - Helpers
// ─────────────────────────────────────────────

static BOOL isEnabled(NSString *key) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

// ─────────────────────────────────────────────
// MARK: - Remove Ads
// ─────────────────────────────────────────────

// Hook into the ad manager to block pre-roll and banner ads
%hook YTAdsInnerTubePlayerResponse
- (BOOL)hasAds { return NO; }
%end

%hook YTAdService
- (void)loadAd { /* suppress ad loading */ }
%end

// ─────────────────────────────────────────────
// MARK: - Remove Shorts Button from Tab Bar
// ─────────────────────────────────────────────

%hook YTPivotBarItemView

- (void)setRenderer:(id)renderer {
    // Inspect the pivot item identifier and suppress Shorts tab if the feature is enabled
    if (isEnabled(@"YTTweakRemoveShortsTab")) {
        if ([self respondsToSelector:@selector(pivotIdentifier)]) {
            NSString *identifier = [self pivotIdentifier];
            if ([identifier isEqualToString:@"FEshorts"]) {
                self.hidden = YES;
                return;
            }
        }
    }
    %orig;
}

%end

// ─────────────────────────────────────────────
// MARK: - Remove Explore / Subscriptions / Library Tabs (optional)
// ─────────────────────────────────────────────

%hook YTIPivotBarRenderer

- (NSArray *)items {
    NSMutableArray *filteredItems = [%orig mutableCopy];

    if (isEnabled(@"YTTweakRemoveExploreTab")) {
        [filteredItems filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id item, NSDictionary *_) {
            // Explore tab identifier
            return ![[item pivotIdentifier] isEqualToString:@"FEexplore"];
        }]];
    }

    return [filteredItems copy];
}

%end

// ─────────────────────────────────────────────
// MARK: - Hide End Screen Cards and Annotations
// ─────────────────────────────────────────────

%hook YTAnnotationsViewController

- (void)viewDidLoad {
    if (isEnabled(@"YTTweakHideAnnotations")) {
        self.view.hidden = YES;
        return;
    }
    %orig;
}

%end

// ─────────────────────────────────────────────
// MARK: - Default HD Quality (720p / 1080p)
// ─────────────────────────────────────────────

%hook YTVideoQualitySwitchOriginalController

- (void)viewDidLoad {
    %orig;
    if (isEnabled(@"YTTweakDefaultHDQuality")) {
        // Attempt to set 1080p as the default selected quality
        NSArray *qualities = [self videoQualities];
        for (id q in qualities) {
            if ([[q qualityLabel] isEqualToString:@"1080p"]) {
                [self setSelectedQuality:q];
                break;
            }
        }
    }
}

%end

// ─────────────────────────────────────────────
// MARK: - OLED / Pure Black Background
// ─────────────────────────────────────────────

%hook YTPageStyleController

- (long long)pageStyle {
    if (isEnabled(@"YTTweakOLEDMode")) {
        return 2; // Force dark/OLED mode
    }
    return %orig;
}

%end

// ─────────────────────────────────────────────
// MARK: - Background Playback
// ─────────────────────────────────────────────

%hook YTBackgroundabilityPolicy

- (BOOL)isBackgroundSupportedForPlaybackType:(NSInteger)type {
    if (isEnabled(@"YTTweakBackgroundPlayback")) {
        return YES;
    }
    return %orig;
}

%end

// ─────────────────────────────────────────────
// MARK: - Remove YouTube Premium Upsell Prompts
// ─────────────────────────────────────────────

%hook YTUpsellDialogController

- (void)viewDidAppear:(BOOL)animated {
    // Don't call %orig → suppresses the dialog entirely
    if (isEnabled(@"YTTweakHideUpsell")) {
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    %orig;
}

%end

// ─────────────────────────────────────────────
// MARK: - Speed Gesture (Scrub to change playback rate)
// ─────────────────────────────────────────────

// Hooks the player overlay to respond to a long-press for 2x speed
%hook YTWatchController

%new
- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (!isEnabled(@"YTTweakSpeedGesture")) return;

    AVPlayer *player = [self playerViewController].player;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        player.rate = 2.0;
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled) {
        player.rate = 1.0;
    }
}

- (void)viewDidLoad {
    %orig;
    if (isEnabled(@"YTTweakSpeedGesture")) {
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc]
            initWithTarget:self action:@selector(handleLongPress:)];
        lp.minimumPressDuration = 0.5;
        [self.view addGestureRecognizer:lp];
    }
}

%end

// ─────────────────────────────────────────────
// MARK: - Hide comments section
// ─────────────────────────────────────────────

%hook YTCommentsHeaderCell

- (void)setHidden:(BOOL)hidden {
    if (isEnabled(@"YTTweakHideComments")) {
        %orig(YES);
        return;
    }
    %orig;
}

%end

// ─────────────────────────────────────────────
// MARK: - Constructor
// ─────────────────────────────────────────────

%ctor {
    // Register default preference values on first launch
    NSDictionary *defaults = @{
        @"YTTweakEnabled":              @YES,
        @"YTTweakRemoveShortsTab":      @NO,
        @"YTTweakRemoveExploreTab":     @NO,
        @"YTTweakHideAnnotations":      @YES,
        @"YTTweakDefaultHDQuality":     @NO,
        @"YTTweakOLEDMode":             @NO,
        @"YTTweakBackgroundPlayback":   @YES,
        @"YTTweakHideUpsell":           @YES,
        @"YTTweakSpeedGesture":         @NO,
        @"YTTweakHideComments":         @NO,
    };
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    %init;
}
