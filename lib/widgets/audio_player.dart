// filepath: lib/widgets/audio_player_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final File audioFile;

  const AudioPlayerWidget({
    super.key,
    required this.audioFile,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
  // bool get _isStopped => _playerState == PlayerState.stopped; // Use if needed
  // bool get _isCompleted => _playerState == PlayerState.completed; // Use if needed

  @override
  void initState() {
    super.initState();
    // Listen to state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _playerState = state);
      }
    });

    // Listen to audio duration changes
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });

    // Listen to audio position changes
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });

     // Set the source when the widget initializes
    _setSource();
  }

 Future<void> _setSource() async {
    try {
       await _audioPlayer.setSourceDeviceFile(widget.audioFile.path);
       // Optionally preload duration here if needed before playing
       // _duration = await _audioPlayer.getDuration();
       // if (mounted) setState(() {});
    } catch (e) {
       print("Error setting audio source: $e");
       // Handle error, maybe show a message
    }
 }

  Future<void> _play() async {
    try {
      // Ensure source is set before playing, especially if stopped/completed
      if (_playerState != PlayerState.playing && _playerState != PlayerState.paused) {
         await _setSource(); // Re-set source if needed
      }
      await _audioPlayer.resume(); // Use resume, it plays if not playing, resumes if paused
    } catch (e) {
      print("Error playing audio: $e");
      // Handle error
    }
  }

  Future<void> _pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print("Error pausing audio: $e");
      // Handle error
    }
  }

  Future<void> _seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print("Error seeking audio: $e");
      // Handle error
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Release resources
    super.dispose();
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '--:--';
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final color =  Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Take minimum space needed
        children: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            color: color,
            onPressed: _isPlaying ? _pause : _play,
            splashRadius: 20,
          ),
          Expanded(
            child: SliderTheme(
               data: SliderTheme.of(context).copyWith(
                 thumbColor: color,
                 activeTrackColor: color.withOpacity(0.7),
                 inactiveTrackColor: color.withOpacity(0.3),
                 overlayColor: color.withOpacity(0.2),
                 trackHeight: 2.0,
                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                 overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
               ),
              child: Slider(
                value: (_position != null && _duration != null && _position!.inMilliseconds > 0 && _position!.inMilliseconds < _duration!.inMilliseconds)
                    ? _position!.inMilliseconds.toDouble()
                    : 0.0,
                min: 0.0,
                max: (_duration != null && _duration!.inMilliseconds > 0)
                    ? _duration!.inMilliseconds.toDouble()
                    : 1.0, // Avoid division by zero or max < min
                onChanged: (value) {
                  final position = Duration(milliseconds: value.toInt());
                  _seek(position);
                },
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }
}