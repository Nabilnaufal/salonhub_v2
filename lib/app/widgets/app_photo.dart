import 'package:flutter/material.dart';

import '../constant/theme.dart';

/// Foto yang selalu berasal dari Supabase Storage (URL publik).
/// Kalau URL kosong/gagal dimuat, tampilkan placeholder abu-abu.
class AppPhoto extends StatelessWidget {
  const AppPhoto(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  bool get _isRemote => url != null && url!.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final child = _isRemote
        ? Image.network(
            url!,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, _, _) => _placeholder(),
          )
        : _placeholder();

    if (borderRadius == null) return child;
    return ClipRRect(borderRadius: borderRadius!, child: child);
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.blueGray100,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        color: AppColors.blueGray400,
        size: (height ?? 48) * .4,
      ),
    );
  }
}

/// Avatar bulat dari URL Supabase; kosong/gagal dimuat jadi ikon orang.
Widget avatarImage(String url, {required double radius}) {
  if (!url.startsWith('http')) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary50,
      child: Icon(
        Icons.person_outline,
        size: radius * .9,
        color: AppColors.primary900,
      ),
    );
  }

  return ClipOval(
    child: Image.network(
      url,
      width: radius * 2,
      height: radius * 2,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primary50,
        child: Icon(
          Icons.person_outline,
          size: radius * .9,
          color: AppColors.primary900,
        ),
      ),
    ),
  );
}
