VLC-Video
=========

基于VLC框架，满足播放视频流的视频项目

使用说明
1. 导入系统库 libiconv.dylib
              libstdc++.dylib
              libbz2.dylib
              AudioToolbox.framework
2. 将AppDelegate.m 的后缀变为.mm
3. 在Build Settings中搜索C++ Standard Library， 修改其属性为libstdc++(GNU C++ standard library)
4. 获取MobileVLCKit.framework,并导入项目中
获取地址：
