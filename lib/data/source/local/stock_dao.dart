import 'package:hive/hive.dart';
import 'package:stock_app/data/source/local/company_listing_entity.dart';

class StockDao {
  static const companyListing = 'companyListing';
  static const stockDb = 'stock.db';

  // final box = Hive.box(stockDb);

  // 추가
  Future<void> insertCompanyListings(
      List<CompanyListingEntity> companyListingEntities) async {
    final box = await Hive.openBox<CompanyListingEntity>(stockDb);
    await box.addAll(companyListingEntities);
  }

  // 캐시 클리어
  Future clearCompanyListings() async {
    final box = await Hive.openBox<CompanyListingEntity>(stockDb);
    await box.clear();
  }

  //검색
  Future<List<CompanyListingEntity>> searchCompanyListing(String query) async {
    final box = await Hive.openBox<CompanyListingEntity>(stockDb);
    final List<CompanyListingEntity> companyListing = box.values.toList();
    // box.get(StockDao.companyListing, defaultValue: []);

    return companyListing
        .where((e) =>
            e.name.toLowerCase().contains(query.toLowerCase()) ||
            query.toUpperCase() == e.symbol)
        .toList();
  }
}
