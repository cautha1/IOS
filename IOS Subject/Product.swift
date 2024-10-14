//
//  Product.swift
//  Assignment1
//
//  Created by Cauthan Janet BULUMA (001171028) on 20/3/2024.
//

import Foundation
public class Product {
    public var itemName: String
    public var price: Double
    public var category: String
    public var quantity: Int
    //default
    public init() {
        self.itemName = ""
        self.price = 0.0
        self.category = ""
        self.quantity = 0
    }
    public init(itemName: String, price: Double, category: String, quantity:Int) {
        self.itemName = itemName
        self.price = price
        self.category = category
        self.quantity = quantity
    }
    
    
    func toString() ->String
    {
        return "Item Name :" + self.itemName + " Price:" + String(format:"$%.2f",self.price) + "Category:" + self.category + "Quantity:" + String(format:"%d", self.quantity)
        
    }
    
}
