import 'package:flutter/material.dart';
import 'package:h/components/user_default_image_component.dart';
import 'package:sizer/sizer.dart';

class CardMessageComponent extends StatefulWidget {
  const CardMessageComponent({super.key});

  @override
  State<CardMessageComponent> createState() => _CardMessageComponentState();
}

class _CardMessageComponentState extends State<CardMessageComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: UserDefaultImageComponent(),
          ),
          SizedBox(width: 2.w),
          SizedBox(
            width: 60.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FinnBolado',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'IRAAAADOOOO',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Text(
            '2 min',
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
