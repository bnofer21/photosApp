//
//  UIImageView.swift
//  photosApp
//
//  Created by Юрий on 05.12.2022.
//

import UIKit

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String) {
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
