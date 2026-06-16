import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../viewmodels/admin/admin_dashboard_viewmodel.dart';
import '../../models/user.dart';


class AdminDashboardScreen extends StatefulWidget {
  final User currentUser;
  const AdminDashboardScreen({super.key, required this.currentUser});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _viewModel = AdminDashboardViewModel();

  final List<_ChartBar> _monthlyRevenue = const [
    _ChartBar('Jan', 850000),
    _ChartBar('Feb', 1200000),
    _ChartBar('Mar', 980000),
    _ChartBar('Apr', 1450000),
    _ChartBar('Mei', 1750000),
    _ChartBar('Jun', 1100000),
  ];

  @override
  void initState() {
    super.initState();
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => _viewModel.loading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFB8973A)))
              : RefreshIndicator(
                  color: const Color(0xFFB8973A),
                  backgroundColor: const Color(0xFF1A1A1A),
                  onRefresh: _viewModel.load,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w,
                        24.h + MediaQuery.of(context).padding.bottom),
                    children: [
                      // ── Header ──────────────────────────────────────────────
                      Row(children: [
                        Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, ${widget.currentUser.nama.split(' ').first} 👋',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Ringkasan platform hari ini',
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.4),
                                      fontSize: 13.sp),
                                ),
                              ]),
                        ),
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFB8973A).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color: const Color(0xFFB8973A)
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Icon(Icons.admin_panel_settings,
                              color: Color(0xFFB8973A), size: 22.sp),
                        ),
                      ]),
                      SizedBox(height: 24.h),

                      // ── Stat Cards ─────────────────────────────────────────
                      const _SectionLabel('Ringkasan Platform'),
                      SizedBox(height: 12.h),
                      _StatCardGrid(
                        cards: [
                          _StatCardData(
                            label: 'Total Pengguna',
                            value: '${_viewModel.stats['totalUsers'] ?? 0}',
                            icon: Icons.people_outline,
                            color: Colors.blue,
                            sub:
                                '${_viewModel.stats['totalSellers'] ?? 0} seller · ${_viewModel.stats['totalBuyers'] ?? 0} buyer',
                          ),
                          _StatCardData(
                            label: 'Total Buku',
                            value: '${_viewModel.stats['totalBooks'] ?? 0}',
                            icon: Icons.menu_book_outlined,
                            color: const Color(0xFFB8973A),
                            sub:
                                '${_viewModel.stats['approvedBooks'] ?? 0} aktif · ${_viewModel.stats['pendingBooks'] ?? 0} pending',
                          ),
                          _StatCardData(
                            label: 'Total Pesanan',
                            value: '${_viewModel.stats['totalOrders'] ?? 0}',
                            icon: Icons.receipt_long_outlined,
                            color: Colors.green,
                            sub: 'Semua status',
                          ),
                          _StatCardData(
                            label: 'Pendapatan',
                            value: _fmtRp(_viewModel.stats['revenue'] ?? 0),
                            icon: Icons.account_balance_wallet_outlined,
                            color: Colors.purple,
                            sub: 'Pesanan selesai',
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // ── Pending alert ──────────────────────────────────────
                      if ((_viewModel.stats['pendingBooks'] ?? 0) > 0)
                        _PendingAlert(
                            count: _viewModel.stats['pendingBooks'] ?? 0),
                      if ((_viewModel.stats['pendingBooks'] ?? 0) > 0)
                        SizedBox(height: 20.h),

                      // ── Grafik Bar ─────────────────────────────────────────
                      const _SectionLabel('Pendapatan 6 Bulan Terakhir'),
                      SizedBox(height: 12.h),
                      _BarChart(bars: _monthlyRevenue),
                      SizedBox(height: 24.h),

                      // ── User breakdown ─────────────────────────────────────
                      const _SectionLabel('Distribusi Pengguna'),
                      SizedBox(height: 12.h),
                      _UserDistribution(
                        totalSeller: _viewModel.stats['totalSellers'] ?? 0,
                        totalBuyer: _viewModel.stats['totalBuyers'] ?? 0,
                      ),
                      SizedBox(height: 24.h),

                      // ── Book status breakdown ──────────────────────────────
                      const _SectionLabel('Status Buku'),
                      SizedBox(height: 12.h),
                      _BookStatusBar(
                        approved: _viewModel.stats['approvedBooks'] ?? 0,
                        pending: _viewModel.stats['pendingBooks'] ?? 0,
                        total: _viewModel.stats['totalBooks'] ?? 0,
                      ),
                      SizedBox(height: 24.h),

                      // ── Recent Orders ──────────────────────────────────────
                      const _SectionLabel('Pesanan Terbaru'),
                      SizedBox(height: 12.h),
                      if (_viewModel.recentOrders.isEmpty)
                        _EmptyBox(label: 'Belum ada pesanan')
                      else
                        ..._viewModel.recentOrders.map((o) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _RecentOrderTile(order: o),
                            )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  String _fmtRp(int v) {
    if (v >= 1000000) return 'Rp ${(v / 1000000).toStringAsFixed(1)}Jt';
    if (v >= 1000) return 'Rp ${(v / 1000).toStringAsFixed(0)}K';
    return 'Rp $v';
  }
}

// ─── Widgets ────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
      );
}

// Data class untuk StatCard (tidak perlu widget sendiri)
class _StatCardData {
  final String label, value, sub;
  final IconData icon;
  final Color color;
  const _StatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.sub,
  });
}

/// Grid 2-kolom yang tingginya mengikuti konten (tidak fixed aspect ratio)
/// sehingga tidak pernah overflow.
class _StatCardGrid extends StatelessWidget {
  final List<_StatCardData> cards;
  const _StatCardGrid({required this.cards});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final crossAxisCount = isTablet ? 4 : 2;
    final spacing = 12.w;

    // Bagi cards menjadi baris-baris
    final rows = <List<_StatCardData>>[];
    for (int i = 0; i < cards.length; i += crossAxisCount) {
      rows.add(cards.sublist(i, (i + crossAxisCount).clamp(0, cards.length)));
    }

    return Column(
      children: rows.asMap().entries.map((entry) {
        final rowIndex = entry.key;
        final row = entry.value;
        return Padding(
          padding: EdgeInsets.only(top: rowIndex == 0 ? 0 : spacing),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: row.asMap().entries.map((e) {
                final colIndex = e.key;
                final card = e.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: colIndex == 0 ? 0 : spacing),
                    child: _StatCard(
                      label: card.label,
                      value: card.value,
                      icon: card.icon,
                      color: card.color,
                      sub: card.sub,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, sub;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color,
      required this.sub});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    // Font scale: lebih kecil di layar sempit
    final valueFontSize = screenW < 360 ? 14.sp : 17.sp;
    final labelFontSize = screenW < 360 ? 9.sp : 10.sp;
    final subFontSize = screenW < 360 ? 8.sp : 9.sp;
    final iconSize = screenW < 360 ? 14.sp : 16.sp;
    final iconBoxSize = screenW < 360 ? 26.w : 30.w;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14.r),
        border:
            Border.all(color: const Color(0xFFB8973A).withValues(alpha: 0.12)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconBoxSize,
              height: iconBoxSize,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9.r)),
              child: Icon(icon, color: color, size: iconSize),
            ),
            SizedBox(height: 6.h),
            Text(value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w800),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 2.h),
            Text(label,
                style: TextStyle(
                    color: const Color(0xFFB8973A),
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 3.h),
            Text(sub,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: subFontSize),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ]),
    );
  }
}

class _PendingAlert extends StatelessWidget {
  final int count;
  const _PendingAlert({required this.count});
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
        ),
        child: Row(children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
              child: Text(
            '$count buku menunggu persetujuan Anda di tab Daftar Buku.',
            style: TextStyle(color: Colors.orange, fontSize: 13.sp),
          )),
        ]),
      );
}

class _BarChart extends StatelessWidget {
  final List<_ChartBar> bars;
  const _BarChart({required this.bars});

  @override
  Widget build(BuildContext context) {
    final maxVal = bars.map((b) => b.amount).reduce((a, b) => a > b ? a : b);
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14.r),
        border:
            Border.all(color: const Color(0xFFB8973A).withValues(alpha: 0.12)),
      ),
      child: Column(children: [
        SizedBox(
          height: 130.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bars.map((b) {
              final ratio = maxVal == 0 ? 0.0 : b.amount / maxVal;
              return Flexible(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FittedBox(
                    child: Text(_fmtK(b.amount),
                        style: TextStyle(
                            color: Color(0xFFB8973A),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 4.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    width: 28.w,
                    height: (110 * ratio).h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFFB8973A), Color(0xFFD4B85A)],
                      ),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                ]),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: bars
              .map((b) => Text(b.label,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11.sp)))
              .toList(),
        ),
      ]),
    );
  }

  String _fmtK(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}Jt';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return '$v';
  }
}

class _ChartBar {
  final String label;
  final int amount;
  const _ChartBar(this.label, this.amount);
}

class _UserDistribution extends StatelessWidget {
  final int totalSeller, totalBuyer;
  const _UserDistribution(
      {required this.totalSeller, required this.totalBuyer});

  @override
  Widget build(BuildContext context) {
    final total = totalSeller + totalBuyer;
    final sellerRatio = total == 0 ? 0.5 : totalSeller / total;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14.r),
        border:
            Border.all(color: const Color(0xFFB8973A).withValues(alpha: 0.12)),
      ),
      child: Column(children: [
        Row(children: [
          _DistChip(
              label: 'Seller',
              count: totalSeller,
              color: const Color(0xFFB8973A)),
          const Spacer(),
          _DistChip(label: 'Buyer', count: totalBuyer, color: Colors.blue),
        ]),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Row(children: [
            Expanded(
              flex: (sellerRatio * 100).round(),
              child: Container(height: 12.h, color: const Color(0xFFB8973A)),
            ),
            Expanded(
              flex: ((1 - sellerRatio) * 100).round(),
              child: Container(height: 12.h, color: Colors.blue),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _DistChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _DistChip(
      {required this.label, required this.count, required this.color});
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 6.w),
        Text('$label ($count)',
            style: TextStyle(
                color: color, fontSize: 13.sp, fontWeight: FontWeight.w600)),
      ]);
}

class _BookStatusBar extends StatelessWidget {
  final int approved, pending, total;
  const _BookStatusBar(
      {required this.approved, required this.pending, required this.total});

  @override
  Widget build(BuildContext context) {
    final approvedR = total == 0 ? 0.0 : approved / total;
    final pendingR = total == 0 ? 0.0 : pending / total;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14.r),
        border:
            Border.all(color: const Color(0xFFB8973A).withValues(alpha: 0.12)),
      ),
      child: Column(children: [
        Row(children: [
          _StatusChip(label: 'Approved', count: approved, color: Colors.green),
          const Spacer(),
          _StatusChip(label: 'Pending', count: pending, color: Colors.orange),
        ]),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Row(children: [
            if (approved > 0)
              Expanded(
                flex: (approvedR * 100).round(),
                child: Container(height: 12.h, color: Colors.green),
              ),
            if (pending > 0)
              Expanded(
                flex: (pendingR * 100).round(),
                child: Container(height: 12.h, color: Colors.orange),
              ),
            if (approved == 0 && pending == 0)
              Expanded(
                  child: Container(
                      height: 12.h,
                      color: Colors.white.withValues(alpha: 0.1))),
          ]),
        ),
      ]),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatusChip(
      {required this.label, required this.count, required this.color});
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 6.w),
        Text('$label ($count)',
            style: TextStyle(
                color: color, fontSize: 13.sp, fontWeight: FontWeight.w600)),
      ]);
}

class _RecentOrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  const _RecentOrderTile({required this.order});

  Color get _statusColor {
    switch (order['status']) {
      case 'pending':
        return Colors.orange;
      case 'dikonfirmasi':
        return Colors.teal;
      case 'selesai':
        return Colors.green;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12.r),
          border:
              Border.all(color: const Color(0xFFB8973A).withValues(alpha: 0.1)),
        ),
        child: Row(children: [
          Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: const Color(0xFFB8973A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r)),
              child: Icon(Icons.receipt_outlined,
                  color: Color(0xFFB8973A), size: 20.sp)),
          SizedBox(width: 12.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(order['book_judul'] ?? '-',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(order['buyer_name'] ?? '-',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11.sp)),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r)),
                child: Text(order['status'] ?? '',
                    style: TextStyle(
                        color: _statusColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600))),
            SizedBox(height: 4.h),
            Text('Rp ${_fmt((order['total'] as num).toInt())}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600)),
          ]),
        ]),
      );

  String _fmt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}

class _EmptyBox extends StatelessWidget {
  final String label;
  const _EmptyBox({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
                color: const Color(0xFFB8973A).withValues(alpha: 0.1))),
        child: Center(
            child: Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 14.sp))),
      );
}
