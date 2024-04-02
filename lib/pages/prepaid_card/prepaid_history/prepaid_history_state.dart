import '../../../models/prepaid/res/union_pay_history_res_entity.dart';

class PrepaidHistoryState {
  PrepaidHistoryState() {
    ///Initialize variables
  }
  bool isLoading = true;
  bool isError = false;
  String filterType = 'yyyy-MM';
  var historyList = <BongLoyCardOrderDto>[];
  var startTime = '';
  var endTime = '';

  double transferAmount = 0.00;
  double topUpAmount = 0.00;
}
