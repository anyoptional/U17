#
# Be sure to run `pod lib lint AppDiscover.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
    s.name             = 'AppDiscover'
    s.version          = '1.0.0'
    s.summary          = 'Application discover module.'
    
    s.homepage         = 'Coming soon...'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Archer' => 'code4archer@163.com' }
    s.source           = { :git => 'Coming soon...', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    
    s.dependency 'Fate'
    s.dependency 'RxMoya'
    s.dependency 'Mediator'
    s.dependency 'RxSkeleton'
    s.dependency 'RxBindable'
    s.dependency 'SnapKit', '~> 4.0.1'
    s.dependency 'ReactorKit', '~> 1.1.0'
    s.dependency 'RxAppState', '~> 1.1.2'
    s.dependency 'RxSwiftExt', '~> 3.2.0'
    
    s.resource_bundles = {
        'AppDiscover' => ['AppDiscover/Assets/*.png']
    }
    
    s.subspec "Controller" do |cs|
        cs.source_files  = "AppDiscover/Classes/Controller"
    end
    
    s.subspec "Reactor" do |cs|
        cs.source_files  = "AppDiscover/Classes/Reactor"
    end
    
    s.subspec "View" do |cs|
        cs.source_files  = "AppDiscover/Classes/View"
    end
    
    s.subspec "Model" do |cs|
        cs.source_files  = "AppDiscover/Classes/Model"
    end
    
    s.subspec "Util" do |cs|
        cs.source_files  = "AppDiscover/Classes/Util"
    end
    
    s.subspec "Router" do |cs|
        cs.source_files  = "AppDiscover/Classes/Router"
    end
    
end
