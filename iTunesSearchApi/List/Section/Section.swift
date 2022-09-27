//
//  Section.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import UIKit

class Section: Hashable {
    var id = UUID()
    var title: String
    var pictures: [Picture]

    init(title: String, pictures: [Picture]) {
        self.title = title
        self.pictures = pictures
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}
