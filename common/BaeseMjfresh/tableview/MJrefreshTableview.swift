//
//  LDTableView.swift
//  grapefruit
//
//  Created by Cator Vee on 3/20/16.
//  Copyright © 2016 Huace. All rights reserved.
//

import MJRefresh

protocol MJTableViewRefreshDelegate: NSObjectProtocol {
	func tableView(_ tableView: TableViewMjResh, refreshDataWithType refreshType: TableViewMjResh.RefreshType)
}

class TableViewMjResh: UITableView {

	enum RefreshType {
		case header
		case footer
	}

	weak var refreshTableDelegate: MJTableViewRefreshDelegate?
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
                self.refreshTableDelegate?.tableView(self, refreshDataWithType: .header)
            })
            header.stateLabel!.isHidden = true
            header.arrowView!.image = nil
            header.lastUpdatedTimeLabel!.isHidden = true
            self.mj_header = header
		}
		if footerEnabled {
			let footer = MJRefreshBackStateFooter(refreshingBlock: {
                self.refreshTableDelegate?.tableView(self, refreshDataWithType: .footer)
			})
			footer.stateLabel!.isHidden = false
			self.mj_footer = footer
			self.mj_footer.isAutomaticallyHidden = false
		}
	}

	func endRefreshing(num: Int = 0, count: Int = -1) {
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
				self.reloadSections(reloadIndexSet, with: .none)
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
			self.endRefreshing(num: newData.count, count: data.count)
		}
	}

	func pageOffset<T>(_ refreshType: RefreshType, data: [T]) -> Int {
		switch refreshType {
		case .header: return 0
		case .footer: return data.count
		}
	}

	func showNoDataNoticeView() {
		noDataNoticeView = LDNoDataNoticeView.viewWithTitle(noDataNotice ?? noDataTitle, frame: self.bounds, imageYOffset: noDataImageYOffset > 0 ? noDataImageYOffset : 198.0, KindS: KindS)
		self.addSubview(noDataNoticeView!)
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
