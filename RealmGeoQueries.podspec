Pod::Spec.new do |spec|
  spec.name             = 'RealmGeoQueries'
  spec.platform         = :ios, "8.0"
  spec.version          = '1.0.2'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://github.com/mhergon/RealmGeoQueries'
  spec.authors          = { 'Marc Hervera' => 'mhergon@gmail.com' }
  spec.summary          = 'Realm GeoQueries made easy'
  spec.source           = { :git => 'https://github.com/mhergon/RealmGeoQueries.git', :tag => 'v1.0.2' }
  spec.source_files     = 'GeoQueries.swift'
  spec.ios.frameworks   = 'CoreLocation', 'MapKit'
  spec.dependency       'RealmSwift'
  spec.requires_arc     = true
  spec.module_name      = 'RealmGeoQueries'
end
