//
//  AppConfig.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//

import Foundation

enum AppConfig {
    static var baseURL: URL {

        if let base = Bundle.main.infoDictionary?["BASE_URL"] as? String,
           let url = URL(string: base) { return url }
        // Fallback/hardcoded for safety:
        return URL(string: "https://api.unsplash.com")!
    }

    static var accessKey: String {
        guard let key = Bundle.main.infoDictionary?["ACCESS_KEY"] as? String, !key.isEmpty
        else { fatalError("Missing ACCESS_KEY in Info.plist") }
        return key
    }
}
