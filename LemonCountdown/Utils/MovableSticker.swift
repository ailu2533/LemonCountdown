//
//  File.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation
import LemonUtils

class MovableSticker: MovableObject {
    var stickerName: String

    enum CodingKeys: String, CodingKey {
        case stickerName
    }

    init(stickerName: String, pos: CGPoint = .zero) {
        self.stickerName = stickerName
        super.init(pos: pos)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stickerName = try container.decode(String.self, forKey: .stickerName)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stickerName, forKey: .stickerName)
        try super.encode(to: encoder)
    }
}

// extension MovableSticker: Hashable {
//    static func == (lhs: MovableSticker, rhs: MovableSticker) -> Bool {
//        return lhs.stickerName == rhs.stickerName
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(stickerName)
//    }
// }
