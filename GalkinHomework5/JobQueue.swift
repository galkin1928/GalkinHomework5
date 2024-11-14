//
//  JobQueue.swift
//  GalkinHomework5
//
//  Created by GALKIN Aleksandr on 14.11.2024.
//

import Foundation
import SwiftUI

// Структура Job, представляющая собой задачу поиска с временем выполнения
struct Job: Identifiable {
    let id = UUID()
    let result: String
    let executionTime: Double

    func colorForExecutionTime() -> Color {
        if executionTime < 1 {
            return .green
        } else if executionTime > 5 {
            return .red
        } else {
            let ratio = (executionTime - 1) / 4
            return Color(red: 1, green: 1 - ratio, blue: 0)
        }
    }
}

// Очередь задач Job Queue с асинхронной обработкой поиска
class JobQueue {
    private var queue = [Job]()

    func enqueue(_ job: Job) {
        queue.append(job)
    }

    func dequeue() -> Job? {
        guard !queue.isEmpty else { return nil }
        return queue.removeFirst()
    }
}
