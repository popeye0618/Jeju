import 'package:flutter/material.dart';
import 'package:jeju_together/shared/theme/app_theme.dart';

/// 로딩 상태 공통 위젯
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({
    super.key,
    this.color,
    this.size = 40.0,
    this.semanticLabel = '불러오는 중',
  });

  final Color? color;
  final double size;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: semanticLabel,
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: color ?? AppColors.primary,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}
