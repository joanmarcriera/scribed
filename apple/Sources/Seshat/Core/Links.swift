import Foundation

/// Outbound links, kept in one place (mirrors the Python `links.py`). The donate
/// URL is empty until the Lemon Squeezy "Pay What You Want" product exists; the
/// Support menu item is additionally compiled in only for editions that define
/// `DONATE_ENABLED` (see configs/*.xcconfig), so the Setapp build omits it.
enum Links {
    /// Lemon Squeezy "Pay What You Want" checkout (marcriera store), verified live.
    static let donateURLString = "https://marcriera.lemonsqueezy.com/checkout/buy/e71c4ce2-f423-4bb6-9883-268e2324035d"
    static let projectURLString = "https://github.com/Joanmarcriera/seshat"

    static var donateURL: URL? {
        let trimmed = donateURLString.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : URL(string: trimmed)
    }
}
