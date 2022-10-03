//
//  Configuration.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 19.09.2022.
//

import Foundation

struct Configuration: Decodable {
    let apiBaseUrl: URL
}

// MARK: Static properties
extension Configuration {
    // we specify base URL here
    static let `default`: Configuration = {
        Configuration(apiBaseUrl: URL(string: "https://jsonplaceholder.typicode.com")!)
    }()
}

