import SwiftUI

// The original project renders the demo screen in Open Sauce One.
// This shim falls back to the system font so the screen compiles
// anywhere. Delete this file if your project already provides the
// OpenSauceOneFont helpers.
enum OpenSauceOneFont {
    static func preload() {}
}

extension Font {
    static func openSauceRegular(size: CGFloat) -> Font {
        .system(size: size)
    }

    static func openSauceSemibold(size: CGFloat) -> Font {
        .system(size: size, weight: .semibold)
    }

    static func openSauceBold(size: CGFloat) -> Font {
        .system(size: size, weight: .bold)
    }
}
