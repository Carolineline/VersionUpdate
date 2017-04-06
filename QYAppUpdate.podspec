Pod::Spec.new do |s|
  s.name             = "QYAppUpdate"
  s.version          = "0.1.13"
  s.summary          = "Prompt users to install new versions in AdHoc and Release"
  s.description      = "Notify users when a new version of app is available and prompt them to upgrade. in AdHoc and Release"
  s.homepage         = "http://git.2b6.me/iOS/QYAppUpdate"
  s.license          = 'MIT'
  s.author           = { "icyleaf" => "icyleaf.cn@gmail.com"  ,"韩晓琳" => "xiaolin.han@qyer.com"}
  s.source           = { :git => 'http://git.2b6.me/iOS/QYAppUpdate.git', :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.source_files     = 'Pod/Classes/**/*'

  
  s.dependency 'QYRequest', '~> 0.2.2'
  s.dependency 'QYUIKit', '~> 0.1.8.2'
  s.dependency 'Masonry', '~> 1.0.2'

end
