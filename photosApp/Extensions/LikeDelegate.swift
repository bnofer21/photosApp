//
//  LikeDelegate.swift
//  photosApp
//
//  Created by Юрий on 09.12.2022.
//

import Foundation

protocol LikeDelegate: AnyObject {
    func homePostCell(cell: HomeCell, didLike post: Post)
}
