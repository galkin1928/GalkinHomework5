//
//  GalkinHomework5App.swift
//  GalkinHomework5
//
//  Created by GALKIN Aleksandr on 13.11.2024.
//

import Foundation

struct SuffixArray: Sequence {
    private let text: String
    private let suffixes: [Int]

    init(_ text: String) {
        self.text = text
        self.suffixes = (0..<text.count).sorted {
             text[text.index(text.startIndex, offsetBy: $0)...] < text[text.index(text.startIndex, offsetBy: $1)...]
        }
    }

    func makeIterator() -> SuffixIterator {
        return SuffixIterator(text: text, suffixes: suffixes)
    }
}

struct SuffixIterator: IteratorProtocol {
    private let text: String
    private let suffixes: [Int]
    private var currentIndex = 0

    init(text: String, suffixes: [Int]) {
        self.text = text
        self.suffixes = suffixes
    }

    mutating func next() -> String? {
        guard currentIndex < suffixes.count else { return nil }
        let start = text.index(text.startIndex, offsetBy: suffixes[currentIndex])
        let suffix = String(text[start...])
        currentIndex += 1
        return suffix
    }
}

struct SuffixSequence {
    private let words: [String]

    init(text: String) {
        self.words = text.split(separator: " ").map(String.init)
    }

    func generateSuffixes() -> [String: Int] {
        var suffixCounts: [String: Int] = [:]

        for word in words {
            let suffixArray = SuffixArray(word)
            for suffix in suffixArray {
                if suffix.count >= 3 {
                    suffixCounts[suffix, default: 0] += 1
                }
            }
        }

        return suffixCounts
    }
}
