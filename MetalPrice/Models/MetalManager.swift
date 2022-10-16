//
//  MetalManager.swift
//  MetalPrice
//
//  Created by Giorgi Samkharadze on 16.10.22.
//

import Foundation

protocol MetalManagerDelegate {
    
    func didUpdatePrice(price: String)
    func didFailWithError(error: Error)
    
}

struct MetalManager {
    
    var delegate: MetalManagerDelegate?
    
    let baseURL = "https://api.metalpriceapi.com/v1/convert?api_key=7acdf76183bbc3cd09fbb0942ab2924d&amount=35.274&"
    let elmetal = ["Gold", "Silver", "Platinum", "Palladium"]
    
    let metal = ["XAU","XAG", "XPT", "XPD"]
    let currency = ["GEL", "USD","EUR","RUB","GBP"]
    
    
    
    func getPrice(for currency: String, for metal: String){
        
        
        
        let urlString = "\(baseURL)from=\(currency)&to=\(metal)"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let metalresult = self.parseJSON(safeData) {
                        let resString = String(format: "%.2f", metalresult)
                        
                        self.delegate?.didUpdatePrice(price: resString)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MetalData.self, from: data)
            let lastRes = decodedData.result
            print(lastRes)
            return lastRes
        } catch {
            
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
