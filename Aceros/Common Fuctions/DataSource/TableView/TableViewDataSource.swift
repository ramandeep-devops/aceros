


import UIKit

typealias  ListCellConfigureBlock = (_ cell : Any , _ item : Any? , _ indexpath: IndexPath) -> ()
typealias  DidSelectedRow = (_ indexPath : IndexPath) -> ()
typealias  ScrollViewDidScroll = (_ scrollView : UIScrollView) -> ()
typealias  ScrollViewStartScroll = (_ scrollView : UIScrollView) -> ()

typealias  ViewForHeaderInSection = (_ section : Int) -> UIView?
typealias  ViewForFooterInSection = (_ section : Int) -> UIView?
typealias  HeightForRow = (_ indexPath : IndexPath) -> CGFloat
typealias  WillDisplayTableViewCellBlock = (_ cell : UITableViewCell , _ indexpath : IndexPath) -> ()

class TableViewDataSource: NSObject  {
    
    var items : Array<Any>?
    var arrIndex:Array<Any>?
    var noOfSections : Array<Any>?
    var cellIdentifier : String?
    var tableView  : UITableView?
    var tableViewRowHeight : CGFloat = 44.0
    
    var configureCellBlock: ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    var ScrollViewListener : ScrollViewDidScroll?
    var viewforHeaderInSection : ViewForHeaderInSection?
    var viewforFooterInSection : ViewForFooterInSection?
    var headerHeight : CGFloat? = 0.0
    var footerHeight : CGFloat? = 0.0
    var willDisplayCell: WillDisplayTableViewCellBlock?
    var heightForRow: HeightForRow?
    
    var isFromType = false
    
    
    init (items : Array<Any>? , height : CGFloat , tableView : UITableView? , cellIdentifier : TableCellID?,isFromType : Bool = false) {
        self.tableView = tableView
        self.items = items
        self.cellIdentifier = cellIdentifier?.rawValue
        self.tableViewRowHeight = height
        self.isFromType = isFromType
    }
    
    init (items : Array<Any>? ,sections :Array<Any>, sectionHeaderHeight :CGFloat, height : CGFloat , tableView : UITableView? , cellIdentifier : TableCellID?,isFromType : Bool = false) {
        self.tableView = tableView
        self.items = items
        self.cellIdentifier = cellIdentifier?.rawValue
        self.tableViewRowHeight = height
        self.isFromType = isFromType
        self.noOfSections = sections
        self.headerHeight = sectionHeaderHeight
    }
    
    
    
    override init() {
        super.init()
    }
}

extension TableViewDataSource : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock , let item: Any = self.items?[indexPath.row]{
            block(cell , item , indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let block = self.willDisplayCell{
            block(cell, indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let block = self.aRowSelectedListener{
            block(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.noOfSections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
       /* guard let block = heightForRow else { return 0 }
        return block(indexPath) */
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let block = viewforHeaderInSection else { return nil }
        return block(section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let block = viewforFooterInSection else { return nil }
        return block(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  200.0
    }
    
    
}

extension TableViewDataSource : UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
//        guard let block = ScrollViewListener else { return }
//        block(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let block = ScrollViewListener else { return }
        block(scrollView)

    }
}



