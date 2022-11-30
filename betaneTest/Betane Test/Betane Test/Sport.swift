//
//  Sport.swift
//  Betane Test
//
//  Created by Robert Ferreira on 29/11/2022.
//

import Foundation
struct Sport: Codable {
//    sport id
    var i : String?
//    sport name
    var d : String?
//    list events
    var e : [Event]
    
    mutating func setFavourite(ind: Int) {
        if let fav = e[ind].favourite {
            e[ind].favourite = !fav
        } else {
            e[ind].favourite = true
        }
    }
    
    var collapsed: Bool?
}
