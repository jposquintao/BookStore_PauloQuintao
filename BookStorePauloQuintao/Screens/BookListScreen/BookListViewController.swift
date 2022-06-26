//
//  ViewController.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import UIKit

class BookListViewController: UIViewController {

    @IBOutlet weak var customHeaderView: CustomHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var isRefreshing:Bool = false
    let refreshControl = UIRefreshControl()
    
    private var isLoding:Bool = false
    private var listEmpty:Bool = false
    private var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    @objc func handleRefreshControl() {
        self.isRefreshing = true
        self.isLoding = true
        self.listEmpty = false
        //self.viewModel.resetItems()
        //self.viewModel.getStockItems(isRefreshing: true)
    }
    
    func setupView(){
        customHeaderView.delegate = self
        customHeaderView.setupForList()
        
        registerCollectionViewCells()
        configureRefreshControl()
    }
    
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        refreshControl.tintColor = .black
        collectionView.refreshControl = refreshControl
        collectionView.addSubview(refreshControl)
        collectionView.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                             for: .valueChanged)
    }
    
    func registerCollectionViewCells(){
        collectionView.register(BookCell.nib, forCellWithReuseIdentifier: BookCell.identifier)
    }
}

extension BookListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else { fatalError("xib does not exists") }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailBookVC") as! DetailBookViewController
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 15)/2, height: collectionView.frame.width * 0.65)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (Int(self.lastContentOffset) < Int(collectionView.contentOffset.y)) {
            let positionAtual:CGFloat = collectionView.contentOffset.y
            let contentHeigth:CGFloat = collectionView.contentSize.height - collectionView.frame.size.height
            
            // Check if is in the end and can load more items
            if Int(contentHeigth) > 0 && Int(positionAtual) >= Int(contentHeigth) && !isLoding && !listEmpty{
                print("REQUEST DATA OFFSET")
                self.isLoding = true
                //self.viewModel.getStockItems(isRefreshing: false)
            }
        }
        // update the new position acquired
        self.lastContentOffset = collectionView.contentOffset.y
    }
}

extension BookListViewController : CustomHeaderViewDelegate{
    func filterByFavorites(isFavorite: Bool) {
        
    }
}

extension BookListViewController : DetailBookViewControllerDelegate{
    func didCloseDetails(vc: DetailBookViewController) {
        vc.navigationController?.popViewController(animated: true, completion: {
            self.collectionView.reloadData()
        })
    }
}

