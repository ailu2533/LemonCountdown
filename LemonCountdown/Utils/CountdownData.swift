// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftData

// public struct ModelUtilities {
//    
//    
//    static let container = getModelContainer([])
//    
//    public static func getModelContainer(_ types: [any PersistentModel.Type], isStoredInMemoryOnly: Bool = true) -> ModelContainer {
//        print(URL.applicationSupportDirectory.path(percentEncoded: false))
//
//        let sharedModelContainer: ModelContainer = {
//            let schema = Schema(types)
//            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)
//
//            do {
//                return try ModelContainer(for: schema, configurations: [modelConfiguration])
//            } catch {
//                fatalError("Could not create ModelContainer: \(error)")
//            }
//        }()
//
//        return sharedModelContainer
//    }
// }
