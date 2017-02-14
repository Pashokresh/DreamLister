//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Павел Мартыненков on 22.11.16.
//  Copyright © 2016 Pavel Martynenkov. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var selectedStoreLabel: UILabel!
    
    @IBOutlet weak var thumgImg: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
            
            storePicker.dataSource = self
            storePicker.delegate = self
            
            titleField.delegate = self
            priceField.delegate = self
            detailsField.delegate = self
            
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            getStores()
            
            addStore(title: "Amazon")
            addStore(title: "Apple")
            addStore(title: "Avito")
            addStore(title: "AliExpress")
            addStore(title: "Ebay")
            addStore(title: "BestBuy")
            addStore(title: "М-Видео")
            addStore(title: "Эльдорадо")
            
            if itemToEdit != nil {
                
                loadItemData()
                
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == titleField {
            
            priceField.becomeFirstResponder()
        } else if textField == detailsField {
            
            self.view.endEditing(true)
            return false
        }
        
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == priceField {
            
            let validSet = CharacterSet.decimalDigits.inverted
            let components = string.components(separatedBy: validSet)
            
            if components.count > 1 {
                
                return false
            }
            
        }
        
        return true
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let store = stores[row]
        return store.name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedStoreLabel.text = stores[row].name
        
    }
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        } catch  {
            print()
        }
    }
    
    func addStore(title:String) {
        
        var isStoreExists = false
        
        for store in stores {
            
            if store.name == title {
               
                isStoreExists = true
                break
            }
        }
        
        if !isStoreExists {
            
            let store = Store(context: context)
            store.name = title
            
            ad.saveContext()
            
            getStores()
        }
        
    }

    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumgImg.image
        
        if itemToEdit == nil {
          
            item = Item(context: context)
        } else {
            
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            
            item.title = title
        }
        
        if let price = priceField.text {
            
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            
            item.detail = details
        }
        
        item.toStore = stores[storePicker .selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            
            titleField.text =  item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.detail
            thumgImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    
                    index += 1
                    
                } while (index < stores.count)
                
            }
        }
        
    }
    
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil) 
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumgImg.image = img
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
