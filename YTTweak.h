// YTTweak.h
// Shared header — preference keys, imports, and forward declarations
// of reverse-engineered YouTube internal classes

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// ─────────────────────────────────────────────
// MARK: - YouTube Internal Class Declarations
// ─────────────────────────────────────────────

// Tab bar / pivot bar
@interface YTPivotBarItemView : UIView
@property (nonatomic, copy) NSString *pivotIdentifier;
- (void)setRenderer:(id)renderer;
@end

@interface YTIPivotBarRenderer : NSObject
- (NSArray *)items;
@end

// Ads
@interface YTAdsInnerTubePlayerResponse : NSObject
- (BOOL)hasAds;
@end

@interface YTAdService : NSObject
- (void)loadAd;
@end

// Player
@interface YTVideoQualitySwitchOriginalController : UIViewController
- (NSArray *)videoQualities;
- (void)setSelectedQuality:(id)quality;
@end

@interface YTWatchController : UIViewController
- (UIViewController *)playerViewController;
@end

@interface YTBackgroundabilityPolicy : NSObject
- (BOOL)isBackgroundSupportedForPlaybackType:(NSInteger)type;
@end

// UI
@interface YTPageStyleController : NSObject
- (long long)pageStyle;
@end

@interface YTAnnotationsViewController : UIViewController
@end

@interface YTUpsellDialogController : UIViewController
@end

@interface YTCommentsHeaderCell : UITableViewCell
@end

// Settings helpers (from YouTubeHeader repo, used in Settings.x)
@interface YTSettingsViewController : UIViewController
- (void)pushGroupController:(id)controller;
@end

@interface YTSettingsSectionItemManager : NSObject
@end

@interface YTSettingsSectionItem : NSObject
+ (instancetype)switchItemWithTitle:(NSString *)title
                       titleComment:(NSString *)comment
                           accessibilityIdentifier:(NSString *)identifier
                         switchOn:(BOOL)on
                 switchToggleBlock:(void (^)(id, BOOL))block;
+ (instancetype)itemWithTitle:(NSString *)title
                 titleComment:(NSString *)comment
                 accessibilityIdentifier:(NSString *)identifier
                   detailTextBlock:(id)detailBlock
                       selectBlock:(void (^)(id, NSUInteger))selectBlock;
@end

@interface YTSettingsPickerViewController : UIViewController
- (instancetype)initWithNavTitle:(NSString *)title
                       pickerTitle:(NSString *)pickerTitle
                         items:(NSArray *)items
                  selectedItemIndex:(NSUInteger)index
                    parentResponder:(id)responder;
@end

@interface YTAlertView : UIView
+ (instancetype)confirmationDialogWithAction:(void (^)(void))action
                               actionTitle:(NSString *)actionTitle;
- (void)show;
@end
