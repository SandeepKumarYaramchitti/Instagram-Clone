//
//  posts.swift
//  Instagram Clone
//
//  Created by Sandeep Kumar  Yaramchitti on 2/24/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import Foundation

struct Post {
    let imageURL: String
    
    init(dictionary: [String: Any]) {
        self.imageURL = dictionary["imageUrl"] as? String ?? ""
    }
}
