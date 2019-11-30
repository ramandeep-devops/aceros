
import Foundation
import UIKit

extension UITableView {
    func sizeHeaderToFit() {
        let headerView = self.tableHeaderView
        headerView?.setNeedsLayout()
        headerView?.layoutIfNeeded()
        let height = headerView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerView?.frame
        frame?.size.height = height ?? 0.0
        headerView?.frame = frame ?? CGRect.init()
        self.tableHeaderView = headerView
    }
    
    func registerXIB(_ nibName: String) {
        self.register(UINib.init(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func registerXIBForHeaderFooter(_ nibName: String) {
        self.register(UINib.init(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    
    func updateHeaderViewHeight() {
        if let headerView = self.tableHeaderView {
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                self.tableHeaderView = headerView
            }
        }
    }
}

extension UICollectionView {
    func registerXIB(_ nibName: String) {
        self.register(UINib.init(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
}
