//
//  JSONConvertable.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 10.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import UIKit

protocol JSONConvertable {
    init(withJSON json: NSDictionary)
}
