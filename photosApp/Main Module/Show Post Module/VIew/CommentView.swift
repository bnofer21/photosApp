//
//  CommentView.swift
//  photosApp
//
//  Created by Юрий on 13.12.2022.
//

import UIKit

class CommentView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        registerCell()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
//        contentSize = CGSizeMake(frame.width, <#T##height: CGFloat##CGFloat#>)
    }
    
    private func registerCell() {
        register(CommentCell.self, forCellReuseIdentifier: CommentCell.cellId)
    }
}
