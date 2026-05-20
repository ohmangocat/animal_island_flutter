import 'dart:ui' as ui;

import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _githubUrl = 'https://github.com/ohmangocat/animal_island_flutter';
const _pubDevUrl = 'https://pub.dev/packages/animal_island_flutter';
const _packageVersion = '0.1.1';

void main() {
  runApp(const AnimalIslandDocsApp());
}

class AnimalIslandDocsApp extends StatelessWidget {
  const AnimalIslandDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimalTheme(
        child: const DocsHomePage(),
      ),
    );
  }
}

class DocsHomePage extends StatefulWidget {
  const DocsHomePage({super.key});

  @override
  State<DocsHomePage> createState() => _DocsHomePageState();
}

class _DocsHomePageState extends State<DocsHomePage> {
  var _activeIndex = -1;
  var _routeLoadingActive = false;
  var _routeLoadingMounted = false;
  var _switchChecked = false;
  var _fishValue = 'fish1';
  String? _flowerValue;
  String? _fruitValue;
  var _disabledSelectValue = 'flower2';
  var _islandChecks = <String>['beach', 'garden'];
  var _critterChecks = <String>[];
  var _tabsActiveKey = 'tab1';
  var _radioValue = 'apple';
  var _paginationPage = 2;
  var _progressValue = 0.64;
  var _stepsCurrent = 1;
  var _sliderValue = 46.0;
  var _rateValue = 4;
  var _segmentedValue = 'list';
  var _typewriterReplayKey = 0;
  var _loadingActive = true;
  var _tableStriped = true;
  var _tableLoading = false;

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    Widget body;
    Color backgroundColor;

    if (_activeIndex < 0) {
      backgroundColor = const Color(0xFF7DC395);
      body = _HomePage(onNavigate: _openHomeTarget);
    } else {
      final safeIndex = _activeIndex.clamp(0, pages.length - 1);
      final activePage = pages[safeIndex];
      backgroundColor = const Color(0xFFF8F4E8);
      body = SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Sidebar(
              pages: pages,
              activeIndex: safeIndex,
              onHome: () => setState(() => _activeIndex = -1),
              onSelect: (index) => setState(() => _activeIndex = index),
            ),
            Expanded(
              child: _DocsDetailShell(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _DocsHeader(onOpenDialog: _openWelcomeDialog),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 64),
                      sliver: SliverToBoxAdapter(
                        child: _DocArticle(activePage),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimalCursor(
        child: Stack(
          fit: StackFit.expand,
          children: [
            body,
            if (_routeLoadingMounted)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !_routeLoadingActive,
                  child: AnimalLoading(active: _routeLoadingActive),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<_DocPage> _buildPages() {
    return [
      _DocPage(
        routeKey: 'button',
        group: '基础组件',
        navTitle: 'Button 按钮',
        title: 'Button 按钮',
        summary:
            '按钮组件 — 支持 primary / dashed / text / link 等类型，danger / ghost / loading / disabled 状态，icon 图标，block 块级，三种尺寸',
        body: const _ButtonDoc(),
      ),
      _DocPage(
        routeKey: 'input',
        group: '基础组件',
        navTitle: 'Input 输入框',
        title: 'Input 输入框',
        summary:
            '输入框组件 — 支持三种尺寸、clearable 清除、prefix / suffix 前后缀、error / warning 校验状态、disabled 禁用',
        body: const _InputDoc(),
      ),
      _DocPage(
        routeKey: 'switch',
        group: '基础组件',
        navTitle: 'Switch 开关',
        title: 'Switch 开关',
        summary: '开关组件 — 支持受控 / 非受控、自定义文案、small 尺寸、loading 状态',
        body: _SwitchDoc(
          checked: _switchChecked,
          onChanged: (value) => setState(() => _switchChecked = value),
        ),
      ),
      _DocPage(
        routeKey: 'card',
        group: '基础组件',
        navTitle: 'Card 卡片',
        title: 'Card 卡片',
        summary: '卡片容器组件 — 支持 default / title 两种类型，13 种背景颜色',
        body: const _CardDoc(),
      ),
      _DocPage(
        routeKey: 'collapse',
        group: '基础组件',
        navTitle: 'Collapse 折叠面板',
        title: 'Collapse 折叠面板',
        summary: '折叠面板组件 — 支持展开/收起、默认展开、禁用状态',
        body: const _CollapseDoc(),
      ),
      _DocPage(
        routeKey: 'cursor',
        group: '基础组件',
        navTitle: 'Cursor 光标',
        title: 'Cursor 光标',
        summary: '光标组件 — 自定义手指光标，支持自定义尺寸、点击动画',
        body: const _CursorDoc(),
      ),
      _DocPage(
        routeKey: 'modal',
        group: '基础组件',
        navTitle: 'Modal 弹窗',
        title: 'Modal 弹窗',
        summary: '模态弹窗组件 — SVG 有机形状裁切、支持标题、关闭按钮、自定义 Footer、ESC / 遮罩关闭',
        body: _ModalDoc(
          onBasic: _openBasicModal,
          onTitle: _openTitleModal,
          onFooter: _openCustomFooterModal,
          onNoTypewriter: _openNoTypewriterModal,
        ),
      ),
      _DocPage(
        routeKey: 'typewriter',
        group: '基础组件',
        navTitle: 'Typewriter 打字机',
        title: 'Typewriter 打字机',
        summary: '打字机组件 — 按字符逐个显示文本，支持多行与 Widget 富内容，不改变原有样式',
        body: _TypewriterDoc(
          replayKey: _typewriterReplayKey,
          onReplay: () => setState(() => _typewriterReplayKey += 1),
        ),
      ),
      _DocPage(
        routeKey: 'divider-comp',
        group: '基础组件',
        navTitle: 'Divider 分割线',
        title: 'Divider 分割线',
        summary: '分割线组件 — 装饰性分割线',
        body: const _DividerDoc(),
      ),
      _DocPage(
        routeKey: 'icon',
        group: '基础组件',
        navTitle: 'Icon 图标',
        title: 'Icon 图标',
        summary: '图标组件 — 动森风格图标集，包含 10 个可爱图标，支持自定义尺寸',
        body: const _IconDoc(),
      ),
      _DocPage(
        routeKey: 'select',
        group: '基础组件',
        navTitle: 'Select 选择器',
        title: 'Select 选择器',
        summary: '下拉选择器组件 — 支持自定义选项列表，高亮当前选中项',
        body: _SelectDoc(
          fishValue: _fishValue,
          flowerValue: _flowerValue,
          fruitValue: _fruitValue,
          disabledValue: _disabledSelectValue,
          onFishChanged: (value) => setState(() => _fishValue = value),
          onFlowerChanged: (value) => setState(() => _flowerValue = value),
          onFruitChanged: (value) => setState(() => _fruitValue = value),
          onDisabledChanged: (value) =>
              setState(() => _disabledSelectValue = value),
        ),
      ),
      _DocPage(
        routeKey: 'checkbox',
        group: '基础组件',
        navTitle: 'Checkbox 多选框',
        title: 'Checkbox 多选框',
        summary: '多选框组件 — 支持受控/非受控、水平/垂直排列、三种尺寸、禁用单项或全部禁用',
        body: _CheckboxDoc(
          selectedIslands: _islandChecks,
          selectedCritters: _critterChecks,
          onIslandsChanged: (values) => setState(() => _islandChecks = values),
          onCrittersChanged: (values) =>
              setState(() => _critterChecks = values),
        ),
      ),
      _DocPage(
        routeKey: 'tabs',
        group: '基础组件',
        navTitle: 'Tabs 标签页',
        title: 'Tabs 标签页',
        summary: '标签页组件 — 支持受控/非受控模式切换',
        body: _TabsDoc(
          activeKey: _tabsActiveKey,
          onChanged: (value) => setState(() => _tabsActiveKey = value),
        ),
      ),
      _DocPage(
        routeKey: 'footer',
        group: '基础组件',
        navTitle: 'Footer 页脚',
        title: 'Footer 底部装饰',
        summary: '页面底部装饰图片，支持树和海两种类型',
        body: const _FooterDoc(),
      ),
      _DocPage(
        routeKey: 'codeblock',
        group: '基础组件',
        navTitle: 'CodeBlock 代码高亮',
        title: 'CodeBlock 代码高亮',
        summary: '代码高亮组件 — 语法高亮显示，支持自定义样式和类名',
        body: const _CodeBlockDoc(),
      ),
      _DocPage(
        routeKey: 'loading',
        group: '基础组件',
        navTitle: 'Loading 加载',
        title: 'Loading 加载',
        summary: '动森风格小岛 Loading 动画组件，支持自定义样式和类名',
        body: _LoadingDoc(
          active: _loadingActive,
          onToggle: () => setState(() => _loadingActive = !_loadingActive),
        ),
      ),
      _DocPage(
        routeKey: 'table',
        group: '基础组件',
        navTitle: 'Table 表格',
        title: 'Table 表格',
        summary: '数据表格组件，支持斑马纹、边框、加载状态等常用功能',
        body: _TableDoc(
          striped: _tableStriped,
          loading: _tableLoading,
          onToggleStriped: () => setState(() => _tableStriped = !_tableStriped),
          onLoading: _simulateTableLoading,
        ),
      ),
      _DocPage(
        routeKey: 'extended',
        group: '扩展组件',
        navTitle: 'Extended 扩展',
        title: 'Extended 扩展基础组件',
        summary:
            '扩展基础组件 — Radio / Tag / Badge / Tooltip / Message / Progress / Pagination / Empty',
        body: _ExtendedBasicsDoc(
          radioValue: _radioValue,
          paginationPage: _paginationPage,
          progressValue: _progressValue,
          onRadioChanged: (value) => setState(() => _radioValue = value),
          onPageChanged: (value) => setState(() => _paginationPage = value),
          onProgressChanged: (value) => setState(() => _progressValue = value),
        ),
      ),
      _DocPage(
        routeKey: 'radio',
        group: '扩展组件',
        navTitle: 'Radio 单选框',
        title: 'Radio 单选框',
        summary: '单选框组件 — 支持受控/非受控、水平/垂直排列、三种尺寸和禁用项',
        body: _RadioDoc(
          value: _radioValue,
          onChanged: (value) => setState(() => _radioValue = value),
        ),
      ),
      const _DocPage(
        routeKey: 'tag',
        group: '扩展组件',
        navTitle: 'Tag 标签',
        title: 'Tag 标签',
        summary: '标签组件 — 支持多种语义颜色、尺寸、图标和可关闭状态',
        body: _TagDoc(),
      ),
      const _DocPage(
        routeKey: 'badge',
        group: '扩展组件',
        navTitle: 'Badge 角标',
        title: 'Badge 角标',
        summary: '角标组件 — 支持数字、小红点、状态色、文本和数字上限',
        body: _BadgeDoc(),
      ),
      const _DocPage(
        routeKey: 'tooltip',
        group: '扩展组件',
        navTitle: 'Tooltip 提示',
        title: 'Tooltip 提示',
        summary: '提示气泡组件 — 给按钮、图标或文字补充轻量说明',
        body: _TooltipDoc(),
      ),
      const _DocPage(
        routeKey: 'message',
        group: '扩展组件',
        navTitle: 'Message 轻提示',
        title: 'Message 轻提示',
        summary: '顶部轻提示组件 — 支持 info / success / warning / error 状态反馈',
        body: _MessageDoc(),
      ),
      _DocPage(
        routeKey: 'progress',
        group: '扩展组件',
        navTitle: 'Progress 进度条',
        title: 'Progress 进度条',
        summary: '条纹进度条组件 — 支持受控进度、自定义高度、颜色和标签显示',
        body: _ProgressDoc(
          value: _progressValue,
          onChanged: (value) => setState(() => _progressValue = value),
        ),
      ),
      _DocPage(
        routeKey: 'pagination',
        group: '扩展组件',
        navTitle: 'Pagination 分页',
        title: 'Pagination 分页',
        summary: '分页器组件 — 支持当前页、总条数、页大小、禁用和可见页数控制',
        body: _PaginationDoc(
          current: _paginationPage,
          onChanged: (value) => setState(() => _paginationPage = value),
        ),
      ),
      const _DocPage(
        routeKey: 'empty',
        group: '扩展组件',
        navTitle: 'Empty 空状态',
        title: 'Empty 空状态',
        summary: '空状态组件 — 支持默认叶子图标、自定义图标、说明文案和行动按钮',
        body: _EmptyDoc(),
      ),
      _DocPage(
        routeKey: 'advanced',
        group: '进阶组件',
        navTitle: 'Advanced 进阶',
        title: 'Advanced 进阶交互组件',
        summary:
            '进阶交互组件 — Alert / Avatar / Breadcrumb / Steps / Slider / Rate / Segmented / Skeleton',
        body: _AdvancedBasicsDoc(
          stepsCurrent: _stepsCurrent,
          sliderValue: _sliderValue,
          rateValue: _rateValue,
          segmentedValue: _segmentedValue,
          onStepChanged: (value) => setState(() => _stepsCurrent = value),
          onSliderChanged: (value) => setState(() => _sliderValue = value),
          onRateChanged: (value) => setState(() => _rateValue = value),
          onSegmentedChanged: (value) =>
              setState(() => _segmentedValue = value),
        ),
      ),
      const _DocPage(
        routeKey: 'alert',
        group: '进阶组件',
        navTitle: 'Alert 警告',
        title: 'Alert 警告提示',
        summary: '警告提示组件 — 支持标题、图标、四种状态和可关闭提示',
        body: _AlertDoc(),
      ),
      const _DocPage(
        routeKey: 'avatar',
        group: '进阶组件',
        navTitle: 'Avatar 头像',
        title: 'Avatar 头像',
        summary: '头像组件 — 支持文字、图片、AnimalIcon、尺寸和圆形/方形形状',
        body: _AvatarDoc(),
      ),
      const _DocPage(
        routeKey: 'breadcrumb',
        group: '进阶组件',
        navTitle: 'Breadcrumb 面包屑',
        title: 'Breadcrumb 面包屑',
        summary: '面包屑导航组件 — 支持可点击项、禁用项和自定义分隔符',
        body: _BreadcrumbDoc(),
      ),
      _DocPage(
        routeKey: 'steps',
        group: '进阶组件',
        navTitle: 'Steps 步骤条',
        title: 'Steps 步骤条',
        summary: '步骤条组件 — 支持横向/纵向、受控切换、错误态和完成态',
        body: _StepsDoc(
          current: _stepsCurrent,
          onChanged: (value) => setState(() => _stepsCurrent = value),
        ),
      ),
      _DocPage(
        routeKey: 'slider',
        group: '进阶组件',
        navTitle: 'Slider 滑动输入',
        title: 'Slider 滑动输入',
        summary: '滑动输入组件 — 支持受控数值、范围、分段、禁用和标签显示',
        body: _SliderDoc(
          value: _sliderValue,
          onChanged: (value) => setState(() => _sliderValue = value),
        ),
      ),
      _DocPage(
        routeKey: 'rate',
        group: '进阶组件',
        navTitle: 'Rate 评分',
        title: 'Rate 评分',
        summary: '评分组件 — 支持受控评分、默认评分、评分数量和禁用态',
        body: _RateDoc(
          value: _rateValue,
          onChanged: (value) => setState(() => _rateValue = value),
        ),
      ),
      _DocPage(
        routeKey: 'segmented',
        group: '进阶组件',
        navTitle: 'Segmented 分段',
        title: 'Segmented 分段控制',
        summary: '分段控制器 — 支持图标、禁用项、默认值和受控切换',
        body: _SegmentedDoc(
          value: _segmentedValue,
          onChanged: (value) => setState(() => _segmentedValue = value),
        ),
      ),
      const _DocPage(
        routeKey: 'skeleton',
        group: '进阶组件',
        navTitle: 'Skeleton 骨架屏',
        title: 'Skeleton 骨架屏',
        summary: '骨架屏组件 — 支持行数、宽度、行高、动画和加载完成内容切换',
        body: _SkeletonDoc(),
      ),
      _DocPage(
        routeKey: 'time',
        group: '复杂组件',
        navTitle: 'Time 时间',
        title: 'Time 时间',
        summary: '经典 HUD 风格的时间显示组件，实时更新时间',
        body: const _TimeDoc(),
      ),
      _DocPage(
        routeKey: 'phone',
        group: '复杂组件',
        navTitle: 'Phone 手机',
        title: 'Phone 手机',
        summary: '动森风格手机界面，包含对话框和背包功能',
        body: const _PhoneDoc(),
      ),
    ];
  }

  Future<void> _simulateTableLoading() async {
    if (_tableLoading) {
      return;
    }
    setState(() => _tableLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _tableLoading = false);
    }
  }

  Future<void> _openHomeTarget(String key) async {
    final pages = _buildPages();
    final matchedIndex = pages.indexWhere((page) => page.routeKey == key);
    final index = matchedIndex < 0 ? 0 : matchedIndex;
    if (_activeIndex >= 0) {
      setState(() => _activeIndex = index);
      return;
    }
    setState(() {
      _routeLoadingMounted = true;
      _routeLoadingActive = true;
      _activeIndex = index;
    });
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    setState(() => _routeLoadingActive = false);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _routeLoadingMounted = false);
    }
  }

  void _openWelcomeDialog() {
    AnimalDialog.show<void>(
      context: context,
      title: const Text('博物馆捐赠'),
      child: const Text('是否愿意将这条鱼捐赠给博物馆？傅达会好好照顾它的！'),
    );
  }

  void _openBasicModal() {
    AnimalDialog.show<void>(
      context: context,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '钓到'),
                  TextSpan(
                    text: '石头',
                    style: TextStyle(color: Color(0xFFFD9303)),
                  ),
                  TextSpan(text: '了!'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text('竟然连这种都能钓起来...'),
          ],
        ),
      ),
    );
  }

  void _openTitleModal() {
    AnimalDialog.show<void>(
      context: context,
      title: const Text('博物馆捐赠'),
      child: const Text('是否愿意将这条鱼捐赠给博物馆呢？傅达会好好照顾它的！这可是博物馆的新展品哦~'),
    );
  }

  void _openCustomFooterModal() {
    AnimalDialog.show<void>(
      context: context,
      title: const Text('确认操作'),
      footer: Builder(
        builder: (dialogContext) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimalButton(
                onPressed: () => Navigator.of(dialogContext).maybePop(),
                child: const Text('再想想'),
              ),
              const SizedBox(width: 12),
              AnimalButton(
                type: AnimalButtonType.primary,
                danger: true,
                onPressed: () => Navigator.of(dialogContext).maybePop(),
                child: const Text('确认搬家'),
              ),
            ],
          );
        },
      ),
      child: const Text('确定要让这位居民搬走吗？这个操作不可撤销。'),
    );
  }

  void _openNoTypewriterModal() {
    AnimalDialog.show<void>(
      context: context,
      title: const Text('天气预报'),
      typewriter: false,
      child: const Text('明天天气晴朗，气温 20-28°C，适合外出活动！'),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late final AnimationController _backgroundController;
  var _showScrollHint = true;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 80),
    )..repeat();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 760;

    return Stack(
      children: [
        Positioned.fill(
          child: _ScrollingHomeBackground(animation: _backgroundController),
        ),
        Positioned.fill(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _HomeHero(
                  isMobile: isMobile,
                  onStart: () => widget.onNavigate('button'),
                ),
                _HomeSection(
                  title: '特性',
                  description: '为什么选择 animal_island_flutter',
                  isMobile: isMobile,
                  child: const _HomeFeatureGrid(),
                ),
                _HomeDivider(isMobile: isMobile),
                _HomeSection(
                  title: '组件一览',
                  description: '点击卡片查看详细文档和在线演示',
                  isMobile: isMobile,
                  child: _HomeComponentGrid(
                    onNavigate: widget.onNavigate,
                  ),
                ),
                _HomeDivider(isMobile: isMobile),
                _HomeSection(
                  title: '安装',
                  description: '在 Flutter 项目中添加依赖即可使用',
                  isMobile: isMobile,
                  child: const _HomeCodeBlock(
                    code: '# pubspec.yaml\n'
                        'dependencies:\n'
                        '  animal_island_flutter: ^$_packageVersion',
                  ),
                ),
                _HomeDivider(isMobile: isMobile),
                _HomeSection(
                  title: '快速上手',
                  description: '包裹 AnimalTheme 后即可使用组件',
                  isMobile: isMobile,
                  child: const _HomeCodeBlock(
                    code:
                        "import 'package:animal_island_flutter/animal_island_flutter.dart';\n"
                        "import 'package:flutter/material.dart';\n\n"
                        'class App extends StatelessWidget {\n'
                        '  const App({super.key});\n\n'
                        '  @override\n'
                        '  Widget build(BuildContext context) {\n'
                        '    return const AnimalTheme(\n'
                        "      child: AnimalButton(child: Text('开始')),\n"
                        '    );\n'
                        '  }\n'
                        '}',
                  ),
                ),
                _HomeDivider(isMobile: isMobile),
                _HomeSection(
                  title: '主题定制',
                  description: '通过 AnimalThemeData 覆盖 Flutter 设计令牌',
                  isMobile: isMobile,
                  child: const _HomeCodeBlock(
                    code: 'final theme = AnimalThemeData.fallback().copyWith(\n'
                        '  primaryColor: const Color(0xFF19C8B9),\n'
                        '  textColor: const Color(0xFF827157),\n'
                        "  fontFamily: 'Nunito',\n"
                        '  radius: 18,\n'
                        ');\n\n'
                        'AnimalTheme(data: theme, child: app);',
                  ),
                ),
                _HomeFooter(
                  isMobile: isMobile,
                  onDocs: () => widget.onNavigate('button'),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: IgnorePointer(
            ignoring: !_showScrollHint,
            child: AnimatedOpacity(
              opacity: _showScrollHint ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: const _ScrollHint(),
            ),
          ),
        ),
      ],
    );
  }

  void _handleScroll() {
    final shouldShow = _scrollController.offset <= 70;
    if (shouldShow != _showScrollHint) {
      setState(() => _showScrollHint = shouldShow);
    }
  }
}

class _ScrollingHomeBackground extends StatefulWidget {
  const _ScrollingHomeBackground({required this.animation});

  final Animation<double> animation;

  @override
  State<_ScrollingHomeBackground> createState() =>
      _ScrollingHomeBackgroundState();
}

class _ScrollingHomeBackgroundState extends State<_ScrollingHomeBackground> {
  ImageStream? _stream;
  late final ImageStreamListener _listener;
  ImageInfo? _imageInfo;

  @override
  void initState() {
    super.initState();
    _listener = ImageStreamListener(_handleImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void dispose() {
    _stream?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF7DC395),
      child: CustomPaint(
        painter: _HomeBackgroundPainter(
          image: _imageInfo?.image,
          progress: widget.animation,
        ),
      ),
    );
  }

  void _resolveImage() {
    final stream = const AssetImage(_DemoAssets.homeBg).resolve(
      createLocalImageConfiguration(context),
    );
    if (_stream?.key == stream.key) {
      return;
    }
    _stream?.removeListener(_listener);
    _stream = stream;
    _stream!.addListener(_listener);
  }

  void _handleImage(ImageInfo image, bool synchronousCall) {
    setState(() => _imageInfo = image);
  }
}

class _HomeBackgroundPainter extends CustomPainter {
  const _HomeBackgroundPainter({
    required this.image,
    required this.progress,
  }) : super(repaint: progress);

  final ui.Image? image;
  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFF7DC395), BlendMode.src);
    final bg = image;
    if (bg == null) {
      return;
    }

    final sourceSize = Size(bg.width.toDouble(), bg.height.toDouble());
    final scale =
        (size.shortestSide / sourceSize.shortestSide).clamp(0.55, 1.0);
    final imageSize = sourceSize * scale;
    final dx = -progress.value * imageSize.width;
    final dy = progress.value * imageSize.height;
    final paint = Paint();

    for (var x = dx % imageSize.width - imageSize.width;
        x < size.width + imageSize.width;
        x += imageSize.width) {
      for (var y = dy % imageSize.height - imageSize.height;
          y < size.height + imageSize.height;
          y += imageSize.height) {
        canvas.drawImageRect(
          bg,
          Offset.zero & sourceSize,
          Offset(x, y) & imageSize,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HomeBackgroundPainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.progress != progress;
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.isMobile,
    required this.onStart,
  });

  final bool isMobile;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final textBlock = Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: isMobile
                      ? 'Animal Island Flutter'
                      : 'Animal\nIsland Flutter'),
              const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: _VersionPill(),
                ),
              ),
            ],
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: theme
              .textStyle(
            size: isMobile ? 37 : 60,
            weight: FontWeight.w800,
            color: const Color(0xFFFFF9E6),
          )
              .copyWith(
            height: 1.1,
            shadows: const [
              Shadow(
                color: Color(0x66000000),
                offset: Offset(0, 4),
                blurRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SizedBox(
            height: isMobile ? 72 : 88,
            child: AnimalTypewriter(
              text: 'Animal风格的 Flutter 组件库，基于 Dart Widget 构建，让跨端应用充满温暖质感',
              speed: const Duration(milliseconds: 60),
              style: theme
                  .textStyle(
                    size: isMobile ? 14 : 17,
                    weight: FontWeight.w500,
                    color: const Color(0xFF7C5734),
                  )
                  .copyWith(height: 1.7),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Align(
          alignment: isMobile ? Alignment.center : Alignment.centerLeft,
          child: AnimalButton(
            type: AnimalButtonType.primary,
            size: AnimalButtonSize.large,
            onPressed: onStart,
            child: const Text('开始使用 ->'),
          ),
        ),
      ],
    );

    final logo = Image.asset(
      _DemoAssets.animalIcon,
      width: isMobile ? 180 : 320,
      height: isMobile ? 112 : 200,
      fit: BoxFit.contain,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 24 : 40,
          isMobile ? 56 : 60,
          isMobile ? 24 : 40,
          40,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: isMobile
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      logo,
                      const SizedBox(height: 32),
                      textBlock,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: textBlock),
                      const SizedBox(width: 150),
                      logo,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _VersionPill extends StatelessWidget {
  const _VersionPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F9F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'v$_packageVersion',
        style: TextStyle(
          color: Color(0xFF19C8B9),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.2,
          shadows: [],
        ),
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  const _HomeSection({
    required this.title,
    required this.description,
    required this.isMobile,
    required this.child,
  });

  final String title;
  final String description;
  final bool isMobile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 32 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textStyle(
                  size: 24,
                  weight: FontWeight.w700,
                  color: const Color(0xFF725D42),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textStyle(
                  size: 14,
                  weight: FontWeight.w500,
                  color: const Color(0xFF7C5734),
                ),
              ),
              const SizedBox(height: 32),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeFeatureGrid extends StatelessWidget {
  const _HomeFeatureGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 460
            ? 1
            : constraints.maxWidth < 720
                ? 2
                : 4;
        return _ResponsiveGrid(
          columns: columns,
          maxWidth: constraints.maxWidth,
          spacing: 16,
          children: [
            for (final feature in _homeFeatures) _FeatureCard(feature: feature),
          ],
        );
      },
    );
  }
}

class _HomeComponentGrid extends StatelessWidget {
  const _HomeComponentGrid({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 460
            ? 1
            : constraints.maxWidth < 700
                ? 2
                : constraints.maxWidth < 920
                    ? 3
                    : 4;
        return _ResponsiveGrid(
          columns: columns,
          maxWidth: constraints.maxWidth,
          spacing: 12,
          children: [
            for (final component in _homeComponents)
              _ComponentCard(
                component: component,
                onTap: () => onNavigate(component.key),
              ),
          ],
        );
      },
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({
    required this.columns,
    required this.maxWidth,
    required this.spacing,
    required this.children,
  });

  final int columns;
  final double maxWidth;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (final child in children)
          SizedBox(
            width: _itemWidth(context),
            child: child,
          ),
      ],
    );
  }

  double _itemWidth(BuildContext context) {
    return (maxWidth - spacing * (columns - 1)) / columns;
  }
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({required this.feature});

  final _FeatureInfo feature;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3DF),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF725D42).withValues(alpha: 0.15),
                    offset: const Offset(0, 8),
                    blurRadius: 24,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            AnimatedScale(
              scale: _hovered ? 1.1 : 1,
              duration: const Duration(milliseconds: 300),
              child: Transform.rotate(
                angle: _hovered ? -0.07 : 0,
                child: SvgPicture.asset(
                  widget.feature.icon,
                  width: 42,
                  height: 42,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.feature.title,
              textAlign: TextAlign.center,
              style: theme.textStyle(
                size: 15,
                weight: FontWeight.w700,
                color: const Color(0xFF725D42),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.feature.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme
                  .textStyle(
                    size: 13,
                    weight: FontWeight.w500,
                    color: const Color(0xFF7C5734),
                  )
                  .copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComponentCard extends StatefulWidget {
  const _ComponentCard({
    required this.component,
    required this.onTap,
  });

  final _ComponentInfo component;
  final VoidCallback onTap;

  @override
  State<_ComponentCard> createState() => _ComponentCardState();
}

class _ComponentCardState extends State<_ComponentCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F3DF),
            borderRadius: BorderRadius.circular(20),
            boxShadow: _hovered ? theme.shadowBase : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.component.name,
                style: theme.textStyle(
                  size: 15,
                  weight: FontWeight.w700,
                  color: const Color(0xFF725D42),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.component.description,
                style: theme
                    .textStyle(
                      size: 12,
                      weight: FontWeight.w500,
                      color: const Color(0xFF7C5734),
                    )
                    .copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCodeBlock extends StatelessWidget {
  const _HomeCodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: AnimalCodeBlock(
        code: code,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      ),
    );
  }
}

class _HomeDivider extends StatelessWidget {
  const _HomeDivider({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: isMobile ? MediaQuery.sizeOf(context).width * 0.9 : 800,
        child: const AnimalDivider(),
      ),
    );
  }
}

class _HomeFooter extends StatelessWidget {
  const _HomeFooter({
    required this.isMobile,
    required this.onDocs,
  });

  final bool isMobile;
  final VoidCallback onDocs;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final linkStyle = theme.textStyle(
      size: 13,
      weight: FontWeight.w500,
      color: const Color(0xFF7C5734),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 24 : 32,
      ).copyWith(top: 32),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 8,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onDocs,
                  child: Text('组件文档', style: linkStyle),
                ),
              ),
              Text('GitHub: $_githubUrl', style: linkStyle),
              Text('Pub.dev: $_pubDevUrl', style: linkStyle),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'MIT License · Flutter + Dart',
            style: theme.textStyle(
              size: 12,
              weight: FontWeight.w500,
              color: const Color(0xFF7C5734),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollHint extends StatefulWidget {
  const _ScrollHint();

  @override
  State<_ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<_ScrollHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _offset = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offset.value),
          child: Opacity(
            opacity: 0.7 + (1 - (_offset.value.abs() / 8)) * 0.3,
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '向下滑动',
            style: TextStyle(
              color: Color(0xFFFFF9E6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Color(0x4D000000),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          CustomPaint(
            size: const Size(16, 16),
            painter: _ArrowDownPainter(),
          ),
        ],
      ),
    );
  }
}

class _ArrowDownPainter extends CustomPainter {
  const _ArrowDownPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFF9E6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width / 2, size.height * 0.2)
      ..lineTo(size.width / 2, size.height * 0.8)
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width / 2, size.height * 0.8)
      ..lineTo(size.width * 0.8, size.height * 0.5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowDownPainter oldDelegate) => false;
}

class _DocsDetailShell extends StatelessWidget {
  const _DocsDetailShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _DocsTiledBackground(),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Image.asset(
              _DemoAssets.guideBgLine,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _DocsTiledBackground extends StatelessWidget {
  const _DocsTiledBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFF8F4E8),
        image: DecorationImage(
          image: AssetImage(_DemoAssets.contentBg),
          repeat: ImageRepeat.repeat,
          fit: BoxFit.none,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.pages,
    required this.activeIndex,
    required this.onHome,
    required this.onSelect,
  });

  final List<_DocPage> pages;
  final int activeIndex;
  final VoidCallback onHome;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return SizedBox(
      width: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFFF8F4E8)),
          SvgPicture.asset(
            _DemoAssets.menuBg,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFFE8E2D6))),
            ),
            child: Column(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onHome,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            _DemoAssets.nook1,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '集合啦！Animal',
                            style: theme.textStyle(
                              size: 15,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE8E2D6)),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                    children: [
                      for (final indexed in pages.indexed) ...[
                        if (indexed.$1 == 0 ||
                            pages[indexed.$1 - 1].group != indexed.$2.group)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xFFA0936E),
                                    height: 1,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    indexed.$2.group,
                                    style: theme.textStyle(
                                      size: 11,
                                      weight: FontWeight.w600,
                                      color: const Color(0xFFA0936E),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xFFA0936E),
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        _NavItem(
                          title: indexed.$2.navTitle,
                          active: indexed.$1 == activeIndex,
                          onTap: () => onSelect(indexed.$1),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.title,
    required this.active,
    required this.onTap,
  });

  final String title;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          padding: const EdgeInsets.only(left: 26, right: 16),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: widget.active
                ? const Color(0xFFB7C6E5)
                : (_hovered ? const Color(0xFFD6DFF0) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyle(
              size: 14,
              weight: FontWeight.w600,
              color: widget.active ? Colors.white : const Color(0xFF8A7B66),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocsHeader extends StatelessWidget {
  const _DocsHeader({required this.onOpenDialog});

  final VoidCallback onOpenDialog;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 32, 40, 28),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Animal Island Flutter',
                  style: theme.textStyle(size: 30, weight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  '基于 animal-island-ui demo 源码编排的 Flutter 组件库文档。',
                  style: theme.textStyle(
                    color: const Color(0xFF794F27),
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DocArticle extends StatelessWidget {
  const _DocArticle(this.page);

  final _DocPage page;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          page.title,
          style: theme.textStyle(
            size: 24,
            weight: FontWeight.w700,
            color: const Color(0xFF794F27),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: AnimalTypewriter(
            key: ValueKey(page.title),
            trigger: page.title,
            speed: const Duration(milliseconds: 30),
            text: page.summary,
            style: theme.textStyle(
              size: 14,
              weight: FontWeight.w500,
              color: const Color(0xFF794F27),
            ),
          ),
        ),
        page.body,
      ],
    );
  }
}

class _ComponentDoc extends StatelessWidget {
  const _ComponentDoc({
    required this.title,
    required this.tags,
    required this.sections,
    required this.code,
    required this.api,
  });

  final String title;
  final List<String> tags;
  final List<_DocSection> sections;
  final String code;
  final List<_ApiRow> api;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 36),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E2D6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ComponentTitle(title: title, tags: tags),
          for (final section in sections) section,
          _UsageCode(code: code),
          _ApiTable(rows: api),
        ],
      ),
    );
  }
}

class _ComponentTitle extends StatelessWidget {
  const _ComponentTitle({required this.title, required this.tags});

  final String title;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          title,
          style: theme.textStyle(
            size: 18,
            weight: FontWeight.w600,
            color: const Color(0xFF725D42),
          ),
        ),
        for (final tag in tags) _DocTag(tag),
      ],
    );
  }
}

class _DocTag extends StatelessWidget {
  const _DocTag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E8D8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: theme.textStyle(
          size: 10,
          weight: FontWeight.w500,
          color: const Color(0xFFA08060),
        ),
      ),
    );
  }
}

class _DocSection extends StatelessWidget {
  const _DocSection({
    required this.label,
    required this.child,
    this.box = _DemoBoxStyle.none,
  });

  final String label;
  final Widget child;
  final _DemoBoxStyle box;

  @override
  Widget build(BuildContext context) {
    final hasLabel = label.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasLabel) _DemoLabel(label) else const SizedBox(height: 16),
        _SectionBox(style: box, child: child),
      ],
    );
  }
}

class _DemoLabel extends StatelessWidget {
  const _DemoLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Text(
        text,
        style: theme.textStyle(
          size: 14,
          weight: FontWeight.w500,
          color: const Color(0xFFA0936E),
        ),
      ),
    );
  }
}

class _SectionBox extends StatelessWidget {
  const _SectionBox({required this.style, required this.child});

  final _DemoBoxStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (style == _DemoBoxStyle.none) {
      return child;
    }

    final dashed = style == _DemoBoxStyle.dashed;
    final radius = dashed ? 18.0 : 12.0;

    return CustomPaint(
      foregroundPainter: dashed
          ? _DashedBoxBorderPainter(
              color: const Color(0xFFE0D8C8),
              radius: radius,
            )
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dashed ? const Color(0xFFFAF8F2) : const Color(0xFFFAF8F3),
          borderRadius: BorderRadius.circular(radius),
          border: dashed ? null : Border.all(color: const Color(0xFFE8E2D6)),
        ),
        child: child,
      ),
    );
  }
}

class _DashedBoxBorderPainter extends CustomPainter {
  const _DashedBoxBorderPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ).deflate(0.5),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + 6).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBoxBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

class _UsageCode extends StatelessWidget {
  const _UsageCode({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DarkLabel('使用示例'),
          AnimalCodeBlock(
            code: code,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiTable extends StatelessWidget {
  const _ApiTable({required this.rows});

  final List<_ApiRow> rows;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DarkLabel('API'),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2B2118),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 820),
                child: Column(
                  children: [
                    _ApiTableRow(
                      background: const Color(0xFF3D3028),
                      cells: const ['属性', '说明', '类型', '默认值'],
                      styles: [
                        _apiHeaderStyle(theme),
                        _apiHeaderStyle(theme),
                        _apiHeaderStyle(theme),
                        _apiHeaderStyle(theme),
                      ],
                    ),
                    for (final row in rows) _ApiDataRow(row: row),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiDataRow extends StatelessWidget {
  const _ApiDataRow({required this.row});

  final _ApiRow row;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final base = theme.textStyle(
      size: 13,
      weight: FontWeight.w500,
      color: const Color(0xFFC8BBA8),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF3D3028))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ApiCell(
            width: 150,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: row.prop,
                    style: base.copyWith(color: const Color(0xFFE8C87A)),
                  ),
                  if (row.required)
                    TextSpan(
                      text: ' *',
                      style: base.copyWith(color: const Color(0xFFF0A870)),
                    ),
                ],
              ),
            ),
          ),
          _ApiCell(
            width: 270,
            child: Text(row.desc, style: base),
          ),
          _ApiCell(
            width: 280,
            child: Text(
              row.type,
              style: base.copyWith(color: const Color(0xFFD4A0E0)),
            ),
          ),
          _ApiCell(
            width: 120,
            child: Text(
              row.defaultVal,
              style: base.copyWith(color: const Color(0xFFA8D4A0)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiTableRow extends StatelessWidget {
  const _ApiTableRow({
    required this.cells,
    required this.styles,
    this.background,
  });

  final List<String> cells;
  final List<TextStyle> styles;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background ?? Colors.transparent,
      child: Row(
        children: [
          _ApiCell(width: 150, child: Text(cells[0], style: styles[0])),
          _ApiCell(width: 270, child: Text(cells[1], style: styles[1])),
          _ApiCell(width: 280, child: Text(cells[2], style: styles[2])),
          _ApiCell(width: 120, child: Text(cells[3], style: styles[3])),
        ],
      ),
    );
  }
}

class _ApiCell extends StatelessWidget {
  const _ApiCell({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: child,
      ),
    );
  }
}

TextStyle _apiHeaderStyle(AnimalThemeData theme) {
  return theme.textStyle(
    size: 13,
    weight: FontWeight.w600,
    color: const Color(0xFFE8D5BC),
  );
}

class _DarkLabel extends StatelessWidget {
  const _DarkLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFF3D3028),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: theme.textStyle(
          size: 14,
          weight: FontWeight.w600,
          color: const Color(0xFFE7E4E0),
        ),
      ),
    );
  }
}

class _DemoRow extends StatelessWidget {
  const _DemoRow({
    required this.children,
    this.spacing = 16,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
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

class _ButtonDoc extends StatelessWidget {
  const _ButtonDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Button',
      tags: const ['6 types'],
      sections: [
        _DocSection(
          label: 'type 按钮类型',
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: () {},
                child: const Text('Primary'),
              ),
              AnimalButton(onPressed: () {}, child: const Text('Default')),
              AnimalButton(
                type: AnimalButtonType.dashed,
                onPressed: () {},
                child: const Text('Dashed'),
              ),
              AnimalButton(
                type: AnimalButtonType.text,
                onPressed: () {},
                child: const Text('Text'),
              ),
              AnimalButton(
                type: AnimalButtonType.link,
                onPressed: () {},
                child: const Text('Link'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'danger / ghost / loading / disabled 状态',
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                danger: true,
                onPressed: () {},
                child: const Text('Danger'),
              ),
              AnimalButton(
                type: AnimalButtonType.primary,
                ghost: true,
                onPressed: () {},
                child: const Text('Ghost'),
              ),
              const AnimalButton(
                type: AnimalButtonType.primary,
                loading: true,
                child: Text('Loading'),
              ),
              AnimalButton(
                type: AnimalButtonType.primary,
                disabled: true,
                onPressed: () {},
                child: const Text('Disabled'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'size 尺寸',
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                size: AnimalButtonSize.small,
                onPressed: () {},
                child: const Text('Small'),
              ),
              AnimalButton(
                type: AnimalButtonType.primary,
                size: AnimalButtonSize.middle,
                onPressed: () {},
                child: const Text('Middle'),
              ),
              AnimalButton(
                type: AnimalButtonType.primary,
                size: AnimalButtonSize.large,
                onPressed: () {},
                child: const Text('Large'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'icon 图标按钮',
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                icon: const Icon(Icons.search_rounded),
                onPressed: () {},
                child: const Text('搜索'),
              ),
              AnimalButton(
                icon: const Icon(Icons.star_rounded, size: 16),
                onPressed: () {},
                child: const Text('收藏'),
              ),
              AnimalButton(
                type: AnimalButtonType.dashed,
                icon: const Text('＋'),
                onPressed: () {},
                child: const Text('新增'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'block 块级按钮',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: AnimalButton(
              type: AnimalButtonType.primary,
              block: true,
              onPressed: () {},
              child: const Text('Block Button'),
            ),
          ),
        ),
        _DocSection(
          label: 'danger 组合',
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                danger: true,
                onPressed: () {},
                child: const Text('Primary Danger'),
              ),
              AnimalButton(
                danger: true,
                onPressed: () {},
                child: const Text('Default Danger'),
              ),
              AnimalButton(
                type: AnimalButtonType.dashed,
                danger: true,
                onPressed: () {},
                child: const Text('Dashed Danger'),
              ),
              AnimalButton(
                type: AnimalButtonType.text,
                danger: true,
                onPressed: () {},
                child: const Text('Text Danger'),
              ),
              AnimalButton(
                type: AnimalButtonType.link,
                danger: true,
                onPressed: () {},
                child: const Text('Link Danger'),
              ),
            ],
          ),
        ),
      ],
      code: _buttonCode,
      api: _buttonApi,
    );
  }
}

class _InputDoc extends StatelessWidget {
  const _InputDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Input',
      tags: const ['3 sizes'],
      sections: const [
        _DocSection(
          label: 'shadow 阴影控制',
          child: _DemoColumn(
            children: [
              AnimalInput(hintText: 'No shadow (default)'),
              AnimalInput(hintText: 'With shadow', shadow: true),
            ],
          ),
        ),
        _DocSection(
          label: '基础用法',
          child: _DemoColumn(
            children: [
              AnimalInput(hintText: 'Basic input'),
              AnimalInput(
                hintText: 'With clear',
                allowClear: true,
                initialValue: 'Island',
              ),
              AnimalInput(
                hintText: 'Prefix & Suffix',
                prefix: Text('🔍'),
                suffix: Text('⏎'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'size 尺寸',
          child: _DemoColumn(
            children: [
              AnimalInput(hintText: 'Small', size: AnimalInputSize.small),
              AnimalInput(hintText: 'Middle (default)'),
              AnimalInput(hintText: 'Large', size: AnimalInputSize.large),
            ],
          ),
        ),
        _DocSection(
          label: 'status 校验状态',
          child: _DemoColumn(
            children: [
              AnimalInput(
                hintText: 'Error status',
                status: AnimalInputStatus.error,
              ),
              AnimalInput(
                hintText: 'Warning status',
                status: AnimalInputStatus.warning,
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'disabled 禁用',
          child: _DemoColumn(
            children: [
              AnimalInput(hintText: 'Disabled', enabled: false),
            ],
          ),
        ),
      ],
      code: _inputCode,
      api: _inputApi,
    );
  }
}

class _SwitchDoc extends StatelessWidget {
  const _SwitchDoc({required this.checked, required this.onChanged});

  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return _ComponentDoc(
      title: 'Switch',
      tags: const ['2 sizes'],
      sections: [
        _DocSection(
          label: '基础用法',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimalSwitch(value: checked, onChanged: onChanged),
              const SizedBox(width: 16),
              Text(
                checked ? 'ON' : 'OFF',
                style: theme.textStyle(size: 13),
              ),
            ],
          ),
        ),
        const _DocSection(
          label: 'checkedChildren / unCheckedChildren 自定义文案',
          child: _DemoRow(
            children: [
              AnimalSwitch(
                defaultValue: true,
                checkedChild: Text('开'),
                uncheckedChild: Text('关'),
              ),
            ],
          ),
        ),
        const _DocSection(
          label: 'size 尺寸',
          child: _DemoRow(
            children: [
              AnimalSwitch(defaultValue: true),
              AnimalSwitch(size: AnimalSwitchSize.small, defaultValue: true),
            ],
          ),
        ),
        const _DocSection(
          label: 'disabled / loading 状态',
          child: _DemoRow(
            children: [
              AnimalSwitch(disabled: true),
              AnimalSwitch(loading: true, defaultValue: true),
            ],
          ),
        ),
      ],
      code: _switchCode,
      api: _switchApi,
    );
  }
}

class _CardDoc extends StatelessWidget {
  const _CardDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Card',
      tags: const ['3 types', '13 colors'],
      sections: [
        const _DocSection(
          label: 'type="default"',
          child: _DemoRow(
            children: [
              AnimalCard(child: Text('基础卡片')),
              SizedBox(
                width: 560,
                child: AnimalCard(
                  child: Text(
                    '在Nintendo 3DS《Animal Island: New Leaf》和《Animal Island: Happy Home Designer》中製作的「我的設計」QR Code，以智慧型裝置讀取就能通過狸端機入口站下載至《集合啦！動物森友會》。',
                  ),
                ),
              ),
            ],
          ),
        ),
        const _DocSection(
          label: 'type="title"',
          child: _DemoRow(
            children: [
              AnimalCard(type: AnimalCardType.title, child: Text('Title标题卡片')),
              SizedBox(
                width: 360,
                child: AnimalCard(
                  type: AnimalCardType.title,
                  child: Text(
                    '欢迎来到无人岛！在Nintendo 3DS《Animal Island: New Leaf》和《Animal Island: Happy Home Designer》中製作的「我的設計」QR Code，以智慧型裝置讀取就能通過狸端機入口站下載至《集合啦！動物森友會》。',
                  ),
                ),
              ),
            ],
          ),
        ),
        const _DocSection(
          label: 'type="dashed"',
          child: _DemoRow(
            children: [
              AnimalCard(type: AnimalCardType.dashed, child: Text('虚线边框卡片')),
              SizedBox(
                width: 360,
                child: AnimalCard(
                  type: AnimalCardType.dashed,
                  child: Text('欢迎来到无人岛！虚线边框适合用于轻量提示或次要信息展示。'),
                ),
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'color — NookPhone 颜色',
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final item in _cardColors)
                    SizedBox(
                      width: 150,
                      child: AnimalCard(
                        color: item.color,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.en,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Opacity(
                              opacity: 0.85,
                              child: Text(
                                item.cn,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const _DocSection(
          label: 'color + type="title"',
          child: _DemoRow(
            children: [
              SizedBox(
                width: 240,
                child: AnimalCard(
                  type: AnimalCardType.title,
                  color: AnimalCardColor.appBlue,
                  child: _CardTitleSample(
                    title: '蓝色标题卡片',
                    subtitle: 'type="title" + color="app-blue"',
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: AnimalCard(
                  type: AnimalCardType.title,
                  color: AnimalCardColor.appGreen,
                  child: _CardTitleSample(
                    title: '绿色标题卡片',
                    subtitle: 'type="title" + color="app-green"',
                  ),
                ),
              ),
              SizedBox(
                width: 240,
                child: AnimalCard(
                  type: AnimalCardType.title,
                  color: AnimalCardColor.purple,
                  child: _CardTitleSample(
                    title: '紫色标题卡片',
                    subtitle: 'type="title" + color="purple"',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      code: _cardCode,
      api: _cardApi,
    );
  }
}

class _CardTitleSample extends StatelessWidget {
  const _CardTitleSample({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 6),
        Opacity(
          opacity: 0.85,
          child: Text(subtitle, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}

class _CollapseDoc extends StatelessWidget {
  const _CollapseDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Collapse',
      tags: ['FAQ'],
      sections: [
        _DocSection(
          label: '基础用法',
          child: SizedBox(
            width: 720,
            child: Column(
              children: [
                AnimalCollapse(
                  question: Text('1個島嶼可以登錄多少名用戶?'),
                  answer: Text('1座島嶼最多可以容納8位居民（用戶）。'),
                ),
                AnimalCollapse(
                  question: Text('可以多少人一起玩?'),
                  answer: Text('同住1個島的居民可以最多4人一起遊玩。透過通訊最多8人一起遊玩。'),
                ),
              ],
            ),
          ),
        ),
        _DocSection(
          label: 'defaultExpanded 默认展开',
          child: SizedBox(
            width: 720,
            child: AnimalCollapse(
              question: Text('这个问题默认展开'),
              answer: Text('答案已经展示出来了！可以点击收起。'),
              defaultExpanded: true,
            ),
          ),
        ),
        _DocSection(
          label: 'disabled 禁用状态',
          child: SizedBox(
            width: 720,
            child: AnimalCollapse(
              question: Text('这个问题已被禁用（无法展开）'),
              answer: Text('这段文字不应该被看到。'),
              disabled: true,
            ),
          ),
        ),
      ],
      code: _collapseCode,
      api: _collapseApi,
    );
  }
}

class _CursorDoc extends StatelessWidget {
  const _CursorDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Cursor',
      tags: ['光标'],
      sections: [
        _DocSection(
          label: 'Cursor 组件通过 CSS cursor 属性将子元素的鼠标光标替换为自定义手指图标，当前 Demo 全局已应用。',
          child: AnimalCursor(
            child: AnimalCard(child: Text('鼠标移入此区域将显示自定义光标')),
          ),
        ),
      ],
      code: _cursorCode,
      api: _cursorApi,
    );
  }
}

class _ModalDoc extends StatelessWidget {
  const _ModalDoc({
    required this.onBasic,
    required this.onTitle,
    required this.onFooter,
    required this.onNoTypewriter,
  });

  final VoidCallback onBasic;
  final VoidCallback onTitle;
  final VoidCallback onFooter;
  final VoidCallback onNoTypewriter;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Modal',
      tags: const ['弹窗'],
      sections: [
        _DocSection(
          label: '基础弹窗',
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: onBasic,
                child: const Text('基础 Modal'),
              ),
              AnimalButton(
                onPressed: onTitle,
                child: const Text('带标题 Modal'),
              ),
              AnimalButton(
                type: AnimalButtonType.dashed,
                onPressed: onFooter,
                child: const Text('自定义 Footer'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '关闭打字机效果',
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: onNoTypewriter,
                child: const Text('关闭打字机效果'),
              ),
            ],
          ),
        ),
      ],
      code: _modalCode,
      api: _modalApi,
    );
  }
}

class _TypewriterDoc extends StatelessWidget {
  const _TypewriterDoc({required this.replayKey, required this.onReplay});

  final int replayKey;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Typewriter',
      tags: const ['打字机'],
      sections: [
        _DocSection(
          label: '基础用法',
          box: _DemoBoxStyle.dashed,
          child: AnimalTypewriter(
            trigger: replayKey,
            text: '你好，欢迎来到动物岛！今天的天气真不错呢～',
          ),
        ),
        _DocSection(
          label: '保留多行与富内容 (速度 40ms)',
          box: _DemoBoxStyle.dashed,
          child: AnimalTypewriter(
            trigger: replayKey,
            speed: const Duration(milliseconds: 40),
            text: '第一行：钓到石头了！\n第二行：竟然连这种都能钓起来...\n第三行：继续加油吧！',
            style: const TextStyle(height: 1.8),
          ),
        ),
        _DocSection(
          label: '',
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: onReplay,
                child: const Text('重新播放'),
              ),
            ],
          ),
        ),
      ],
      code: _typewriterCode,
      api: _typewriterApi,
    );
  }
}

class _DividerDoc extends StatelessWidget {
  const _DividerDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Divider',
      tags: ['5 types'],
      sections: [
        _DocSection(
          label: 'line-brown',
          child: AnimalDivider(type: AnimalDividerType.lineBrown),
        ),
        _DocSection(
          label: 'line-teal',
          child: AnimalDivider(type: AnimalDividerType.lineTeal),
        ),
        _DocSection(
          label: 'line-white',
          child: ColoredBox(
            color: Color(0xFF333333),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: AnimalDivider(type: AnimalDividerType.lineWhite),
            ),
          ),
        ),
        _DocSection(
          label: 'line-yellow',
          child: AnimalDivider(type: AnimalDividerType.lineYellow),
        ),
        _DocSection(
          label: 'wave-yellow',
          child: AnimalDivider(type: AnimalDividerType.waveYellow),
        ),
      ],
      code: _dividerCode,
      api: _dividerApi,
    );
  }
}

class _IconDoc extends StatelessWidget {
  const _IconDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Icon',
      tags: const ['10 icons'],
      sections: [
        const _DocSection(
          label: '基础用法',
          child: _DemoRow(
            spacing: 20,
            children: [
              AnimalIcon(name: AnimalIconName.miles, size: 32),
              AnimalIcon(name: AnimalIconName.camera, size: 32),
              AnimalIcon(name: AnimalIconName.chat, size: 32),
              AnimalIcon(name: AnimalIconName.design, size: 32),
              AnimalIcon(name: AnimalIconName.map, size: 32),
            ],
          ),
        ),
        const _DocSection(
          label: 'size 尺寸',
          child: _DemoRow(
            spacing: 20,
            children: [
              AnimalIcon(name: AnimalIconName.miles, size: 16),
              AnimalIcon(name: AnimalIconName.miles, size: 24),
              AnimalIcon(name: AnimalIconName.miles, size: 32),
              AnimalIcon(name: AnimalIconName.miles, size: 48),
            ],
          ),
        ),
        const _DocSection(
          label: 'bounce 弹跳动画（鼠标悬停查看效果）',
          child: _DemoRow(
            spacing: 20,
            children: [
              AnimalIcon(name: AnimalIconName.miles, size: 32, bounce: true),
              AnimalIcon(name: AnimalIconName.camera, size: 32, bounce: true),
              AnimalIcon(name: AnimalIconName.chat, size: 32, bounce: true),
            ],
          ),
        ),
        _DocSection(
          label: '图标列表',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8E2D6)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (final indexed in animalIconList.indexed)
                  _IconListRow(
                    icon: indexed.$2,
                    last: indexed.$1 == animalIconList.length - 1,
                  ),
              ],
            ),
          ),
        ),
      ],
      code: _iconCode,
      api: _iconApi,
    );
  }
}

class _IconListRow extends StatelessWidget {
  const _IconListRow({required this.icon, required this.last});

  final AnimalIconInfo icon;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: last
              ? BorderSide.none
              : const BorderSide(color: Color(0xFFF0E8D8), width: 1),
        ),
      ),
      child: Row(
        children: [
          AnimalIcon(name: icon.name, size: 32),
          const SizedBox(width: 20),
          Text(
            icon.label,
            style: theme.textStyle(size: 14, color: const Color(0xFF725D42)),
          ),
          const Spacer(),
          Text(
            _iconCodeName(icon.name),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Color(0xFFA0936E),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectDoc extends StatelessWidget {
  const _SelectDoc({
    required this.fishValue,
    required this.flowerValue,
    required this.fruitValue,
    required this.disabledValue,
    required this.onFishChanged,
    required this.onFlowerChanged,
    required this.onFruitChanged,
    required this.onDisabledChanged,
  });

  final String fishValue;
  final String? flowerValue;
  final String? fruitValue;
  final String disabledValue;
  final ValueChanged<String> onFishChanged;
  final ValueChanged<String> onFlowerChanged;
  final ValueChanged<String> onFruitChanged;
  final ValueChanged<String> onDisabledChanged;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final selectedFish =
        _fishOptions.firstWhere((option) => option.key == fishValue).label;

    return _ComponentDoc(
      title: 'Select',
      tags: const ['基础用法'],
      sections: [
        _DocSection(
          label: '默认状态',
          box: _DemoBoxStyle.soft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '当前选中: '),
                    TextSpan(
                      text: selectedFish,
                      style: const TextStyle(
                        color: Color(0xFF19C8B9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                style: theme.textStyle(
                  size: 13,
                  color: const Color(0xFFA08060),
                ),
              ),
              const SizedBox(height: 8),
              AnimalSelect<String>(
                options: _fishOptions,
                value: fishValue,
                onChanged: onFishChanged,
              ),
            ],
          ),
        ),
        _DocSection(
          label: '自定义占位文本',
          box: _DemoBoxStyle.dashed,
          child: _DemoRow(
            children: [
              AnimalSelect<String>(
                options: _flowerOptions,
                value: flowerValue,
                onChanged: onFlowerChanged,
                placeholder: '请选择花朵',
              ),
              AnimalSelect<String>(
                options: _fruitOptions,
                value: fruitValue,
                onChanged: onFruitChanged,
                placeholder: '请选择水果',
              ),
            ],
          ),
        ),
        _DocSection(
          label: '禁用状态',
          box: _DemoBoxStyle.soft,
          child: AnimalSelect<String>(
            options: _flowerOptions,
            value: disabledValue,
            onChanged: onDisabledChanged,
            disabled: true,
          ),
        ),
      ],
      code: _selectCode,
      api: _selectApi,
    );
  }
}

class _CheckboxDoc extends StatelessWidget {
  const _CheckboxDoc({
    required this.selectedIslands,
    required this.selectedCritters,
    required this.onIslandsChanged,
    required this.onCrittersChanged,
  });

  final List<String> selectedIslands;
  final List<String> selectedCritters;
  final ValueChanged<List<String>> onIslandsChanged;
  final ValueChanged<List<String>> onCrittersChanged;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final selectedText = selectedIslands.isEmpty
        ? '无'
        : _islandOptions
            .where((option) => selectedIslands.contains(option.value))
            .map((option) => (option.label as Text).data ?? '')
            .join('、');

    return _ComponentDoc(
      title: 'Checkbox',
      tags: const ['基础用法'],
      sections: [
        _DocSection(
          label: '默认水平排列（受控）',
          box: _DemoBoxStyle.soft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '已选中: '),
                    TextSpan(
                      text: selectedText,
                      style: const TextStyle(
                        color: Color(0xFF19C8B9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                style: theme.textStyle(
                  size: 13,
                  color: const Color(0xFFA08060),
                ),
              ),
              const SizedBox(height: 8),
              AnimalCheckbox<String>(
                options: _islandOptions,
                value: selectedIslands,
                onChanged: onIslandsChanged,
              ),
            ],
          ),
        ),
        _DocSection(
          label: '垂直排列 + 含禁用选项',
          box: _DemoBoxStyle.soft,
          child: AnimalCheckbox<String>(
            options: _critterOptions,
            value: selectedCritters,
            direction: AnimalCheckboxDirection.vertical,
            onChanged: onCrittersChanged,
          ),
        ),
        const _DocSection(
          label: '小尺寸',
          box: _DemoBoxStyle.soft,
          child: AnimalCheckbox<String>(
            options: _islandOptions,
            defaultValue: ['forest'],
            size: AnimalCheckboxSize.small,
          ),
        ),
        const _DocSection(
          label: '中尺寸（默认）',
          box: _DemoBoxStyle.soft,
          child: AnimalCheckbox<String>(
            options: _islandOptions,
            defaultValue: ['beach'],
          ),
        ),
        const _DocSection(
          label: '大尺寸',
          box: _DemoBoxStyle.soft,
          child: AnimalCheckbox<String>(
            options: _islandShortOptions,
            defaultValue: ['beach'],
            size: AnimalCheckboxSize.large,
          ),
        ),
        const _DocSection(
          label: '全部禁用',
          box: _DemoBoxStyle.soft,
          child: AnimalCheckbox<String>(
            options: _islandOptions,
            defaultValue: ['garden', 'village'],
            disabled: true,
          ),
        ),
      ],
      code: _checkboxCode,
      api: _checkboxApi,
    );
  }
}

class _TabsDoc extends StatelessWidget {
  const _TabsDoc({required this.activeKey, required this.onChanged});

  final String activeKey;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selectedLabel =
        _controlledTabs.firstWhere((item) => item.key == activeKey).label;

    return _ComponentDoc(
      title: 'Tab',
      tags: const ['基础用法'],
      sections: [
        const _DocSection(
          label: 'shadow 阴影控制',
          child: _DemoRow(
            children: [
              SizedBox(width: 320, child: _FishTabs(shadow: true)),
              SizedBox(width: 320, child: _FishTabs(shadow: false)),
            ],
          ),
        ),
        const _DocSection(
          label: '非受控模式',
          box: _DemoBoxStyle.soft,
          child: AnimalTabs(
            defaultActiveKey: 'a',
            items: [
              AnimalTabItem(
                key: 'a',
                label: Text('鱼类'),
                child: Text('鲈鱼、鲷鱼、河童...'),
              ),
              AnimalTabItem(
                key: 'b',
                label: Text('昆虫'),
                child: Text('蝴蝶、瓢虫、蜻蜓...'),
              ),
              AnimalTabItem(
                key: 'c',
                label: Text('海洋生物'),
                child: Text('海星、珊瑚、小丑鱼...'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '受控模式',
          box: _DemoBoxStyle.soft,
          child: AnimalTabs(
            items: _controlledTabs,
            activeKey: activeKey,
            onChanged: onChanged,
          ),
        ),
        _DocSection(
          label: '当前选中: ${(selectedLabel as Text).data}',
          child: const SizedBox.shrink(),
        ),
        const _DocSection(
          label: 'leafAnimation 叶子动画控制',
          child: _DemoRow(
            children: [
              SizedBox(
                width: 320,
                child: _LeafTabs(
                    leafAnimation: true, caption: 'leafAnimation=true (默认)'),
              ),
              SizedBox(
                width: 320,
                child: _LeafTabs(
                    leafAnimation: false, caption: 'leafAnimation=false'),
              ),
            ],
          ),
        ),
      ],
      code: _tabsCode,
      api: _tabsApi,
    );
  }
}

class _FishTabs extends StatelessWidget {
  const _FishTabs({required this.shadow});

  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return AnimalTabs(
      shadow: shadow,
      defaultActiveKey: 'a',
      items: const [
        AnimalTabItem(key: 'a', label: Text('鱼类'), child: Text('鲈鱼、鲷鱼...')),
        AnimalTabItem(key: 'b', label: Text('昆虫'), child: Text('蝴蝶、瓢虫...')),
      ],
    );
  }
}

class _LeafTabs extends StatelessWidget {
  const _LeafTabs({required this.leafAnimation, required this.caption});

  final bool leafAnimation;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimalTabs(
          leafAnimation: leafAnimation,
          defaultActiveKey: 'a',
          items: const [
            AnimalTabItem(
              key: 'a',
              label: Text('鱼类'),
              child: Text('鲈鱼、鲷鱼...'),
            ),
            AnimalTabItem(
              key: 'b',
              label: Text('昆虫'),
              child: Text('蝴蝶、瓢虫...'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          caption,
          style: theme.textStyle(size: 12, color: const Color(0xFFA0936E)),
        ),
      ],
    );
  }
}

class _FooterDoc extends StatelessWidget {
  const _FooterDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Footer',
      tags: ['底部装饰'],
      sections: [
        _DocSection(
          label: 'Footer 组件 — 页面底部装饰图片，支持 sea（海）和 tree（树）两种类型。',
          child: SizedBox.shrink(),
        ),
        _DocSection(
          label: 'tree 类型（默认）',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: AnimalFooter(),
          ),
        ),
        _DocSection(
          label: 'sea 类型',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: AnimalFooter(type: AnimalFooterType.sea),
          ),
        ),
      ],
      code: _footerCode,
      api: _footerApi,
    );
  }
}

class _CodeBlockDoc extends StatelessWidget {
  const _CodeBlockDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'CodeBlock',
      tags: ['代码高亮'],
      sections: [
        _DocSection(
          label: '基础用法',
          box: _DemoBoxStyle.soft,
          child: AnimalCodeBlock(
            code:
                "import 'package:flutter/material.dart';\n\nconst AnimalButton(\n  type: AnimalButtonType.primary,\n  child: Text('按钮'),\n);",
          ),
        ),
        _DocSection(
          label: '自定义样式',
          box: _DemoBoxStyle.soft,
          child: AnimalCodeBlock(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            code:
                "const AnimalCodeBlock(\n  code: codeString,\n  padding: EdgeInsets.all(28),\n);",
          ),
        ),
      ],
      code: _codeBlockCode,
      api: _codeBlockApi,
    );
  }
}

class _LoadingDoc extends StatelessWidget {
  const _LoadingDoc({required this.active, required this.onToggle});

  final bool active;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return _ComponentDoc(
      title: 'Loading',
      tags: const ['加载动画'],
      sections: [
        _DocSection(
          label: '动森风格小岛 Loading 动画组件，带有漂浮的小岛、摇曳的树叶和游动的鱼。关闭时会从中间圆形透明扩散，露出底层内容。',
          child: AnimalButton(
            type: active
                ? AnimalButtonType.defaultType
                : AnimalButtonType.primary,
            onPressed: onToggle,
            child: Text(active ? '关闭 Loading' : '开启 Loading'),
          ),
        ),
        _DocSection(
          label: '',
          child: SizedBox(
            height: 800,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFD6A5),
                          Color(0xFFFDFFB6),
                          Color(0xFFCAFFBF),
                          Color(0xFF9BF6FF),
                          Color(0xFFA0C4FF),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '底层内容 · Underlying Content',
                        style: theme.textStyle(
                          size: 28,
                          weight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(child: AnimalLoading(active: active)),
              ],
            ),
          ),
        ),
      ],
      code: _loadingCode,
      api: _loadingApi,
    );
  }
}

class _TableDoc extends StatelessWidget {
  const _TableDoc({
    required this.striped,
    required this.loading,
    required this.onToggleStriped,
    required this.onLoading,
  });

  final bool striped;
  final bool loading;
  final VoidCallback onToggleStriped;
  final VoidCallback onLoading;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Table',
      tags: const ['表格'],
      sections: [
        const _DocSection(
          label: '数据表格组件，支持斑马纹、边框、加载状态等常用功能。',
          child: SizedBox.shrink(),
        ),
        _DocSection(
          label: '',
          child: _DemoRow(
            children: [
              AnimalButton(
                type: striped
                    ? AnimalButtonType.primary
                    : AnimalButtonType.defaultType,
                onPressed: onToggleStriped,
                child: Text('斑马纹 ${striped ? '✓' : '✗'}'),
              ),
              AnimalButton(
                type: AnimalButtonType.primary,
                disabled: loading,
                onPressed: loading ? null : onLoading,
                child: Text(loading ? '加载中...' : '模拟加载'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '',
          box: _DemoBoxStyle.soft,
          child: _IslandTable(striped: striped, loading: loading),
        ),
      ],
      code: _tableCode,
      api: _tableApi,
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

class _ExtendedBasicsDoc extends StatelessWidget {
  const _ExtendedBasicsDoc({
    required this.radioValue,
    required this.paginationPage,
    required this.progressValue,
    required this.onRadioChanged,
    required this.onPageChanged,
    required this.onProgressChanged,
  });

  final String radioValue;
  final int paginationPage;
  final double progressValue;
  final ValueChanged<String> onRadioChanged;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<double> onProgressChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Extended',
      tags: const ['扩展基础组件'],
      sections: [
        _DocSection(
          label: 'Radio 单选框',
          box: _DemoBoxStyle.soft,
          child: AnimalRadio<String>(
            value: radioValue,
            options: const [
              AnimalRadioOption(value: 'apple', label: Text('苹果岛')),
              AnimalRadioOption(value: 'peach', label: Text('桃子岛')),
              AnimalRadioOption(
                value: 'locked',
                label: Text('神秘岛'),
                disabled: true,
              ),
            ],
            onChanged: onRadioChanged,
          ),
        ),
        const _DocSection(
          label: 'Tag 标签',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalTag(color: AnimalTagColor.primary, child: Text('新组件')),
              AnimalTag(color: AnimalTagColor.success, child: Text('可用')),
              AnimalTag(color: AnimalTagColor.warning, child: Text('注意')),
              AnimalTag(
                  color: AnimalTagColor.danger,
                  closable: true,
                  child: Text('关闭')),
              AnimalTag(
                  color: AnimalTagColor.purple,
                  icon: Text('✦'),
                  child: Text('稀有')),
            ],
          ),
        ),
        const _DocSection(
          label: 'Badge 角标',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalBadge(
                  count: 5,
                  child: AnimalIcon(name: AnimalIconName.chat, size: 42)),
              AnimalBadge(
                  count: 120,
                  child: AnimalIcon(name: AnimalIconName.shopping, size: 42)),
              AnimalBadge(
                  dot: true,
                  status: AnimalBadgeStatus.success,
                  child: AnimalIcon(name: AnimalIconName.camera, size: 42)),
            ],
          ),
        ),
        const _DocSection(
          label: 'Tooltip 提示',
          box: _DemoBoxStyle.soft,
          child: AnimalTooltip(
            message: '今天也要整理背包哦',
            child: AnimalButton(
              type: AnimalButtonType.primary,
              child: Text('悬停查看'),
            ),
          ),
        ),
        _DocSection(
          label: 'Message 轻提示',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: () => AnimalMessage.success(
                  context,
                  const Text('保存成功'),
                ),
                child: const Text('Success'),
              ),
              AnimalButton(
                onPressed: () => AnimalMessage.warning(
                  context,
                  const Text('背包快满了'),
                ),
                child: const Text('Warning'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'Progress 进度条',
          box: _DemoBoxStyle.soft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimalProgress(value: progressValue),
              const SizedBox(height: 12),
              Slider(
                value: progressValue,
                activeColor: const Color(0xFF19C8B9),
                onChanged: onProgressChanged,
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'Pagination 分页',
          box: _DemoBoxStyle.soft,
          child: AnimalPagination(
            current: paginationPage,
            total: 86,
            onChanged: onPageChanged,
          ),
        ),
        _DocSection(
          label: 'Empty 空状态',
          box: _DemoBoxStyle.soft,
          child: AnimalEmpty(
            description: '今天还没有岛民记录',
            action: AnimalButton(
              type: AnimalButtonType.primary,
              onPressed: () {},
              child: const Text('添加记录'),
            ),
          ),
        ),
      ],
      code: _extendedBasicsCode,
      api: _extendedBasicsApi,
    );
  }
}

class _RadioDoc extends StatelessWidget {
  const _RadioDoc({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Radio',
      tags: const ['单选框', '受控'],
      sections: [
        _DocSection(
          label: '基础受控用法',
          box: _DemoBoxStyle.soft,
          child: AnimalRadio<String>(
            value: value,
            options: const [
              AnimalRadioOption(value: 'apple', label: Text('苹果岛')),
              AnimalRadioOption(value: 'peach', label: Text('桃子岛')),
              AnimalRadioOption(value: 'orange', label: Text('橘子岛')),
            ],
            onChanged: onChanged,
          ),
        ),
        const _DocSection(
          label: '尺寸与垂直排列',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalRadio<String>(
                size: AnimalRadioSize.small,
                defaultValue: 'small',
                options: [
                  AnimalRadioOption(value: 'small', label: Text('Small')),
                  AnimalRadioOption(value: 'middle', label: Text('Middle')),
                ],
              ),
              AnimalRadio<String>(
                direction: AnimalRadioDirection.vertical,
                defaultValue: 'morning',
                options: [
                  AnimalRadioOption(value: 'morning', label: Text('上午')),
                  AnimalRadioOption(value: 'night', label: Text('夜晚')),
                  AnimalRadioOption(
                    value: 'locked',
                    label: Text('未开放'),
                    disabled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        const _DocSection(
          label: '禁用全部',
          box: _DemoBoxStyle.soft,
          child: AnimalRadio<String>(
            disabled: true,
            defaultValue: 'one',
            options: [
              AnimalRadioOption(value: 'one', label: Text('一号岛')),
              AnimalRadioOption(value: 'two', label: Text('二号岛')),
            ],
          ),
        ),
        const _DocSection(
          label: '富内容选项',
          box: _DemoBoxStyle.soft,
          child: AnimalRadio<String>(
            defaultValue: 'camera',
            options: [
              AnimalRadioOption(
                value: 'camera',
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimalIcon(name: AnimalIconName.camera, size: 22),
                    SizedBox(width: 6),
                    Text('相机应用'),
                  ],
                ),
              ),
              AnimalRadioOption(
                value: 'map',
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimalIcon(name: AnimalIconName.map, size: 22),
                    SizedBox(width: 6),
                    Text('地图应用'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      code: _radioCode,
      api: _radioApi,
    );
  }
}

class _TagDoc extends StatelessWidget {
  const _TagDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Tag',
      tags: ['标签', '状态'],
      sections: [
        _DocSection(
          label: '颜色',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalTag(child: Text('Default')),
              AnimalTag(color: AnimalTagColor.primary, child: Text('Primary')),
              AnimalTag(color: AnimalTagColor.success, child: Text('Success')),
              AnimalTag(color: AnimalTagColor.warning, child: Text('Warning')),
              AnimalTag(color: AnimalTagColor.danger, child: Text('Danger')),
              AnimalTag(color: AnimalTagColor.blue, child: Text('Blue')),
              AnimalTag(color: AnimalTagColor.purple, child: Text('Purple')),
              AnimalTag(color: AnimalTagColor.brown, child: Text('Brown')),
            ],
          ),
        ),
        _DocSection(
          label: '尺寸、图标和可关闭',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalTag(size: AnimalTagSize.small, child: Text('Small')),
              AnimalTag(size: AnimalTagSize.large, child: Text('Large')),
              AnimalTag(
                color: AnimalTagColor.purple,
                icon: Text('✦'),
                child: Text('稀有'),
              ),
              AnimalTag(
                color: AnimalTagColor.danger,
                closable: true,
                child: Text('可关闭'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '组合成状态面板',
          box: _DemoBoxStyle.soft,
          child: AnimalCard(
            child: _DemoRow(
              spacing: 8,
              children: [
                AnimalTag(color: AnimalTagColor.primary, child: Text('岛民')),
                AnimalTag(color: AnimalTagColor.success, child: Text('在线')),
                AnimalTag(color: AnimalTagColor.warning, child: Text('访客')),
              ],
            ),
          ),
        ),
      ],
      code: _tagCode,
      api: _tagApi,
    );
  }
}

class _BadgeDoc extends StatelessWidget {
  const _BadgeDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Badge',
      tags: ['角标', '通知'],
      sections: [
        _DocSection(
          label: '数字角标',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalBadge(
                count: 5,
                child: AnimalIcon(name: AnimalIconName.chat, size: 44),
              ),
              AnimalBadge(
                count: 120,
                child: AnimalIcon(name: AnimalIconName.shopping, size: 44),
              ),
              AnimalBadge(
                count: 0,
                showZero: true,
                child: AnimalIcon(name: AnimalIconName.map, size: 44),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '小圆点、文本和偏移',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalBadge(
                dot: true,
                status: AnimalBadgeStatus.success,
                child: AnimalIcon(name: AnimalIconName.camera, size: 44),
              ),
              AnimalBadge(
                text: 'NEW',
                status: AnimalBadgeStatus.primary,
                child: AnimalIcon(name: AnimalIconName.diy, size: 44),
              ),
              AnimalBadge(
                count: 8,
                offset: Offset(6, 4),
                child: AnimalIcon(name: AnimalIconName.variant, size: 44),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '和头像组合',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalBadge(dot: true, child: AnimalAvatar(child: Text('狸'))),
              AnimalBadge(
                count: 12,
                child: AnimalAvatar(
                  icon: AnimalIconName.chat,
                  backgroundColor: Color(0xFFE6F9F6),
                ),
              ),
            ],
          ),
        ),
      ],
      code: _badgeCode,
      api: _badgeApi,
    );
  }
}

class _TooltipDoc extends StatelessWidget {
  const _TooltipDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Tooltip',
      tags: const ['提示', '方位'],
      sections: [
        const _DocSection(
          label: '基础提示',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalTooltip(
                message: '今天也要整理背包哦',
                child: AnimalButton(
                  type: AnimalButtonType.primary,
                  child: Text('悬停查看'),
                ),
              ),
              AnimalTooltip(
                message: '相机应用有新提示',
                preferBelow: true,
                child: AnimalIcon(name: AnimalIconName.camera, size: 42),
              ),
            ],
          ),
        ),
        const _DocSection(
          label: '上下左右位置',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalTooltip(
                message: '上方提示',
                placement: AnimalTooltipPlacement.top,
                child: AnimalButton(child: Text('Top')),
              ),
              AnimalTooltip(
                message: '右侧提示',
                placement: AnimalTooltipPlacement.right,
                child: AnimalButton(child: Text('Right')),
              ),
              AnimalTooltip(
                message: '下方提示',
                placement: AnimalTooltipPlacement.bottom,
                child: AnimalButton(child: Text('Bottom')),
              ),
              AnimalTooltip(
                message: '左侧提示',
                placement: AnimalTooltipPlacement.left,
                child: AnimalButton(child: Text('Left')),
              ),
            ],
          ),
        ),
      ],
      code: _tooltipCode,
      api: _tooltipApi,
    );
  }
}

class _MessageDoc extends StatelessWidget {
  const _MessageDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Message',
      tags: const ['反馈', 'Overlay'],
      sections: [
        _DocSection(
          label: '四种反馈',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: () =>
                    AnimalMessage.info(context, const Text('新的岛屿公告')),
                child: const Text('Info'),
              ),
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: () =>
                    AnimalMessage.success(context, const Text('保存成功')),
                child: const Text('Success'),
              ),
              AnimalButton(
                onPressed: () =>
                    AnimalMessage.warning(context, const Text('背包快满了')),
                child: const Text('Warning'),
              ),
              AnimalButton(
                danger: true,
                onPressed: () =>
                    AnimalMessage.error(context, const Text('操作失败')),
                child: const Text('Error'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '自定义显示时长',
          box: _DemoBoxStyle.soft,
          child: AnimalButton(
            type: AnimalButtonType.primary,
            onPressed: () => AnimalMessage.show(
              context,
              type: AnimalMessageType.info,
              duration: const Duration(seconds: 4),
              child: const Text('这条消息会停留 4 秒'),
            ),
            child: const Text('Custom duration'),
          ),
        ),
      ],
      code: _messageCode,
      api: _messageApi,
    );
  }
}

class _ProgressDoc extends StatelessWidget {
  const _ProgressDoc({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Progress',
      tags: const ['进度', '条纹'],
      sections: [
        _DocSection(
          label: '受控进度',
          box: _DemoBoxStyle.soft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimalProgress(value: value),
              const SizedBox(height: 12),
              Slider(
                value: value,
                activeColor: const Color(0xFF19C8B9),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        const _DocSection(
          label: '高度、颜色和无标签',
          box: _DemoBoxStyle.soft,
          child: Column(
            children: [
              AnimalProgress(value: 0.32, height: 10),
              SizedBox(height: 12),
              AnimalProgress(
                value: 0.82,
                color: Color(0xFFF5C31C),
                showLabel: false,
              ),
            ],
          ),
        ),
        const _DocSection(
          label: '组合在卡片中',
          box: _DemoBoxStyle.soft,
          child: AnimalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('岛屿建设进度'),
                SizedBox(height: 10),
                AnimalProgress(value: 0.72),
              ],
            ),
          ),
        ),
      ],
      code: _progressCode,
      api: _progressApi,
    );
  }
}

class _PaginationDoc extends StatelessWidget {
  const _PaginationDoc({required this.current, required this.onChanged});

  final int current;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Pagination',
      tags: const ['分页', '导航'],
      sections: [
        _DocSection(
          label: '基础分页',
          box: _DemoBoxStyle.soft,
          child: AnimalPagination(
            current: current,
            total: 86,
            onChanged: onChanged,
          ),
        ),
        _DocSection(
          label: '页大小、可见页数和禁用',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              AnimalPagination(
                current: 4,
                total: 160,
                pageSize: 20,
                maxVisiblePages: 7,
                onChanged: (_) {},
              ),
              AnimalPagination(
                current: 2,
                total: 40,
                disabled: true,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ],
      code: _paginationCode,
      api: _paginationApi,
    );
  }
}

class _EmptyDoc extends StatelessWidget {
  const _EmptyDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Empty',
      tags: const ['空状态'],
      sections: [
        _DocSection(
          label: '基础空状态',
          box: _DemoBoxStyle.soft,
          child: AnimalEmpty(
            description: '今天还没有岛民记录',
            action: AnimalButton(
              type: AnimalButtonType.primary,
              onPressed: () {},
              child: const Text('添加记录'),
            ),
          ),
        ),
        const _DocSection(
          label: '自定义图标',
          box: _DemoBoxStyle.soft,
          child: AnimalEmpty(
            description: '暂无聊天消息',
            icon: AnimalIcon(name: AnimalIconName.chat, size: 72),
          ),
        ),
        const _DocSection(
          label: '嵌入表格空状态',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 360,
            child: AnimalTable<Map<String, String>>(
              columns: [
                AnimalTableColumn(
                  title: Text('名称'),
                  cellBuilder: _emptyNameCell,
                ),
              ],
              rows: [],
              empty: AnimalEmpty(description: '列表里还没有收藏项'),
            ),
          ),
        ),
      ],
      code: _emptyCode,
      api: _emptyApi,
    );
  }
}

class _AdvancedBasicsDoc extends StatelessWidget {
  const _AdvancedBasicsDoc({
    required this.stepsCurrent,
    required this.sliderValue,
    required this.rateValue,
    required this.segmentedValue,
    required this.onStepChanged,
    required this.onSliderChanged,
    required this.onRateChanged,
    required this.onSegmentedChanged,
  });

  final int stepsCurrent;
  final double sliderValue;
  final int rateValue;
  final String segmentedValue;
  final ValueChanged<int> onStepChanged;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<int> onRateChanged;
  final ValueChanged<String> onSegmentedChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Advanced',
      tags: const ['进阶交互组件'],
      sections: [
        const _DocSection(
          label: 'Alert 警告提示',
          box: _DemoBoxStyle.soft,
          child: Column(
            children: [
              AnimalAlert(
                type: AnimalAlertType.info,
                title: Text('岛屿公告'),
                child: Text('今天商店会提前打烊，请记得早点采购。'),
              ),
              SizedBox(height: 12),
              AnimalAlert(
                type: AnimalAlertType.success,
                showIcon: true,
                child: Text('资料已经保存成功。'),
              ),
            ],
          ),
        ),
        const _DocSection(
          label: 'Avatar 头像',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalAvatar(child: Text('狸')),
              AnimalAvatar(
                size: AnimalAvatarSize.large,
                icon: AnimalIconName.chat,
              ),
              AnimalAvatar(
                size: AnimalAvatarSize.small,
                shape: AnimalAvatarShape.square,
                child: Text('岛'),
              ),
            ],
          ),
        ),
        const _DocSection(
          label: 'Breadcrumb 面包屑',
          box: _DemoBoxStyle.soft,
          child: AnimalBreadcrumb(
            items: [
              AnimalBreadcrumbItem(label: Text('首页')),
              AnimalBreadcrumbItem(label: Text('组件')),
              AnimalBreadcrumbItem(label: Text('Advanced')),
            ],
          ),
        ),
        _DocSection(
          label: 'Steps 步骤条',
          box: _DemoBoxStyle.soft,
          child: AnimalSteps(
            current: stepsCurrent,
            onChanged: onStepChanged,
            items: const [
              AnimalStepItem(title: Text('出发'), description: Text('整理背包')),
              AnimalStepItem(title: Text('采集'), description: Text('收集素材')),
              AnimalStepItem(title: Text('完成'), description: Text('回到服务处')),
            ],
          ),
        ),
        _DocSection(
          label: 'Slider 滑动输入',
          box: _DemoBoxStyle.soft,
          child: AnimalSlider(
            value: sliderValue,
            divisions: 10,
            onChanged: onSliderChanged,
          ),
        ),
        _DocSection(
          label: 'Rate 评分',
          box: _DemoBoxStyle.soft,
          child: AnimalRate(
            value: rateValue,
            onChanged: onRateChanged,
          ),
        ),
        _DocSection(
          label: 'Segmented 分段控制',
          box: _DemoBoxStyle.soft,
          child: AnimalSegmented<String>(
            value: segmentedValue,
            onChanged: onSegmentedChanged,
            options: const [
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
          ),
        ),
        const _DocSection(
          label: 'Skeleton 骨架屏',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 320,
            child: AnimalSkeleton(rows: 4),
          ),
        ),
      ],
      code: _advancedBasicsCode,
      api: _advancedBasicsApi,
    );
  }
}

class _AlertDoc extends StatelessWidget {
  const _AlertDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Alert',
      tags: const ['提示', '反馈'],
      sections: [
        const _DocSection(
          label: '四种状态',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              AnimalAlert(
                type: AnimalAlertType.info,
                title: Text('岛屿公告'),
                child: Text('今天商店会提前打烊，请记得早点采购。'),
              ),
              AnimalAlert(
                type: AnimalAlertType.success,
                child: Text('资料已经保存成功。'),
              ),
              AnimalAlert(
                type: AnimalAlertType.warning,
                child: Text('背包空间不足，请整理后继续。'),
              ),
              AnimalAlert(
                type: AnimalAlertType.error,
                child: Text('网络连接失败，请稍后再试。'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '可关闭与隐藏图标',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              AnimalAlert(
                type: AnimalAlertType.warning,
                closable: true,
                child: const Text('这条提示可以关闭。'),
              ),
              const AnimalAlert(
                showIcon: false,
                child: Text('没有图标时更适合短提示。'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '配合操作按钮',
          box: _DemoBoxStyle.soft,
          child: AnimalAlert(
            type: AnimalAlertType.info,
            title: const Text('需要确认'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('是否把当前设置应用到整座岛？'),
                const SizedBox(height: 10),
                AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () {},
                  child: const Text('应用设置'),
                ),
              ],
            ),
          ),
        ),
      ],
      code: _alertCode,
      api: _alertApi,
    );
  }
}

class _AvatarDoc extends StatelessWidget {
  const _AvatarDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Avatar',
      tags: ['头像', '展示'],
      sections: [
        _DocSection(
          label: '尺寸和内容',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalAvatar(size: AnimalAvatarSize.small, child: Text('豆')),
              AnimalAvatar(child: Text('狸')),
              AnimalAvatar(size: AnimalAvatarSize.large, child: Text('岛')),
              AnimalAvatar(
                size: AnimalAvatarSize.large,
                icon: AnimalIconName.camera,
              ),
            ],
          ),
        ),
        _DocSection(
          label: '方形、颜色和图片',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalAvatar(
                shape: AnimalAvatarShape.square,
                child: Text('方'),
              ),
              AnimalAvatar(
                backgroundColor: Color(0xFFE6F9F6),
                foregroundColor: Color(0xFF19C8B9),
                child: Text('青'),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '头像组和角标',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalBadge(dot: true, child: AnimalAvatar(child: Text('豆'))),
              AnimalAvatar(child: Text('粒')),
              AnimalAvatar(icon: AnimalIconName.camera),
              AnimalAvatar(shape: AnimalAvatarShape.square, child: Text('+3')),
            ],
          ),
        ),
      ],
      code: _avatarCode,
      api: _avatarApi,
    );
  }
}

class _BreadcrumbDoc extends StatelessWidget {
  const _BreadcrumbDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Breadcrumb',
      tags: const ['导航'],
      sections: [
        _DocSection(
          label: '基础用法',
          box: _DemoBoxStyle.soft,
          child: AnimalBreadcrumb(
            items: [
              AnimalBreadcrumbItem(
                label: const Text('首页'),
                onTap: () {},
              ),
              AnimalBreadcrumbItem(
                label: const Text('组件'),
                onTap: () {},
              ),
              const AnimalBreadcrumbItem(label: Text('Breadcrumb')),
            ],
          ),
        ),
        const _DocSection(
          label: '禁用项和自定义分隔符',
          box: _DemoBoxStyle.soft,
          child: AnimalBreadcrumb(
            separator: Text('>'),
            items: [
              AnimalBreadcrumbItem(label: Text('岛屿')),
              AnimalBreadcrumbItem(label: Text('居民'), disabled: true),
              AnimalBreadcrumbItem(label: Text('详情')),
            ],
          ),
        ),
        _DocSection(
          label: '可点击路径',
          box: _DemoBoxStyle.soft,
          child: AnimalBreadcrumb(
            items: [
              AnimalBreadcrumbItem(
                label: const Text('组件库'),
                onTap: () => AnimalMessage.info(context, const Text('回到组件库')),
              ),
              AnimalBreadcrumbItem(
                label: const Text('进阶组件'),
                onTap: () => AnimalMessage.info(context, const Text('进阶组件')),
              ),
              const AnimalBreadcrumbItem(label: Text('Breadcrumb')),
            ],
          ),
        ),
      ],
      code: _breadcrumbCode,
      api: _breadcrumbApi,
    );
  }
}

class _StepsDoc extends StatelessWidget {
  const _StepsDoc({required this.current, required this.onChanged});

  final int current;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Steps',
      tags: const ['步骤', '流程'],
      sections: [
        _DocSection(
          label: '横向受控步骤',
          box: _DemoBoxStyle.soft,
          child: AnimalSteps(
            current: current,
            onChanged: onChanged,
            items: const [
              AnimalStepItem(title: Text('出发'), description: Text('整理背包')),
              AnimalStepItem(title: Text('采集'), description: Text('收集素材')),
              AnimalStepItem(title: Text('完成'), description: Text('回到服务处')),
            ],
          ),
        ),
        const _DocSection(
          label: '纵向、错误态和禁用项',
          box: _DemoBoxStyle.soft,
          child: AnimalSteps(
            current: 1,
            direction: AnimalStepsDirection.vertical,
            items: [
              AnimalStepItem(title: Text('申请')),
              AnimalStepItem(
                title: Text('审核'),
                description: Text('材料缺失'),
                status: AnimalStepStatus.error,
              ),
              AnimalStepItem(title: Text('完成'), disabled: true),
            ],
          ),
        ),
        const _DocSection(
          label: '混合状态',
          box: _DemoBoxStyle.soft,
          child: AnimalSteps(
            current: 2,
            items: [
              AnimalStepItem(
                  title: Text('已完成'), status: AnimalStepStatus.finish),
              AnimalStepItem(
                  title: Text('进行中'), status: AnimalStepStatus.process),
              AnimalStepItem(title: Text('待处理')),
              AnimalStepItem(title: Text('异常'), status: AnimalStepStatus.error),
            ],
          ),
        ),
      ],
      code: _stepsCode,
      api: _stepsApi,
    );
  }
}

class _SliderDoc extends StatelessWidget {
  const _SliderDoc({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Slider',
      tags: const ['输入', '范围'],
      sections: [
        _DocSection(
          label: '受控滑动',
          box: _DemoBoxStyle.soft,
          child: AnimalSlider(
            value: value,
            divisions: 10,
            onChanged: onChanged,
          ),
        ),
        const _DocSection(
          label: '范围、无标签和禁用',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              AnimalSlider(
                defaultValue: 3,
                min: 1,
                max: 5,
                divisions: 4,
              ),
              AnimalSlider(
                defaultValue: 0.35,
                min: 0,
                max: 1,
                showLabel: false,
              ),
              AnimalSlider(defaultValue: 60, disabled: true),
            ],
          ),
        ),
        const _DocSection(
          label: '用于设置面板',
          box: _DemoBoxStyle.soft,
          child: AnimalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('背景音乐音量'),
                SizedBox(height: 8),
                AnimalSlider(defaultValue: 72, divisions: 8),
              ],
            ),
          ),
        ),
      ],
      code: _sliderCode,
      api: _sliderApi,
    );
  }
}

class _RateDoc extends StatelessWidget {
  const _RateDoc({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Rate',
      tags: const ['评分'],
      sections: [
        _DocSection(
          label: '受控评分',
          box: _DemoBoxStyle.soft,
          child: AnimalRate(
            value: value,
            onChanged: onChanged,
          ),
        ),
        const _DocSection(
          label: '默认值、数量和禁用',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              AnimalRate(defaultValue: 3),
              AnimalRate(defaultValue: 6, count: 8),
              AnimalRate(defaultValue: 4, disabled: true),
            ],
          ),
        ),
        const _DocSection(
          label: '评价卡片',
          box: _DemoBoxStyle.soft,
          child: AnimalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('今日岛屿满意度'),
                SizedBox(height: 8),
                AnimalRate(defaultValue: 5),
              ],
            ),
          ),
        ),
      ],
      code: _rateCode,
      api: _rateApi,
    );
  }
}

class _SegmentedDoc extends StatelessWidget {
  const _SegmentedDoc({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Segmented',
      tags: const ['分段', '切换'],
      sections: [
        _DocSection(
          label: '受控分段',
          box: _DemoBoxStyle.soft,
          child: AnimalSegmented<String>(
            value: value,
            onChanged: onChanged,
            options: const [
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
          ),
        ),
        const _DocSection(
          label: '默认值、禁用项和整体禁用',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              AnimalSegmented<String>(
                defaultValue: 'morning',
                options: [
                  AnimalSegmentedOption(value: 'morning', label: Text('上午')),
                  AnimalSegmentedOption(value: 'night', label: Text('夜晚')),
                  AnimalSegmentedOption(
                    value: 'locked',
                    label: Text('未开放'),
                    disabled: true,
                  ),
                ],
              ),
              AnimalSegmented<String>(
                disabled: true,
                defaultValue: 'a',
                options: [
                  AnimalSegmentedOption(value: 'a', label: Text('A')),
                  AnimalSegmentedOption(value: 'b', label: Text('B')),
                ],
              ),
            ],
          ),
        ),
        const _DocSection(
          label: '筛选工具条',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalSegmented<String>(
                defaultValue: 'all',
                options: [
                  AnimalSegmentedOption(value: 'all', label: Text('全部')),
                  AnimalSegmentedOption(value: 'new', label: Text('最新')),
                  AnimalSegmentedOption(value: 'hot', label: Text('热门')),
                ],
              ),
              AnimalButton(type: AnimalButtonType.primary, child: Text('筛选')),
            ],
          ),
        ),
      ],
      code: _segmentedCode,
      api: _segmentedApi,
    );
  }
}

class _SkeletonDoc extends StatelessWidget {
  const _SkeletonDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Skeleton',
      tags: ['加载', '占位'],
      sections: [
        _DocSection(
          label: '基础骨架屏',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 360,
            child: AnimalSkeleton(rows: 4),
          ),
        ),
        _DocSection(
          label: '宽度、行高和加载完成内容',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              AnimalSkeleton(rows: 2, width: 260, lineHeight: 18),
              AnimalSkeleton(
                active: false,
                child: AnimalAlert(
                  type: AnimalAlertType.success,
                  child: Text('加载完成'),
                ),
              ),
            ],
          ),
        ),
        _DocSection(
          label: '卡片加载占位',
          box: _DemoBoxStyle.soft,
          child: AnimalCard(
            child: AnimalSkeleton(rows: 4, lineHeight: 16),
          ),
        ),
      ],
      code: _skeletonCode,
      api: _skeletonApi,
    );
  }
}

class _TimeDoc extends StatelessWidget {
  const _TimeDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Time',
      tags: ['时间'],
      sections: [
        _DocSection(
          label: 'Time 组件 — 动森经典 HUD 风格的时间显示组件，实时更新时间，支持星期、日期和时间显示。',
          child: AnimalTime(),
        ),
      ],
      code: _timeCode,
      api: _timeApi,
    );
  }
}

class _PhoneDoc extends StatelessWidget {
  const _PhoneDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Phone',
      tags: ['手机'],
      sections: [
        _DocSection(
          label: 'Phone 组件 — 手机界面组件。',
          child: SizedBox(
            width: 316,
            height: 473,
            child: AnimalPhone(),
          ),
        ),
      ],
      code: _phoneCode,
      api: _phoneApi,
    );
  }
}

class _DocPage {
  const _DocPage({
    required this.routeKey,
    required this.group,
    required this.navTitle,
    required this.title,
    required this.summary,
    required this.body,
  });

  final String routeKey;
  final String group;
  final String navTitle;
  final String title;
  final String summary;
  final Widget body;
}

class _FeatureInfo {
  const _FeatureInfo({
    required this.icon,
    required this.title,
    required this.description,
  });

  final String icon;
  final String title;
  final String description;
}

class _ComponentInfo {
  const _ComponentInfo({
    required this.key,
    required this.name,
    required this.description,
  });

  final String key;
  final String name;
  final String description;
}

abstract final class _DemoAssets {
  static const animalIcon = 'assets/demo/img/animal_icon.png';
  static const contentBg = 'assets/demo/img/content_bg_pc.jpg';
  static const guideBgLine = 'assets/demo/img/guide-bg-line.webp';
  static const homeBg = 'assets/demo/img/home_bg.webp';
  static const menuBg = 'assets/demo/img/menu_bg.svg';
  static const nook1 = 'assets/demo/img/nook-phone/nook1.svg';
  static const shopping = 'assets/demo/img/nook-phone/Property-Shopping.svg';
  static const camera = 'assets/demo/img/nook-phone/Property-Camera.svg';
  static const recipes = 'assets/demo/img/nook-phone/Property-Recipes.svg';
}

class _ApiRow {
  const _ApiRow(
    this.prop,
    this.desc,
    this.type,
    this.defaultVal, {
    this.required = false,
  });

  final String prop;
  final String desc;
  final String type;
  final String defaultVal;
  final bool required;
}

Widget _emptyNameCell(
    BuildContext context, Map<String, String> row, int index) {
  return Text(row['name'] ?? '');
}

class _CardColorInfo {
  const _CardColorInfo(this.color, this.en, this.cn);

  final AnimalCardColor color;
  final String en;
  final String cn;
}

class _TagStyle {
  const _TagStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

enum _DemoBoxStyle { none, soft, dashed }

const _homeFeatures = [
  _FeatureInfo(
    icon: _DemoAssets.nook1,
    title: 'Animal风格',
    description: 'SVG 有机形状裁切，3D 按压按钮，温暖质朴的自然 UI 质感',
  ),
  _FeatureInfo(
    icon: _DemoAssets.shopping,
    title: '35 个组件',
    description:
        'Button / Input / Switch / Modal / Table / Radio / Alert / Avatar / Steps / Slider / Rate / Skeleton 等',
  ),
  _FeatureInfo(
    icon: _DemoAssets.camera,
    title: '主题定制',
    description: '通过 AnimalThemeData 覆盖颜色、字体、圆角、阴影等 Flutter 设计令牌',
  ),
  _FeatureInfo(
    icon: _DemoAssets.recipes,
    title: '开箱即用',
    description: '纯 Dart Widget API，支持 Flutter Web / Desktop / Mobile 示例运行',
  ),
];

const _homeComponents = [
  _ComponentInfo(
    key: 'button',
    name: 'Button',
    description: '5 种类型、3 种尺寸、加载/危险/幽灵模式',
  ),
  _ComponentInfo(key: 'input', name: 'Input', description: '前后缀、一键清空、校验状态'),
  _ComponentInfo(
    key: 'switch',
    name: 'Switch',
    description: '受控/非受控、自定义文案、加载状态',
  ),
  _ComponentInfo(
    key: 'checkbox',
    name: 'Checkbox',
    description: '多选框组件，支持水平/垂直排列',
  ),
  _ComponentInfo(key: 'select', name: 'Select', description: '下拉选择器，支持搜索和禁用'),
  _ComponentInfo(key: 'tabs', name: 'Tabs', description: '标签页组件，支持受控/非受控模式'),
  _ComponentInfo(key: 'modal', name: 'Modal', description: 'SVG 有机形状弹窗、ESC 关闭'),
  _ComponentInfo(
    key: 'typewriter',
    name: 'Typewriter',
    description: '逐字打字机效果，支持多行与富内容',
  ),
  _ComponentInfo(key: 'card', name: 'Card', description: '默认/标题两种卡片风格'),
  _ComponentInfo(
      key: 'collapse', name: 'Collapse', description: 'FAQ 折叠面板、平滑展开动画'),
  _ComponentInfo(key: 'cursor', name: 'Cursor', description: '自定义手指光标，支持多种尺寸'),
  _ComponentInfo(key: 'divider-comp', name: 'Divider', description: '装饰性水平分割线'),
  _ComponentInfo(key: 'icon', name: 'Icon', description: 'SVG 图标库'),
  _ComponentInfo(key: 'footer', name: 'Footer', description: '页脚组件'),
  _ComponentInfo(key: 'time', name: 'Time', description: '可爱风格时间显示'),
  _ComponentInfo(key: 'phone', name: 'Phone', description: 'Phone 模拟器'),
  _ComponentInfo(key: 'codeblock', name: 'CodeBlock', description: '代码语法高亮组件'),
  _ComponentInfo(key: 'loading', name: 'Loading', description: '动森风格小岛加载动画'),
  _ComponentInfo(key: 'table', name: 'Table', description: '斑马纹表格、加载与空状态'),
  _ComponentInfo(key: 'radio', name: 'Radio', description: '单选框组件，支持尺寸与排列方向'),
  _ComponentInfo(key: 'tag', name: 'Tag', description: '彩色标签、图标与可关闭状态'),
  _ComponentInfo(key: 'badge', name: 'Badge', description: '角标、数字上限与小红点'),
  _ComponentInfo(key: 'tooltip', name: 'Tooltip', description: '动森风提示气泡'),
  _ComponentInfo(key: 'message', name: 'Message', description: '顶部轻提示反馈'),
  _ComponentInfo(key: 'progress', name: 'Progress', description: '条纹进度条'),
  _ComponentInfo(key: 'pagination', name: 'Pagination', description: '分页器组件'),
  _ComponentInfo(key: 'empty', name: 'Empty', description: '空状态占位'),
  _ComponentInfo(key: 'alert', name: 'Alert', description: '警告提示、图标与可关闭状态'),
  _ComponentInfo(key: 'avatar', name: 'Avatar', description: '头像、文字、图片与图标占位'),
  _ComponentInfo(key: 'breadcrumb', name: 'Breadcrumb', description: '面包屑导航路径'),
  _ComponentInfo(key: 'steps', name: 'Steps', description: '横向/纵向步骤条'),
  _ComponentInfo(key: 'slider', name: 'Slider', description: '滑动输入、分段与数值展示'),
  _ComponentInfo(key: 'rate', name: 'Rate', description: '评分选择控件'),
  _ComponentInfo(key: 'segmented', name: 'Segmented', description: '分段控制器'),
  _ComponentInfo(key: 'skeleton', name: 'Skeleton', description: '骨架屏加载占位'),
];

const _cardColors = [
  _CardColorInfo(AnimalCardColor.defaultColor, 'Default', '默认奶油色'),
  _CardColorInfo(AnimalCardColor.appPink, 'App Pink', '应用粉'),
  _CardColorInfo(AnimalCardColor.purple, 'Purple', '紫色'),
  _CardColorInfo(AnimalCardColor.appBlue, 'App Blue', '应用蓝'),
  _CardColorInfo(AnimalCardColor.appYellow, 'App Yellow', '应用黄'),
  _CardColorInfo(AnimalCardColor.appOrange, 'App Orange', '应用橙'),
  _CardColorInfo(AnimalCardColor.appTeal, 'App Teal', '应用青'),
  _CardColorInfo(AnimalCardColor.appGreen, 'App Green', '应用绿'),
  _CardColorInfo(AnimalCardColor.appRed, 'App Red', '应用红'),
  _CardColorInfo(AnimalCardColor.limeGreen, 'Lime Green', '青柠绿'),
  _CardColorInfo(AnimalCardColor.yellowGreen, 'Yellow-Green', '黄绿色'),
  _CardColorInfo(AnimalCardColor.brown, 'Brown', '棕色'),
  _CardColorInfo(AnimalCardColor.warmPeachPink, 'Warm Peach Pink', '暖桃粉'),
];

const _fishOptions = [
  AnimalSelectOption(key: 'fish1', label: '鲈鱼'),
  AnimalSelectOption(key: 'fish2', label: '鲷鱼'),
  AnimalSelectOption(key: 'fish3', label: '草鱼'),
  AnimalSelectOption(key: 'fish4', label: '龙睛鱼'),
  AnimalSelectOption(key: 'fish5', label: '神仙鱼'),
];

const _flowerOptions = [
  AnimalSelectOption(key: 'flower1', label: '樱花'),
  AnimalSelectOption(key: 'flower2', label: '玫瑰'),
  AnimalSelectOption(key: 'flower3', label: '向日葵'),
  AnimalSelectOption(key: 'flower4', label: '薰衣草'),
  AnimalSelectOption(key: 'flower5', label: '郁金香'),
];

const _fruitOptions = [
  AnimalSelectOption(key: 'fruit1', label: '草莓'),
  AnimalSelectOption(key: 'fruit2', label: '蓝莓'),
  AnimalSelectOption(key: 'fruit3', label: '桃子'),
  AnimalSelectOption(key: 'fruit4', label: '樱桃'),
  AnimalSelectOption(key: 'fruit5', label: '猕猴桃'),
];

const _islandOptions = [
  AnimalCheckboxOption(value: 'beach', label: Text('🌊 海滩')),
  AnimalCheckboxOption(value: 'forest', label: Text('🌳 森林')),
  AnimalCheckboxOption(value: 'garden', label: Text('🌸 花园')),
  AnimalCheckboxOption(value: 'village', label: Text('🏡 村庄')),
];

const _islandShortOptions = [
  AnimalCheckboxOption(value: 'beach', label: Text('🌊 海滩')),
  AnimalCheckboxOption(value: 'forest', label: Text('🌳 森林')),
  AnimalCheckboxOption(value: 'garden', label: Text('🌸 花园')),
];

const _critterOptions = [
  AnimalCheckboxOption(value: 'butterfly', label: Text('🦋 蝴蝶')),
  AnimalCheckboxOption(value: 'bass', label: Text('🐟 鲈鱼')),
  AnimalCheckboxOption(value: 'crab', label: Text('🦀 螃蟹'), disabled: true),
  AnimalCheckboxOption(value: 'caterpillar', label: Text('🐛 毛毛虫')),
  AnimalCheckboxOption(value: 'jellyfish', label: Text('🌊 水母')),
];

const _controlledTabs = [
  AnimalTabItem(
    key: 'tab1',
    label: Text('岛屿概况'),
    child: Text('这里是一座无人岛，环境优美，气候宜人。\n可以钓鱼、捉虫、种植各种植物。'),
  ),
  AnimalTabItem(
    key: 'tab2',
    label: Text('商店'),
    child: Text('狸然超市营业中！\n各种商品应有尽有，价格实惠。'),
  ),
  AnimalTabItem(
    key: 'tab3',
    label: Text('服务台'),
    child: Text('欢迎来到服务台！\n可以办理各种服务业务。'),
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

const _hobbyStyle = {
  '音乐': _TagStyle(background: Color(0x269370DB), foreground: Color(0xFF9370DB)),
  '运动': _TagStyle(background: Color(0x26FF8C00), foreground: Color(0xFFFF8C00)),
  '唱歌': _TagStyle(background: Color(0x26FF6347), foreground: Color(0xFFFF6347)),
  '钓鱼': _TagStyle(background: Color(0x261E90FF), foreground: Color(0xFF1E90FF)),
  '画画': _TagStyle(background: Color(0x26FF69B4), foreground: Color(0xFFFF69B4)),
};

String _iconCodeName(AnimalIconName name) {
  return switch (name) {
    AnimalIconName.miles => 'icon-miles',
    AnimalIconName.camera => 'icon-camera',
    AnimalIconName.chat => 'icon-chat',
    AnimalIconName.critterpedia => 'icon-critterpedia',
    AnimalIconName.design => 'icon-design',
    AnimalIconName.diy => 'icon-diy',
    AnimalIconName.helicopter => 'icon-helicopter',
    AnimalIconName.map => 'icon-map',
    AnimalIconName.shopping => 'icon-shopping',
    AnimalIconName.variant => 'icon-variant',
  };
}

const _buttonApi = [
  _ApiRow('type', '按钮类型', 'AnimalButtonType', 'defaultType'),
  _ApiRow('size', '按钮尺寸', 'AnimalButtonSize', 'middle'),
  _ApiRow('danger', '是否危险按钮', 'bool', 'false'),
  _ApiRow('ghost', '是否幽灵按钮（透明背景）', 'bool', 'false'),
  _ApiRow('block', '是否块级按钮', 'bool', 'false'),
  _ApiRow('loading', '加载状态', 'bool', 'false'),
  _ApiRow('disabled', '禁用状态', 'bool', 'false'),
  _ApiRow('icon', '图标', 'Widget?', '-'),
  _ApiRow('child', '按钮内容', 'Widget', '-', required: true),
  _ApiRow('onPressed', '点击回调', 'VoidCallback?', '-'),
];

const _inputApi = [
  _ApiRow('size', '输入框尺寸', 'AnimalInputSize', 'middle'),
  _ApiRow('prefix', '前缀图标', 'Widget?', '-'),
  _ApiRow('suffix', '后缀图标', 'Widget?', '-'),
  _ApiRow('allowClear', '允许清除', 'bool', 'false'),
  _ApiRow('status', '校验状态', 'AnimalInputStatus?', '-'),
  _ApiRow('shadow', '是否显示阴影', 'bool', 'false'),
  _ApiRow('onChanged', '值变化回调', 'ValueChanged<String>?', '-'),
  _ApiRow('onClear', '清除回调', 'VoidCallback?', '-'),
  _ApiRow('controller', '文本控制器', 'TextEditingController?', '-'),
  _ApiRow('enabled', '是否启用', 'bool', 'true'),
];

const _switchApi = [
  _ApiRow('value', '是否选中（受控）', 'bool?', '-'),
  _ApiRow('defaultValue', '默认是否选中', 'bool', 'false'),
  _ApiRow('size', '尺寸', 'AnimalSwitchSize', 'normal'),
  _ApiRow('disabled', '禁用', 'bool', 'false'),
  _ApiRow('loading', '加载状态', 'bool', 'false'),
  _ApiRow('checkedChild', '选中时文案', 'Widget?', '-'),
  _ApiRow('uncheckedChild', '未选中时文案', 'Widget?', '-'),
  _ApiRow('onChanged', '变化回调', 'ValueChanged<bool>?', '-'),
];

const _cardApi = [
  _ApiRow('type', '卡片类型', 'AnimalCardType', 'defaultType'),
  _ApiRow('color', '背景颜色类型', 'AnimalCardColor', 'defaultColor'),
  _ApiRow('child', '自定义内容', 'Widget', '-', required: true),
  _ApiRow('padding', '自定义内边距', 'EdgeInsetsGeometry?', '-'),
  _ApiRow('onTap', '点击回调', 'VoidCallback?', '-'),
];

const _collapseApi = [
  _ApiRow('question', '问题标题', 'Widget', '-', required: true),
  _ApiRow('answer', '答案内容', 'Widget', '-', required: true),
  _ApiRow('defaultExpanded', '是否默认展开', 'bool', 'false'),
  _ApiRow('disabled', '是否禁用', 'bool', 'false'),
];

const _cursorApi = [
  _ApiRow('child', '子元素', 'Widget', '-', required: true),
  _ApiRow('cursor', '鼠标光标', 'MouseCursor', 'SystemMouseCursors.none'),
  _ApiRow('showImageCursor', '是否显示图片光标', 'bool', 'true'),
];

const _modalApi = [
  _ApiRow('context', '弹窗上下文', 'BuildContext', '-', required: true),
  _ApiRow('title', '标题', 'Widget?', '-'),
  _ApiRow('width', '宽度', 'double', '520'),
  _ApiRow('barrierDismissible', '点击遮罩关闭', 'bool', 'true'),
  _ApiRow('footer', '底部按钮区域', 'Widget?', '默认按钮'),
  _ApiRow('showFooter', '是否显示底部按钮', 'bool', 'true'),
  _ApiRow('onOk', '确认回调', 'VoidCallback?', '-'),
  _ApiRow('child', '自定义内容', 'Widget', '-', required: true),
  _ApiRow('typeSpeed', '打字机每字间隔', 'Duration', '80ms'),
  _ApiRow('typewriter', '是否启用打字机效果', 'bool', 'true'),
];

const _typewriterApi = [
  _ApiRow('text', '需要逐字显示的内容', 'String', '-', required: true),
  _ApiRow('speed', '每字间隔', 'Duration', '90ms'),
  _ApiRow('trigger', '值变化时重新播放', 'Object?', '-'),
  _ApiRow('autoPlay', '是否自动从头开始播放', 'bool', 'true'),
  _ApiRow('style', '文本样式', 'TextStyle?', '-'),
  _ApiRow('onDone', '播放完成回调', 'VoidCallback?', '-'),
];

const _dividerApi = [
  _ApiRow('type', '分隔线类型', 'AnimalDividerType', 'lineBrown'),
  _ApiRow('height', '分隔线高度', 'double', '12'),
];

const _iconApi = [
  _ApiRow('name', '图标名称', 'AnimalIconName', '-', required: true),
  _ApiRow('size', '图标尺寸', 'double', '24'),
  _ApiRow('bounce', '弹跳动画', 'bool', 'false'),
];

const _selectApi = [
  _ApiRow('options', '选项列表', 'List<AnimalSelectOption<T>>', '-',
      required: true),
  _ApiRow('value', '当前选中值', 'T?', '-', required: true),
  _ApiRow('onChanged', '选中变化回调', 'ValueChanged<T>', '-', required: true),
  _ApiRow('placeholder', '占位文本', 'String', '请选择'),
  _ApiRow('disabled', '禁用状态', 'bool', 'false'),
  _ApiRow('minWidth', '触发器最小宽度', 'double', '140'),
];

const _checkboxApi = [
  _ApiRow('options', '选项列表', 'List<AnimalCheckboxOption<T>>', '-',
      required: true),
  _ApiRow('value', '受控选中值列表', 'List<T>?', '-'),
  _ApiRow('defaultValue', '默认选中值列表', 'List<T>', '[]'),
  _ApiRow('size', '尺寸', 'AnimalCheckboxSize', 'middle'),
  _ApiRow('disabled', '禁用全部选项', 'bool', 'false'),
  _ApiRow('direction', '排列方向', 'AnimalCheckboxDirection', 'horizontal'),
  _ApiRow('onChanged', '选中值变化回调', 'ValueChanged<List<T>>?', '-'),
];

const _tabsApi = [
  _ApiRow('items', '标签页配置列表', 'List<AnimalTabItem>', '-', required: true),
  _ApiRow('defaultActiveKey', '默认激活的标签', 'String?', '第一个标签'),
  _ApiRow('activeKey', '受控模式当前激活标签', 'String?', '-'),
  _ApiRow('onChanged', '标签切换回调', 'ValueChanged<String>?', '-'),
  _ApiRow('shadow', '是否显示选中状态阴影', 'bool', 'true'),
  _ApiRow('leafAnimation', '是否启用叶子动画', 'bool', 'true'),
];

const _footerApi = [
  _ApiRow('type', 'Footer 类型', 'AnimalFooterType', 'tree'),
  _ApiRow('height', '自定义显示高度', 'double?', '80'),
];

const _codeBlockApi = [
  _ApiRow('code', '代码字符串', 'String', '-', required: true),
  _ApiRow('padding', '自定义内边距', 'EdgeInsetsGeometry', '24x20'),
];

const _loadingApi = [
  _ApiRow('active', '是否显示加载动画', 'bool', 'true'),
  _ApiRow('size', '辅助 loading 尺寸', 'double', '28'),
  _ApiRow('strokeWidth', '辅助 loading 线宽', 'double', '3'),
  _ApiRow('style', '加载样式', 'AnimalLoadingStyle', 'island'),
];

const _tableApi = [
  _ApiRow('columns', '表格列配置', 'List<AnimalTableColumn<T>>', '[]'),
  _ApiRow('rows', '表格数据源', 'List<T>', '[]'),
  _ApiRow('striped', '是否显示斑马纹', 'bool', 'true'),
  _ApiRow('showHeader', '是否显示表头', 'bool', 'true'),
  _ApiRow('loading', '加载状态', 'bool', 'false'),
  _ApiRow('emptyText', '空数据显示文本', 'String?', '暂无数据'),
  _ApiRow('maxHeight', '表格最大高度', 'double?', '-'),
  _ApiRow('onRowTap', '行点击回调', 'void Function(T row, int index)?', '-'),
];

const _extendedBasicsApi = [
  _ApiRow('AnimalRadio.options', '单选项列表', 'List<AnimalRadioOption<T>>', '-',
      required: true),
  _ApiRow('AnimalRadio.value', '受控选中值', 'T?', '-'),
  _ApiRow('AnimalRadio.defaultValue', '默认选中值', 'T?', '-'),
  _ApiRow('AnimalTag.color', '标签颜色', 'AnimalTagColor', 'defaultColor'),
  _ApiRow('AnimalTag.closable', '是否显示关闭按钮', 'bool', 'false'),
  _ApiRow('AnimalBadge.count', '数字角标', 'int?', '-'),
  _ApiRow('AnimalBadge.dot', '小圆点模式', 'bool', 'false'),
  _ApiRow('AnimalTooltip.message', '提示文本', 'String', '-', required: true),
  _ApiRow('AnimalProgress.value', '进度比例 0..1', 'double', '-', required: true),
  _ApiRow('AnimalPagination.current', '当前页', 'int', '-', required: true),
  _ApiRow('AnimalPagination.total', '总条数', 'int', '-', required: true),
  _ApiRow('AnimalEmpty.description', '空状态文案', 'String', '暂无数据'),
];

const _advancedBasicsApi = [
  _ApiRow('AnimalAlert.type', '提示类型', 'AnimalAlertType', 'info'),
  _ApiRow('AnimalAlert.closable', '是否可关闭', 'bool', 'false'),
  _ApiRow('AnimalAvatar.size', '头像尺寸', 'AnimalAvatarSize', 'middle'),
  _ApiRow('AnimalAvatar.shape', '头像形状', 'AnimalAvatarShape', 'circle'),
  _ApiRow('AnimalBreadcrumb.items', '面包屑项', 'List<AnimalBreadcrumbItem>', '-',
      required: true),
  _ApiRow('AnimalSteps.items', '步骤项', 'List<AnimalStepItem>', '-',
      required: true),
  _ApiRow('AnimalSteps.current', '当前步骤索引', 'int', '0'),
  _ApiRow('AnimalSlider.value', '受控数值', 'double?', '-'),
  _ApiRow('AnimalSlider.divisions', '分段数量', 'int?', '-'),
  _ApiRow('AnimalRate.value', '受控评分', 'int?', '-'),
  _ApiRow(
      'AnimalSegmented.options', '分段选项', 'List<AnimalSegmentedOption<T>>', '-',
      required: true),
  _ApiRow('AnimalSkeleton.active', '是否显示骨架屏', 'bool', 'true'),
];

const _radioApi = [
  _ApiRow('options', '单选项列表', 'List<AnimalRadioOption<T>>', '-',
      required: true),
  _ApiRow('value', '受控选中值', 'T?', '-'),
  _ApiRow('defaultValue', '默认选中值', 'T?', '-'),
  _ApiRow('size', '尺寸', 'AnimalRadioSize', 'middle'),
  _ApiRow('disabled', '是否禁用全部', 'bool', 'false'),
  _ApiRow('direction', '排列方向', 'AnimalRadioDirection', 'horizontal'),
  _ApiRow('onChanged', '选中变化回调', 'ValueChanged<T>?', '-'),
];

const _tagApi = [
  _ApiRow('child', '标签内容', 'Widget', '-', required: true),
  _ApiRow('color', '标签颜色', 'AnimalTagColor', 'defaultColor'),
  _ApiRow('size', '标签尺寸', 'AnimalTagSize', 'middle'),
  _ApiRow('closable', '是否显示关闭按钮', 'bool', 'false'),
  _ApiRow('onClose', '关闭回调', 'VoidCallback?', '-'),
  _ApiRow('icon', '前置图标', 'Widget?', '-'),
];

const _badgeApi = [
  _ApiRow('child', '被包裹的内容', 'Widget?', '-'),
  _ApiRow('count', '数字角标', 'int?', '-'),
  _ApiRow('text', '文本角标', 'String?', '-'),
  _ApiRow('dot', '小圆点模式', 'bool', 'false'),
  _ApiRow('showZero', '是否显示 0', 'bool', 'false'),
  _ApiRow('maxCount', '最大数字', 'int', '99'),
  _ApiRow('status', '状态色', 'AnimalBadgeStatus', 'danger'),
  _ApiRow('offset', '偏移量', 'Offset', 'Offset.zero'),
];

const _tooltipApi = [
  _ApiRow('message', '提示文本', 'String', '-', required: true),
  _ApiRow('child', '触发提示的子元素', 'Widget', '-', required: true),
  _ApiRow('placement', '提示位置', 'AnimalTooltipPlacement', 'top'),
  _ApiRow('preferBelow', '兼容旧写法：优先在下方显示', 'bool?', '-'),
  _ApiRow('waitDuration', '等待显示时间', 'Duration', '350ms'),
  _ApiRow('showDuration', '显示持续时间', 'Duration', '3s'),
  _ApiRow('gap', '提示与触发元素间距', 'double', '10'),
];

const _messageApi = [
  _ApiRow('context', '上下文', 'BuildContext', '-', required: true),
  _ApiRow('child', '提示内容', 'Widget', '-', required: true),
  _ApiRow('type', '提示类型', 'AnimalMessageType', 'info'),
  _ApiRow('duration', '显示时长', 'Duration', '2s'),
];

const _progressApi = [
  _ApiRow('value', '进度比例 0..1', 'double', '-', required: true),
  _ApiRow('height', '进度条高度', 'double', '16'),
  _ApiRow('showLabel', '是否显示百分比', 'bool', 'true'),
  _ApiRow('color', '填充色', 'Color?', '-'),
  _ApiRow('backgroundColor', '背景色', 'Color?', '-'),
];

const _paginationApi = [
  _ApiRow('current', '当前页', 'int', '-', required: true),
  _ApiRow('total', '总条数', 'int', '-', required: true),
  _ApiRow('onChanged', '页码变化回调', 'ValueChanged<int>', '-', required: true),
  _ApiRow('pageSize', '每页条数', 'int', '10'),
  _ApiRow('maxVisiblePages', '最大可见页数', 'int', '5'),
  _ApiRow('disabled', '是否禁用', 'bool', 'false'),
];

const _emptyApi = [
  _ApiRow('description', '空状态文案', 'String', '暂无数据'),
  _ApiRow('icon', '自定义图标', 'Widget?', '-'),
  _ApiRow('action', '行动按钮或操作区', 'Widget?', '-'),
];

const _alertApi = [
  _ApiRow('title', '标题', 'Widget?', '-'),
  _ApiRow('child', '提示内容', 'Widget', '-', required: true),
  _ApiRow('type', '提示类型', 'AnimalAlertType', 'info'),
  _ApiRow('showIcon', '是否显示图标', 'bool', 'true'),
  _ApiRow('closable', '是否可关闭', 'bool', 'false'),
  _ApiRow('onClose', '关闭回调', 'VoidCallback?', '-'),
];

const _avatarApi = [
  _ApiRow('child', '文字或自定义内容', 'Widget?', '-'),
  _ApiRow('image', '图片源', 'ImageProvider?', '-'),
  _ApiRow('imageUrl', '网络图片地址', 'String?', '-'),
  _ApiRow('icon', 'Animal 图标名', 'AnimalIconName?', '-'),
  _ApiRow('size', '头像尺寸', 'AnimalAvatarSize', 'middle'),
  _ApiRow('shape', '头像形状', 'AnimalAvatarShape', 'circle'),
  _ApiRow('backgroundColor', '背景色', 'Color?', '-'),
  _ApiRow('foregroundColor', '前景色', 'Color?', '-'),
];

const _breadcrumbApi = [
  _ApiRow('items', '面包屑项', 'List<AnimalBreadcrumbItem>', '-', required: true),
  _ApiRow('separator', '自定义分隔符', 'Widget?', '/'),
];

const _stepsApi = [
  _ApiRow('items', '步骤项', 'List<AnimalStepItem>', '-', required: true),
  _ApiRow('current', '当前步骤索引', 'int', '0'),
  _ApiRow('direction', '排列方向', 'AnimalStepsDirection', 'horizontal'),
  _ApiRow('onChanged', '步骤点击回调', 'ValueChanged<int>?', '-'),
];

const _sliderApi = [
  _ApiRow('value', '受控数值', 'double?', '-'),
  _ApiRow('defaultValue', '默认数值', 'double', '0'),
  _ApiRow('min', '最小值', 'double', '0'),
  _ApiRow('max', '最大值', 'double', '100'),
  _ApiRow('divisions', '分段数量', 'int?', '-'),
  _ApiRow('disabled', '是否禁用', 'bool', 'false'),
  _ApiRow('showLabel', '是否显示标签', 'bool', 'true'),
  _ApiRow('onChanged', '数值变化回调', 'ValueChanged<double>?', '-'),
];

const _rateApi = [
  _ApiRow('value', '受控评分', 'int?', '-'),
  _ApiRow('defaultValue', '默认评分', 'int', '0'),
  _ApiRow('count', '评分总数', 'int', '5'),
  _ApiRow('disabled', '是否禁用', 'bool', 'false'),
  _ApiRow('onChanged', '评分变化回调', 'ValueChanged<int>?', '-'),
];

const _segmentedApi = [
  _ApiRow('options', '分段选项', 'List<AnimalSegmentedOption<T>>', '-',
      required: true),
  _ApiRow('value', '受控选中值', 'T?', '-'),
  _ApiRow('defaultValue', '默认选中值', 'T?', '第一个选项'),
  _ApiRow('disabled', '是否整体禁用', 'bool', 'false'),
  _ApiRow('onChanged', '选中变化回调', 'ValueChanged<T>?', '-'),
];

const _skeletonApi = [
  _ApiRow('active', '是否显示骨架屏', 'bool', 'true'),
  _ApiRow('rows', '行数', 'int', '3'),
  _ApiRow('width', '固定宽度', 'double?', '-'),
  _ApiRow('lineHeight', '行高', 'double', '14'),
  _ApiRow('child', '加载完成内容', 'Widget?', '-'),
];

const _timeApi = [
  _ApiRow('now', '指定显示时间；为空时实时更新时间', 'DateTime?', '-'),
];

const _phoneApi = [
  _ApiRow('width', '手机设计稿宽度', 'double', '527'),
  _ApiRow('height', '手机设计稿高度', 'double', '788'),
];

const _buttonCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        // Primary
        AnimalButton(type: AnimalButtonType.primary, onPressed: () {}, child: const Text('Primary')),
        // Default
        AnimalButton(onPressed: () {}, child: const Text('Default')),
        // Dashed
        AnimalButton(type: AnimalButtonType.dashed, onPressed: () {}, child: const Text('Dashed')),
        // Text
        AnimalButton(type: AnimalButtonType.text, onPressed: () {}, child: const Text('Text')),
        // Link
        AnimalButton(type: AnimalButtonType.link, onPressed: () {}, child: const Text('Link')),
        // Danger
        AnimalButton(type: AnimalButtonType.primary, danger: true, onPressed: () {}, child: const Text('Danger')),
        // Ghost
        AnimalButton(type: AnimalButtonType.primary, ghost: true, onPressed: () {}, child: const Text('Ghost')),
        // Loading
        const AnimalButton(type: AnimalButtonType.primary, loading: true, child: Text('Loading')),
        // Large
        AnimalButton(type: AnimalButtonType.primary, size: AnimalButtonSize.large, onPressed: () {}, child: const Text('Large')),
        // Icon
        AnimalButton(type: AnimalButtonType.primary, icon: const Text('🔍'), onPressed: () {}, child: const Text('搜索')),
        // Block
        AnimalButton(type: AnimalButtonType.primary, block: true, onPressed: () {}, child: const Text('Block')),
      ],
    );
  }
}''';

const _inputCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // 基础输入框
        AnimalInput(hintText: 'Basic input'),
        // 带清除按钮
        AnimalInput(hintText: 'With clear', allowClear: true),
        // 前后缀
        AnimalInput(hintText: 'Prefix', prefix: Text('🔍'), suffix: Text('⏎')),
        // 小尺寸
        AnimalInput(hintText: 'Small', size: AnimalInputSize.small),
        // 大尺寸
        AnimalInput(hintText: 'Large', size: AnimalInputSize.large),
        // 错误状态
        AnimalInput(hintText: 'Error', status: AnimalInputStatus.error),
        // 警告状态
        AnimalInput(hintText: 'Warning', status: AnimalInputStatus.warning),
        // 有阴影
        AnimalInput(hintText: 'With shadow', shadow: true),
      ],
    );
  }
}''';

const _switchCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var checked = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        // 受控模式
        AnimalSwitch(value: checked, onChanged: (value) => setState(() => checked = value)),
        // 自定义文案
        const AnimalSwitch(defaultValue: true, checkedChild: Text('开'), uncheckedChild: Text('关')),
        // 小尺寸
        const AnimalSwitch(size: AnimalSwitchSize.small, defaultValue: true),
      ],
    );
  }
}''';

const _cardCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // 基础卡片
        SizedBox(width: 260, child: AnimalCard(child: Text('基础卡片'))),

        // 标题卡片
        SizedBox(
          width: 260,
          child: AnimalCard(type: AnimalCardType.title, child: Text('标题卡片')),
        ),

        // 颜色变体
        AnimalCard(color: AnimalCardColor.appBlue, child: Text('蓝色卡片')),
        AnimalCard(color: AnimalCardColor.warmPeachPink, child: Text('暖桃粉卡片')),

        // 颜色 + 标题 组合
        AnimalCard(
          type: AnimalCardType.title,
          color: AnimalCardColor.purple,
          child: Text('紫色标题卡片'),
        ),
      ],
    );
  }
}''';

const _collapseCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // 基础用法
        AnimalCollapse(question: Text('问题'), answer: Text('回答内容')),
        // 默认展开
        AnimalCollapse(question: Text('默认展开'), answer: Text('答案'), defaultExpanded: true),
        // 禁用状态
        AnimalCollapse(question: Text('禁用'), answer: Text('答案'), disabled: true),
      ],
    );
  }
}''';

const _cursorCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimalCursor(
      child: Text('鼠标移入此区域将显示自定义光标'),
    );
  }
}''';

const _modalCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

void openModal(BuildContext context) {
  AnimalDialog.show<void>(
    context: context,
    child: const Text('Modal 内容'),
  );

  // 带标题
  AnimalDialog.show<void>(
    context: context,
    title: const Text('标题'),
    child: const Text('内容'),
  );

  // 自定义 Footer
  AnimalDialog.show<void>(
    context: context,
    title: const Text('确认'),
    footer: AnimalButton(onPressed: () {}, child: const Text('自定义按钮')),
    child: const Text('内容'),
  );

  // 无 Footer
  AnimalDialog.show<void>(
    context: context,
    showFooter: false,
    child: const Text('无底部按钮'),
  );

  // 关闭打字机效果
  AnimalDialog.show<void>(
    context: context,
    typewriter: false,
    child: const Text('直接显示全部内容'),
  );
}''';

const _typewriterCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var replayKey = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimalTypewriter(
          trigger: replayKey,
          text: '你好，欢迎来到动物岛！',
        ),

        // 支持多行文本
        AnimalTypewriter(
          speed: const Duration(milliseconds: 40),
          trigger: replayKey,
          text: '第一行\n第二行',
        ),

        AnimalButton(
          onPressed: () => setState(() => replayKey += 1),
          child: const Text('重新播放'),
        ),
      ],
    );
  }
}''';

const _dividerCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // line-brown
        AnimalDivider(type: AnimalDividerType.lineBrown),
        // line-teal
        AnimalDivider(type: AnimalDividerType.lineTeal),
        // line-white
        AnimalDivider(type: AnimalDividerType.lineWhite),
        // line-yellow
        AnimalDivider(type: AnimalDividerType.lineYellow),
        // wave-yellow
        AnimalDivider(type: AnimalDividerType.waveYellow),
      ],
    );
  }
}''';

const _iconCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // 基础用法
        AnimalIcon(name: AnimalIconName.miles, size: 32),
        // 弹跳动画
        AnimalIcon(name: AnimalIconName.camera, size: 48, bounce: true),
      ],
    );
  }
}''';

const _selectCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

const options = [
  AnimalSelectOption(key: 'option1', label: '选项一'),
  AnimalSelectOption(key: 'option2', label: '选项二'),
];

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? value = 'option1';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 受控模式
        AnimalSelect<String>(options: options, value: value, onChanged: (next) => setState(() => value = next)),
        // 占位文本
        AnimalSelect<String>(options: options, value: null, onChanged: (_) {}, placeholder: '请选择'),
        // 禁用状态
        AnimalSelect<String>(options: options, value: value, onChanged: (_) {}, disabled: true),
      ],
    );
  }
}''';

const _checkboxCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

const options = [
  AnimalCheckboxOption(value: 'beach', label: Text('🌊 海滩')),
  AnimalCheckboxOption(value: 'forest', label: Text('🌳 森林')),
  AnimalCheckboxOption(value: 'garden', label: Text('🌸 花园')),
];

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // 非受控
        AnimalCheckbox<String>(options: options, defaultValue: ['beach']),
        // 垂直排列
        AnimalCheckbox<String>(options: options, direction: AnimalCheckboxDirection.vertical),
      ],
    );
  }
}''';

const _tabsCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimalTabs(
      defaultActiveKey: 'tab1',
      items: [
        AnimalTabItem(key: 'tab1', label: Text('标签一'), child: Text('内容一')),
        AnimalTabItem(key: 'tab2', label: Text('标签二'), child: Text('内容二')),
      ],
    );
  }
}''';

const _footerCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AnimalFooter(),
        AnimalFooter(type: AnimalFooterType.sea),
      ],
    );
  }
}''';

const _codeBlockCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimalCodeBlock(
      code: "AnimalButton(type: AnimalButtonType.primary, child: Text('按钮'))",
    );
  }
}''';

const _loadingCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var active = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: Text('Underlying Content')),
        Positioned.fill(child: AnimalLoading(active: active)),
        AnimalButton(
          onPressed: () => setState(() => active = !active),
          child: Text(active ? '关闭 Loading' : '开启 Loading'),
        ),
      ],
    );
  }
}''';

const _tableCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

const data = [
  {'name': '豆狸', 'age': 26, 'island': '彩虹岛', 'fruit': '苹果', 'hobby': '音乐'},
  {'name': '粒狸', 'age': 24, 'island': '彩虹岛', 'fruit': '橘子', 'hobby': '运动'},
  {'name': '西施惠', 'age': 28, 'island': '好评岛', 'fruit': '樱桃', 'hobby': '唱歌'},
];

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimalTable<Map<String, Object>>(
      columns: [
        AnimalTableColumn(title: const Text('岛民'), width: 120, cellBuilder: (_, row, __) => Text(row['name'] as String)),
        AnimalTableColumn(title: const Text('年龄'), width: 80, alignment: Alignment.center, cellBuilder: (_, row, __) => Text('${row['age']}')),
        AnimalTableColumn(title: const Text('岛屿'), cellBuilder: (_, row, __) => Text(row['island'] as String)),
      ],
      rows: data,
      striped: true,
    );
  }
}''';

const _extendedBasicsCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var fruit = 'apple';
  var page = 1;
  var progress = 0.64;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimalRadio<String>(
          value: fruit,
          options: const [
            AnimalRadioOption(value: 'apple', label: Text('苹果岛')),
            AnimalRadioOption(value: 'peach', label: Text('桃子岛')),
          ],
          onChanged: (value) => setState(() => fruit = value),
        ),
        const AnimalTag(color: AnimalTagColor.primary, child: Text('新组件')),
        const AnimalBadge(count: 5, child: AnimalIcon(name: AnimalIconName.chat)),
        const AnimalTooltip(
          message: '今天也要整理背包哦',
          child: Text('悬停查看'),
        ),
        AnimalButton(
          onPressed: () => AnimalMessage.success(context, const Text('保存成功')),
          child: const Text('显示提示'),
        ),
        AnimalProgress(value: progress),
        AnimalPagination(
          current: page,
          total: 86,
          onChanged: (value) => setState(() => page = value),
        ),
        const AnimalEmpty(description: '今天还没有岛民记录'),
      ],
    );
  }
}''';

const _advancedBasicsCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var step = 1;
  var slider = 46.0;
  var rate = 4;
  var segment = 'list';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AnimalAlert(
          type: AnimalAlertType.info,
          title: Text('岛屿公告'),
          child: Text('今天商店会提前打烊。'),
        ),
        const AnimalAvatar(child: Text('狸')),
        const AnimalBreadcrumb(
          items: [
            AnimalBreadcrumbItem(label: Text('首页')),
            AnimalBreadcrumbItem(label: Text('组件')),
            AnimalBreadcrumbItem(label: Text('Advanced')),
          ],
        ),
        AnimalSteps(
          current: step,
          onChanged: (value) => setState(() => step = value),
          items: const [
            AnimalStepItem(title: Text('出发')),
            AnimalStepItem(title: Text('采集')),
            AnimalStepItem(title: Text('完成')),
          ],
        ),
        AnimalSlider(
          value: slider,
          divisions: 10,
          onChanged: (value) => setState(() => slider = value),
        ),
        AnimalRate(
          value: rate,
          onChanged: (value) => setState(() => rate = value),
        ),
        AnimalSegmented<String>(
          value: segment,
          onChanged: (value) => setState(() => segment = value),
          options: const [
            AnimalSegmentedOption(value: 'list', label: Text('列表')),
            AnimalSegmentedOption(value: 'grid', label: Text('网格')),
          ],
        ),
        const AnimalSkeleton(rows: 3),
      ],
    );
  }
}''';

const _radioCode = r'''AnimalRadio<String>(
  value: value,
  options: const [
    AnimalRadioOption(value: 'apple', label: Text('苹果岛')),
    AnimalRadioOption(value: 'peach', label: Text('桃子岛')),
    AnimalRadioOption(value: 'locked', label: Text('未开放'), disabled: true),
  ],
  onChanged: (next) => setState(() => value = next),
)

const AnimalRadio<String>(
  direction: AnimalRadioDirection.vertical,
  defaultValue: 'morning',
  options: [
    AnimalRadioOption(value: 'morning', label: Text('上午')),
    AnimalRadioOption(value: 'night', label: Text('夜晚')),
  ],
)''';

const _tagCode =
    r'''const AnimalTag(color: AnimalTagColor.primary, child: Text('新组件'))

AnimalTag(
  color: AnimalTagColor.danger,
  closable: true,
  onClose: () {},
  child: const Text('可关闭'),
)

const AnimalTag(
  size: AnimalTagSize.large,
  icon: Text('✦'),
  child: Text('稀有'),
)''';

const _badgeCode = r'''const AnimalBadge(
  count: 120,
  child: AnimalIcon(name: AnimalIconName.shopping, size: 44),
)

const AnimalBadge(
  dot: true,
  status: AnimalBadgeStatus.success,
  child: AnimalIcon(name: AnimalIconName.camera, size: 44),
)

const AnimalBadge(text: 'NEW', child: Text('消息'))''';

const _tooltipCode = r'''const AnimalTooltip(
  message: '今天也要整理背包哦',
  child: AnimalButton(
    type: AnimalButtonType.primary,
    child: Text('悬停查看'),
  ),
)

const AnimalTooltip(
  message: '右侧提示',
  placement: AnimalTooltipPlacement.right,
  child: Text('Right'),
)

const AnimalTooltip(
  message: '下方提示',
  placement: AnimalTooltipPlacement.bottom,
  child: Text('提示文本'),
)''';

const _messageCode = r'''AnimalButton(
  onPressed: () => AnimalMessage.success(context, const Text('保存成功')),
  child: const Text('Success'),
)

AnimalMessage.show(
  context,
  type: AnimalMessageType.warning,
  duration: const Duration(seconds: 3),
  child: const Text('背包快满了'),
)''';

const _progressCode = r'''AnimalProgress(value: progress)

const AnimalProgress(
  value: 0.82,
  height: 12,
  color: Color(0xFFF5C31C),
  showLabel: false,
)''';

const _paginationCode = r'''AnimalPagination(
  current: page,
  total: 86,
  onChanged: (next) => setState(() => page = next),
)

AnimalPagination(
  current: 4,
  total: 160,
  pageSize: 20,
  maxVisiblePages: 7,
  onChanged: (next) {},
)''';

const _emptyCode = r'''AnimalEmpty(
  description: '今天还没有岛民记录',
  action: AnimalButton(
    type: AnimalButtonType.primary,
    onPressed: () {},
    child: const Text('添加记录'),
  ),
)

const AnimalEmpty(
  description: '暂无聊天消息',
  icon: AnimalIcon(name: AnimalIconName.chat, size: 72),
)''';

const _alertCode = r'''const AnimalAlert(
  type: AnimalAlertType.info,
  title: Text('岛屿公告'),
  child: Text('今天商店会提前打烊。'),
)

AnimalAlert(
  type: AnimalAlertType.warning,
  closable: true,
  onClose: () {},
  child: const Text('这条提示可以关闭。'),
)''';

const _avatarCode = r'''const AnimalAvatar(child: Text('狸'))

const AnimalAvatar(
  size: AnimalAvatarSize.large,
  icon: AnimalIconName.camera,
)

const AnimalAvatar(
  shape: AnimalAvatarShape.square,
  backgroundColor: Color(0xFFE6F9F6),
  child: Text('岛'),
)''';

const _breadcrumbCode = r'''AnimalBreadcrumb(
  items: [
    AnimalBreadcrumbItem(label: const Text('首页'), onTap: () {}),
    AnimalBreadcrumbItem(label: const Text('组件'), onTap: () {}),
    const AnimalBreadcrumbItem(label: Text('Breadcrumb')),
  ],
)

const AnimalBreadcrumb(
  separator: Text('>'),
  items: [
    AnimalBreadcrumbItem(label: Text('岛屿')),
    AnimalBreadcrumbItem(label: Text('居民'), disabled: true),
    AnimalBreadcrumbItem(label: Text('详情')),
  ],
)''';

const _stepsCode = r'''AnimalSteps(
  current: step,
  onChanged: (next) => setState(() => step = next),
  items: const [
    AnimalStepItem(title: Text('出发'), description: Text('整理背包')),
    AnimalStepItem(title: Text('采集'), description: Text('收集素材')),
    AnimalStepItem(title: Text('完成'), description: Text('回到服务处')),
  ],
)

const AnimalSteps(
  direction: AnimalStepsDirection.vertical,
  current: 1,
  items: [
    AnimalStepItem(title: Text('申请')),
    AnimalStepItem(title: Text('审核'), status: AnimalStepStatus.error),
    AnimalStepItem(title: Text('完成'), disabled: true),
  ],
)''';

const _sliderCode = r'''AnimalSlider(
  value: slider,
  divisions: 10,
  onChanged: (next) => setState(() => slider = next),
)

const AnimalSlider(
  defaultValue: 3,
  min: 1,
  max: 5,
  divisions: 4,
)

const AnimalSlider(defaultValue: 60, disabled: true)''';

const _rateCode = r'''AnimalRate(
  value: rate,
  onChanged: (next) => setState(() => rate = next),
)

const AnimalRate(defaultValue: 3)
const AnimalRate(defaultValue: 6, count: 8)
const AnimalRate(defaultValue: 4, disabled: true)''';

const _segmentedCode = r'''AnimalSegmented<String>(
  value: mode,
  onChanged: (next) => setState(() => mode = next),
  options: const [
    AnimalSegmentedOption(value: 'list', label: Text('列表')),
    AnimalSegmentedOption(value: 'grid', label: Text('网格')),
  ],
)

const AnimalSegmented<String>(
  defaultValue: 'morning',
  options: [
    AnimalSegmentedOption(value: 'morning', label: Text('上午')),
    AnimalSegmentedOption(value: 'night', label: Text('夜晚')),
    AnimalSegmentedOption(value: 'locked', label: Text('未开放'), disabled: true),
  ],
)''';

const _skeletonCode = r'''const AnimalSkeleton(rows: 4)

const AnimalSkeleton(rows: 2, width: 260, lineHeight: 18)

const AnimalSkeleton(
  active: false,
  child: AnimalAlert(
    type: AnimalAlertType.success,
    child: Text('加载完成'),
  ),
)''';

const _timeCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimalTime();
  }
}''';

const _phoneCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimalPhone();
  }
}''';
