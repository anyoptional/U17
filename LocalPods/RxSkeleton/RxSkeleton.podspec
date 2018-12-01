#
# Be sure to run `pod lib lint RxSkeleton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  
  s.name             = 'RxSkeleton'
  s.version          = '1.0.0'
  s.summary          = 'Reactive wrapper for SkeletonView.'
  
  s.homepage         = 'Coming soon...'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Archer' => 'code4archer@163.com' }
  s.source           = { :git => 'Coming soon...', :tag => s.version.to_s }
  
  s.frameworks  = "UIKit"
  
  s.ios.deployment_target = '9.0'
  
  s.dependency 'RxSwift', '~> 4.1.2'
  s.dependency 'RxCocoa', '~> 4.1.2'
  s.dependency 'SkeletonView', '~> 1.4.1'
  s.dependency 'RxDataSources', '~> 3.1.0'
  
  s.resource_bundles = {
    'RxSkeleton' => ['RxSkeleton/Assets/*.png']
  }
  
  s.subspec "Core" do |cs|
    cs.source_files  = "RxSkeleton/Classes/Core"
  end
  
end
