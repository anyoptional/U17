#
# Be sure to run `pod lib lint Fate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
    s.name             = 'Fate'
    s.version          = '1.0.0'
    s.summary          = 'Core services.'
    
    s.homepage         = 'Coming soon...'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Archer' => 'code4archer@163.com' }
    s.source           = { :git => 'Coming soon...', :tag => s.version.to_s }
    
    s.frameworks  = "UIKit"
    
    s.ios.deployment_target = '9.0'
    
    s.dependency 'SDWebImage/WebP'
    s.dependency 'SDCycleScrollView'
    s.dependency 'YYKit', '~> 1.0.9'
    s.dependency 'RxSwift', '~> 4.1.2'
    s.dependency 'RxCocoa', '~> 4.1.2'
    s.dependency 'Timepiece', '~> 1.3.1'
    s.dependency 'RxOptional', '~> 3.4.0'
    s.dependency 'SkeletonView', '~> 1.4.1'
    s.dependency 'MJRefresh', '~> 3.1.15.7'
    s.dependency 'RxDataSources', '~> 3.1.0'
    s.dependency 'SwiftMessages', '~> 6.0.1'
    s.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.6'

    s.resource_bundles = {
      'Fate' => ['Fate/Assets/*.png']
    }
    
    s.subspec "Core" do |cs|
      cs.source_files  = "Fate/Classes/Core"
    end
    
    s.subspec "CommonUI" do |cs|
      cs.source_files  = "Fate/Classes/CommonUI"
    end
    
    s.subspec "RxAdaptor" do |cs|
      cs.source_files  = "Fate/Classes/RxAdaptor"
    end
    
    s.subspec "Identifiable" do |cs|
      cs.source_files  = "Fate/Classes/Identifiable"
    end
    
    s.subspec "ImageLoading" do |cs|
      cs.source_files  = "Fate/Classes/ImageLoading"
    end
    
    s.subspec "NavigationBar" do |cs|
      cs.source_files  = "Fate/Classes/NavigationBar"
    end
    
    s.subspec "UILayoutAdaptor" do |cs|
      cs.source_files  = "Fate/Classes/UILayoutAdaptor"
    end
    
    s.subspec "RunloopOptimize" do |cs|
        cs.source_files  = "Fate/Classes/RunloopOptimize"
    end
end
