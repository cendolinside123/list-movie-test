//
//  HomeViewController.swift
//  movie
//
//  Created by Jan Sebastian on 27/04/24.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private let stackViewCore: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.backgroundColor = UIColor(white: 1, alpha: 0.001)
        return stackView
    }()
    
    private let searchView = SearchBar()
    
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
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        setupConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchView.getTextField().delegate = self
        collectionView.reloadData()
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
        self.view.addSubview(stackViewCore)
        stackViewCore.addArrangedSubview(searchView)
        stackViewCore.addArrangedSubview(collectionView)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["stackViewCore": stackViewCore]
        var constraints: [NSLayoutConstraint] = []
        
        stackViewCore.translatesAutoresizingMaskIntoConstraints = false
        let v_stackViewCore = "V:|-[stackViewCore]-|"
        let h_stackViewCore = "H:|-0-[stackViewCore]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: v_stackViewCore, options: .alignAllLeading, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: h_stackViewCore, options: .alignAllTop, metrics: nil, views: views)
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        constraints += [NSLayoutConstraint(item: searchView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)]
        
        NSLayoutConstraint.activate(constraints)
    }

}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            
        } else {
            if scrollView == collectionView {
                if (Int(scrollView.contentOffset.y) >= Int(scrollView.contentSize.height - scrollView.frame.size.height)) {
                    
                    
                }
            }
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
        }
        cell.forTest()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: 120)
    }
}
