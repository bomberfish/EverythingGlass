//
//  tweak.c
//  BrokenGlass
//
//  Created by bedtime on 11/20/25.
//

#include <CoreFoundation/CoreFoundation.h>
#include "dobby.h"

Boolean (*_os_feature_enabled_old)(const char *domain, const char *feature);
Boolean _os_feature_enabled_new(const char *domain, const char *feature) {
    Boolean result = _os_feature_enabled_old(domain, feature);
    if (domain && feature) {
         if (strcmp(domain, "SwiftUI") == 0 &&
             strcmp(feature, "Solarium") == 0) {
             return false;
         }
    }
    
    return result;
}

__attribute__((constructor)) void InitTweak(void) {
    DobbyHook(DobbySymbolResolver(NULL, "_os_feature_enabled_impl"),
              _os_feature_enabled_new,
              &_os_feature_enabled_old);
}
