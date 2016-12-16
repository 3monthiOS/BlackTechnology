//
//  LDTableView.swift
//  grapefruit
//
//  Created by Cator Vee on 3/20/16.
//  Copyright © 2016 Huace. All rights reserved.
//

import MJRefresh

protocol MJTableViewRefreshDelegate: NSObjectProtocol {
	func tableView(tableView: TableViewMjResh, refreshDataWithType refreshType: TableViewMjResh.RefreshType)
}

class TableViewMjResh: UITableView {

	enum RefreshType {
		case Header
		case Footer
	}

	weak var refreshTableDelegate: MJTableViewRefreshDelegate?
	var pageSize = 10
	var reloadIndexSet: NSIndexSet?
	var imageArray = [UIImage]()
	var isShowNoData = true
	var noDataTitle = "很抱歉，未找到相关的内容"
	var noDataNotice: String?
	var noDataImageYOffset: CGFloat = 0.0
    var KindS = 1
	private var noDataNoticeView: LDNoDataNoticeView?

	func configRefreshable(headerEnabled headerEnabled: Bool, footerEnabled: Bool) {
        
		if headerEnabled {
            let header = MJRefreshNormalHeader(refreshingBlock: {
                self.refreshTableDelegate?.tableView(self, refreshDataWithType: .Header)
            })
            header.stateLabel!.hidden = true
            header.arrowView!.image = nil
            header.lastUpdatedTimeLabel!.hidden = true
            self.mj_header = header
		}
		if footerEnabled {
			let footer = MJRefreshBackStateFooter(refreshingBlock: {
                self.refreshTableDelegate?.tableView(self, refreshDataWithType: .Footer)
			})
			footer.stateLabel!.hidden = false
			self.mj_footer = footer
			self.mj_footer.automaticallyHidden = false
		}
	}

	func endRefreshing(num num: Int = 0, count: Int = -1) {
        if let header = self.mj_header {
            header.endRefreshing()
        }
		if let footer = self.mj_footer {
			if num < self.pageSize {
				footer.endRefreshingWithNoMoreData()
			} else {
                footer.state = .Idle
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
				self.reloadSections(reloadIndexSet, withRowAnimation: .None)
			}
		} else {
			self.reloadData()
		}
	}

	func refreshData(refreshType: RefreshType = .Header) {
		switch refreshType {
		case .Header:
			if let header = self.mj_header {
				header.beginRefreshing()
			}
		case .Footer:
			if let footer = self.mj_footer {
				footer.beginRefreshing()
			}
		}
	}

	func updateData<T>(inout data: [T], newData: [T], refreshType: RefreshType, endRefreshing: Bool = true) {
		switch refreshType {
		case .Header: data = newData
		case .Footer: data += newData
		}
		if endRefreshing {
			self.endRefreshing(num: newData.count, count: data.count)
		}
	}

	func pageOffset<T>(refreshType: RefreshType, data: [T]) -> Int {
		switch refreshType {
		case .Header: return 0
		case .Footer: return data.count
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
