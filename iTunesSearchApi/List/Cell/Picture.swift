//
//  Picture.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import UIKit

class Picture: Hashable {
    var id = UUID()
    var thumbnail: UIImage?

    init(thumbnail: UIImage? = nil) {
        self.thumbnail = thumbnail
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Picture, rhs: Picture) -> Bool {
        lhs.id == rhs.id
    }
}

