//
//  GooglePlaces.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 10/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import UIKit

class GooglePlaces : NSObject
{
    func createQueryArray(_ type : String)->[URLQueryItem]
    {
        var queryDictionary : [String:String] = [:]
        queryDictionary[GooglePlacesConstants.queryKeys.location] = GooglePlacesConstants.queryValues.location
        queryDictionary[GooglePlacesConstants.queryKeys.radius] = GooglePlacesConstants.queryValues.radius
        queryDictionary[GooglePlacesConstants.queryKeys.type] = type
        queryDictionary[GooglePlacesConstants.queryKeys.sensor] = GooglePlacesConstants.queryValues.sensor
        queryDictionary[GooglePlacesConstants.queryKeys.apiKey] = GooglePlacesConstants.queryValues.apiKey
        
        var queryArray : [URLQueryItem] = []
        for (key,value) in queryDictionary
        {
            let queryItem = URLQueryItem(name: key, value: value)
            queryArray.append(queryItem)
        }
        return queryArray
    }
    
    func createHospitalUrl() -> URL
    {
        var urlComponents = URLComponents()
        urlComponents.scheme = GooglePlacesConstants.urlScheme
        urlComponents.host = GooglePlacesConstants.urlHost
        urlComponents.path = GooglePlacesConstants.urlPath
        urlComponents.queryItems = createQueryArray(GooglePlacesConstants.queryValues.hospitalType)
        return urlComponents.url!
    }
    
    func createPharmacyUrl() -> URL
    {
        var urlComponents = URLComponents()
        urlComponents.scheme = GooglePlacesConstants.urlScheme
        urlComponents.host = GooglePlacesConstants.urlHost
        urlComponents.path = GooglePlacesConstants.urlPath
        urlComponents.queryItems = createQueryArray(GooglePlacesConstants.queryValues.pharmacyType)
        return urlComponents.url!
    }
    
    func fetchData(_ url : URL, _ completionHandler : @escaping(_ data:Data?,_ error : Error?) -> Void)
    {
        let url = url
        print(url)
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil
            {
                completionHandler(data,nil)
            }
            else
            {
                completionHandler(nil,error)
            }
        }
        dataTask.resume()
    }
}
