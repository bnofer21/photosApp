//
//  PostsCollectionVIew.swift
//  photosApp
//
//  Created by Юрий on 05.12.2022.
//

import UIKit

class PostsCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .systemBackground
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        register(PostCell.self, forCellWithReuseIdentifier: PostCell.id)
    }

}





