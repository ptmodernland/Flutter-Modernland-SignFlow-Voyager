import 'package:modernland_signflow/bloc/all_approval/approval_main_page_bloc.dart';
import 'package:modernland_signflow/bloc/all_approval/approval_main_page_event.dart';
import 'package:modernland_signflow/bloc/all_approval/approval_main_page_state.dart';
import 'package:modernland_signflow/bloc/notif/notif_bloc.dart';
import 'package:modernland_signflow/bloc/notif/notif_event.dart';
import 'package:modernland_signflow/bloc/notif/notif_state.dart';
import 'package:modernland_signflow/data/dio_client.dart';
import 'package:modernland_signflow/di/service_locator.dart';
import 'package:modernland_signflow/repos/approval_main_page_repository.dart';
import 'package:modernland_signflow/repos/notif_repository.dart';
import 'package:modernland_signflow/util/enum/menu_type.dart';
import 'package:modernland_signflow/util/my_theme.dart';
import 'package:modernland_signflow/widget/approval/item_approval_widget.dart';
import 'package:modernland_signflow/widget/menus/menu_item_approval_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TestAllPBJPage extends StatefulWidget {
  const TestAllPBJPage({Key? key}) : super(key: key);

  @override
  State<TestAllPBJPage> createState() => _TestAllPBJPageState();
}

class _TestAllPBJPageState extends State<TestAllPBJPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var notifRepository = NotifRepository(dioClient: getIt<DioClient>());
    NotifCoreBloc notifBloc = NotifCoreBloc(notifRepository);

    ApprovalMainPageRepository approvalRepo =
        ApprovalMainPageRepository(dioClient: getIt<DioClient>());
    ApprovalMainPageBloc approvalBloc = ApprovalMainPageBloc(approvalRepo);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'asset/img/background/bg_pattern_fp.png'),
                                  repeat: ImageRepeat.repeat,
                                ),
                              ),
                              width: double.infinity,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 30, right: 30, top: 10),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Permohonan Barang dan Jasa",
                                        style: MyTheme.myStylePrimaryTextStyle
                                            .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        width: MediaQuery.sizeOf(context).width,
                        child: Stack(
                          children: [
                            Container(
                              margin:
                              EdgeInsets.only(top: 20, left: 0, right: 0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30.0)),
                              ),
                              child: Container(
                                child: Column(
                                  children: [
                                    BlocProvider(
                                        create: (BuildContext context) {
                                          return notifBloc
                                            ..add(NotifEventCount());
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              BlocBuilder<NotifCoreBloc,
                                                  NotifCoreState>(
                                                  builder: (context, state) {
                                                    var count = "";
                                                    if (state
                                                    is NotifStateLoading) {}
                                                    if (state
                                                    is NotifStateFailure) {}
                                                    if (state
                                                    is NotifStateSuccess) {
                                                      count = state.totalPermohonan;
                                                    }
                                                    return MenuItemApprovalWidget(
                                                      unreadBadgeCount: count,
                                                      onLeftTapFunction: () {
                                                        Fluttertoast.showToast(
                                                            msg: "Left",
                                                            toastLength:
                                                            Toast.LENGTH_SHORT,
                                                            gravity:
                                                            ToastGravity.CENTER,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor:
                                                            Colors.red,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0);
                                                      },
                                                      onRightTapFunction: () {
                                                        Fluttertoast.showToast(
                                                            msg: "Right",
                                                            toastLength:
                                                            Toast.LENGTH_SHORT,
                                                            gravity:
                                                            ToastGravity.CENTER,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor:
                                                            Colors.red,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0);
                                                      },
                                                    );
                                                  }),
                                            ],
                                          ),
                                        )),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Request Terbaru",
                                            textAlign: TextAlign.start,
                                            style: MyTheme
                                                .myStylePrimaryTextStyle
                                                .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocProvider(
                        create: (BuildContext context) {
                          return approvalBloc
                            ..add(RequestDataEvent(ApprovalListType.PBJ));
                        },
                        child: BlocBuilder<ApprovalMainPageBloc,
                            ApprovalMainPageState>(
                          builder: (context, state) {
                            var status = "";
                            Widget dataList = Text("");
                            if (state is ApprovalMainPageStateLoading) {}
                            if (state is ApprovalMainPageStateFailure) {}
                            if (state is ApprovalMainPageStateSuccessListPBJ) {
                              var pbjList = state.datas;
                              dataList = ListView.builder(
                                itemCount: pbjList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final pbjItem = pbjList[index];
                                  var isApproved = false;
                                  if (pbjItem.status != "T") {
                                    isApproved = true;
                                  }
                                  return ItemApprovalWidget(
                                    isApproved: isApproved,
                                    itemCode:
                                        "${index + 1} ${pbjItem.noPermintaan}(${pbjList.length})",
                                    date: pbjItem.tglPermintaan,
                                    departmentTitle: pbjItem.jenis,
                                  );
                                },
                              );
                            }
                            return Container(
                              child: dataList,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
