import 'package:arisan_digital/blocs/home/selected_group_cubit/selected_group_cubit.dart';
import 'package:arisan_digital/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key, this.groups}) : super(key: key);

  final List<GroupModel>? groups;

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  final ItemScrollController itemController = ItemScrollController();
  int selectedIndex = 0;

  @override
  void initState() {
    selectedIndex = widget.groups!.isNotEmpty ? (widget.groups!.length - 1) : 0;
    context.read<SelectedGroupCubit>().initSelectedIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild master');
    return BlocConsumer<SelectedGroupCubit, SelectedGroupState>(
      listener: (context, state) {
        itemController.jumpTo(index: state.selectedIndex);
      },
      builder: (context, state) {
        return BlocBuilder<SelectedGroupCubit, SelectedGroupState>(
          builder: (context, state) {
            return ScrollablePositionedList.builder(
                initialScrollIndex: state.selectedIndex,
                itemScrollController: itemController,
                itemCount: widget.groups?.length ?? 0,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () => context
                        .read<SelectedGroupCubit>()
                        .setSelectedIndex(index),
                    child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: index == state.selectedIndex && !state.isInit
                                ? Colors.white.withOpacity(0.2)
                                : null,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(widget.groups![index].name ?? '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))),
                  );
                }));
          },
        );
      },
    );
  }
}
