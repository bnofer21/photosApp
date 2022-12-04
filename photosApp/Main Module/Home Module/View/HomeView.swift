//
//  HomeView.swift
//  photosApp
//
//  Created by Юрий on 07.12.2022.
//

import Foundation
import UIKit

class HomeView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.id)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

