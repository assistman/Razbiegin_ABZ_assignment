//
//  Data+MultipartForm.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 3/10/25.
//

import Foundation

extension Data {

    enum MultipartDataError: Error {
        case stingToData
    }

    struct ImagePart {
        let name: String
        let fileName: String
        let data: Data
    }

    mutating func appendString(_ string: String) throws {
        guard let data = string.data(
            using: String.Encoding.utf8
        ) else {
            throw MultipartDataError.stingToData
        }
        append(data)
    }

    static func withParameters(
        _ parameters: [String: Any],
        images: [ImagePart],
        boundary: String
    ) throws -> Data {
        var data = Data();

        for (key, value) in parameters {
            try data.appendString("--\(boundary)\r\n")
            try data.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            try data.appendString("\(value)\r\n")
        }

        let mimetype = "image/jpg"
        try data.appendString("--\(boundary)\r\n")

        for image in images {
            try data.appendString(
                "Content-Disposition: form-data; name=\"\(image.name)\"; filename=\"\(image.fileName)\"\r\n"
            )
            try data.appendString("Content-Type: \(mimetype)\r\n\r\n")
            data.append(image.data)
            try data.appendString("\r\n")
            try data.appendString("--\(boundary)--\r\n")
        }
        return data
    }

    var utf8: String {
        return String(data: self, encoding: .utf8) ??
            "Data is not a UTF-8 string, size: \(self.count)"
    }
}

