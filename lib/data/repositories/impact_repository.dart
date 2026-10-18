import '../models/models.dart';

/// Community impact numbers (aggregated, no personal data).
abstract interface class ImpactRepository {
  Future<ImpactDashboard> dashboard(ImpactPeriod period);
}
