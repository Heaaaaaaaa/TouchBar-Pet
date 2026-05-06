#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

BOOL TBPInstallPersistentTouchBarView(NSView *view, NSString *identifier);
BOOL TBPPresentPersistentTouchBar(NSTouchBar *touchBar, NSString *identifier);
BOOL TBPRemovePersistentTouchBar(NSString *identifier);

NS_ASSUME_NONNULL_END
