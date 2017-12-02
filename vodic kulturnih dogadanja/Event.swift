//
//  Event.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 02/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import Foundation

struct Event: Codable {
    let eventId: Int?
    let name: String?
    let description: String?
    let begin: Int?
    let end: Int?
    let picture: String?
    let link: String?
    let location: String?
    let price: Float?
}
