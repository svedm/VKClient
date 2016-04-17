//
//  FeedController.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 08.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import UIKit
import VK_ios_sdk
import AlamofireImage

class FeedController : UITableViewController {
    
    private var test: NSMutableArray = NSMutableArray()
    private var nextFeedItem: String?
    private var vkFeedSources = [VKFeedSource]()
    private var cellHeightCache: [NSIndexPath : CGFloat] = [:]
    private var loadMoreStatus = false
    
    let testIdentifier = "BaseFeedTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFeed(nil) {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return test.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        struct oneCell {
            static var once_token: dispatch_once_t = 0
            static var cell = TextTableViewCell()
        }
        
        dispatch_once(&oneCell.once_token) {
            oneCell.cell = tableView.dequeueReusableCellWithIdentifier(self.testIdentifier) as! TextTableViewCell
        }
        
        let item = test[indexPath.row] as! VKItem
        
        if (item.text != "") {
            
            let height = CGSizeMake(oneCell.cell.postText.frame.size.width, CGFloat.max)
            let font = UIFont.systemFontOfSize(17)
            let size = NSString(string: item.text).boundingRectWithSize(height, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            
            return 80.0 + size.size.height
        }
        
        return 90
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(testIdentifier, forIndexPath: indexPath) as? TextTableViewCell
        
        if cell == nil {
            cell = TextTableViewCell(style: .Default, reuseIdentifier: testIdentifier)
        }
        
        let item = test[indexPath.row] as! VKItem
        
        let source = self.vkFeedSources.filter { (source) -> Bool in
            source.id == item.sourceId
        }.first
        
        cell?.updateContent(source!.name, date: item.date, avatarUrl: NSURL(string: source!.photo)!, text: item.text)
        
        return cell!
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //super.scrollViewDidScroll(scrollView)
        
        if self.nextFeedItem == nil {
            return;
        }
    
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= maximumOffset * 0.2 {
            loadMore()
        }
    }
    
    func loadMore() {
        if (!loadMoreStatus && self.nextFeedItem != nil) {
            self.loadMoreStatus = true
            loadFeed(["start_from": self.nextFeedItem!]){
                self.loadMoreStatus = false
                self.tableView.reloadData()
            }
        }
    }

    
    func loadFeed(params: [NSObject: AnyObject]?, withCallback callback: () -> Void){
        dispatch_async(dispatch_get_main_queue()) {
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let res = VKApi.requestWithMethod("newsfeed.get", andParameters: params)
            res.executeWithResultBlock({ (VKResponse) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let resp = VKResponse {
                    if let json = resp.json {
                        let vkFeed = VKFeed(withJSON: json as! NSDictionary)
                        self.vkFeedSources.appendContentsOf(vkFeed.vkFeedSources)
                        self.nextFeedItem = vkFeed.nextFrom
                        for item in vkFeed.items {
                            self.test.addObject(item)
                        }
                        callback()
                    }
                }
            }) { (NSError) -> Void in
                
            }
        }
        
    }
    
}

