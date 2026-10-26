import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'api_client.dart';

/// Uploads local photos to a public Supabase Storage bucket and returns
/// their public URLs. The first path segment must be the signed-in user's id
/// (that is what the bucket policies check), e.g. `{userId}/{folder}/0.jpg`.
class StorageService {
  static const propertyImages = 'property-images';
  static const offerImages = 'offer-images';
  static const avatars = 'avatars';

  /// Anything already starting with http(s) is kept as is (edit mode).
  Future<List<String>> uploadAll(String bucket, String folder, List<String> paths) async {
    final user = supabaseInstance.auth.currentUser;
    if (user == null) throw const ApiException(401, 'Not signed in');
    final out = <String>[];
    final stamp = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < paths.length; i++) {
      final p = paths[i];
      if (p.startsWith('http://') || p.startsWith('https://')) {
        out.add(p);
        continue;
      }
      final dot = p.lastIndexOf('.');
      final ext = dot == -1 ? 'jpg' : p.substring(dot + 1).toLowerCase();
      final objectPath = '${user.id}/$folder/$stamp-$i.$ext';
      try {
        await supabaseInstance.storage.from(bucket).upload(
              objectPath,
              File(p),
              fileOptions: FileOptions(contentType: ext == 'png' ? 'image/png' : 'image/jpeg', upsert: false),
            );
      } on StorageException catch (e) {
        throw ApiException(int.tryParse(e.statusCode ?? ''), e.message);
      }
      out.add(supabaseInstance.storage.from(bucket).getPublicUrl(objectPath));
    }
    return out;
  }
}
