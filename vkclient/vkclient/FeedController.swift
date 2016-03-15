//
//  FeedController.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 08.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import UIKit
import VK_ios_sdk

class FeedController : UITableViewController {
    
    private var test: [VKItem] = []
    let testIdentifier = "BaseFeedTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let res = VKApi.requestWithMethod("newsfeed.get", andParameters: nil)
        res.executeWithResultBlock({ (VKResponse) -> Void in
            if let resp = VKResponse {
                if let json = resp.json {
                    let feed = VKFeed(withJSON: json as! NSDictionary)
                    for item in feed.items {
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
        cell?.nameLabel?.text = item.text
        if item.attacments.count > 0 {
            if let photo = item.attacments.first as? VKPhoto {
                let image = UIImage(data: NSData(contentsOfURL: NSURL(string: photo.photo_604)!)!)
                cell?.mainImage?.image = image
            }
        }
        
        return cell!
    }
}

