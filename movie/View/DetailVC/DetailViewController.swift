//
//  DetailViewController.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import UIKit

class DetailViewController: BaseViewController {
    
    private let btnBack: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.00)
        button.setImage(UIImage(named: "BackButton"), for: .normal)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.001)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleDetailCell")
        collectionView.register(DescCollectionViewCell.self, forCellWithReuseIdentifier: "DescDetailCell")
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: "CastDetailCell")
        return collectionView
    }()
    
    private var idMovie: Int = 0
    private var viewModel: MovieDetailPresenter = MovieDetailPresenterImpl()
    private var getMovieInfo: (MovieDetailEntity, [CastEntity])?
    
    init(idMovie: Int) {
        self.idMovie = idMovie
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupConstraints()
        addAction()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        
        if idMovie != 0 {
            viewModel.loadMovieDetail(movieID: idMovie)
        } else {
            showToast(message: "error, failed get movie ID", font: UIFont.systemFont(ofSize: 14))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setupView() {
        self.view.addSubview(collectionView)
        self.view.addSubview(btnBack)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["collectionView": collectionView]
        var constraints: [NSLayoutConstraint] = []
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let v_collectionView = "V:|-[collectionView]-|"
        let h_collectionView = "H:|-0-[collectionView]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_collectionView, options: .alignAllLeading, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_collectionView, options: .alignAllTop, metrics: nil, views: views)
        
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: btnBack, attribute: .top, relatedBy: .equal, toItem: self.view.layoutMarginsGuide, attribute: .top, multiplier: 1, constant: 20)]
        constraints += [NSLayoutConstraint(item: btnBack, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)]
        constraints += [NSLayoutConstraint(item: btnBack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)]
        constraints += [NSLayoutConstraint(item: btnBack, attribute: .width, relatedBy: .equal, toItem: btnBack, attribute: .height, multiplier: 1, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
    }

}

extension DetailViewController {
    private func addAction() {
        btnBack.addTarget(self, action: #selector(backAction), for: .touchDown)
    }
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: MovieDetailDelegate {
    func onSuccess(value: (MovieDetailEntity, [CastEntity])) {
        getMovieInfo = value
        self.collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    func onError(error: Error) {
        self.showToast(message: error.localizedDescription, font: UIFont.systemFont(ofSize: 14))
    }
    
    func onLoading() {
        showLoading()
    }
    
    func onEndLoading() {
        hideLoading()
    }
    
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let getData = getMovieInfo {
            if getData.1.count > 0 {
                return 3
            } else {
                return 2
            }
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let getItem = getMovieInfo else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
        }
        
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleDetailCell", for: indexPath) as? TitleCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
            }
            cell.setValue(value: getItem.0)
            return cell
        } else if indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescDetailCell", for: indexPath) as? DescCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
            }
            cell.setValue(value: getItem.0)
            return cell
        } else if indexPath.item == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastDetailCell", for: indexPath) as? CastCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
            }
            
            if getItem.1.count > 0 {
                cell.setValue(value: getItem.1)
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
            }
            
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
    }
    
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let getItem = getMovieInfo else {
            return .zero
        }
        
        if indexPath.item == 0 {
            return CGSize(width: self.collectionView.bounds.width, height: CGFloat(TitleCollectionViewCell.defaultHeight))
        } else if indexPath.item == 1 {
            if let getSize = getItem.0.overViewSize {
                return CGSize(width: self.collectionView.bounds.width, height: getSize.height)
            } else {
                return CGSize(width: self.collectionView.bounds.width, height: CGFloat(DescCollectionViewCell.templateHeight))
            }
        } else if indexPath.item == 2 {
            if getItem.1.count > 0  {
                return CGSize(width: self.collectionView.bounds.width, height: CGFloat(180))
            } else {
                return.zero
            }
            
        }
        
        return .zero
    }
}
