//
//  JsonDec.swift
//  4MD
//
//  Created by Aivis Skangalis 10.06.2020.
//  Copyright © 2020.g. Aivis Skangalis. All rights reserved.
//

import UIKit

struct JsonDec: Codable{
    let name: String
    let path: String
    let sha: String
    let size: Int
    let url: String
    let html_url: String
    let git_url: String
    let download_url: String
    let type: String
    
    struct Links: Codable{
        let selfLink: String
        let gitLink: String
        let htmlLink: String
        private enum CodingKeys : String, CodingKey {
            case selfLink = "self"
            case gitLink = "git"
            case htmlLink = "html"
        }
    }
    let _links: Links
}
