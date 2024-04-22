//
//  ViewController.swift
//  UIKitTarget
//
//  Created by Nataliia Lapshyna on 21/04/2024.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var productsModel: ProductsModel = ProductsModel()
    var productsSubscription : AnyCancellable! = nil
    var cartSubscription : AnyCancellable! = nil
    
    @IBOutlet weak var productsTable: UITableView!
    
    @IBOutlet weak var cartButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        productsTable.dataSource = self
        productsTable.delegate = self
        
        productsModel.getProducts()
    }
    
    override func viewDidLoad() {
        productsSubscription = productsModel.$products.sink{ _ in
            self.productsTable.reloadData()
        }
        cartSubscription = productsModel.$cart.sink{ _ in
            self.cartButton.setTitle("\(self.productsModel.cartItemsCount())", for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        productsSubscription.cancel()
        cartSubscription.cancel()
    }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        cell.textLabel?.text = productsModel.products[indexPath.item].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productsModel.addToCart(productID: productsModel.products[indexPath.item].productID)
    }
    
    @IBAction func payAction(_ sender: Any) {
    }
    
}

