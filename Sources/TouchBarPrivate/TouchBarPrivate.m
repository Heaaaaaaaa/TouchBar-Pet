#import "TouchBarPrivate.h"
#import <dlfcn.h>

static NSCustomTouchBarItem *TBPPersistentItem;

typedef void (*TBPPresenceFunction)(NSString *, BOOL);
typedef void (*TBPCloseBoxFunction)(BOOL);
typedef void (*TBPAddTrayItemFunction)(id, SEL, NSTouchBarItem *);
typedef void (*TBPRemoveTrayItemFunction)(id, SEL, NSTouchBarItem *);
typedef void (*TBPPresentModalFunction)(id, SEL, NSTouchBar *, NSString *);
typedef void (*TBPPresentModalPlacementFunction)(id, SEL, NSTouchBar *, long long, NSString *);

static void *TBPDFRHandle(void) {
    static void *handle = NULL;
    if (handle == NULL) {
        handle = dlopen(
            "/System/Library/PrivateFrameworks/DFRFoundation.framework/DFRFoundation",
            RTLD_LAZY
        );
    }
    return handle;
}

static TBPPresenceFunction TBPPresence(void) {
    void *handle = TBPDFRHandle();
    if (handle == NULL) {
        return NULL;
    }

    return (TBPPresenceFunction)dlsym(handle, "DFRElementSetControlStripPresenceForIdentifier");
}

static TBPCloseBoxFunction TBPCloseBox(void) {
    void *handle = TBPDFRHandle();
    if (handle == NULL) {
        return NULL;
    }

    return (TBPCloseBoxFunction)dlsym(handle, "DFRSystemModalShowsCloseBoxWhenFrontMost");
}

BOOL TBPInstallPersistentTouchBarView(NSView *view, NSString *identifier) {
    if (view == nil || identifier.length == 0) {
        return NO;
    }

    SEL addSelector = NSSelectorFromString(@"addSystemTrayItem:");
    TBPPresenceFunction presence = TBPPresence();

    if (![NSTouchBarItem respondsToSelector:addSelector] || presence == NULL) {
        return NO;
    }

    NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
    item.view = view;

    TBPAddTrayItemFunction addItem = (TBPAddTrayItemFunction)[NSTouchBarItem methodForSelector:addSelector];
    addItem([NSTouchBarItem class], addSelector, item);
    presence(identifier, YES);

    TBPPersistentItem = item;
    return YES;
}

BOOL TBPPresentPersistentTouchBar(NSTouchBar *touchBar, NSString *identifier) {
    if (touchBar == nil || identifier.length == 0) {
        return NO;
    }

    TBPCloseBoxFunction closeBox = TBPCloseBox();
    if (closeBox != NULL) {
        closeBox(NO);
    }

    SEL selectors[] = {
        NSSelectorFromString(@"presentSystemModalTouchBar:systemTrayItemIdentifier:"),
        NSSelectorFromString(@"presentSystemModalFunctionBar:systemTrayItemIdentifier:")
    };

    for (NSUInteger index = 0; index < 2; index += 1) {
        SEL selector = selectors[index];
        if ([NSTouchBar respondsToSelector:selector]) {
            TBPPresentModalFunction present = (TBPPresentModalFunction)[NSTouchBar methodForSelector:selector];
            present([NSTouchBar class], selector, touchBar, identifier);
            return YES;
        }
    }

    SEL placementSelectors[] = {
        NSSelectorFromString(@"presentSystemModalTouchBar:placement:systemTrayItemIdentifier:"),
        NSSelectorFromString(@"presentSystemModalFunctionBar:placement:systemTrayItemIdentifier:")
    };

    for (NSUInteger index = 0; index < 2; index += 1) {
        SEL selector = placementSelectors[index];
        if ([NSTouchBar respondsToSelector:selector]) {
            TBPPresentModalPlacementFunction present = (TBPPresentModalPlacementFunction)[NSTouchBar methodForSelector:selector];
            present([NSTouchBar class], selector, touchBar, 1, identifier);
            return YES;
        }
    }

    return NO;
}

BOOL TBPRemovePersistentTouchBar(NSString *identifier) {
    if (identifier.length == 0) {
        return NO;
    }

    BOOL didRemove = NO;

    TBPPresenceFunction presence = TBPPresence();
    if (presence != NULL) {
        presence(identifier, NO);
        didRemove = YES;
    }

    SEL removeSelector = NSSelectorFromString(@"removeSystemTrayItem:");
    if (TBPPersistentItem != nil && [NSTouchBarItem respondsToSelector:removeSelector]) {
        TBPRemoveTrayItemFunction removeItem = (TBPRemoveTrayItemFunction)[NSTouchBarItem methodForSelector:removeSelector];
        removeItem([NSTouchBarItem class], removeSelector, TBPPersistentItem);
        TBPPersistentItem = nil;
        didRemove = YES;
    }

    return didRemove;
}
