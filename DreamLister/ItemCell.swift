//
//  ItemCell.swift
//  DreamLister
//
//  Created by Павел Мартыненков on 21.11.16.
//  Copyright © 2016 Pavel Martynenkov. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!

    
    func configureCell(item: Item) {
        
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.detail
        thumb.image = item.toImage?.image as? UIImage
    }
}
