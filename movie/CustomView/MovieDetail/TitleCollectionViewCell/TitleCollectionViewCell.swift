//
//  TitleCollectionViewCell.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    private let imgMovie: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.00)
        return view
    }()
    
    private let viewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    private let stackViewInfo: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalCentering
        stackview.alignment = .leading
        stackview.spacing = 8
        return stackview
    }()
    
    private let lblMovieTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.001)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 3
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    
    private let stackViewStatus: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .fill
        stackview.alignment = .center
        stackview.spacing = 5
        return stackview
    }()
    
    private let lblTime: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.001)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        label.sizeToFit()
        return label
    }()
    
    private let iconStatus: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "MovieQuality")
        view.backgroundColor = UIColor(white: 1, alpha: 0.001)
        return view
    }()
    
    private let lblGenre: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.001)
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        label.sizeToFit()
        return label
    }()
    
    static let defaultHeight: Int = {
        return 400
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(white: 1, alpha: 0.001)
        self.contentView.backgroundColor = UIColor(white: 1, alpha: 0.001)
        self.contentView.addSubview(imgMovie)
        self.contentView.addSubview(viewBackground)
        self.contentView.addSubview(stackViewInfo)
        stackViewInfo.addArrangedSubview(lblMovieTitle)
        stackViewInfo.addArrangedSubview(lblTime)
        stackViewInfo.addArrangedSubview(stackViewStatus)
        stackViewStatus.addArrangedSubview(lblTime)
        stackViewStatus.addArrangedSubview(iconStatus)
        stackViewInfo.addArrangedSubview(lblGenre)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["imgMovie": imgMovie,
                                    "viewBackground": viewBackground,
                                    "stackViewInfo": stackViewInfo]
        
        var constraints: [NSLayoutConstraint] = []
        
        imgMovie.translatesAutoresizingMaskIntoConstraints = false
        let h_imgMovie = "V:|-0-[imgMovie]-0-|"
        let v_imgMovie = "H:|-0-[imgMovie]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_imgMovie, options: .alignAllTop, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_imgMovie, options: .alignAllLeading, metrics: nil, views: views)
        
        viewBackground.translatesAutoresizingMaskIntoConstraints = false
        let h_viewBackground = "V:|-0-[viewBackground]-0-|"
        let v_viewBackground = "H:|-0-[viewBackground]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_viewBackground, options: .alignAllTop, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_viewBackground, options: .alignAllLeading, metrics: nil, views: views)
        
        stackViewInfo.translatesAutoresizingMaskIntoConstraints = false
        let h_stackViewInfo = "H:|-20-[stackViewInfo]-20-|"
        let v_stackViewInfo = "V:[stackViewInfo]-10-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_stackViewInfo, options: .alignAllBottom, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_stackViewInfo, options: .alignAllLeading, metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }

}

extension TitleCollectionViewCell {
    
    func setValue(value: MovieDetailModel) {
        let urlImg = "https://image.tmdb.org/t/p/original/\(value.backdropPath)"
        if let url = URL(string: urlImg) {
            imgMovie.kf.setImage(with: url)
        }
        
        if value.runtime > 0 {
            let getNewRunTime =  self.minutesToHoursAndMinutes(value.runtime)
            if getNewRunTime.hours > 0 {
                lblTime.text = "\(getNewRunTime.hours) h \(getNewRunTime.leftMinutes) m"
            } else {
                lblTime.text = "\(value.runtime) m"
            }
        }
        lblGenre.text = value.genres
        lblMovieTitle.text = value.title
    }
    
    func forTesting() {
        lblMovieTitle.text = "Movie Title Here 1"
        lblTime.text = "1 h 29 m"
        lblGenre.text = "Drama, Asia, Comedy, Series"
    }
    
}
