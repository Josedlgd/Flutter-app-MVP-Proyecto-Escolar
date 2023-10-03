import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    return Container(
      decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: AppColor.primarySoft, width: 2))),
      child: BottomNavigationBar(
        onTap: (int index) => uiProvider.selectedMenuOpt = index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: uiProvider.selectedMenuOpt,
        items: [
          (uiProvider.selectedMenuOpt == 0)
              ? BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/Home-active.svg'),
                  label: '')
              : BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/Home.svg'), label: ''),
          (uiProvider.selectedMenuOpt == 1)
              ? BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/Category-active.svg'),
                  label: '')
              : BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/Category.svg'),
                  label: ''),
          (uiProvider.selectedMenuOpt == 2)
              ? BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/Profile-active.svg'),
                  label: '')
              : BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/Profile.svg'),
                  label: ''),
        ],
      ),
    );
  }
}
