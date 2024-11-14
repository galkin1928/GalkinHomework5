//
//  SearchHistoryView.swift
//  GalkinHomework5
//
//  Created by GALKIN Aleksandr on 14.11.2024.
//

import SwiftUI

struct SearchHistoryView: View {
    @ObservedObject var jobScheduler = JobScheduler()

    var body: some View {
        VStack {
            Text("История поиска суффиксов")
                .font(.headline)
                .padding()

            List(jobScheduler.completedJobs) { job in
                HStack {
                    Text("Результат: \(job.result)")
                    Spacer()
                    Text("Время: \(job.executionTime, specifier: "%.2f") с")
                        .foregroundColor(job.colorForExecutionTime())
                }
            }
        }
    }
}
