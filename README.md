<p align="center" >
<img src="https://raw.github.com/mhergon/RealmGeoQueries/assets/logo.png" alt="RealmGeoQueries" title="Logo" height=300>
</p>

![issues](https://img.shields.io/github/issues/mhergon/RealmGeoQueries.svg)
&emsp;
![stars](https://img.shields.io/github/stars/mhergon/RealmGeoQueries.svg)
&emsp;
![license](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)

RealmGeoQueries simplify spatial queries with Realm.io. In the absence of and official functions, this library provide the possibility to do proximity search.
It's not necessary to include Geohash or other type of index in the model class and only needs latitude and longitude properties.

## How To Get Started

### Installation with CocoaPods

```ruby
platform :ios, '8.0'
pod "RealmGeoQueries"
```

### Manually installation

[Download](https://github.com/mhergon/RealmGeoQueries/raw/master/GeoQueries.swift) (right-click) and add to your project.

### Requirements

| Version | Language  | Minimum iOS Target  |
|:--------------------:|:---------------------------:|:---------------------------:|
|          1.x         |            Swift            |            iOS 8            |

### Usage

First, import module
```swift
import GeoQueries
```

Search with MapView MKCoordinateRegion
```swift
let results = try! Realm().findInRegion(YourModelClass.self, region: mapView.region)
```

Search around the center
```swift
let results = try! Realm().findNearby(Point.self, origin: mapView.centerCoordinate, radius: 500, sortAscending: nil)
```
