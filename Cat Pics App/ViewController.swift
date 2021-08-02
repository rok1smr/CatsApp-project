//
//  ViewController.swift
//  Cat Pics App
//
//  Created by Konstantin on 15.11.2020.
//

// colors used: https://colorhunt.co/palette/220248

// there are 3 arrays currently implemented:
// likedArray - is created in the main vs to store URLs when the liked button is pressed
// savedArray - stores the above mentioned URLs into the user defaults
// savedItems - used in the SavedPicsViewController to display the URLs on the saved screen


import UIKit

class ViewController: UIViewController {
    
////    creating the user defaults

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        
        let defaults = UserDefaults.standard
        defaults.set(likedArray, forKey: "SavedArray")
        let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        print(savedArray)
    }
    
    
    struct theCatAPI: Decodable {
        var url: String!
    }
    var cats = theCatAPI()
    
    var likedArray:[URL] = []
    var currentURL: URL?
    
    @IBOutlet weak var catsHere: UIImageView!
    @IBAction func buttonNext(_ sender: UIButton) {
        loadImage()
    }
    
//    need to implement "set" of the user defaults to add new URLs when the liked button is pressed
//    to the liked array (already done) but also to the saved array that stores info in the user defaults
    @IBAction func buttonLike(_ sender: UIButton) {
        guard let currentURL = currentURL else { return }
    
        likedArray.append(currentURL)
        print(likedArray)
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    func loadImage() {
        setProgressIndicatorEnabled(true)
        NetworkManager.shared.getImageURL { [weak self] (url) in
            
            guard let url = url else {
                self?.showProblemAlert()
                self?.setProgressIndicatorEnabled(false)
                return
            }
            
            // получили нашу ссылку для фото
            
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

    
// протянул из сториборда элемент UIActivityIndicatorView и добавил его название в функцию, по умолчанию он не работает
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
        
    
// via the PREPARE for segue assigned the identifier of the transition from the main vc to the saved pics vc
// and defined savedItems array from the saved pics vc equals to the liked array from the main vc
// to which we add the URLs via the like button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SavedViewController"{
            if let vc = segue.destination as? SavedPicsViewController {
                vc.savedItems = likedArray
            }
        }
        
    }
    
}



