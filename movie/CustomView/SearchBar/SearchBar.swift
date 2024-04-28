//
//  SearchBar.swift
//  movie
//
//  Created by Jan Sebastian on 27/04/24.
//

import UIKit

class SearchBar: UIView {
    
    private let txtSearch: TextField = {
        let textView = TextField()
        textView.backgroundColor = UIColor(white: 1, alpha: 0.001)
        textView.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        return textView
    }()
    
    private let iconSearch: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 1, alpha: 0.001)
        button.setImage(UIImage(named: "Search"), for: .normal)
        return button
    }()
    
    private var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        return view
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
//        txtSearch.layoutIfNeeded()
//        iconSearch.frame = CGRect(x: 0, y: 0, width: txtSearch.bounds.height, height: txtSearch.bounds.height)
//        txtSearch.rightView = iconSearch
//        txtSearch.rightViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        txtSearch.layoutIfNeeded()
        iconSearch.frame = CGRect(x: 0, y: 0, width: txtSearch.bounds.height, height: txtSearch.bounds.height)
        txtSearch.rightView = iconSearch
        txtSearch.rightViewMode = .always
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        self.addSubview(txtSearch)
        self.addSubview(line)
        
    }

    private func setupConstraints() {
        let views: [String: Any] = ["txtSearch": txtSearch, "line": line]
        var constraints: [NSLayoutConstraint] = []
        
        txtSearch.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        let v_content = "V:|-10-[txtSearch]-0-[line]-10-|"
        let h_txtSearch = "H:|-15-[txtSearch]-15-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_content, options: .alignAllCenterX, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_txtSearch, options: .alignAllTop, metrics: nil, views: views)
        constraints += [NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: txtSearch, attribute: .leading, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: txtSearch, attribute: .trailing, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
