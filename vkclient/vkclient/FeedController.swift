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
    private var vkFeed: VKFeed?
    private var cellHeightCache: [NSIndexPath : CGFloat] = [:]
    
    let testIdentifier = "BaseFeedTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let res = VKApi.requestWithMethod("newsfeed.get", andParameters: nil)
        res.executeWithResultBlock({ (VKResponse) -> Void in
            if let resp = VKResponse {
                if let json = resp.json {
                    self.vkFeed = VKFeed(withJSON: json as! NSDictionary)
                    for item in (self.vkFeed?.items)! {
                        self.test.addObject(item)
                    }
                    self.tableView.reloadData()
                }
            }
        }) { (NSError) -> Void in
            
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
            return 200
        }
        
        return 80
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(testIdentifier, forIndexPath: indexPath) as? TextTableViewCell
        
        if cell == nil {
            cell = TextTableViewCell(style: .Default, reuseIdentifier: testIdentifier)
        }
        
        let item = test[indexPath.row] as! VKItem
        
        struct cellHead {
            var sourceName: String = ""
            var sourceImageUrl: String = ""
        }
        
        var head: cellHead
        
        if item.sourceId > 0 {
            head = (vkFeed?.profiles.filter({ (user) -> Bool in
                user.id == item.sourceId
            }).map({ (user) -> cellHead in
                return cellHead(sourceName: "\(user.first_name) \(user.last_name)", sourceImageUrl: user.photo_100)
            }).first)!
        } else {
            head = (vkFeed?.groups.filter({ (group) -> Bool in
                group.id == abs(item.sourceId)
            }).map({ (group) -> cellHead in
                return cellHead(sourceName: group.name, sourceImageUrl: group.photo_100)
            }).first)!
        }

        
        cell?.updateContent(head.sourceName, date: item.date, avatarUrl: NSURL(string: head.sourceImageUrl)!, text: item.text)
        
        return cell!
    }
}

