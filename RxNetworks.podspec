#
# Be sure to run 'pod lib lint RxNetworks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxNetworks'
  s.version          = '0.4.2'
  s.summary          = 'Network Architecture API RxSwift + Moya + HandyJSON + Plugins.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.homepage         = 'https://github.com/yangKJ/RxNetworks'
  s.description      = 'https://github.com/yangKJ/RxNetworks/blob/master/README.md'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangkejun' => 'yangkj310@gmail.com' }
  s.source           = { :git => 'https://github.com/yangKJ/RxNetworks.git', :tag => "#{s.version}" }
  s.social_media_url = 'https://juejin.cn/user/1987535102554472/posts'
  
  s.ios.deployment_target = '11.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.static_framework = true
  s.module_name      = 'RxNetworks'
  s.ios.source_files = 'Sources/RxNetworks.h'
  #s.default_subspec  = "MoyaNetwork"
  
  s.pod_target_xcconfig = {
    'SWIFT_WHOLE_MODULE_OPTIMIZATION' => 'YES',
    "OTHER_SWIFT_FLAGS[config=Debug]" => "-D DEBUG",
  }
  
  s.subspec 'MoyaNetwork' do |xx|
    xx.source_files = 'Sources/MoyaNetwork/*.swift'
    xx.dependency 'Moya'
  end
  
  unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].blank?
    unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"RxSwift"
      s.subspec 'RxSwift' do |xx|
        xx.source_files = 'Sources/RxSwift/*.swift'
        xx.dependency 'RxSwift'
        xx.dependency 'RxNetworks/MoyaNetwork'
      end
    end
    
    unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"HandyJSON"
      s.subspec 'HandyJSON' do |xx|
        xx.source_files = 'Sources/HandyJSON/*.swift'
        xx.dependency 'HandyJSON'
        xx.dependency 'RxSwift'
      end
    end
    
    ################## -- 插件系列 -- ##################
    s.subspec 'MoyaPlugins' do |xx|
      unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"INDICATOR"
        xx.subspec 'Indicator' do |xxx|
          xxx.source_files = 'Sources/MoyaPlugins/Indicator/*.swift'
          xxx.dependency 'RxNetworks/MoyaNetwork'
          xxx.pod_target_xcconfig = {
            'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'RxNetworks_MoyaPlugins_Indicator',
            'GCC_PREPROCESSOR_DEFINITIONS' => 'RxNetworks_MoyaPlugins_Indicator=1'
          }
        end
      end
      unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"DEBUGGING"
        xx.subspec 'Debugging' do |xxx|
          xxx.source_files = 'Sources/MoyaPlugins/Debugging/*.swift'
          xxx.dependency 'RxNetworks/MoyaNetwork'
          xxx.pod_target_xcconfig = {
            'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'RxNetworks_MoyaPlugins_Debugging',
            'GCC_PREPROCESSOR_DEFINITIONS' => 'RxNetworks_MoyaPlugins_Debugging=1'
          }
        end
      end
      unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"LOADING"
        xx.subspec 'Loading' do |xxx|
          xxx.source_files = 'Sources/MoyaPlugins/Loading/*.swift'
          xxx.dependency 'RxNetworks/MoyaNetwork'
          xxx.ios.dependency 'MBProgressHUD'
        end
      end
      unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"ANIMATEDLOADING"
        xx.subspec 'AnimatedLoading' do |xxx|
          xxx.source_files = 'Sources/MoyaPlugins/AnimatedLoading/*.swift'
          xxx.dependency 'RxNetworks/MoyaNetwork'
          xxx.dependency 'lottie-ios'#, '~> 4.2.0'
        end
      end
      unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"WARNING"
        xx.subspec 'Warning' do |xxx|
          xxx.source_files = 'Sources/MoyaPlugins/Warning/*.swift'
          xxx.dependency 'RxNetworks/MoyaNetwork'
          xxx.ios.dependency 'Toast-Swift'
        end
      end
      unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"CACHE"
        xx.subspec 'Cache' do |xxx|
          xxx.source_files = 'Sources/MoyaPlugins/Cache/*.swift'
          xxx.dependency 'RxNetworks/MoyaNetwork'
          xxx.dependency 'Lemons'
        end
      end
      unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"GZIP"
        xx.subspec 'GZip' do |xxx|
          xxx.source_files = 'Sources/MoyaPlugins/GZip/*.swift'
          xxx.dependency 'RxNetworks/MoyaNetwork'
        end
      end
      unless ENV['RXNETWORKS_PLUGINGS_EXCLUDE'].include?"SHARED"
        xx.subspec 'Shared' do |xxx|
          xxx.source_files = 'Sources/MoyaPlugins/Shared/*.swift'
          xxx.dependency 'RxNetworks/MoyaNetwork'
          xxx.pod_target_xcconfig = {
            'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'RxNetworks_MoyaPlugins_Shared',
            'GCC_PREPROCESSOR_DEFINITIONS' => 'RxNetworks_MoyaPlugins_Shared=1'
          }
        end
      end
    end
  else
    s.subspec 'RxSwift' do |xx|
      xx.source_files = 'Sources/RxSwift/*.swift'
      xx.dependency 'RxSwift'
      xx.dependency 'RxNetworks/MoyaNetwork'
    end
    
    s.subspec 'HandyJSON' do |xx|
      xx.source_files = 'Sources/HandyJSON/*.swift'
      xx.dependency 'HandyJSON'
      xx.dependency 'RxSwift'
    end
    
    ################## -- 插件系列 -- ##################
    s.subspec 'MoyaPlugins' do |xx|
      xx.subspec 'Indicator' do |xxx|
        xxx.source_files = 'Sources/MoyaPlugins/Indicator/*.swift'
        xxx.dependency 'RxNetworks/MoyaNetwork'
        xxx.pod_target_xcconfig = {
          'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'RxNetworks_MoyaPlugins_Indicator',
          'GCC_PREPROCESSOR_DEFINITIONS' => 'RxNetworks_MoyaPlugins_Indicator=1'
        }
      end
      xx.subspec 'Debugging' do |xxx|
        xxx.source_files = 'Sources/MoyaPlugins/Debugging/*.swift'
        xxx.dependency 'RxNetworks/MoyaNetwork'
        xxx.pod_target_xcconfig = {
          'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'RxNetworks_MoyaPlugins_Debugging',
          'GCC_PREPROCESSOR_DEFINITIONS' => 'RxNetworks_MoyaPlugins_Debugging=1'
        }
      end
      xx.subspec 'Loading' do |xxx|
        xxx.source_files = 'Sources/MoyaPlugins/Loading/*.swift'
        xxx.dependency 'RxNetworks/MoyaNetwork'
        xxx.ios.dependency 'MBProgressHUD'
      end
      xx.subspec 'AnimatedLoading' do |xxx|
        xxx.source_files = 'Sources/MoyaPlugins/AnimatedLoading/*.swift'
        xxx.dependency 'RxNetworks/MoyaNetwork'
        xxx.dependency 'lottie-ios'#, '~> 4.2.0'
      end
      xx.subspec 'Warning' do |xxx|
        xxx.source_files = 'Sources/MoyaPlugins/Warning/*.swift'
        xxx.dependency 'RxNetworks/MoyaNetwork'
        xxx.ios.dependency 'Toast-Swift'
      end
      xx.subspec 'Cache' do |xxx|
        xxx.source_files = 'Sources/MoyaPlugins/Cache/*.swift'
        xxx.dependency 'RxNetworks/MoyaNetwork'
        xxx.dependency 'Lemons'
      end
      xx.subspec 'GZip' do |xxx|
        xxx.source_files = 'Sources/MoyaPlugins/GZip/*.swift'
        xxx.dependency 'RxNetworks/MoyaNetwork'
      end
      xx.subspec 'Shared' do |xxx|
        xxx.source_files = 'Sources/MoyaPlugins/Shared/*.swift'
        xxx.dependency 'RxNetworks/MoyaNetwork'
        xxx.pod_target_xcconfig = {
          'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'RxNetworks_MoyaPlugins_Shared',
          'GCC_PREPROCESSOR_DEFINITIONS' => 'RxNetworks_MoyaPlugins_Shared=1'
        }
      end
    end
  end
  
end
