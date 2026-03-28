// Sideloading.x
// Extra patches needed when the tweak is injected into a sideloaded IPA
// rather than via a jailbreak dylib injection.
//
// Without these, certain features crash or behave incorrectly on non-jailbroken devices.

#import "YTTweak.h"

// ─────────────────────────────────────────────
// MARK: - Disable Background App Refresh Guard
// ─────────────────────────────────────────────
// YouTube gates background audio on a capabilities check.
// On sideloaded builds the entitlement may be missing; this bypasses the guard.

%hook YTBackgroundabilityPolicy

- (BOOL)isBackgroundPlaybackAvailable {
    return YES;
}

%end

// ─────────────────────────────────────────────
// MARK: - Disable Certificate Pinning
// ─────────────────────────────────────────────
// YouTube pins its TLS cert. On sideloaded builds the certificate chain differs,
// so we override the validation to always succeed.
// NOTE: Only safe for personal use — disabling pinning reduces MITM protection.

%hook NSURLSession

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        %orig;
    }
}

%end

// ─────────────────────────────────────────────
// MARK: - Fix NSUserDefaults Suite for Sideloaded Bundle IDs
// ─────────────────────────────────────────────
// Jailbroken tweaks share the system-wide NSUserDefaults.
// Sideloaded builds use the app's sandbox, which is fine — 
// but we ensure our keys are stored in the standard domain.

%hook NSUserDefaults

+ (NSUserDefaults *)standardUserDefaults {
    return %orig; // No change needed — just a hook point for future customisation
}

%end

// ─────────────────────────────────────────────
// MARK: - Suppress StoreKit / IAP Prompts
// ─────────────────────────────────────────────
// On sideloaded builds, StoreKit calls fail silently and sometimes
// cause the app to hang waiting for a response.

%hook SKPaymentQueue

- (void)addPayment:(SKPayment *)payment {
    // Drop the payment request — prevents hangs on sideloaded builds
    NSLog(@"[YTTweak] Suppressed StoreKit payment request: %@", payment.productIdentifier);
}

%end
