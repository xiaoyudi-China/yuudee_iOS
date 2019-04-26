//
//  YuudeeConst.m
//  Yuudee2
//
//  Created by 北京道口贷科技有限公司 on 2018/8/23.
//  Copyright © 20bb18年 北京道口贷科技有限公司. All rights reserved.
//

#import "YuudeeConst.h"

//服务器地址
NSString *const Host = @"https://api.xiaoyudi.org";
//NSString *const Host = @"http://47.95.244.242/XiaoyudiApplication";
//
/*-------------------------常用字符串--------------------------*/

//调试接口fail时弹框提示内容
NSString *const ErrorInfo = @"连接服务器失败";

/*------------------------------------------------------------*/
//名词
NSString *const MCKJ = @"/app/trainTest/getNoun";
//动词
NSString *const DCKJ = @"/app/trainTest/getVerb";
//句子成组
NSString *const JZCZ = @"/app/trainTest/getSentencegroup";
//句子分解
NSString *const JZFJ = @"/app/trainTest/getSentenceResolve";
//上传答题结果
NSString *const PostResult = @"/app/trainingResult/addTrainingResult";
//获取当前答题进度
NSString *const GetProgress = @"/app/trainTest/getSystemStatistics";
//添减金币
NSString *const AddCoin = @"/app/trainTest/addFortifier";
//获取金币数量
NSString *const GetCoin = @"/app/trainTest/getFortifier";
//查询剩余积木数
NSString *const Rest = @"/app/toy/toyList";
//删除积木
NSString *const Delete = @"/app/toy/useToy";
//上传课件体验记录
NSString *const PostTry = @"/app/parents/addRecord";
//是否完善了儿童信息,问卷评估
NSString *const IsComplete = @"/app/parents/toAssess";
//获取启动页
NSString *const GetLoading = @"/app/system/appStartImage";
//通关重置强化物积木
NSString *const ResetJiMu = @"/app/toy//empty/useToy";




/*-------------------------注册相关接口-------------------------*/

//家长注册
NSString *const Register = @"/app/user/register";
//判断该手机号是否已注册
NSString *const PhoneIsRegister = @"/app/user/phoneIsRegister";
//家长注册、手机验证码验证
NSString *const RegisterCodeverify = @"/app/user/registerCodeverify";
//注册获取验证码
NSString *const RegisterSendCode = @"/app/user/registerSendCode";
//普通登录
NSString *const GeneralLogin = @"/app/user/generalLogin";
//快捷登录
NSString *const ShortCutLogin = @"/app/user/shortcutLogin";
//快捷登录获取验证码
NSString *const ShortcutLoginSend = @"/app/user/shortcutLoginSend";
//忘记密码
NSString *const ResetPassword = @"/app/user/resetPassword";
//忘记密码-发送验证码
NSString *const SendCode = @"/app/user/sendCode";
//图形验证码
NSString *const AuthImage = @"/app/authImage/service";
//图片验证码校验
NSString *const VerifyImageCode = @"/app/user/verify/imageCode";
//获取手机号归属地数据列表
NSString *const QCellCoreList = @"/app/system/qcellcoreList";

/*----------------------家长中心-----------------------*/
//家长中心-产品介绍
NSString *const ProductInfo = @"/app/system/productInfo";
//完善儿童信息
NSString *const AddChild = @"/app/user/perfection/addChild";
//修改儿童昵称
NSString *const UpdateChildInfo = @"/app/user/updateChildInfo";
//修改密码
NSString *const ChangePassword = @"/app/user/updatePassword";
//训练档案一级页面
NSString *const Records = @"/app/parents/training/records";
//训练档案、总测试通关学习情况记录
NSString *const TotalInfo = @"/app/statistics/noun/totalInfo";
//修改手机号 旧手机号code验证
NSString *const EfficacyCode = @"/app/user/efficacyCode";
//训练档案、按天查询统计学习情况记录
NSString *const DayInfo = @"/app/statistics/noun/dayInfo";
//训练档案、按周查询统计学习情况记录
NSString *const WeekInfo = @"/app/statistics/noun/weekInfo";
//训练档案、按月查询统计学习情况记录
NSString *const MonthInfo = @"/app/statistics/noun/monthInfo";
//用户修改手机号
NSString *const UpdatePhone = @"/app/user/updatePhone";
//更多建议反馈和版本信息
NSString *const AboutUs = @"/app/system/aboutUs";
//上传图片
NSString *const FileUpload = @"/app/system/oss/fileUpload";
//评估评测界面
NSString *const ToAssess = @"/app/parents/toAssess";
//PCDI问卷
NSString *const PCDI = @"/xiaoyudi/pages/pcdiRequired.html";
//ABC问卷
NSString *const ABC = @"/xiaoyudi/pages/abcquestionnaire.html";
//pcdi全部结果页
NSString *const AllResult = @"/xiaoyudi/pages/allResult.html";
//pcdi必填结果页
NSString *const Required = @"/xiaoyudi/pages/requiredPresentation.html";
//abc结果页
NSString *const ABCPresentation = @"/xiaoyudi/pages/abcPresentation.html";
//获取三级城市列表
NSString *const GetThisCityClass = @"/app/system/getThisCityList";
//效验手机合法性
NSString *const PhoneNumber = @"/app/system/verify/phoneNumber";
/*------------------------------------------------------------*/
