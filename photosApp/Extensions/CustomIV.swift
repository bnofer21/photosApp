//
//  CustomIV.swift
//  cryptoMonitoring
//
//  Created by Юрий on 16.12.2022.
//
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomIV: UIImageView {
    var imageUrl: String?
    func loadImage(urlStr: String) {
        imageUrl = urlStr
        image = UIImage(named: "noImage")
        if let img = imageCache.object(forKey: NSString(string: imageUrl!)) {
            image = img
            return
        }
        guard let url = URL(string: urlStr) else {return}
        imageUrl = urlStr
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let err = error {
                print(err)
            } else {
                DispatchQueue.main.async {
                    let tempImg = UIImage(data: data!)
                    if self.imageUrl == urlStr {
                        self.image = tempImg
                    }
                    imageCache.setObject(tempImg!, forKey: NSString(string: urlStr))
                }
            }
        }.resume()
    }
}
