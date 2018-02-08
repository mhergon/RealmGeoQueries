Pod::Spec.new do |spec|
  spec.name             = 'RealmGeoQueries'
  spec.platform         = :ios, "9.0"
  spec.version          = '1.3.1'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://github.com/mhergon/RealmGeoQueries'
  spec.authors          = { 'Marc Hervera' => 'mhergon@gmail.com' }
  spec.summary          = 'Realm GeoQueries made easy'
  spec.source           = { :git => 'https://github.com/mhergon/RealmGeoQueries.git', :tag => 'v1.3.1' }
  spec.source_files     = 'GeoQueries.swift'
  spec.ios.frameworks   = 'CoreLocation', 'MapKit'
  spec.dependency       'RealmSwift'
  spec.requires_arc     = true
  spec.module_name      = 'GeoQueries'
end
