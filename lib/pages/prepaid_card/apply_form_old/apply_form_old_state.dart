
import 'package:get/get_rx/get_rx.dart';
import '../../../generated/l10n.dart';
import '../../../models/certificate_type.dart';
import '../../../models/prepaid/res/union_pay_card_config_model.dart';
import '../../../models/prepaid/union_pay_apply_old_param_model.dart';

class ApplyFormOldState {
  ApplyFormOldState() {
    ///Initialize variables
  }
  var isContinue = true.obs;
  UnionPayApplyOldParamModel? requestParam = UnionPayApplyOldParamModel();
  final List<CertificateType> idItems = [
    CertificateType('1', S.current.kycDocType_IdCard),
    CertificateType('3', S.current.kycDocType_Passport),
  ].obs;
  var idIndex = 0;

  UnionPayCardConfigModel? configModel;
  var isLoading = false.obs;
  String? requestError;
}
