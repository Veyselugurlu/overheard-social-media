import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/product/constants/product_colors.dart';

class SelectionTile extends StatelessWidget {
  const SelectionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final cubit = context.read<ShareCreationCubit>();
        final selectedCard = cubit.state.selectcards.firstWhere(
          (card) => card.title == title,
        );
        cubit.updatePostTarget(selectedCard);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side:
              isSelected
                  ? BorderSide(
                    color: ProductColors.instance.tynantBlue,
                    width: 2,
                  )
                  : BorderSide.none,
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color:
                isSelected
                    ? ProductColors.instance.tynantBlue
                    : ProductColors.instance.grey,
          ),
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(subtitle),
          trailing:
              isSelected
                  ? Icon(
                    Icons.check_circle,
                    color: ProductColors.instance.tynantBlue,
                  )
                  : null,
        ),
      ),
    );
  }
}
