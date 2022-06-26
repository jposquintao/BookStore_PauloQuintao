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
    
    private var lastContentOffset:CGFloat = 0
    let refreshControl = UIRefreshControl()
    
    lazy var viewModal = {
        BookViewModal()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        initViewModal()
    }
    
    func initViewModal(){
        self.viewModal.getBooks()
        
        viewModal.reloadCollectionView = { [weak self] in
            
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc func handleRefreshControl() {
        self.viewModal.resetBooks()
        self.viewModal.getBooks()
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
        return self.viewModal.bookCellViewModals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else { fatalError("xib does not exists") }
        let cellVM = viewModal.getBookCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailBookVC") as! DetailBookViewController
        
        vc.delegate = self
        let cellVM = viewModal.getBookCellViewModel(at: indexPath)
        vc.book = viewModal.books.filter({$0.id == cellVM.id}).first
        
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
            if Int(contentHeigth) > 0 && Int(positionAtual) >= Int(contentHeigth) && !viewModal.isLoding && !viewModal.listEmpty{
                print("REQUEST DATA OFFSET")
                self.viewModal.getBooks()
            }
        }
        // update the new position acquired
        self.lastContentOffset = collectionView.contentOffset.y
    }
}

extension BookListViewController : CustomHeaderViewDelegate{
    func filterByFavorites(isFavorite: Bool) {
        self.viewModal.filterByFavorite(isFavorites: isFavorite)
    }
}

extension BookListViewController : DetailBookViewControllerDelegate{
    func didCloseDetails(book:Book?, vc: DetailBookViewController) {
        vc.navigationController?.popViewController(animated: true, completion: {
            if let book = book {
                self.viewModal.reloadListBooks(book: book)
            }
        })
    }
}

