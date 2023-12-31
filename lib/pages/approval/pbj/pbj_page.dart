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
import 'package:modernland_signflow/pages/approval/pbj/detail_pbj_page.dart';
import 'package:modernland_signflow/pages/approval/pbj/filter/pbj_approved_all.dart';
import 'package:modernland_signflow/pages/approval/pbj/pbj_waiting_approval.dart';
import 'package:modernland_signflow/repos/approval_main_page_repository.dart';
import 'package:modernland_signflow/repos/notif_repository.dart';
import 'package:modernland_signflow/util/enum/menu_type.dart';
import 'package:modernland_signflow/util/my_theme.dart';
import 'package:modernland_signflow/widget/approval/item_approval_widget.dart';
import 'package:modernland_signflow/widget/menus/menu_item_approval_widget.dart';

class ApprovalPBJMainPage extends StatefulWidget {
  const ApprovalPBJMainPage({Key? key}) : super(key: key);

  @override
  State<ApprovalPBJMainPage> createState() => _ApprovalPBJMainPageState();
}

class _ApprovalPBJMainPageState extends State<ApprovalPBJMainPage> {
  late NotifRepository notifRepository;
  late NotifCoreBloc notifBloc;

  late ApprovalMainPageRepository approvalRepo;
  late ApprovalMainPageBloc approvalBloc;

  @override
  void initState() {
    super.initState();
    notifRepository = NotifRepository(dioClient: getIt<DioClient>());
    notifBloc = NotifCoreBloc(notifRepository);
    approvalRepo = ApprovalMainPageRepository(dioClient: getIt<DioClient>());
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
                                                      titleLeft:
                                                      "Menunggu\nApproval",
                                                      titleRight:
                                                      "History\nApproval",
                                                      onLeftTapFunction: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PBJWaitingApproval(),
                                                          ),
                                                        ).then((value) {
                                                          notifBloc
                                                            ..add(
                                                                NotifEventCount());
                                                          approvalBloc
                                                            ..add(RequestDataEvent(
                                                                ApprovalListType
                                                                    .PBJ));
                                                        });
                                                      },
                                                      onRightTapFunction: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PBJAllApprovedPage(),
                                                          ),
                                                        ).then((value) {
                                                          notifBloc
                                                            ..add(
                                                                NotifEventCount());
                                                          approvalBloc
                                                            ..add(RequestDataEvent(
                                                                ApprovalListType
                                                                    .PBJ));
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
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [],
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
                              if (pbjList.isEmpty) {
                                return Container(
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
                                        'No data available',
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
                                    requiredId: pbjItem.noPermintaan,
                                    isApproved: isApproved,
                                    itemCode: pbjItem.noPermintaan,
                                    date: pbjItem.tglPermintaan,
                                    departmentTitle: pbjItem.departemen ?? "",
                                    personName: (pbjItem.namaUser ?? ""),
                                    personImage: "",
                                    onPressed: (String requiredId) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPBJPage(
                                              noPermintaan: requiredId),
                                        ),
                                      ).then((value) {
                                        notifBloc..add(NotifEventCount());
                                        approvalBloc
                                          ..add(RequestDataEvent(
                                              ApprovalListType.PBJ));
                                        print("kocak " + value.toString());
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
