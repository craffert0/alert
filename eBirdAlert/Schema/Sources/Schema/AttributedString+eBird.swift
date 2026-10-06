// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension AttributedString {
    init(eBird text: String) {
        if let markdown = text.markdownify {
            do {
                try self.init(markdown: markdown, options: .eBird)
            } catch {
                self.init(stringLiteral: text)
            }
        } else {
            self.init(stringLiteral: text)
        }
    }
}

public extension AttributedString.MarkdownParsingOptions {
    static let eBird: AttributedString.MarkdownParsingOptions =
        .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
}
