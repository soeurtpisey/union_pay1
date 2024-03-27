
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import '../../../constants/style.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';
import '../../../helper/prepaid_card_helper.dart';
import '../../../models/prepaid/enums/union_card_menu_type.dart';
import '../../../models/prepaid/res/union_pay_card_res_model.dart';
import '../../../utils/dialog_util.dart';
import '../../../widgets/common.dart';
import '../../../widgets/prepaid_card/prepaid_account_item.dart';
import '../prepaid_change_account_name/prepaid_change_account_view.dart';
import 'prepaid_account_logic.dart';

class PrepaidAccountPage extends StatefulWidget {
  const PrepaidAccountPage({Key? key}) : super(key: key);

  @override
  _PrepaidAccountPageState createState() => _PrepaidAccountPageState();
}

class _PrepaidAccountPageState extends State<PrepaidAccountPage> {
  final logic = Get.put(PrepaidAccountLogic());
  final state = Get.find<PrepaidAccountLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: logic,
        builder: (viewModel) {
          return cScaffold(context, S.current.profile_account,
              appBarColor: Colors.white,
              appBarBgColor: AppColors.colorFF3E47,
              child: Stack(
                children: [
                  Obx(() => Container(
                      height: 150,
                      color: AppColors.colorFF3E47,
                      child: CustomPaint(
                        painter: TogView(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gaps.vGap10,
                            cText(S.current.all_amount,
                                color: AppColors.colorA6FFFFFF),
                            Gaps.vGap10,
                            cText(
                                '${PrepaidCardHelper.totalAccountAmount.value}',
                                color: Colors.white,
                                fontSize: 36),
                          ],
                        ).intoContainer(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 15)),
                      ))).intoPositioned(left: 0, top: 0, right: 0),
                  Obx(() => ListView.builder(
                          itemCount: PrepaidCardHelper.blCardList.length,
                          itemBuilder: (context, index) {
                            var data = PrepaidCardHelper.blCardList[index];
                            return PrepaidAccountView(
                              model: data,
                              onMenuSelect: (type) {
                                switch (type) {
                                  case UnionCardMenuType.DEFAULT:
                                    break;
                                  case UnionCardMenuType.CHANGE_ACCOUNT_NAME:
                                    _showChangeAccountNameDialog(data);
                                    // logic.accountName(index, data, 'Test222');
                                    break;
                                  case UnionCardMenuType.SHARE_ACCOUNT:
                                    break;
                                }
                              },
                            );
                          }))
                      .intoPositioned(left: 0, top: 100, right: 0, bottom: 0),
                ],
              ));
        });
  }

  void _showChangeAccountNameDialog(UnionPayCardResModel model) {
    DialogUtil.showSimpleDialog2(
        context,
        PrepaidChangeAccountNamePage(
          model: model,
        )).then((value) {
      if (value!=null) {
        logic.update();
      }
    });
  }

  @override
  void dispose() {
    Get.delete<PrepaidAccountLogic>();
    super.dispose();
  }
}

class TogView extends CustomPainter {
  final Paint _paint = Paint()
    ..color = AppColors.colorFF3E47 //画笔颜色
    ..strokeCap = StrokeCap.butt //画笔笔触类型
    // ..isAntiAlias = true //是否启动抗锯齿
    // ..blendMode = BlendMode.exclusion //颜色混合模式
    ..style = PaintingStyle.fill //绘画风格，默认为填充
    // ..colorFilter = ColorFilter.mode(Colors.redAccent,
    //     BlendMode.exclusion) //颜色渲染模式，一般是矩阵效果来改变的,但是flutter中只能使用颜色混合模式
    // ..maskFilter = MaskFilter.blur(BlurStyle.inner, 3.0) //模糊遮罩效果，flutter中只有这个
    ..filterQuality = FilterQuality.high //颜色渲染模式的质量
    ..strokeWidth = 1.0; //

  @override
  void paint(Canvas canvas, Size size) {
    // Path path = new Path();
    // path.moveTo(0, 0);
    // path.lineTo(100, 100);
    // path.lineTo(200, 200);
    // path.lineTo(0, 0);
    // path.close();
    // canvas.drawPath(path, _paint);
    // canvas.drawCircle(Offset(100, 100), 50, _paint);
    canvas.drawLine(Offset(20.0, 20.0), Offset(100.0, 100.0), _paint);
    // const PI = 3.1415926;
    // Rect rect2 = Rect.fromCircle(center: Offset(100.0, 50.0), radius: 200.0);
    // canvas.drawArc(rect2, -PI, PI, false, _paint,);

    // Rect rect1 = Rect.fromPoints(Offset(150.0, 200.0), Offset(300.0, 250.0));
    // canvas.drawOval(rect1, _paint);

    var startPoint = Offset(0, size.height); // 开始位置
    var controlPoint1 = Offset(size.width / 4, size.height / 3 * 4); // 控制点
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3 * 4); //控制点
    var endPoint = Offset(size.width, size.height); //结束位置

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(TogView oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TogView oldDelegate) => false;
}
