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
    
    private var test: [VKItem] = []
    private var vkFeed: VKFeed?
    
    let testIdentifier = "BaseFeedTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let res = VKApi.requestWithMethod("newsfeed.get", andParameters: nil)
        res.executeWithResultBlock({ (VKResponse) -> Void in
            if let resp = VKResponse {
                if let json = resp.json {
                    self.vkFeed = VKFeed(withJSON: json as! NSDictionary)
                    for item in (self.vkFeed?.items)! {
                        self.test.append(item)
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
        var cell = tableView.dequeueReusableCellWithIdentifier(testIdentifier) as? BaseFeedTableViewCell
        
        if cell == nil {
            cell = BaseFeedTableViewCell(style: .Default, reuseIdentifier: testIdentifier)
        }
        
        let item = test[indexPath.row]
        
        var sourceName: String = ""
        var sourceImageUrl: String = ""
        
        if let source = vkFeed?.profiles.filter({ (user) -> Bool in
            user.id == abs(item.sourceId)
        }).first {
            sourceName = "\(source.first_name) \(source.last_name)"
            sourceImageUrl = source.photo_100
        } else if let source = vkFeed?.groups.filter({ (group) -> Bool in
            group.id == abs(item.sourceId)
        }).first {
            sourceName = source.name
            sourceImageUrl = source.photo_100
        }
        
        cell?.mainImage?.image = nil
        cell?.avatarImageView?.image = nil
        
        cell?.nameLabel?.text = item.text
        cell?.titleLabel?.text = sourceName
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm dd.MM.yyyy"
        cell?.dateLabel?.text = dateFormatter.stringFromDate(item.date)


        cell?.avatarImageView?.af_setImageWithURL(NSURL(string: sourceImageUrl)!)
        
        if item.attacments.count > 0 {
            if let photo = item.attacments.first as? VKPhoto {
                cell?.mainImage?.af_setImageWithURL(NSURL(string: photo.photo_604)!)
            }
        }
        
        return cell!
    }
}

