//
//  FirstViewController.swift
//  Assignment1
//
//  Created by Cauthan Janet BULUMA (001171028) on 20/3/2024.
//

import UIKit
import SQLite3
class FirstViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    
    
    @IBOutlet weak var productTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var productArray:[Product] = []
    var db: OpaquePointer? = nil
    func getDBPath()->String
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentsDir = paths[0]
        
        let databasePath = (documentsDir as NSString).appendingPathComponent("shoppingDB.db")
        
        return databasePath;
        
    }
    
    func selectQuery() {
        
        let selectQueryStatement = "SELECT * FROM itemlist"
        
        var queryStatement: OpaquePointer? = nil
        
        //Prepare the sql query
        
        if (sqlite3_prepare_v2(db, selectQueryStatement, -1, &queryStatement, nil) == SQLITE_OK)
            
        {
            
            print("Query Result:")
            
            //Run the query
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW)
                    
            {
                
                let itemKey = sqlite3_column_int(queryStatement, 0)
                
                let itemNameTextField = sqlite3_column_text(queryStatement, 1)
                
                let itemName = String(cString: itemNameTextField!)
                
                let itemPrice = Double(sqlite3_column_int(queryStatement, 2))
                
                let itemTypeField = sqlite3_column_text(queryStatement, 3)
                
                let itemType = String(cString: itemTypeField!)
                
                let quantityTextField = sqlite3_column_text(queryStatement, 4)
                let itemQty = Int(bitPattern: quantityTextField!)
                
                print("\(itemKey) | \(itemName)")
                
                //let m = Product(title:movieTitle, year:movieYear, genre:movieGenre)
                let s = Product(itemName: itemName, price: Double(itemPrice), category: itemType, quantity: itemQty)
                appDelegate.productArray.append(s)
                
            }
            
        }
        
        else
        
        {
            
            print("SELECT statement could not be prepared")
            
        }
        
        
        
        sqlite3_finalize(queryStatement)
        
        sqlite3_close(db)
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if sqlite3_open(getDBPath(),&db) == SQLITE_OK{
            print("Successfully opened connection to database")
            //run the selsct quiery
            selectQuery()
        }
        else {
            print( "Unable to open database")
        }
    }
    
    
    func numberOfSelectionInTableView(tableView: UITableView) -> Int{
        return 1
    }
    //number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.productArray.count;
    }
    //Populate the table rows( cells)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath  )
        
        let product:Product = appDelegate.productArray[indexPath.row]
        cell.textLabel!.text = product.itemName
        
        cell.detailTextLabel?.text = product.toString()
        //cell.imageView?.image = UIImage(named: product.imageName)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productTableView.reloadData()
        
        super.viewWillAppear(animated)
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
    }
    func deleteQuery(itemName:String){
        let deleteSQL = "DELETE FROM itemlist WHERE itemName = ('\(itemName)')"
        print (deleteSQL)
        var queryStatement:OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK{
            print("Successfully opened connection database ", terminator: "")
            
            if (sqlite3_prepare_v2(db, deleteSQL, -1, &queryStatement, nil) == SQLITE_OK){
                if sqlite3_step(queryStatement) == SQLITE_DONE{
                    print("Record Deleted!")
                }
                else {
                    print ("Fail to delete")
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                print("Delete statement  could not prepared", terminator: "")
            }
            sqlite3_close(db)
            
            
        }
        else{
            print("Unable to open database", terminator: "")
        }
    }
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete from db
            let selectedItem:Product = appDelegate.productArray[indexPath.row]
            let itemName:String = selectedItem.itemName
            deleteQuery(itemName:itemName)
            //remove from array annd table
            appDelegate.productArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    }
