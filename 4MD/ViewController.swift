//
//  ViewController.swift
//  4MD
//
//  Created by Aivis Skangalis 10.06.2020.
//  Copyright © 2020.g. Aivis Skangalis. All rights reserved.
//

import UIKit

struct GithubContent {
    let name: String?
    let company: String?
    let bio: String?
    let imageUrl: String?
}

class ViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var image: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
    }
    func fetchUserData() -> Void {
        let url  = URL(string: "https://api.github.com/users/aaiiviis")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            if let data = data {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let validDictionary = jsonSerialized {
                        
                        let validName = validDictionary["name"] as? String
                        let validCompany = validDictionary["company"] as? String
                        let validBio = validDictionary["bio"] as? String
                        let validImageUrl = validDictionary["avatar_url"] as? String
                    
                        DispatchQueue.main.async {
                            self.name.text = validName ?? "No name received"
                            self.company.text = validCompany ?? "No company reveiced"
                            self.bio.text = validBio ?? "No bio received"
                            self.image.downloaded(from: validImageUrl ?? "https://dummyimage.com/600x400/000/fff&text=Attēls+nav+atrasts")
                            
                        }
                    }else{
                        print("Dati nav derīgi!")
                    }
                    //print(jsonSerialized!)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
}
    extension UIImageView {
        func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() {
                    self.image = image
                }
                }.resume()
        }
        func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
}

