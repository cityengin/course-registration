import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lab_notifier.dart';
import 'rebuild_tracker.dart';

/// [ProviderLabScreen]: Màn hình thực nghiệm trực quan hóa cơ chế rebuild trong Flutter.
///
/// TẠI SAO DÙNG ChangeNotifierProvider CỤC BỘ TẠI ĐÂY?
/// - [LabNotifier] là state riêng biệt, phục vụ bài lab đo đếm số lần build,
///   không can thiệp vào [RegistrationNotifier] ở cấp toàn ứng dụng (main.dart).
/// - Khi đặt [ChangeNotifierProvider] ngay tại đây, instance [LabNotifier] sẽ có
///   vòng đời gắn liền với màn hình này. Khi người dùng bấm nút Back (Pop khỏi Navigator),
///   Provider sẽ tự động gọi dispose() để dọn dẹp và giải phóng tài nguyên bộ nhớ.
class ProviderLabScreen extends StatelessWidget {
  const ProviderLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo Provider cục bộ cho màn hình Lab
    return ChangeNotifierProvider(
      create: (_) => LabNotifier(),
      child: const _ProviderLabView(),
    );
  }
}

class _ProviderLabView extends StatefulWidget {
  const _ProviderLabView();

  @override
  State<_ProviderLabView> createState() => _ProviderLabViewState();
}

class _ProviderLabViewState extends State<_ProviderLabView> {
  @override
  void initState() {
    super.initState();
    // Đặt lại bộ đếm khi vừa vào màn hình Lab để bắt đầu phiên đo mới
    RebuildTracker.resetAll();
  }

  void _resetBuildCounters() {
    RebuildTracker.resetAll();
    // [setState]: Kích hoạt rebuild màn hình Lab để cập nhật lại số đếm hiển thị về Build 1
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã đặt lại toàn bộ bộ đếm build về ban đầu (Build 1)!'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Provider Lab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Đặt lại bộ đếm build',
            onPressed: _resetBuildCounters,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Banner giới thiệu mục tiêu bài Lab
          _buildIntroBanner(),
          const SizedBox(height: 16),

          // PHẦN 1: setState vs Provider
          _buildSectionHeader(
            icon: Icons.compare_arrows_rounded,
            title: 'Phần 1: setState vs Provider',
            subtitle: 'So sánh phạm vi ảnh hưởng khi cập nhật trạng thái',
          ),
          const SizedBox(height: 8),
          const _SetStateDemoCard(),
          const SizedBox(height: 12),
          const _ProviderDemoCard(),
          const SizedBox(height: 24),

          // PHẦN 2: 4 cách đọc state trong Provider
          _buildSectionHeader(
            icon: Icons.hub_outlined,
            title: 'Phần 2: 4 cách đọc state trong Provider',
            subtitle: 'Phân biệt context.watch, Consumer, context.select và context.read',
          ),
          const SizedBox(height: 8),
          const _WatchCard(),
          const SizedBox(height: 10),
          const _ConsumerCard(),
          const SizedBox(height: 10),
          const _SelectCard(),
          const SizedBox(height: 10),
          const _ReadCard(),
          const SizedBox(height: 24),

          // PHẦN 3: Thanh điều khiển bộ đếm
          _ControlPanelCard(onResetBuildCounters: _resetBuildCounters),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildIntroBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.shade200, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.science_outlined, color: Colors.indigo.shade800, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Thực nghiệm trực quan hóa cơ chế rebuild: Quan sát chip đếm (Build: n) '
              'để thấy rõ widget nào được vẽ lại và widget nào được bảo vệ khi dữ liệu thay đổi.',
              style: TextStyle(fontSize: 12.5, color: Colors.indigo.shade900, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.indigo.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PHẦN 1: CÁC WIDGET THỰC NGHIỆM SETSTATE VS PROVIDER
// ============================================================================

/// Khối A: Sử dụng StatefulWidget + setState
class _SetStateDemoCard extends StatefulWidget {
  const _SetStateDemoCard();

  @override
  State<_SetStateDemoCard> createState() => _SetStateDemoCardState();
}

class _SetStateDemoCardState extends State<_SetStateDemoCard> {
  int _localCounter = 0;

  @override
  Widget build(BuildContext context) {
    // [setState]: Khi gọi setState(), Flutter đánh dấu StatefulWidget này là dirty
    // và chạy lại toàn bộ phương thức build(), làm cả khối cha lẫn các widget con cùng rebuild!
    final parentHits = RebuildTracker.hit('setstate_parent');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
              const SizedBox(width: 6),
              const Text(
                'Khối A: StatefulWidget + setState',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const Spacer(),
              BuildCountChip(count: parentHits, label: 'Khối cha'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTextCounter()),
              const SizedBox(width: 8),
              Expanded(child: _buildStaticChild()),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade900,
              ),
              onPressed: () {
                // [setState]: Cập nhật giá trị cục bộ và kích hoạt rebuild toàn bộ cây con
                setState(() {
                  _localCounter++;
                });
              },
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('Tăng số (setState)'),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '⚠️ Khi bấm nút, setState làm CẢ khối cha, Text số và widget con tĩnh đều rebuild.',
            style: TextStyle(fontSize: 11.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCounter() {
    final textHits = RebuildTracker.hit('setstate_text');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Giá trị: $_localCounter', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          BuildCountChip(count: textHits, label: 'Text số'),
        ],
      ),
    );
  }

  Widget _buildStaticChild() {
    final staticHits = RebuildTracker.hit('setstate_static');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Widget con tĩnh', style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 4),
          BuildCountChip(count: staticHits, label: 'Con tĩnh'),
        ],
      ),
    );
  }
}

/// Khối B: Sử dụng LabNotifier (Provider)
class _ProviderDemoCard extends StatelessWidget {
  const _ProviderDemoCard();

  @override
  Widget build(BuildContext context) {
    // Khung bao ngoài KHÔNG gọi watch nên KHÔNG bị rebuild khi LabNotifier thay đổi
    final parentHits = RebuildTracker.hit('provider_parent');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              const Text(
                'Khối B: Quản lý bằng LabNotifier',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const Spacer(),
              BuildCountChip(count: parentHits, label: 'Khối cha'),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              // Widget lắng nghe bằng context.watch
              Expanded(child: _ProviderWatchCounterWidget()),
              SizedBox(width: 8),
              // Widget con tĩnh KHÔNG lắng nghe Provider
              Expanded(child: _ProviderStaticChildWidget()),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: Colors.green.shade900,
              ),
              onPressed: () {
                // [context.read]: Gọi hàm thay đổi state trong callback mà không đăng ký lắng nghe
                context.read<LabNotifier>().incrementA();
              },
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('Tăng countA (context.read)'),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '✅ Chỉ widget hiển thị số (dùng watch) rebuild. Khối cha và widget con tĩnh giữ nguyên số build.',
            style: TextStyle(fontSize: 11.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _ProviderWatchCounterWidget extends StatelessWidget {
  const _ProviderWatchCounterWidget();

  @override
  Widget build(BuildContext context) {
    // [context.watch]: Chỉ widget nhỏ này lắng nghe LabNotifier.
    // Khi countA thay đổi, chỉ riêng widget này được Flutter đánh dấu dirty và rebuild.
    final countA = context.watch<LabNotifier>().countA;
    final hits = RebuildTracker.hit('provider_watch_text');

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('countA: $countA', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          BuildCountChip(count: hits, label: 'Watch số'),
        ],
      ),
    );
  }
}

class _ProviderStaticChildWidget extends StatelessWidget {
  const _ProviderStaticChildWidget();

  @override
  Widget build(BuildContext context) {
    // Widget tĩnh không có bất kỳ kết nối nào với Provider nên không bao giờ rebuild khi state đổi
    final hits = RebuildTracker.hit('provider_static');

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Widget tĩnh', style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 4),
          BuildCountChip(count: hits, label: 'Con tĩnh'),
        ],
      ),
    );
  }
}

// ============================================================================
// PHẦN 2: SO SÁNH 4 CÁCH ĐỌC STATE TRONG PROVIDER
// ============================================================================

/// Card 1: context.watch
class _WatchCard extends StatelessWidget {
  const _WatchCard();

  @override
  Widget build(BuildContext context) {
    // [context.watch]: Lắng nghe toàn bộ LabNotifier.
    // Bất kể countA hay countB thay đổi, widget này đều được đánh dấu dirty và rebuild.
    final hits = RebuildTracker.hit('card_watch');
    final notifier = context.watch<LabNotifier>();

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.indigo.shade100, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.visibility_outlined, size: 20, color: Colors.indigo),
                const SizedBox(width: 8),
                const Text(
                  '1. context.watch<LabNotifier>()',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                BuildCountChip(count: hits),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('countA = ${notifier.countA}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('countB = ${notifier.countB}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '💡 Giải thích: Đăng ký lắng nghe toàn bộ notifier. Rebuild cả khi tăng A hoặc tăng B.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card 2: Consumer
class _ConsumerCard extends StatelessWidget {
  const _ConsumerCard();

  @override
  Widget build(BuildContext context) {
    // Khung ngoài Card không gọi watch, chỉ build 1 lần khi màn hình khởi tạo
    final outerHits = RebuildTracker.hit('card_consumer_outer');

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal.shade100, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pie_chart_outline, size: 20, color: Colors.teal),
                const SizedBox(width: 8),
                const Text(
                  '2. Consumer<LabNotifier>',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                BuildCountChip(count: outerHits, label: 'Khung ngoài'),
              ],
            ),
            const SizedBox(height: 10),
            // [Consumer]: Giúp cô lập phạm vi rebuild chỉ trong hàm builder.
            // Tham số child được truyền vào để không bị tính toán vẽ lại lãng phí.
            Consumer<LabNotifier>(
              builder: (context, notifier, childWidget) {
                final builderHits = RebuildTracker.hit('card_consumer_builder');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'countA = ${notifier.countA} | countB = ${notifier.countB}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          BuildCountChip(count: builderHits, label: 'Trong builder'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // childWidget lấy từ tham số child bên dưới
                    childWidget!,
                  ],
                );
              },
              child: const _ConsumerStaticChild(),
            ),
            const SizedBox(height: 8),
            const Text(
              '💡 Giải thích: Chỉ phần UI trong builder rebuild khi state đổi; khung ngoài Card và widget child tĩnh giữ nguyên số build.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsumerStaticChild extends StatelessWidget {
  const _ConsumerStaticChild();

  @override
  Widget build(BuildContext context) {
    // Widget tĩnh được truyền qua tham số child của Consumer, không bao giờ rebuild khi notifier thay đổi
    final childHits = RebuildTracker.hit('card_consumer_child');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          const Text('Widget tĩnh (tham số child)', style: TextStyle(fontSize: 12, color: Colors.black54)),
          const Spacer(),
          BuildCountChip(count: childHits, label: 'Child'),
        ],
      ),
    );
  }
}

/// Card 3: context.select
class _SelectCard extends StatelessWidget {
  const _SelectCard();

  @override
  Widget build(BuildContext context) {
    // [context.select]: Chỉ theo dõi sự thay đổi của countA.
    // Flutter sẽ so sánh giá trị trả về trước và sau khi notifyListeners().
    // Nếu countA không đổi (ví dụ khi chỉ tăng countB), widget này KHÔNG rebuild!
    final countA = context.select<LabNotifier, int>((n) => n.countA);
    final hits = RebuildTracker.hit('card_select');

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.deepPurple.shade100, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_center_focus_outlined, size: 20, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text(
                  '3. context.select<LabNotifier, int>(...)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                BuildCountChip(count: hits),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text('Chỉ theo dõi countA:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Text('$countA', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  const Text('(Bỏ qua countB)', style: TextStyle(fontSize: 12, color: Colors.deepPurple)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '💡 Giải thích: Chỉ rebuild khi countA thay đổi. Bấm "Tăng B" thì state đổi nhưng Card này không hề rebuild!',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card 4: context.read (Thao tác)
class _ReadCard extends StatelessWidget {
  const _ReadCard();

  @override
  Widget build(BuildContext context) {
    // [context.read]: Lấy tham chiếu đến LabNotifier mà KHÔNG đăng ký lắng nghe (listen: false).
    // Phù hợp tuyệt đối để đặt trong các hàm xử lý sự kiện (onPressed).
    // Card này không bao giờ bị rebuild khi state thay đổi.
    final hits = RebuildTracker.hit('card_read');

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade100, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.touch_app_outlined, size: 20, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  '4. context.read<LabNotifier>() (Thao tác)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                BuildCountChip(count: hits),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {
                      // [context.read]: Tăng countA trong callback sự kiện
                      context.read<LabNotifier>().incrementA();
                    },
                    child: const Text('Tăng A (+1)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {
                      // [context.read]: Tăng countB trong callback sự kiện
                      context.read<LabNotifier>().incrementB();
                    },
                    child: const Text('Tăng B (+1)'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // [context.read]: Đặt lại cả countA và countB về 0
                    context.read<LabNotifier>().reset();
                  },
                  child: const Text('Reset Lab'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '💡 Giải thích: Dùng trong hàm xử lý sự kiện (onPressed). Vì không lắng nghe (listen: false) nên Card này không bao giờ rebuild.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PHẦN 3: THANH ĐIỀU KHIỂN BỘ ĐẾM BUILD
// ============================================================================

class _ControlPanelCard extends StatelessWidget {
  final VoidCallback onResetBuildCounters;

  const _ControlPanelCard({required this.onResetBuildCounters});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.amber.shade50.withValues(alpha: 0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.amber.shade300, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, size: 20, color: Colors.amber.shade900),
                const SizedBox(width: 8),
                Text(
                  'Phần 3: Thanh điều khiển bộ đếm build',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Đặt lại toàn bộ số đếm của RebuildTracker về 0, sau đó gọi setState() ở màn Lab để vẽ lại tất cả các chip về Build 1.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber.shade900,
                  foregroundColor: Colors.white,
                ),
                onPressed: onResetBuildCounters,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  'Đặt lại bộ đếm build (resetAll)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
