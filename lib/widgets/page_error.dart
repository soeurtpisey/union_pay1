
import 'package:flutter/material.dart';
import 'package:union_pay/components/custom_icons/custom_icons_icons.dart';
import 'package:union_pay/generated/l10n.dart';
import 'package:union_pay/widgets/common.dart';

import '../http/net/api_exception.dart';

class PageError extends StatelessWidget {
  final dynamic exception;
  final VoidCallback? onRefresh;

  const PageError({Key? key, this.exception, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          const SizedBox(
            width: 100.0,
            height: 100.0,
            child: FittedBox(child: Icon(CustomIcons.sad, color: Colors.black)),
          ),
          Container(
            padding: const EdgeInsets.all(25.0),
            child: Text(
                exception is ApiException &&
                    exception != null &&
                    exception.apiError == false &&
                    exception.statusError == false
                    ? S.of(context).errorTextCheckConnection
                    : S.of(context).errorTextReloadPage,
                style:
                const TextStyle(color: Colors.black, fontSize: 15.0, height: 1.5),
                textAlign: TextAlign.center),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 37.5, left: 37.5, top: 40.0),
                child: SizedBox(
                  width: 300.0,
                  height: 44.0,
                  child: btnWithLoading(
                    onTap: onRefresh,
                    title: S.of(context).errorButtonReloadPage,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
