import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/epg_program.dart';
import '../services/database_service.dart';

class EpgController extends GetxController {
  final _programs = <EpgProgram>[].obs;
  final _isLoading = false.obs;

  final Dio _dio = Dio();

  // Getters
  List<EpgProgram> get programs => _programs;
  bool get isLoading => _isLoading.value;

  Future<void> loadEpg(String channelId, DateTime date) async {
    _isLoading.value = true;

    try {
      final epgData = await DatabaseService.instance.getEpgForChannel(channelId, date);
      _programs.value = epgData;

      if (epgData.isEmpty) {
        await _fetchAndStoreEpgData(channelId, date);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load EPG: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _fetchAndStoreEpgData(String channelId, DateTime date) async {
    try {
      // Fetch EPG from external source (API or XMLTV)
      final response = await _dio.get('https://example.com/epg',
          queryParameters: {'channel_id': channelId, 'date': date.toIso8601String()});

      final List<dynamic> epgJson = response.data;

      // Parse and insert into database
      final programs = epgJson.map((json) => EpgProgram.fromJson(json)).toList();
      await DatabaseService.instance.insertEpgPrograms(programs);

      // Update local state
      _programs.addAll(programs);
    } catch (e) {
      throw Exception('Failed to fetch EPG data: $e');
    }
  }

  void clearPrograms() {
    _programs.clear();
    update();
  }

  Future<void> refreshEpgData() async {
    // Refresh EPG data for all channels
    _isLoading.value = true;
    try {
      // Clear existing programs
      _programs.clear();
      // This would typically reload from database or API
      // For now, just update the loading state
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to refresh EPG: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadEpgForDate(DateTime date) async {
    _isLoading.value = true;
    try {
      // Load EPG data for all channels for the given date
      final epgData = await DatabaseService.instance.getEpgForDate(date);
      _programs.value = epgData;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load EPG for date: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  List<EpgProgram> getProgramsForChannel(String channelId) {
    return _programs.where((program) => program.channelId == channelId).toList();
  }
}
