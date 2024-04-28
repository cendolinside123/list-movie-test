//
//  MovieCollectionViewCell.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let stackViewCore: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 10
        return stackview
    }()
    
    private let imgMovie: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.00)
        return view
    }()
    
    private let stackViewInfo: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalCentering
        stackview.alignment = .fill
//        stackview.spacing = 10
        return stackview
    }()
    
    private let stackViewTitle: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 5
        return stackview
    }()
    
    private let lblMovieTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.001)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    
    private let lblYear: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.001)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.001)
        return label
    }()
    
    private let lblGenre: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.001)
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.sizeToFit()
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgMovie.image = nil
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(white: 1, alpha: 0.001)
        self.contentView.backgroundColor = UIColor(white: 1, alpha: 0.001)
        self.contentView.addSubview(mainView)
        mainView.addSubview(stackViewCore)
        stackViewCore.addArrangedSubview(imgMovie)
        stackViewCore.addArrangedSubview(stackViewInfo)
        stackViewInfo.addArrangedSubview(stackViewTitle)
        stackViewTitle.addArrangedSubview(lblMovieTitle)
        stackViewTitle.addArrangedSubview(lblYear)
//        stackViewInfo.addArrangedSubview(emptyLabel)
        stackViewInfo.addArrangedSubview(lblGenre)
    }
    
    private func setupConstraint() {
        let views: [String: Any] = ["mainView": mainView,
                                    "stackViewCore": stackViewCore]
        var constraints: [NSLayoutConstraint] = []
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        let v_mainView = "V:|-10-[mainView]-10-|"
        let h_mainView = "H:|-10-[mainView]-10-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_mainView, options: .alignAllLeading, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_mainView, options: .alignAllTop, metrics: nil, views: views)
        
        stackViewCore.translatesAutoresizingMaskIntoConstraints = false
        let v_stackViewCore = "V:|-0-[stackViewCore]-0-|"
        let h_stackViewCore = "H:|-0-[stackViewCore]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_stackViewCore, options: .alignAllLeading, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_stackViewCore, options: .alignAllTop, metrics: nil, views: views)
        
        imgMovie.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: imgMovie, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)]
        
//        lblMovieTitle.translatesAutoresizingMaskIntoConstraints = false
//        constraints += [NSLayoutConstraint(item: lblMovieTitle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16)]
//        
        lblYear.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: lblYear, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16)]
//        constraints += [NSLayoutConstraint(item: lblYear, attribute: .height, relatedBy: .equal, toItem: lblMovieTitle, attribute: .height, multiplier: 1, constant: 0)]
//        
        lblGenre.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: lblGenre, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12)]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension MovieCollectionViewCell {
    
    func setValue(value: MovieModel) {
        lblMovieTitle.text = value.title
        
        let splitStr = value.releaseDate.split(separator: "-")
        lblYear.text = "\(splitStr[0])"
        lblGenre.text = value.genreIDS
        
        if let backdropPath = value.backdropPath {
            let urlImg = "https://image.tmdb.org/t/p/w500/\(backdropPath)"
            if let url = URL(string: urlImg) {
                imgMovie.kf.setImage(with: url)
            }
        }
    }
    
    func forTest() {
        lblMovieTitle.text = "Movie Title 1"
        lblYear.text = "2024"
        lblGenre.text = "Drama, Asia, Comedy, Series"
    }
}
