//
//  WebViewController.swift
//  4MD
//
//  Created by Aivis Skangalis 10.06.2020.
//  Copyright © 2020.g. Aivis Skangalis. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var webDocs = [JsonDec]()
    var fileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchWeb()
    }
    
    func fetchWeb() -> Void{
        let url = URL(string: "https://api.github.com/repos/aaiiviis/RestApi/contents/WebPages")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data, error == nil, response != nil else { print("error")
                return
                
            }
            print("Downolading finished")
            print(data)
            do
            {
                let decoder = JSONDecoder()
                let downloadedDocs = try decoder.decode([JsonDec].self, from: data)
                self.webDocs = downloadedDocs
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
        return webDocs.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WebViewCell") as? WebViewCell else {
            return UITableViewCell()
        }
        cell.name.text = webDocs[indexPath.row].name
        let sizeKB = webDocs[indexPath.row].size / 1024
        cell.size.text = String(sizeKB) + " KB"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let localPathUrl = download(fileName: webDocs[indexPath.row].name, fileUrlString: webDocs[indexPath.row].download_url)
        localPath = localPathUrl.absoluteString
        fileName = webDocs[indexPath.row].name
        performSegue(withIdentifier: "showWeb", sender: self)
    }
    
    var localPath:String? = nil
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! OpenWebViewController
        VC.title = fileName
        VC.filePath = localPath
    }
}
