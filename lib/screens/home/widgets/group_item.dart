import 'package:arisan_digital/models/group_model.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({Key? key, this.groups}) : super(key: key);

  final List<GroupModel>? groups;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: groups?.length ?? 0,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: ((context, index) {
          return Container(
              margin: const EdgeInsets.only(right: 5),
              height: 30,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: index == 0 ? Colors.white.withOpacity(0.2) : null,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(groups![index].name ?? '',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))));
        }));
  }
}
