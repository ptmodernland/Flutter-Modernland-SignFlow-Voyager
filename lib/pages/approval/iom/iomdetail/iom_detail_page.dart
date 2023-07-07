import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modernland_signflow/bloc/iom/approval_action_cubit.dart';
import 'package:modernland_signflow/bloc/iom/approval_comment_cubit.dart';
import 'package:modernland_signflow/bloc/iom/approval_detail_cubit.dart';
import 'package:modernland_signflow/bloc/iom/approval_head_dept_cubit.dart';
import 'package:modernland_signflow/bloc/iom/approval_state.dart';
import 'package:modernland_signflow/bloc/rekomendasi/rekomendasi_action_cubit.dart';
import 'package:modernland_signflow/bloc/rekomendasi/rekomendasi_state.dart';
import 'package:modernland_signflow/pages/approval/iom/log/iom_log_page.dart';
import 'package:modernland_signflow/pages/approval/koordinasi/koordinasi_choose_head.dart';
import 'package:modernland_signflow/repos/iom/approval_repository.dart';
import 'package:modernland_signflow/repos/rekomendasi/rekomendasi_repository.dart';
import 'package:modernland_signflow/util/core/string/html_util.dart';
import 'package:modernland_signflow/util/core/url/base_url.dart';
import 'package:modernland_signflow/util/enum/action_type.dart';
import 'package:modernland_signflow/util/my_theme.dart';
import 'package:modernland_signflow/widget/approval/document_detail_widget.dart';
import 'package:modernland_signflow/widget/approval/item_approval_widget.dart';
import 'package:modernland_signflow/widget/common/user_comment_widget.dart';
import 'package:modernland_signflow/widget/core/blurred_dialog.dart';
import 'package:modernland_signflow/widget/core/custom_text_input.dart';
import 'package:quickalert/quickalert.dart';

class IomDetailPage extends StatefulWidget {
  const IomDetailPage({Key? key,
    required this.idIom,
    required this.noIom,
    this.isFromHistory = false,
    this.idKoordinasi = "-99",
    this.isFromRekomendasi = false})
      : super(key: key);

  final String idIom;
  final String noIom;
  final String idKoordinasi;
  final bool isFromHistory;
  final bool isFromRekomendasi;

  @override
  State<IomDetailPage> createState() => _IomDetailPageState();
}

class _IomDetailPageState extends State<IomDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final messageController = TextEditingController();

  late ApprovalHeadDeptCubit iomDeptHeadCubit;
  late ApprovalDetailCubit iomDetailCubit;
  late ApprovalCommentCubit iomCommentCubit;
  late ApprovalActionCubit iomActionCubit;
  late RekomendasiActionCubit rekomendasictionCubit;

  @override
  void initState() {
    super.initState();
    rekomendasictionCubit = RekomendasiActionCubit(RekomendasiRepository());
    iomActionCubit = ApprovalActionCubit(ApprovalRepository());
    iomCommentCubit = ApprovalCommentCubit(ApprovalRepository());
    iomDetailCubit = ApprovalDetailCubit(ApprovalRepository());
    iomDeptHeadCubit = ApprovalHeadDeptCubit(ApprovalRepository());
    iomDetailCubit.fetchApprovals(widget.idIom);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          buildDetailIomPage(context),
          BlocBuilder<RekomendasiActionCubit, RekomendasiState>(
            bloc: rekomendasictionCubit,
            builder: (context, state) {
              if (state is RekomendasiStateLoading) {
                return BlurredDialog(loadingText: "Mengirim Koordinasi");
              }
              if (state is RekomendasiStateLoading) {
                return BlurredDialog(loadingText: "Mengirim Koordinasi");
              }
              return Container();
            },
          ),
          BlocProvider<ApprovalActionCubit>(
            create: (context) => iomActionCubit,
            // Replace with your actual cubit instantiation
            child: BlocBuilder<ApprovalActionCubit, ApprovalState>(
              bloc: iomActionCubit,
              builder: (context, state) {
                if (state is ApprovalLoading) {
                  return BlurredDialog(loadingText: "Please Wait");
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Scaffold buildDetailIomPage(BuildContext context) {
    return Scaffold(
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
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 30, right: 30, top: 0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Flexible(
                                      child: Text(
                                        "#" +
                                            widget.noIom +
                                            (widget.isFromRekomendasi
                                                ? "\n(Rekomendasi)"
                                                : ""),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: MyTheme.myStylePrimaryTextStyle
                                            .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
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
                      child: Container(
                        margin: EdgeInsets.only(top: 20, left: 0, right: 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30.0)),
                        ),
                        child: Container(),
                      ),
                    ),
                    BlocBuilder<ApprovalDetailCubit, ApprovalState>(
                      bloc: iomDetailCubit..fetchApprovals(widget.idIom),
                      builder: (context, state) {
                        if (state is ApprovalDetailLoading) {
                          return Container(
                              height: 400,
                              child: Center(child: Text("Loading")));
                        }
                        if (state is ApprovalDetailError) {
                          return Text("Success : " + state.message);
                        }
                        if (state is ApprovalDetailSuccess) {
                          var data = state.detailData;

                          var isApproved = false;
                          if (data.status != "Y" && data.status != "T") {
                            isApproved = true;
                          }
                          if (widget.isFromHistory) {
                            isApproved = true;
                          }

                          return Container(
                            child: Column(
                              children: [
                                ItemApprovalWidget(
                                  isApproved: isApproved,
                                  itemCode: data.nomor,
                                  date: data.tanggal,
                                  personName: data.namaUser,
                                  descriptiveText:
                                  removeHtmlTags(data.perihal ?? ""),
                                  departmentTitle: data.departemen,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 20.0),
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Document Header",
                                        textAlign: TextAlign.start,
                                        style: MyTheme.myStylePrimaryTextStyle
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: DocumentDetailWidget(
                                              title: "Perihal : ",
                                              content: removeHtmlTags(
                                                  data.perihal ?? ""),
                                            ),
                                          ),
                                          Expanded(
                                            child: DocumentDetailWidget(
                                              title: "Dari : ",
                                              content: removeHtmlTags(
                                                  data.dari ?? ""),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: DocumentDetailWidget(
                                              title: "Kepada : ",
                                              content: removeHtmlTags(
                                                  data.kepada ?? ""),
                                            ),
                                          ),
                                          Expanded(
                                            child: DocumentDetailWidget(
                                              title: "CC : ",
                                              content:
                                              removeHtmlTags(data.cc ?? ""),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "IOM " + (data.kategoriIom ?? ""),
                                        textAlign: TextAlign.start,
                                        style: MyTheme.myStylePrimaryTextStyle
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: DocumentDetailWidget(
                                              title: "Nomor IOM :",
                                              content: data.nomor ?? "",
                                            ),
                                          ),
                                          Expanded(
                                            child: DocumentDetailWidget(
                                              title: "Tanggal :",
                                              content: data.tanggal ?? "-",
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: DocumentDetailWidget(
                                                title: "Nama Karyawan :",
                                                content:
                                                data.namaUser ?? "MDLN Staff",
                                              )),
                                          Expanded(
                                            child: DocumentDetailWidget(
                                              title: "Department :",
                                              content: data.departemen ??
                                                  "Modernland",
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: DocumentDetailWidget(
                                                title: "View Detail",
                                                content: "Klik Disini",
                                                fileURL: DOC_VIEW_IOM +
                                                    (widget.idIom ?? ""),
                                              )),
                                          Expanded(
                                            child: DocumentDetailWidget(
                                              title: "Download File",
                                              content: data.attchLampiran ?? "",
                                              isForDownload: true,
                                              fileURL: ATTACH_DOWNLOAD_KASBON +
                                                  data.attchLampiran.toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => IomLogPage(
                                                noIom: data.nomor ?? "",
                                                title: "Log #" +
                                                    (data.nomor ?? ""),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("Lihat History"),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Komentar",
                                        textAlign: TextAlign.start,
                                        style: MyTheme.myStylePrimaryTextStyle
                                            .copyWith(
                                          fontSize: 18,
                                        ),
                                      ),
                                      if (!widget.isFromHistory)
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomTextInput(
                                                textEditController:
                                                messageController,
                                                hintTextString: 'Isi Tanggapan',
                                                inputType: InputType.Default,
                                                enableBorder: true,
                                                minLines: 3,
                                                themeColor: Theme.of(context)
                                                    .primaryColor,
                                                cornerRadius: 18.0,
                                                textValidator: (value) {
                                                  if (value?.isEmpty ?? true) {
                                                    return 'Isi field ini terlebih dahulu';
                                                  }
                                                  return null;
                                                },
                                                textColor: Colors.black,
                                                errorMessage:
                                                'Username cant be empty',
                                                labelText:
                                                'Tanggapan/Komentar/Review',
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return Text("Memuat Detail");
                      },
                    ),
                    BlocProvider<ApprovalActionCubit>(
                      create: (context) => iomActionCubit,
                      // Replace with your actual cubit instantiation
                      child: BlocListener<ApprovalActionCubit, ApprovalState>(
                        listener: (context, state) {
                          // Navigate to next screen
                          if (state is ApprovalStateApproveSuccess) {
                            showDialog(
                              context: context,
                              useSafeArea: false,
                              builder: (BuildContext context) {
                                var text = state.message;
                                return WillPopScope(
                                  onWillPop: () async {
                                    Navigator.of(context)
                                        .pop(); // Handle back button press
                                    return false; // Prevent dialog from being dismissed by back button
                                  },
                                  child: CupertinoAlertDialog(
                                    title: Text(
                                      'Success',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(text),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                          Navigator.of(context)
                                              .pop(); // Go back to the previous page
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }

                          if (state is ApprovalStateApproveError) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: state.message.toString(),
                            );
                          }

                          if (state is ApprovalStateRejectSuccess) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: state.message.toString(),
                            );
                          }
                          if (state is ApprovalStateRejectError) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: state.message.toString(),
                            );
                          }
                        },
                        child: Container(),
                      ),
                    ),
                    BlocBuilder<ApprovalCommentCubit, ApprovalState>(
                      bloc: iomCommentCubit..fetchApprovalComment(widget.noIom),
                      builder: (context, state) {
                        Widget emptyState = Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, bottom: 50, top: 50),
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
                                'Belum Ada Komentar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );

                        if (state is ApprovalLoading) {
                          return Text("");
                        }
                        if (state is ApprovalCommentError) {
                          return Text("Success : " + state.message);
                        }
                        if (state is ApprovalCommentSuccess) {
                          var commentList = state.comments;
                          var commentListViewBuilder = ListView.builder(
                            itemCount: commentList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final pbjItem = commentList[index];
                              var isApproved = false;
                              if (pbjItem.status != "T") {
                                isApproved = true;
                              }
                              if (widget.isFromHistory) {
                                isApproved = true;
                              }

                              return UserCommentWidget(
                                comment: pbjItem.komen ?? "",
                                userName: pbjItem.approve ?? "",
                                postingDate: pbjItem.tgl ?? "",
                                bottomText:
                                "Status : " + (pbjItem.statusApprove ?? ""),
                              );
                            },
                          );
                          return Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: commentListViewBuilder);
                        }
                        return emptyState;
                      },
                    ),
                    if (widget.isFromHistory != true)
                      Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (widget.isFromRekomendasi) {
                                  showPinInputDialog(
                                      type:
                                      ApprovalActionType.KOORDINASI_APPROVE,
                                      description:
                                      "\nAnda Yakin Ingin Mengapprove Koordinasi ini ?");
                                } else {
                                  showPinInputDialog(
                                      type: ApprovalActionType.APPROVE,
                                      description:
                                      "Anda Yakin Ingin Mengapprove Approval ini ?");
                                }
                              },
                              child: Text(
                                'Approve',
                                style: MyTheme.myStyleButtonTextStyle,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff33DC9F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (widget.isFromRekomendasi) {
                                  showPinInputDialog(
                                      type:
                                      ApprovalActionType.KOORDINASI_REJECT,
                                      description:
                                      "\nAnda Yakin Ingin Menolak Permintaan Koordinasi ini ?");
                                } else {
                                  showPinInputDialog(
                                      type: ApprovalActionType.REJECT,
                                      description:
                                      "Anda Yakin Ingin Menolak Approval ini ?");
                                }
                              },
                              child: Text(
                                'Reject',
                                style: MyTheme.myStyleButtonTextStyle,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffFF5B5B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                            ),
                            if (widget.isFromRekomendasi != true)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          KoordinasiChooseHeadPage(
                                            idIom: widget.idIom,
                                            nomorIom: widget.noIom,
                                          ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Recommend',
                                  style: MyTheme.myStyleButtonTextStyle,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffC4C4C4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // Adjust the radius as needed
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPinInputDialog({required ApprovalActionType type,
    String description = 'Masukkan PIN anda'}) {
    var pin = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Enter PIN',
            style: GoogleFonts.lato(),
          ),
          content: Column(
            children: [
              Text(description), // Added description here
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: CupertinoTextField(
                  key: _formKey2,
                  onChanged: (value) {
                    pin = value;
                  },
                  textAlign: TextAlign.start,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  placeholder: 'PIN',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                if (_formKey2.currentState?.validate() ?? true) {
                  Navigator.of(context).pop();
                  var comment = this.messageController.text;
                  print("send with comment " + comment);

                  if (type == ApprovalActionType.APPROVE) {
                    iomActionCubit.approveIom(
                        noIom: widget.noIom,
                        idIom: widget.idIom,
                        comment: messageController.text,
                        pin: pin);
                  }

                  if (type == ApprovalActionType.KOORDINASI_APPROVE) {
                    rekomendasictionCubit.approveKoordinasi(
                        comment: messageController.text,
                        noIom: widget.noIom,
                        idIom: widget.idIom,
                        idKoordinasi: widget.idKoordinasi,
                        pin: pin);
                  }

                  if (type == ApprovalActionType.KOORDINASI_REJECT) {
                    rekomendasictionCubit.rejectKoordinasi(
                        comment: messageController.text,
                        noIom: widget.noIom,
                        idIom: widget.idIom,
                        idKoordinasi: widget.idKoordinasi,
                        pin: pin);
                  }

                  if (type == ApprovalActionType.REJECT) {
                    iomActionCubit.rejectIom(
                        noIom: widget.noIom,
                        idIom: widget.idIom,
                        comment: messageController.text,
                        pin: pin);
                  }

                  // Perform any desired operations with the entered PIN
                  // Here, we're just printing it for demonstration purposes
                  print('Entered PIN: $pin with navigator' +
                      this.messageController.text.toString());
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
