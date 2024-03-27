
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/res/images_res.dart';
import '../../constants/style.dart';
import '../../generated/l10n.dart';
import '../../helper/colors.dart';
import '../../models/certificate_type.dart';
import '../../models/prepaid/enums/doc_type.dart';
import '../common.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2023/9/12 18:36
/// @Description:
/// /////////////////////////////////////////////

class CertificateSelect extends StatefulWidget {
  final DocType selectType;
  final List<CertificateType> items;
  final ValueChanged<CertificateType> onResult;

  const CertificateSelect(
      {super.key,
      required this.selectType,
      required this.onResult,
      required this.items});

  @override
  State<CertificateSelect> createState() => _CertificateSelectState();
}

class _CertificateSelectState extends State<CertificateSelect> {
  DocType selectType = DocType.ID_CARD;

  @override
  void initState() {
    super.initState();
    selectType = widget.selectType;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.selectType!=selectType){
      selectType=widget.selectType;
    }
    return Row(
      children: [
        _buildIDCertification().onClick(() {
          setType(DocType.ID_CARD);
        }),
        Gaps.hGap55,
        _buildPassword().onClick(() {
          setType(DocType.PASSPORT);
        })
      ],
    );
  }

  void setType(DocType type) {
    setState(() {
      selectType = type;
    });
    var select = widget.items.firstWhere(
        (element) => DocTypeValue.typeFromStr2(element.type) == type);
    widget.onResult.call(select);
  }

  Widget buildDefaultRadio() {
    return const Icon(
      Icons.radio_button_off,
      color: Colors.black,
    );
  }

  Widget buildSelectRadio() {
    return const Icon(
      Icons.radio_button_checked,
      color: AppColors.colorE40C19,
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagesRes.IC_CARD_PASSPORT.UIImage(),
        Gaps.vGap10,
        cText(S().kycDocType_Passport,
            fontSize: 16, color: AppColors.color79747E),
        Gaps.vGap10,
        selectType == DocType.PASSPORT
            ? buildSelectRadio()
            : buildDefaultRadio(),
      ],
    );
  }

  Widget _buildIDCertification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagesRes.IC_NOTIONAL_ID_CARD.UIImage(),
        Gaps.vGap10,
        cText(S.of(context).kycDocType_IdCard,
            fontSize: 16, color: AppColors.color79747E),
        Gaps.vGap10,
        selectType == DocType.ID_CARD
            ? buildSelectRadio()
            : buildDefaultRadio(),
      ],
    );
  }
}
