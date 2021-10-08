//
//  URLStore.swift
//  Cat Pics App
//
//  Created by Konstantin on 03.08.2021.
//

import Foundation

class URLsStore {
    static var shared = URLsStore()
    private struct Keys {
        static let savedArray = "SavedArray"
    }
    
    func addURL(_ url: URL){
        
        var savedArray = getURLs()
        if savedArray.contains(url) { return }
        savedArray.append(url)
        let savedArrayStrings: [String] = savedArray.map { url in url.absoluteString }
        
        
        UserDefaults.standard.set(savedArrayStrings, forKey: URLsStore.Keys.savedArray)
        UserDefaults.standard.synchronize()
    }
        

    func getURLs() -> [URL] {
        guard let savedArray = UserDefaults.standard.array(forKey: URLsStore.Keys.savedArray) as? [String]
        else  { return [] }
        let savedArrayURLsFromStrings: [URL] = savedArray.compactMap { string in URL.init(string: string) }
        return savedArrayURLsFromStrings
    }
}
