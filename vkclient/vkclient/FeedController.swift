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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(testIdentifier, forIndexPath: indexPath) as? BaseFeedTableViewCell
        
        if cell == nil {
            cell = BaseFeedTableViewCell(style: .Default, reuseIdentifier: testIdentifier)
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
        
        var firstImageUrl: NSURL? = nil
        var firstImageHeight: NSNumber? = nil
        
        if item.attacments.count > 0 {
            if let photo = item.attacments.first as? VKPhoto {
                firstImageUrl = NSURL(string: photo.photo_604!)
                let ratio = photo.width.floatValue / photo.height.floatValue
                firstImageHeight = cell!.mainImage.frame.size.width / CGFloat(ratio)
            }
        }
        
        updateCell(cell!,name: item.text, title: head.sourceName, date: item.date, mainImageUrl: firstImageUrl, mainImageHeight: firstImageHeight, avatarImageUrl: NSURL(string: head.sourceImageUrl)!)

        
        return cell!
    }
    
    
    
    private func updateCell(cell: BaseFeedTableViewCell, name: String, title: String, date: NSDate, mainImageUrl: NSURL?, mainImageHeight: NSNumber?,
                            avatarImageUrl: NSURL) {
        cell.mainImage.image = nil
        cell.cellHeaderView.avatarImageView?.image = nil
        
        cell.nameLabel?.text = name
        cell.cellHeaderView.titleLabel?.text = title
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm dd.MM.yyyy"
        cell.cellHeaderView.dateLabel?.text = dateFormatter.stringFromDate(date)
        cell.cellHeaderView.avatarImageView?.af_setImageWithURL(avatarImageUrl)
        guard mainImageUrl != nil else {
            return
        }
        
        cell.mainImage?.af_setImageWithURL(mainImageUrl!)
    }
}

