//
//  GalkinHomework5App.swift
//  GalkinHomework5
//
//  Created by GALKIN Aleksandr on 13.11.2024.
//

import SwiftUI
import Combine

class SuffixManager: ObservableObject {
    @Published var suffixCounts: [String: Int] = [:]
    @Published var topSuffixes: [String] = []
    @Published var filteredSuffixCounts: [String: Int] = [:]
    @Published var selectedView: SuffixViewMode = .all
    @Published var searchQuery: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.filterSuffixes(by: query)
            }
            .store(in: &cancellables)
    }

    func analyzeText(_ text: String) {
        let suffixSequence = SuffixSequence(text: text)
        suffixCounts = suffixSequence.generateSuffixes()

        topSuffixes = suffixCounts
            .filter { $0.key.count >= 3 }
            .sorted { $0.value > $1.value }
            .prefix(10)
            .map { $0.key }

        filteredSuffixCounts = suffixCounts
    }

    private func filterSuffixes(by query: String) {
        if query.isEmpty {
            filteredSuffixCounts = suffixCounts
        } else {
            filteredSuffixCounts = suffixCounts.filter { $0.key.contains(query) }
        }
    }

    func getAnalysisResult() -> String {
        return suffixCounts
            .map { "\($0.key) - \($0.value) раз(а)" }
            .joined(separator: ", ")
    }
}

enum SuffixViewMode {
    case all
    case top10
}
