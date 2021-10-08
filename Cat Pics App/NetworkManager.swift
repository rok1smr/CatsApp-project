//
//  NetworkManager.swift
//  Cat Pics App
//
//  Created by Konstantin on 21.02.2021.
//

import Foundation
import UIKit


struct ApiResponseDataModel: Codable {
    var id: String
    var url: String
  
}

class NetworkManager {
    static var shared = NetworkManager() 
    init() { }
    
    func getImageURL(handler: @escaping (URL?) -> () ) {
        let urlString = "https://api.thecatapi.com/v1/images/search"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                handler(nil)
            }
            return
        }
        
        
        DispatchQueue.global().async {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, _, err) in
                if let err = err {
                    print(err)
                    DispatchQueue.main.async {
                        handler(nil)
                    }
                } else if let data = data {
                    if let apiModel = try? JSONDecoder().decode([ApiResponseDataModel].self, from: data),
                       let item = apiModel.first,
                       let url = URL(string: item.url)
                    {
                        DispatchQueue.main.async {
                            print(item)
                            handler(url)
                        }
                    } else {
                        DispatchQueue.main.async {
                            handler(nil)
                        }
                    }
                }
            }
            task.resume()
        }
    } 
    
    
    func getImageFromURL(_ url: URL, handler: @escaping (UIImage?) -> ()) {
        DispatchQueue.main.async {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, _, err) in
                if let err = err {
                    DispatchQueue.main.async {
                        handler(nil)
                    }
                } else if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        handler(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        handler(nil)
                    }
                }
            }
            task.resume()
        }
    }
}
