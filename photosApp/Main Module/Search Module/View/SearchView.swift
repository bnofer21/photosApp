//
//  SearchView.swift
//  photosApp
//
//  Created by Юрий on 11.12.2022.
//

import UIKit

class SearchView: UIView {
    
    var tableView = ResultsTableView()
    
    var searchField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .line
        tf.placeholder = "Search profile..."
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tf.frame.height))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tf.frame.height))
        tf.rightViewMode = .always
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addView(searchField)
        addView(tableView)
    }
    
    func setFieldDelegateTarget(target: Any?, action: Selector) {
        searchField.addTarget(target, action: action, for: .editingChanged)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            searchField.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
