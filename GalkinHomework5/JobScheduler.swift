//
//  JobScheduler.swift
//  GalkinHomework5
//
//  Created by GALKIN Aleksandr on 14.11.2024.
//

import Foundation
import SwiftUI

@MainActor
class JobScheduler: ObservableObject {
    private var jobQueue = JobQueue()
    @Published var completedJobs: [Job] = []

    init() {
        Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { _ in
            self.performSummary()
        }
    }

    func scheduleJob(withResult result: String) async {
        let startTime = Date()

        await Task.sleep(1 * 1_000_000_000)

        let executionTime = Date().timeIntervalSince(startTime)
        let job = Job(result: result, executionTime: executionTime)

        jobQueue.enqueue(job)
        completedJobs.append(job)
    }

    func performSummary() {
        let summary = completedJobs.map { "\($0.result) - \($0.executionTime) с" }.joined(separator: "\n")
        print("Summary обновление:\n\(summary)")
    }
}
