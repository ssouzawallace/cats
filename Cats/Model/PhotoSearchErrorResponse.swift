//
//  PhotoSearchErrorResponse.swift
//  Cats
//
//  Created by Wallace Silva on 03/02/23.
//

import Foundation

/// The body Pexels returns alongside a non-2xx status, for example
/// `{"status": 401, "code": "Unauthorized", "message": "Invalid API key"}`.
struct PhotoSearchErrorResponse: Decodable {
    let status: Int
    let code: String
    let message: String
}
