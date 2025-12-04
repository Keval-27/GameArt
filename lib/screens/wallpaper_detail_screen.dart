import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallpaper_model.dart';
import '../services/favorites_provider.dart';
import '../services/wallpaper_service.dart';
import '../services/wallpaper_helper.dart';

class WallpaperDetailScreen extends StatefulWidget {
  final WallpaperModel wallpaper;
  const WallpaperDetailScreen({super.key, required this.wallpaper, required String heroTagPrefix});

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  bool _busy = false;
  final _service = WallpaperService();

  Future<void> _download() async {
    setState(() => _busy = true);
    try {
      final savedPath = await _service.downloadToGallery(
        widget.wallpaper.imageUrl,
        filename: '${widget.wallpaper.title}.jpg',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Downloaded successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Download failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _apply(int location) async {
    setState(() => _busy = true);
    try {
      await WallpaperHelper.setWallpaper(widget.wallpaper.imageUrl, location);
      if (mounted) {
        String locationText = location == WallpaperHelper.home
            ? 'Home Screen'
            : location == WallpaperHelper.lock
            ? 'Lock Screen'
            : 'Both Screens';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Set as $locationText wallpaper!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>();
    final isFav = favs.isFav(widget.wallpaper.id);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.wallpaper.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.white,
                size: 28,
              ),
              onPressed: () => favs.toggle(widget.wallpaper.id),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔥 FULL SCREEN BIG IMAGE
          Expanded(
            child: Hero(
              tag: 'wp_${widget.wallpaper.id}',
              child: SizedBox(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: widget.wallpaper.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.white, size: 50),
                          SizedBox(height: 8),
                          Text('Failed to load image', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.wallpaper.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (widget.wallpaper.tags.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.wallpaper.tags
                              .take(5) // Show max 5 tags
                              .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                              .toList(),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🔥 BIG DOWNLOAD BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _busy ? null : _download,
                    icon: _busy
                        ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : const Icon(Icons.download, size: 26),
                    label: Text(
                      _busy ? 'Downloading...' : 'Download to Gallery',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: Colors.blue.withOpacity(0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Set as Wallpaper',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 16),
                // 🔥 SET WALLPAPER BUTTONS - ALL VISIBLE
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(

                        height: 46,
                        child: ElevatedButton.icon(
                          onPressed: _busy ? null : () => _apply(WallpaperHelper.home),
                          icon: const Icon(Icons.home, size: 20),
                          label: const Text('Home', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: Colors.green.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton.icon(
                          onPressed: _busy ? null : () => _apply(WallpaperHelper.lock),
                          icon: const Icon(Icons.lock, size: 22),
                          label: const Text('Lock', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[600],
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: Colors.orange.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton.icon(
                          onPressed: _busy ? null : () => _apply(WallpaperHelper.both),
                          icon: const Icon(Icons.phone_android, size: 22),
                          label: const Text('Both', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[600],
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: Colors.purple.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
