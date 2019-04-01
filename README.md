# NOTE
使用ReactorKit并不好处理数据变动的问题。一旦State中有一个属性发生变化，所有的状态都会被其ActionSubject发射出来从而导致很多不必要的界面刷新，这不是我想要的，所以这个项目就先放弃啦。</br>

# 效果图

<p align="center">
  <img width="320" height="568" src="Snapshot/today.gif"/>
</p>

# 项目架构

1、基于CocoaPods/Mediator的组件化架构；</br>
2、基于ReactiveX系列的响应式、函数式编程。
