import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final networkImageCacheManager = CacheManager(Config(
  'networkImagesCacheKey',
  stalePeriod: const Duration(days: 30),
  maxNrOfCacheObjects: 1000,
));
