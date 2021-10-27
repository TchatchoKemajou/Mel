import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/pages/article_detail.dart';
import 'package:flutter_app/services/produit_service.dart';

class DynamicLinkService {
  final articleservice = ProduitService();

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      Uri deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          final id = deepLink.queryParameters['id'];

          Produit produit = await articleservice.getCurrentArticle(id);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ArticleDetail(article: produit,)
          ));
        }
      }
    } catch (e) {
      print('---------------------+++++++++++++casdsd' + e.toString());
    }
  }

  Future<Uri> createDynamicLink(
      String id, String title, String description, Uri image) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://meloccasion.page.link',
      link: Uri.parse('https://meloccasion.page.link.com/?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.flutter_app',
        minimumVersion: 1,
      ),
      // iosParameters: IosParameters(
      //   bundleId: 'your_ios_bundle_identifier',
      //   minimumVersion: '1',
      //   appStoreId: 'your_app_store_id',
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: description,
        imageUrl: image,
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    print('---------------shotlink----------++++++++' +
        shortDynamicLink.toString());
    Uri shotlink = shortDynamicLink.shortUrl;

    var dynamicUrl = await parameters.buildUrl();

    return shotlink;
  }
}
