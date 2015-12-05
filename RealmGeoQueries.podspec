Pod::Spec.new do |spec|
  spec.name             = 'RealmGeoQueries'
  spec.platform         = :ios, "8.0"
  spec.version          = '1.0'
  spec.license          = { :type => 'Apache' }
  spec.homepage         = 'https://github.com/mhergon/RealmGeoQueries'
  spec.authors          = { 'Marc Hervera' => 'mhergon@gmail.com' }
  spec.summary          = 'Realm GeoQueries made easy'
  spec.source           = { :git => 'https://github.com/mhergon/RealmGeoQueries.git', :tag => 'v1.0' }
  spec.source_files     = 'Subtitles.swift'
  spec.requires_arc     = true
  spec.module_name       = 'MPMoviePlayerControllerSubtitles'
end
