import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CardMensagemComponent extends StatefulWidget {
  const CardMensagemComponent({super.key});

  @override
  State<CardMensagemComponent> createState() => _CardMensagemComponentState();
}

class _CardMensagemComponentState extends State<CardMensagemComponent> {
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
            child: const Image(
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              image: ResizeImage(
                AssetImage(
                  "assets/images/perfil.png",
                ),
                width: 156,
                height: 275,
              ),
            ),
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
