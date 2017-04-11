//
//  LDTableView.swift
//  grapefruit
//
//  Created by Cator Vee on 3/20/16.
//  Copyright © 2016 Huace. All rights reserved.
//

import MJRefresh

protocol MJCollectionViewRefreshDelegate: NSObjectProtocol {
    func Collection(_ Collection: CollectionMjResh, refreshDataWithType refreshType: CollectionMjResh.RefreshType)
}

class CollectionMjResh: UICollectionView {
    
    enum RefreshType {
        case header
        case footer
    }
    
    weak var refreshDelegate: MJCollectionViewRefreshDelegate?
    var pageSize = 10
    var reloadIndexSet: IndexSet?
    var imageArray = [UIImage]()
    var isShowNoData = true
    var noDataTitle = "很抱歉，未找到相关的内容"
    var noDataNotice: String?
    var noDataImageYOffset: CGFloat = 0.0
    var KindS = 1
    fileprivate var noDataNoticeView: LDNoDataNoticeView?
    
    func configRefreshable(headerEnabled: Bool, footerEnabled: Bool) {
        if headerEnabled {
            let header = MJRefreshNormalHeader(refreshingBlock: {
                self.refreshDelegate?.Collection(self, refreshDataWithType: .header)
            })
            header.stateLabel!.isHidden = true
            header.arrowView!.image = nil
            header.lastUpdatedTimeLabel!.isHidden = true
            self.mj_header = header
        }
        if footerEnabled {
            let footer = MJRefreshBackNormalFooter(refreshingBlock: {
                self.refreshDelegate?.Collection(self, refreshDataWithType: .footer)
            })
            footer.stateLabel!.isHidden = true
            footer.arrowView!.image = nil
            self.mj_footer = footer
        }
    }

    func endRefreshing(num: Int = 0, count: Int = -1,NoDataNoticeViewKinds: Int = 3) {
        if let header = self.mj_header {
            header.endRefreshing()
        }
        if let footer = self.mj_footer {
            if num < self.pageSize {
                footer.endRefreshingWithNoMoreData()
            } else {
                footer.state = .idle
                footer.resetNoMoreData()
                footer.endRefreshing()
            }
        }
        
        if self.isShowNoData && count >= 0 {
            if count > 0 {
                self.hideNoDataNoticeView()
            } else {
                self.showNoDataNoticeView()
            }
        }
        if let reloadIndexSet = self.reloadIndexSet {
            if let _ = self.mj_footer {
                self.reloadData()
            } else {
                self.reloadSections(reloadIndexSet)
            }
        } else {
            self.reloadData()
        }
    }
    
    func refreshData(_ refreshType: RefreshType = .header) {
        switch refreshType {
        case .header:
            if let header = self.mj_header {
                header.beginRefreshing()
            }
        case .footer:
            if let footer = self.mj_footer {
                footer.beginRefreshing()
            }
        }
    }
    
    func updateData<T>(_ data: inout [T], newData: [T], refreshType: RefreshType, endRefreshing: Bool = true) {
        switch refreshType {
        case .header: data = newData
        case .footer: data += newData
        }
        if endRefreshing {
            self.endRefreshing(num: newData.count, count: data.count,NoDataNoticeViewKinds: 3)
        }
    }
    
    func pageOffset<T>(_ refreshType: RefreshType, data: [T]) -> Int {
        switch refreshType {
        case .header: return 0
        case .footer: return data.count
        }
    }
    
    func showNoDataNoticeView() {
        if KindS == 0{
            noDataNoticeView = LDNoDataNoticeView.viewWithTitle(noDataNotice ?? noDataTitle, frame: self.bounds, imageYOffset: noDataImageYOffset > 0 ? noDataImageYOffset : 100.0, KindS: KindS)
            self.addSubview(noDataNoticeView!)
        }else if KindS == 1{
            noDataNoticeView = LDNoDataNoticeView.viewWithTitle(noDataNotice ?? noDataTitle, frame: self.bounds, imageYOffset: noDataImageYOffset > 0 ? noDataImageYOffset : 198.0, KindS: KindS)
            self.addSubview(noDataNoticeView!)
        }
    }
    
    func hideNoDataNoticeView() {
        if let view = noDataNoticeView {
            view.removeFromSuperview()
        }
        noDataNoticeView = nil
    }
    func endRefreshMKstype() {
        
    }
    
}
