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
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 610
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return test.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if cellHeightCache.indexForKey(indexPath) != nil {
           return cellHeightCache[indexPath]!
        }
        
        
        struct oneCell {
            static var once_token: dispatch_once_t = 0
            static var cell = BaseFeedTableViewCell()
        }
        
        dispatch_once(&oneCell.once_token) {
            oneCell.cell = tableView.dequeueReusableCellWithIdentifier(self.testIdentifier) as! BaseFeedTableViewCell
        }
    
        let item = test[indexPath.row] as! VKItem;
        oneCell.cell.nameLabel.text = item.text
        
        var imageHeight: CGFloat = 0.0
        
        if item.attacments.count > 0 {
            if let photo = item.attacments.first as? VKPhoto {
                let ratio = photo.width.floatValue / photo.height.floatValue
                imageHeight = 560 / CGFloat(ratio)
            }
        }
        
        let cellHeight = 100 + oneCell.cell.nameLabel.frame.height + imageHeight
        
        self.cellHeightCache[indexPath] = cellHeight
        
        return cellHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(testIdentifier) as? BaseFeedTableViewCell
        
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
        
        if item.attacments.count > 0 {
            if let photo = item.attacments.first as? VKPhoto {
                firstImageUrl = NSURL(string: photo.photo_604!)
            }
        }
        
        updateCell(cell!,name: item.text, title: head.sourceName, date: item.date, mainImageUrl: firstImageUrl, avatarImageUrl: NSURL(string: head.sourceImageUrl)!)

        
        return cell!
    }
    
    
    
    private func updateCell(cell: BaseFeedTableViewCell, name: String, title: String, date: NSDate, mainImageUrl: NSURL?,
                      avatarImageUrl: NSURL) {
        cell.mainImage.image = nil
        cell.avatarImageView.image = nil
        
        cell.nameLabel?.text = name
        cell.titleLabel?.text = title
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm dd.MM.yyyy"
        cell.dateLabel?.text = dateFormatter.stringFromDate(date)
        cell.avatarImageView?.af_setImageWithURL(avatarImageUrl)
        guard mainImageUrl != nil else {
            cell.updateConstraintsIfNeeded()
            return
        }
        
        cell.mainImage?.af_setImageWithURL(mainImageUrl!)
    }
    
    private func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}

