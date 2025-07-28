import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/epg_controller.dart';
import '../controllers/playlist_controller.dart';
import '../models/epg_program.dart';
import '../models/channel.dart';

class EPGScreen extends StatefulWidget {
  @override
  _EPGScreenState createState() => _EPGScreenState();
}

class _EPGScreenState extends State<EPGScreen> {
  final EpgController epgController = Get.find<EpgController>();
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final ScrollController _scrollController = ScrollController();
  
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Electronic Program Guide'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => epgController.refreshEpgData(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date selector
          Container(
            height: 60,
            color: Colors.grey[800],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7, // Show 7 days
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = DateFormat('yyyy-MM-dd').format(date) == 
                                 DateFormat('yyyy-MM-dd').format(selectedDate);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                    epgController.loadEpgForDate(date);
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('MMM d').format(date),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // EPG Grid
          Expanded(
            child: Obx(() {
              if (epgController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              final channels = playlistController.channels;
              if (channels.isEmpty) {
                return Center(
                  child: Text(
                    'No channels available',
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }
              
              return ListView.builder(
                controller: _scrollController,
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  final programs = epgController.getProgramsForChannel(
                    channel.id, 
                    selectedDate,
                  );
                  
                  return _buildChannelRow(channel, programs);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelRow(Channel channel, List<EpgProgram> programs) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Channel info
          Container(
            width: 150,
            padding: EdgeInsets.all(8),
            color: Colors.grey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (channel.logoUrl?.isNotEmpty == true)
                  Image.network(
                    channel.logoUrl!,
                    height: 30,
                    width: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.tv,
                        color: Colors.white54,
                        size: 24,
                      );
                    },
                  )
                else
                  Icon(
                    Icons.tv,
                    color: Colors.white54,
                    size: 24,
                  ),
                SizedBox(height: 4),
                Text(
                  channel.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Programs timeline
          Expanded(
            child: Container(
              child: programs.isEmpty
                  ? Center(
                      child: Text(
                        'No program data available',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: programs.length,
                      itemBuilder: (context, index) {
                        final program = programs[index];
                        return _buildProgramCard(program);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramCard(EpgProgram program) {
    final now = DateTime.now();
    final isLive = now.isAfter(program.startTime) && now.isBefore(program.endTime);
    final isPast = now.isAfter(program.endTime);
    
    Color cardColor;
    if (isLive) {
      cardColor = Colors.green[700]!;
    } else if (isPast) {
      cardColor = Colors.grey[700]!;
    } else {
      cardColor = Colors.blue[700]!;
    }
    
    return Container(
      width: 200,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormat('HH:mm').format(program.startTime)} - ${DateFormat('HH:mm').format(program.endTime)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Expanded(
              child: Text(
                program.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (program.description?.isNotEmpty == true)
              Text(
                program.description!,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
