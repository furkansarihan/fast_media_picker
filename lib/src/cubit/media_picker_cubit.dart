import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';

import '../configs.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit(
    this.context,
    this.configs,
  ) : super(const MediaPickerState(status: MediaPickerStatus.loading)) {
    _init();
    WidgetsBinding.instance.addPostFrameCallback((_) => initSheet());
  }

  final BuildContext context;
  final FastMediaPickerConfigs configs;

  List<AssetPathEntity>? folders;
  final ValueNotifier<AssetPathEntity?> selectedFolder = ValueNotifier(null);
  final ValueNotifier<bool> folderSelecting = ValueNotifier(false);

  final ValueNotifier<List<AssetEntity>?> assets = ValueNotifier(null);
  final ValueNotifier<List<AssetEntity>?> selectedAssets = ValueNotifier(null);
  final ValueNotifier<List<AssetEntity>?> updatedAssets = ValueNotifier(null);

  final ScrollController scrollController = ScrollController();
  final SnappingSheetController snappingSheetController =
      SnappingSheetController();
  final ValueNotifier<double> currentSheetPosition = ValueNotifier(0);
  final List<DragUpdateDetails> lastDragUpdates = [];
  ScrollController? folderSelectingScrollController;
  final int pageSize = 36;

  Map<String, Uint8List> imageCache = {};

  @override
  Future<void> close() async {
    super.close();
    lastDragUpdates.clear();
    imageCache.clear();
    selectedFolder.dispose();
    folderSelecting.dispose();
    assets.dispose();
    selectedAssets.dispose();
    updatedAssets.dispose();
    folderSelectingScrollController?.dispose();
    scrollController.dispose();
    await removeCallback();
  }

  // TODO: manage cache size
  void addToCache(String key, Uint8List value) {
    imageCache[key] = value;
  }

  Uint8List? getFromCache(String key) {
    if (imageCache.containsKey(key)) return imageCache[key];
    return null;
  }

  void initSheet() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double deviceHeight = mediaQueryData.size.height;
    double topPadding = mediaQueryData.padding.top;
    double grabbingHeigth = 68;
    SnappingPosition middle = SnappingPosition.pixels(
      positionPixels: deviceHeight - 128 - topPadding - grabbingHeigth,
      grabbingContentOffset: GrabbingContentOffset.middle,
    );
    snappingSheetController.snapToPosition(middle);
  }

  bool popping = false;
  void popSheet() {
    popping = true;
    SnappingPosition bottom = const SnappingPosition.factor(
      positionFactor: -1,
      grabbingContentOffset: GrabbingContentOffset.bottom,
      snappingDuration: Duration(milliseconds: 1000),
    );
    snappingSheetController.snapToPosition(bottom);
  }

  void changeNotify(MethodCall call) async {
    Map<dynamic, dynamic> arguments = call.arguments as Map<dynamic, dynamic>;

    List<dynamic>? createList;
    List<dynamic>? updateList;
    List<dynamic>? deleteList;

    if (Platform.isIOS) {
      createList = arguments.containsKey('create')
          ? arguments['create'] as List<dynamic>
          : const [];
      updateList = arguments.containsKey('update')
          ? arguments['update'] as List<dynamic>
          : const [];
      deleteList = arguments.containsKey('delete')
          ? List<dynamic>.from(arguments['delete'], growable: true)
          : List<dynamic>.from(const [], growable: true);
    } else {
      final type =
          arguments.containsKey('type') ? arguments['type'] as String : null;
      if (type == 'insert') {
        createList = [arguments];
      } else if (type == 'delete') {
        deleteList = [arguments];
      }

      createList = createList ?? const [];
      updateList = updateList ?? const [];
      deleteList = deleteList ?? const [];
    }

    if (updateList.isNotEmpty && assets.value != null) {
      for (int i = 0; i < updateList.length; i++) {
        var element = updateList[i];
        Map<dynamic, dynamic> updatedElement = element as Map<dynamic, dynamic>;
        dynamic updatedId = updatedElement.containsKey('id')
            ? updatedElement['id'] as dynamic
            : const [];
        int index =
            assets.value!.indexWhere((element) => element.id == updatedId);
        if (index >= 0) {
          AssetEntity? updatedAsset = await AssetEntity.fromId(updatedId);
          if (updatedAsset != null) {
            // TODO: check if asset removed from current folder - better
            AssetPathEntity folder = selectedFolder.value!;
            int count = await folder.assetCountAsync;
            List<AssetEntity> al = await folder.getAssetListRange(
              start: 0,
              end: count,
            );
            bool found = false;
            for (var i = 0; i < al.length; i++) {
              AssetEntity ae = al[i];
              if (ae.id == updatedId) {
                found = true;
                break;
              }
            }
            if (found) {
              tooggleUpdatedAsset(updatedAsset);
              assets.value?.replaceRange(index, index + 1, [updatedAsset]);
            } else {
              deleteList.add(element);
            }
          }
        } else {
          AssetEntity? updatedAsset = await AssetEntity.fromId(updatedId);
          if (updatedAsset != null) {
            // TODO: check if asset added to current folder - better
            AssetPathEntity folder = selectedFolder.value!;
            int count = await folder.assetCountAsync;
            List<AssetEntity> al = await folder.getAssetListRange(
              start: 0,
              end: count + updateList.length,
            );
            for (var i = 0; i < al.length; i++) {
              AssetEntity ae = al[i];
              if (ae.id == updatedId) {
                tooggleUpdatedAsset(updatedAsset);
                // TODO: current folder's order?
                assets.value?.insert(0, updatedAsset);
                assets.value = List<AssetEntity>.from(assets.value!);
                break;
              }
            }
          }
        }
      }
    }

    if (deleteList.isNotEmpty) {
      for (var element in deleteList) {
        Map<dynamic, dynamic> deletedElement = element as Map<dynamic, dynamic>;
        dynamic deletedId = deletedElement.containsKey('id')
            ? deletedElement['id'] as dynamic
            : const [];
        selectedAssets.value?.removeWhere((element) => element.id == deletedId);
        selectedAssets.value = selectedAssets.value?.toList();
      }
    }

    if (createList.isNotEmpty || deleteList.isNotEmpty) {
      await refresh();
    }

    if (createList.isEmpty && updateList.isEmpty && deleteList.isEmpty) {
      int newCount =
          arguments.containsKey('newCount') ? arguments['newCount'] as int : 0;
      int oldCount =
          arguments.containsKey('oldCount') ? arguments['oldCount'] as int : 0;
      if (newCount != oldCount) {
        await refresh();
      }
    }
  }

  Future<void> refresh() async {
    String? selectedFolderId = selectedFolder.value?.id;
    selectedFolder.value = null;
    await _initAllFolders(selectedFolderId: selectedFolderId);
  }

  tooggleUpdatedAsset(AssetEntity asset) {
    if (updatedAssets.value == null) {
      updatedAssets.value = [asset];
    } else {
      updatedAssets.value = updatedAssets.value!.followedBy([asset]).toList();
    }
  }

  bool _callbackAdded = false;
  Future<void> addCallback() async {
    if (_callbackAdded) return;
    _callbackAdded = true;
    PhotoManager.addChangeCallback(changeNotify);
    await PhotoManager.startChangeNotify();
  }

  Future<void> removeCallback() async {
    if (!_callbackAdded) return;
    PhotoManager.removeChangeCallback(changeNotify);
    await PhotoManager.stopChangeNotify();
  }

  _init() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.storage.status;
    } else {
      // TODO: ios 13 and below?
      status = await Permission.photos.status;
    }

    _emitPermissionStatus(status);
    _initAllFolders();
  }

  _emitPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        emit(const MediaPickerState(status: MediaPickerStatus.fullPermission));
        break;
      case PermissionStatus.limited:
        emit(const MediaPickerState(
            status: MediaPickerStatus.limitedPermission));
        break;
      case PermissionStatus.denied:
        emit(
            const MediaPickerState(status: MediaPickerStatus.deniedPermission));
        break;
      default:
        emit(const MediaPickerState(
            status: MediaPickerStatus.permenantlyDeniedPermission));
    }
  }

  bool _foldersLoading = false;
  _initAllFolders({String? selectedFolderId}) async {
    if (_foldersLoading) return;
    if (state.status == MediaPickerStatus.loading) return;
    if (state.status == MediaPickerStatus.deniedPermission) return;
    if (state.status == MediaPickerStatus.permenantlyDeniedPermission) return;
    _foldersLoading = true;
    // TODO: limited always requests for more?
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      hasAll: true,
      onlyAll: state.status == MediaPickerStatus.limitedPermission,
      type: configs.type,
    );
    // TODO: only show folders with assets
    folders = List<AssetPathEntity>.from(paths);
    // TODO: handle no folder
    if (folders!.isEmpty) {
      assets.value = null;
      _foldersLoading = false;
      return;
    }
    if (selectedFolderId == null) {
      await selectFolder(folders!.first);
    } else {
      await selectFolder(folders!.firstWhere(
        (element) => element.id == selectedFolderId,
        orElse: () => folders!.first,
      ));
    }
    _foldersLoading = false;
    addCallback();
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

  Future<void> selectFolder(AssetPathEntity? folder) async {
    if (folder == null) return;
    if (selectedFolder.value == folder) return;
    assets.value = null;
    selectedFolder.value = folder;
    _endOfList = false;
    await fetchMoreAsset();
  }

  bool _isLoading = false;
  bool _endOfList = false;
  Future<void> fetchMoreAsset() async {
    if (_isLoading) return;
    if (_endOfList) return;
    if (selectedFolder.value == null) return;
    _isLoading = true;
    int start = assets.value?.length ?? 0;
    int end = start + pageSize;
    List<AssetEntity> al = await selectedFolder.value!.getAssetListRange(
      start: start,
      end: end,
    );
    _isLoading = false;
    if (al.isEmpty) {
      if (start == 0) {
        assets.value = const [];
      }
      return;
    } else if (al.length < pageSize) {
      _endOfList = true;
    }
    assets.value = (assets.value ?? const []).followedBy(al).toList();
  }

  tooggleSelectAsset(AssetEntity asset) {
    if (selectedAssets.value == null) {
      selectedAssets.value = [asset];
    } else {
      if (selectedAssets.value!.contains(asset)) {
        selectedAssets.value =
            selectedAssets.value!.where((a) => a != asset).toList();
        if (selectedAssets.value!.isEmpty) selectedAssets.value = null;
      } else {
        if (!canSelectAsset()) return;
        selectedAssets.value =
            selectedAssets.value!.followedBy([asset]).toList();
      }
    }
  }

  bool canSelectAsset() {
    if (selectedAssets.value == null) return true;
    return selectedAssets.value!.length < configs.pickLimit;
  }

  void done() => popSheet();

  bool _appSettingsOpened = false;
  void requestPermission() async {
    if (state.status == MediaPickerStatus.permenantlyDeniedPermission) {
      await openAppSettings();
      _appSettingsOpened = true;
      return;
    }
    PermissionStatus? status;
    if (Platform.isAndroid) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }

    _emitPermissionStatus(status);
    _initAllFolders();
  }

  void refreshPermission() {
    if (!_appSettingsOpened) return;
    _appSettingsOpened = false;
    _init();
  }

  Future<void> manageLimited() async {
    // TODO: push sheet
    // PhotoManager.openSetting();
    await PhotoManager.presentLimited();
  }
}
