//
//  testingchart.swift
//  Roomie
//
//  Created by David Shapiro on 9/12/24.
//

import SwiftUI
import Charts

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let revenue: Double
}

struct testingchart: View {
    @State private var products: [Product] = [
        .init(title: "Annual", revenue: 0.7),
        .init(title: "Monthly", revenue: 0.2),
        .init(title: "Lifetime", revenue: 0.1)
    ]
    
    var body: some View {
        Chart(products) { product in
            SectorMark(
                angle: .value(
                    Text(verbatim: product.title),
                    product.revenue
                )
            )
            .foregroundStyle(
                by: .value(
                    Text(verbatim: product.title) .font(.system(size: 20)),
                    product.title
                )
            )
        }
        VStack(alignment: .leading) {
                ForEach(products) { product in
                    HStack {
                        // Sample color indicator
                        Rectangle()
                            .fill(Color.blue) // Replace with actual color
                            .frame(width: 20, height: 20)
                        Text(product.title)
                            .font(.system(size: 20)) // Adjust the size
                    }
                }
            }
    }
}


#Preview {
    testingchart()
}
