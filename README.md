<p align="center" >
<img src="https://raw.github.com/mhergon/RealmGeoQueries/assets/logo.png" alt="RealmGeoQueries" title="Logo" height=300>
</p>

![cocoapods](https://img.shields.io/cocoapods/v/RealmGeoQueries.svg?style=flat)
![carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![issues](https://img.shields.io/github/issues/mhergon/RealmGeoQueries.svg)
![stars](https://img.shields.io/github/stars/mhergon/RealmGeoQueries.svg)
![license](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)

RealmGeoQueries simplifies spatial queries with [Realm Cocoa][1]. In the absence of and official functions, this library provide the possibility to do proximity search.
It's not necessary to include Geohash or other types of indexes in the model class as it only needs latitude and longitude properties.

## How To Get Started

### Installation with CocoaPods

```ruby
platform :ios, '9.0'
pod "RealmGeoQueries"
```

### Installation with Carthage

Add to `mhergon/RealmGeoQueries` project to your `Cartfile`
```ruby
github "mhergon/RealmGeoQueries"
```

Drag `GeoQueries.framework`, `RealmSwift.framework` and `Realm.framework` from Carthage/Build/ to the “Linked Frameworks and Libraries” section of your Xcode project’s “General” settings.

Only on **iOS/tvOS/watchOS**: On your application targets "Build Phases" settings tab, click the "+" icon and choose "New Run Script Phase". Create a Run Script with the following contents:
```ruby
/usr/local/bin/carthage copy-frameworks
```
and add the paths to the frameworks you want to use under "Input Files", e.g.:
```ruby
$(SRCROOT)/Carthage/Build/iOS/GeoQueries.framework
$(SRCROOT)/Carthage/Build/iOS/Realm.framework
$(SRCROOT)/Carthage/Build/iOS/RealmSwift.framework
```

### Manually installation

[Download](https://github.com/mhergon/RealmGeoQueries/raw/master/GeoQueries.swift) (right-click) and add to your project.

### Requirements

| Version | Language | Minimum iOS Target |
|:--------------------:|:---------------------------:|:---------------------------:|
|          1.3         |            Swift 4.x / Realm 3.x            |            iOS 9            |
|          1.2         |            Swift 3.0 / Realm 2.x            |            iOS 9            |
|          1.1         |            Swift 2.x / Realm 2.x            |            iOS 8            |

### Usage

First, import module;
```swift
import GeoQueries
```

Model must have a latitude and longitude keys, that have to be named "lat" and "lng" respectively. You can use another property names (use "latitudeKey" and "longitudeKey" parameters).

<br>

Search with MapView MKCoordinateRegion;
```swift
let results = try! Realm()
    .findInRegion(type: YourModelClass.self, region: mapView.region)
```
<br>

Search around the center with radius in meters;
```swift
let results = try! Realm()
    .findNearby(YourModeltype: Class.self, origin: mapView.centerCoordinate, radius: 500, sortAscending: nil)
```
<br>

Filter Realm results with radius in meters;
```swift
let results = try! Realm()
    .objects(YourModelClass.self)
    .filter("type", "restaurant")
    .filterGeoRadius(center: mapView.centerCoordinate, radius: 500, sortAscending: nil)
```
<br>

See ```GeoQueries.swift``` for more options.

## Contact

- [Linkedin][2]
- [Twitter][3] (@mhergon)

[1]: http://www.realm.io
[2]: https://es.linkedin.com/in/marchervera
[3]: http://twitter.com/mhergon "Marc Hervera"

## License

Licensed under Apache License v2.0.
<br>
Copyright 2017 Marc Hervera.
