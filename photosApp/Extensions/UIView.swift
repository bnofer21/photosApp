//
//  UIView.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import UIKit

extension UIView {
    
    func addView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
}

