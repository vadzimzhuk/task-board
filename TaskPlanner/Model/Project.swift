//
//  Project.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 10/05/2025.
//

import Foundation
import SwiftData

@Model
class Project: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \Task.project)
    var tasks: [Task] = []
    
    var colorData: Data?
    
    init(name: String, tasks: [Task] = []) {
        self.id = UUID()
        self.name = name
        self.tasks = tasks
    }
    
//    required init(from decoder: any Decoder) throws {
//        fatalError("this method should not be used as task copying is not supported")
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.colorData = try container.decode(Data.self, forKey: .color)
//        self.tasks = try container.decode([Task].self, forKey: .tasks)
//        
//        // Restore Task reference to Project
//        for task in tasks {
//            task.project = self
//        }
//    }
//    
//    func encode(to encoder: any Encoder) throws {
//        fatalError("this method should not be used as task copying is not supported")
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(colorData, forKey: .color)
//        
//        // Remove Task reference to Project
//        let tasksWithoutProject = tasks.map { task in
//            Task(title: task.title)
//        }
//        
//        try container.encode(tasksWithoutProject, forKey: .tasks)
//    }
    
//    enum CodingKeys: String, CodingKey {
//        case id, name, color, tasks
//    }
}

import SwiftUI

extension Project {
    var color: Color {
        get {
            guard let colorData else { return .black }
            
            do {
                let color = try Color.decodeColor(from: colorData)
                return color
            } catch {
                assertionFailure("Failed to decode color with error: \(error)")
                return .black
            }
        }
        
        set {
            do {
                try colorData = newValue.encode()
            } catch {
                assertionFailure("Failed to encode color with error: \(error)")
            }
        }
    }
}
