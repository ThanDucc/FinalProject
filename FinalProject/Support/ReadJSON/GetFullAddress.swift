//
//  ReadJSON.swift
//  FinalProject
//
//  Created by ThanDuc on 18/07/2023.
//

import Foundation

class GetFullAddress {
    
    public static var fullAddress: FullAddress?
    
    let fileName = "FullAddress"
            
    func getData() {
        let url = Bundle.main.url(forResource: fileName, withExtension: ".txt")
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url!)
                let resultData = try? JSONDecoder().decode(FullAddress.self, from: data)
                DispatchQueue.main.async {
                    GetFullAddress.fullAddress = resultData
                }
            } catch {
                print("Error to parse JSON")
            }
        }
    }
    
    func readStringsFromFile(fileURL: URL) -> [String]? {
        do {
            let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            let stringsArray = fileContent.components(separatedBy: .newlines)
            return stringsArray
        } catch {
            print("Lỗi khi đọc file: \(error)")
            return nil
        }
    }
    
    func readArrayFromFile(fileURL: URL) -> [[String]]? {
        do {
            let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = fileContent.components(separatedBy: .newlines)
            
            var arrayOfArrays: [[String]] = []
            
            for line in lines {
                let components = line.components(separatedBy: "/ ")
                arrayOfArrays.append(components)
            }
            
            return arrayOfArrays
        } catch {
            print("Lỗi khi đọc file: \(error)")
            return nil
        }
    }
    
}
