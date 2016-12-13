platform :ios, '9.0'

target 'Gank' do
  use_frameworks!
  pod 'Alamofire', '~> 4.0'
  pod 'SwiftyJSON'
  pod 'SVProgressHUD'
  pod 'SDWebImage'
  pod 'MJRefresh'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end