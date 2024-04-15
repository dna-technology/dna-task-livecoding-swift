//
//  RootView.swift
//  dna-task-livecoding-swift
//
//  Created by Maciej Rudnicki on 15/04/2024.
//

import Foundation
import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var productsModel: ProductsModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "cart")
                Text(String(format: "%d", productsModel.cartItemsCount()))
                    .foregroundColor(Color.primary)
            }
            .frame(maxWidth: .infinity, minHeight: 32)
            .padding(.horizontal, 8)
            
            
            ScrollView {
                VStack {
                    Text("Products")
                        .foregroundColor(Color.primary)
                    ForEach(productsModel.products, id: \.self) { product in
                        Button(action: {productsModel.addToCart(productID: product.productID)}) {
                            HStack {
                                Text(product.name)
                                    .foregroundColor(Color.primary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 32)
                            .background(Color.mint)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal, 8)
                        }
                        
                    }
                    
                }
                .ignoresSafeArea()
                .onAppear {
                    productsModel.getProducts()
                }
            }
            Spacer()
            Button(action: {}) {
                HStack {
                    Text("BUY")
                        .foregroundColor(Color.primary)
                }
                .frame(maxWidth: .infinity, minHeight: 32)
                .background(Color.mint)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 8)
                .padding(.bottom, 20)
            }
        }
    }
}
