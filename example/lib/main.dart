import 'dart:ui' as ui;

import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'mobile_preview_embed.dart';

const _githubUrl = 'https://github.com/ohmangocat/animal_island_flutter';
const _pubDevUrl = 'https://pub.dev/packages/animal_island_flutter';
const _packageVersion = '0.1.2';

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
  var _docSearchQuery = '';
  var _mobilePreviewOpen = false;
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
  var _mobileBottomIndex = 1;

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();
    final visiblePages = _filterDocPages(pages, _docSearchQuery);
    final width = MediaQuery.sizeOf(context).width;

    Widget body;
    Color backgroundColor;

    if (_mobilePreviewOpen) {
      backgroundColor = const Color(0xFFF8F4E8);
      body = SafeArea(
        child: _MobilePreviewHost(
          onClose: _closeMobilePreview,
        ),
      );
    } else if (_activeIndex < 0) {
      backgroundColor = const Color(0xFF7DC395);
      body = _HomePage(onNavigate: _openHomeTarget);
    } else {
      final safeIndex = _activeIndex.clamp(0, pages.length - 1);
      final activeVisible = visiblePages.contains(pages[safeIndex]);
      final displayIndex = activeVisible || visiblePages.isEmpty
          ? safeIndex
          : pages.indexOf(visiblePages.first);
      final activePage = pages[displayIndex];
      backgroundColor = const Color(0xFFF8F4E8);
      body = SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useMobileDocs = width < 900 || constraints.maxWidth < 900;

            if (useMobileDocs) {
              return _MobileDocsLayout(
                pages: pages,
                visiblePages: visiblePages,
                activeIndex: displayIndex,
                activePage: activePage,
                searchQuery: _docSearchQuery,
                onSearchChanged: (value) {
                  setState(() => _docSearchQuery = value);
                },
                onHome: () => setState(() => _activeIndex = -1),
                onSelect: (index) => setState(() => _activeIndex = index),
                onOpenDialog: _openWelcomeDialog,
                onOpenMobilePreview: _openMobilePreview,
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Sidebar(
                  pages: pages,
                  visiblePages: visiblePages,
                  activeIndex: displayIndex,
                  searchQuery: _docSearchQuery,
                  onSearchChanged: (value) {
                    setState(() => _docSearchQuery = value);
                  },
                  onHome: () => setState(() => _activeIndex = -1),
                  onSelect: (index) => setState(() => _activeIndex = index),
                ),
                Expanded(
                  child: _DocsDetailShell(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: _DocsHeader(
                            onOpenDialog: _openWelcomeDialog,
                            onOpenMobilePreview: _openMobilePreview,
                          ),
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
            );
          },
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
    final pages = [
      _DocPage(
        routeKey: 'button',
        group: '主题与基础',
        navTitle: 'Button 按钮',
        title: 'Button 按钮',
        summary:
            '按钮组件 — 支持 primary / dashed / text / link 等类型，danger / ghost / loading / disabled 状态，icon 图标，block 块级，三种尺寸',
        body: const _ButtonDoc(),
      ),
      _DocPage(
        routeKey: 'input',
        group: '表单输入',
        navTitle: 'Input 输入框',
        title: 'Input 输入框',
        summary:
            '输入框组件 — 支持三种尺寸、clearable 清除、prefix / suffix 前后缀、error / warning 校验状态、disabled 禁用',
        body: const _InputDoc(),
      ),
      _DocPage(
        routeKey: 'switch',
        group: '表单输入',
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
        group: '布局与容器',
        navTitle: 'Card 卡片',
        title: 'Card 卡片',
        summary: '卡片容器组件 — 支持 default / title 两种类型，13 种背景颜色',
        body: const _CardDoc(),
      ),
      _DocPage(
        routeKey: 'collapse',
        group: '布局与容器',
        navTitle: 'Collapse 折叠面板',
        title: 'Collapse 折叠面板',
        summary: '折叠面板组件 — 支持展开/收起、默认展开、禁用状态',
        body: const _CollapseDoc(),
      ),
      _DocPage(
        routeKey: 'cursor',
        group: 'Animal 特色',
        navTitle: 'Cursor 光标',
        title: 'Cursor 光标',
        summary: '光标组件 — 自定义手指光标，支持自定义尺寸、点击动画',
        body: const _CursorDoc(),
      ),
      _DocPage(
        routeKey: 'modal',
        group: '浮层',
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
        group: 'Animal 特色',
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
        group: '布局与容器',
        navTitle: 'Divider 分割线',
        title: 'Divider 分割线',
        summary: '分割线组件 — 装饰性分割线',
        body: const _DividerDoc(),
      ),
      _DocPage(
        routeKey: 'icon',
        group: '主题与基础',
        navTitle: 'Icon 图标',
        title: 'Icon 图标',
        summary: '图标组件 — 动森风格图标集，包含 10 个可爱图标，支持自定义尺寸',
        body: const _IconDoc(),
      ),
      _DocPage(
        routeKey: 'select',
        group: '表单输入',
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
        group: '表单输入',
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
        group: '导航',
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
        group: 'Animal 特色',
        navTitle: 'Footer 页脚',
        title: 'Footer 底部装饰',
        summary: '页面底部装饰图片，支持树和海两种类型',
        body: const _FooterDoc(),
      ),
      _DocPage(
        routeKey: 'codeblock',
        group: '数据展示',
        navTitle: 'CodeBlock 代码高亮',
        title: 'CodeBlock 代码高亮',
        summary: '代码高亮组件 — 语法高亮显示，支持自定义样式和类名',
        body: const _CodeBlockDoc(),
      ),
      _DocPage(
        routeKey: 'loading',
        group: '反馈',
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
        group: '数据展示',
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
        group: '反馈',
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
        group: '表单输入',
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
        group: '主题与基础',
        navTitle: 'Tag 标签',
        title: 'Tag 标签',
        summary: '标签组件 — 支持多种语义颜色、尺寸、图标和可关闭状态',
        body: _TagDoc(),
      ),
      const _DocPage(
        routeKey: 'badge',
        group: '主题与基础',
        navTitle: 'Badge 角标',
        title: 'Badge 角标',
        summary: '角标组件 — 支持数字、小红点、状态色、文本和数字上限',
        body: _BadgeDoc(),
      ),
      const _DocPage(
        routeKey: 'tooltip',
        group: '反馈',
        navTitle: 'Tooltip 提示',
        title: 'Tooltip 提示',
        summary: '提示气泡组件 — 给按钮、图标或文字补充轻量说明',
        body: _TooltipDoc(),
      ),
      const _DocPage(
        routeKey: 'message',
        group: '反馈',
        navTitle: 'Message 轻提示',
        title: 'Message 轻提示',
        summary: '顶部轻提示组件 — 支持 info / success / warning / error 状态反馈',
        body: _MessageDoc(),
      ),
      _DocPage(
        routeKey: 'progress',
        group: '反馈',
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
        group: '导航',
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
        group: '布局与容器',
        navTitle: 'Empty 空状态',
        title: 'Empty 空状态',
        summary: '空状态组件 — 支持默认叶子图标、自定义图标、说明文案和行动按钮',
        body: _EmptyDoc(),
      ),
      _DocPage(
        routeKey: 'advanced',
        group: '表单输入',
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
        routeKey: 'theme',
        group: '主题与基础',
        navTitle: 'Theme 主题',
        title: 'Theme 主题定制',
        summary: '主题能力 — 支持默认令牌、品牌主色派生、外部字体和局部覆盖',
        body: _ThemeDoc(),
      ),
      const _DocPage(
        routeKey: 'alert',
        group: '反馈',
        navTitle: 'Alert 警告',
        title: 'Alert 警告提示',
        summary: '警告提示组件 — 支持标题、图标、四种状态和可关闭提示',
        body: _AlertDoc(),
      ),
      const _DocPage(
        routeKey: 'avatar',
        group: '主题与基础',
        navTitle: 'Avatar 头像',
        title: 'Avatar 头像',
        summary: '头像组件 — 支持文字、图片、AnimalIcon、尺寸和圆形/方形形状',
        body: _AvatarDoc(),
      ),
      const _DocPage(
        routeKey: 'breadcrumb',
        group: '导航',
        navTitle: 'Breadcrumb 面包屑',
        title: 'Breadcrumb 面包屑',
        summary: '面包屑导航组件 — 支持可点击项、禁用项和自定义分隔符',
        body: _BreadcrumbDoc(),
      ),
      _DocPage(
        routeKey: 'steps',
        group: '导航',
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
        group: '表单输入',
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
        group: '表单输入',
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
        group: '表单输入',
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
        group: '布局与容器',
        navTitle: 'Skeleton 骨架屏',
        title: 'Skeleton 骨架屏',
        summary: '骨架屏组件 — 支持行数、宽度、行高、动画和加载完成内容切换',
        body: _SkeletonDoc(),
      ),
      const _DocPage(
        routeKey: 'form',
        group: '表单输入',
        navTitle: 'Form 表单布局',
        title: 'Form 表单布局',
        summary:
            '表单布局组件 — 支持 vertical / horizontal / inline 三种排列、label 宽度、帮助文本和错误文本',
        body: _FormDoc(),
      ),
      const _DocPage(
        routeKey: 'input-plus',
        group: '表单输入',
        navTitle: 'Input Plus 输入增强',
        title: 'Input Plus 输入增强',
        summary:
            '输入增强组件 — Textarea / PasswordInput / SearchInput / NumberInput 覆盖更完整的业务输入场景',
        body: _InputPlusDoc(),
      ),
      const _DocPage(
        routeKey: 'popover',
        group: '浮层',
        navTitle: 'Popover 气泡卡片',
        title: 'Popover 气泡卡片',
        summary: '气泡卡片组件 — 支持 click / hover / manual 触发和上下左右定位',
        body: _PopoverDoc(),
      ),
      const _DocPage(
        routeKey: 'dropdown',
        group: '浮层',
        navTitle: 'Dropdown 下拉菜单',
        title: 'Dropdown 下拉菜单',
        summary: '下拉菜单组件 — 复用 Popover 浮层能力，支持图标、禁用项、选中回调和点击后自动关闭',
        body: _DropdownDoc(),
      ),
      const _DocPage(
        routeKey: 'drawer',
        group: '浮层',
        navTitle: 'Drawer 抽屉',
        title: 'Drawer 抽屉',
        summary: '抽屉组件 — 支持左右方向、标题、底部操作区和遮罩关闭',
        body: _DrawerDoc(),
      ),
      const _DocPage(
        routeKey: 'confirm-dialog',
        group: '浮层',
        navTitle: 'ConfirmDialog 确认框',
        title: 'ConfirmDialog 确认框',
        summary: '确认框组件 — 基于 AnimalDialog 封装常见确认流程，支持危险操作样式和返回结果',
        body: _ConfirmDialogDoc(),
      ),
      const _DocPage(
        routeKey: 'mobile-navbar',
        group: '移动端',
        navTitle: 'MobileNavBar 导航栏',
        title: 'MobileNavBar 移动导航栏',
        summary: '移动导航栏 — 支持安全区、返回按钮、左右操作区和固定高度',
        body: _MobileNavBarDoc(),
        keywords: ['mobile', 'navbar', 'appbar', '手机导航', '移动端'],
      ),
      _DocPage(
        routeKey: 'mobile-bottom-bar',
        group: '移动端',
        navTitle: 'BottomBar 底部栏',
        title: 'BottomBar 底部导航栏',
        summary: '底部导航栏 — 支持选中态、徽标、底部安全区和触摸反馈',
        body: _MobileBottomBarDoc(
          currentIndex: _mobileBottomIndex,
          onChanged: (value) => setState(() => _mobileBottomIndex = value),
        ),
        keywords: ['mobile', 'bottom', 'tabbar', '底部导航', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-bottom-sheet',
        group: '移动端',
        navTitle: 'BottomSheet 底部弹层',
        title: 'BottomSheet 底部弹层',
        summary: '底部弹层 — 从屏幕底部展开，适合移动端详情、筛选和轻量表单',
        body: _MobileBottomSheetDoc(),
        keywords: ['mobile', 'sheet', 'bottomsheet', '底部弹层', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-action-sheet',
        group: '移动端',
        navTitle: 'ActionSheet 操作面板',
        title: 'ActionSheet 操作面板',
        summary: '操作面板 — 面向触摸操作列表，支持图标、危险项、禁用项和返回选择值',
        body: _MobileActionSheetDoc(),
        keywords: ['mobile', 'actionsheet', '操作面板', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-list-tile',
        group: '移动端',
        navTitle: 'ListTile 列表项',
        title: 'ListTile 移动列表项',
        summary: '列表项 — 支持前后缀、二级文案、箭头、禁用态、危险态和键盘触发',
        body: _MobileListTileDoc(),
        keywords: ['mobile', 'listtile', 'cell', '列表项', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-cell-group',
        group: '移动端',
        navTitle: 'CellGroup 单元格组',
        title: 'CellGroup 单元格组',
        summary: '单元格组 — 将多个移动列表项组织为带边框和分割线的触摸列表',
        body: _MobileCellGroupDoc(),
        keywords: ['mobile', 'cellgroup', 'cell', '单元格', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-search-bar',
        group: '移动端',
        navTitle: 'SearchBar 搜索栏',
        title: 'SearchBar 移动搜索栏',
        summary: '移动搜索栏 — 支持取消按钮、清空、搜索提交和焦点态',
        body: _MobileSearchBarDoc(),
        keywords: ['mobile', 'search', '搜索栏', '搜索', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-picker',
        group: '移动端',
        navTitle: 'Picker 选择器',
        title: 'Picker 移动选择器',
        summary: '移动选择器 — 基于底部弹层展示选项，支持选中、禁用和返回选择值',
        body: _MobilePickerDoc(),
        keywords: ['mobile', 'picker', '选择器', '底部选择', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-date-picker',
        group: '移动端',
        navTitle: 'DatePicker 日期选择',
        title: 'DatePicker 移动日期选择',
        summary: '移动日期选择 — 复用 AnimalCalendar 并提供底部确认操作',
        body: _MobileDatePickerDoc(),
        keywords: ['mobile', 'date', 'calendar', '日期选择', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-stepper',
        group: '移动端',
        navTitle: 'Stepper 步进器',
        title: 'Stepper 移动步进器',
        summary: '移动步进器 — 适合购物车数量、份数和库存等触摸增减场景',
        body: _MobileStepperDoc(),
        keywords: ['mobile', 'stepper', 'number', '数量', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-swipe-action',
        group: '移动端',
        navTitle: 'SwipeAction 左滑操作',
        title: 'SwipeAction 左滑操作',
        summary: '左滑操作 — 为列表项提供收藏、归档、删除等触摸快捷操作',
        body: _MobileSwipeActionDoc(),
        keywords: ['mobile', 'swipe', '左滑', '删除', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-pull-refresh',
        group: '移动端',
        navTitle: 'PullRefresh 下拉刷新',
        title: 'PullRefresh 下拉刷新',
        summary: '下拉刷新 — 包装滚动内容，使用 Animal 主题色展示刷新反馈',
        body: _MobilePullRefreshDoc(),
        keywords: ['mobile', 'refresh', '下拉刷新', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-section',
        group: '移动端',
        navTitle: 'Section 分区',
        title: 'Section 移动分区',
        summary: '移动分区 — 为手机页面提供标题、右侧操作和内容分组间距',
        body: _MobileSectionDoc(),
        keywords: ['mobile', 'section', '分区', '标题', '移动端'],
      ),
      const _DocPage(
        routeKey: 'mobile-product-card',
        group: '移动端',
        navTitle: 'ProductCard 商品卡片',
        title: 'ProductCard 商品卡片',
        summary: '商品卡片 — 面向移动商城、列表推荐和加购业务场景',
        body: _MobileProductCardDoc(),
        keywords: ['mobile', 'product', '商品', '商城', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-order-card',
        group: '移动端',
        navTitle: 'OrderCard 订单卡片',
        title: 'OrderCard 订单卡片',
        summary: '订单卡片 — 展示订单号、状态、商品明细、合计和底部操作区',
        body: _MobileOrderCardDoc(),
        keywords: ['mobile', 'order', '订单', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-profile-header',
        group: '移动端',
        navTitle: 'ProfileHeader 个人头图',
        title: 'ProfileHeader 个人头图',
        summary: '个人头图 — 用于会员中心、我的页面和用户资产概览',
        body: _MobileProfileHeaderDoc(),
        keywords: ['mobile', 'profile', 'user', '个人中心', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-stats-grid',
        group: '移动端',
        navTitle: 'StatsGrid 统计宫格',
        title: 'StatsGrid 统计宫格',
        summary: '统计宫格 — 在手机端展示订单、积分、券包等轻量指标',
        body: _MobileStatsGridDoc(),
        keywords: ['mobile', 'stats', '统计', '宫格', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-coupon-card',
        group: '移动端',
        navTitle: 'CouponCard 优惠券',
        title: 'CouponCard 优惠券',
        summary: '优惠券卡片 — 支持可领取、已领取和已过期三种业务状态',
        body: _MobileCouponCardDoc(),
        keywords: ['mobile', 'coupon', '优惠券', '营销', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-notice-bar',
        group: '移动端',
        navTitle: 'NoticeBar 公告栏',
        title: 'NoticeBar 移动公告栏',
        summary: '移动公告栏 — 用于活动提醒、订单提示和轻量业务通知，支持四种状态和点击动作',
        body: _MobileNoticeBarDoc(),
        keywords: ['mobile', 'notice', '公告', '通知', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-address-card',
        group: '移动端',
        navTitle: 'AddressCard 地址卡片',
        title: 'AddressCard 地址卡片',
        summary: '地址卡片 — 展示收货人、手机号、详细地址、默认标签和选中态',
        body: _MobileAddressCardDoc(),
        keywords: ['mobile', 'address', '地址', '收货', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-price-summary',
        group: '移动端',
        navTitle: 'PriceSummary 价格明细',
        title: 'PriceSummary 价格明细',
        summary: '价格明细 — 用于订单确认、费用拆分、优惠抵扣和合计展示',
        body: _MobilePriceSummaryDoc(),
        keywords: ['mobile', 'price', 'summary', '价格', '订单', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-checkout-bar',
        group: '移动端',
        navTitle: 'CheckoutBar 结算栏',
        title: 'CheckoutBar 底部结算栏',
        summary: '底部结算栏 — 固定底部金额与主操作，支持安全区和补充说明',
        body: _MobileCheckoutBarDoc(),
        keywords: ['mobile', 'checkout', 'cart', '结算', '底部栏', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-cart-item',
        group: '移动端',
        navTitle: 'CartItem 购物车项',
        title: 'CartItem 购物车项',
        summary: '购物车项 — 支持选中态、商品图、规格、价格、数量步进器和失效状态',
        body: _MobileCartItemDoc(),
        keywords: ['mobile', 'cart', '购物车', '商品项', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-order-timeline',
        group: '移动端',
        navTitle: 'OrderTimeline 订单时间线',
        title: 'OrderTimeline 订单时间线',
        summary: '订单时间线 — 为物流、履约和服务进度提供手机端状态时间线',
        body: _MobileOrderTimelineDoc(),
        keywords: ['mobile', 'timeline', '物流', '订单', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-payment-method',
        group: '移动端',
        navTitle: 'PaymentMethod 支付方式',
        title: 'PaymentMethod 支付方式',
        summary: '支付方式卡片 — 支持图标、说明、选中态、禁用态和点击选择',
        body: _MobilePaymentMethodDoc(),
        keywords: ['mobile', 'payment', '支付', '收银台', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'mobile-empty-action',
        group: '移动端',
        navTitle: 'EmptyAction 业务空状态',
        title: 'EmptyAction 业务空状态',
        summary: '移动业务空状态 — 带插画位、标题、说明和主行动按钮，适合购物车、订单和收藏页',
        body: _MobileEmptyActionDoc(),
        keywords: ['mobile', 'empty', '空状态', '行动按钮', '业务组件'],
      ),
      const _DocPage(
        routeKey: 'descriptions',
        group: '数据展示',
        navTitle: 'Descriptions 描述列表',
        title: 'Descriptions 描述列表',
        summary: '描述列表组件 — 支持多列、span 合并、横向/纵向展示，用于详情页信息分组',
        body: _DescriptionsDoc(),
      ),
      const _DocPage(
        routeKey: 'statistic',
        group: '数据展示',
        navTitle: 'Statistic 统计数值',
        title: 'Statistic 统计数值',
        summary: '统计数值组件 — 支持标题、前后缀、说明文本和强调色，用于仪表盘指标',
        body: _StatisticDoc(),
      ),
      const _DocPage(
        routeKey: 'timeline',
        group: '数据展示',
        navTitle: 'Timeline 时间线',
        title: 'Timeline 时间线',
        summary: '时间线组件 — 支持状态色、图标、时间和描述，用于流程进展或日志展示',
        body: _TimelineDoc(),
      ),
      const _DocPage(
        routeKey: 'calendar',
        group: '数据录入',
        navTitle: 'Calendar 日历',
        title: 'Calendar 日历',
        summary: '日历组件 — 支持日期选择、月份切换、受控值和日期范围限制',
        body: _CalendarDoc(),
      ),
      const _DocPage(
        routeKey: 'upload',
        group: '数据录入',
        navTitle: 'Upload 上传',
        title: 'Upload 上传',
        summary: '上传组件 — 展示上传入口、文件列表、进度、成功/失败状态和删除回调',
        body: _UploadDoc(),
      ),
      const _DocPage(
        routeKey: 'tree',
        group: '数据录入',
        navTitle: 'Tree 树形控件',
        title: 'Tree 树形控件',
        summary: '树形控件 — 支持层级节点、展开收起、选中项、禁用节点和图标',
        body: _TreeDoc(),
      ),
      const _DocPage(
        routeKey: 'result',
        group: '反馈',
        navTitle: 'Result 结果页',
        title: 'Result 结果页',
        summary: '结果页组件 — 用于成功、警告、错误和信息反馈场景，可配置额外内容与操作区',
        body: _ResultDoc(),
      ),
      _DocPage(
        routeKey: 'time',
        group: 'Animal 特色',
        navTitle: 'Time 时间',
        title: 'Time 时间',
        summary: '经典 HUD 风格的时间显示组件，实时更新时间',
        body: const _TimeDoc(),
      ),
      _DocPage(
        routeKey: 'phone',
        group: 'Animal 特色',
        navTitle: 'Phone 手机',
        title: 'Phone 手机',
        summary: '动森风格手机界面，包含对话框和背包功能',
        body: const _PhoneDoc(),
      ),
    ];
    return _sortDocPages(pages);
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

  void _openMobilePreview() {
    setState(() {
      _mobilePreviewOpen = true;
    });
  }

  void _closeMobilePreview() {
    setState(() => _mobilePreviewOpen = false);
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
    final isMobile = width < 900;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compactHero = isMobile || constraints.maxWidth < 900;
        final textBlock = Column(
          crossAxisAlignment: compactHero
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: compactHero
                        ? 'Animal Island Flutter'
                        : 'Animal\nIsland Flutter',
                  ),
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: _VersionPill(),
                    ),
                  ),
                ],
              ),
              textAlign: compactHero ? TextAlign.center : TextAlign.left,
              style: theme
                  .textStyle(
                size: compactHero ? 37 : 60,
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
                height: compactHero ? 72 : 88,
                child: AnimalTypewriter(
                  text: 'Animal风格的 Flutter 组件库，基于 Dart Widget 构建，让跨端应用充满温暖质感',
                  speed: const Duration(milliseconds: 60),
                  style: theme
                      .textStyle(
                        size: compactHero ? 14 : 17,
                        weight: FontWeight.w500,
                        color: const Color(0xFF7C5734),
                      )
                      .copyWith(height: 1.7),
                ),
              ),
            ),
            SizedBox(height: compactHero ? 22 : 28),
            Align(
              alignment: compactHero ? Alignment.center : Alignment.centerLeft,
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
          width: compactHero ? 180 : 320,
          height: compactHero ? 112 : 200,
          fit: BoxFit.contain,
        );

        return ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              compactHero ? 24 : 40,
              compactHero ? 56 : 60,
              compactHero ? 24 : 40,
              40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 880),
                child: compactHero
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          logo,
                          const SizedBox(height: 24),
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
      },
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
        final sections = _homeComponentGroups();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final indexed in sections.indexed) ...[
              _HomeComponentSection(
                section: indexed.$2,
                maxWidth: constraints.maxWidth,
                onNavigate: onNavigate,
              ),
              if (indexed.$1 != sections.length - 1) const SizedBox(height: 30),
            ],
          ],
        );
      },
    );
  }
}

class _HomeComponentSection extends StatelessWidget {
  const _HomeComponentSection({
    required this.section,
    required this.maxWidth,
    required this.onNavigate,
  });

  final _HomeComponentGroup section;
  final double maxWidth;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final columns = maxWidth < 460
        ? 1
        : maxWidth < 700
            ? 2
            : maxWidth < 920
                ? 3
                : 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 6,
          children: [
            Text(
              section.title,
              style: theme.textStyle(
                size: 18,
                weight: FontWeight.w800,
                color: const Color(0xFF725D42),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFE9F7EF),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFF86CBB0)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Text(
                  '${section.components.length} 个',
                  style: theme.textStyle(
                    size: 11,
                    weight: FontWeight.w700,
                    color: const Color(0xFF4E8F75),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          section.description,
          style: theme.textStyle(
            size: 12,
            weight: FontWeight.w600,
            color: const Color(0xFF8F7E62),
          ),
        ),
        const SizedBox(height: 12),
        _ResponsiveGrid(
          columns: columns,
          maxWidth: maxWidth,
          spacing: 12,
          children: [
            for (final component in section.components)
              _ComponentCard(
                component: component,
                onTap: () => onNavigate(component.key),
              ),
          ],
        ),
      ],
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
    required this.visiblePages,
    required this.activeIndex,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onHome,
    required this.onSelect,
  });

  final List<_DocPage> pages;
  final List<_DocPage> visiblePages;
  final int activeIndex;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onHome;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final groupCounts = <String, int>{};
    for (final page in pages) {
      groupCounts.update(page.group, (value) => value + 1, ifAbsent: () => 1);
    }

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
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: _DocSearchBox(
                    value: searchQuery,
                    onChanged: onSearchChanged,
                  ),
                ),
                Expanded(
                  child: KeyedSubtree(
                    key: const ValueKey('docs-sidebar-scrollable'),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                      children: [
                        if (visiblePages.isEmpty)
                          _SearchEmptyState(query: searchQuery)
                        else
                          for (final page in visiblePages) ...[
                            if (_isFirstVisibleInGroup(page, visiblePages))
                              _NavGroupHeader(
                                title: page.group,
                                count: _visibleGroupCount(
                                  page.group,
                                  visiblePages,
                                ),
                              ),
                            _NavItem(
                              title: page.navTitle,
                              active: pages.indexOf(page) == activeIndex,
                              onTap: () => onSelect(pages.indexOf(page)),
                            ),
                          ],
                      ],
                    ),
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

class _MobileDocsLayout extends StatelessWidget {
  const _MobileDocsLayout({
    required this.pages,
    required this.visiblePages,
    required this.activeIndex,
    required this.activePage,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onHome,
    required this.onSelect,
    required this.onOpenDialog,
    required this.onOpenMobilePreview,
  });

  final List<_DocPage> pages;
  final List<_DocPage> visiblePages;
  final int activeIndex;
  final _DocPage activePage;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onHome;
  final ValueChanged<int> onSelect;
  final VoidCallback onOpenDialog;
  final VoidCallback onOpenMobilePreview;

  @override
  Widget build(BuildContext context) {
    return _DocsDetailShell(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _MobileDocsTopBar(
              pages: pages,
              visiblePages: visiblePages,
              activeIndex: activeIndex,
              searchQuery: searchQuery,
              onSearchChanged: onSearchChanged,
              onHome: onHome,
              onSelect: onSelect,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DocsHeader(
                    onOpenDialog: onOpenDialog,
                    onOpenMobilePreview: onOpenMobilePreview,
                    compact: true,
                  ),
                  _DocArticle(
                    activePage,
                    compact: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileDocsTopBar extends StatelessWidget {
  const _MobileDocsTopBar({
    required this.pages,
    required this.visiblePages,
    required this.activeIndex,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onHome,
    required this.onSelect,
  });

  final List<_DocPage> pages;
  final List<_DocPage> visiblePages;
  final int activeIndex;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onHome;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final activeGroup = pages[activeIndex].group;
    final groups = [
      for (final group in _docNavGroups)
        if (visiblePages.any((page) => page.group == group)) group,
    ];
    final activeVisible = visiblePages.contains(pages[activeIndex]);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F4E8),
        border: Border(bottom: BorderSide(color: Color(0xFFE8E2D6))),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onHome,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _DemoAssets.nook1,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Animal Docs',
                          style: theme.textStyle(
                            size: 16,
                            weight: FontWeight.w800,
                            color: const Color(0xFF725D42),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E2),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE5D39D)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    child: Text(
                      activeVisible ? '${visiblePages.length} 个结果' : '搜索中',
                      style: theme.textStyle(
                        size: 11,
                        weight: FontWeight.w800,
                        color: const Color(0xFF9C7A2D),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _DocSearchBox(
              value: searchQuery,
              onChanged: onSearchChanged,
            ),
            if (visiblePages.isEmpty) ...[
              const SizedBox(height: 10),
              _SearchEmptyState(query: searchQuery),
            ] else ...[
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final group in groups) ...[
                      _MobileGroupChip(
                        title: group,
                        count: _visibleGroupCount(group, visiblePages),
                        active: activeGroup == group,
                        onTap: () {
                          final page = visiblePages.firstWhere(
                            (candidate) => candidate.group == group,
                          );
                          onSelect(pages.indexOf(page));
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: visiblePages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final page = visiblePages[index];
                    final pageIndex = pages.indexOf(page);
                    return _MobilePageChip(
                      title: page.title,
                      active: pageIndex == activeIndex,
                      onTap: () => onSelect(pageIndex),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MobileGroupChip extends StatelessWidget {
  const _MobileGroupChip({
    required this.title,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final String title;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFB7C6E5) : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active ? const Color(0xFF9AAED8) : const Color(0xFFE1D7C8),
            ),
          ),
          child: Text(
            '$title $count',
            style: theme.textStyle(
              size: 12,
              weight: FontWeight.w800,
              color: active ? Colors.white : const Color(0xFF8A7652),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobilePageChip extends StatelessWidget {
  const _MobilePageChip({
    required this.title,
    required this.active,
    required this.onTap,
  });

  final String title;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(maxWidth: 148),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFFEEA0) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active ? const Color(0xFFE5A928) : const Color(0xFFE1D7C8),
              width: active ? 2 : 1,
            ),
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyle(
              size: 13,
              weight: FontWeight.w800,
              color: const Color(0xFF725D42),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobilePreviewHost extends StatelessWidget {
  const _MobilePreviewHost({
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _DocsDetailShell(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fullScreen = constraints.maxWidth < 900;
          final preview = kIsWeb
              ? const MobilePreviewEmbed(
                  key: ValueKey('mobile-preview-iframe'),
                  source: 'mobile_preview/index.html',
                )
              : const _MobilePreviewFallback();

          if (fullScreen) {
            return Stack(
              children: [
                Positioned.fill(child: preview),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _MobilePreviewFloatingClose(onClose: onClose),
                ),
              ],
            );
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 330),
                    child: _MobilePreviewIntro(onClose: onClose),
                  ),
                  const SizedBox(width: 42),
                  _PhoneSimulatorFrame(child: preview),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MobilePreviewFallback extends StatelessWidget {
  const _MobilePreviewFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF8F4E8),
      child: _MobilePreviewFallbackContent(),
    );
  }
}

class _MobilePreviewFallbackContent extends StatelessWidget {
  const _MobilePreviewFallbackContent();

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(_DemoAssets.nook1, width: 58, height: 58),
            const SizedBox(height: 16),
            Text(
              '手机预览应用',
              textAlign: TextAlign.center,
              style: theme.textStyle(size: 24, weight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Web 文档通过 iframe 挂载独立 mobile_preview 应用。桌面或移动本地调试时，请单独运行 example/mobile_preview。',
              textAlign: TextAlign.center,
              style: theme.textStyle(
                size: 13,
                weight: FontWeight.w700,
                color: const Color(0xFF7D684B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobilePreviewFloatingClose extends StatelessWidget {
  const _MobilePreviewFloatingClose({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: _MobilePreviewIconButton(
        icon: Icons.close_rounded,
        onTap: onClose,
      ),
    );
  }
}

class _MobilePreviewIntro extends StatelessWidget {
  const _MobilePreviewIntro({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(_DemoAssets.nook1, width: 48, height: 48),
        const SizedBox(height: 18),
        Text(
          '手机模拟器预览',
          style: theme.textStyle(size: 30, weight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        Text(
          '按移动端浏览路径体验组件：分类、列表、效果页。详情页只展示组件真实效果，不展示代码和 API。',
          style: theme.textStyle(
            size: 14,
            weight: FontWeight.w700,
            color: const Color(0xFF7D684B),
          ),
        ),
        const SizedBox(height: 22),
        AnimalButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          onPressed: onClose,
          child: const Text('返回文档'),
        ),
      ],
    );
  }
}

class _PhoneSimulatorFrame extends StatelessWidget {
  const _PhoneSimulatorFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Container(
      width: 402,
      height: height.clamp(680.0, 812.0),
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3C2F),
        borderRadius: BorderRadius.circular(46),
        border: Border.all(color: const Color(0xFF2E251D), width: 4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 16),
            blurRadius: 30,
          ),
          BoxShadow(
            color: Color(0x332B2118),
            offset: Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 6,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2118),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobilePreviewIconButton extends StatelessWidget {
  const _MobilePreviewIconButton({required this.icon, this.onTap});

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

class _DocSearchBox extends StatelessWidget {
  const _DocSearchBox({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: const ValueKey('docs-search-box'),
      child: AnimalInput(
        initialValue: value,
        hintText: '搜索组件 / API / 关键词',
        size: AnimalInputSize.small,
        allowClear: true,
        prefix: const Icon(Icons.search_rounded, size: 16),
        onChanged: onChanged,
        onClear: () => onChanged(''),
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Text(
        query.trim().isEmpty ? '暂无组件' : '没有找到 “${query.trim()}”',
        textAlign: TextAlign.center,
        style: theme.textStyle(
          size: 12,
          weight: FontWeight.w700,
          color: const Color(0xFF9A8465),
        ),
      ),
    );
  }
}

bool _isFirstVisibleInGroup(_DocPage page, List<_DocPage> pages) {
  final index = pages.indexOf(page);
  return index == 0 || pages[index - 1].group != page.group;
}

int _visibleGroupCount(String group, List<_DocPage> pages) {
  return pages.where((page) => page.group == group).length;
}

List<_DocPage> _filterDocPages(List<_DocPage> pages, String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return pages;
  }

  return [
    for (final page in pages)
      if (page.searchText.toLowerCase().contains(normalized)) page,
  ];
}

class _NavGroupHeader extends StatelessWidget {
  const _NavGroupHeader({
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 5),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF19C8B9),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyle(
                size: 12,
                weight: FontWeight.w800,
                color: const Color(0xFF8A7652),
              ),
            ),
          ),
          const SizedBox(width: 6),
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E2),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE5D39D)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              child: Text(
                '$count',
                style: theme.textStyle(
                  size: 10,
                  weight: FontWeight.w800,
                  color: const Color(0xFF9C7A2D),
                ),
              ),
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
  const _DocsHeader({
    required this.onOpenDialog,
    required this.onOpenMobilePreview,
    this.compact = false,
  });

  final VoidCallback onOpenDialog;
  final VoidCallback onOpenMobilePreview;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Padding(
      padding: compact
          ? const EdgeInsets.fromLTRB(0, 12, 0, 18)
          : const EdgeInsets.fromLTRB(40, 32, 40, 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Animal Island Flutter',
                  style: theme.textStyle(
                    size: compact ? 22 : 30,
                    weight: FontWeight.w900,
                  ),
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
          if (!compact) ...[
            const SizedBox(width: 16),
            AnimalButton(
              type: AnimalButtonType.primary,
              icon: const Icon(Icons.phone_iphone_rounded, size: 18),
              onPressed: onOpenMobilePreview,
              child: const Text('手机预览'),
            ),
          ] else ...[
            const SizedBox(width: 12),
            Tooltip(
              message: '手机预览',
              child: AnimalButton(
                type: AnimalButtonType.primary,
                icon: const Icon(Icons.phone_iphone_rounded, size: 17),
                onPressed: onOpenMobilePreview,
                child: const Text('预览'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DocArticle extends StatelessWidget {
  const _DocArticle(
    this.page, {
    this.compact = false,
  });

  final _DocPage page;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          page.title,
          style: theme.textStyle(
            size: compact ? 21 : 24,
            weight: FontWeight.w700,
            color: const Color(0xFF794F27),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: compact ? 72 : 44,
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
        _DocCompactScope(
          compact: compact,
          child: page.body,
        ),
      ],
    );
  }
}

class _DocCompactScope extends InheritedWidget {
  const _DocCompactScope({
    required this.compact,
    required super.child,
  });

  final bool compact;

  static bool of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<_DocCompactScope>()
            ?.compact ??
        false;
  }

  @override
  bool updateShouldNotify(covariant _DocCompactScope oldWidget) {
    return oldWidget.compact != compact;
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
    final compact = _DocCompactScope.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 36),
      padding: EdgeInsets.all(compact ? 14 : 24),
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
    final compact = _DocCompactScope.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          title,
          style: theme.textStyle(
            size: compact ? 17 : 18,
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
    final compact = _DocCompactScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasLabel)
          _DemoLabel(label)
        else
          SizedBox(height: compact ? 10 : 16),
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

    final compact = _DocCompactScope.of(context);
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
        padding: EdgeInsets.all(compact ? 10 : 16),
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
    final compact = _DocCompactScope.of(context);
    return Padding(
      padding: EdgeInsets.only(top: compact ? 24 : 36),
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
    final compact = _DocCompactScope.of(context);

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
                constraints: BoxConstraints(minWidth: compact ? 720 : 820),
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
    final compact = _DocCompactScope.of(context);
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final indexed in children.indexed) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: indexed.$2,
            ),
            if (indexed.$1 != children.length - 1) const SizedBox(height: 12),
          ],
        ],
      );
    }

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
        _DocSection(
          label: 'Form 表单校验',
          box: _DemoBoxStyle.soft,
          child: _InputFormDemo(),
        ),
      ],
      code: _inputCode,
      api: _inputApi,
    );
  }
}

class _InputFormDemo extends StatefulWidget {
  const _InputFormDemo();

  @override
  State<_InputFormDemo> createState() => _InputFormDemoState();
}

class _InputFormDemoState extends State<_InputFormDemo> {
  final _formKey = GlobalKey<FormState>();
  var _saved = '未提交';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimalInputFormField(
              hintText: '岛民昵称',
              allowClear: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入昵称';
                }
                return null;
              },
              onSaved: (value) => _saved = value ?? '',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () {
                    final state = _formKey.currentState!;
                    if (state.validate()) {
                      state.save();
                    } else {
                      _saved = '校验未通过';
                    }
                    setState(() {});
                  },
                  child: const Text('提交'),
                ),
                const SizedBox(width: 12),
                Text(_saved),
              ],
            ),
          ],
        ),
      ),
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
        const _DocSection(
          label: 'Form 表单封装',
          box: _DemoBoxStyle.soft,
          child: _SwitchFormDemo(),
        ),
      ],
      code: _switchCode,
      api: _switchApi,
    );
  }
}

class _SwitchFormDemo extends StatefulWidget {
  const _SwitchFormDemo();

  @override
  State<_SwitchFormDemo> createState() => _SwitchFormDemoState();
}

class _SwitchFormDemoState extends State<_SwitchFormDemo> {
  final _formKey = GlobalKey<FormState>();
  var _saved = '未提交';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimalSwitchFormField(
              checkedChild: const Text('开'),
              uncheckedChild: const Text('关'),
              validator: (value) => value == true ? null : '需要开启岛屿通知',
              onSaved: (value) => _saved = value == true ? '已开启' : '未开启',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () {
                    final state = _formKey.currentState!;
                    if (state.validate()) {
                      state.save();
                      setState(() {});
                    } else {
                      setState(() => _saved = '校验未通过');
                    }
                  },
                  child: const Text('提交'),
                ),
                const SizedBox(width: 12),
                Text(_saved),
              ],
            ),
          ],
        ),
      ),
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
        const _DocSection(
          label: 'Form 表单封装',
          box: _DemoBoxStyle.soft,
          child: _SelectFormDemo(),
        ),
      ],
      code: _selectCode,
      api: _selectApi,
    );
  }
}

class _SelectFormDemo extends StatefulWidget {
  const _SelectFormDemo();

  @override
  State<_SelectFormDemo> createState() => _SelectFormDemoState();
}

class _SelectFormDemoState extends State<_SelectFormDemo> {
  final _formKey = GlobalKey<FormState>();
  var _saved = '未提交';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimalSelectFormField<String>(
              options: _fruitOptions,
              value: null,
              placeholder: '请选择水果',
              validator: (value) => value == null ? '请选择水果' : null,
              onSaved: (value) => _saved = value ?? '',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () {
                    final state = _formKey.currentState!;
                    if (state.validate()) {
                      state.save();
                      setState(() {});
                    } else {
                      setState(() => _saved = '校验未通过');
                    }
                  },
                  child: const Text('提交'),
                ),
                const SizedBox(width: 12),
                Text(_saved),
              ],
            ),
          ],
        ),
      ),
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
        const _DocSection(
          label: 'Form 表单封装',
          box: _DemoBoxStyle.soft,
          child: _CheckboxFormDemo(),
        ),
      ],
      code: _checkboxCode,
      api: _checkboxApi,
    );
  }
}

class _CheckboxFormDemo extends StatefulWidget {
  const _CheckboxFormDemo();

  @override
  State<_CheckboxFormDemo> createState() => _CheckboxFormDemoState();
}

class _CheckboxFormDemoState extends State<_CheckboxFormDemo> {
  final _formKey = GlobalKey<FormState>();
  var _saved = '未提交';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimalCheckboxFormField<String>(
              options: _islandShortOptions,
              validator: (value) =>
                  (value == null || value.isEmpty) ? '至少选择一个岛屿区域' : null,
              onSaved: (value) => _saved = (value ?? const []).join('、'),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () {
                    final state = _formKey.currentState!;
                    if (state.validate()) {
                      state.save();
                      setState(() {});
                    } else {
                      setState(() => _saved = '校验未通过');
                    }
                  },
                  child: const Text('提交'),
                ),
                const SizedBox(width: 12),
                Flexible(child: Text(_saved)),
              ],
            ),
          ],
        ),
      ),
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
        const _DocSection(
          label: 'Form 表单封装',
          box: _DemoBoxStyle.soft,
          child: _RadioFormDemo(),
        ),
      ],
      code: _radioCode,
      api: _radioApi,
    );
  }
}

class _RadioFormDemo extends StatefulWidget {
  const _RadioFormDemo();

  @override
  State<_RadioFormDemo> createState() => _RadioFormDemoState();
}

class _RadioFormDemoState extends State<_RadioFormDemo> {
  final _formKey = GlobalKey<FormState>();
  var _saved = '未提交';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimalRadioFormField<String>(
              options: const [
                AnimalRadioOption(value: 'morning', label: Text('上午出发')),
                AnimalRadioOption(value: 'night', label: Text('夜晚出发')),
              ],
              validator: (value) => value == null ? '请选择出发时间' : null,
              onSaved: (value) => _saved = value ?? '',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () {
                    final state = _formKey.currentState!;
                    if (state.validate()) {
                      state.save();
                      setState(() {});
                    } else {
                      setState(() => _saved = '校验未通过');
                    }
                  },
                  child: const Text('提交'),
                ),
                const SizedBox(width: 12),
                Text(_saved),
              ],
            ),
          ],
        ),
      ),
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

class _ThemeDoc extends StatelessWidget {
  const _ThemeDoc();

  @override
  Widget build(BuildContext context) {
    final forestTheme = AnimalThemeData.fromPrimary(
      const Color(0xFF4E8F75),
      textColor: const Color(0xFF5B4228),
    ).copyWith(
      radius: 22,
      radiusLarge: 30,
    );
    final berryTheme = AnimalThemeData.fromPrimary(
      const Color(0xFFD85C7D),
    ).copyWith(
      fontFamily: 'Noto Sans SC',
    );
    final neutralTheme = AnimalThemeData.fromPrimary(
      const Color(0xFF4E8F75),
      textColor: const Color(0xFF4C3525),
    ).copyWith(
      backgroundColor: const Color(0xFFF4F1E7),
      secondaryBackgroundColor: const Color(0xFFE9DFCC),
      borderColor: const Color(0xFFA89170),
      lightBorderColor: const Color(0xFFE2D5BD),
      disabledTextColor: const Color(0xFFC1AD91),
    );
    final appFontTheme = AnimalThemeData.fallback().copyWith(
      fontFamily: 'Inter',
      fontPackage: null,
      fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
      textHeight: 1.45,
    );

    return _ComponentDoc(
      title: 'Theme',
      tags: const ['全局', '品牌色', '字体'],
      sections: [
        const _DocSection(
          label: '主色切换（点击色块预览）',
          box: _DemoBoxStyle.soft,
          child: _ThemePrimarySwitcher(),
        ),
        _DocSection(
          label: '品牌主色派生卡片',
          box: _DemoBoxStyle.soft,
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ThemePreviewCard(
                title: 'Forest',
                theme: forestTheme,
              ),
              _ThemePreviewCard(
                title: 'Berry',
                theme: berryTheme,
              ),
            ],
          ),
        ),
        _DocSection(
          label: '中立色令牌',
          box: _DemoBoxStyle.soft,
          child: AnimalTheme(
            data: neutralTheme,
            child: const _ThemeNeutralPreview(),
          ),
        ),
        _DocSection(
          label: '外部字体',
          box: _DemoBoxStyle.soft,
          child: AnimalTheme(
            data: appFontTheme,
            child: const Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AnimalTag(
                    color: AnimalTagColor.primary, child: Text('App font')),
                AnimalButton(child: Text('使用应用字体')),
                SizedBox(
                  width: 240,
                  child: AnimalInput(
                    initialValue: 'fontPackage: null',
                  ),
                ),
              ],
            ),
          ),
        ),
        const _DocSection(
          label: '使用建议',
          box: _DemoBoxStyle.dashed,
          child: Text(
            '推荐先使用 AnimalThemeData.fromPrimary 生成品牌主色，再通过 copyWith 覆盖字体、圆角、高度、背景、文字和边框等令牌。组件内部会继续读取 AnimalTheme.of(context)，不需要逐个传色值。',
          ),
        ),
      ],
      code: _themeCode,
      api: _themeApi,
    );
  }
}

class _ThemeNeutralPreview extends StatelessWidget {
  const _ThemeNeutralPreview();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimalInput(
            initialValue: 'Neutral surface',
            prefix: Icon(Icons.tune_rounded),
            shadow: true,
          ),
          SizedBox(height: 12),
          AnimalCheckbox<String>(
            value: ['surface'],
            options: [
              AnimalCheckboxOption(
                value: 'surface',
                label: Text('表单底色跟随主题'),
              ),
              AnimalCheckboxOption(
                value: 'border',
                label: Text('边框与文字派生'),
              ),
            ],
          ),
          SizedBox(height: 12),
          AnimalSegmented<String>(
            defaultValue: 'list',
            options: [
              AnimalSegmentedOption(value: 'list', label: Text('列表')),
              AnimalSegmentedOption(value: 'grid', label: Text('网格')),
            ],
          ),
          SizedBox(height: 12),
          AnimalSlider(value: 42),
          SizedBox(height: 12),
          AnimalSkeleton(active: false, rows: 2, width: 280),
        ],
      ),
    );
  }
}

class _ThemePrimarySwitcher extends StatefulWidget {
  const _ThemePrimarySwitcher();

  @override
  State<_ThemePrimarySwitcher> createState() => _ThemePrimarySwitcherState();
}

class _ThemePrimarySwitcherState extends State<_ThemePrimarySwitcher> {
  var _selected = _themeSwatches.first;

  @override
  Widget build(BuildContext context) {
    final previewTheme = AnimalThemeData.fromPrimary(
      _selected.color,
      textColor: const Color(0xFF5B4228),
    );
    final currentTheme = AnimalTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final swatch in _themeSwatches)
              _ThemeSwatchButton(
                swatch: swatch,
                selected: swatch == _selected,
                onTap: () => setState(() => _selected = swatch),
              ),
          ],
        ),
        const SizedBox(height: 16),
        AnimalTheme(
          data: previewTheme,
          child: Builder(
            builder: (context) {
              final theme = AnimalTheme.of(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_selected.name} ${_selected.hex}',
                    style: theme.textStyle(
                      size: 15,
                      weight: FontWeight.w900,
                      color: theme.primaryActiveColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      AnimalButton(
                        type: AnimalButtonType.primary,
                        onPressed: () {},
                        child: const Text('Primary'),
                      ),
                      const AnimalButton(
                        type: AnimalButtonType.primary,
                        loading: true,
                        child: Text('Loading'),
                      ),
                      const AnimalTag(
                        color: AnimalTagColor.primary,
                        child: Text('Tag'),
                      ),
                      const SizedBox(
                        width: 160,
                        child: AnimalProgress(value: 0.64),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        AnimalTabs(
                          defaultActiveKey: 'button',
                          items: [
                            AnimalTabItem(
                              key: 'button',
                              label: Text('Button'),
                              child: Text('主按钮、标签、进度条会跟随主色。'),
                            ),
                            AnimalTabItem(
                              key: 'form',
                              label: Text('Form'),
                              child: Text('输入与选择组件继续保持暖色底。'),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        AnimalInput(
                            initialValue: 'AnimalThemeData.fromPrimary'),
                        SizedBox(height: 12),
                        AnimalSlider(value: 58),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Flutter 中主色通过 AnimalTheme(data: AnimalThemeData.fromPrimary(...)) 注入；这个演示只影响下方预览区域。',
          style: currentTheme.textStyle(
            size: 12,
            color: const Color(0xFFA0936E),
          ),
        ),
      ],
    );
  }
}

class _ThemeSwatchButton extends StatelessWidget {
  const _ThemeSwatchButton({
    required this.swatch,
    required this.selected,
    required this.onTap,
  });

  final _ThemeSwatch swatch;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final borderColor =
        selected ? theme.primaryActiveColor : const Color(0xFFD8CCB8);

    return Tooltip(
      message: swatch.hex,
      waitDuration: const Duration(milliseconds: 250),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 92,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFFFF8D6) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: selected ? 2 : 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFBDAEA0).withValues(alpha: 0.34),
                  offset: Offset(0, selected ? 3 : 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: swatch.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    swatch.name,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle(
                      size: 12,
                      weight: FontWeight.w800,
                      color: const Color(0xFF725D42),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  const _ThemePreviewCard({
    required this.title,
    required this.theme,
  });

  final String title;
  final AnimalThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AnimalTheme(
      data: theme,
      child: SizedBox(
        width: 280,
        child: AnimalCard(
          color: AnimalCardColor.defaultColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textStyle(size: 18, weight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AnimalButton(
                      type: AnimalButtonType.primary,
                      onPressed: () {},
                      child: const Text('Primary'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimalTag(
                    color: AnimalTagColor.primary,
                    child: const Text('Tag'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AnimalProgress(value: 0.62, color: theme.primaryColor),
            ],
          ),
        ),
      ),
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
        const _DocSection(
          label: 'Form 表单封装',
          box: _DemoBoxStyle.soft,
          child: _SliderFormDemo(),
        ),
      ],
      code: _sliderCode,
      api: _sliderApi,
    );
  }
}

class _SliderFormDemo extends StatefulWidget {
  const _SliderFormDemo();

  @override
  State<_SliderFormDemo> createState() => _SliderFormDemoState();
}

class _SliderFormDemoState extends State<_SliderFormDemo> {
  final _formKey = GlobalKey<FormState>();
  var _saved = '未提交';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimalSliderFormField(
              defaultValue: 30,
              divisions: 10,
              validator: (value) => (value ?? 0) >= 50 ? null : '音量至少需要 50',
              onSaved: (value) => _saved = '${(value ?? 0).round()}',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () {
                    final state = _formKey.currentState!;
                    if (state.validate()) {
                      state.save();
                      setState(() {});
                    } else {
                      setState(() => _saved = '校验未通过');
                    }
                  },
                  child: const Text('提交'),
                ),
                const SizedBox(width: 12),
                Text(_saved),
              ],
            ),
          ],
        ),
      ),
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
        const _DocSection(
          label: 'Form 表单封装',
          box: _DemoBoxStyle.soft,
          child: _RateFormDemo(),
        ),
      ],
      code: _rateCode,
      api: _rateApi,
    );
  }
}

class _RateFormDemo extends StatefulWidget {
  const _RateFormDemo();

  @override
  State<_RateFormDemo> createState() => _RateFormDemoState();
}

class _RateFormDemoState extends State<_RateFormDemo> {
  final _formKey = GlobalKey<FormState>();
  var _saved = '未提交';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimalRateFormField(
              defaultValue: 0,
              validator: (value) => (value ?? 0) > 0 ? null : '请先给出评分',
              onSaved: (value) => _saved = '${value ?? 0} 星',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () {
                    final state = _formKey.currentState!;
                    if (state.validate()) {
                      state.save();
                      setState(() {});
                    } else {
                      setState(() => _saved = '校验未通过');
                    }
                  },
                  child: const Text('提交'),
                ),
                const SizedBox(width: 12),
                Text(_saved),
              ],
            ),
          ],
        ),
      ),
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

class _FormDoc extends StatelessWidget {
  const _FormDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Form',
      tags: ['布局', '校验'],
      sections: [
        _DocSection(
          label: 'vertical 默认布局',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 360,
            child: AnimalForm(
              child: Column(
                children: [
                  AnimalFormItem(
                    label: Text('岛民昵称'),
                    required: true,
                    help: Text('显示在岛民名片上。'),
                    child: AnimalInput(hintText: '请输入昵称', allowClear: true),
                  ),
                  AnimalFormItem(
                    label: Text('留言'),
                    child: AnimalTextarea(
                      hintText: '写下今天的岛屿计划',
                      rows: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _DocSection(
          label: 'horizontal 标签宽度',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 520,
            child: AnimalForm(
              layout: AnimalFormLayout.horizontal,
              labelWidth: 96,
              child: Column(
                children: [
                  AnimalFormItem(
                    label: Text('出发地点'),
                    required: true,
                    child: AnimalInput(initialValue: '机场码头'),
                  ),
                  AnimalFormItem(
                    label: Text('状态'),
                    errorText: '请确认今天是否开放登岛。',
                    child: AnimalSwitch(defaultValue: false),
                  ),
                ],
              ),
            ),
          ),
        ),
        _DocSection(
          label: 'inline 紧凑排列',
          box: _DemoBoxStyle.soft,
          child: AnimalForm(
            layout: AnimalFormLayout.inline,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AnimalFormItem(
                  label: Text('关键词'),
                  margin: EdgeInsets.zero,
                  child: AnimalSearchInput(hintText: '搜索岛民'),
                ),
                AnimalFormItem(
                  label: Text('数量'),
                  margin: EdgeInsets.zero,
                  child: AnimalNumberInput(defaultValue: 2, min: 0, max: 9),
                ),
              ],
            ),
          ),
        ),
      ],
      code: _formCode,
      api: _formApi,
    );
  }
}

class _InputPlusDoc extends StatelessWidget {
  const _InputPlusDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Input Plus',
      tags: ['输入', '表单'],
      sections: [
        _DocSection(
          label: 'Textarea 多行输入',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 380,
            child: AnimalTextarea(
              initialValue: '今天想去海边捡贝壳，再整理一下花园。',
              rows: 4,
              maxLength: 80,
              allowClear: true,
            ),
          ),
        ),
        _DocSection(
          label: 'Password / Search / Number',
          box: _DemoBoxStyle.soft,
          child: _InputPlusDemo(),
        ),
      ],
      code: _inputPlusCode,
      api: _inputPlusApi,
    );
  }
}

class _InputPlusDemo extends StatefulWidget {
  const _InputPlusDemo();

  @override
  State<_InputPlusDemo> createState() => _InputPlusDemoState();
}

class _InputPlusDemoState extends State<_InputPlusDemo> {
  var _searched = '未搜索';
  var _count = 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AnimalPasswordInput(initialValue: 'turnip-price'),
          const SizedBox(height: 12),
          AnimalSearchInput(
            hintText: '搜索收藏品',
            onSearch: (value) =>
                setState(() => _searched = value.isEmpty ? '空关键词' : value),
          ),
          const SizedBox(height: 8),
          Text('搜索结果：$_searched'),
          const SizedBox(height: 12),
          AnimalNumberInput(
            value: _count,
            min: 0,
            max: 10,
            onChanged: (value) => setState(() => _count = value.round()),
          ),
          const SizedBox(height: 8),
          Text('当前数量：$_count'),
        ],
      ),
    );
  }
}

class _PopoverDoc extends StatelessWidget {
  const _PopoverDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Popover',
      tags: ['浮层', '说明'],
      sections: [
        _DocSection(
          label: 'click 触发',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalPopover(
                title: Text('岛屿提示'),
                content: Text('今日高价收购大头菜，记得去商店看看。'),
                child: AnimalButton(
                  type: AnimalButtonType.primary,
                  child: Text('点击查看'),
                ),
              ),
              AnimalPopover(
                placement: AnimalPopoverPlacement.right,
                content: Text('右侧气泡会自动避开屏幕边缘。'),
                child: AnimalButton(child: Text('右侧')),
              ),
            ],
          ),
        ),
        _DocSection(
          label: 'hover 与四个方向',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              _PopoverPlacementButton(
                text: 'Top',
                placement: AnimalPopoverPlacement.top,
              ),
              _PopoverPlacementButton(
                text: 'Right',
                placement: AnimalPopoverPlacement.right,
              ),
              _PopoverPlacementButton(
                text: 'Bottom',
                placement: AnimalPopoverPlacement.bottom,
              ),
              _PopoverPlacementButton(
                text: 'Left',
                placement: AnimalPopoverPlacement.left,
              ),
            ],
          ),
        ),
      ],
      code: _popoverCode,
      api: _popoverApi,
    );
  }
}

class _PopoverPlacementButton extends StatelessWidget {
  const _PopoverPlacementButton({
    required this.text,
    required this.placement,
  });

  final String text;
  final AnimalPopoverPlacement placement;

  @override
  Widget build(BuildContext context) {
    return AnimalPopover(
      trigger: AnimalPopoverTrigger.hover,
      placement: placement,
      content: Text('$text 方向提示'),
      child: AnimalButton(child: Text(text)),
    );
  }
}

class _DropdownDoc extends StatelessWidget {
  const _DropdownDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Dropdown',
      tags: const ['菜单', '操作'],
      sections: [
        const _DocSection(
          label: '基础菜单',
          box: _DemoBoxStyle.soft,
          child: _DropdownDemo(),
        ),
        _DocSection(
          label: '右侧弹出',
          box: _DemoBoxStyle.soft,
          child: AnimalDropdown<String>(
            placement: AnimalPopoverPlacement.right,
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
            ],
            onChanged: (value) => AnimalMessage.info(
              context,
              Text('选择了 $value'),
            ),
            child: const AnimalButton(child: Text('更多操作')),
          ),
        ),
      ],
      code: _dropdownCode,
      api: _dropdownApi,
    );
  }
}

class _DropdownDemo extends StatefulWidget {
  const _DropdownDemo();

  @override
  State<_DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<_DropdownDemo> {
  var _selected = '未选择';

  @override
  Widget build(BuildContext context) {
    return _DemoRow(
      children: [
        AnimalDropdown<String>(
          items: const [
            AnimalDropdownItem(
              value: 'copy',
              icon: Icon(Icons.copy_rounded),
              label: Text('复制地址'),
            ),
            AnimalDropdownItem(
              value: 'edit',
              icon: Icon(Icons.edit_rounded),
              label: Text('编辑信息'),
            ),
            AnimalDropdownItem(
              value: 'delete',
              icon: Icon(Icons.delete_rounded),
              label: Text('删除记录'),
              disabled: true,
            ),
          ],
          onChanged: (value) => setState(() => _selected = value),
          child: const AnimalButton(
            type: AnimalButtonType.primary,
            child: Text('打开菜单'),
          ),
        ),
        Text('当前操作：$_selected'),
      ],
    );
  }
}

class _DrawerDoc extends StatelessWidget {
  const _DrawerDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Drawer',
      tags: const ['浮层', '面板'],
      sections: [
        _DocSection(
          label: '左右抽屉',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              Builder(
                builder: (context) => AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () => _showDrawer(context),
                  child: const Text('右侧抽屉'),
                ),
              ),
              Builder(
                builder: (context) => AnimalButton(
                  onPressed: () => _showDrawer(
                    context,
                    placement: AnimalDrawerPlacement.left,
                  ),
                  child: const Text('左侧抽屉'),
                ),
              ),
            ],
          ),
        ),
      ],
      code: _drawerCode,
      api: _drawerApi,
    );
  }

  static void _showDrawer(
    BuildContext context, {
    AnimalDrawerPlacement placement = AnimalDrawerPlacement.right,
  }) {
    AnimalDrawer.show<void>(
      context: context,
      placement: placement,
      title: const Text('岛屿背包'),
      footer: AnimalButton(
        type: AnimalButtonType.primary,
        block: true,
        onPressed: () => Navigator.of(context).maybePop(),
        child: const Text('整理完成'),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimalAlert(
            type: AnimalAlertType.info,
            child: Text('抽屉适合展示表单、详情和辅助操作。'),
          ),
          SizedBox(height: 16),
          AnimalDescriptions(
            column: 1,
            items: [
              AnimalDescriptionItem(label: Text('容量'), child: Text('24 / 40')),
              AnimalDescriptionItem(label: Text('稀有物'), child: Text('金矿石 x 2')),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfirmDialogDoc extends StatelessWidget {
  const _ConfirmDialogDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'ConfirmDialog',
      tags: const ['反馈', '确认'],
      sections: [
        _DocSection(
          label: '确认流程',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              Builder(
                builder: (context) => AnimalButton(
                  type: AnimalButtonType.primary,
                  onPressed: () => _openConfirm(context),
                  child: const Text('提交确认'),
                ),
              ),
              Builder(
                builder: (context) => AnimalButton(
                  danger: true,
                  onPressed: () => _openDangerConfirm(context),
                  child: const Text('危险确认'),
                ),
              ),
            ],
          ),
        ),
      ],
      code: _confirmDialogCode,
      api: _confirmDialogApi,
    );
  }

  static Future<void> _openConfirm(BuildContext context) async {
    final result = await AnimalConfirmDialog.show(
      context: context,
      title: const Text('提交订单'),
      content: const Text('确定要提交这批岛屿物资吗？'),
    );
    if (context.mounted) {
      AnimalMessage.info(context, Text('结果：${result == true ? '确认' : '取消'}'));
    }
  }

  static Future<void> _openDangerConfirm(BuildContext context) async {
    await AnimalConfirmDialog.show(
      context: context,
      title: const Text('删除记录'),
      danger: true,
      okText: '删除',
      content: const Text('删除后无法恢复，确定继续吗？'),
    );
  }
}

class _DescriptionsDoc extends StatelessWidget {
  const _DescriptionsDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Descriptions',
      tags: ['详情', '展示'],
      sections: [
        _DocSection(
          label: '多列详情',
          box: _DemoBoxStyle.soft,
          child: AnimalDescriptions(
            title: Text('岛屿信息'),
            items: [
              AnimalDescriptionItem(label: Text('名称'), child: Text('星露岛')),
              AnimalDescriptionItem(label: Text('水果'), child: Text('桃子')),
              AnimalDescriptionItem(label: Text('天气'), child: Text('晴朗')),
              AnimalDescriptionItem(
                label: Text('公告'),
                span: 2,
                child: Text('今晚八点有烟花大会，请提前到广场集合。'),
              ),
              AnimalDescriptionItem(label: Text('访客'), child: Text('骆岚')),
            ],
          ),
        ),
        _DocSection(
          label: 'vertical 纵向标签',
          box: _DemoBoxStyle.soft,
          child: AnimalDescriptions(
            column: 2,
            layout: AnimalDescriptionsLayout.vertical,
            items: [
              AnimalDescriptionItem(label: Text('任务'), child: Text('整理花园')),
              AnimalDescriptionItem(label: Text('负责人'), child: Text('西施惠')),
              AnimalDescriptionItem(
                label: Text('备注'),
                span: 2,
                child: Text('适合在详情页、抽屉和弹窗里展示只读数据。'),
              ),
            ],
          ),
        ),
      ],
      code: _descriptionsCode,
      api: _descriptionsApi,
    );
  }
}

class _StatisticDoc extends StatelessWidget {
  const _StatisticDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Statistic',
      tags: ['数据', '仪表盘'],
      sections: [
        _DocSection(
          label: '指标卡片',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalStatistic(
                title: Text('今日访客'),
                value: 128,
                suffix: Text('人'),
                description: Text('比昨天 +18'),
              ),
              AnimalStatistic(
                title: Text('大头菜价格'),
                value: 586,
                prefix: Icon(Icons.spa_rounded),
                suffix: Text('铃钱'),
                color: Color(0xFFE5A928),
              ),
              AnimalStatistic(
                title: Text('完成率'),
                value: 92.5,
                suffix: Text('%'),
                color: Color(0xFF4E8F75),
              ),
            ],
          ),
        ),
      ],
      code: _statisticCode,
      api: _statisticApi,
    );
  }
}

class _TimelineDoc extends StatefulWidget {
  const _TimelineDoc();

  @override
  State<_TimelineDoc> createState() => _TimelineDocState();
}

class _TimelineDocState extends State<_TimelineDoc> {
  var _activeStep = '整理背包';

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Timeline',
      tags: const ['流程', '日志'],
      sections: [
        _DocSection(
          label: '状态时间线',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 520,
            child: AnimalTimeline(
              items: [
                AnimalTimelineItem(
                  title: const Text('整理背包'),
                  description: const Text('检查工具和素材是否齐全。'),
                  time: const Text('09:00'),
                  status: AnimalTimelineItemStatus.success,
                  icon: const Icon(Icons.check_rounded),
                  onTap: () => setState(() => _activeStep = '整理背包'),
                ),
                AnimalTimelineItem(
                  title: const Text('出发采集'),
                  description: const Text('前往北侧森林采集木材。'),
                  time: const Text('10:30'),
                  status: AnimalTimelineItemStatus.primary,
                  onTap: () => setState(() => _activeStep = '出发采集'),
                ),
                const AnimalTimelineItem(
                  title: Text('等待确认'),
                  description: Text('服务处正在确认今日活动安排。'),
                  time: Text('12:00'),
                  status: AnimalTimelineItemStatus.warning,
                  disabled: true,
                ),
                const AnimalTimelineItem(
                  title: Text('完成归档'),
                  time: Text('待定'),
                ),
              ],
            ),
          ),
        ),
        _DocSection(
          label: '可点击节点',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              AnimalTag(child: Text('当前：$_activeStep')),
              const Text('带 onTap 的节点支持 hover、小手和 Enter / Space。'),
            ],
          ),
        ),
      ],
      code: _timelineCode,
      api: _timelineApi,
    );
  }
}

class _CalendarDoc extends StatefulWidget {
  const _CalendarDoc();

  @override
  State<_CalendarDoc> createState() => _CalendarDocState();
}

class _CalendarDocState extends State<_CalendarDoc> {
  var _selected = DateTime(2026, 5, 21);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Calendar',
      tags: const ['日期', '业务'],
      sections: [
        _DocSection(
          label: '受控日期选择',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              AnimalCalendar(
                value: _selected,
                month: DateTime(_selected.year, _selected.month),
                onChanged: (value) => setState(() => _selected = value),
              ),
              Text(
                  '选中日期：${_selected.year}-${_selected.month}-${_selected.day}'),
            ],
          ),
        ),
        _DocSection(
          label: '键盘选择日期',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              AnimalCalendar(
                value: _selected,
                month: DateTime(_selected.year, _selected.month),
                firstDate: DateTime(2026, 5, 1),
                lastDate: DateTime(2026, 6, 30),
                onChanged: (value) => setState(() => _selected = value),
              ),
              const Text('聚焦日期后可用方向键移动，PageUp / PageDown 切换月份。'),
            ],
          ),
        ),
        _DocSection(
          label: '限制可选范围',
          box: _DemoBoxStyle.soft,
          child: AnimalCalendar(
            defaultValue: DateTime(2026, 5, 16),
            month: DateTime(2026, 5),
            firstDate: DateTime(2026, 5, 10),
            lastDate: DateTime(2026, 5, 24),
          ),
        ),
        _DocSection(
          label: 'Form 表单封装',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 460,
            child: AnimalForm(
              formKey: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  AnimalFormItem(
                    label: const Text('预约日期'),
                    required: true,
                    help: const Text('可直接接入 Flutter Form 校验和保存流程。'),
                    child: AnimalCalendarFormField(
                      defaultValue: DateTime(2026, 5, 18),
                      month: DateTime(2026, 5),
                      firstDate: DateTime(2026, 5, 10),
                      lastDate: DateTime(2026, 5, 24),
                      validator: (value) => value == null ? '请选择预约日期' : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimalButton(
                      type: AnimalButtonType.primary,
                      onPressed: () => _formKey.currentState?.validate(),
                      child: const Text('校验日期'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _calendarCode,
      api: _calendarApi,
    );
  }
}

class _UploadDoc extends StatefulWidget {
  const _UploadDoc();

  @override
  State<_UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<_UploadDoc> {
  final _formKey = GlobalKey<FormState>();
  var _files = const [
    AnimalUploadFile(
      name: 'island-plan.pdf',
      status: AnimalUploadStatus.uploading,
      progress: 0.58,
      size: '2.4 MB',
    ),
    AnimalUploadFile(
      name: 'market-photo.png',
      status: AnimalUploadStatus.done,
      size: '860 KB',
      message: '上传完成',
    ),
    AnimalUploadFile(
      name: 'broken-map.zip',
      status: AnimalUploadStatus.error,
      message: '文件格式需要重新确认',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Upload',
      tags: const ['上传', '队列'],
      sections: [
        _DocSection(
          label: '上传入口和文件列表',
          box: _DemoBoxStyle.soft,
          child: _DemoColumn(
            children: [
              SizedBox(
                width: 460,
                child: AnimalUpload(
                  files: _files,
                  onTap: () => AnimalMessage.info(context, const Text('选择文件')),
                  onRemove: (file) {
                    setState(() {
                      _files = _files
                          .where((item) => item.name != file.name)
                          .toList(growable: false);
                    });
                  },
                ),
              ),
              const Text('上传区域获得焦点后支持 Enter / Space 触发。'),
            ],
          ),
        ),
        _DocSection(
          label: '键盘触发上传',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 420,
            child: AnimalUpload(
              title: '键盘可达上传',
              hint: '点击后按 Enter / Space 也会触发上传动作',
              onTap: () => AnimalMessage.info(context, const Text('键盘触发上传')),
            ),
          ),
        ),
        const _DocSection(
          label: '禁用上传',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 420,
            child: AnimalUpload(
              disabled: true,
              title: '暂停上传',
              hint: '当前岛屿网络维护中',
            ),
          ),
        ),
        _DocSection(
          label: 'Form 表单封装',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 460,
            child: AnimalForm(
              formKey: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  AnimalFormItem(
                    label: const Text('资料附件'),
                    required: true,
                    child: AnimalUploadFormField(
                      files: _files,
                      title: '上传资料',
                      hint: '至少保留一个资料文件',
                      onTap: () =>
                          AnimalMessage.info(context, const Text('选择资料')),
                      validator: (files) =>
                          files == null || files.isEmpty ? '请上传资料附件' : null,
                      onChanged: (files) => setState(() => _files = files),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimalButton(
                      type: AnimalButtonType.primary,
                      onPressed: () => _formKey.currentState?.validate(),
                      child: const Text('校验附件'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _uploadCode,
      api: _uploadApi,
    );
  }
}

class _TreeDoc extends StatefulWidget {
  const _TreeDoc();

  @override
  State<_TreeDoc> createState() => _TreeDocState();
}

class _TreeDocState extends State<_TreeDoc> {
  final _formKey = GlobalKey<FormState>();
  var _selected = 'rose';

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Tree',
      tags: const ['层级', '选择'],
      sections: [
        _DocSection(
          label: '树形选择',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 360,
            child: AnimalTree<String>(
              selectedValue: _selected,
              defaultExpandedValues: const ['plants', 'animals'],
              onChanged: (value) => setState(() => _selected = value),
              nodes: _treeNodes,
            ),
          ),
        ),
        _DocSection(
          label: '当前选择',
          box: _DemoBoxStyle.soft,
          child: Text('当前节点：$_selected'),
        ),
        _DocSection(
          label: 'Form 表单封装和键盘操作',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 420,
            child: AnimalForm(
              formKey: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  AnimalFormItem(
                    label: const Text('图鉴节点'),
                    required: true,
                    help: const Text('聚焦节点后可用 Enter/Space 选择，左右方向键展开或收起。'),
                    child: AnimalTreeFormField<String>(
                      nodes: _treeNodes,
                      defaultValue: _selected,
                      defaultExpandedValues: const ['plants', 'animals'],
                      validator: (value) => value == null ? '请选择一个图鉴节点' : null,
                      onChanged: (value) => setState(() => _selected = value),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimalButton(
                      type: AnimalButtonType.primary,
                      onPressed: () => _formKey.currentState?.validate(),
                      child: const Text('校验节点'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _treeCode,
      api: _treeApi,
    );
  }
}

class _ResultDoc extends StatelessWidget {
  const _ResultDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Result',
      tags: const ['反馈', '页面状态'],
      sections: [
        _DocSection(
          label: '成功结果',
          box: _DemoBoxStyle.soft,
          child: SizedBox(
            width: 420,
            child: AnimalResult(
              status: AnimalResultStatus.success,
              title: Text('岛屿资料提交成功'),
              description: Text('新的访客计划已经同步到服务处。'),
              extra: AnimalTag(
                color: AnimalTagColor.success,
                child: Text('已归档'),
              ),
              action: AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: () {},
                child: Text('返回列表'),
              ),
            ),
          ),
        ),
        const _DocSection(
          label: '警告、错误和信息',
          box: _DemoBoxStyle.soft,
          child: _DemoRow(
            children: [
              SizedBox(
                width: 250,
                child: AnimalResult(
                  status: AnimalResultStatus.warning,
                  title: Text('需要确认'),
                  description: Text('还有任务未完成。'),
                ),
              ),
              SizedBox(
                width: 250,
                child: AnimalResult(
                  status: AnimalResultStatus.error,
                  title: Text('提交失败'),
                  description: Text('请检查网络后重试。'),
                ),
              ),
            ],
          ),
        ),
      ],
      code: _resultCode,
      api: _resultApi,
    );
  }
}

class _MobileNavBarDoc extends StatelessWidget {
  const _MobileNavBarDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'MobileNavBar',
      tags: ['移动端', '导航'],
      sections: [
        _DocSection(
          label: '基础导航栏',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: AnimalMobileNavBar(
              title: Text('岛屿背包'),
              showBackButton: true,
              safeAreaTop: false,
              trailing: Icon(Icons.more_horiz_rounded),
            ),
          ),
        ),
      ],
      code: _mobileNavBarCode,
      api: _mobileNavBarApi,
    );
  }
}

class _MobileBottomBarDoc extends StatelessWidget {
  const _MobileBottomBarDoc({
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'BottomBar',
      tags: const ['移动端', '导航'],
      sections: [
        _DocSection(
          label: '底部导航',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: AnimalBottomBar(
              currentIndex: currentIndex,
              onChanged: onChanged,
              safeAreaBottom: false,
              items: const [
                AnimalBottomBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: Text('首页'),
                ),
                AnimalBottomBarItem(
                  icon: Icon(Icons.widgets_rounded),
                  activeIcon: Icon(Icons.widgets_rounded),
                  label: Text('组件'),
                  badge: AnimalBadge(dot: true),
                ),
                AnimalBottomBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: Text('我的'),
                ),
              ],
            ),
          ),
        ),
      ],
      code: _mobileBottomBarCode,
      api: _mobileBottomBarApi,
    );
  }
}

class _MobileBottomSheetDoc extends StatelessWidget {
  const _MobileBottomSheetDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'BottomSheet',
      tags: const ['移动端', '浮层'],
      sections: [
        _DocSection(
          label: '打开底部弹层',
          box: _DemoBoxStyle.soft,
          child: AnimalButton(
            type: AnimalButtonType.primary,
            onPressed: () {
              AnimalBottomSheet.show<void>(
                context: context,
                title: const Text('岛屿计划'),
                child: const AnimalCellGroup(
                  children: [
                    AnimalListTile(
                      leading: Icon(Icons.local_florist_rounded),
                      title: Text('整理花园'),
                      subtitle: Text('今天 16:00'),
                    ),
                    AnimalListTile(
                      leading: Icon(Icons.shopping_bag_rounded),
                      title: Text('采购家具'),
                      subtitle: Text('狸然超市'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('打开 BottomSheet'),
          ),
        ),
      ],
      code: _mobileBottomSheetCode,
      api: _mobileBottomSheetApi,
    );
  }
}

class _MobileActionSheetDoc extends StatelessWidget {
  const _MobileActionSheetDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'ActionSheet',
      tags: const ['移动端', '操作'],
      sections: [
        _DocSection(
          label: '触摸操作面板',
          box: _DemoBoxStyle.soft,
          child: AnimalButton(
            type: AnimalButtonType.primary,
            onPressed: () async {
              final value = await AnimalActionSheet.show<String>(
                context: context,
                title: const Text('更多操作'),
                message: const Text('选择一个适合触摸场景的操作。'),
                actions: const [
                  AnimalActionSheetAction(
                    value: 'share',
                    icon: Icon(Icons.ios_share_rounded),
                    label: Text('分享岛屿'),
                  ),
                  AnimalActionSheetAction(
                    value: 'archive',
                    icon: Icon(Icons.inventory_2_rounded),
                    label: Text('归档记录'),
                  ),
                  AnimalActionSheetAction(
                    value: 'delete',
                    icon: Icon(Icons.delete_rounded),
                    label: Text('删除记录'),
                    destructive: true,
                  ),
                ],
              );
              if (context.mounted && value != null) {
                AnimalMessage.info(context, Text('选择了 $value'));
              }
            },
            child: const Text('打开 ActionSheet'),
          ),
        ),
      ],
      code: _mobileActionSheetCode,
      api: _mobileActionSheetApi,
    );
  }
}

class _MobileListTileDoc extends StatelessWidget {
  const _MobileListTileDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'ListTile',
      tags: ['移动端', '列表'],
      sections: [
        _DocSection(
          label: '列表项状态',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: AnimalCellGroup(
              children: [
                AnimalListTile(
                  leading: Icon(Icons.notifications_rounded),
                  title: Text('岛屿通知'),
                  subtitle: Text('访客抵达时提醒我'),
                  trailing: AnimalSwitch(size: AnimalSwitchSize.small),
                ),
                AnimalListTile(
                  leading: Icon(Icons.delete_rounded),
                  title: Text('删除记录'),
                  destructive: true,
                  showChevron: false,
                ),
                AnimalListTile(
                  leading: Icon(Icons.lock_rounded),
                  title: Text('未开放功能'),
                  subtitle: Text('禁用态不会触发操作'),
                  disabled: true,
                ),
              ],
            ),
          ),
        ),
      ],
      code: _mobileListTileCode,
      api: _mobileListTileApi,
    );
  }
}

class _MobileCellGroupDoc extends StatelessWidget {
  const _MobileCellGroupDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'CellGroup',
      tags: ['移动端', '列表'],
      sections: [
        _DocSection(
          label: '单元格组',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: AnimalCellGroup(
              children: [
                AnimalListTile(
                  leading: Icon(Icons.person_rounded),
                  title: Text('个人资料'),
                ),
                AnimalListTile(
                  leading: Icon(Icons.palette_rounded),
                  title: Text('主题偏好'),
                  subtitle: Text('主色、字体和圆角'),
                ),
                AnimalListTile(
                  leading: Icon(Icons.logout_rounded),
                  title: Text('退出登录'),
                  destructive: true,
                  showChevron: false,
                ),
              ],
            ),
          ),
        ),
      ],
      code: _mobileCellGroupCode,
      api: _mobileCellGroupApi,
    );
  }
}

class _MobileSearchBarDoc extends StatelessWidget {
  const _MobileSearchBarDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'SearchBar',
      tags: const ['移动端', '表单'],
      sections: [
        _DocSection(
          label: '搜索栏与取消操作',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AnimalMobileSearchBar(
                initialValue: '樱桃',
                hintText: '搜索岛屿商品',
                showCancel: true,
                onSearch: (value) =>
                    AnimalMessage.info(context, Text('搜索 $value')),
              ),
            ),
          ),
        ),
      ],
      code: _mobileSearchBarCode,
      api: _mobileSearchBarApi,
    );
  }
}

class _MobilePickerDoc extends StatelessWidget {
  const _MobilePickerDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'Picker',
      tags: const ['移动端', '选择'],
      sections: [
        _DocSection(
          label: '底部选择器',
          box: _DemoBoxStyle.soft,
          child: AnimalButton(
            type: AnimalButtonType.primary,
            onPressed: () async {
              final value = await AnimalPicker.show<String>(
                context: context,
                title: const Text('选择配送岛屿'),
                message: const Text('已禁用的岛屿不会触发选择。'),
                value: 'north',
                options: const [
                  AnimalPickerOption(
                    value: 'north',
                    leading: Icon(Icons.park_rounded),
                    label: Text('北岸森林岛'),
                    subtitle: Text('预计 30 分钟送达'),
                  ),
                  AnimalPickerOption(
                    value: 'south',
                    leading: Icon(Icons.water_rounded),
                    label: Text('南湾海风岛'),
                    subtitle: Text('预计 45 分钟送达'),
                  ),
                  AnimalPickerOption(
                    value: 'locked',
                    leading: Icon(Icons.lock_rounded),
                    label: Text('星愿岛'),
                    subtitle: Text('暂未开放'),
                    disabled: true,
                  ),
                ],
              );
              if (context.mounted && value != null) {
                AnimalMessage.success(context, Text('选择了 $value'));
              }
            },
            child: const Text('打开 Picker'),
          ),
        ),
        const _DocSection(
          label: '页面内选择列表',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: AnimalPicker<String>(
                value: 'south',
                onChanged: _noopStringChanged,
                options: [
                  AnimalPickerOption(
                    value: 'north',
                    label: Text('北岸森林岛'),
                  ),
                  AnimalPickerOption(
                    value: 'south',
                    label: Text('南湾海风岛'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _mobilePickerCode,
      api: _mobilePickerApi,
    );
  }
}

class _MobileDatePickerDoc extends StatelessWidget {
  const _MobileDatePickerDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'DatePicker',
      tags: const ['移动端', '日期'],
      sections: [
        _DocSection(
          label: '底部日期选择',
          box: _DemoBoxStyle.soft,
          child: AnimalButton(
            type: AnimalButtonType.primary,
            onPressed: () async {
              final date = await AnimalMobileDatePicker.show(
                context: context,
                value: DateTime(2026, 5, 22),
                firstDate: DateTime(2026, 5, 1),
                lastDate: DateTime(2026, 6, 30),
              );
              if (context.mounted && date != null) {
                AnimalMessage.success(
                  context,
                  Text('预约 ${date.month}/${date.day}'),
                );
              }
            },
            child: const Text('打开 DatePicker'),
          ),
        ),
        _DocSection(
          label: '嵌入页面内容',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AnimalMobileDatePicker(
                value: DateTime(2026, 5, 22),
                firstDate: DateTime(2026, 5),
                lastDate: DateTime(2026, 6, 30),
                onChanged: (date) => AnimalMessage.info(
                  context,
                  Text('选择 ${date.month}/${date.day}'),
                ),
              ),
            ),
          ),
        ),
      ],
      code: _mobileDatePickerCode,
      api: _mobileDatePickerApi,
    );
  }
}

class _MobileStepperDoc extends StatelessWidget {
  const _MobileStepperDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Stepper',
      tags: ['移动端', '数量'],
      sections: [
        _DocSection(
          label: '数量步进',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('樱桃果篮'),
                  AnimalMobileStepper(
                    defaultValue: 2,
                    min: 0,
                    max: 9,
                    onChanged: _noopNumChanged,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _mobileStepperCode,
      api: _mobileStepperApi,
    );
  }
}

class _MobileSwipeActionDoc extends StatelessWidget {
  const _MobileSwipeActionDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'SwipeAction',
      tags: const ['移动端', '列表'],
      sections: [
        _DocSection(
          label: '左滑露出快捷操作',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AnimalSwipeAction(
                actions: [
                  AnimalSwipeActionItem(
                    icon: const Icon(Icons.archive_rounded),
                    label: const Text('归档'),
                    onTap: () => AnimalMessage.info(context, const Text('已归档')),
                  ),
                  AnimalSwipeActionItem(
                    icon: const Icon(Icons.delete_rounded),
                    label: const Text('删除'),
                    destructive: true,
                    onTap: () =>
                        AnimalMessage.error(context, const Text('已删除')),
                  ),
                ],
                child: const AnimalListTile(
                  leading: Icon(Icons.receipt_long_rounded),
                  title: Text('订单 #A001'),
                  subtitle: Text('向左拖动查看操作'),
                ),
              ),
            ),
          ),
        ),
      ],
      code: _mobileSwipeActionCode,
      api: _mobileSwipeActionApi,
    );
  }
}

class _MobilePullRefreshDoc extends StatefulWidget {
  const _MobilePullRefreshDoc();

  @override
  State<_MobilePullRefreshDoc> createState() => _MobilePullRefreshDocState();
}

class _MobilePullRefreshDocState extends State<_MobilePullRefreshDoc> {
  int _refreshCount = 0;

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) {
      return;
    }
    setState(() {
      _refreshCount += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'PullRefresh',
      tags: const ['移动端', '刷新'],
      sections: [
        _DocSection(
          label: '下拉刷新列表',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: SizedBox(
              height: 230,
              child: AnimalPullRefresh(
                onRefresh: _handleRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    AnimalMobileNoticeBar(
                      type: AnimalMobileNoticeType.success,
                      child: Text(
                        _refreshCount == 0
                            ? '向下拖动列表刷新今日任务'
                            : '已刷新 $_refreshCount 次，今日任务已同步',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const AnimalCellGroup(
                      children: [
                        AnimalListTile(
                          leading: Icon(Icons.local_florist_rounded),
                          title: Text('整理花园'),
                          subtitle: Text('下拉刷新今日任务'),
                        ),
                        AnimalListTile(
                          leading: Icon(Icons.shopping_bag_rounded),
                          title: Text('采购家具'),
                        ),
                        AnimalListTile(
                          leading: Icon(Icons.cookie_rounded),
                          title: Text('准备下午茶'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      code: _mobilePullRefreshCode,
      api: _mobilePullRefreshApi,
    );
  }
}

class _MobileSectionDoc extends StatelessWidget {
  const _MobileSectionDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'Section',
      tags: ['移动端', '布局'],
      sections: [
        _DocSection(
          label: '移动页面分区',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  AnimalMobileSection(
                    title: Text('今日推荐'),
                    extra: Text('查看全部'),
                    child: AnimalMobileProductCard(
                      title: Text('樱桃果篮'),
                      subtitle: Text('岛屿直送，今日 18:00 前送达'),
                      price: Text('120 铃钱'),
                    ),
                  ),
                  AnimalMobileSection(
                    title: Text('我的服务'),
                    child: AnimalCellGroup(
                      children: [
                        AnimalListTile(
                          leading: Icon(Icons.card_giftcard_rounded),
                          title: Text('优惠券'),
                        ),
                        AnimalListTile(
                          leading: Icon(Icons.inventory_2_rounded),
                          title: Text('订单'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _mobileSectionCode,
      api: _mobileSectionApi,
    );
  }
}

class _MobileProductCardDoc extends StatelessWidget {
  const _MobileProductCardDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'ProductCard',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '商品推荐列表',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  AnimalMobileProductCard(
                    title: Text('樱桃果篮'),
                    subtitle: Text('岛屿直送，今日 18:00 前送达'),
                    price: Text('120 铃钱'),
                    tag: AnimalTag(
                      color: AnimalTagColor.danger,
                      size: AnimalTagSize.small,
                      child: Text('热卖'),
                    ),
                    action: AnimalButton(
                      type: AnimalButtonType.primary,
                      size: AnimalButtonSize.small,
                      child: Text('加购'),
                    ),
                  ),
                  SizedBox(height: 12),
                  AnimalMobileProductCard(
                    title: Text('手作花园椅'),
                    subtitle: Text('适合放在庭院或露营区'),
                    price: Text('320 铃钱'),
                    tag: AnimalTag(
                      color: AnimalTagColor.success,
                      size: AnimalTagSize.small,
                      child: Text('新品'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _mobileProductCardCode,
      api: _mobileProductCardApi,
    );
  }
}

class _MobileOrderCardDoc extends StatelessWidget {
  const _MobileOrderCardDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'OrderCard',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '订单摘要',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: AnimalMobileOrderCard(
                orderNo: Text('订单 #A001'),
                status: Text('配送中'),
                items: [
                  AnimalMobileOrderItem(
                    title: Text('樱桃果篮'),
                    subtitle: Text('南湾海风岛'),
                    quantity: 2,
                    price: Text('120'),
                  ),
                  AnimalMobileOrderItem(
                    title: Text('手作花园椅'),
                    subtitle: Text('庭院家具'),
                    quantity: 1,
                    price: Text('320'),
                  ),
                ],
                total: Text('合计 560 铃钱'),
                footer: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimalButton(
                      size: AnimalButtonSize.small,
                      child: Text('查看物流'),
                    ),
                    SizedBox(width: 8),
                    AnimalButton(
                      type: AnimalButtonType.primary,
                      size: AnimalButtonSize.small,
                      child: Text('确认收货'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      code: _mobileOrderCardCode,
      api: _mobileOrderCardApi,
    );
  }
}

class _MobileProfileHeaderDoc extends StatelessWidget {
  const _MobileProfileHeaderDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'ProfileHeader',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '我的页面头图',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: AnimalMobileProfileHeader(
                name: Text('狸克'),
                subtitle: Text('岛屿居民服务处 · Lv.8'),
                stats: [
                  AnimalMobileStatItem(
                    label: Text('订单'),
                    value: Text('12'),
                    icon: Icon(Icons.inventory_2_rounded),
                  ),
                  AnimalMobileStatItem(
                    label: Text('积分'),
                    value: Text('840'),
                    icon: Icon(Icons.stars_rounded),
                  ),
                  AnimalMobileStatItem(
                    label: Text('优惠券'),
                    value: Text('6'),
                    icon: Icon(Icons.card_giftcard_rounded),
                  ),
                ],
                actions: [
                  AnimalButton(
                    type: AnimalButtonType.primary,
                    size: AnimalButtonSize.small,
                    child: Text('编辑资料'),
                  ),
                  AnimalButton(
                    size: AnimalButtonSize.small,
                    child: Text('会员中心'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _mobileProfileHeaderCode,
      api: _mobileProfileHeaderApi,
    );
  }
}

class _MobileStatsGridDoc extends StatelessWidget {
  const _MobileStatsGridDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'StatsGrid',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '业务指标宫格',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: AnimalMobileStatsGrid(
                items: [
                  AnimalMobileStatItem(
                    label: Text('待付款'),
                    value: Text('2'),
                    description: Text('订单'),
                    icon: Icon(Icons.payments_rounded),
                  ),
                  AnimalMobileStatItem(
                    label: Text('配送中'),
                    value: Text('5'),
                    description: Text('包裹'),
                    icon: Icon(Icons.local_shipping_rounded),
                  ),
                  AnimalMobileStatItem(
                    label: Text('收藏'),
                    value: Text('18'),
                    description: Text('商品'),
                    icon: Icon(Icons.favorite_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _mobileStatsGridCode,
      api: _mobileStatsGridApi,
    );
  }
}

class _MobileCouponCardDoc extends StatelessWidget {
  const _MobileCouponCardDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'CouponCard',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '优惠券状态',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  AnimalMobileCouponCard(
                    amount: Text('-20'),
                    title: Text('新人购物券'),
                    description: Text('满 100 铃钱可用，今日有效'),
                  ),
                  SizedBox(height: 12),
                  AnimalMobileCouponCard(
                    amount: Text('8折'),
                    title: Text('家具节折扣券'),
                    description: Text('仅限庭院家具分类'),
                    status: AnimalMobileCouponStatus.claimed,
                  ),
                  SizedBox(height: 12),
                  AnimalMobileCouponCard(
                    amount: Text('-10'),
                    title: Text('过期补贴券'),
                    description: Text('已超过使用时间'),
                    status: AnimalMobileCouponStatus.expired,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      code: _mobileCouponCardCode,
      api: _mobileCouponCardApi,
    );
  }
}

class _MobileNoticeBarDoc extends StatelessWidget {
  const _MobileNoticeBarDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'NoticeBar',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '公告提醒',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: _DemoColumn(
              children: [
                AnimalMobileNoticeBar(
                  action: Text('查看'),
                  showChevron: true,
                  child: Text('今日 18:00 前下单，岛屿直送免服务费。'),
                ),
                AnimalMobileNoticeBar(
                  type: AnimalMobileNoticeType.warning,
                  child: Text('部分海岛受天气影响，配送时间可能延迟。'),
                ),
                AnimalMobileNoticeBar(
                  type: AnimalMobileNoticeType.success,
                  child: Text('优惠券已自动抵扣，结算时可查看明细。'),
                ),
              ],
            ),
          ),
        ),
      ],
      code: _mobileNoticeBarCode,
      api: _mobileNoticeBarApi,
    );
  }
}

class _MobileAddressCardDoc extends StatelessWidget {
  const _MobileAddressCardDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'AddressCard',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '收货地址',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: _DemoColumn(
              children: [
                AnimalMobileAddressCard(
                  selected: true,
                  name: Text('狸克'),
                  phone: Text('138 0000 0522'),
                  tag: AnimalTag(
                    color: AnimalTagColor.primary,
                    size: AnimalTagSize.small,
                    child: Text('默认'),
                  ),
                  address: Text('星露岛 居民服务处旁 1 号营地'),
                ),
                AnimalMobileAddressCard(
                  name: Text('西施惠'),
                  phone: Text('139 0000 0618'),
                  address: Text('南湾海风岛 花园路 8 号'),
                ),
              ],
            ),
          ),
        ),
      ],
      code: _mobileAddressCardCode,
      api: _mobileAddressCardApi,
    );
  }
}

class _MobilePriceSummaryDoc extends StatelessWidget {
  const _MobilePriceSummaryDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'PriceSummary',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '订单费用',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: AnimalMobilePriceSummary(
              items: [
                AnimalMobilePriceItem(
                    label: Text('商品金额'), value: Text('560 铃钱')),
                AnimalMobilePriceItem(
                    label: Text('配送服务'), value: Text('20 铃钱')),
                AnimalMobilePriceItem(
                  label: Text('优惠券'),
                  value: Text('-20 铃钱'),
                  emphasized: true,
                ),
              ],
              total: Text('560 铃钱'),
              footer: Text('价格明细适合订单确认页、服务预约页和会员结算页。'),
            ),
          ),
        ),
      ],
      code: _mobilePriceSummaryCode,
      api: _mobilePriceSummaryApi,
    );
  }
}

class _MobileCheckoutBarDoc extends StatelessWidget {
  const _MobileCheckoutBarDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'CheckoutBar',
      tags: const ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '底部结算',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AnimalMobileProductCard(
                  title: Text('樱桃果篮'),
                  subtitle: Text('岛屿直送，今日 18:00 前送达'),
                  price: Text('120 铃钱'),
                ),
                const SizedBox(height: 12),
                AnimalMobileCheckoutBar(
                  safeAreaBottom: false,
                  total: const Text('560 铃钱'),
                  extra: const Text('已优惠 20 铃钱'),
                  action: AnimalButton(
                    type: AnimalButtonType.primary,
                    onPressed: () {},
                    child: const Text('去结算'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      code: _mobileCheckoutBarCode,
      api: _mobileCheckoutBarApi,
    );
  }
}

class _MobileCartItemDoc extends StatefulWidget {
  const _MobileCartItemDoc();

  @override
  State<_MobileCartItemDoc> createState() => _MobileCartItemDocState();
}

class _MobileCartItemDocState extends State<_MobileCartItemDoc> {
  var _selected = true;
  num _quantity = 2;

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'CartItem',
      tags: const ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '购物车商品项',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: _DemoColumn(
              children: [
                AnimalMobileCartItem(
                  selected: _selected,
                  onSelectedChanged: (value) =>
                      setState(() => _selected = value),
                  title: const Text('樱桃果篮'),
                  subtitle: const Text('规格：大份 / 今日 18:00 前送达'),
                  price: const Text('120 铃钱'),
                  quantity: _quantity,
                  onQuantityChanged: (value) =>
                      setState(() => _quantity = value),
                  tag: const AnimalTag(
                    color: AnimalTagColor.danger,
                    size: AnimalTagSize.small,
                    child: Text('热卖'),
                  ),
                ),
                const AnimalMobileCartItem(
                  disabled: true,
                  selected: false,
                  title: Text('手作花园椅'),
                  subtitle: Text('规格：原木色'),
                  price: Text('320 铃钱'),
                  quantity: 1,
                  disabledText: Text('该商品暂时缺货'),
                ),
              ],
            ),
          ),
        ),
      ],
      code: _mobileCartItemCode,
      api: _mobileCartItemApi,
    );
  }
}

class _MobileOrderTimelineDoc extends StatelessWidget {
  const _MobileOrderTimelineDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'OrderTimeline',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '物流进度',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: AnimalMobileOrderTimeline(
              items: [
                AnimalMobileTimelineItem(
                  title: Text('订单已提交'),
                  description: Text('居民服务处已收到你的订单。'),
                  time: Text('09:30'),
                  status: AnimalMobileTimelineStatus.success,
                  icon: Icon(Icons.check_rounded),
                ),
                AnimalMobileTimelineItem(
                  title: Text('正在配送'),
                  description: Text('豆狸正在把包裹送往星露岛。'),
                  time: Text('10:12'),
                  status: AnimalMobileTimelineStatus.processing,
                  icon: Icon(Icons.local_shipping_rounded),
                ),
                AnimalMobileTimelineItem(
                  title: Text('等待签收'),
                  description: Text('请在码头附近保持联络。'),
                  status: AnimalMobileTimelineStatus.warning,
                ),
              ],
            ),
          ),
        ),
      ],
      code: _mobileOrderTimelineCode,
      api: _mobileOrderTimelineApi,
    );
  }
}

class _MobilePaymentMethodDoc extends StatelessWidget {
  const _MobilePaymentMethodDoc();

  @override
  Widget build(BuildContext context) {
    return const _ComponentDoc(
      title: 'PaymentMethod',
      tags: ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '支付方式',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: _DemoColumn(
              children: [
                AnimalMobilePaymentMethodCard(
                  selected: true,
                  icon: Icon(Icons.account_balance_wallet_rounded),
                  title: Text('铃钱钱包'),
                  subtitle: Text('余额 8,400 铃钱，可直接抵扣'),
                ),
                AnimalMobilePaymentMethodCard(
                  icon: Icon(Icons.credit_card_rounded),
                  title: Text('岛屿信用卡'),
                  subtitle: Text('尾号 0522'),
                ),
                AnimalMobilePaymentMethodCard(
                  disabled: true,
                  icon: Icon(Icons.lock_rounded),
                  title: Text('博物馆积分'),
                  subtitle: Text('当前订单暂不可用'),
                ),
              ],
            ),
          ),
        ),
      ],
      code: _mobilePaymentMethodCode,
      api: _mobilePaymentMethodApi,
    );
  }
}

class _MobileEmptyActionDoc extends StatelessWidget {
  const _MobileEmptyActionDoc();

  @override
  Widget build(BuildContext context) {
    return _ComponentDoc(
      title: 'EmptyAction',
      tags: const ['移动端', '业务'],
      sections: [
        _DocSection(
          label: '业务空状态',
          box: _DemoBoxStyle.soft,
          child: _MobileFrame(
            child: AnimalMobileEmptyAction(
              icon: const Icon(Icons.shopping_cart_rounded),
              title: const Text('购物车还是空的'),
              description: const Text('去挑选一些岛屿好物，结算栏会自动汇总金额。'),
              action: AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: () {},
                child: const Text('去逛逛'),
              ),
            ),
          ),
        ),
      ],
      code: _mobileEmptyActionCode,
      api: _mobileEmptyActionApi,
    );
  }
}

class _MobileFrame extends StatelessWidget {
  const _MobileFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 390),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: ColoredBox(
          color: const Color(0xFFF8F4E8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: child,
          ),
        ),
      ),
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
    this.keywords = const [],
  });

  final String routeKey;
  final String group;
  final String navTitle;
  final String title;
  final String summary;
  final Widget body;
  final List<String> keywords;

  String get searchText {
    return [
      routeKey,
      group,
      navTitle,
      title,
      summary,
      ...keywords,
    ].join(' ');
  }

  _DocPage copyWith({
    String? group,
    List<String>? keywords,
  }) {
    return _DocPage(
      routeKey: routeKey,
      group: group ?? this.group,
      navTitle: navTitle,
      title: title,
      summary: summary,
      body: body,
      keywords: keywords ?? this.keywords,
    );
  }
}

class _DocNavMeta {
  const _DocNavMeta(this.group, this.order);

  final String group;
  final int order;
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
  '移动端',
  'Animal 特色',
];

const _docNavMeta = <String, _DocNavMeta>{
  'theme': _DocNavMeta('主题与基础', 0),
  'button': _DocNavMeta('主题与基础', 1),
  'icon': _DocNavMeta('主题与基础', 2),
  'avatar': _DocNavMeta('主题与基础', 3),
  'tag': _DocNavMeta('主题与基础', 4),
  'badge': _DocNavMeta('主题与基础', 5),
  'card': _DocNavMeta('布局与容器', 100),
  'collapse': _DocNavMeta('布局与容器', 101),
  'divider-comp': _DocNavMeta('布局与容器', 102),
  'skeleton': _DocNavMeta('布局与容器', 103),
  'empty': _DocNavMeta('布局与容器', 104),
  'input': _DocNavMeta('表单输入', 200),
  'input-plus': _DocNavMeta('表单输入', 201),
  'select': _DocNavMeta('表单输入', 202),
  'checkbox': _DocNavMeta('表单输入', 203),
  'radio': _DocNavMeta('表单输入', 204),
  'switch': _DocNavMeta('表单输入', 205),
  'slider': _DocNavMeta('表单输入', 206),
  'rate': _DocNavMeta('表单输入', 207),
  'segmented': _DocNavMeta('表单输入', 208),
  'form': _DocNavMeta('表单输入', 209),
  'calendar': _DocNavMeta('数据录入', 300),
  'upload': _DocNavMeta('数据录入', 301),
  'tree': _DocNavMeta('数据录入', 302),
  'tabs': _DocNavMeta('导航', 400),
  'breadcrumb': _DocNavMeta('导航', 401),
  'steps': _DocNavMeta('导航', 402),
  'pagination': _DocNavMeta('导航', 403),
  'alert': _DocNavMeta('反馈', 500),
  'message': _DocNavMeta('反馈', 501),
  'tooltip': _DocNavMeta('反馈', 502),
  'progress': _DocNavMeta('反馈', 503),
  'loading': _DocNavMeta('反馈', 504),
  'result': _DocNavMeta('反馈', 505),
  'table': _DocNavMeta('数据展示', 600),
  'descriptions': _DocNavMeta('数据展示', 601),
  'statistic': _DocNavMeta('数据展示', 602),
  'timeline': _DocNavMeta('数据展示', 603),
  'codeblock': _DocNavMeta('数据展示', 604),
  'modal': _DocNavMeta('浮层', 700),
  'popover': _DocNavMeta('浮层', 701),
  'dropdown': _DocNavMeta('浮层', 702),
  'drawer': _DocNavMeta('浮层', 703),
  'confirm-dialog': _DocNavMeta('浮层', 704),
  'mobile-navbar': _DocNavMeta('移动端', 800),
  'mobile-bottom-bar': _DocNavMeta('移动端', 801),
  'mobile-bottom-sheet': _DocNavMeta('移动端', 802),
  'mobile-action-sheet': _DocNavMeta('移动端', 803),
  'mobile-list-tile': _DocNavMeta('移动端', 804),
  'mobile-cell-group': _DocNavMeta('移动端', 805),
  'mobile-search-bar': _DocNavMeta('移动端', 806),
  'mobile-picker': _DocNavMeta('移动端', 807),
  'mobile-date-picker': _DocNavMeta('移动端', 808),
  'mobile-stepper': _DocNavMeta('移动端', 809),
  'mobile-swipe-action': _DocNavMeta('移动端', 810),
  'mobile-pull-refresh': _DocNavMeta('移动端', 811),
  'mobile-section': _DocNavMeta('移动端', 812),
  'mobile-product-card': _DocNavMeta('移动端', 813),
  'mobile-order-card': _DocNavMeta('移动端', 814),
  'mobile-profile-header': _DocNavMeta('移动端', 815),
  'mobile-stats-grid': _DocNavMeta('移动端', 816),
  'mobile-coupon-card': _DocNavMeta('移动端', 817),
  'mobile-notice-bar': _DocNavMeta('移动端', 818),
  'mobile-address-card': _DocNavMeta('移动端', 819),
  'mobile-price-summary': _DocNavMeta('移动端', 820),
  'mobile-checkout-bar': _DocNavMeta('移动端', 821),
  'mobile-cart-item': _DocNavMeta('移动端', 822),
  'mobile-order-timeline': _DocNavMeta('移动端', 823),
  'mobile-payment-method': _DocNavMeta('移动端', 824),
  'mobile-empty-action': _DocNavMeta('移动端', 825),
  'time': _DocNavMeta('Animal 特色', 900),
  'phone': _DocNavMeta('Animal 特色', 901),
  'cursor': _DocNavMeta('Animal 特色', 902),
  'typewriter': _DocNavMeta('Animal 特色', 903),
  'footer': _DocNavMeta('Animal 特色', 904),
};

List<_DocPage> _sortDocPages(List<_DocPage> pages) {
  final displayPages = pages
      .where(
          (page) => page.routeKey != 'extended' && page.routeKey != 'advanced')
      .toList();
  displayPages.sort((a, b) {
    final left = _docNavMeta[a.routeKey] ?? _DocNavMeta(a.group, 10000);
    final right = _docNavMeta[b.routeKey] ?? _DocNavMeta(b.group, 10000);
    final groupCompare =
        _docGroupIndex(left.group).compareTo(_docGroupIndex(right.group));
    if (groupCompare != 0) {
      return groupCompare;
    }
    final orderCompare = left.order.compareTo(right.order);
    if (orderCompare != 0) {
      return orderCompare;
    }
    return a.navTitle.compareTo(b.navTitle);
  });
  return [
    for (final page in displayPages)
      page.copyWith(
        group: _docNavMeta[page.routeKey]?.group ?? page.group,
        keywords: _docSearchKeywords[page.routeKey] ?? page.keywords,
      ),
  ];
}

const _docSearchKeywords = <String, List<String>>{
  'theme': ['主题', 'token', 'color', 'font', 'palette'],
  'button': ['按钮', 'loading', 'ghost', 'danger', 'primary'],
  'icon': ['图标', 'svg', 'asset'],
  'avatar': ['头像', 'image', 'circle'],
  'tag': ['标签', 'label', 'close'],
  'badge': ['角标', 'dot', 'count'],
  'card': ['卡片', 'container', 'panel'],
  'collapse': ['折叠', 'accordion', 'faq'],
  'divider-comp': ['分割线', 'divider', 'line'],
  'skeleton': ['骨架屏', 'placeholder', 'loading'],
  'empty': ['空状态', 'empty', 'no data'],
  'input': ['输入框', 'text field', 'clearable', 'prefix', 'suffix'],
  'input-plus': ['textarea', 'password', 'search', 'number', '输入增强'],
  'select': ['选择器', 'dropdown', '下拉', 'option'],
  'checkbox': ['多选', 'check', 'form field'],
  'radio': ['单选', 'radio group'],
  'switch': ['开关', 'toggle'],
  'slider': ['滑块', 'range', 'value'],
  'rate': ['评分', 'star'],
  'segmented': ['分段', 'tabs', 'mode'],
  'form': ['表单', 'validator', 'layout', 'field'],
  'calendar': ['日历', 'date', 'picker'],
  'upload': ['上传', 'file', 'progress'],
  'tree': ['树形', 'tree view', 'node'],
  'tabs': ['标签页', 'tab'],
  'breadcrumb': ['面包屑', 'path', 'navigation'],
  'steps': ['步骤条', 'stepper'],
  'pagination': ['分页', 'page'],
  'alert': ['警告', 'notice', 'warning'],
  'message': ['轻提示', 'toast', 'feedback'],
  'tooltip': ['提示', 'hover', 'tip'],
  'progress': ['进度', 'bar'],
  'loading': ['加载', 'spinner', 'island'],
  'result': ['结果页', 'success', 'error'],
  'table': ['表格', 'data grid', 'row', 'column', 'scroll'],
  'descriptions': ['描述列表', 'detail', 'metadata'],
  'statistic': ['统计', 'number', 'metric'],
  'timeline': ['时间线', 'log', 'activity'],
  'codeblock': ['代码', 'highlight', 'snippet'],
  'modal': ['弹窗', 'dialog', 'popup'],
  'popover': ['气泡', 'overlay', 'floating'],
  'dropdown': ['下拉菜单', 'menu', 'action'],
  'drawer': ['抽屉', 'panel', 'sidebar'],
  'confirm-dialog': ['确认框', 'confirm', 'delete'],
  'mobile-navbar': ['手机导航', 'navbar', 'appbar'],
  'mobile-bottom-bar': ['底部导航', 'tabbar', 'phone'],
  'mobile-bottom-sheet': ['底部弹层', 'bottom sheet', 'filter'],
  'mobile-action-sheet': ['操作面板', 'action sheet', 'touch'],
  'mobile-list-tile': ['移动列表项', 'cell', 'list item'],
  'mobile-cell-group': ['单元格组', 'cell group', 'settings'],
  'mobile-search-bar': ['移动搜索', 'search', 'cancel', 'clear'],
  'mobile-picker': ['移动选择器', 'picker', 'bottom sheet'],
  'mobile-date-picker': ['日期选择', 'date picker', 'calendar'],
  'mobile-stepper': ['步进器', 'quantity', 'cart'],
  'mobile-swipe-action': ['左滑操作', 'swipe', 'delete'],
  'mobile-pull-refresh': ['下拉刷新', 'refresh', 'list'],
  'mobile-section': ['移动分区', 'section', 'group'],
  'mobile-product-card': ['商品卡片', 'product', 'shop'],
  'mobile-order-card': ['订单卡片', 'order', 'business'],
  'mobile-profile-header': ['个人头图', 'profile', 'mine'],
  'mobile-stats-grid': ['统计宫格', 'stats', 'metrics'],
  'mobile-coupon-card': ['优惠券', 'coupon', 'marketing'],
  'mobile-notice-bar': ['公告栏', 'notice', 'notification', 'activity'],
  'mobile-address-card': ['地址卡片', 'address', 'shipping', 'receiver'],
  'mobile-price-summary': ['价格明细', 'price', 'summary', 'checkout'],
  'mobile-checkout-bar': ['结算栏', 'checkout', 'cart', 'bottom bar'],
  'mobile-cart-item': ['购物车', 'cart', 'product item', 'quantity'],
  'mobile-order-timeline': ['订单时间线', 'logistics', 'delivery', 'timeline'],
  'mobile-payment-method': ['支付方式', 'payment', 'checkout', 'method'],
  'mobile-empty-action': ['业务空状态', 'empty', 'action', 'placeholder'],
  'time': ['时间', 'clock', 'hud'],
  'phone': ['手机', 'nook phone'],
  'cursor': ['光标', 'pointer', 'mouse'],
  'typewriter': ['打字机', 'typing', 'text'],
  'footer': ['页脚', 'decoration'],
};

int _docGroupIndex(String group) {
  final index = _docNavGroups.indexOf(group);
  return index < 0 ? _docNavGroups.length : index;
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

class _HomeComponentGroup {
  const _HomeComponentGroup({
    required this.title,
    required this.description,
    required this.components,
  });

  final String title;
  final String description;
  final List<_ComponentInfo> components;
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

class _ThemeSwatch {
  const _ThemeSwatch(this.name, this.hex, this.color);

  final String name;
  final String hex;
  final Color color;
}

enum _DemoBoxStyle { none, soft, dashed }

void _noopStringChanged(String value) {}

void _noopNumChanged(num value) {}

const _themeSwatches = [
  _ThemeSwatch('Mint', '#19C8B9', Color(0xFF19C8B9)),
  _ThemeSwatch('Forest', '#4E8F75', Color(0xFF4E8F75)),
  _ThemeSwatch('Berry', '#D85C7D', Color(0xFFD85C7D)),
  _ThemeSwatch('Honey', '#E5A928', Color(0xFFE5A928)),
  _ThemeSwatch('Ocean', '#3D82C4', Color(0xFF3D82C4)),
];

const _homeFeatures = [
  _FeatureInfo(
    icon: _DemoAssets.nook1,
    title: 'Animal风格',
    description: 'SVG 有机形状裁切，3D 按压按钮，温暖质朴的自然 UI 质感',
  ),
  _FeatureInfo(
    icon: _DemoAssets.shopping,
    title: '74 个组件',
    description:
        'Button / Input / Switch / Modal / Table / Form / Calendar / Upload / Mobile 业务组件等',
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
  _ComponentInfo(key: 'theme', name: 'Theme', description: '品牌主色、字体与设计令牌'),
  _ComponentInfo(
    key: 'button',
    name: 'Button',
    description: '5 种类型、3 种尺寸、加载/危险/幽灵模式',
  ),
  _ComponentInfo(key: 'icon', name: 'Icon', description: 'SVG 图标库'),
  _ComponentInfo(key: 'avatar', name: 'Avatar', description: '头像、文字、图片与图标占位'),
  _ComponentInfo(key: 'tag', name: 'Tag', description: '彩色标签、图标与可关闭状态'),
  _ComponentInfo(key: 'badge', name: 'Badge', description: '角标、数字上限与小红点'),
  _ComponentInfo(key: 'card', name: 'Card', description: '默认/标题两种卡片风格'),
  _ComponentInfo(
      key: 'collapse', name: 'Collapse', description: 'FAQ 折叠面板、平滑展开动画'),
  _ComponentInfo(key: 'divider-comp', name: 'Divider', description: '装饰性水平分割线'),
  _ComponentInfo(key: 'skeleton', name: 'Skeleton', description: '骨架屏加载占位'),
  _ComponentInfo(key: 'empty', name: 'Empty', description: '空状态占位'),
  _ComponentInfo(key: 'input', name: 'Input', description: '前后缀、一键清空、校验状态'),
  _ComponentInfo(
      key: 'input-plus', name: 'Input Plus', description: '多行、密码、搜索和数字输入'),
  _ComponentInfo(key: 'select', name: 'Select', description: '下拉选择器，支持搜索和禁用'),
  _ComponentInfo(
    key: 'checkbox',
    name: 'Checkbox',
    description: '多选框组件，支持水平/垂直排列',
  ),
  _ComponentInfo(key: 'radio', name: 'Radio', description: '单选框组件，支持尺寸与排列方向'),
  _ComponentInfo(
    key: 'switch',
    name: 'Switch',
    description: '受控/非受控、自定义文案、加载状态',
  ),
  _ComponentInfo(key: 'slider', name: 'Slider', description: '滑动输入、分段与数值展示'),
  _ComponentInfo(key: 'rate', name: 'Rate', description: '评分选择控件'),
  _ComponentInfo(key: 'segmented', name: 'Segmented', description: '分段控制器'),
  _ComponentInfo(key: 'form', name: 'Form', description: '表单布局、标签宽度与帮助文案'),
  _ComponentInfo(key: 'calendar', name: 'Calendar', description: '日期选择和月份切换'),
  _ComponentInfo(key: 'upload', name: 'Upload', description: '上传入口和文件队列'),
  _ComponentInfo(key: 'tree', name: 'Tree', description: '层级节点选择控件'),
  _ComponentInfo(key: 'tabs', name: 'Tabs', description: '标签页组件，支持受控/非受控模式'),
  _ComponentInfo(key: 'breadcrumb', name: 'Breadcrumb', description: '面包屑导航路径'),
  _ComponentInfo(key: 'steps', name: 'Steps', description: '横向/纵向步骤条'),
  _ComponentInfo(key: 'pagination', name: 'Pagination', description: '分页器组件'),
  _ComponentInfo(key: 'alert', name: 'Alert', description: '警告提示、图标与可关闭状态'),
  _ComponentInfo(key: 'message', name: 'Message', description: '顶部轻提示反馈'),
  _ComponentInfo(key: 'tooltip', name: 'Tooltip', description: '动森风提示气泡'),
  _ComponentInfo(key: 'progress', name: 'Progress', description: '条纹进度条'),
  _ComponentInfo(key: 'loading', name: 'Loading', description: '动森风格小岛加载动画'),
  _ComponentInfo(key: 'result', name: 'Result', description: '结果反馈和操作区'),
  _ComponentInfo(key: 'table', name: 'Table', description: '斑马纹表格、加载与空状态'),
  _ComponentInfo(
      key: 'descriptions', name: 'Descriptions', description: '详情页描述列表'),
  _ComponentInfo(key: 'statistic', name: 'Statistic', description: '仪表盘统计数值'),
  _ComponentInfo(key: 'timeline', name: 'Timeline', description: '流程时间线与状态点'),
  _ComponentInfo(key: 'codeblock', name: 'CodeBlock', description: '代码语法高亮组件'),
  _ComponentInfo(key: 'modal', name: 'Modal', description: 'SVG 有机形状弹窗、ESC 关闭'),
  _ComponentInfo(key: 'popover', name: 'Popover', description: '上下左右气泡卡片'),
  _ComponentInfo(key: 'dropdown', name: 'Dropdown', description: '浮层菜单、图标和禁用项'),
  _ComponentInfo(key: 'drawer', name: 'Drawer', description: '左右抽屉和底部操作区'),
  _ComponentInfo(
      key: 'confirm-dialog', name: 'ConfirmDialog', description: '确认流程弹窗封装'),
  _ComponentInfo(
      key: 'mobile-navbar', name: 'MobileNavBar', description: '移动端顶部导航栏'),
  _ComponentInfo(
      key: 'mobile-bottom-bar', name: 'BottomBar', description: '移动端底部导航'),
  _ComponentInfo(
      key: 'mobile-bottom-sheet', name: 'BottomSheet', description: '移动端底部弹层'),
  _ComponentInfo(
      key: 'mobile-action-sheet', name: 'ActionSheet', description: '触摸操作面板'),
  _ComponentInfo(
      key: 'mobile-list-tile', name: 'ListTile', description: '移动列表项'),
  _ComponentInfo(
      key: 'mobile-cell-group', name: 'CellGroup', description: '单元格分组容器'),
  _ComponentInfo(
      key: 'mobile-search-bar', name: 'SearchBar', description: '移动端搜索栏'),
  _ComponentInfo(key: 'mobile-picker', name: 'Picker', description: '移动底部选择器'),
  _ComponentInfo(
      key: 'mobile-date-picker', name: 'DatePicker', description: '移动日期选择'),
  _ComponentInfo(key: 'mobile-stepper', name: 'Stepper', description: '数量步进器'),
  _ComponentInfo(
      key: 'mobile-swipe-action', name: 'SwipeAction', description: '左滑快捷操作'),
  _ComponentInfo(
      key: 'mobile-pull-refresh', name: 'PullRefresh', description: '下拉刷新容器'),
  _ComponentInfo(key: 'mobile-section', name: 'Section', description: '移动页面分区'),
  _ComponentInfo(
      key: 'mobile-product-card', name: 'ProductCard', description: '移动商品卡片'),
  _ComponentInfo(
      key: 'mobile-order-card', name: 'OrderCard', description: '移动订单卡片'),
  _ComponentInfo(
      key: 'mobile-profile-header',
      name: 'ProfileHeader',
      description: '个人中心头图'),
  _ComponentInfo(
      key: 'mobile-stats-grid', name: 'StatsGrid', description: '移动统计宫格'),
  _ComponentInfo(
      key: 'mobile-coupon-card', name: 'CouponCard', description: '移动优惠券卡片'),
  _ComponentInfo(
      key: 'mobile-notice-bar', name: 'NoticeBar', description: '移动公告和业务提醒'),
  _ComponentInfo(
      key: 'mobile-address-card', name: 'AddressCard', description: '收货地址和选中态'),
  _ComponentInfo(
      key: 'mobile-price-summary', name: 'PriceSummary', description: '订单价格明细'),
  _ComponentInfo(
      key: 'mobile-checkout-bar', name: 'CheckoutBar', description: '底部结算操作栏'),
  _ComponentInfo(
      key: 'mobile-cart-item', name: 'CartItem', description: '购物车商品项'),
  _ComponentInfo(
      key: 'mobile-order-timeline',
      name: 'OrderTimeline',
      description: '物流和订单状态时间线'),
  _ComponentInfo(
      key: 'mobile-payment-method',
      name: 'PaymentMethod',
      description: '支付方式选择卡片'),
  _ComponentInfo(
      key: 'mobile-empty-action', name: 'EmptyAction', description: '移动业务空状态'),
  _ComponentInfo(key: 'time', name: 'Time', description: '可爱风格时间显示'),
  _ComponentInfo(key: 'phone', name: 'Phone', description: 'Phone 模拟器'),
  _ComponentInfo(key: 'cursor', name: 'Cursor', description: '自定义手指光标，支持多种尺寸'),
  _ComponentInfo(
    key: 'typewriter',
    name: 'Typewriter',
    description: '逐字打字机效果，支持多行与富内容',
  ),
  _ComponentInfo(key: 'footer', name: 'Footer', description: '页脚组件'),
];

const _homeComponentGroupDescriptions = {
  '主题与基础': '主题令牌、按钮、图标和轻量标识，构成界面的基础表达。',
  '布局与容器': '组织页面结构、内容分隔和加载占位的常用容器。',
  '表单输入': '覆盖文本输入、选择、开关、评分和完整表单布局。',
  '数据录入': '面向日期、文件和层级节点的复杂录入控件。',
  '数据展示': '用于表格、详情、指标、时间线和代码内容展示。',
  '导航': '页面切换、路径提示、步骤流程和分页导航。',
  '反馈': '提示、消息、进度、加载和结果状态反馈。',
  '浮层': '弹窗、气泡、菜单、抽屉和确认流程。',
  '移动端': '面向手机页面、触摸列表和底部操作的移动端组件。',
  'Animal 特色': '保留 Animal Island 氛围的装饰、光标和拟物化组件。',
};

List<_HomeComponentGroup> _homeComponentGroups() {
  final byKey = {
    for (final component in _homeComponents) component.key: component
  };
  final groups = <_HomeComponentGroup>[];

  for (final group in _docNavGroups) {
    final components = [
      for (final meta in _docNavMeta.entries)
        if (meta.value.group == group && byKey.containsKey(meta.key))
          byKey[meta.key]!,
    ];
    if (components.isEmpty) {
      continue;
    }
    groups.add(
      _HomeComponentGroup(
        title: group,
        description: _homeComponentGroupDescriptions[group] ?? '',
        components: components,
      ),
    );
  }

  return groups;
}

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
  _ApiRow('onSubmitted', '键盘提交回调', 'ValueChanged<String>?', '-'),
  _ApiRow('onEditingComplete', '编辑完成回调', 'VoidCallback?', '-'),
  _ApiRow('onClear', '清除回调', 'VoidCallback?', '-'),
  _ApiRow('controller', '文本控制器', 'TextEditingController?', '-'),
  _ApiRow('keyboardType', '键盘类型', 'TextInputType?', '-'),
  _ApiRow('textInputAction', '键盘动作', 'TextInputAction?', '-'),
  _ApiRow('textCapitalization', '大小写策略', 'TextCapitalization', 'none'),
  _ApiRow('autofillHints', '自动填充提示', 'Iterable<String>?', '-'),
  _ApiRow('maxLines', '最大行数；密码输入固定为 1', 'int?', '1'),
  _ApiRow('maxLength', '最大字符数', 'int?', '-'),
  _ApiRow('enabled', '是否启用', 'bool', 'true'),
  _ApiRow('AnimalInputFormField', '表单校验封装', 'FormField<String>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<String>?', '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<String>?', '-'),
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
  _ApiRow('AnimalSwitchFormField', '表单校验封装', 'FormField<bool>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<bool>?', '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<bool>?', '-'),
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
  _ApiRow('dropdownMaxHeight', '下拉层最大高度，超出后内部滚动', 'double', '260'),
  _ApiRow('AnimalSelectFormField', '表单校验封装', 'FormField<T>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<T>?', '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<T>?', '-'),
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
  _ApiRow('AnimalCheckboxFormField', '表单校验封装', 'FormField<List<T>>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<List<T>>?', '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<List<T>>?', '-'),
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
  _ApiRow('horizontalScroll', '列宽超出容器时自动横向滚动并显示底部滚动条', 'built-in', '-'),
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
  _ApiRow('AnimalRadioFormField', '表单校验封装', 'FormField<T>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<T>?', '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<T>?', '-'),
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

const _themeApi = [
  _ApiRow('AnimalTheme.data', '主题数据', 'AnimalThemeData?', 'fallback'),
  _ApiRow('AnimalThemeData.fallback()', '默认 Animal 风格令牌', 'factory', '-'),
  _ApiRow(
    'AnimalThemeData.fromPrimary',
    '根据品牌主色派生 hover / active / background',
    'factory',
    '-',
  ),
  _ApiRow('primarySolidColor', '激活标签、强调背景等实心主色', 'Color', '派生值'),
  _ApiRow('primaryStripeColor', 'Loading/Button 条纹色', 'Color', '派生值'),
  _ApiRow('contentBackgroundColor', '输入框、表格、选择项等内容底色', 'Color', '派生值'),
  _ApiRow('elevatedBackgroundColor', 'Tooltip、Message、Avatar 等浮层底色', 'Color',
      '派生值'),
  _ApiRow('controlBorderColor', 'Slider、Segmented、Steps 等控件边框', 'Color', '派生值'),
  _ApiRow('bodyTextColor', '正文与表单文本色', 'Color', '派生值'),
  _ApiRow('tactileShadowColor', '按钮、分页、滑块等底部触感阴影', 'Color', '派生值'),
  _ApiRow('copyWith.fontPackage', '字体资源包；传 null 可使用应用自身字体', 'String?', '当前值'),
  _ApiRow(
      'fontFamilyFallback', '字体 fallback 列表', 'List<String>', '内置中日英 fallback'),
  _ApiRow('textHeight', '默认文本行高', 'double', '1.5715'),
  _ApiRow('textStyle(height)', '局部覆盖行高', 'double?', 'textHeight'),
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
  _ApiRow('AnimalSliderFormField', '表单校验封装', 'FormField<double>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<double>?', '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<double>?', '-'),
];

const _rateApi = [
  _ApiRow('value', '受控评分', 'int?', '-'),
  _ApiRow('defaultValue', '默认评分', 'int', '0'),
  _ApiRow('count', '评分总数', 'int', '5'),
  _ApiRow('disabled', '是否禁用', 'bool', 'false'),
  _ApiRow('onChanged', '评分变化回调', 'ValueChanged<int>?', '-'),
  _ApiRow('AnimalRateFormField', '表单校验封装', 'FormField<int>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<int>?', '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<int>?', '-'),
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

const _formApi = [
  _ApiRow('AnimalForm.child', '表单内容', 'Widget', '-', required: true),
  _ApiRow('AnimalForm.formKey', 'FormState key', 'GlobalKey<FormState>?', '-'),
  _ApiRow('AnimalForm.layout', '默认布局', 'AnimalFormLayout', 'vertical'),
  _ApiRow('AnimalForm.labelWidth', 'horizontal 标签宽度', 'double', '112'),
  _ApiRow('AnimalForm.spacing', '表单项默认底部间距', 'double', '16'),
  _ApiRow('AnimalForm.autovalidateMode', '自动校验模式', 'AutovalidateMode?', '-'),
  _ApiRow('AnimalForm.onChanged', '表单变化回调', 'VoidCallback?', '-'),
  _ApiRow('AnimalFormItem.child', '表单项控件', 'Widget', '-', required: true),
  _ApiRow('AnimalFormItem.label', '标签', 'Widget?', '-'),
  _ApiRow('AnimalFormItem.required', '是否显示必填星号', 'bool', 'false'),
  _ApiRow('AnimalFormItem.help', '帮助说明', 'Widget?', '-'),
  _ApiRow('AnimalFormItem.errorText', '错误文案', 'String?', '-'),
  _ApiRow('AnimalFormItem.margin', '自定义外边距', 'EdgeInsetsGeometry?', '-'),
];

const _inputPlusApi = [
  _ApiRow('AnimalTextarea.rows', '显示行数', 'int', '4'),
  _ApiRow('AnimalTextarea.maxLength', '最大字符数', 'int?', '-'),
  _ApiRow('AnimalPasswordInput.hintText', '占位文本', 'String', '请输入密码'),
  _ApiRow('AnimalPasswordInput.allowClear', '允许清除', 'bool', 'false'),
  _ApiRow('AnimalSearchInput.onSearch', '搜索提交回调', 'ValueChanged<String>?', '-'),
  _ApiRow('AnimalSearchInput.allowClear', '允许清除', 'bool', 'true'),
  _ApiRow('AnimalNumberInput.value', '受控数值', 'num?', '-'),
  _ApiRow('AnimalNumberInput.defaultValue', '默认数值', 'num', '0'),
  _ApiRow('AnimalNumberInput.min', '最小值', 'num?', '-'),
  _ApiRow('AnimalNumberInput.max', '最大值', 'num?', '-'),
  _ApiRow('AnimalNumberInput.step', '步进', 'num', '1'),
  _ApiRow('AnimalNumberInput.onChanged', '数值变化回调', 'ValueChanged<num>?', '-'),
];

const _popoverApi = [
  _ApiRow('child', '触发元素', 'Widget', '-', required: true),
  _ApiRow('content', '浮层内容', 'Widget', '-', required: true),
  _ApiRow('title', '浮层标题', 'Widget?', '-'),
  _ApiRow('placement', '弹出方向', 'AnimalPopoverPlacement', 'bottom'),
  _ApiRow('trigger', '触发方式', 'AnimalPopoverTrigger', 'click'),
  _ApiRow('open', '受控打开状态', 'bool?', '-'),
  _ApiRow('onOpenChanged', '打开状态变化回调', 'ValueChanged<bool>?', '-'),
  _ApiRow('width', '浮层宽度', 'double', '260'),
  _ApiRow('gap', '与触发元素间距', 'double', '10'),
];

const _dropdownApi = [
  _ApiRow('child', '触发元素', 'Widget', '-', required: true),
  _ApiRow('items', '菜单项', 'List<AnimalDropdownItem<T>>', '-', required: true),
  _ApiRow('onChanged', '选中回调', 'ValueChanged<T>', '-', required: true),
  _ApiRow('placement', '弹出方向', 'AnimalPopoverPlacement', 'bottom'),
  _ApiRow('width', '菜单宽度', 'double', '220'),
  _ApiRow('AnimalDropdownItem.value', '菜单值', 'T', '-', required: true),
  _ApiRow('AnimalDropdownItem.label', '菜单内容', 'Widget', '-', required: true),
  _ApiRow('AnimalDropdownItem.disabled', '是否禁用', 'bool', 'false'),
  _ApiRow('AnimalDropdownItem.icon', '前置图标', 'Widget?', '-'),
];

const _drawerApi = [
  _ApiRow('context', '弹窗上下文', 'BuildContext', '-', required: true),
  _ApiRow('child', '抽屉内容', 'Widget', '-', required: true),
  _ApiRow('title', '标题', 'Widget?', '-'),
  _ApiRow('footer', '底部操作区', 'Widget?', '-'),
  _ApiRow('placement', '抽屉方向', 'AnimalDrawerPlacement', 'right'),
  _ApiRow('width', '抽屉宽度', 'double', '360'),
  _ApiRow('barrierDismissible', '点击遮罩关闭', 'bool', 'true'),
];

const _confirmDialogApi = [
  _ApiRow('context', '弹窗上下文', 'BuildContext', '-', required: true),
  _ApiRow('content', '确认内容', 'Widget', '-', required: true),
  _ApiRow('title', '标题', 'Widget?', '-'),
  _ApiRow('okText', '确认按钮文案', 'String', '确定'),
  _ApiRow('cancelText', '取消按钮文案', 'String', '取消'),
  _ApiRow('onOk', '确认前回调', 'VoidCallback?', '-'),
  _ApiRow('danger', '危险确认样式', 'bool', 'false'),
  _ApiRow('return', '返回用户选择结果', 'Future<bool?>', '-'),
];

const _descriptionsApi = [
  _ApiRow('items', '描述项', 'List<AnimalDescriptionItem>', '-', required: true),
  _ApiRow('title', '标题', 'Widget?', '-'),
  _ApiRow('column', '列数', 'int', '3'),
  _ApiRow('layout', '标签排列', 'AnimalDescriptionsLayout', 'horizontal'),
  _ApiRow('responsive', '是否根据容器宽度自动收列', 'bool', 'true'),
  _ApiRow('minColumnWidth', '响应式最小列宽', 'double', '170'),
  _ApiRow('AnimalDescriptionItem.label', '标签', 'Widget', '-', required: true),
  _ApiRow('AnimalDescriptionItem.child', '内容', 'Widget', '-', required: true),
  _ApiRow('AnimalDescriptionItem.span', '跨列数量', 'int', '1'),
];

const _statisticApi = [
  _ApiRow('value', '统计数值', 'num', '-', required: true),
  _ApiRow('title', '标题', 'Widget?', '-'),
  _ApiRow('prefix', '前缀', 'Widget?', '-'),
  _ApiRow('suffix', '后缀', 'Widget?', '-'),
  _ApiRow('description', '辅助说明', 'Widget?', '-'),
  _ApiRow('color', '数值强调色', 'Color?', 'primaryActiveColor'),
];

const _timelineApi = [
  _ApiRow('items', '时间线项', 'List<AnimalTimelineItem>', '-', required: true),
  _ApiRow('AnimalTimelineItem.title', '标题', 'Widget', '-', required: true),
  _ApiRow('AnimalTimelineItem.description', '描述', 'Widget?', '-'),
  _ApiRow('AnimalTimelineItem.time', '时间', 'Widget?', '-'),
  _ApiRow('AnimalTimelineItem.status', '状态色', 'AnimalTimelineItemStatus',
      'defaultStatus'),
  _ApiRow('AnimalTimelineItem.icon', '自定义节点图标', 'Widget?', '-'),
  _ApiRow('AnimalTimelineItem.onTap', '节点点击回调', 'VoidCallback?', '-'),
  _ApiRow('AnimalTimelineItem.disabled', '禁用节点交互', 'bool', 'false'),
];

const _calendarApi = [
  _ApiRow('value', '受控选中日期', 'DateTime?', '-'),
  _ApiRow('defaultValue', '默认选中日期', 'DateTime?', 'DateTime.now()'),
  _ApiRow('month', '当前展示月份', 'DateTime?', '选中日期所在月'),
  _ApiRow('firstDate', '最早可选日期', 'DateTime?', '-'),
  _ApiRow('lastDate', '最晚可选日期', 'DateTime?', '-'),
  _ApiRow('onChanged', '日期选择回调', 'ValueChanged<DateTime>?', '-'),
  _ApiRow('onMonthChanged', '月份切换回调', 'ValueChanged<DateTime>?', '-'),
  _ApiRow('keyboard', '方向键移动日期，PageUp/PageDown 切换月份', 'built-in', '-'),
  _ApiRow('AnimalCalendarFormField', '表单校验封装', 'FormField<DateTime>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<DateTime>?', '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<DateTime>?', '-'),
];

const _uploadApi = [
  _ApiRow('files', '文件列表', 'List<AnimalUploadFile>', '[]'),
  _ApiRow('onTap', '点击上传区域回调', 'VoidCallback?', '-'),
  _ApiRow('keyboard', '上传区域聚焦后 Enter/Space 触发 onTap', 'built-in', '-'),
  _ApiRow('onRemove', '删除文件回调', 'ValueChanged<AnimalUploadFile>?', '-'),
  _ApiRow(
      'onChanged', '表单文件列表变化回调', 'ValueChanged<List<AnimalUploadFile>>?', '-'),
  _ApiRow('disabled', '是否禁用', 'bool', 'false'),
  _ApiRow('removable', 'FormField 内是否允许删除文件', 'bool', 'true'),
  _ApiRow('title', '上传标题', 'String', '上传文件'),
  _ApiRow('hint', '上传说明', 'String', '点击选择文件，或将文件拖到这里'),
  _ApiRow('AnimalUploadFormField', '表单校验封装',
      'FormField<List<AnimalUploadFile>>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<List<AnimalUploadFile>>?',
      '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<List<AnimalUploadFile>>?', '-'),
  _ApiRow('AnimalUploadFile.name', '文件名', 'String', '-', required: true),
  _ApiRow('AnimalUploadFile.status', '上传状态', 'AnimalUploadStatus', 'ready'),
  _ApiRow('AnimalUploadFile.progress', '上传进度 0..1', 'double', '0'),
  _ApiRow('AnimalUploadFile.size', '文件大小文案', 'String?', '-'),
  _ApiRow('AnimalUploadFile.message', '状态说明', 'String?', '-'),
];

const _treeApi = [
  _ApiRow('nodes', '树节点列表', 'List<AnimalTreeNode<T>>', '-', required: true),
  _ApiRow('selectedValue', '当前选中节点值', 'T?', '-'),
  _ApiRow('defaultValue', 'FormField 默认选中值', 'T?', '-'),
  _ApiRow('defaultExpandedValues', '默认展开节点值', 'List<T>', '[]'),
  _ApiRow('onChanged', '节点点击回调', 'ValueChanged<T>?', '-'),
  _ApiRow('onExpandedChanged', '展开节点变化回调', 'ValueChanged<List<T>>?', '-'),
  _ApiRow('AnimalTreeFormField', '表单校验封装', 'FormField<T>', '-'),
  _ApiRow('validator', '表单校验函数', 'FormFieldValidator<T>?', '-'),
  _ApiRow('onSaved', '表单保存回调', 'FormFieldSetter<T>?', '-'),
  _ApiRow('AnimalTreeNode.value', '节点值', 'T', '-', required: true),
  _ApiRow('AnimalTreeNode.label', '节点内容', 'Widget', '-', required: true),
  _ApiRow('AnimalTreeNode.children', '子节点', 'List<AnimalTreeNode<T>>', '[]'),
  _ApiRow('AnimalTreeNode.disabled', '是否禁用节点', 'bool', 'false'),
  _ApiRow('AnimalTreeNode.icon', '节点图标', 'Widget?', '-'),
];

const _resultApi = [
  _ApiRow('title', '标题', 'Widget', '-', required: true),
  _ApiRow('description', '描述内容', 'Widget?', '-'),
  _ApiRow('status', '结果状态', 'AnimalResultStatus', 'info'),
  _ApiRow('extra', '补充内容', 'Widget?', '-'),
  _ApiRow('action', '操作区', 'Widget?', '-'),
];

const _mobileNavBarApi = [
  _ApiRow('title', '标题', 'Widget', '-', required: true),
  _ApiRow('leading', '左侧自定义内容', 'Widget?', '-'),
  _ApiRow('trailing', '右侧自定义内容', 'Widget?', '-'),
  _ApiRow('showBackButton', '是否显示默认返回按钮', 'bool', 'false'),
  _ApiRow('onBack', '返回按钮回调；为空时尝试 Navigator.maybePop', 'VoidCallback?', '-'),
  _ApiRow('safeAreaTop', '是否补偿顶部安全区', 'bool', 'true'),
  _ApiRow('height', '导航栏内容高度', 'double', '56'),
];

const _mobileBottomBarApi = [
  _ApiRow('items', '底部导航项', 'List<AnimalBottomBarItem>', '-', required: true),
  _ApiRow('currentIndex', '当前选中索引', 'int', '-', required: true),
  _ApiRow('onChanged', '切换回调', 'ValueChanged<int>', '-', required: true),
  _ApiRow('safeAreaBottom', '是否补偿底部安全区', 'bool', 'true'),
  _ApiRow('AnimalBottomBarItem.icon', '默认图标', 'Widget', '-', required: true),
  _ApiRow('AnimalBottomBarItem.activeIcon', '选中图标', 'Widget?', '-'),
  _ApiRow('AnimalBottomBarItem.label', '底部文字', 'Widget', '-', required: true),
  _ApiRow('AnimalBottomBarItem.badge', '徽标', 'Widget?', '-'),
];

const _mobileBottomSheetApi = [
  _ApiRow('context', '弹层上下文', 'BuildContext', '-', required: true),
  _ApiRow('child', '弹层内容', 'Widget', '-', required: true),
  _ApiRow('title', '标题', 'Widget?', '-'),
  _ApiRow('footer', '底部操作区', 'Widget?', '-'),
  _ApiRow('handle', '顶部拖拽把手显示策略', 'AnimalMobileBottomSheetHandle', 'visible'),
  _ApiRow('padding', '内容内边距', 'EdgeInsetsGeometry', 'EdgeInsets(20,8,20,20)'),
  _ApiRow('maxHeightFactor', '最大高度占屏幕比例', 'double', '0.84'),
  _ApiRow('barrierDismissible', '点击遮罩和下拉关闭', 'bool', 'true'),
];

const _mobileActionSheetApi = [
  _ApiRow('actions', '操作项列表', 'List<AnimalActionSheetAction<T>>', '-',
      required: true),
  _ApiRow('title', '标题', 'Widget?', '-'),
  _ApiRow('message', '说明文案', 'Widget?', '-'),
  _ApiRow('cancelText', '取消按钮内容', 'Widget', "Text('取消')"),
  _ApiRow('AnimalActionSheetAction.value', '操作返回值', 'T', '-', required: true),
  _ApiRow('AnimalActionSheetAction.label', '操作文案', 'Widget', '-',
      required: true),
  _ApiRow('AnimalActionSheetAction.icon', '前置图标', 'Widget?', '-'),
  _ApiRow('AnimalActionSheetAction.destructive', '是否危险操作', 'bool', 'false'),
  _ApiRow('AnimalActionSheetAction.disabled', '是否禁用', 'bool', 'false'),
];

const _mobileListTileApi = [
  _ApiRow('title', '主标题', 'Widget', '-', required: true),
  _ApiRow('subtitle', '副标题', 'Widget?', '-'),
  _ApiRow('leading', '左侧图标或头像', 'Widget?', '-'),
  _ApiRow('trailing', '右侧自定义内容', 'Widget?', '-'),
  _ApiRow('onTap', '点击回调；为空时为展示态', 'VoidCallback?', '-'),
  _ApiRow('disabled', '是否禁用', 'bool', 'false'),
  _ApiRow('destructive', '是否危险文本色', 'bool', 'false'),
  _ApiRow('showChevron', '是否显示默认右箭头', 'bool', 'true'),
  _ApiRow('minHeight', '最小高度', 'double', '54'),
  _ApiRow('textAlign', '文字对齐方式', 'TextAlign', 'start'),
];

const _mobileCellGroupApi = [
  _ApiRow('children', '单元格列表，通常放 AnimalListTile', 'List<Widget>', '-',
      required: true),
  _ApiRow('margin', '外边距', 'EdgeInsetsGeometry', 'EdgeInsets.zero'),
];

const _mobileSearchBarApi = [
  _ApiRow('controller', '外部文本控制器', 'TextEditingController?', '-'),
  _ApiRow('initialValue', '非受控初始值', 'String?', '-'),
  _ApiRow('hintText', '占位文案', 'String', '搜索'),
  _ApiRow('enabled', '是否可输入', 'bool', 'true'),
  _ApiRow('autofocus', '是否自动聚焦', 'bool', 'false'),
  _ApiRow('showCancel', '是否显示取消按钮', 'bool', 'false'),
  _ApiRow('cancelText', '取消按钮内容', 'Widget', "Text('取消')"),
  _ApiRow('onChanged', '输入变化回调', 'ValueChanged<String>?', '-'),
  _ApiRow('onSubmitted', '提交回调', 'ValueChanged<String>?', '-'),
  _ApiRow('onSearch', '搜索动作回调', 'ValueChanged<String>?', '-'),
  _ApiRow('onClear', '清空回调', 'VoidCallback?', '-'),
  _ApiRow('onCancel', '取消回调', 'VoidCallback?', '-'),
];

const _mobilePickerApi = [
  _ApiRow('options', '选项列表', 'List<AnimalPickerOption<T>>', '-',
      required: true),
  _ApiRow('value', '当前选中值', 'T?', '-'),
  _ApiRow('onChanged', '选择回调', 'ValueChanged<T>', '-', required: true),
  _ApiRow('closeOnSelect', '页面内选择后是否尝试关闭路由', 'bool', 'false'),
  _ApiRow('AnimalPicker.show.context', '弹层上下文', 'BuildContext', '-',
      required: true),
  _ApiRow('AnimalPicker.show.title', '弹层标题', 'Widget?', '-'),
  _ApiRow('AnimalPicker.show.message', '弹层说明', 'Widget?', '-'),
  _ApiRow('AnimalPicker.show.cancelText', '取消按钮内容', 'Widget', "Text('取消')"),
  _ApiRow('AnimalPickerOption.value', '选项值', 'T', '-', required: true),
  _ApiRow('AnimalPickerOption.label', '选项标题', 'Widget', '-', required: true),
  _ApiRow('AnimalPickerOption.subtitle', '选项说明', 'Widget?', '-'),
  _ApiRow('AnimalPickerOption.leading', '前置图标', 'Widget?', '-'),
  _ApiRow('AnimalPickerOption.disabled', '是否禁用', 'bool', 'false'),
];

const _mobileDatePickerApi = [
  _ApiRow('value', '受控日期', 'DateTime?', '-'),
  _ApiRow('defaultValue', '非受控默认日期', 'DateTime?', '-'),
  _ApiRow('firstDate', '可选开始日期', 'DateTime?', '-'),
  _ApiRow('lastDate', '可选结束日期', 'DateTime?', '-'),
  _ApiRow('onChanged', '确认日期回调', 'ValueChanged<DateTime>?', '-'),
  _ApiRow('showActions', '是否显示取消/确定按钮', 'bool', 'true'),
  _ApiRow('confirmText', '确认按钮文案', 'String', '确定'),
  _ApiRow('cancelText', '取消按钮文案', 'String', '取消'),
  _ApiRow(
      'AnimalMobileDatePicker.show.title', '底部弹层标题', 'Widget?', "Text('选择日期')"),
];

const _mobileStepperApi = [
  _ApiRow('value', '受控值', 'num?', '-'),
  _ApiRow('defaultValue', '非受控默认值', 'num', '0'),
  _ApiRow('min', '最小值', 'num?', '-'),
  _ApiRow('max', '最大值', 'num?', '-'),
  _ApiRow('step', '步长', 'num', '1'),
  _ApiRow('disabled', '是否禁用', 'bool', 'false'),
  _ApiRow('onChanged', '数值变化回调', 'ValueChanged<num>?', '-'),
  _ApiRow('formatter', '自定义数值展示', 'String Function(num)?', '-'),
];

const _mobileSwipeActionApi = [
  _ApiRow('child', '前景列表项内容', 'Widget', '-', required: true),
  _ApiRow('actions', '右侧操作按钮', 'List<AnimalSwipeActionItem>', '-',
      required: true),
  _ApiRow('actionExtent', '单个操作按钮宽度', 'double', '82'),
  _ApiRow('enabled', '是否允许滑动', 'bool', 'true'),
  _ApiRow('AnimalSwipeActionItem.label', '按钮文案', 'Widget', '-', required: true),
  _ApiRow('AnimalSwipeActionItem.onTap', '点击回调', 'VoidCallback', '-',
      required: true),
  _ApiRow('AnimalSwipeActionItem.icon', '按钮图标', 'Widget?', '-'),
  _ApiRow('AnimalSwipeActionItem.color', '自定义背景色', 'Color?', '-'),
  _ApiRow('AnimalSwipeActionItem.destructive', '是否危险操作', 'bool', 'false'),
  _ApiRow('AnimalSwipeActionItem.disabled', '是否禁用', 'bool', 'false'),
];

const _mobilePullRefreshApi = [
  _ApiRow('child', '滚动内容', 'Widget', '-', required: true),
  _ApiRow('onRefresh', '刷新回调', 'RefreshCallback', '-', required: true),
  _ApiRow('displacement', 'Animal 小岛指示器高度', 'double', '58'),
  _ApiRow('edgeOffset', '触发起始偏移', 'double', '0'),
  _ApiRow('style', '刷新指示器样式，默认小岛海风动画，可切回 Material 原生圈',
      'AnimalPullRefreshStyle', 'animal'),
  _ApiRow(
    'indicatorBuilder',
    '自定义 Animal 刷新指示器内容',
    'AnimalPullRefreshIndicatorBuilder?',
    '-',
  ),
  _ApiRow(
    'triggerMode',
    '触发模式，复杂滚动页可改为 anywhere',
    'RefreshIndicatorTriggerMode',
    'onEdge',
  ),
  _ApiRow(
    'notificationPredicate',
    '滚动通知过滤器',
    'ScrollNotificationPredicate',
    'defaultScrollNotificationPredicate',
  ),
  _ApiRow('semanticsLabel', '无障碍标签', 'String?', '-'),
  _ApiRow('semanticsValue', '无障碍状态', 'String?', '-'),
];

const _mobileSectionApi = [
  _ApiRow('child', '分区内容', 'Widget', '-', required: true),
  _ApiRow('title', '左侧标题', 'Widget?', '-'),
  _ApiRow('extra', '右侧操作', 'Widget?', '-'),
  _ApiRow(
      'margin', '分区外边距', 'EdgeInsetsGeometry', 'EdgeInsets.only(bottom: 16)'),
];

const _mobileProductCardApi = [
  _ApiRow('title', '商品标题', 'Widget', '-', required: true),
  _ApiRow('subtitle', '商品说明', 'Widget?', '-'),
  _ApiRow('price', '价格区域', 'Widget?', '-'),
  _ApiRow('image', '商品图或自定义占位', 'Widget?', '-'),
  _ApiRow('tag', '右上角标签', 'Widget?', '-'),
  _ApiRow('action', '右下角操作', 'Widget?', '-'),
  _ApiRow('onTap', '卡片点击回调', 'VoidCallback?', '-'),
];

const _mobileOrderCardApi = [
  _ApiRow('orderNo', '订单号', 'Widget', '-', required: true),
  _ApiRow('status', '订单状态', 'Widget', '-', required: true),
  _ApiRow('items', '商品明细', 'List<AnimalMobileOrderItem>', '[]'),
  _ApiRow('total', '合计信息', 'Widget?', '-'),
  _ApiRow('footer', '底部操作区', 'Widget?', '-'),
  _ApiRow('onTap', '卡片点击回调', 'VoidCallback?', '-'),
  _ApiRow('AnimalMobileOrderItem.title', '明细标题', 'Widget', '-', required: true),
  _ApiRow('AnimalMobileOrderItem.subtitle', '明细说明', 'Widget?', '-'),
  _ApiRow('AnimalMobileOrderItem.quantity', '数量', 'int?', '-'),
  _ApiRow('AnimalMobileOrderItem.price', '价格', 'Widget?', '-'),
  _ApiRow('AnimalMobileOrderItem.leading', '缩略图', 'Widget?', '-'),
];

const _mobileProfileHeaderApi = [
  _ApiRow('name', '用户名称', 'Widget', '-', required: true),
  _ApiRow('avatar', '头像', 'Widget?', '-'),
  _ApiRow('subtitle', '用户说明', 'Widget?', '-'),
  _ApiRow('actions', '操作按钮列表', 'List<Widget>', '[]'),
  _ApiRow('stats', '统计项列表', 'List<AnimalMobileStatItem>', '[]'),
];

const _mobileStatsGridApi = [
  _ApiRow('items', '统计项列表', 'List<AnimalMobileStatItem>', '-', required: true),
  _ApiRow('crossAxisCount', '每行列数，自动限制 1-4', 'int', '3'),
  _ApiRow('AnimalMobileStatItem.label', '指标名称', 'Widget', '-', required: true),
  _ApiRow('AnimalMobileStatItem.value', '指标值', 'Widget', '-', required: true),
  _ApiRow('AnimalMobileStatItem.icon', '图标', 'Widget?', '-'),
  _ApiRow('AnimalMobileStatItem.description', '补充说明', 'Widget?', '-'),
  _ApiRow('AnimalMobileStatItem.color', '强调色', 'Color?', '-'),
  _ApiRow('AnimalMobileStatItem.onTap', '点击回调', 'VoidCallback?', '-'),
];

const _mobileCouponCardApi = [
  _ApiRow('amount', '券面金额或折扣', 'Widget', '-', required: true),
  _ApiRow('title', '优惠券标题', 'Widget', '-', required: true),
  _ApiRow('description', '优惠券说明', 'Widget?', '-'),
  _ApiRow('status', '优惠券状态', 'AnimalMobileCouponStatus', 'available'),
  _ApiRow('actionText', '可领取状态按钮文案', 'String', '领取'),
  _ApiRow('onTap', '可领取状态点击回调', 'VoidCallback?', '-'),
];

const _mobileNoticeBarApi = [
  _ApiRow('child', '公告内容', 'Widget', '-', required: true),
  _ApiRow('type', '公告状态', 'AnimalMobileNoticeType', 'info'),
  _ApiRow('icon', '前置图标', 'Widget?', '-'),
  _ApiRow('action', '右侧操作内容', 'Widget?', '-'),
  _ApiRow('onTap', '点击回调', 'VoidCallback?', '-'),
  _ApiRow('showChevron', '是否显示右箭头', 'bool', 'false'),
];

const _mobileAddressCardApi = [
  _ApiRow('name', '收货人', 'Widget', '-', required: true),
  _ApiRow('phone', '手机号', 'Widget', '-', required: true),
  _ApiRow('address', '详细地址', 'Widget', '-', required: true),
  _ApiRow('tag', '地址标签', 'Widget?', '-'),
  _ApiRow('leading', '左侧图标或头像', 'Widget?', '-'),
  _ApiRow('trailing', '右侧自定义内容', 'Widget?', '-'),
  _ApiRow('selected', '是否选中地址', 'bool', 'false'),
  _ApiRow('onTap', '点击回调', 'VoidCallback?', '-'),
];

const _mobilePriceSummaryApi = [
  _ApiRow('items', '费用明细列表', 'List<AnimalMobilePriceItem>', '-',
      required: true),
  _ApiRow('totalLabel', '合计标签', 'Widget?', "Text('合计')"),
  _ApiRow('total', '合计金额', 'Widget?', '-'),
  _ApiRow('footer', '底部补充说明', 'Widget?', '-'),
  _ApiRow('AnimalMobilePriceItem.label', '明细名称', 'Widget', '-', required: true),
  _ApiRow('AnimalMobilePriceItem.value', '明细金额', 'Widget', '-', required: true),
  _ApiRow('AnimalMobilePriceItem.emphasized', '是否强调该行', 'bool', 'false'),
  _ApiRow('AnimalMobilePriceItem.color', '自定义金额颜色', 'Color?', '-'),
];

const _mobileCheckoutBarApi = [
  _ApiRow('total', '合计金额', 'Widget', '-', required: true),
  _ApiRow('action', '右侧主操作', 'Widget', '-', required: true),
  _ApiRow('label', '金额上方标签', 'Widget?', "Text('合计')"),
  _ApiRow('extra', '金额下方说明', 'Widget?', '-'),
  _ApiRow('safeAreaBottom', '是否补偿底部安全区', 'bool', 'true'),
  _ApiRow('padding', '内边距', 'EdgeInsetsGeometry', 'EdgeInsets(14,10,14,10)'),
];

const _mobileCartItemApi = [
  _ApiRow('title', '商品标题', 'Widget', '-', required: true),
  _ApiRow('subtitle', '规格或补充说明', 'Widget?', '-'),
  _ApiRow('price', '价格区域', 'Widget?', '-'),
  _ApiRow('image', '商品图或占位', 'Widget?', '-'),
  _ApiRow('quantity', '数量', 'num?', '-'),
  _ApiRow('onQuantityChanged', '数量变化回调', 'ValueChanged<num>?', '-'),
  _ApiRow('selected', '是否选中', 'bool', 'false'),
  _ApiRow('onSelectedChanged', '选中变化回调', 'ValueChanged<bool>?', '-'),
  _ApiRow('tag', '右上角标签', 'Widget?', '-'),
  _ApiRow('action', '右下角自定义操作', 'Widget?', '-'),
  _ApiRow('disabled', '是否失效/禁用', 'bool', 'false'),
  _ApiRow('disabledText', '失效说明', 'Widget?', '-'),
  _ApiRow('onTap', '卡片点击回调', 'VoidCallback?', '-'),
];

const _mobileOrderTimelineApi = [
  _ApiRow('items', '时间线项', 'List<AnimalMobileTimelineItem>', '-',
      required: true),
  _ApiRow('padding', '内边距', 'EdgeInsetsGeometry', 'EdgeInsets.all(14)'),
  _ApiRow('AnimalMobileTimelineItem.title', '节点标题', 'Widget', '-',
      required: true),
  _ApiRow('AnimalMobileTimelineItem.description', '节点说明', 'Widget?', '-'),
  _ApiRow('AnimalMobileTimelineItem.time', '节点时间', 'Widget?', '-'),
  _ApiRow('AnimalMobileTimelineItem.icon', '节点图标', 'Widget?', '-'),
  _ApiRow('AnimalMobileTimelineItem.status', '节点状态',
      'AnimalMobileTimelineStatus', 'defaultStatus'),
  _ApiRow('AnimalMobileTimelineItem.onTap', '点击回调', 'VoidCallback?', '-'),
  _ApiRow('AnimalMobileTimelineItem.disabled', '禁用点击态', 'bool', 'false'),
];

const _mobilePaymentMethodApi = [
  _ApiRow('title', '支付方式名称', 'Widget', '-', required: true),
  _ApiRow('subtitle', '支付方式说明', 'Widget?', '-'),
  _ApiRow('icon', '左侧图标', 'Widget?', '-'),
  _ApiRow('trailing', '右侧自定义内容', 'Widget?', '-'),
  _ApiRow('selected', '是否选中', 'bool', 'false'),
  _ApiRow('disabled', '是否禁用', 'bool', 'false'),
  _ApiRow('onTap', '点击回调', 'VoidCallback?', '-'),
];

const _mobileEmptyActionApi = [
  _ApiRow('title', '空状态标题', 'Widget', '-', required: true),
  _ApiRow('description', '说明文案', 'Widget?', '-'),
  _ApiRow('icon', '图标或插画位', 'Widget?', '-'),
  _ApiRow('action', '主行动按钮', 'Widget?', '-'),
  _ApiRow(
      'padding', '内边距', 'EdgeInsetsGeometry', 'EdgeInsets.symmetric(22,26)'),
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
}

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  var primary = const Color(0xFF19C8B9);

  @override
  Widget build(BuildContext context) {
    final theme = AnimalThemeData.fromPrimary(primary);
    return AnimalTheme(
      data: theme,
      child: Column(
        children: [
          Wrap(
            children: [
              AnimalButton(onPressed: () => setState(() => primary = const Color(0xFF19C8B9)), child: const Text('Mint')),
              AnimalButton(onPressed: () => setState(() => primary = const Color(0xFFD85C7D)), child: const Text('Berry')),
              AnimalButton(onPressed: () => setState(() => primary = const Color(0xFF3D82C4)), child: const Text('Ocean')),
            ],
          ),
          AnimalButton(type: AnimalButtonType.primary, onPressed: () {}, child: const Text('Primary')),
          const AnimalProgress(value: 0.64),
        ],
      ),
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
        // Form 表单封装
        Form(
          child: AnimalSwitchFormField(
            validator: (next) => next == true ? null : '需要开启',
          ),
        ),
      ],
    );
  }
}''';

const _themeCode =
    r'''import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

final forestTheme = AnimalThemeData.fromPrimary(
  const Color(0xFF4E8F75),
  textColor: const Color(0xFF5B4228),
).copyWith(
  radius: 22,
  radiusLarge: 30,
);

final neutralTheme = AnimalThemeData.fromPrimary(
  const Color(0xFF4E8F75),
  textColor: const Color(0xFF4C3525),
).copyWith(
  backgroundColor: const Color(0xFFF4F1E7),
  secondaryBackgroundColor: const Color(0xFFE9DFCC),
  borderColor: const Color(0xFFA89170),
  lightBorderColor: const Color(0xFFE2D5BD),
);

final appFontTheme = AnimalThemeData.fallback().copyWith(
  fontFamily: 'Inter',
  fontPackage: null, // 使用应用自身注册的字体，而不是 package 字体
  fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
  textHeight: 1.45,
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimalTheme(
      data: forestTheme,
      child: Scaffold(
        body: Center(
          child: AnimalButton(
            type: AnimalButtonType.primary,
            onPressed: () {},
            child: const Text('Forest primary'),
          ),
        ),
      ),
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
        // 长列表限制最大高度，移动端更友好
        AnimalSelect<String>(options: options, value: value, dropdownMaxHeight: 220, onChanged: (next) => setState(() => value = next)),
        // 禁用状态
        AnimalSelect<String>(options: options, value: value, onChanged: (_) {}, disabled: true),
        // Form 表单封装
        Form(
          child: AnimalSelectFormField<String>(
            options: options,
            value: null,
            validator: (next) => next == null ? '请选择' : null,
          ),
        ),
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
    return Column(
      children: [
        // 非受控
        const AnimalCheckbox<String>(options: options, defaultValue: ['beach']),
        // 垂直排列
        const AnimalCheckbox<String>(options: options, direction: AnimalCheckboxDirection.vertical),
        // Form 表单封装
        Form(
          child: AnimalCheckboxFormField<String>(
            options: options,
            validator: (next) => next == null || next.isEmpty ? '至少选择一项' : null,
          ),
        ),
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
        AnimalTableColumn(title: const Text('喜欢的水果'), cellBuilder: (_, row, __) => Text(row['fruit'] as String)),
        AnimalTableColumn(title: const Text('爱好'), cellBuilder: (_, row, __) => Text(row['hobby'] as String)),
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
)

Form(
  child: AnimalRadioFormField<String>(
    options: const [
      AnimalRadioOption(value: 'morning', label: Text('上午')),
      AnimalRadioOption(value: 'night', label: Text('夜晚')),
    ],
    validator: (next) => next == null ? '请选择时间' : null,
  ),
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

const AnimalSlider(defaultValue: 60, disabled: true)

Form(
  child: AnimalSliderFormField(
    divisions: 10,
    validator: (next) => (next ?? 0) >= 50 ? null : '至少 50',
  ),
)''';

const _rateCode = r'''AnimalRate(
  value: rate,
  onChanged: (next) => setState(() => rate = next),
)

const AnimalRate(defaultValue: 3)
const AnimalRate(defaultValue: 6, count: 8)
const AnimalRate(defaultValue: 4, disabled: true)

Form(
  child: AnimalRateFormField(
    validator: (next) => (next ?? 0) > 0 ? null : '请评分',
  ),
)''';

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

const _formCode = r'''final formKey = GlobalKey<FormState>();

AnimalForm(
  formKey: formKey,
  layout: AnimalFormLayout.horizontal,
  labelWidth: 96,
  child: Column(
    children: const [
      AnimalFormItem(
        label: Text('岛民昵称'),
        required: true,
        help: Text('显示在岛民名片上。'),
        child: AnimalInput(hintText: '请输入昵称', allowClear: true),
      ),
      AnimalFormItem(
        label: Text('状态'),
        errorText: '请确认今天是否开放登岛。',
        child: AnimalSwitch(defaultValue: false),
      ),
    ],
  ),
)

const AnimalForm(
  layout: AnimalFormLayout.inline,
  child: Wrap(
    spacing: 12,
    children: [
      AnimalFormItem(
        label: Text('关键词'),
        margin: EdgeInsets.zero,
        child: AnimalSearchInput(hintText: '搜索岛民'),
      ),
    ],
  ),
)''';

const _inputPlusCode = r'''const AnimalTextarea(
  hintText: '写下今天的岛屿计划',
  rows: 4,
  maxLength: 80,
  allowClear: true,
)

const AnimalPasswordInput(initialValue: 'turnip-price')

AnimalSearchInput(
  hintText: '搜索收藏品',
  onSearch: (value) => debugPrint(value),
)

AnimalNumberInput(
  defaultValue: 3,
  min: 0,
  max: 10,
  step: 1,
  onChanged: (value) => debugPrint('$value'),
)''';

const _popoverCode = r'''const AnimalPopover(
  title: Text('岛屿提示'),
  content: Text('今日高价收购大头菜。'),
  child: AnimalButton(
    type: AnimalButtonType.primary,
    child: Text('点击查看'),
  ),
)

const AnimalPopover(
  trigger: AnimalPopoverTrigger.hover,
  placement: AnimalPopoverPlacement.right,
  content: Text('右侧气泡'),
  child: Text('悬停查看'),
)

AnimalPopover(
  open: open,
  trigger: AnimalPopoverTrigger.manual,
  onOpenChanged: (value) => setState(() => open = value),
  content: const Text('受控浮层'),
  child: const Text('Manual'),
)''';

const _dropdownCode = r'''AnimalDropdown<String>(
  items: const [
    AnimalDropdownItem(
      value: 'copy',
      icon: Icon(Icons.copy_rounded),
      label: Text('复制地址'),
    ),
    AnimalDropdownItem(
      value: 'delete',
      icon: Icon(Icons.delete_rounded),
      label: Text('删除记录'),
      disabled: true,
    ),
  ],
  onChanged: (value) => setState(() => selected = value),
  child: const AnimalButton(
    type: AnimalButtonType.primary,
    child: Text('打开菜单'),
  ),
)''';

const _drawerCode = r'''AnimalDrawer.show<void>(
  context: context,
  placement: AnimalDrawerPlacement.right,
  title: const Text('岛屿背包'),
  footer: AnimalButton(
    type: AnimalButtonType.primary,
    block: true,
    onPressed: () => Navigator.of(context).maybePop(),
    child: const Text('整理完成'),
  ),
  child: const Text('抽屉内容'),
)

AnimalDrawer.show<void>(
  context: context,
  placement: AnimalDrawerPlacement.left,
  child: const Text('左侧抽屉'),
)''';

const _confirmDialogCode = r'''final result = await AnimalConfirmDialog.show(
  context: context,
  title: const Text('提交订单'),
  content: const Text('确定要提交这批岛屿物资吗？'),
);

await AnimalConfirmDialog.show(
  context: context,
  title: const Text('删除记录'),
  danger: true,
  okText: '删除',
  content: const Text('删除后无法恢复，确定继续吗？'),
);''';

const _descriptionsCode = r'''const AnimalDescriptions(
  title: Text('岛屿信息'),
  column: 3,
  items: [
    AnimalDescriptionItem(label: Text('名称'), child: Text('星露岛')),
    AnimalDescriptionItem(label: Text('水果'), child: Text('桃子')),
    AnimalDescriptionItem(label: Text('天气'), child: Text('晴朗')),
    AnimalDescriptionItem(
      label: Text('公告'),
      span: 2,
      child: Text('今晚八点有烟花大会。'),
    ),
  ],
)

const AnimalDescriptions(
  column: 2,
  layout: AnimalDescriptionsLayout.vertical,
  items: [
    AnimalDescriptionItem(label: Text('任务'), child: Text('整理花园')),
    AnimalDescriptionItem(label: Text('负责人'), child: Text('西施惠')),
  ],
)
// responsive 默认为 true，窄容器下会自动减少列数并切换为纵向标签。''';

const _statisticCode = r'''const AnimalStatistic(
  title: Text('今日访客'),
  value: 128,
  suffix: Text('人'),
  description: Text('比昨天 +18'),
)

const AnimalStatistic(
  title: Text('大头菜价格'),
  value: 586,
  prefix: Icon(Icons.spa_rounded),
  suffix: Text('铃钱'),
  color: Color(0xFFE5A928),
)''';

const _timelineCode = r'''AnimalTimeline(
  items: [
    AnimalTimelineItem(
      title: const Text('整理背包'),
      description: const Text('检查工具和素材是否齐全。'),
      time: const Text('09:00'),
      status: AnimalTimelineItemStatus.success,
      icon: const Icon(Icons.check_rounded),
      onTap: () => setState(() => activeStep = '整理背包'),
    ),
    AnimalTimelineItem(
      title: const Text('出发采集'),
      description: const Text('前往北侧森林采集木材。'),
      time: const Text('10:30'),
      status: AnimalTimelineItemStatus.primary,
      onTap: () => setState(() => activeStep = '出发采集'),
    ),
    const AnimalTimelineItem(
      title: Text('等待确认'),
      status: AnimalTimelineItemStatus.warning,
      disabled: true,
    ),
  ],
)
// 带 onTap 的节点支持 hover、小手和 Enter / Space。''';

const _calendarCode = r'''AnimalCalendar(
  value: selectedDate,
  month: DateTime(selectedDate.year, selectedDate.month),
  firstDate: DateTime(2026, 5, 1),
  lastDate: DateTime(2026, 5, 31),
  onChanged: (value) => setState(() => selectedDate = value),
  onMonthChanged: (value) => debugPrint('$value'),
)
// 聚焦日期后可用方向键移动，PageUp / PageDown 切换月份。

AnimalCalendarFormField(
  defaultValue: DateTime(2026, 5, 18),
  firstDate: DateTime(2026, 5, 10),
  lastDate: DateTime(2026, 5, 24),
  validator: (value) => value == null ? '请选择预约日期' : null,
)''';

const _uploadCode = r'''AnimalUpload(
  files: const [
    AnimalUploadFile(
      name: 'island-plan.pdf',
      status: AnimalUploadStatus.uploading,
      progress: 0.58,
      size: '2.4 MB',
    ),
    AnimalUploadFile(
      name: 'market-photo.png',
      status: AnimalUploadStatus.done,
      message: '上传完成',
    ),
  ],
  onTap: () {},
  onRemove: (file) {},
)
// 上传区域获得焦点后支持 Enter / Space 触发 onTap。

AnimalUploadFormField(
  files: files,
  title: '上传资料',
  hint: '至少保留一个资料文件',
  validator: (files) => files == null || files.isEmpty ? '请上传资料附件' : null,
  onChanged: (files) => setState(() => this.files = files),
)''';

const _treeCode = r'''AnimalTree<String>(
  selectedValue: selected,
  defaultExpandedValues: const ['plants'],
  onChanged: (value) => setState(() => selected = value),
  nodes: const [
    AnimalTreeNode(
      value: 'plants',
      label: Text('植物图鉴'),
      icon: Icon(Icons.local_florist_rounded),
      children: [
        AnimalTreeNode(value: 'rose', label: Text('玫瑰')),
        AnimalTreeNode(value: 'tulip', label: Text('郁金香')),
      ],
    ),
  ],
)

AnimalTreeFormField<String>(
  nodes: nodes,
  defaultValue: selected,
  defaultExpandedValues: const ['plants'],
  validator: (value) => value == null ? '请选择一个图鉴节点' : null,
  onChanged: (value) => setState(() => selected = value),
)''';

const _resultCode = r'''const AnimalResult(
  status: AnimalResultStatus.success,
  title: Text('岛屿资料提交成功'),
  description: Text('新的访客计划已经同步到服务处。'),
  extra: AnimalTag(
    color: AnimalTagColor.success,
    child: Text('已归档'),
  ),
  action: AnimalButton(
    type: AnimalButtonType.primary,
    onPressed: null,
    child: Text('返回列表'),
  ),
)''';

const _mobileNavBarCode = r'''AnimalMobileNavBar(
  title: const Text('岛屿背包'),
  showBackButton: true,
  trailing: const Icon(Icons.more_horiz_rounded),
  onBack: () => Navigator.maybePop(context),
)''';

const _mobileBottomBarCode = r'''AnimalBottomBar(
  currentIndex: currentIndex,
  onChanged: (index) => setState(() => currentIndex = index),
  items: const [
    AnimalBottomBarItem(
      icon: Icon(Icons.home_rounded),
      label: Text('首页'),
    ),
    AnimalBottomBarItem(
      icon: Icon(Icons.widgets_rounded),
      label: Text('组件'),
      badge: AnimalBadge(dot: true),
    ),
    AnimalBottomBarItem(
      icon: Icon(Icons.person_rounded),
      label: Text('我的'),
    ),
  ],
)''';

const _mobileBottomSheetCode = r'''AnimalBottomSheet.show<void>(
  context: context,
  title: const Text('岛屿计划'),
  child: const AnimalCellGroup(
    children: [
      AnimalListTile(
        leading: Icon(Icons.local_florist_rounded),
        title: Text('整理花园'),
        subtitle: Text('今天 16:00'),
      ),
      AnimalListTile(
        leading: Icon(Icons.shopping_bag_rounded),
        title: Text('采购家具'),
        subtitle: Text('狸然超市'),
      ),
    ],
  ),
)''';

const _mobileActionSheetCode =
    r'''final value = await AnimalActionSheet.show<String>(
  context: context,
  title: const Text('更多操作'),
  message: const Text('选择一个适合触摸场景的操作。'),
  actions: const [
    AnimalActionSheetAction(
      value: 'share',
      icon: Icon(Icons.ios_share_rounded),
      label: Text('分享岛屿'),
    ),
    AnimalActionSheetAction(
      value: 'delete',
      icon: Icon(Icons.delete_rounded),
      label: Text('删除记录'),
      destructive: true,
    ),
  ],
)''';

const _mobileListTileCode = r'''const AnimalListTile(
  leading: Icon(Icons.notifications_rounded),
  title: Text('岛屿通知'),
  subtitle: Text('访客抵达时提醒我'),
  trailing: AnimalSwitch(size: AnimalSwitchSize.small),
)''';

const _mobileCellGroupCode = r'''const AnimalCellGroup(
  children: [
    AnimalListTile(
      leading: Icon(Icons.person_rounded),
      title: Text('个人资料'),
    ),
    AnimalListTile(
      leading: Icon(Icons.palette_rounded),
      title: Text('主题偏好'),
      subtitle: Text('主色、字体和圆角'),
    ),
    AnimalListTile(
      leading: Icon(Icons.logout_rounded),
      title: Text('退出登录'),
      destructive: true,
      showChevron: false,
    ),
  ],
)''';

const _mobileSearchBarCode = r'''AnimalMobileSearchBar(
  initialValue: '樱桃',
  hintText: '搜索岛屿商品',
  showCancel: true,
  onSearch: (value) => AnimalMessage.info(context, Text('搜索 $value')),
  onClear: () {},
  onCancel: () {},
)''';

const _mobilePickerCode = r'''final value = await AnimalPicker.show<String>(
  context: context,
  title: const Text('选择配送岛屿'),
  value: 'north',
  options: const [
    AnimalPickerOption(
      value: 'north',
      leading: Icon(Icons.park_rounded),
      label: Text('北岸森林岛'),
      subtitle: Text('预计 30 分钟送达'),
    ),
    AnimalPickerOption(
      value: 'south',
      leading: Icon(Icons.water_rounded),
      label: Text('南湾海风岛'),
      subtitle: Text('预计 45 分钟送达'),
    ),
  ],
)''';

const _mobileDatePickerCode =
    r'''final date = await AnimalMobileDatePicker.show(
  context: context,
  value: DateTime(2026, 5, 22),
  firstDate: DateTime(2026, 5, 1),
  lastDate: DateTime(2026, 6, 30),
)''';

const _mobileStepperCode = r'''AnimalMobileStepper(
  defaultValue: 2,
  min: 0,
  max: 9,
  onChanged: (value) {},
)''';

const _mobileSwipeActionCode = r'''AnimalSwipeAction(
  actions: [
    AnimalSwipeActionItem(
      icon: const Icon(Icons.archive_rounded),
      label: const Text('归档'),
      onTap: () {},
    ),
    AnimalSwipeActionItem(
      icon: const Icon(Icons.delete_rounded),
      label: const Text('删除'),
      destructive: true,
      onTap: () {},
    ),
  ],
  child: const AnimalListTile(
    leading: Icon(Icons.receipt_long_rounded),
    title: Text('订单 #A001'),
    subtitle: Text('向左拖动查看操作'),
  ),
)''';

const _mobilePullRefreshCode = r'''AnimalPullRefresh(
  onRefresh: () async {
    await Future<void>.delayed(const Duration(milliseconds: 360));
  },
  child: ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: const [
      AnimalListTile(title: Text('下拉刷新今日任务')),
    ],
  ),
)''';

const _mobileSectionCode = r'''const AnimalMobileSection(
  title: Text('今日推荐'),
  extra: Text('查看全部'),
  child: AnimalMobileProductCard(
    title: Text('樱桃果篮'),
    subtitle: Text('岛屿直送，今日 18:00 前送达'),
    price: Text('120 铃钱'),
  ),
)''';

const _mobileProductCardCode = r'''const AnimalMobileProductCard(
  title: Text('樱桃果篮'),
  subtitle: Text('岛屿直送，今日 18:00 前送达'),
  price: Text('120 铃钱'),
  tag: AnimalTag(
    color: AnimalTagColor.danger,
    size: AnimalTagSize.small,
    child: Text('热卖'),
  ),
  action: AnimalButton(
    type: AnimalButtonType.primary,
    size: AnimalButtonSize.small,
    child: Text('加购'),
  ),
)''';

const _mobileOrderCardCode = r'''const AnimalMobileOrderCard(
  orderNo: Text('订单 #A001'),
  status: Text('配送中'),
  items: [
    AnimalMobileOrderItem(
      title: Text('樱桃果篮'),
      subtitle: Text('南湾海风岛'),
      quantity: 2,
      price: Text('120'),
    ),
  ],
  total: Text('合计 560 铃钱'),
)''';

const _mobileProfileHeaderCode = r'''const AnimalMobileProfileHeader(
  name: Text('狸克'),
  subtitle: Text('岛屿居民服务处 · Lv.8'),
  stats: [
    AnimalMobileStatItem(
      label: Text('订单'),
      value: Text('12'),
      icon: Icon(Icons.inventory_2_rounded),
    ),
    AnimalMobileStatItem(
      label: Text('积分'),
      value: Text('840'),
      icon: Icon(Icons.stars_rounded),
    ),
  ],
  actions: [
    AnimalButton(
      type: AnimalButtonType.primary,
      size: AnimalButtonSize.small,
      child: Text('编辑资料'),
    ),
  ],
)''';

const _mobileStatsGridCode = r'''const AnimalMobileStatsGrid(
  items: [
    AnimalMobileStatItem(
      label: Text('待付款'),
      value: Text('2'),
      description: Text('订单'),
      icon: Icon(Icons.payments_rounded),
    ),
    AnimalMobileStatItem(
      label: Text('配送中'),
      value: Text('5'),
      description: Text('包裹'),
      icon: Icon(Icons.local_shipping_rounded),
    ),
  ],
)''';

const _mobileCouponCardCode = r'''const AnimalMobileCouponCard(
  amount: Text('-20'),
  title: Text('新人购物券'),
  description: Text('满 100 铃钱可用，今日有效'),
)

const AnimalMobileCouponCard(
  amount: Text('8折'),
  title: Text('家具节折扣券'),
  status: AnimalMobileCouponStatus.claimed,
)''';

const _mobileNoticeBarCode = r'''AnimalMobileNoticeBar(
  type: AnimalMobileNoticeType.warning,
  action: const Text('查看'),
  showChevron: true,
  onTap: () {},
  child: const Text('部分海岛受天气影响，配送时间可能延迟。'),
)''';

const _mobileAddressCardCode = r'''const AnimalMobileAddressCard(
  selected: true,
  name: Text('狸克'),
  phone: Text('138 0000 0522'),
  tag: AnimalTag(
    color: AnimalTagColor.primary,
    size: AnimalTagSize.small,
    child: Text('默认'),
  ),
  address: Text('星露岛 居民服务处旁 1 号营地'),
)''';

const _mobilePriceSummaryCode = r'''const AnimalMobilePriceSummary(
  items: [
    AnimalMobilePriceItem(label: Text('商品金额'), value: Text('560 铃钱')),
    AnimalMobilePriceItem(label: Text('配送服务'), value: Text('20 铃钱')),
    AnimalMobilePriceItem(
      label: Text('优惠券'),
      value: Text('-20 铃钱'),
      emphasized: true,
    ),
  ],
  total: Text('560 铃钱'),
)''';

const _mobileCheckoutBarCode = r'''AnimalMobileCheckoutBar(
  total: const Text('560 铃钱'),
  extra: const Text('已优惠 20 铃钱'),
  action: AnimalButton(
    type: AnimalButtonType.primary,
    onPressed: () {},
    child: const Text('去结算'),
  ),
)''';

const _mobileCartItemCode = r'''AnimalMobileCartItem(
  selected: selected,
  onSelectedChanged: (value) => setState(() => selected = value),
  title: const Text('樱桃果篮'),
  subtitle: const Text('规格：大份 / 今日 18:00 前送达'),
  price: const Text('120 铃钱'),
  quantity: quantity,
  onQuantityChanged: (value) => setState(() => quantity = value),
)''';

const _mobileOrderTimelineCode = r'''const AnimalMobileOrderTimeline(
  items: [
    AnimalMobileTimelineItem(
      title: Text('订单已提交'),
      description: Text('居民服务处已收到你的订单。'),
      time: Text('09:30'),
      status: AnimalMobileTimelineStatus.success,
      icon: Icon(Icons.check_rounded),
    ),
    AnimalMobileTimelineItem(
      title: Text('正在配送'),
      description: Text('豆狸正在把包裹送往星露岛。'),
      time: Text('10:12'),
      status: AnimalMobileTimelineStatus.processing,
      icon: Icon(Icons.local_shipping_rounded),
    ),
  ],
)''';

const _mobilePaymentMethodCode = r'''const AnimalMobilePaymentMethodCard(
  selected: true,
  icon: Icon(Icons.account_balance_wallet_rounded),
  title: Text('铃钱钱包'),
  subtitle: Text('余额 8,400 铃钱，可直接抵扣'),
)''';

const _mobileEmptyActionCode = r'''AnimalMobileEmptyAction(
  icon: const Icon(Icons.shopping_cart_rounded),
  title: const Text('购物车还是空的'),
  description: const Text('去挑选一些岛屿好物，结算栏会自动汇总金额。'),
  action: AnimalButton(
    type: AnimalButtonType.primary,
    onPressed: () {},
    child: const Text('去逛逛'),
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
