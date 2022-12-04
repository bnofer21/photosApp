//
//  TableView.swift
//  photosApp
//
//  Created by Юрий on 11.12.2022.
//

import UIKit

class ResultsTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(UserCell.self, forCellReuseIdentifier: UserCell.cellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
