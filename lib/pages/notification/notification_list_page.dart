import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/res/images_res.dart';
import 'package:union_pay/widgets/common.dart';
import '../../generated/l10n.dart';

class NotificationListPage extends StatefulWidget {
  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: cText(S().notification, color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500)),
      body: SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: true,
      header: const MaterialClassicHeader(
        color: Colors.black,
      ),
      // footer: CustomFooter(
      //     builder: (BuildContext context, LoadStatus? mode) {
      //       Widget body;
      //       var tempHeight = 55.0;
      //       if (mode == LoadStatus.idle) {
      //         body = Container();
      //       } else if (mode == LoadStatus.loading) {
      //         body = const CupertinoActivityIndicator();
      //       } else if (mode == LoadStatus.failed) {
      //         if (notifications?.isEmpty ?? false) {
      //           body = cText('Load Failed! Click retry!');
      //         } else {
      //           body = Container();
      //         }
      //       } else if (mode == LoadStatus.canLoading) {
      //         body = Container();
      //       } else {
      //         if (notifications?.isEmpty ?? false) {
      //           tempHeight = MediaQuery.of(context).size.height - 100;
      //           body = cText(
      //             S().no_data,
      //             textAlign: TextAlign.center,
      //           );
      //         } else {
      //           tempHeight = 60;
      //           body = cText(S().no_more_data);
      //         }
      //       }
      //       return SizedBox(
      //         height: tempHeight,
      //         child: Center(child: body),
      //       );
      //     }),
      // onRefresh: _reloadList,
      // onLoading: _loadList,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
        itemCount: 20,
        itemBuilder: (BuildContext c, int index) {
          return notificationItem();
        },
      ),
    )
    );


  }

  Widget notificationItem() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8))),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(children: [
          Image.asset(ImagesRes.NOTIFICATION_CARD_IC),
          const SizedBox(width: 8),
          cText('Your physical card', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          Expanded(child: cText('Reject', color: Colors.red, textAlign: TextAlign.right))
        ],),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(left: 32),
            child: cText('14 03 2024 | 12:00', color: AppColors.color9D9D9D)
        ),
        const SizedBox(height: 4),
        Padding(
            padding: const EdgeInsets.only(left: 32),
            child: cText('${S().card_number} 6263 0137 9900 0015', color: AppColors.color9D9D9D)
        )
      ],),
    );
  }
}