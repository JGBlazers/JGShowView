# JGShowView
## Swift3.0，简单的条件选择弹窗的使用
![(预览)](https://github.com/fcgIsPioneer/JGShowView/blob/master/%E9%A2%84%E8%A7%88%E5%9B%BE.gif)

整个弹窗容器的整体结构：工具条(toolBar)、承载弹窗条件的子View(showSubView)

## 一、简介
### 1.1、默认的情况
#### 在弹窗容器中，会加载一个默认的toolBar和默认的showSubView。
#### a、在这种情况下，可以直接将条件的字符串数组传递过来即可
#### b、获取方式有二：一为通过调用本类的属性selectIndex和title获取；二是通过调用代理方法获取
#### c、如果基础属性无法满足条件需要，可以自主扩展

## <a id="DemoOneVC.swift"></a>DemoOneVC.swift
```objc

let popView = JGPopupView.sharePopupView()
popView.delegate = self
popView.toolBarAlertTitle = "请选择贷款类型"
popView.subViewTitleArray = ["业主贷", "车主贷", "寿险贷", "优房贷", "宅E贷"]
popView.show()

/**
将勾选后的结果回调回来

- parameter index: 选择的条件索引
- parameter msg:   选择的条件标题等，取值是，可根据需要进行转换
*/
func clickMormalCommitBtn(index: Int, msg: Any?);

@end
```
### 1.2、自定义工具类
#### 如果默认的工具条效果无法达到自己需要，可以通过自定义的方式进行拓展，可参考类DemoTwoVC
#### a、在容器中，有一个提供外部修改的属性(var toolBar : UIView?)，使用这个属性来承接自定义的工具条
#### b、通过调用本类的属性selectIndex和title获取当前选中的条件的值

#### 注意：
#### 自定义工具条之后，暂时无法控制弹窗容器的关闭情况，需要在自己的工具条点击事件中，自己调用finish()进行关闭

### 1.3、自定义条件View
#### 如果默认的 条件view(showSubView) 效果无法达到自己需要，可以通过自定义的方式进行拓展，可参考类DemoThreeVC
#### a、在容器中，有一个提供外部修改的属性(var showSubView : UIView?)，使用这个属性来承接自定义的条件view(showSubView)
#### b、获取值方式有三：一为通过调用本类的属性selectIndex和title获取；二是通过调用容器代理方法获取；三是自己对自定义的条件View进行控制，自主获取值

#### 注意：
#### a、获取值的方式中，前二者，必须要在条件View中，时时将点击后的相关索引index和值title赋值给容器View，不然前二者方式会拿不到值

## 二、外部调用属性
#### 容器View和默认的工具条、条件view都提供了部分的属性，方便做相对应的修改和控制，具体按照需要进行配置

## 三、总结
### 1、此demo仅提供初学者参考使用，大神勿喷
### 2、半路出家，经验有限，不喜勿喷，多谢

