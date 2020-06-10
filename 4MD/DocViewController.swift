//
//  DocViewController.swift
//  4MD
//
//  Created by Aivis Skangalis 10.06.2020.
//  Copyright © 2020.g. Aivis Skangalis. All rights reserved.
//

import UIKit

class DocViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var documents = [JsonDec]()
    var fileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDocs()
    }
    
    func fetchDocs() -> Void{
        let url = URL(string: "https://api.github.com/repos/aaiiviis/RestApi/contents/Documents")
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
                self.documents = downloadedDocs
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
        return documents.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocViewCell") as? DocViewCell else {
            return UITableViewCell()
        }
        cell.name.text = documents[indexPath.row].name
        let sizeKB = documents[indexPath.row].size / 1024
        cell.size.text = String(sizeKB) + " KB"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let localPathUrl = download(fileName: documents[indexPath.row].name, fileUrlString: documents[indexPath.row].download_url)
        localPath = localPathUrl.absoluteString
        fileName = documents[indexPath.row].name
        performSegue(withIdentifier: "showDoc", sender: self)
    }
    
    var localPath:String? = nil
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! OpenDocViewController
        VC.title = fileName
        VC.filePath = localPath
    }
}
