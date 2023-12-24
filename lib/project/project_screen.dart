import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/Model/repos_model.dart';
import 'package:github/utils/colors.dart';
import 'package:intl/intl.dart';

import '../utils/images.dart';
import '../utils/strings.dart';
import '../utils/styles.dart';
import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';

class ProjectPage extends StatefulWidget {
  ReposModel? item;

  ProjectPage(this.item, {Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProjectBloc()
        ..add(InitEvent(
            widget.item?.owner?.login ?? '', widget.item?.name ?? '', context)),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<ProjectBloc>(context);

    return BlocConsumer<ProjectBloc, ProjectState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is BranchState) {
            _tabController = TabController(
                initialIndex: selectedIndex,
                length: state.branchModel.length,
                vsync: this);
            _tabController.addListener(() {
              selectedIndex = _tabController.index;

              bloc.add(GetCommitLogs(
                  widget.item?.owner?.login ?? '',
                  widget.item?.name ?? '',
                  state.branchModel[selectedIndex].name ?? ''));
            });
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  Strings.project,
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                backgroundColor: AppColors.primaryColor,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: SafeArea(
                  child: Column(children: [
                Stack(
                  children: [
                    Container(
                      color: AppColors.primaryColor,
                      height: 120,
                    ),
                    Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                widget.item?.owner?.avatarUrl ?? ''),
                            radius: 20,
                          ),
                          title: Text(
                            widget.item?.name ?? '',
                            style: Styles.bodyBoldMedium
                                .copyWith(color: Colors.white),
                          ),
                          subtitle: Text(
                            widget.item?.owner?.login ?? '',
                            style:
                                Styles.bodyLight.copyWith(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              Text(
                                'Last update : ${DateFormat("dd/MM/yyyy hh:mm a").format(DateFormat("yyyy-MM-ddThh:mm:ssZ").parse(widget.item?.updatedAt ?? ''))}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBar(
                    controller: _tabController,
                    tabs: state.tabs,
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: state.selectedColor,
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: state.commitModel.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              leading: Image.asset(Images.folder),
                              title: Text(
                                state.commitModel[index].commit?.message ?? '',
                                style: Styles.bodyBoldMedium,
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${DateFormat("dd/MM/yy hh:mm a").format(DateFormat("yyyy-MM-ddThh:mm:ssZ").parse(state.commitModel[index].commit?.author?.date ?? ''))}',
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(Images.person),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(state.commitModel[index]
                                                .commit?.author?.name ??
                                            ''),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ])),
            );
          } else {
            return const Scaffold(
              appBar: null,
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  getChildrenData(BranchState state) {
    for (var item in state.branchModel) {}
  }
}
