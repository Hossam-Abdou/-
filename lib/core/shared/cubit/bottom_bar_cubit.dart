import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BottomBarState {}

class BottomBarInitial extends BottomBarState {}

class BottomBarIndexChanged extends BottomBarState {}

/// Holds the current tab index only — which tab is showing is
/// genuine persistent UI state. The tab widgets themselves are NOT
/// stored here (see the comment in [BottomBarScreen] for why): they
/// come from the widget's own `layouts` field so they always reflect
/// the latest build (e.g. after a language change).
class BottomBarCubit extends Cubit<BottomBarState> {
  BottomBarCubit() : super(BottomBarInitial());

  static BottomBarCubit get(BuildContext context) => BlocProvider.of<BottomBarCubit>(context);

  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(BottomBarIndexChanged());
  }
}
