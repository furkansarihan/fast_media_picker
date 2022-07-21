part of 'media_picker_cubit.dart';

class MediaPickerState extends Equatable {
  const MediaPickerState({
    this.status = MediaPickerStatus.loading,
  });

  final MediaPickerStatus status;

  @override
  List<Object> get props => [status];

  MediaPickerState copyWith({
    MediaPickerStatus? status,
  }) {
    return MediaPickerState(
      status: status ?? this.status,
    );
  }
}

enum MediaPickerStatus {
  loading,
  noPermission,
  limitedPermission,
  fullPermission,
}
