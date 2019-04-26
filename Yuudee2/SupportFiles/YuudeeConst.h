//
//  YuudeeConst.h
//  Yuudee2
//
//  Created by 北京道口贷科技有限公司 on 2018/8/23.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//服务器地址
extern NSString *const Host;

/*-------------------------常用字符串--------------------------*/

//调试接口fail时弹框提示内容
extern NSString *const ErrorInfo;


/*------------------------------------------------------------*/
//名词
extern NSString *const MCKJ;
//动词
extern NSString *const DCKJ;
//句子成组
extern NSString *const JZCZ;
//句子分解
extern NSString *const JZFJ;
//上传答题结果
extern NSString *const PostResult;
//获取当前答题进度
extern NSString *const GetProgress;
//添减金币
extern NSString *const AddCoin;
//获取金币数量
extern NSString *const GetCoin;
//查询剩余积木数
extern NSString *const Rest;
//删除积木
extern NSString *const Delete;
//上传课件体验记录
extern NSString *const PostTry;
//是否完善了儿童信息,问卷评估
extern NSString *const IsComplete;
//获取启动页
extern NSString *const GetLoading;
//通关重置强化物积木
extern NSString *const ResetJiMu;


/*-----------------------登录注册相关接口-----------------------*/

//家长注册
extern NSString *const Register;
//判断该手机号是否已注册
extern NSString *const PhoneIsRegister;
//家长注册、手机验证码验证
extern NSString *const RegisterCodeverify;
//注册获取验证码
extern NSString *const RegisterSendCode;
//普通登录
extern NSString *const GeneralLogin;
//快捷登录
extern NSString *const ShortCutLogin;
//快捷登录获取验证码
extern NSString *const ShortcutLoginSend;
//忘记密码
extern NSString *const ResetPassword;
//忘记密码-发送验证码 发送类型(1：忘记密码 2：修改密码 3：更换手机号旧发送验证码 4:更换手机号新手机发送验证码)
extern NSString *const SendCode;
//图形验证码
extern NSString *const AuthImage;
//图片验证码校验
extern NSString *const VerifyImageCode;
//获取手机号归属地数据列表
extern NSString *const QCellCoreList;

/*----------------------家长中心-----------------------*/
//家长中心-产品介绍
extern NSString *const ProductInfo;
//完善儿童信息
extern NSString *const AddChild;
//修改儿童昵称
extern NSString *const UpdateChildInfo;
//修改密码
extern NSString *const ChangePassword;
//训练档案一级页面
extern NSString *const Records;
//训练档案、总测试通关学习情况记录
extern NSString *const TotalInfo;
//修改手机号 旧手机号code验证
extern NSString *const EfficacyCode;
//训练档案、按天查询统计学习情况记录
extern NSString *const DayInfo;
//训练档案、按周查询统计学习情况记录
extern NSString *const WeekInfo;
//训练档案、按月查询统计学习情况记录
extern NSString *const MonthInfo;
//用户修改手机号
extern NSString *const UpdatePhone;
//更多建议反馈和版本信息
extern NSString *const AboutUs;
//上传图片
extern NSString *const FileUpload;
//PCDI问卷
extern NSString *const PCDI;
//ABC问卷
extern NSString *const ABC;
//评估评测界面
extern NSString *const ToAssess;
//全部结果页
extern NSString *const AllResult;
//必填结果页
extern NSString *const Required;
//abc结果页
extern NSString *const ABCPresentation;
//获取三级城市列表
extern NSString *const GetThisCityClass;
//效验手机合法性
extern NSString *const PhoneNumber;

/*------------------------------------------------------------*/
