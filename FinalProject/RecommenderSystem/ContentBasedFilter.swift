//
//  ContentBaseFilter.swift
//  FinalProject
//
//  Created by ThanDuc on 27/09/2023.
//

import Foundation

class ContentBasedFilter {
        
    static func getRecommend(numberOfRecommend: Int, completion: @escaping() -> Void) {
        let user_data = User.user
        let apartment_data = GetAllPost.allPost
         
        
        // Hàm chuyển chuỗi thành danh sách các từ
        func splitStringIntoWords(_ s: String) -> [String] {
            return s.components(separatedBy: " ")
        }

        // Biểu diễn dữ liệu thành các vector số học
        func vectorize(user: UserInfor, post: Post) -> [Double] {
            // Mã hóa thông tin người dùng thành vector

            // Xử lý giá của người dùng
            let user_price = Double(user.price?.replacingOccurrences(of: " triệu/tháng", with: "").trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".") ?? "100000") ?? 0.0

            // Xử lý diện tích của người dùng
            let user_area = Double(user.area?.replacingOccurrences(of: " m²", with: "").trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".") ?? "1000000") ?? 0.0

            // Chuyển đổi giá trị thành số thực
            let data_price: Double
            if post.price == "Giá thỏa thuận" {
                data_price = 0.0
            } else {
                data_price = Double(post.price.replacingOccurrences(of: " triệu/tháng", with: "").replacingOccurrences(of: " nghìn/tháng", with: "").replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespaces)) ?? 0.0
            }

            // Chuyển đổi giá trị thành số thực
            let data_area = Double(post.area.replacingOccurrences(of: " m²", with: "").replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespaces))!

            // Chuyển chuỗi A và B thành danh sách các từ
            let user_addr = splitStringIntoWords(user.address ?? "")
            let data_addr = splitStringIntoWords(post.address.replacingOccurrences(of: ",", with: ""))

            // Biến đếm số từ chung
            var commonWordCount = 0

            // Duyệt qua từng từ trong danh sách A
            for word in user_addr {
                // Kiểm tra xem từ này có tồn tại trong danh sách B không
                if data_addr.contains(word) {
                    commonWordCount += 1
                }
            }
            
            let post_address = post.address.components(separatedBy: ", ")
            var weight_addr = 0.0
            
            if user.address == post_address[0] {
                weight_addr = 1
            } else if user.address == post_address[1] {
                weight_addr = 0.8
            } else {
                weight_addr = 0.2
            }

            // Bây giờ bạn có thể so sánh dữ liệu như đã làm trong vector trước đó
            let userVector = [
                Double(2 * commonWordCount) / Double(user_addr.count) * weight_addr,
                data_price <= user_price ? 1.0 : 0.0,
                data_area >= user_area ? 1.0 : 0.0
            ]

            return userVector
        }

        // Tính điểm tương đồng sử dụng cosine similarity
        let userVector = [2.0, 1.0, 1.0]
        let apartmentVectors = apartment_data.map { vectorize(user: user_data, post: $0) }
        var similarities: [Double] = []

        for apartmentVector in apartmentVectors {
            let dotProduct = zip(userVector, apartmentVector).map { $0 * $1 }.reduce(0.0, +)
            let userVectorMagnitude = sqrt(userVector.map { $0 * $0 }.reduce(0.0, +))
            let apartmentVectorMagnitude = sqrt(apartmentVector.map { $0 * $0 }.reduce(0.0, +))
            if (userVectorMagnitude * apartmentVectorMagnitude) == 0 {
                similarities.append(0)
            } else {
                let similarity = dotProduct / (userVectorMagnitude * apartmentVectorMagnitude)
                similarities.append(similarity)
            }
        }

        // Sắp xếp các phòng trọ theo điểm tương đồng giảm dần
        let recommendedApartments = zip(0..<apartment_data.count, similarities).sorted { $0.1 > $1.1 }

        var topRecommendedApartments = [Post]() // Tạo mảng rỗng kiểu [Post]

        // Lấy 10 phòng trọ có điểm tương đồng cao nhất
        for (index, _) in recommendedApartments.prefix(numberOfRecommend) {
            topRecommendedApartments.append(apartment_data[index])
        }

        RecommendPost.contentBasePost = topRecommendedApartments

        completion()
    }
}
