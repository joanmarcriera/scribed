import Foundation

/// Builds the URL for a pre-filled GitHub "New issue" page. Pure and UI-free so
/// it can be unit-tested without servers or the app target; the app layer
/// supplies the diagnostics title/body and edition. Visiting the URL opens the
/// GitHub issue form with the title and body already populated.
public enum IssueReport {

    /// Characters left unescaped in a query value. RFC 3986 *unreserved* only —
    /// deliberately excludes the sub-delimiters (`& = + #` …) that
    /// `URLComponents.queryItems` would leave raw and thereby corrupt the query,
    /// so any title/body (including Markdown with `&`) round-trips safely.
    private static let queryValueAllowed: CharacterSet = {
        var set = CharacterSet.alphanumerics
        set.insert(charactersIn: "-._~")
        return set
    }()

    /// e.g. `githubNewIssueURL(repoSlug: "Joanmarcriera/seshat", title: …, body: …)`
    /// → `https://github.com/Joanmarcriera/seshat/issues/new?title=…&body=…`.
    public static func githubNewIssueURL(repoSlug: String, title: String, body: String) -> URL? {
        func encode(_ value: String) -> String {
            value.addingPercentEncoding(withAllowedCharacters: queryValueAllowed) ?? ""
        }
        let query = "title=\(encode(title))&body=\(encode(body))"
        return URL(string: "https://github.com/\(repoSlug)/issues/new?\(query)")
    }
}
