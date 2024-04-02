
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:union_pay/http/net/api_exception.dart';
import 'package:union_pay/utils/view_util.dart';
import 'package:union_pay/widgets/page_error.dart';

class CustomEasyRefresh extends StatefulWidget {
  Future<void> Function() onRefresh;
  Future<void> Function()? onLoadMore;
  RefreshController controller;
  bool enableRefresh; //如果设置为true onRefresh 必须赋值
  bool enableLoadMore; //如果设置为true onLoadMore 必须赋值
  Widget? child;
  bool? loading = false;
  ApiException? error;

  CustomEasyRefresh(
      {Key? key,
      required this.onRefresh,
      this.onLoadMore,
      required this.controller,
      this.enableRefresh = true,
      this.enableLoadMore = true,
      this.error,
      this.loading = false,
      this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomEasyRefreshState();
}

class _CustomEasyRefreshState extends State<CustomEasyRefresh>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        if (widget.error != null)
          PageError(
            exception: widget.error,
            onRefresh: () => widget.enableRefresh ? widget.onRefresh : null,
          ),
        SmartRefresher(
          header: const MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = const Text('');
              } else if (mode == LoadStatus.loading) {
                body = const CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = const Text('');
              } else if (mode == LoadStatus.canLoading) {
                body = const Text('');
              } else {
                body = const Text('');
              }
              return SizedBox(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: widget.controller,
          enablePullDown: widget.enableRefresh ?? true,
          enablePullUp: widget.enableLoadMore,
          onLoading: widget.enableLoadMore ? widget.onLoadMore : null,
          onRefresh: widget.enableRefresh ? widget.onRefresh : null,
          child: widget.child,
        ),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: buildLoading(widget.loading),
        ),
      ],
    );
  }
}
