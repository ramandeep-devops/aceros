

import UIKit

typealias WillDisplayCellBlock = (_ cell : UICollectionViewCell , _ indexpath : IndexPath) -> ()
typealias didEndDisplayCellBlock = (_ cell : UICollectionViewCell , _ indexpath : IndexPath) -> ()

typealias ViewForHeaderInSectionCollectionView = (_ view : Any? , _ indexpath: Any?) -> ()

class CollectionViewDataSource: ScrollViewDataSource  {
    
    var items : Array<Any>?
    var cellIdentifier : String?
    var headerIdentifier : String?
    var collectionView  : UICollectionView?
    var cellHeight : CGFloat = 0.0
    var cellWidth : CGFloat = 0.0
    var edgeInsetsMake  = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var minimumLineSpacing : CGFloat = 0.0
    var minimumInteritemSpacing : CGFloat = 0.0
  
    var configureCellBlock : ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    var willDisplayCellListener : WillDisplayCellBlock?
    var didEndDisplayCellListener : didEndDisplayCellBlock?
   
    var viewforHeaderInSection : ViewForHeaderInSectionCollectionView?
    var sectionHeaderHeight : CGSize? = .zero
   
    init (items : Array<Any>?  , collectionView : UICollectionView? , cellIdentifier : String? , headerIdentifier : String? , cellHeight : CGFloat , cellWidth : CGFloat ,minimumLineSpacing : CGFloat ,minimumInteritemSpacing : CGFloat ,edgeInsetsMake : UIEdgeInsets  ,sectionHeaderHeight : CGSize)  {
        
        self.collectionView = collectionView
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.headerIdentifier = headerIdentifier
        self.cellWidth = cellWidth
        self.cellHeight = cellHeight
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.edgeInsetsMake = edgeInsetsMake
        self.sectionHeaderHeight = sectionHeaderHeight
        
    }
    
    override init() {
        super.init()
    }
}

extension CollectionViewDataSource : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier ,
                                                      for: indexPath) as UICollectionViewCell
        if let block = self.configureCellBlock , let item: Any = self.items?[indexPath.row]{
            block(cell , item , indexPath )
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = self.aRowSelectedListener{
            block(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let block = willDisplayCellListener else { return }
        cell.isExclusiveTouch = true
        block(cell , indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let block = didEndDisplayCellListener else { return }
        cell.isExclusiveTouch = true
        block(cell , indexPath)
    }
   
}

extension CollectionViewDataSource : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return  CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return edgeInsetsMake
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return minimumInteritemSpacing
    }
}


