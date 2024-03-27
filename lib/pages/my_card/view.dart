import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/utils/view_util.dart';
import '../../app/base/app.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../helper/prepaid_card_helper.dart';
import '../../models/event/refresh_home_data.dart';
import '../../models/prepaid/enums/union_card_type.dart';
import '../../res/images_res.dart';
import '../../utils/screen_util.dart';
import '../../widgets/common.dart';
import '../../widgets/prepaid_card/new_card_bottom.dart';
import '../../widgets/silver_decorate_box.dart';
import '../notification/notification_list_page.dart';
import 'logic.dart';

class MyCardPage extends StatefulWidget {
  MyCardPage({Key? key}) : super(key: key);

  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  final logic = Get.put(MyCardLogic());
  final state = Get.find<MyCardLogic>().state;

  @override
  void initState() {
    super.initState();
    App.eventBus?.on<RefreshHomeData>().listen((event) {
      // initHomeItemsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: logic,
        builder: (viewModel) {
          return Scaffold(
              appBar: AppBar(
                leadingWidth: 200,
                leading: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: cText(S.current.my_card,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        textAlign: TextAlign.left)),
                actions: [
                  InkWell(
                    onTap: () {
                      Get.to(NotificationListPage());
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 17, top: 10),
                        child: Image.asset(ImagesRes.NOTIFICATION_READ_IC)),
                  )
                ],
              ),
              floatingActionButton: PrepaidCardHelper.blCardList.isEmpty
                  ? null
                  : FloatingActionButton(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      onPressed: () {
                        addNewCard();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(ImagesRes
                              .IC_FLOATING_NEW_CARD) //AssetsRes.IC_FLOATING_NEW_CARD.UIImage(),
                          ),
                    ),
              body: CustomScrollView(
                slivers: [
                  if (PrepaidCardHelper.blCardList.isEmpty)
                    ...buildSliverNoBankCard(),
                  if (PrepaidCardHelper.blCardList.isNotEmpty)
                    ...buildSliverBankCard()
                ],
              ));
        });
  }

  List<Widget> buildSliverNoBankCard() {
    return [
      SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          height: ScreenUtil.screenHeight - 174,
          child: Column(
            children: [
              Gaps.vGap70,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Image.asset(ImagesRes.IC_NO_CARD_HERE),
              ),
              Gaps.vGap30,
              cText(S().no_card_here,
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
              Gaps.vGap10,
              cText(S().no_card_here_des,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.color79747E)
                  .paddingSymmetric(horizontal: 50),
              Gaps.vGap20,
              buildNewCardBtn()
            ],
          ),
        ),
      )
    ];
  }

  Widget buildNewCardBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.colorE40C19,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(ImagesRes.NEW_CARD_IC),
          Gaps.hGap10,
          cText(S.of(context).new_card,
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          if (state.loading.value)
            Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.only(left: 10),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                  ),
                ))
        ],
      ),
    ).onDebounce(() {
      addNewCard();
    });
  }

  void pushFormPage(BuildContext context, UnionCardType unionCardType) {
    /// warning
    if (PrepaidCardHelper.blCardList.isEmpty) {
      // context.router.push(ApplyFormPageRoute(unionCardType: unionCardType));
    } else {
      // context.router.push(ApplyFormOldPageRoute(unionCardType: unionCardType));
    }
  }

  void addNewCard() async {
    if (state.loading.value) {
      return;
    }
    var applyStatus = await logic.checkStatusNew();
    if (applyStatus == null) {
      return;
    }
    var value = await showSheet(context, NewCardBottom(applyStatus: applyStatus));
    if (value != null && value is NewCardParam) {
      if (value.cardType == UnionCardType.physicalCard) {
        if (isAdminApplyCard) {
          pushFormPage(context, UnionCardType.physicalCard);
        } else {
          if (value.isAudit) {
            pushFormPage(context, UnionCardType.physicalCard);
          } else {
            showToast(S().you_card_apply_status_tips);
          }
        }
      } else {
        if (value.isAudit) {
          pushFormPage(context, UnionCardType.virtualCard);
        } else {
          showToast(S.of(context).you_card_apply_status_tips);
        }
      }
    }
  }

  List<Widget> buildSliverBankCard() {
    return [
      SliverToBoxAdapter(
        child: Container(
            padding: EdgeInsets.only(left: 18, top: 21),
            color: Colors.white,
            child: cText(S.of(context).my_card,
                textAlign: TextAlign.start,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
      ),
      SliverDecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var model = PrepaidCardHelper.blCardList[index];
            /// update later
            return Container();
            // return cardView(context, model, cardNumVisible: true, onDetail: () {
            //   context.pushRoute(PrepaidManagerPageRoute(model: model));
            // }).intoContainer(
            //     height: 206,
            //     margin: EdgeInsets.only(
            //         left: 16,
            //         right: 16,
            //         top: 15,
            //         bottom: index == PrepaidCardHelper.blCardList.length - 1
            //             ? 15
            //             : 0));
          },
          childCount: PrepaidCardHelper.blCardList.length,
        )),
      ),
    ];
  }


  @override
  void dispose() {
    Get.delete<MyCardLogic>();
    super.dispose();
  }
}
