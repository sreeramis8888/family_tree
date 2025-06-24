import 'dart:developer';

import 'package:familytree/src/data/globals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';

import 'package:familytree/src/data/models/user_model.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final Ref ref;

  UserNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    if (mounted) {
      await _fetchUserDetails();
    }
  }

  Future<void> refreshUser() async {
    if (mounted) {
      state = const AsyncValue.loading();
      await _fetchUserDetails();
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      log('Fetching user details');
      final user = await ref.read(fetchUserDetailsProvider(id).future);
      state = AsyncValue.data(user ?? UserModel());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      log('Error fetching user details: $e');
      log(stackTrace.toString());
    }
  }

  void updateName(String? name) {
    state = state.whenData((user) => user.copyWith(fullName: name));
  }

  void updateSecondaryPhone(String? secondaryPhone) {
    state = state.whenData((user) => user.copyWith(secondaryPhone: secondaryPhone));
  }

  void updateEmail(String? email) {
    state = state.whenData((user) => user.copyWith(email: email));
  }

  void updateBio(String? bio) {
    state = state.whenData((user) => user.copyWith(biography: bio));
  }

  void updateAddress(String? address) {
    state = state.whenData((user) => user.copyWith(address: address));
  }

  void updatePhone(String? phone) {
    state = state.whenData((user) => user.copyWith(phone: phone));
  }
  void updateOccupation(String? occupation) {
    state = state.whenData((user) => user.copyWith(occupation: occupation));
  }

  // void updateBusinessTags(List<String> businessTags) {
  //   state = state.whenData((user) => user.copyWith(businessTags: businessTags));
  // }

  void updateProfilePicture(String profilePicture) {
    state = state.whenData((user) {
   
      return user.copyWith(image: profilePicture);
    });
  }

  void updateAwards(List<Media> awards) {
    state = state.whenData((user) {
      final others = user.media?.where((m) => m.metadata != "award").toList() ?? [];
      return user.copyWith(media: [...others, ...awards]);
    });
  }

  void removeAward(Media awardToRemove) {
    state = state.whenData((user) {
      final updated = user.media?.where((m) => m != awardToRemove).toList() ?? [];
      return user.copyWith(media: updated);
    });
  }

  void editAward(Media oldAward, Media updatedAward) {
    state = state.whenData((user) {
      final updated = user.media?.map((m) => m == oldAward ? updatedAward : m).toList() ?? [];
      return user.copyWith(media: updated);
    });
  }

  void updateCertificates(List<Media> certificates) {
    state = state.whenData((user) {
      final others = user.media?.where((m) => m.metadata != "certificate").toList() ?? [];
      return user.copyWith(media: [...others, ...certificates]);
    });
  }

  void removeCertificate(Media certToRemove) {
    state = state.whenData((user) {
      final updated = user.media?.where((m) => m != certToRemove).toList() ?? [];
      return user.copyWith(media: updated);
    });
  }

  void editCertificate(Media oldCert, Media newCert) {
    state = state.whenData((user) {
      final updated = user.media?.map((m) => m == oldCert ? newCert : m).toList() ?? [];
      return user.copyWith(media: updated);
    });
  }

  void updateVideos(List<Media> videos) {
    state = state.whenData((user) {
      final others = user.media?.where((m) => m.metadata != "video").toList() ?? [];
      return user.copyWith(media: [...others, ...videos]);
    });
  }

  void removeVideo(Media videoToRemove) {
    state = state.whenData((user) {
      final updated = user.media?.where((m) => m != videoToRemove).toList() ?? [];
      return user.copyWith(media: updated);
    });
  }

  void editVideo(Media oldVideo, Media newVideo) {
    state = state.whenData((user) {
      final updated = user.media?.map((m) => m == oldVideo ? newVideo : m).toList() ?? [];
      return user.copyWith(media: updated);
    });
  }

  void updateSocialMedia(List<Link> socialmedias, String platform, String newUrl) {
    if (platform.isNotEmpty) {
      final index = socialmedias.indexWhere((item) => item.name == platform);
      if (index != -1) {
        if (newUrl.isNotEmpty) {
          socialmedias[index] = socialmedias[index].copyWith(link: newUrl);
        } else {
          socialmedias.removeAt(index);
        }
      } else if (newUrl.isNotEmpty) {
        socialmedias.add(Link(name: platform, link: newUrl));
      }
      state = state.whenData((user) => user.copyWith(social: socialmedias));
    } else {
      state = state.whenData((user) => user.copyWith(social: []));
    }
  }

  void updateWebsite(List<Link> websites) {
    state = state.whenData((user) => user.copyWith(website: websites));
  }

  void removeWebsite(Link websiteToRemove) {
    state = state.whenData((user) {
      final updated = user.website?.where((w) => w != websiteToRemove).toList();
      return user.copyWith(website: updated);
    });
  }

  void editWebsite(Link oldWebsite, Link newWebsite) {
    state = state.whenData((user) {
      final updated = user.website?.map((w) => w == oldWebsite ? newWebsite : w).toList();
      return user.copyWith(website: updated);
    });
  }

  void updateBirthDate(DateTime? birthDate) {
    state = state.whenData((user) => user.copyWith(birthDate: birthDate));
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel>>((ref) {
  return UserNotifier(ref);
});
