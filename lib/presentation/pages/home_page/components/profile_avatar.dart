import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/domain/entities/delivery_partner.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/home_controller.dart';
import 'package:get/get.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.user});
  final DeliveryPartner? user;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrl = user?.profileImage ?? '';
    final initials = controller.getInitials(user?.name);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary,
      ),
      child: ClipOval(
        child: imageUrl.isEmpty
            ? Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
