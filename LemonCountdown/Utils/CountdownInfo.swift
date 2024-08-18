//
//  EventInfo.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation
// import LemonUtils
import SwiftUI

@Observable
class EventInfo: MovableObject {
    var date: Date
    var title: String

    enum CodingKeys: String, CodingKey {
        case date
        case title
    }

    init(date: Date, title: String) {
        self.date = date
        self.title = title
        super.init(pos: .init(x: 190, y: 200))
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        title = try container.decode(String.self, forKey: .title)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(title, forKey: .title)
        try super.encode(to: encoder)
    }

    func view() -> some View {
        VStack {
            Text(title)
            Text(date.formatted(date: .abbreviated, time: .omitted))
        }
    }
}
