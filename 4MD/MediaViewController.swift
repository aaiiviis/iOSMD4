//
//  MediaViewController.swift
//  4MD
//
//  Created by User on 24/04/2019.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit
import AVKit

class MediaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var media = [JsonDec]()
    var player = AVPlayerViewController()
    var fileName = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchMedia()
    }
    
    func fetchMedia() -> Void{
        let url = URL(string: "https://api.github.com/repos/aaiiviis/RestApi/contents/Media")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data, error == nil, response != nil else { print("error")
                return
                
            }
            print("Downloading finished")
            print(data)
            do
            {
                let decoder = JSONDecoder()
                let downloadedDocs = try decoder.decode([JsonDec].self, from: data)
                self.media = downloadedDocs
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print("error after downloading")
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return media.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaViewCell") as? MediaViewCell else { return UITableViewCell() }
        cell.name.text = media[indexPath.row].name
        let sizeKB = media[indexPath.row].size / 1024
        cell.size.text = String(sizeKB) + " KB"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: media[indexPath.row].download_url){
            let video = AVPlayer(url: url)
            player.player = video
            present(player, animated: true, completion:
            {
                video.play()
            })
        }
    }
}
