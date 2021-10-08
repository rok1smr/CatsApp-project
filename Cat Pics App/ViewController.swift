//
//  ViewController.swift
//  Cat Pics App
//
//  Created by Konstantin on 15.11.2020.
//

// colors used: https://colorhunt.co/palette/220248


// savedItems - used in the SavedPicsViewController to display the URLs on the saved screen

import UIKit

class ViewController: UIViewController {
    
//  creating the user defaults
    var URLSave: URL? {
        get {
            return UserDefaults.standard.url(forKey: "SavedArray")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SavedArray")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    
    struct theCatAPI: Decodable {
        var url: String!
    }
    var cats = theCatAPI()
    
    var currentURL: URL?
    
    
    @IBOutlet weak var catsHere: UIImageView!
    @IBAction func buttonNext(_ sender: UIButton) {
        loadImage()
    }
    
//    need to implement "set" of the user defaults to add new URLs when the liked button is pressed
//    to the liked array (already done) but also to the saved array that stores info in the user defaults
    @IBAction func buttonLike(_ sender: UIButton) {
        guard let currentURL = currentURL else { return }
        URLsStore.shared.addURL(currentURL)
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    public func loadImage() {
        setProgressIndicatorEnabled(true)
        NetworkManager.shared.getImageURL { [weak self] (url) in
            
            guard let url = url else {
                self?.showProblemAlert()
                self?.setProgressIndicatorEnabled(false)
                return
            }
            
            
            NetworkManager.shared.getImageFromURL(url) { (image) in
                defer {
                    self?.setProgressIndicatorEnabled(false)
                }
                
                guard let image = image else {
                    self?.catsHere.image = nil
                    self?.currentURL = nil
                    self?.showProblemAlert()
                    return
                }
                
                self?.catsHere.image = image
                self?.currentURL = url
            }
        }
    }

    
    func setProgressIndicatorEnabled(_ enabled: Bool) {
        loadingIndicator.isHidden = !enabled
        if enabled {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    private var progressIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .white
        return indicator
        
    }()
    
    private func showProblemAlert() {
        let alertController = UIAlertController(title: "Some problem", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}



