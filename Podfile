platform :ios, '9.0'

target 'Gank' do
  use_frameworks!
  pod 'Alamofire', '~> 4.0'
  pod 'SwiftyJSON'
  pod 'SVProgressHUD'
  pod 'SDWebImage'
  pod 'MJRefresh'
  pod 'YYWebImage'
  pod 'FMDB'
  pod 'IQKeyboardManagerSwift'
  # pod 'BmobSDK'
  
  # U-Share SDK UI模块（分享面板，建议添加）
  pod 'UMengUShare/UI'
  # 集成微信
  pod 'UMengUShare/Social/WeChat'
  # 集成短信
  pod 'UMengUShare/Social/SMS'
  
  # 腾讯Bugly
  pod 'Bugly'
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
