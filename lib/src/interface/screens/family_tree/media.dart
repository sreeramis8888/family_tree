import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/family_api.dart/family_api.dart';
import 'package:familytree/src/data/models/family_model.dart';
import 'package:familytree/src/data/notifiers/user_notifier.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:familytree/src/data/services/image_upload.dart';
import 'package:familytree/src/data/utils/show_image_viewer.dart';
import 'package:familytree/src/interface/components/common/custom_video.dart';
import 'package:familytree/src/data/models/promotion_model.dart';

class PhotoGalleryPage extends ConsumerStatefulWidget {
  const PhotoGalleryPage({super.key});

  @override
  ConsumerState<PhotoGalleryPage> createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends ConsumerState<PhotoGalleryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Future<void> _addMediaDialog(
      String familyId, List<FamilyMedia> currentMedia) async {
    String mediaType = 'photo';
    File? selectedImage;
    String? uploadedImageUrl;
    bool isUploading = false;
    final urlController = TextEditingController();
    final captionController = TextEditingController();
    final ytUrlController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String? errorText;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickImage() async {
            final picker = ImagePicker();
            final picked = await picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setState(() {
                selectedImage = File(picked.path);
                uploadedImageUrl = null;
                errorText = null;
              });
            }
          }

          Future<void> uploadImage() async {
            if (selectedImage == null) return;
            setState(() {
              isUploading = true;
              errorText = null;
            });
            try {
              final url = await imageUpload(selectedImage!.path);
              setState(() {
                uploadedImageUrl = url;
              });
            } catch (e) {
              setState(() {
                errorText = 'Failed to upload image.';
              });
            } finally {
              setState(() {
                isUploading = false;
              });
            }
          }

          Widget photoTab() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child:
                                  Image.file(selectedImage!, fit: BoxFit.cover),
                            )
                          : Icon(Icons.add_a_photo,
                              size: 48, color: Colors.grey[500]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (selectedImage != null && uploadedImageUrl == null)
                    ElevatedButton.icon(
                      onPressed: isUploading ? null : uploadImage,
                      icon: isUploading
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Icon(Icons.cloud_upload),
                      label:
                          Text(isUploading ? 'Uploading...' : 'Upload Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  if (uploadedImageUrl != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Uploaded!',
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: captionController,
                    decoration: InputDecoration(
                      labelText: 'Caption',
                      prefixIcon: Icon(Icons.text_fields),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Caption required' : null,
                  ),
                ],
              );

          Widget videoTab() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: ytUrlController,
                    decoration: InputDecoration(
                      labelText: 'YouTube URL',
                      prefixIcon: Icon(Icons.ondemand_video),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'YouTube URL required';
                      final ytRegex = RegExp(
                          r'^(https?://)?(www\.)?(youtube\.com|youtu\.?be)/.+');
                      if (!ytRegex.hasMatch(v))
                        return 'Enter a valid YouTube URL';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: captionController,
                    decoration: InputDecoration(
                      labelText: 'Caption',
                      prefixIcon: Icon(Icons.text_fields),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Caption required' : null,
                  ),
                ],
              );

          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: Row(
              children: [
                Icon(Icons.perm_media, color: Colors.red),
                SizedBox(width: 8),
                Text('Add Media',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => mediaType = 'photo'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: mediaType == 'photo'
                                    ? Colors.red[50]
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.photo,
                                      color: mediaType == 'photo'
                                          ? Colors.red
                                          : Colors.grey),
                                  Text('Photo',
                                      style: TextStyle(
                                          color: mediaType == 'photo'
                                              ? Colors.red
                                              : Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => mediaType = 'video'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: mediaType == 'video'
                                    ? Colors.red[50]
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.ondemand_video,
                                      color: mediaType == 'video'
                                          ? Colors.red
                                          : Colors.grey),
                                  Text('Video',
                                      style: TextStyle(
                                          color: mediaType == 'video'
                                              ? Colors.red
                                              : Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (mediaType == 'photo') photoTab(),
                  if (mediaType == 'video') videoTab(),
                  if (errorText != null) ...[
                    SizedBox(height: 12),
                    Text(errorText!, style: TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  if (mediaType == 'photo') {
                    if (uploadedImageUrl == null) {
                      setState(() {
                        errorText = 'Please upload a photo.';
                      });
                      return;
                    }
                    final newMedia = FamilyMedia(
                      url: uploadedImageUrl,
                      caption: captionController.text,
                      urlType: 'photo',
                      uploadDate: DateTime.now(),
                    );
                    await FamilyApiService.updateFamilyMedia(
                      familyId: familyId,
                      media: [...currentMedia, newMedia],
                    );
                    Navigator.pop(context);
                    setState(() {});
                  } else {
                    final newMedia = FamilyMedia(
                      url: ytUrlController.text,
                      caption: captionController.text,
                      urlType: 'video',
                      uploadDate: DateTime.now(),
                    );
                    await FamilyApiService.updateFamilyMedia(
                      familyId: familyId,
                      media: [...currentMedia, newMedia],
                    );
                    Navigator.pop(context);
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final asyncUser = ref.watch(userProvider);

    return asyncUser.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (user) {
        final familyId = (user.familyId != null && user.familyId!.isNotEmpty)
            ? user.familyId!.first
            : null;
        if (familyId == null) {
          return const Center(child: Text('No family found.'));
        }
        final asyncFamily =
            ref.watch(fetchSingleFamilyProvider(familyId: familyId));
        return asyncFamily.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (family) {
            final List<FamilyMedia> photos =
                family.media?.where((m) => m.urlType == 'photo').toList() ?? [];
            final List<FamilyMedia> videos =
                family.media?.where((m) => m.urlType == 'video').toList() ?? [];
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                forceMaterialTransparency: true,
                centerTitle: true,
                title: Text(
                  "Media",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xff272727),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 6),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 12,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                elevation: 1,
                bottom: TabBar(
                  controller: _tabController,
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.black54,
                  indicator: UnderlineTabIndicator(
                    borderSide: const BorderSide(
                      width: 4,
                      color: Colors.red,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: screenWidth / 3),
                  ),
                  tabs: const [
                    Tab(text: "Photos"),
                    Tab(text: "Videos"),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  // Photos Grid
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: GridView.builder(
                      itemCount: photos.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            if (photos[index].url != null) {
                              showImageViewer(photos[index].url!, context);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: photos[index].url != null
                                ? Image.network(photos[index].url!,
                                    fit: BoxFit.cover)
                                : const SizedBox.shrink(),
                          ),
                        );
                      },
                    ),
                  ),
                  // Video list
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      final promotion = Promotion(
                        link: video.url,
                        title: video.caption,
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customVideo(context: context, video: promotion),
                          const SizedBox(height: 8),
                          Text(
                            video.caption ?? '',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ],
              ),
              floatingActionButton: RawMaterialButton(
                onPressed: () async {
                  await _addMediaDialog(familyId, family.media ?? []);
                  ref.invalidate(fetchSingleFamilyProvider(familyId: familyId));
                },
                fillColor: const Color(0xffE30613),
                shape: const CircleBorder(),
                elevation: 6,
                constraints:
                    const BoxConstraints.tightFor(width: 62, height: 62),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }
}
