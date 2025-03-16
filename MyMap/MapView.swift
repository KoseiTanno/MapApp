//
//  MapView.swift
//  MyMap
//
//  Created by ピットラボ on 2025/03/01.
//

import SwiftUI
import MapKit

enum MapType {
    case standard
    case satellite
    case hybrid
}

struct MapView: View {
    let searchKey: String
    let mapType: MapType
    
    //  キーワードから取得した緯度経度
    @State var targetCoordinate = CLLocationCoordinate2D()
    @State var cameraPosition: MapCameraPosition = .automatic
    
    var mapStyle: MapStyle {
        switch mapType {
        case .standard:
            return MapStyle.standard()
        case .satellite:
            return MapStyle.imagery()
        case .hybrid:
            return MapStyle.hybrid()
        }
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            Marker(searchKey, coordinate: targetCoordinate)
        }
        .mapStyle(mapStyle)
        
        //  検索キーワードの変更を検知
        .onChange(of: searchKey, initial: true) { oldValue, newValue in
            print("検索キーワード : \(newValue)")
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = newValue
            let search = MKLocalSearch(request: request)
            
            //  検索開始
            search.start { response, error in
                
                //  結果が存在するなら、1件目を取り出す
                if let mapItems = response?.mapItems,
                   let mapItem = mapItems.first {
                    targetCoordinate = mapItem.placemark.coordinate
                    
                    print("緯度経度 : \(targetCoordinate)")
                }
                
                //  表示するマップの領域を作成
                cameraPosition = .region(MKCoordinateRegion(
                    center: targetCoordinate,
                    latitudinalMeters: 500.0,
                    longitudinalMeters: 500.0
                ))
            }
        }
    }
}

#Preview {
    MapView(searchKey: "東京駅", mapType: .standard)
}
