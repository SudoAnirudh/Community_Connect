import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notice_model.dart';
import '../repositories/notice_repository.dart';

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  return NoticeRepository();
});

final noticesStreamProvider = StreamProvider<List<NoticeModel>>((ref) {
  final repository = ref.watch(noticeRepositoryProvider);
  return repository.getNoticesStream();
});
