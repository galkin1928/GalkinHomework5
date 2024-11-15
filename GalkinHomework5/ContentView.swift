//
//  GalkinHomework5App.swift
//  GalkinHomework5
//
//  Created by GALKIN Aleksandr on 13.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var action: Int? = 0
    @ObservedObject private var suffixManager = SuffixManager()
    @ObservedObject private var jobScheduler = JobScheduler()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Введите текст", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onSubmit {
                        Task {
                            suffixManager.analyzeText(inputText)
                            await jobScheduler.scheduleJob(withResult: suffixManager.getAnalysisResult())
                        }
                    }
                    .onChange(of: inputText) { _, newValue in
                        suffixManager.analyzeText(newValue)
                    }
                
                NavigationLink {
                    SearchHistoryView(jobScheduler: jobScheduler)
                } label: {
                    Text("История поиска суффиксов")
                }
                
                Picker("", selection: $suffixManager.selectedView) {
                    Text("Все").tag(SuffixViewMode.all)
                    Text("Топ-10").tag(SuffixViewMode.top10)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if suffixManager.selectedView == .all {
                    SuffixListView(suffixManager: suffixManager)
                } else {
                    TopSuffixesView(suffixManager: suffixManager)
                }
            }
            .padding()
        }
    }
}

struct SuffixListView: View {
    @ObservedObject var suffixManager: SuffixManager

    var body: some View {
        List {
            ForEach(suffixManager.filteredSuffixCounts.keys.sorted(), id: \.self) { suffix in
                HStack {
                    Text(suffix)
                    Spacer()
                    Text("\(suffixManager.filteredSuffixCounts[suffix]!)")
                }
            }
        }
    }
}

struct TopSuffixesView: View {
    @ObservedObject var suffixManager: SuffixManager

    var body: some View {
        List {
            ForEach(suffixManager.topSuffixes, id: \.self) { suffix in
                HStack {
                    Text(suffix)
                    Spacer()
                    Text("\(suffixManager.suffixCounts[suffix]!)")
                }
            }
        }
    }
}
