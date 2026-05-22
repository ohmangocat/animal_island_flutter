import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AnimalIslandMobilePreviewApp());
}

class AnimalIslandMobilePreviewApp extends StatelessWidget {
  const AnimalIslandMobilePreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animal Island Mobile Preview',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F4E8),
      ),
      home: const AnimalTheme(child: MobilePreviewHome()),
    );
  }
}

class MobilePreviewHome extends StatefulWidget {
  const MobilePreviewHome({super.key});

  @override
  State<MobilePreviewHome> createState() => _MobilePreviewHomeState();
}

class _MobilePreviewHomeState extends State<MobilePreviewHome> {
  String? _group;
  String? _routeKey;

  _PreviewPage? get _activePage {
    final routeKey = _routeKey;
    if (routeKey == null) {
      return null;
    }
    return _pages.cast<_PreviewPage?>().firstWhere(
          (page) => page?.routeKey == routeKey,
          orElse: () => null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final activePage = _activePage;
    final title = activePage?.navTitle ?? _group ?? '组件分类';
    final canBack = _group != null || activePage != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _PreviewAppBar(
              title: title,
              canBack: canBack,
              onBack: _back,
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const _PreviewTiledBackground(),
                  if (activePage != null)
                    _PreviewDetailPage(page: activePage)
                  else if (_group != null)
                    _PreviewListPage(
                      group: _group!,
                      pages: _pagesForGroup(_group!),
                      onSelectPage: (page) {
                        setState(() {
                          _group = page.group;
                          _routeKey = page.routeKey;
                        });
                      },
                    )
                  else
                    _PreviewCategoryPage(
                      onSelectGroup: (group) {
                        setState(() {
                          _group = group;
                          _routeKey = null;
                        });
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _back() {
    setState(() {
      if (_routeKey != null) {
        _routeKey = null;
      } else if (_group != null) {
        _group = null;
      }
    });
  }
}

class _PreviewAppBar extends StatelessWidget {
  const _PreviewAppBar({
    required this.title,
    required this.canBack,
    required this.onBack,
  });

  final String title;
  final bool canBack;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8D6),
        border: Border(bottom: BorderSide(color: Color(0xFFE8D8B8), width: 2)),
      ),
      child: Row(
        children: [
          _RoundIconButton(
            icon:
                canBack ? Icons.arrow_back_rounded : Icons.phone_iphone_rounded,
            onTap: canBack ? onBack : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyle(
                size: 17,
                weight: FontWeight.w900,
                color: const Color(0xFF725D42),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: enabled ? Colors.white : const Color(0xFFF5EBC8),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE0CCA0), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A3D3428),
                offset: Offset(0, 2),
                blurRadius: 0,
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? const Color(0xFF725D42) : const Color(0xFFB9A783),
          ),
        ),
      ),
    );
  }
}

class _PreviewTiledBackground extends StatelessWidget {
  const _PreviewTiledBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFF8F4E8),
        image: DecorationImage(
          image: AssetImage('assets/demo/img/content_bg_pc.jpg'),
          repeat: ImageRepeat.repeat,
          fit: BoxFit.none,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class _PreviewCategoryPage extends StatelessWidget {
  const _PreviewCategoryPage({required this.onSelectGroup});

  final ValueChanged<String> onSelectGroup;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        Text(
          '组件分类',
          style: theme.textStyle(size: 25, weight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          '从分类进入组件列表，再查看移动端效果。',
          style: theme.textStyle(
            size: 13,
            weight: FontWeight.w700,
            color: const Color(0xFF8A7652),
          ),
        ),
        const SizedBox(height: 16),
        for (final group in _docNavGroups)
          if (_pagesForGroup(group).isNotEmpty) ...[
            _PreviewCategoryTile(
              title: group,
              count: _pagesForGroup(group).length,
              icon: _groupIcon(group),
              color: _groupColor(group),
              onTap: () => onSelectGroup(group),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _PreviewCategoryTile extends StatelessWidget {
  const _PreviewCategoryTile({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE8E2D6), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F3D3428),
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icon, color: color, size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textStyle(size: 17, weight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$count 个组件',
                      style: theme.textStyle(
                        size: 12,
                        weight: FontWeight.w800,
                        color: const Color(0xFF9A8465),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB08A42),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewListPage extends StatelessWidget {
  const _PreviewListPage({
    required this.group,
    required this.pages,
    required this.onSelectPage,
  });

  final String group;
  final List<_PreviewPage> pages;
  final ValueChanged<_PreviewPage> onSelectPage;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        Text(
          group,
          style: theme.textStyle(size: 25, weight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          _groupDescriptions[group] ?? '',
          style: theme.textStyle(
            size: 13,
            weight: FontWeight.w700,
            color: const Color(0xFF8A7652),
          ),
        ),
        const SizedBox(height: 16),
        for (final page in pages) ...[
          _PreviewComponentTile(
            page: page,
            onTap: () => onSelectPage(page),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _PreviewComponentTile extends StatelessWidget {
  const _PreviewComponentTile({
    required this.page,
    required this.onTap,
  });

  final _PreviewPage page;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFDF7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8E2D6), width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _groupColor(page.group).withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(color: _groupColor(page.group), width: 2),
                ),
                child: Icon(
                  _routeIcon(page.routeKey),
                  color: _groupColor(page.group),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      page.navTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(size: 15, weight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      page.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(
                        size: 12,
                        weight: FontWeight.w600,
                        color: const Color(0xFF9A8465),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB08A42),
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewDetailPage extends StatelessWidget {
  const _PreviewDetailPage({required this.page});

  final _PreviewPage page;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _groupColor(page.group).withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(color: _groupColor(page.group), width: 2),
              ),
              child: Icon(
                _routeIcon(page.routeKey),
                color: _groupColor(page.group),
                size: 25,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle(size: 22, weight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  AnimalTag(
                    color: AnimalTagColor.primary,
                    size: AnimalTagSize.small,
                    child: Text(page.group),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          page.summary,
          style: theme.textStyle(
            size: 13,
            weight: FontWeight.w700,
            color: const Color(0xFF7D684B),
          ),
        ),
        const SizedBox(height: 18),
        _PreviewDemoPanel(
          child: _ComponentPreviewDemo(routeKey: page.routeKey),
        ),
        const SizedBox(height: 18),
        const AnimalDivider(type: AnimalDividerType.waveYellow, height: 18),
      ],
    );
  }
}

class _PreviewDemoPanel extends StatelessWidget {
  const _PreviewDemoPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E2D6), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F3D3428),
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ComponentPreviewDemo extends StatelessWidget {
  const _ComponentPreviewDemo({required this.routeKey});

  final String routeKey;

  @override
  Widget build(BuildContext context) {
    final demo = switch (routeKey) {
      'theme' => _previewTheme(),
      'button' => _previewButton(),
      'icon' => _previewIcon(),
      'avatar' => _previewAvatar(),
      'tag' => _previewTag(),
      'badge' => _previewBadge(),
      'card' => _previewCard(),
      'collapse' => _previewCollapse(),
      'divider-comp' => _previewDivider(),
      'skeleton' => _previewSkeleton(),
      'empty' => _previewEmpty(),
      'input' => _previewInput(),
      'input-plus' => _previewInputPlus(),
      'select' => _previewSelect(),
      'checkbox' => _previewCheckbox(),
      'radio' => _previewRadio(),
      'switch' => _previewSwitch(),
      'slider' => _previewSlider(),
      'rate' => _previewRate(),
      'segmented' => _previewSegmented(),
      'form' => _previewForm(),
      'calendar' => _previewCalendar(),
      'upload' => _previewUpload(),
      'tree' => _previewTree(),
      'tabs' => _previewTabs(),
      'breadcrumb' => _previewBreadcrumb(),
      'steps' => _previewSteps(),
      'pagination' => _previewPagination(),
      'alert' => _previewAlert(),
      'message' => _previewMessage(context),
      'tooltip' => _previewTooltip(),
      'progress' => _previewProgress(),
      'loading' => _previewLoading(),
      'result' => _previewResult(),
      'table' => _previewTable(),
      'descriptions' => _previewDescriptions(),
      'statistic' => _previewStatistic(),
      'timeline' => _previewTimeline(),
      'codeblock' => _previewCodeBlock(),
      'modal' => _previewModal(context),
      'popover' => _previewPopover(),
      'dropdown' => _previewDropdown(context),
      'drawer' => _previewDrawer(context),
      'confirm-dialog' => _previewConfirmDialog(context),
      'time' => _previewTime(),
      'phone' => _previewPhone(),
      'cursor' => _previewCursor(),
      'typewriter' => _previewTypewriter(),
      'footer' => _previewFooter(),
      _ => const AnimalEmpty(description: '组件预览准备中'),
    };

    return DefaultTextStyle.merge(
      style: AnimalTheme.of(context).textStyle(),
      child: demo,
    );
  }

  Widget _previewTheme() {
    final theme = AnimalThemeData.fromPrimary(const Color(0xFFD85C7D));
    return AnimalTheme(
      data: theme,
      child: const _DemoColumn(
        children: [
          AnimalButton(type: AnimalButtonType.primary, child: Text('Berry')),
          AnimalProgress(value: 0.72),
          AnimalTag(color: AnimalTagColor.danger, child: Text('主题色联动')),
        ],
      ),
    );
  }

  Widget _previewButton() {
    return const _DemoColumn(
      children: [
        AnimalButton(type: AnimalButtonType.primary, child: Text('Primary')),
        AnimalButton(
          type: AnimalButtonType.primary,
          loading: true,
          child: Text('Loading'),
        ),
        AnimalButton(
          type: AnimalButtonType.primary,
          ghost: true,
          child: Text('Ghost'),
        ),
        AnimalButton(block: true, child: Text('Block')),
      ],
    );
  }

  Widget _previewIcon() {
    return const Wrap(
      spacing: 18,
      runSpacing: 16,
      children: [
        AnimalIcon(name: AnimalIconName.camera, size: 42, bounce: true),
        AnimalIcon(name: AnimalIconName.shopping, size: 42, bounce: true),
        AnimalIcon(name: AnimalIconName.map, size: 42, bounce: true),
        AnimalIcon(name: AnimalIconName.diy, size: 42, bounce: true),
      ],
    );
  }

  Widget _previewAvatar() {
    return const Wrap(
      spacing: 14,
      runSpacing: 12,
      children: [
        AnimalAvatar(size: AnimalAvatarSize.large, child: Text('狸')),
        AnimalAvatar(icon: AnimalIconName.camera),
        AnimalAvatar(shape: AnimalAvatarShape.square, child: Text('岛')),
      ],
    );
  }

  Widget _previewTag() {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        AnimalTag(color: AnimalTagColor.primary, child: Text('Primary')),
        AnimalTag(color: AnimalTagColor.success, child: Text('Success')),
        AnimalTag(color: AnimalTagColor.warning, child: Text('Warning')),
        AnimalTag(
          color: AnimalTagColor.purple,
          icon: Icon(Icons.star_rounded),
          child: Text('Star'),
        ),
      ],
    );
  }

  Widget _previewBadge() {
    return const Wrap(
      spacing: 22,
      runSpacing: 16,
      children: [
        AnimalBadge(
          count: 8,
          child: AnimalAvatar(icon: AnimalIconName.shopping),
        ),
        AnimalBadge(
          dot: true,
          status: AnimalBadgeStatus.success,
          child: AnimalAvatar(icon: AnimalIconName.chat),
        ),
        AnimalBadge(text: 'NEW', status: AnimalBadgeStatus.primary),
      ],
    );
  }

  Widget _previewCard() {
    return const _DemoColumn(
      children: [
        AnimalCard(
          type: AnimalCardType.title,
          color: AnimalCardColor.appYellow,
          child: Text('今日岛屿公告'),
        ),
        AnimalCard(
          color: AnimalCardColor.appTeal,
          child: Text('带有暖色边缘和柔和拟物质感的卡片。'),
        ),
      ],
    );
  }

  Widget _previewCollapse() {
    return const _DemoColumn(
      children: [
        AnimalCollapse(
          question: Text('今天适合做什么？'),
          answer: Text('钓鱼、浇花、整理背包都很合适。'),
          defaultExpanded: true,
        ),
        AnimalCollapse(question: Text('商店几点关门？'), answer: Text('晚上 10 点。')),
      ],
    );
  }

  Widget _previewDivider() {
    return const _DemoColumn(
      children: [
        AnimalDivider(type: AnimalDividerType.lineBrown),
        AnimalDivider(type: AnimalDividerType.lineTeal),
        AnimalDivider(type: AnimalDividerType.waveYellow, height: 18),
      ],
    );
  }

  Widget _previewSkeleton() {
    return const AnimalSkeleton(rows: 4, lineHeight: 15);
  }

  Widget _previewEmpty() {
    return AnimalEmpty(
      description: '今天还没有记录',
      action: AnimalButton(
        type: AnimalButtonType.primary,
        onPressed: () {},
        child: const Text('添加记录'),
      ),
    );
  }

  Widget _previewInput() {
    return const _DemoColumn(
      children: [
        AnimalInput(
          hintText: '岛屿名称',
          prefix: Icon(Icons.search_rounded, size: 18),
          allowClear: true,
        ),
        AnimalInput(hintText: '有阴影输入框', shadow: true),
        AnimalInput(hintText: '校验状态', status: AnimalInputStatus.warning),
      ],
    );
  }

  Widget _previewInputPlus() {
    return const _DemoColumn(
      children: [
        AnimalSearchInput(hintText: '搜索岛民'),
        AnimalPasswordInput(initialValue: 'nookpass'),
        AnimalTextarea(hintText: '写下今天的岛屿计划', rows: 3),
      ],
    );
  }

  Widget _previewSelect() {
    return _DemoColumn(
      children: [
        AnimalSelect<String>(
          options: _fishOptions,
          value: 'fish2',
          onChanged: (_) {},
        ),
        AnimalSelect<String>(
          options: _fruitOptions,
          value: null,
          placeholder: '选择水果',
          onChanged: (_) {},
        ),
      ],
    );
  }

  Widget _previewCheckbox() {
    return const AnimalCheckbox<String>(
      defaultValue: ['beach', 'garden'],
      options: _islandShortOptions,
    );
  }

  Widget _previewRadio() {
    return const AnimalRadio<String>(
      defaultValue: 'peach',
      options: [
        AnimalRadioOption(value: 'apple', label: Text('苹果岛')),
        AnimalRadioOption(value: 'peach', label: Text('桃子岛')),
        AnimalRadioOption(value: 'locked', label: Text('未开放'), disabled: true),
      ],
    );
  }

  Widget _previewSwitch() {
    return const Wrap(
      spacing: 16,
      runSpacing: 14,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AnimalSwitch(
          defaultValue: true,
          checkedChild: Text('开'),
          uncheckedChild: Text('关'),
        ),
        AnimalSwitch(size: AnimalSwitchSize.small, defaultValue: true),
        AnimalSwitch(loading: true, defaultValue: true),
      ],
    );
  }

  Widget _previewSlider() {
    return const _DemoColumn(
      children: [
        AnimalSlider(defaultValue: 64, divisions: 10),
        AnimalSlider(defaultValue: 0, showLabel: true),
        AnimalSlider(defaultValue: 100, disabled: true),
      ],
    );
  }

  Widget _previewRate() {
    return const _DemoColumn(
      children: [
        AnimalRate(defaultValue: 4),
        AnimalCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('今日岛屿满意度'),
              SizedBox(height: 8),
              AnimalRate(defaultValue: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _previewSegmented() {
    return const AnimalSegmented<String>(
      defaultValue: 'grid',
      options: [
        AnimalSegmentedOption(
          value: 'list',
          label: Text('列表'),
          icon: Icon(Icons.list_rounded),
        ),
        AnimalSegmentedOption(
          value: 'grid',
          label: Text('网格'),
          icon: Icon(Icons.grid_view_rounded),
        ),
        AnimalSegmentedOption(
          value: 'map',
          label: Text('地图'),
          icon: Icon(Icons.map_rounded),
        ),
      ],
    );
  }

  Widget _previewForm() {
    return AnimalForm(
      layout: AnimalFormLayout.vertical,
      child: _DemoColumn(
        children: [
          const AnimalFormItem(
            label: Text('岛屿名'),
            required: true,
            child: AnimalInput(initialValue: '星露岛'),
          ),
          AnimalFormItem(
            label: const Text('特产'),
            child: AnimalSelect<String>(
              options: _fruitOptions,
              value: 'fruit3',
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewCalendar() {
    return Center(
      child: Transform.scale(
        scale: 0.84,
        child: AnimalCalendar(
          value: DateTime(2026, 5, 22),
          month: DateTime(2026, 5),
        ),
      ),
    );
  }

  Widget _previewUpload() {
    return AnimalUpload(
      title: '上传岛屿照片',
      hint: '点击选择照片',
      onTap: () {},
      files: const [
        AnimalUploadFile(
          name: 'museum.png',
          status: AnimalUploadStatus.uploading,
          progress: 0.62,
          size: '1.8 MB',
        ),
        AnimalUploadFile(
          name: 'beach.webp',
          status: AnimalUploadStatus.done,
          size: '920 KB',
        ),
      ],
    );
  }

  Widget _previewTree() {
    return const AnimalTree<String>(
      nodes: _treeNodes,
      selectedValue: 'rose',
      defaultExpandedValues: ['plants', 'animals'],
    );
  }

  Widget _previewTabs() {
    return const AnimalTabs(
      defaultActiveKey: 'tab2',
      items: _controlledTabs,
    );
  }

  Widget _previewBreadcrumb() {
    return const AnimalBreadcrumb(
      items: [
        AnimalBreadcrumbItem(label: Text('岛屿')),
        AnimalBreadcrumbItem(label: Text('商店')),
        AnimalBreadcrumbItem(label: Text('今日价格')),
      ],
    );
  }

  Widget _previewSteps() {
    return const AnimalSteps(
      current: 1,
      direction: AnimalStepsDirection.vertical,
      items: [
        AnimalStepItem(title: Text('出发'), description: Text('整理背包')),
        AnimalStepItem(title: Text('采集'), description: Text('收集素材')),
        AnimalStepItem(title: Text('完成'), description: Text('回到服务处')),
      ],
    );
  }

  Widget _previewPagination() {
    return AnimalPagination(
      current: 3,
      total: 86,
      onChanged: (_) {},
    );
  }

  Widget _previewAlert() {
    return const _DemoColumn(
      children: [
        AnimalAlert(
          type: AnimalAlertType.success,
          title: Text('保存成功'),
          child: Text('岛屿档案已经同步。'),
        ),
        AnimalAlert(
          type: AnimalAlertType.warning,
          child: Text('背包容量即将不足。'),
        ),
      ],
    );
  }

  Widget _previewMessage(BuildContext context) {
    return AnimalButton(
      type: AnimalButtonType.primary,
      onPressed: () => AnimalMessage.success(
        context,
        const Text('保存成功'),
      ),
      child: const Text('显示轻提示'),
    );
  }

  Widget _previewTooltip() {
    return const Center(
      child: AnimalTooltip(
        message: '长按或悬停查看提示',
        placement: AnimalTooltipPlacement.bottom,
        child: AnimalButton(
          type: AnimalButtonType.primary,
          child: Text('查看提示'),
        ),
      ),
    );
  }

  Widget _previewProgress() {
    return const _DemoColumn(
      children: [
        AnimalProgress(value: 0.38),
        AnimalProgress(value: 0.72, color: Color(0xFFD85C7D)),
        AnimalProgress(value: 1),
      ],
    );
  }

  Widget _previewLoading() {
    return const Wrap(
      spacing: 18,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AnimalLoading(style: AnimalLoadingStyle.spinner, size: 30),
        AnimalLoading(style: AnimalLoadingStyle.stripes, size: 28),
        AnimalButton(
          type: AnimalButtonType.primary,
          loading: true,
          child: Text('Loading'),
        ),
      ],
    );
  }

  Widget _previewResult() {
    return AnimalResult(
      status: AnimalResultStatus.success,
      title: const Text('发布成功'),
      description: const Text('你的岛屿图鉴已经更新。'),
      action: AnimalButton(
        type: AnimalButtonType.primary,
        onPressed: () {},
        child: const Text('继续查看'),
      ),
    );
  }

  Widget _previewTable() {
    return SizedBox(
      height: 248,
      child: _IslandTable(striped: true, loading: false),
    );
  }

  Widget _previewDescriptions() {
    return const AnimalDescriptions(
      column: 2,
      title: Text('岛屿档案'),
      items: [
        AnimalDescriptionItem(label: Text('名称'), child: Text('星露岛')),
        AnimalDescriptionItem(label: Text('水果'), child: Text('桃子')),
        AnimalDescriptionItem(label: Text('天气'), child: Text('晴朗')),
        AnimalDescriptionItem(label: Text('访客'), child: Text('骆岚')),
      ],
    );
  }

  Widget _previewStatistic() {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        AnimalStatistic(title: Text('贝壳'), value: 128, suffix: Text('个')),
        AnimalStatistic(title: Text('完成率'), value: 86, suffix: Text('%')),
      ],
    );
  }

  Widget _previewTimeline() {
    return const AnimalTimeline(
      items: [
        AnimalTimelineItem(
          title: Text('抵达无人岛'),
          time: Text('09:00'),
          status: AnimalTimelineItemStatus.success,
        ),
        AnimalTimelineItem(
          title: Text('整理花园'),
          description: Text('清理杂草并浇水'),
          time: Text('10:30'),
          status: AnimalTimelineItemStatus.primary,
        ),
        AnimalTimelineItem(
          title: Text('等待商店开门'),
          status: AnimalTimelineItemStatus.warning,
        ),
      ],
    );
  }

  Widget _previewCodeBlock() {
    return const AnimalCodeBlock(
      code:
          "AnimalButton(\n  type: AnimalButtonType.primary,\n  child: Text('按钮'),\n)",
      padding: EdgeInsets.all(16),
    );
  }

  Widget _previewModal(BuildContext context) {
    return AnimalButton(
      type: AnimalButtonType.primary,
      onPressed: () {
        AnimalDialog.show<void>(
          context: context,
          title: const Text('博物馆捐赠'),
          child: const Text('是否愿意将这条鱼捐赠给博物馆？'),
        );
      },
      child: const Text('打开弹窗'),
    );
  }

  Widget _previewPopover() {
    return const Center(
      child: AnimalPopover(
        title: Text('岛屿提示'),
        content: Text('今日高价收购大头菜。'),
        child: AnimalButton(
          type: AnimalButtonType.primary,
          child: Text('打开气泡'),
        ),
      ),
    );
  }

  Widget _previewDropdown(BuildContext context) {
    return Center(
      child: AnimalDropdown<String>(
        width: 220,
        items: const [
          AnimalDropdownItem(
            value: 'view',
            icon: Icon(Icons.visibility_rounded),
            label: Text('查看详情'),
          ),
          AnimalDropdownItem(
            value: 'share',
            icon: Icon(Icons.ios_share_rounded),
            label: Text('分享岛屿'),
          ),
          AnimalDropdownItem(
            value: 'delete',
            icon: Icon(Icons.delete_rounded),
            label: Text('删除记录'),
            disabled: true,
          ),
        ],
        onChanged: (value) => AnimalMessage.info(context, Text('选择了 $value')),
        child: const AnimalButton(child: Text('更多操作')),
      ),
    );
  }

  Widget _previewDrawer(BuildContext context) {
    return AnimalButton(
      type: AnimalButtonType.primary,
      onPressed: () {
        AnimalDrawer.show<void>(
          context: context,
          title: const Text('背包'),
          child: const Text('木材 x 12\n铁矿石 x 8\n樱桃 x 5'),
        );
      },
      child: const Text('打开抽屉'),
    );
  }

  Widget _previewConfirmDialog(BuildContext context) {
    return AnimalButton(
      type: AnimalButtonType.primary,
      danger: true,
      onPressed: () {
        AnimalConfirmDialog.show(
          context: context,
          title: const Text('确认出售'),
          content: const Text('确定要出售这一组物品吗？'),
          danger: true,
        );
      },
      child: const Text('确认操作'),
    );
  }

  Widget _previewTime() {
    return Center(
      child: Transform.scale(
        scale: 0.82,
        child: AnimalTime(now: DateTime(2026, 5, 22, 10, 28)),
      ),
    );
  }

  Widget _previewPhone() {
    return const Center(
      child: SizedBox(
        width: 220,
        child: AnimalPhone(),
      ),
    );
  }

  Widget _previewCursor() {
    return const AnimalCursor(
      child: AnimalCard(
        color: AnimalCardColor.appGreen,
        child: Text('桌面端移入时会显示自定义手形光标。'),
      ),
    );
  }

  Widget _previewTypewriter() {
    return AnimalTypewriter(
      trigger: routeKey,
      text: '欢迎来到 Animal Island Flutter。这里是移动端的组件效果预览。',
      speed: const Duration(milliseconds: 35),
    );
  }

  Widget _previewFooter() {
    return const _DemoColumn(
      children: [
        AnimalFooter(type: AnimalFooterType.tree, height: 86),
        AnimalFooter(type: AnimalFooterType.sea, height: 58),
      ],
    );
  }
}

class _DemoColumn extends StatelessWidget {
  const _DemoColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final indexed in children.indexed) ...[
            if (indexed.$1 > 0) const SizedBox(height: 12),
            indexed.$2,
          ],
        ],
      ),
    );
  }
}

class _IslandTable extends StatelessWidget {
  const _IslandTable({required this.striped, required this.loading});

  final bool striped;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AnimalTable<Map<String, Object>>(
      striped: striped,
      loading: loading,
      columns: [
        AnimalTableColumn(
          title: const Text('岛民'),
          width: 120,
          cellBuilder: (_, row, __) => Text(row['name'] as String),
        ),
        AnimalTableColumn(
          title: const Text('年龄'),
          width: 80,
          alignment: Alignment.center,
          cellBuilder: (_, row, __) => Text('${row['age']}'),
        ),
        AnimalTableColumn(
          title: const Text('岛屿'),
          cellBuilder: (_, row, __) => Text(row['island'] as String),
        ),
        AnimalTableColumn(
          title: const Text('喜欢的水果'),
          cellBuilder: (_, row, __) => Text(row['fruit'] as String),
        ),
        AnimalTableColumn(
          title: const Text('爱好'),
          cellBuilder: (_, row, __) => _HobbyTag(row['hobby'] as String),
        ),
      ],
      rows: _tableRows,
    );
  }
}

class _HobbyTag extends StatelessWidget {
  const _HobbyTag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final style = _hobbyStyle[text] ??
        const _TagStyle(
          background: Color(0x2619C8B9),
          foreground: Color(0xFF19C8B9),
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: style.foreground,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _PreviewPage {
  const _PreviewPage({
    required this.routeKey,
    required this.group,
    required this.navTitle,
    required this.title,
    required this.summary,
  });

  final String routeKey;
  final String group;
  final String navTitle;
  final String title;
  final String summary;
}

class _TagStyle {
  const _TagStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

List<_PreviewPage> _pagesForGroup(String group) {
  return [
    for (final page in _pages)
      if (page.group == group) page
  ];
}

IconData _groupIcon(String group) {
  return switch (group) {
    '主题与基础' => Icons.palette_rounded,
    '布局与容器' => Icons.dashboard_customize_rounded,
    '表单输入' => Icons.tune_rounded,
    '数据录入' => Icons.edit_calendar_rounded,
    '数据展示' => Icons.table_chart_rounded,
    '导航' => Icons.near_me_rounded,
    '反馈' => Icons.notifications_active_rounded,
    '浮层' => Icons.layers_rounded,
    'Animal 特色' => Icons.eco_rounded,
    _ => Icons.widgets_rounded,
  };
}

Color _groupColor(String group) {
  return switch (group) {
    '主题与基础' => const Color(0xFF19C8B9),
    '布局与容器' => const Color(0xFFE5A928),
    '表单输入' => const Color(0xFFD85C7D),
    '数据录入' => const Color(0xFF4E8F75),
    '数据展示' => const Color(0xFF3D82C4),
    '导航' => const Color(0xFF9370DB),
    '反馈' => const Color(0xFFFF8C00),
    '浮层' => const Color(0xFFB08A42),
    'Animal 特色' => const Color(0xFF6FBA2C),
    _ => const Color(0xFF19C8B9),
  };
}

IconData _routeIcon(String routeKey) {
  return switch (routeKey) {
    'theme' => Icons.palette_rounded,
    'button' => Icons.smart_button_rounded,
    'icon' => Icons.insert_emoticon_rounded,
    'avatar' => Icons.account_circle_rounded,
    'tag' => Icons.sell_rounded,
    'badge' => Icons.notifications_rounded,
    'card' => Icons.crop_landscape_rounded,
    'collapse' => Icons.unfold_more_rounded,
    'divider-comp' => Icons.horizontal_rule_rounded,
    'skeleton' => Icons.blur_linear_rounded,
    'empty' => Icons.inbox_rounded,
    'input' => Icons.input_rounded,
    'input-plus' => Icons.text_fields_rounded,
    'select' => Icons.arrow_drop_down_circle_rounded,
    'checkbox' => Icons.check_box_rounded,
    'radio' => Icons.radio_button_checked_rounded,
    'switch' => Icons.toggle_on_rounded,
    'slider' => Icons.linear_scale_rounded,
    'rate' => Icons.star_rounded,
    'segmented' => Icons.segment_rounded,
    'form' => Icons.assignment_rounded,
    'calendar' => Icons.calendar_month_rounded,
    'upload' => Icons.cloud_upload_rounded,
    'tree' => Icons.account_tree_rounded,
    'tabs' => Icons.tab_rounded,
    'breadcrumb' => Icons.route_rounded,
    'steps' => Icons.stairs_rounded,
    'pagination' => Icons.more_horiz_rounded,
    'alert' => Icons.warning_rounded,
    'message' => Icons.sms_rounded,
    'tooltip' => Icons.tips_and_updates_rounded,
    'progress' => Icons.trending_up_rounded,
    'loading' => Icons.autorenew_rounded,
    'result' => Icons.task_alt_rounded,
    'table' => Icons.table_rows_rounded,
    'descriptions' => Icons.fact_check_rounded,
    'statistic' => Icons.query_stats_rounded,
    'timeline' => Icons.timeline_rounded,
    'codeblock' => Icons.code_rounded,
    'modal' => Icons.chat_bubble_rounded,
    'popover' => Icons.comment_rounded,
    'dropdown' => Icons.menu_open_rounded,
    'drawer' => Icons.view_sidebar_rounded,
    'confirm-dialog' => Icons.help_rounded,
    'time' => Icons.schedule_rounded,
    'phone' => Icons.phone_iphone_rounded,
    'cursor' => Icons.ads_click_rounded,
    'typewriter' => Icons.keyboard_rounded,
    'footer' => Icons.water_rounded,
    _ => Icons.widgets_rounded,
  };
}

const _docNavGroups = [
  '主题与基础',
  '布局与容器',
  '表单输入',
  '数据录入',
  '数据展示',
  '导航',
  '反馈',
  '浮层',
  'Animal 特色',
];

const _groupDescriptions = {
  '主题与基础': '主题令牌、按钮、图标和轻量标识，构成界面的基础表达。',
  '布局与容器': '组织页面结构、内容分隔和加载占位的常用容器。',
  '表单输入': '覆盖文本输入、选择、开关、评分和完整表单布局。',
  '数据录入': '面向日期、文件和层级节点的复杂录入控件。',
  '数据展示': '用于表格、详情、指标、时间线和代码内容展示。',
  '导航': '页面切换、路径提示、步骤流程和分页导航。',
  '反馈': '提示、消息、进度、加载和结果状态反馈。',
  '浮层': '弹窗、气泡、菜单、抽屉和确认流程。',
  'Animal 特色': '保留 Animal Island 氛围的装饰、光标和拟物化组件。',
};

const _pages = [
  _PreviewPage(
    routeKey: 'theme',
    group: '主题与基础',
    navTitle: 'Theme 主题',
    title: 'Theme 主题定制',
    summary: '主题能力 — 支持默认令牌、品牌主色派生、外部字体和局部覆盖',
  ),
  _PreviewPage(
    routeKey: 'button',
    group: '主题与基础',
    navTitle: 'Button 按钮',
    title: 'Button 按钮',
    summary:
        '按钮组件 — 支持 primary / dashed / text / link 等类型，danger / ghost / loading / disabled 状态，icon 图标，block 块级，三种尺寸',
  ),
  _PreviewPage(
    routeKey: 'icon',
    group: '主题与基础',
    navTitle: 'Icon 图标',
    title: 'Icon 图标',
    summary: '图标组件 — 动森风格图标集，包含 10 个可爱图标，支持自定义尺寸',
  ),
  _PreviewPage(
    routeKey: 'avatar',
    group: '主题与基础',
    navTitle: 'Avatar 头像',
    title: 'Avatar 头像',
    summary: '头像组件 — 支持文字、图片、AnimalIcon、尺寸和圆形/方形形状',
  ),
  _PreviewPage(
    routeKey: 'tag',
    group: '主题与基础',
    navTitle: 'Tag 标签',
    title: 'Tag 标签',
    summary: '标签组件 — 支持多种语义颜色、尺寸、图标和可关闭状态',
  ),
  _PreviewPage(
    routeKey: 'badge',
    group: '主题与基础',
    navTitle: 'Badge 角标',
    title: 'Badge 角标',
    summary: '角标组件 — 支持数字、小红点、状态色、文本和数字上限',
  ),
  _PreviewPage(
    routeKey: 'card',
    group: '布局与容器',
    navTitle: 'Card 卡片',
    title: 'Card 卡片',
    summary: '卡片容器组件 — 支持 default / title 两种类型，13 种背景颜色',
  ),
  _PreviewPage(
    routeKey: 'collapse',
    group: '布局与容器',
    navTitle: 'Collapse 折叠面板',
    title: 'Collapse 折叠面板',
    summary: '折叠面板组件 — 支持展开/收起、默认展开、禁用状态',
  ),
  _PreviewPage(
    routeKey: 'divider-comp',
    group: '布局与容器',
    navTitle: 'Divider 分割线',
    title: 'Divider 分割线',
    summary: '分割线组件 — 装饰性分割线',
  ),
  _PreviewPage(
    routeKey: 'skeleton',
    group: '布局与容器',
    navTitle: 'Skeleton 骨架屏',
    title: 'Skeleton 骨架屏',
    summary: '骨架屏组件 — 支持行数、宽度、行高、动画和加载完成内容切换',
  ),
  _PreviewPage(
    routeKey: 'empty',
    group: '布局与容器',
    navTitle: 'Empty 空状态',
    title: 'Empty 空状态',
    summary: '空状态组件 — 支持默认叶子图标、自定义图标、说明文案和行动按钮',
  ),
  _PreviewPage(
    routeKey: 'input',
    group: '表单输入',
    navTitle: 'Input 输入框',
    title: 'Input 输入框',
    summary:
        '输入框组件 — 支持三种尺寸、clearable 清除、prefix / suffix 前后缀、error / warning 校验状态、disabled 禁用',
  ),
  _PreviewPage(
    routeKey: 'input-plus',
    group: '表单输入',
    navTitle: 'Input Plus 输入增强',
    title: 'Input Plus 输入增强',
    summary:
        '输入增强组件 — Textarea / PasswordInput / SearchInput / NumberInput 覆盖更完整的业务输入场景',
  ),
  _PreviewPage(
    routeKey: 'select',
    group: '表单输入',
    navTitle: 'Select 选择器',
    title: 'Select 选择器',
    summary: '下拉选择器组件 — 支持自定义选项列表，高亮当前选中项',
  ),
  _PreviewPage(
    routeKey: 'checkbox',
    group: '表单输入',
    navTitle: 'Checkbox 多选框',
    title: 'Checkbox 多选框',
    summary: '多选框组件 — 支持受控/非受控、水平/垂直排列、三种尺寸、禁用单项或全部禁用',
  ),
  _PreviewPage(
    routeKey: 'radio',
    group: '表单输入',
    navTitle: 'Radio 单选框',
    title: 'Radio 单选框',
    summary: '单选框组件 — 支持受控/非受控、水平/垂直排列、三种尺寸和禁用项',
  ),
  _PreviewPage(
    routeKey: 'switch',
    group: '表单输入',
    navTitle: 'Switch 开关',
    title: 'Switch 开关',
    summary: '开关组件 — 支持受控 / 非受控、自定义文案、small 尺寸、loading 状态',
  ),
  _PreviewPage(
    routeKey: 'slider',
    group: '表单输入',
    navTitle: 'Slider 滑动输入',
    title: 'Slider 滑动输入',
    summary: '滑动输入组件 — 支持受控数值、范围、分段、禁用和标签显示',
  ),
  _PreviewPage(
    routeKey: 'rate',
    group: '表单输入',
    navTitle: 'Rate 评分',
    title: 'Rate 评分',
    summary: '评分组件 — 支持受控评分、默认评分、评分数量和禁用态',
  ),
  _PreviewPage(
    routeKey: 'segmented',
    group: '表单输入',
    navTitle: 'Segmented 分段',
    title: 'Segmented 分段控制',
    summary: '分段控制器 — 支持图标、禁用项、默认值和受控切换',
  ),
  _PreviewPage(
    routeKey: 'form',
    group: '表单输入',
    navTitle: 'Form 表单布局',
    title: 'Form 表单布局',
    summary:
        '表单布局组件 — 支持 vertical / horizontal / inline 三种排列、label 宽度、帮助文本和错误文本',
  ),
  _PreviewPage(
    routeKey: 'calendar',
    group: '数据录入',
    navTitle: 'Calendar 日历',
    title: 'Calendar 日历',
    summary: '日历组件 — 支持日期选择、月份切换、受控值和日期范围限制',
  ),
  _PreviewPage(
    routeKey: 'upload',
    group: '数据录入',
    navTitle: 'Upload 上传',
    title: 'Upload 上传',
    summary: '上传组件 — 展示上传入口、文件列表、进度、成功/失败状态和删除回调',
  ),
  _PreviewPage(
    routeKey: 'tree',
    group: '数据录入',
    navTitle: 'Tree 树形控件',
    title: 'Tree 树形控件',
    summary: '树形控件 — 支持层级节点、展开收起、选中项、禁用节点和图标',
  ),
  _PreviewPage(
    routeKey: 'table',
    group: '数据展示',
    navTitle: 'Table 表格',
    title: 'Table 表格',
    summary: '数据表格组件，支持斑马纹、边框、加载状态等常用功能',
  ),
  _PreviewPage(
    routeKey: 'descriptions',
    group: '数据展示',
    navTitle: 'Descriptions 描述列表',
    title: 'Descriptions 描述列表',
    summary: '描述列表组件 — 支持多列、span 合并、横向/纵向展示，用于详情页信息分组',
  ),
  _PreviewPage(
    routeKey: 'statistic',
    group: '数据展示',
    navTitle: 'Statistic 统计数值',
    title: 'Statistic 统计数值',
    summary: '统计数值组件 — 支持标题、前后缀、说明文本和强调色，用于仪表盘指标',
  ),
  _PreviewPage(
    routeKey: 'timeline',
    group: '数据展示',
    navTitle: 'Timeline 时间线',
    title: 'Timeline 时间线',
    summary: '时间线组件 — 支持状态色、图标、时间和描述，用于流程进展或日志展示',
  ),
  _PreviewPage(
    routeKey: 'codeblock',
    group: '数据展示',
    navTitle: 'CodeBlock 代码高亮',
    title: 'CodeBlock 代码高亮',
    summary: '代码高亮组件 — 语法高亮显示，支持自定义样式和类名',
  ),
  _PreviewPage(
    routeKey: 'tabs',
    group: '导航',
    navTitle: 'Tabs 标签页',
    title: 'Tabs 标签页',
    summary: '标签页组件 — 支持受控/非受控模式切换',
  ),
  _PreviewPage(
    routeKey: 'breadcrumb',
    group: '导航',
    navTitle: 'Breadcrumb 面包屑',
    title: 'Breadcrumb 面包屑',
    summary: '面包屑导航组件 — 支持可点击项、禁用项和自定义分隔符',
  ),
  _PreviewPage(
    routeKey: 'steps',
    group: '导航',
    navTitle: 'Steps 步骤条',
    title: 'Steps 步骤条',
    summary: '步骤条组件 — 支持横向/纵向、受控切换、错误态和完成态',
  ),
  _PreviewPage(
    routeKey: 'pagination',
    group: '导航',
    navTitle: 'Pagination 分页',
    title: 'Pagination 分页',
    summary: '分页器组件 — 支持当前页、总条数、页大小、禁用和可见页数控制',
  ),
  _PreviewPage(
    routeKey: 'alert',
    group: '反馈',
    navTitle: 'Alert 警告',
    title: 'Alert 警告提示',
    summary: '警告提示组件 — 支持标题、图标、四种状态和可关闭提示',
  ),
  _PreviewPage(
    routeKey: 'message',
    group: '反馈',
    navTitle: 'Message 轻提示',
    title: 'Message 轻提示',
    summary: '顶部轻提示组件 — 支持 info / success / warning / error 状态反馈',
  ),
  _PreviewPage(
    routeKey: 'tooltip',
    group: '反馈',
    navTitle: 'Tooltip 提示',
    title: 'Tooltip 提示',
    summary: '提示气泡组件 — 给按钮、图标或文字补充轻量说明',
  ),
  _PreviewPage(
    routeKey: 'progress',
    group: '反馈',
    navTitle: 'Progress 进度条',
    title: 'Progress 进度条',
    summary: '条纹进度条组件 — 支持受控进度、自定义高度、颜色和标签显示',
  ),
  _PreviewPage(
    routeKey: 'loading',
    group: '反馈',
    navTitle: 'Loading 加载',
    title: 'Loading 加载',
    summary: '动森风格小岛 Loading 动画组件，支持自定义样式和类名',
  ),
  _PreviewPage(
    routeKey: 'result',
    group: '反馈',
    navTitle: 'Result 结果页',
    title: 'Result 结果页',
    summary: '结果页组件 — 用于成功、警告、错误和信息反馈场景，可配置额外内容与操作区',
  ),
  _PreviewPage(
    routeKey: 'modal',
    group: '浮层',
    navTitle: 'Modal 弹窗',
    title: 'Modal 弹窗',
    summary: '模态弹窗组件 — SVG 有机形状裁切、支持标题、关闭按钮、自定义 Footer、ESC / 遮罩关闭',
  ),
  _PreviewPage(
    routeKey: 'popover',
    group: '浮层',
    navTitle: 'Popover 气泡卡片',
    title: 'Popover 气泡卡片',
    summary: '气泡卡片组件 — 支持 click / hover / manual 触发和上下左右定位',
  ),
  _PreviewPage(
    routeKey: 'dropdown',
    group: '浮层',
    navTitle: 'Dropdown 下拉菜单',
    title: 'Dropdown 下拉菜单',
    summary: '下拉菜单组件 — 复用 Popover 浮层能力，支持图标、禁用项、选中回调和点击后自动关闭',
  ),
  _PreviewPage(
    routeKey: 'drawer',
    group: '浮层',
    navTitle: 'Drawer 抽屉',
    title: 'Drawer 抽屉',
    summary: '抽屉组件 — 支持左右方向、标题、底部操作区和遮罩关闭',
  ),
  _PreviewPage(
    routeKey: 'confirm-dialog',
    group: '浮层',
    navTitle: 'ConfirmDialog 确认框',
    title: 'ConfirmDialog 确认框',
    summary: '确认框组件 — 基于 AnimalDialog 封装常见确认流程，支持危险操作样式和返回结果',
  ),
  _PreviewPage(
    routeKey: 'time',
    group: 'Animal 特色',
    navTitle: 'Time 时间',
    title: 'Time 时间',
    summary: '经典 HUD 风格的时间显示组件，实时更新时间',
  ),
  _PreviewPage(
    routeKey: 'phone',
    group: 'Animal 特色',
    navTitle: 'Phone 手机',
    title: 'Phone 手机',
    summary: '动森风格手机界面，包含对话框和背包功能',
  ),
  _PreviewPage(
    routeKey: 'cursor',
    group: 'Animal 特色',
    navTitle: 'Cursor 光标',
    title: 'Cursor 光标',
    summary: '光标组件 — 自定义手指光标，支持自定义尺寸、点击动画',
  ),
  _PreviewPage(
    routeKey: 'typewriter',
    group: 'Animal 特色',
    navTitle: 'Typewriter 打字机',
    title: 'Typewriter 打字机',
    summary: '打字机组件 — 按字符逐个显示文本，支持多行与 Widget 富内容，不改变原有样式',
  ),
  _PreviewPage(
    routeKey: 'footer',
    group: 'Animal 特色',
    navTitle: 'Footer 页脚',
    title: 'Footer 底部装饰',
    summary: '页面底部装饰图片，支持树和海两种类型',
  ),
];

const _fishOptions = [
  AnimalSelectOption(key: 'fish1', label: '鲈鱼'),
  AnimalSelectOption(key: 'fish2', label: '鲷鱼'),
  AnimalSelectOption(key: 'fish3', label: '草鱼'),
  AnimalSelectOption(key: 'fish4', label: '龙睛鱼'),
  AnimalSelectOption(key: 'fish5', label: '神仙鱼'),
];

const _fruitOptions = [
  AnimalSelectOption(key: 'fruit1', label: '草莓'),
  AnimalSelectOption(key: 'fruit2', label: '蓝莓'),
  AnimalSelectOption(key: 'fruit3', label: '桃子'),
  AnimalSelectOption(key: 'fruit4', label: '樱桃'),
  AnimalSelectOption(key: 'fruit5', label: '猕猴桃'),
];

const _islandShortOptions = [
  AnimalCheckboxOption(value: 'beach', label: Text('海滩')),
  AnimalCheckboxOption(value: 'forest', label: Text('森林')),
  AnimalCheckboxOption(value: 'garden', label: Text('花园')),
];

const _controlledTabs = [
  AnimalTabItem(
    key: 'tab1',
    label: Text('岛屿概况'),
    child: Text('这里是一座无人岛，环境优美，气候宜人。'),
  ),
  AnimalTabItem(
    key: 'tab2',
    label: Text('商店'),
    child: Text('狸然超市营业中！各种商品应有尽有。'),
  ),
  AnimalTabItem(
    key: 'tab3',
    label: Text('服务台'),
    child: Text('欢迎来到服务台！可以办理各种服务业务。'),
  ),
];

const _tableRows = <Map<String, Object>>[
  {
    'key': '1',
    'name': '豆狸',
    'age': 26,
    'island': '彩虹岛',
    'fruit': '苹果',
    'hobby': '音乐'
  },
  {
    'key': '2',
    'name': '粒狸',
    'age': 24,
    'island': '彩虹岛',
    'fruit': '橘子',
    'hobby': '运动'
  },
  {
    'key': '3',
    'name': '西施惠',
    'age': 28,
    'island': '好评岛',
    'fruit': '樱桃',
    'hobby': '唱歌'
  },
  {
    'key': '4',
    'name': '喻哥',
    'age': 30,
    'island': '无人岛',
    'fruit': '梨',
    'hobby': '钓鱼'
  },
  {
    'key': '5',
    'name': '小润',
    'age': 22,
    'island': '摸鱼岛',
    'fruit': '桃子',
    'hobby': '画画'
  },
];

const _treeNodes = [
  AnimalTreeNode<String>(
    value: 'plants',
    label: Text('植物图鉴'),
    icon: Icon(Icons.local_florist_rounded),
    children: [
      AnimalTreeNode<String>(value: 'rose', label: Text('玫瑰')),
      AnimalTreeNode<String>(value: 'cosmos', label: Text('波斯菊')),
      AnimalTreeNode<String>(value: 'tulip', label: Text('郁金香')),
    ],
  ),
  AnimalTreeNode<String>(
    value: 'animals',
    label: Text('岛民档案'),
    icon: Icon(Icons.badge_rounded),
    children: [
      AnimalTreeNode<String>(value: 'tom', label: Text('豆狸')),
      AnimalTreeNode<String>(value: 'timmy', label: Text('粒狸')),
      AnimalTreeNode<String>(
        value: 'locked',
        label: Text('未解锁区域'),
        disabled: true,
      ),
    ],
  ),
];

const _hobbyStyle = {
  '音乐': _TagStyle(background: Color(0x269370DB), foreground: Color(0xFF9370DB)),
  '运动': _TagStyle(background: Color(0x26FF8C00), foreground: Color(0xFFFF8C00)),
  '唱歌': _TagStyle(background: Color(0x26FF6347), foreground: Color(0xFFFF6347)),
  '钓鱼': _TagStyle(background: Color(0x261E90FF), foreground: Color(0xFF1E90FF)),
  '画画': _TagStyle(background: Color(0x26FF69B4), foreground: Color(0xFFFF69B4)),
};
