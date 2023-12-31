import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernland_signflow/bloc/stream/orderbook_cubit.dart';
import 'package:modernland_signflow/bloc/stream/shareholder_movement_cubit.dart';
import 'package:modernland_signflow/bloc/stream/stream_cubit.dart';
import 'package:modernland_signflow/bloc/stream/stream_state.dart';
import 'package:modernland_signflow/data/dio_client.dart';
import 'package:modernland_signflow/di/service_locator.dart';
import 'package:modernland_signflow/repos/stream/stream_repository.dart';
import 'package:modernland_signflow/widget/common/shareholder_transaction_widget.dart';

class MDLNShareholderAllPage extends StatefulWidget {
  final String title;

  const MDLNShareholderAllPage({this.title = ""});

  @override
  State<MDLNShareholderAllPage> createState() => _MDLNShareholderAllPageState();
}

class _MDLNShareholderAllPageState extends State<MDLNShareholderAllPage> {
  late StreamCubit streamCubit;
  late OrderbookCubit orderbookCubit;
  late ShareholderMovementCubit shareholderCubit;

  @override
  void initState() {
    super.initState();
    final streamRepository = StreamRepository(dioClient: getIt<DioClient>());
    streamCubit = StreamCubit(streamRepository);
    orderbookCubit = OrderbookCubit(streamRepository);
    shareholderCubit = ShareholderMovementCubit(streamRepository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => shareholderCubit..fetchShareholder(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.widget.title),
        ),
        body: ContentWidget(),
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget();

  @override
  Widget build(BuildContext context) {
    final shareholderCubit = context.read<ShareholderMovementCubit>();
    return BlocBuilder<ShareholderMovementCubit, StreamState>(
      bloc: shareholderCubit..fetchShareholder(),
      builder: (context, state) {
        if (state is StreamStateLoading) {
          return Container(
              height: 100, child: Center(child: CupertinoActivityIndicator()));
        } else if (state is StreamStateLoadShareholder) {
          return Container(
            child: ListView.builder(
              itemCount: (state.datas.length),
              // Limit the count to a maximum of 5
              itemBuilder: (context, index) {
                final item = state.datas[index];
                var photoUrl = "";
                var isBuying = false;
                var shareHolderName = item.name ?? "Investor ";
                var buyingValue = item.changes?.value ?? "0";

                if (item.changes?.value?.contains("+") == true) {
                  isBuying = true;
                }

                var description = shareHolderName;

                if (isBuying) {
                  description += "\n" + buyingValue + " shares";
                } else {
                  description += "\n" + buyingValue + " shares";
                }
                return ShareholderTransactionWidget(
                  userName: item.name ?? "",
                  comment: description,
                  postingDate: item.date ?? "",
                  bottomText: (item.current?.percentage ?? "") + "%",
                );
              },
            ),
          );
        } else {
          return Text("Halo Gais");
        }
      },
    );
  }
}
