import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit(
    this.context,
    this.scrollController,
    this.backgroundColor,
    this.foregrounColor,
    this.maxSelection,
    this.emptyWidget,
    this.loadingWidget,
    this.onPicked,
  ) : super(const MediaPickerState(status: MediaPickerStatus.loading)) {
    init();
  }

  final BuildContext context;

  final ScrollController scrollController;
  final Color backgroundColor;
  final Color foregrounColor;
  final int maxSelection;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Function(List<File?>) onPicked;

  List<AssetPathEntity>? folders;
  ValueNotifier<AssetPathEntity?> selectedFolder = ValueNotifier(null);
  ValueNotifier<bool> folderSelecting = ValueNotifier(false);

  ValueNotifier<List<AssetEntity>?> assets = ValueNotifier(null);
  ValueNotifier<List<AssetEntity>?> selectedAssets = ValueNotifier(null);

  ScrollController? folderSelectingScrollController;

  void changeNotify(MethodCall call) {
    // TODO: refresh folders
    // find selected by name
    // select selected
  }

  @override
  Future<void> close() async {
    super.close();
    // TODO:
    // PhotoManager.removeChangeCallback(changeNotify);
    // PhotoManager.stopChangeNotify();
  }

  init() async {
    // TODO:
    // PhotoManager.addChangeCallback(changeNotify);
    // PhotoManager.startChangeNotify();
    PermissionState ps;
    try {
      ps = await PhotoManager.requestPermissionExtend();
    } catch (_) {
      ps = PermissionState.denied;
    }
    switch (ps) {
      case PermissionState.authorized:
        emit(const MediaPickerState(status: MediaPickerStatus.fullPermission));
        break;
      case PermissionState.limited:
        emit(const MediaPickerState(
            status: MediaPickerStatus.limitedPermission));
        break;
      default:
        emit(const MediaPickerState(status: MediaPickerStatus.noPermission));
    }
    // TODO: collect all assets if limited permission
    _initAllFolders();
  }

  _initAllFolders() async {
    if (state.status == MediaPickerStatus.loading) return;
    if (state.status == MediaPickerStatus.noPermission) return;
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      hasAll: true,
      type: RequestType.common,
    );
    // TODO: only show folders with assets
    folders = List<AssetPathEntity>.from(paths);
    selectFolder(folders!.first);
  }

  toggleSelectFolderState(AssetPathEntity? prevSelectedFolder) {
    folderSelecting.value = !folderSelecting.value;
    if (folderSelecting.value) {
      folderSelectingScrollController = ScrollController(
        initialScrollOffset: scrollController.offset,
      );
    } else if (prevSelectedFolder?.id != selectedFolder.value?.id) {
      folderSelectingScrollController?.jumpTo(0);
      scrollController.jumpTo(0);
    }
  }

  selectFolder(AssetPathEntity? folder) async {
    if (folder == null) return;
    if (selectedFolder.value == folder) return;
    assets.value = null;
    selectedFolder.value = folder;
    await fetchMoreAsset();
  }

  bool _isLoading = false;
  fetchMoreAsset() async {
    if (_isLoading) return;
    if (selectedFolder.value == null) return;
    _isLoading = true;
    int start = assets.value?.length ?? 0;
    int end = start + 64;
    List<AssetEntity> al = await selectedFolder.value!.getAssetListRange(
      start: start,
      end: end,
    );
    _isLoading = false;
    if (al.isEmpty) return;
    assets.value = (assets.value ?? const []).followedBy(al).toList();
  }

  tooggleSelectAsset(AssetEntity asset) {
    if (selectedAssets.value == null) {
      selectedAssets.value = [asset];
    } else {
      if (selectedAssets.value!.contains(asset)) {
        selectedAssets.value =
            selectedAssets.value!.where((a) => a != asset).toList();
      } else {
        if (!canSelectAsset()) return;
        selectedAssets.value =
            selectedAssets.value!.followedBy([asset]).toList();
      }
    }
  }

  bool canSelectAsset() {
    if (selectedAssets.value == null) return true;
    return selectedAssets.value!.length < maxSelection;
  }

  bool _doneLoading = false;
  done() async {
    // TODO: better way to do this - no async?
    if (_doneLoading) return;
    if (selectedAssets.value?.isEmpty ?? true) onPicked(const []);
    _doneLoading = true;
    List<File?> selectedFiles = await Future.wait(
      selectedAssets.value!.map((a) async {
        return await a.file;
      }),
    );
    _doneLoading = false;
    return onPicked(selectedFiles);
  }

  void openSetting() {
    PhotoManager.openSetting();
  }

  void manageLimited() {
    // TODO: push sheet
    // PhotoManager.openSetting();
    // PhotoManager.presentLimited();
  }
}
