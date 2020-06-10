//
//  download.swift
//  4MD
//
//  Created by Aivis Skangalis 10.06.2020.
//  Copyright © 2020.g. Aivis Skangalis. All rights reserved.
//

import UIKit


func download(fileName: String, fileUrlString: String) -> URL {
    let fileURL = URL(string: fileUrlString)
    // Create destination URL
    let now = Date()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyMMddHHmmss"
    let dateString = formatter.string(from: now)
    
    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
    //let destinationFileUrl = documentsUrl.appendingPathComponent("\(dateString)_\(fileName)")
    let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
    let localPath = destinationFileUrl
    print("Destination file URL: ", destinationFileUrl)
    //Create URL to the source file you want to download
    
    
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    
    let request = URLRequest(url:fileURL!)
    
    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
            // Success
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Successfully downloaded \(dateString)_\(fileName). Status code: \(statusCode)")
            }
            
            do {
                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
            } catch (let writeError) {
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
            }
            
        } else {
            print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "");
        }
    }
    task.resume()
    return localPath
}
