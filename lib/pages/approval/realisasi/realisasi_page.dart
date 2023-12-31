import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernland_signflow/bloc/all_approval/approval_main_page_bloc.dart';
import 'package:modernland_signflow/bloc/all_approval/approval_main_page_event.dart';
import 'package:modernland_signflow/bloc/all_approval/approval_main_page_state.dart';
import 'package:modernland_signflow/bloc/notif/notif_bloc.dart';
import 'package:modernland_signflow/bloc/notif/notif_event.dart';
import 'package:modernland_signflow/bloc/notif/notif_state.dart';
import 'package:modernland_signflow/data/dio_client.dart';
import 'package:modernland_signflow/di/service_locator.dart';
import 'package:modernland_signflow/pages/approval/kasbon/kasbon_waiting_approval_page.dart';
import 'package:modernland_signflow/pages/approval/realisasi/realisasi_approved_all_page.dart';
import 'package:modernland_signflow/pages/approval/realisasi/realisasi_detail_page.dart';
import 'package:modernland_signflow/repos/approval_main_page_repository.dart';
import 'package:modernland_signflow/repos/notif_repository.dart';
import 'package:modernland_signflow/util/core/string/html_util.dart';
import 'package:modernland_signflow/util/enum/menu_type.dart';
import 'package:modernland_signflow/util/my_theme.dart';
import 'package:modernland_signflow/widget/approval/item_approval_widget.dart';
import 'package:modernland_signflow/widget/menus/menu_item_approval_widget.dart';

class ApprovalRealisasiMainPage extends StatefulWidget {
  const ApprovalRealisasiMainPage({Key? key}) : super(key: key);

  @override
  State<ApprovalRealisasiMainPage> createState() =>
      _ApprovalRealisasiMainPageState();
}

class _ApprovalRealisasiMainPageState extends State<ApprovalRealisasiMainPage> {
  late NotifCoreBloc notifBloc;
  late ApprovalMainPageBloc approvalBloc;

  @override
  void initState() {
    super.initState();
    var notifRepository = NotifRepository(dioClient: getIt<DioClient>());
    notifBloc = NotifCoreBloc(notifRepository);

    var approvalRepo =
        ApprovalMainPageRepository(dioClient: getIt<DioClient>());
    approvalBloc = ApprovalMainPageBloc(approvalRepo);
  }

  @override
  Widget build(BuildContext context) {
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
                                    IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Realisasi Kasbon",
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
                                                      count = state.totalRealisasi;
                                                    }
                                                    return MenuItemApprovalWidget(
                                                      unreadBadgeCount: count,
                                                      onLeftTapFunction: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                KasbonWaitingApprovalPage(),
                                                          ),
                                                        ).then((value) {
                                                          notifBloc
                                                            ..add(
                                                                NotifEventCount());
                                                          approvalBloc
                                                            ..add(RequestDataEvent(
                                                                ApprovalListType
                                                                    .REALISASI));
                                                          print("kocak " +
                                                              value.toString());
                                                        });
                                                      },
                                                      onRightTapFunction: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                RealisasiAllApprovedPage(),
                                                          ),
                                                        ).then((value) {
                                                          notifBloc
                                                            ..add(
                                                                NotifEventCount());
                                                          approvalBloc
                                                            ..add(RequestDataEvent(
                                                                ApprovalListType
                                                                    .REALISASI));
                                                          print("kocak " +
                                                              value.toString());
                                                        });
                                                      },
                                                    );
                                                  }),
                                            ],
                                          ),
                                        )),
                                    Container(
                                      width: double.infinity,
                                      margin:
                                      EdgeInsets.only(left: 20, right: 20),
                                      child: Text(
                                        "Request Terbaru",
                                        textAlign: TextAlign.start,
                                        style: MyTheme.myStylePrimaryTextStyle
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
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
                            ..add(RequestDataEvent(ApprovalListType.REALISASI));
                        },
                        child: BlocBuilder<ApprovalMainPageBloc,
                            ApprovalMainPageState>(
                          builder: (context, state) {
                            var status = "";
                            Widget dataList = Text("");
                            if (state is ApprovalMainPageStateLoading) {}
                            if (state is ApprovalMainPageStateFailure) {}
                            if (state
                            is ApprovalMainPageStateSuccessListRealisasi) {
                              var pbjList = state.datas;

                              if (pbjList.isEmpty) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 50, left: 20, right: 20),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        'http://feylabs.my.id/fm/mdln_asset/mdln_empty_image.png',
                                        // Adjust the image properties as per your requirement
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Belum Ada Request Baru',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              dataList = ListView.builder(
                                itemCount: pbjList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final pbjItem = pbjList[index];
                                  var isApproved = false;
                                  if (pbjItem.status != "Y") {
                                    isApproved = true;
                                  }
                                  return ItemApprovalWidget(
                                    isApproved: isApproved,
                                    itemCode: (index + 1).toString() +
                                        pbjItem.noRealisasi.toString(),
                                    date: pbjItem.tglBuat,
                                    requiredId: pbjItem.idRealisasi,
                                    personName: pbjItem.namaUser,
                                    departmentTitle: pbjItem.departemen,
                                    descriptiveText: removeHtmlTags(
                                        ("No Kasbon Yang Akan Direalisasi : \n" +
                                            (pbjItem.noKasbon ?? ""))),
                                    onPressed: (String noCompare) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RealisasiDetailPage(
                                                noRealisasi:
                                                pbjItem.noRealisasi ?? "",
                                                isFromHistory: false,
                                              ),
                                        ),
                                      ).then((value) {
                                        notifBloc..add(NotifEventCount());
                                        approvalBloc
                                          ..add(RequestDataEvent(
                                              ApprovalListType.REALISASI));
                                      });
                                    },
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
