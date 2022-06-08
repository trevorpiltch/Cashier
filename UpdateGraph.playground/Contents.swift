import UIKit

var data: [(String, Double)] = [("3/10/2021", 10.00), ("3/09/2021", 20.00), ("3/10/2021", 10.00)]
var amounts: [(String, Double)] = []

for i in data.indices {
    amounts.append((data[i].0, data[i].1))
    
    var deletedAmount = 0

    for j in amounts.indices {
        if (amounts[j - deletedAmount].0 == amounts.last!.0 && (j - deletedAmount) != amounts.count - 1) {
            amounts[amounts.count - 1].1 += amounts[j - deletedAmount].1
            amounts.remove(at: j - deletedAmount)
            deletedAmount += 1
        }
    }
}

print(amounts)
