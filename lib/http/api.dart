

import '../app/config/app_config.dart';

class Api {
  static String get baseUrl => Env.envConfig.apiUrl;


  //cloud storage
  static const String baseFileUrl = 'https://file.u-pay.com/storage/file/';
  static const String bucketId = '1232548112614445057';
  static const String accessKey = '9f91Zusijy';
  static const String secretKey = 'KCzZSft6CsE3';

  //upload image
  static const String uploadImageFile = 'uploadImageFile';
  static String get getCustomImage => 'getCustomImage';
  static String get uploadSingleFile => 'uploadSingleFile';

  //--------------login start--------------//
  static String get emailLogin => 'bongloy/user/login/email';
  static String get phoneLogin => 'bongloy/user/login/phone';
  //-----------------login end-----------------//

  //--------------Register----------------//
  static String get emailRegister => 'bongloy/user/register/email';
  static String get emailRegisterSendOTP => 'bongloy/user/register/optCode';
  static String get emailRegisterVerifyOTP => 'bongloy/user/register/verifyOptCode/email';
  static String get phoneRegister => 'bongloy/user/register/phone';
  //-----------------Register end-----------------//

  //--------------Forget Password--------------//
  static String get forgetPassSendOTPByEmail => 'bongloy/user/changePassword/optCode/email';
  static String get forgetPassByEmail => 'bongloy/user/changePassword/email';
  static String get verifyOTPForgetPassByEmail => 'bongloy/user/changePassword/verifyOptCode/email';
  static String get forgetPassSendOTPByPhone => 'bongloy/user/changePassword/optCode/phone';
  static String get verifyOTPForgetPassByPhone => 'bongloy/user/changePassword/verifyOptCode/phone';
  static String get forgetPassByPhone => 'bongloy/user/changePassword/phone';
  //-----------------Forget Password end-----------------//

  //----------------Refresh Session----------------//
  static String get refreshToken => 'auth/refreshToken';
  //----------------Refresh Session end------------//

  //----------------User Info----------------//
  static String get userInfo => 'bongloy/user/userInfo';
  //----------------User Info end-------------//

  //-----------------Union Pay------------------//

  //银联卡开卡申请 新客户
  static String get unionPayCardApply => 'bongloy/v1/unionPayCard/unionPayCardOpen';

  //跳过鉴权接口，伪装他人身份id
  static String get unionPayCardApplySkip => 'bongloy/v1/unionPayCard/unionPayCardOpenSkip';

  //银联卡开卡申请 老客户
  static String get unionPayCardOldApply => 'bongloy/v1/unionPayCard/unionPayCardOpenOld';

  //检查老客户参数
  static String get unionPayCardOpenOldCheck => 'bongloy/v1/unionPayCard/unionPayCardOpenOldCheck';

  //银联卡开卡申请 老客户   //跳过鉴权接口，伪装他人身份id
  static String get unionPayCardOldApplySkip => 'bongloy/v1/unionPayCard/unionPayCardOpenOldSkip';

  //实名卡激活
  static String get cardInfoActive => 'bongloy/v1/unionPayCard/cardInfoActive';

  //银联卡 充值
  static String get unionPayTopUp => 'bongloy/v1/unionPayCard/unionPayTopUp';

  //预充值
  static String get unionPrePayTopUp => 'bongloy/v1/unionPayCard/unionPrePayTopUp';

  //获取客户信息接口
  static String get unionPayCardCustomer => 'bongloy/v1/unionPayCard/unionPayCardCustomer';

  //卡转UPAY
  static String get bakongMemberTransfer => 'bongloy/v1/unionPayCard/bakongMemberTransfer';

  //持卡人姓名查询
  static String get customerInfoQuery => 'bongloy/v1/unionPayCard/customerInfoQuery';

  //银联卡：转账
  static String get cardTransfer => 'bongloy/v1/unionPayCard/cardTransfer';

  //卡配置信息接口
  static String get blCardConfig => 'bongloy/v1/unionPayCard/blCardConfig';

  //卡列表接口
  static String get blCardList => 'bongloy/v1/unionPayCard/blCardList';

  //申请卡是否支持
  static String get blCardApplyStatus => 'bongloy/v1/unionPayCard/blCardApplyStatus';
  static String get blCardApplyStatusNew => 'bongloy/v1/unionPayCard/blCardApplyStatusNew';

  //卡密码修改
  static String get cardPwdModify => 'bongloy/v1/unionPayCard/cardPwdModify';

  //省区社区
  static String get getProvince => 'bongloy/v1/region/getProvinces';

  static String get getDistricts => 'bongloy/v1/region/getDistricts';

  static String get getCommunes => 'bongloy/v1/region/getCommunes';

  //保存模版
  static String get saveOrUpdateTemplate => 'bongloy/v1/unionPayCard/saveOrUpdateTemplate';

  //模版列表
  static String get templateList => 'bongloy/v1/unionPayCard/listTemplate';

  //删除模版
  static String get delTemplate => 'bongloy/v1/unionPayCard/delTemplate';

  //冻结卡
  static String get freezeCard => 'bongloy/v1/unionPayCard/freezeCard';

  //解冻卡
  static String get unFreezeCard => 'bongloy/v1/unionPayCard/unFreezeCard';

  //历史列表
  static String get cardTransactionList => 'bongloy/v1/unionPayCard/cardTransactionList';

  //同步bongloy的历史列表
  static String get cardBongLoyTransactionList =>
      'bongloy/v1/unionPayCard/cardBongLoyTransactionList';

  //修改交易限额
  static String get setCardLimit => 'bongloy/v1/unionPayCard/setCardLimit';

  //修改卡别名
  static String get accountName => 'bongloy/v1/unionPayCard/accountName';

  //获取申请列表
  static String get blCardApplyList => 'bongloy/v1/unionPayCard/blCardApplyList';

  //保存cvv
  static String get setCardCVV => 'bongloy/v1/unionPayCard/setCardCVV';

  //查询交易限制
  static String get queryCardLimit => 'bongloy/v1/unionPayCard/queryCardLimit';

  //查询cvv
  static String get getCVV => 'bongloy/v1/unionPayCard/getCVV';

  //根据审核ID获取拒审记录
  static String get getApplyRecord => 'bongloy/v1/unionPayCard/getApplyRecord';

  static String get getApplyRecordById => 'bongloy/v1/unionPayCard/getApplyRecordById';



}
