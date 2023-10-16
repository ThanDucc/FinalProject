//
//  CollaborativeFilter.swift
//  FinalProject
//
//  Created by ThanDuc on 08/10/2023.
//

import Foundation
import Accelerate

// Dữ liệu người dùng và các phòng trọ
struct Interaction: Codable {
    
    var userId: String
    var productId: String
    var rating: String
}

class CollaborativeFilter {
    
    static var sortedProductIds = Array<String>()
    static var sortedUserIds = Array<String>()
    
    static func getAllInteraction(completion: @escaping([Interaction]) -> Void) {
        let requestURL = URL(string: Constant.domain + "final_project/getAllInteraction.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
                        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let response = String(data: data ?? Data(), encoding: .utf8) {
                switch response {
                case "Error":
                    print("Lỗi kết nối, vui lòng kiểm tra lại!")
                    
                default:
                    let interactionList = try? JSONDecoder().decode([Interaction].self, from: data ?? Data())
                    DispatchQueue.main.async {
                        completion(interactionList ?? [])
                    }
                }
            }
        })
        
        task.resume()
    }
    
    // Hàm xây dựng ma trận tiện ích
    static func buildUtilityMatrix(data: [Interaction]) -> [[Double]] {
        let userIds = Set(data.map { $0.userId })
        let productIds = Set(data.map { $0.productId })
        
        // Sắp xếp userIds và productIds
        sortedUserIds = userIds.sorted()
        sortedProductIds = productIds.sorted()

        // Sử dụng các mảng đã sắp xếp để xây dựng ma trận tiện ích
        var matrix = Array(repeating: Array(repeating: Double.nan, count: sortedProductIds.count), count: sortedUserIds.count)

        let userIdToIndex = Dictionary(uniqueKeysWithValues: sortedUserIds.enumerated().map { ($0.element, $0.offset) })
        let productIdToIndex = Dictionary(uniqueKeysWithValues: sortedProductIds.enumerated().map { ($0.element, $0.offset) })

        for interaction in data {
            if let userIdx = userIdToIndex[interaction.userId],
               let productIdx = productIdToIndex[interaction.productId] {
                matrix[userIdx][productIdx] = Double(interaction.rating) ?? 0.0
            }
        }
        
        return matrix
    }
    
    // Hàm chuẩn hoá ma trận tiện ích
    static func normalizeUtilityMatrix(matrix: [[Double]]) -> [[Double]] {
        // Tính giá trị trung bình cho từng người dùng
        let userMeans = matrix.map { row -> Double in
            let filteredRow = row.filter { !$0.isNaN }
            return filteredRow.reduce(0, +) / Double(filteredRow.count)
        }

        // Trừ giá trị trung bình khỏi các đánh giá của từng người dùng
        let normalizedMatrix = matrix.enumerated().map { (userIndex, row) -> [Double] in
            return row.map { rating -> Double in
                if rating.isNaN {
                    return 0
                }
                return rating - userMeans[userIndex]
            }
        }

        return normalizedMatrix
    }

    // Hàm tính cosine similarity giữa hai vectors
    static func cosineSimilarity(_ vectorA: [Double], _ vectorB: [Double]) -> Double {
        precondition(vectorA.count == vectorB.count, "Vectors must have the same dimension")
        
        var dotProduct: Double = 0
        var magnitudeA: Double = 0
        var magnitudeB: Double = 0
        
        vDSP_dotprD(vectorA, 1, vectorB, 1, &dotProduct, vDSP_Length(vectorA.count))
        vDSP_dotprD(vectorA, 1, vectorA, 1, &magnitudeA, vDSP_Length(vectorA.count))
        vDSP_dotprD(vectorB, 1, vectorB, 1, &magnitudeB, vDSP_Length(vectorB.count))
        
        return dotProduct / (sqrt(magnitudeA) * sqrt(magnitudeB))
    }

    // Hàm tính ma trận tương đồng giữa các người dùng
    static func userSimilarityMatrix(_ normalizedMatrix: [[Double]]) -> [[Double]] {
        let userCount = normalizedMatrix.count
        var similarityMatrix = Array(repeating: Array(repeating: 0.0, count: userCount), count: userCount)
        
        for i in 0..<userCount {
            for j in i..<userCount {
                let similarity = cosineSimilarity(normalizedMatrix[i], normalizedMatrix[j])
                similarityMatrix[i][j] = similarity
                similarityMatrix[j][i] = similarity
            }
        }
        
        return similarityMatrix
    }
        
    static func getKNN(similarityMatrix: [[Double]], userId: String, k: Int = 5) -> [(String, Double)] {
        var similarTuples = [(String, Double)]()

        if let userIndex = sortedUserIds.firstIndex(where: { $0 == userId }) {
            let userSimilarities = similarityMatrix[userIndex]
            var similarUsers = [(index: Int, similarity: Double)]()

            for (index, similarity) in userSimilarities.enumerated() {
                if index != userIndex {
                    similarUsers.append((index: index, similarity: similarity))
                }
            }

            similarUsers.sort { $0.similarity > $1.similarity }

            for i in 0..<min(k, similarUsers.count) {
                let user = sortedUserIds[similarUsers[i].index]
                let similarity = similarUsers[i].similarity
                similarTuples.append((user, similarity))
            }
        }

        return similarTuples
    }
    
    static func cfRecommender(knn: [(String, Double)], normMatrix: [[Double]], n: Int = 3) -> [String] {
        let similarUserList = knn.map { $0.0 }  // Danh sách các người dùng tương đồng
        let sumWeighted = knn.map { $0.1 }.reduce(0, +)  // Tổng trọng số của các người dùng tương đồng
        
        let jobList = sortedProductIds  // Danh sách các công việc
        var weighted = [(String, Double)]()  // Tạo một mảng tuple để lưu trọng số cho mỗi người dùng
        
        // Tính trọng số cho mỗi người dùng dựa trên K-nearest neighbors
        for (userId, value) in knn {
            weighted.append((userId, value / sumWeighted))
        }
        
        let weightedList = weighted.map { $0.1 }  // Danh sách các trọng số
                
        // Lấy ma trận điểm số tương tự giữa các người dùng tương đồng
        var ratingSimilaritiesUser = [[Double]]()
        for userId in similarUserList {
            if let userIndex = sortedUserIds.firstIndex(of: userId) {
                ratingSimilaritiesUser.append(normMatrix[userIndex])
            }
        }
        
        // Tính ma trận điểm số mới bằng cách nhân trọng số với ma trận điểm số tương tự
        let newRatingMatrix = zip(weightedList, ratingSimilaritiesUser).map { weight, row in
            return row.map { rating in
                return weight * rating
            }
        }
                
        // Tính giá trị trung bình của điểm số cho từng công việc
        var meanRatingList = [Double]()
        for columnIndex in 0..<jobList.count {
            var sum = 0.0
            for rowIndex in 0..<similarUserList.count {
                sum += newRatingMatrix[rowIndex][columnIndex]
            }
            meanRatingList.append(sum)
        }
                        
        // Chọn ra n công việc có điểm số cao nhất và trích xuất productId
        let n = min(meanRatingList.count, n)
        let postRecommender = meanRatingList.enumerated().sorted { $0.element > $1.element }.prefix(n).map { jobList[$0.offset] }
        
        return postRecommender
    }


    static func getRecommend(number: Int, completion: @escaping() -> Void) {
        let user_data = User.user
        
        getAllInteraction { interactionList in
            let data = interactionList
            
            // Xây dựng ma trận tiện ích từ dữ liệu
            let utilityMatrix = buildUtilityMatrix(data: data)
            
            // Chuẩn hoá ma trận tiện ích
            let normalizedMatrix = normalizeUtilityMatrix(matrix: utilityMatrix)
            
            let similarityMatrix = userSimilarityMatrix(normalizedMatrix)
            
            let knnResults = getKNN(similarityMatrix: similarityMatrix, userId: user_data.userId ?? "", k: 20)

            let jobRecommender = CollaborativeFilter.cfRecommender(knn: knnResults, normMatrix: normalizedMatrix, n: number)
            
            var recommend: [Post] = []
            
            for id in jobRecommender {
                let requestURL = URL(string: Constant.domain + "final_project/getCollaborative.php")!
                var request = URLRequest(url: requestURL)
                request.httpMethod = "POST"
                
                let data = "productId=\(id)"
                
                request.httpBody = data.data(using: String.Encoding.utf8)
                                
                let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!, completionHandler: { data, response, error in
                    if let response = String(data: data ?? Data(), encoding: .utf8) {
                        switch response {
                        case "Error":
                            print("Lỗi kết nối, vui lòng kiểm tra lại!")
                            
                        default:
                            let interactionList = try? JSONDecoder().decode([Post].self, from: data ?? Data())
                            if let i = interactionList {
                                if !i.isEmpty {
                                    recommend.append(i[0])
                                }
                                if recommend.count == jobRecommender.count {
                                    RecommendPost.collaborativePost = recommend
                                    completion()
                                }
                            }
                        }
                    }
                })
                
                task.resume()
            }
        }
    }
}

