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

  @override
  void initState() {
    context.read<SelectedGroupCubit>().initSelectedIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectedGroupCubit, SelectedGroupState>(
      listener: (context, state) {
        if (state.isInit) {
          itemController.jumpTo(index: state.selectedIndex);
        }
      },
      builder: (context, state) {
        return BlocBuilder<SelectedGroupCubit, SelectedGroupState>(
          builder: (context, state) {
            return ScrollablePositionedList.builder(
                initialScrollIndex: state.selectedIndex,
                itemScrollController: itemController,
                itemCount: widget.groups?.length ?? 0,
                scrollDirection: Axis.horizontal,
                // shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: ((context, index) {
                  int selectedIndex = state.selectedIndex;
                  // Kondisi ketika ada user login di 2 device yang sama,
                  // Yang satu menghapus groups,
                  // Sedangkan yang satunya masih menyimpan data selected index
                  if (state.selectedIndex >= widget.groups!.length) {
                    selectedIndex = 0;
                    context.read<SelectedGroupCubit>().setSelectedIndex(0);
                  }
                  return GestureDetector(
                    onTap: () => context
                        .read<SelectedGroupCubit>()
                        .setSelectedIndex(index),
                    child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: index == selectedIndex
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
