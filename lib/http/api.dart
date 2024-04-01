

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

  //--------------Register--------------//
  static String get emailRegister => 'bongloy/user/register/email';
  static String get emailVerify => 'bongloy/user/register/optCode';
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
  static String get unionPayCardApply => 'unionPayCard/unionPayCardOpen';

  //跳过鉴权接口，伪装他人身份id
  static String get unionPayCardApplySkip =>
      'unionPayCard/unionPayCardOpenSkip';

  //银联卡开卡申请 老客户
  static String get unionPayCardOldApply => 'unionPayCard/unionPayCardOpenOld';

  //检查老客户参数
  static String get unionPayCardOpenOldCheck => 'unionPayCard/unionPayCardOpenOldCheck';

  //银联卡开卡申请 老客户   //跳过鉴权接口，伪装他人身份id
  static String get unionPayCardOldApplySkip =>
      'unionPayCard/unionPayCardOpenOldSkip';

  //实名卡激活
  static String get cardInfoActive => 'unionPayCard/cardInfoActive';

  //银联卡 充值
  static String get unionPayTopUp => 'unionPayCard/unionPayTopUp';

  //预充值
  static String get unionPrePayTopUp => 'unionPayCard/unionPrePayTopUp';

  //获取客户信息接口
  static String get unionPayCardCustomer => 'unionPayCard/unionPayCardCustomer';

  //卡转UPAY
  static String get bakongMemberTransfer => 'unionPayCard/bakongMemberTransfer';

  //持卡人姓名查询
  static String get customerInfoQuery => 'unionPayCard/customerInfoQuery';

  //银联卡：转账
  static String get cardTransfer => 'unionPayCard/cardTransfer';

  //卡配置信息接口
  static String get blCardConfig => 'unionPayCard/blCardConfig';

  //卡列表接口
  static String get blCardList => 'unionPayCard/blCardList';

  //申请卡是否支持
  static String get blCardApplyStatus => 'unionPayCard/blCardApplyStatus';
  static String get blCardApplyStatusNew => 'unionPayCard/blCardApplyStatusNew';

  //卡密码修改
  static String get cardPwdModify => 'unionPayCard/cardPwdModify';

  //省区社区
  static String get getProvince => 'region/getProvinces';

  static String get getDistricts => 'region/getDistricts';

  static String get getCommunes => 'region/getCommunes';

  //保存模版
  static String get saveOrUpdateTemplate => 'unionPayCard/saveOrUpdateTemplate';

  //模版列表
  static String get templateList => 'unionPayCard/listTemplate';

  //删除模版
  static String get delTemplate => 'unionPayCard/delTemplate';

  //冻结卡
  static String get freezeCard => 'unionPayCard/freezeCard';

  //解冻卡
  static String get unFreezeCard => 'unionPayCard/unFreezeCard';

  //历史列表
  static String get cardTransactionList => 'unionPayCard/cardTransactionList';

  //同步bongloy的历史列表
  static String get cardBongLoyTransactionList =>
      'unionPayCard/cardBongLoyTransactionList';

  //修改交易限额
  static String get setCardLimit => 'unionPayCard/setCardLimit';

  //修改卡别名
  static String get accountName => 'unionPayCard/accountName';

  //获取申请列表
  static String get blCardApplyList => 'unionPayCard/blCardApplyList';

  //保存cvv
  static String get setCardCVV => 'unionPayCard/setCardCVV';

  //查询交易限制
  static String get queryCardLimit => 'unionPayCard/queryCardLimit';

  //查询cvv
  static String get getCVV => 'unionPayCard/getCVV';

  //根据审核ID获取拒审记录
  static String get getApplyRecord => 'unionPayCard/getApplyRecord';

  static String get getApplyRecordById => 'unionPayCard/getApplyRecordById';



}
