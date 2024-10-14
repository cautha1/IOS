//
//  SecondViewController.swift
//  Assignment1
//
//  Created by Cauthan Janet BULUMA (001171028) on 20/3/2024.
//

import UIKit
import SQLite3
class SecondViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db: OpaquePointer? = nil
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    //this was changed to picker view controller
   /// @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var groupPickerView: UIPickerView!
    
    
    var groupArray: [String] = ["Clothing","Electronics","Groceries","Others"]
    // this is the button c
    @IBAction func addClicked(_ sender: UIButton) {
        var itemName:String?
        var itemPrice:Double?
        var itemType:String?
        var itemQty:Int?
        itemName = itemNameTextField.text
        itemPrice = NSString(string:priceTextField.text!).doubleValue
        itemType = groupArray[groupPickerView.selectedRow(inComponent: 0)]
        itemQty = NSString(string: quantityTextField.text!).integerValue
        
        print(itemType!)
        
        insertQuery(itemName: itemName!, price: itemPrice!, category: itemType!, quantity: itemQty!)
        let s = Product(itemName: itemName!, price: itemPrice!, category: itemType!, quantity: itemQty!)
        appDelegate.productArray.append(s)
        
        statusLabel.text = "Record added"
        
        itemNameTextField.text = ""
        priceTextField.text = ""
        quantityTextField.text = ""
            
            
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
    }
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupArray.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return groupArray[row] as String
    }
    
    
    func insertQuery(itemName:String, price:Double,category:String, quantity:Int){
        let insertSQL = "INSERT INTO itemlist(ItemName, ItemPrice, ItemType,Quantity) VALUES ('\(itemName)', \(price), '\(category)',\(quantity))"
        print (insertSQL)
        var queryStatment: OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK
        {
            print("Successfully opened connection to database")
            // compile the query
            
            if(sqlite3_prepare_v2(db, insertSQL,-1, &queryStatment, nil) == SQLITE_OK){
                //EXCUET QUERY
                if sqlite3_step(queryStatment) == SQLITE_DONE{
                    print("record inserted!")
                    statusLabel.text = "Record Inserted"
                }
                else
                {
                    print("fail to insert")
                }
                //comit changed to the table
                sqlite3_finalize(queryStatment)
            }
            else
            {
               print("Unable to open database")
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
    }
    

}
