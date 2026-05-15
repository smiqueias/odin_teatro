# Odin Teatro — Design System Reference

Use this skill to get guidance on any aspect of the Odin Teatro design system: setup, components, theming, tokens, and cross-project customization.

**Import único:** `import 'package:odin_teatro/design_system/odin_teatro.dart';`

---

## 1. Setup — OdinThemeProvider

O `OdinThemeProvider` é o ponto de entrada obrigatório. Deve envolver toda a árvore de widgets do app. Ele cria todos os 22 temas de componentes automaticamente a partir de `appColorScheme` e `typography`.

```dart
// main.dart
OdinThemeProvider(
  appColorScheme: odinLightColorScheme, // ou odinDarkColorScheme
  typography: defaultTypography,        // tipografia padrão (BtgPactualSans)
  builder: (context) => MaterialApp(
    home: MyHomePage(),
  ),
)
```

**Parâmetros:**
| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `appColorScheme` | `OdinColorScheme` | ✅ | Paleta de cores (OdinLight ou customizada) |
| `typography` | `OdinTypography` | ✅ | Sistema tipográfico |
| `builder` | `WidgetBuilder` | ✅ | Builder que recebe o contexto com o tema injetado |
| `isInverse` | `bool` | ❌ | `false` por padrão. Inverte semântica de cores |

**Acessar o provider manualmente:**
```dart
final theme = OdinThemeProvider.of(context);
final color = theme.appColorScheme.primaryBase;
final style = theme.typography.bodyBase;
```

---

## 2. Instâncias de Color Scheme

### OdinLight (tema padrão)
```dart
import 'package:odin_teatro/design_system/color_scheme/instances/odin_light.dart';

OdinThemeProvider(appColorScheme: odinLightColorScheme, ...)
```

### OdinDark (tema escuro)
```dart
import 'package:odin_teatro/design_system/color_scheme/instances/odin_dark.dart';

OdinThemeProvider(appColorScheme: odinDarkColorScheme, ...)
```

---

## 3. Tokens de Fundação

### Espaçamento
```dart
// Valores numéricos (use em padding/margin)
OdinGapValue.xxxs  // 4.0
OdinGapValue.xxs   // 8.0
OdinGapValue.xs    // 16.0
OdinGapValue.sm    // 24.0
OdinGapValue.md    // 32.0
OdinGapValue.lg    // 40.0
OdinGapValue.xl    // 48.0
OdinGapValue.xxl   // 64.0
OdinGapValue.xxxl  // 128.0

// Widgets Gap prontos (use em Column/Row)
OdinGap.xxxs  // Gap(4)
OdinGap.xs    // Gap(16)
OdinGap.sm    // Gap(24)
// ... mesma escala

// Para SliverList / CustomScrollView
OdinSliverGap.xs

// Padding values
OdinPaddingValue.xs   // 16.0
OdinPaddingValue.sm   // 24.0
OdinPaddingValue.md   // 32.0
```

### Border Radius
```dart
OdinBorderRadius.circular_radius_8   // BorderRadius.all(Radius.circular(8))
OdinBorderRadius.circular_radius_10
OdinBorderRadius.circular_radius_12
OdinBorderRadius.circular_radius_16
OdinBorderRadius.circular_radius_20
OdinBorderRadius.circular_radius_32
```

### Tipografia — TextStyles prontos
```dart
final t = OdinThemeProvider.of(context).typography;

t.displayBase          // 28px, regular, lineHeight large
t.titleBase            // 24px, regular, lineHeight medium
t.titleSmall           // 18px, regular, lineHeight medium
t.bodyBase             // 16px, regular, lineHeight large
t.bodySmall            // 14px, regular, lineHeight large
t.captionBase          // 12px, regular, lineHeight large
t.labelBase            // 16px, regular, lineHeight medium
t.labelSmall           // 14px, regular, lineHeight medium
t.labelTiny            // 12px, regular, lineHeight medium
t.labelMicro           // 10px, regular, lineHeight medium

// Variantes decoradas
t.displayBaseUnderline
t.bodyBaseUnderline / t.bodyBaseStrikethrough
t.bodySmallUnderline / t.bodySmallStrikethrough
t.labelBaseUnderline / t.labelBaseStrikethrough
t.labelSmallUnderline / t.labelSmallStrikethrough
t.captionBaseStrikethrough
```

### Tipografia — Escala de tamanhos
```dart
final fs = OdinThemeProvider.of(context).typography.fontSize;
// xxs=10, xs=12, sm=14, base=16, md=18, lg=24, xl=28, xxl=32, xxxl=48, xxxxl=64
```

### Ícones
```dart
// Use OdinIcons.<nome> como IconData
Icon(OdinIcons.statusSuccess)
Icon(OdinIcons.statusError)
Icon(OdinIcons.statusWarning)
Icon(OdinIcons.infoOn)
// Ver todos em: lib/design_system/foundation/icons.dart
```

---

## 4. Componentes UI

### OdinButton

**Quando usar:** Ação primária, secundária ou terciária do usuário. Prefira `primary` para ação principal de uma tela, `neutral` para ações secundárias, `line` para ações de menor destaque.

```dart
// Mínimo funcional
OdinButton(
  label: Text('Confirmar'),
  onPress: () {},
)

// Completo
OdinButton(
  label: Text('Continuar'),
  kind: OdinButtonKind.primary,   // primary | neutral | line
  size: OdinButtonSize.normal,    // compact | normal | fullWidth
  leftIcon: Icon(OdinIcons.arrowLeft),
  rightIcon: Icon(OdinIcons.arrowRight),
  onPress: () {},
  semantics: OdinSemanticsData(),
)

// A partir de OdinActionSettings
OdinButton.fromActionSettings(
  actionSettings: OdinActionSettings(text: 'Salvar', onPress: () {}),
  kind: OdinButtonKind.primary,
)
```

**Variantes especializadas:** `OdinButtonInline`, `OdinButtonForward`, `OdinButtonShortcut`, `OdinButtonFixed`

**Defaults contextuais:** Para definir kind/size para vários botões de uma vez:
```dart
OdinDefaultButtonProperties.merge(
  kind: OdinButtonKind.neutral,
  size: OdinButtonSize.compact,
  child: Column(children: [
    OdinButton(label: Text('A'), onPress: () {}),
    OdinButton(label: Text('B'), onPress: () {}),
  ]),
)
```

**Override de tema:**
```dart
OdinButtonTheme(
  data: OdinButtonTheme.of(context).copyWith(/* propriedades */),
  child: OdinButton(...),
)
```

---

### OdinAvatar

**Quando usar:** Representar usuários, perfis ou entidades com identidade visual. Suporta imagem, iniciais e badges sobrepostos.

```dart
// Com imagem
OdinAvatar(
  size: OdinAvatarSize.size48,
  image: Image.network('https://...'),
  hasOutline: true,
)

// Com iniciais (fallback quando não há imagem)
OdinAvatar(
  size: OdinAvatarSize.size40,
  initials: Text('JS'),
)

// Com badge de notificação
OdinAvatar(
  size: OdinAvatarSize.size64,
  image: Image.asset('assets/user.png'),
  notificationBadge: OdinGlobalNotificationBadge.counter(count: 3),
  statusBadge: OdinGlobalStatusBadge(...),
)
```

**Tamanhos disponíveis (`OdinAvatarSize`):** `size24`, `size32`, `size40`, `size48`, `size64`, `size80`, `size112`

> Em tamanhos ≤32px, `notificationBadge` é automaticamente convertido para `.bullet()`.

---

### OdinBadgeStatus

**Quando usar:** Indicar estados semânticos de entidades (investimento, status de transação, resultado).

```dart
// Forma rápida (factory nomeada)
OdinBadgeStatus.positive(label: Text('Aprovado'))
OdinBadgeStatus.warning(label: Text('Pendente'))
OdinBadgeStatus.negative(label: Text('Recusado'))
OdinBadgeStatus.informative(label: Text('Em análise'))
OdinBadgeStatus.neutral(label: Text('Inativo'))

// Completo
OdinBadgeStatus(
  kind: OdinBadgeStatusKind.positive,
  label: Text('Aprovado'),
  hasOutline: false,
  isLoading: false,
  onPress: () {},
)
```

**OdinBadgeCount:** Para exibir contagem numérica.
**OdinBadgeSuitability:** Para graus de risco (`conservative` | `moderate` | `sophisticated`).

---

### OdinTextField / OdinTextFieldArea

**Quando usar:** Entrada de dados do usuário — textos, números, senhas. Use `OdinTextFieldArea` para textos longos (multi-linha).

```dart
OdinTextField(
  state: OdinTextFieldState.enabled,  // enabled | disabled | error | loading
  size: OdinTextFieldSize.large,      // small | large
  controller: _controller,
  label: Text('Nome completo'),
  description: Text('Como aparece no documento'),
  hintText: 'Ex: João Silva',
  leading: Icon(OdinIcons.userOutline),
  trailing: Icon(OdinIcons.clearField),
  characterLimit: 100,
  shouldBlockOnCharacterLimit: true,
  keyboardType: TextInputType.name,
  onSubmit: (value) {},
)

// Senha
OdinTextField(
  state: OdinTextFieldState.enabled,
  size: OdinTextFieldSize.large,
  shouldObscureText: true,
  obscuringCharacter: '•',
)

// Erro
OdinTextField(
  state: OdinTextFieldState.error,
  size: OdinTextFieldSize.large,
  // Mostre a mensagem de erro fora do campo (Text widget abaixo)
)
```

---

### OdinCheckbox

**Quando usar:** Seleção múltipla ou estado booleano. Use `OdinCheckboxLabel` quando há texto associado, `OdinCheckboxCard` para seleção em formato de cartão.

```dart
// Apenas o checkbox
OdinCheckbox(
  selection: OdinToggleableSelection.selected,  // selected | unselected | indeterminate
  onChanged: (value) => setState(() => _selection = value),
)

// Com label
OdinCheckboxLabel(
  label: 'Aceito os termos',
  selection: _selection,
  position: OdinCheckboxPosition.right,  // left | right
  isTristate: false,
  onChanged: (value) => setState(() => _selection = value),
)
```

---

### OdinRadioButton

**Quando usar:** Seleção exclusiva dentro de um grupo de opções. Use `OdinRadioButtonLabel` com texto, `OdinRadioButtonCard` para formato de cartão.

```dart
// Genérico — T pode ser qualquer tipo
OdinRadioButton<String>(
  value: 'opcao_a',
  selectedValue: _selectedOption,
  onChanged: (value) => setState(() => _selectedOption = value),
)

// Com label
OdinRadioButtonLabel<String>(
  label: 'Opção A',
  value: 'opcao_a',
  selectedValue: _selectedOption,
  position: OdinRadioButtonPosition.right,
  onChanged: (value) => setState(() => _selectedOption = value),
)
```

---

### OdinModal

**Quando usar:** Diálogos de confirmação, alertas importantes ou coleta de informação que exige foco total. Use `showOdinModal()` para exibir.

```dart
// Conteúdo padrão (título + subtítulo + parágrafo)
OdinModal.defaultContent(
  title: Text('Confirmar operação'),
  subtitle: Text('Transferência de R$ 1.000,00'),
  paragraph: Text('Essa ação não pode ser desfeita.'),
  primaryAction: OdinActionSettings(
    text: 'Confirmar',
    onPress: () {},
  ),
  secondaryAction: OdinActionSettings(
    text: 'Cancelar',
    onPress: () => Navigator.pop(context),
  ),
)

// Conteúdo customizado
OdinModal(
  title: Text('Título'),
  content: MyCustomWidget(),
  primaryAction: OdinActionSettings(text: 'OK', onPress: () {}),
  linkAction: OdinActionSettings(text: 'Saber mais', onPress: () {}),
)
```

---

### OdinNotification

**Quando usar:** Feedback de sistema inline (sucesso, erro, aviso, info). Use `OdinNotificationFixed` para notificações fixas no topo/rodapé, `OdinNotificationFloater` para toasts.

```dart
// Inline (dentro do conteúdo da tela)
OdinNotificationInline.success(title: Text('Operação realizada'))
OdinNotificationInline.error(title: Text('Falha ao processar'))
OdinNotificationInline.warning(title: Text('Atenção necessária'))
OdinNotificationInline.info(title: Text('Informação importante'))
OdinNotificationInline.loader(title: Text('Processando...'))

// Com ícone personalizado
OdinNotificationInline.placeholder(
  title: Text('Mensagem'),
  icon: OdinIcons.infoOn,
  isEnabled: true,
)
```

---

### OdinList

**Quando usar:** Itens de lista com imagem, conteúdo principal, detalhe e ação. É o componente de lista mais versátil do DS.

```dart
OdinList(
  content: OdinListContent(
    title: Text('Nome do item'),
    subtitle: Text('Descrição secundária'),
  ),
  imageKind: OdinSubListImageKindAvatar(avatar: OdinAvatar(...)),
  // ou: OdinSubListImageKindIcon, OdinSubListImageKindIconCircle,
  //     OdinSubListImageKindImage, OdinSubListImageKindImageGroup
  action: OdinSubListAction(...),
  detail: OdinSubListDetail(...),
  hasDivider: true,
  isFullWidth: false,
  alignment: OdinListImageAlignment.top,  // top | center | bottom
  onPress: () {},
)
```

---

### OdinNavBar

**Quando usar:** Barra de navegação superior (AppBar customizado do DS). Implementa `PreferredSizeWidget`, use dentro de `Scaffold.appBar`.

```dart
Scaffold(
  appBar: OdinNavBar(
    title: Text('Minha Tela'),
    hasBackButton: true,
    onTapBack: () => Navigator.pop(context),
    actions: [
      OdinIconButton(icon: OdinIcons.search, onPress: () {}),
      OdinIconButton(icon: OdinIcons.menuDots, onPress: () {}),
    ],
    backgroundColor: theme.appColorScheme.neutralBase,
    foregroundColor: theme.appColorScheme.onColorEmphasisHigh,
  ),
)

// Com logo
OdinNavBarLogo(...)

// Sliver (para CustomScrollView)
OdinSliverNavBar(...)
```

---

### OdinSearch

**Quando usar:** Campo de busca com estado controlado.

```dart
OdinSearch(
  controller: _searchController,
  hintText: 'Buscar...',
  onChanged: (query) {},
  onSubmit: (query) {},
)

// Trigger (abre busca em outra tela)
OdinSearchTrigger(
  hintText: 'Buscar produtos',
  onPress: () => Navigator.push(context, ...),
)
```

---

### OdinIconButton

**Quando usar:** Botão de ícone sem label. Comum em NavBars e toolbars.

```dart
OdinIconButton(
  icon: OdinIcons.search,
  onPress: () {},
  color: theme.appColorScheme.primaryBase,
  iconSize: 24.0,
  tooltip: 'Buscar',
)
```

---

### OdinIconContainer

**Quando usar:** Ícone com background colorido — indicadores, categorias, ações contextuais.

```dart
OdinIconContainer(
  icon: OdinIcons.wallet,
  color: theme.appColorScheme.primaryBase,
  // size definido pelo OdinIconContainerTheme ou via theme override
)

// Variante circular
OdinIconContainer.circle(
  icon: OdinIcons.chart,
  color: theme.appColorScheme.secondaryBase,
)
```

---

### OdinLink

**Quando usar:** Textos clicáveis inline (dentro de parágrafos) ou standalone.

```dart
OdinLink(
  label: Text('Saiba mais'),
  onPress: () {},
)
```

---

### OdinSwitcher

**Quando usar:** Alternar entre dois estados (on/off). Use `OdinSwitcherLabel` com texto, `OdinSwitcherBox` para formato de cartão.

```dart
OdinSwitcher(
  isSelected: _isEnabled,
  onChanged: (value) => setState(() => _isEnabled = value),
)

OdinSwitcherLabel(
  label: 'Notificações ativas',
  isSelected: _isEnabled,
  onChanged: (value) => setState(() => _isEnabled = value),
)
```

---

### OdinSlider

**Quando usar:** Seleção de valor em escala contínua. Suporta modo single e range.

```dart
OdinSlider(
  value: _value,
  min: 0.0,
  max: 100.0,
  onChanged: (value) => setState(() => _value = value),
)

// Range (dois handles)
OdinSubSliderKind.range
```

---

### OdinCalendar / OdinDatePicker

**Quando usar:** Seleção de datas. `OdinCalendar` para UI inline, `OdinDatePicker` para apresentação em modal/bottom sheet.

```dart
OdinCalendar(
  selectionMode: OdinCalendarSelectionMode.date,
  // date | month | year | period
  onDateSelected: (date) {},
  dateEnabledPredicate: (date) => date.isAfter(DateTime.now()),
)
```

---

### OdinTag

**Quando usar:** Filtros e categorias selecionáveis.

```dart
// Filtro
OdinTagFilter(
  label: Text('Renda Fixa'),
  isSelected: _isSelected,
  onPress: () {},
)

// Resultado de busca
OdinTagSearch(
  label: Text('Tesouro Direto'),
  onPress: () {},
)
```

---

### OdinTooltip

**Quando usar:** Informação contextual exibida ao pressionar/hover um elemento.

```dart
OdinTooltip(
  message: Text('Informação adicional sobre este campo'),
  child: Icon(OdinIcons.infoOn),
)
```

---

### OdinCard

**Quando usar:** Container para agrupar conteúdo relacionado com hierarquia visual. Suporta imagem, header, detalhes, rodapé, badges, barra de progresso e stripe.

```dart
OdinCard(
  header: OdinCardHeader(title: Text('Produto XYZ')),
  details: OdinCardDetails(...),
  footer: OdinCardFooter(...),
  onPress: () {},
)
```

---

### OdinShimmer

**Quando usar:** Placeholder animado durante carregamento de conteúdo.

```dart
OdinShimmer(
  child: Container(
    width: 200,
    height: 16,
    color: Colors.white,
  ),
)

// Avatar shimmer
OdinAvatarShimmer(size: OdinAvatarSize.size48)
```

---

### OdinFilter

**Quando usar:** Filtros complexos com múltiplos slots (categorias, períodos).

```dart
OdinFilter(
  slots: [
    OdinSubFilterSlot(label: 'Tipo', content: [...]),
    OdinSubFilterSlot(label: 'Período', content: [...]),
  ],
  onApply: (filters) {},
  onReset: () {},
)

// Filtro de período dedicado
OdinFilterPeriod(...)
```

---

### OdinCoachmark

**Quando usar:** Onboarding — destacar um elemento novo para o usuário.

```dart
OdinCoachmark(
  title: Text('Nova funcionalidade!'),
  description: Text('Agora você pode fazer X facilmente.'),
  child: MyWidget(),
)
```

---

### OdinInformativeIcon

**Quando usar:** Ícone que, ao ser pressionado, exibe tooltip, modal ou ação customizada.

```dart
OdinInformativeIcon.tooltip(message: 'Explicação detalhada')
OdinInformativeIcon.modal(title: 'Título', content: Widget)
OdinInformativeIcon.custom(onPress: () {})
```

---

### OdinInputTag

**Quando usar:** Campo para inserir múltiplos itens como tags (ex: e-mails, categorias).

```dart
OdinInputTag(
  tags: _tags,
  onTagAdded: (tag) => setState(() => _tags.add(tag)),
  onTagRemoved: (tag) => setState(() => _tags.remove(tag)),
  hintText: 'Adicionar...',
)
```

---

### OdinBorder / OdinBorderSide

**Quando usar:** Aplicar bordas customizadas (sólida, tracejada, ou nenhuma) em containers.

```dart
DecoratedBox(
  decoration: BoxDecoration(
    border: OdinBorder.all(
      color: theme.appColorScheme.outlineBase,
      stroke: OdinBorderStyle.solid,
    ),
  ),
)
```

---

## 5. Componentes Globais

### OdinGlobalDivider
```dart
OdinGlobalDivider()  // Linha divisória horizontal
OdinGlobalDivider.vertical()
```

### OdinGlobalProgressBar
```dart
OdinGlobalProgressBar(
  value: 0.65,  // 0.0 a 1.0
  isAnimated: true,
)
```

### OdinGlobalLoader / OdinGlobalLoaderSmall
```dart
OdinGlobalLoader()       // Loader grande (tela inteira ou seção)
OdinGlobalLoaderSmall()  // Loader pequeno (inline)
```

### OdinGlobalStatusBadge
```dart
OdinGlobalStatusBadge(kind: OdinBadgeStatusKind.positive)
```

### OdinGlobalNotificationBadge
```dart
OdinGlobalNotificationBadge.bullet()     // Ponto vermelho
OdinGlobalNotificationBadge.counter(count: 5)  // Número
```

### OdinGlobalImageCombo
```dart
OdinGlobalImageCombo(
  primary: OdinAvatar(...),
  secondary: OdinIconContainer(...),
)
```

### OdinGlobalLockScreen
```dart
OdinGlobalLockScreen(
  onUnlock: () {},
  biometricButton: OdinButton(...),
)
```

---

## 6. Modelos Reutilizáveis

### OdinActionSettings

Use para padronizar a representação de ações em modais, botões e listas.

```dart
final action = OdinActionSettings<VoidCallback>(
  text: 'Confirmar',
  leftIcon: OdinIcons.checkMark,
  rightIcon: null,
  onPress: () {},
  semantics: OdinSemanticsData(),
);

// Usando em OdinButton
OdinButton.fromActionSettings(actionSettings: action)

// Usando em OdinModal
OdinModal.defaultContent(
  title: Text('Título'),
  primaryAction: action,
)
```

### OdinSemanticsData

Controle de acessibilidade para qualquer componente.

```dart
OdinSemanticsData(
  exclude: false,         // exclui da árvore semântica
  container: false,       // agrupa semântica como container
  blockUserActions: false,
  label: 'Botão confirmar',
  hint: 'Toque para confirmar a operação',
)
```

---

## 7. Customização Cross-Project

### Cenário: app com arquitetura própria (GetX, Riverpod, BLoC, MVC) usando o OdinLight como base

O `OdinThemeProvider` é completamente agnóstico de arquitetura — é um `InheritedWidget` puro. Pode envolver qualquer `MaterialApp`, `GetMaterialApp`, `ProviderScope`, etc.

#### Passo 1 — Criar um color scheme derivado do OdinLight

```dart
// meu_app/lib/theme/my_color_scheme.dart
import 'package:odin_teatro/design_system/odin_teatro.dart';
import 'package:odin_teatro/design_system/color_scheme/instances/odin_light.dart';

// Crie usando copyWith para sobrescrever apenas o que precisa
final myBrandColorScheme = odinLightColorScheme.copyWith(
  primaryBase: const Color(0xFF2A5298),          // cor primária da marca
  primaryBaseInverse: const Color(0xFFFFFFFF),
  secondaryBase: const Color(0xFF34A853),         // cor secundária da marca
  // Todos os outros tokens herdam do OdinLight
);
```

> `OdinColorScheme.copyWith()` aceita qualquer subconjunto dos 250+ tokens. Só altere o que diverge da paleta Odin.

#### Passo 2 — Criar tipografia personalizada (opcional)

```dart
// Substituir apenas a fonte, mantendo escala do OdinLight
final myTypography = defaultTypography.copyWith(
  fontFamily: 'MinhaFontePersonalizada',
);

// Ou substituir tamanhos específicos
final myTypography = defaultTypography.copyWith(
  fontSize: defaultTypography.fontSize.copyWith(base: 18.0),
);
```

#### Passo 3 — Integrar ao app (exemplo com GetX)

```dart
// main.dart
void main() {
  runApp(
    OdinThemeProvider(
      appColorScheme: myBrandColorScheme,
      typography: myTypography,
      builder: (context) => GetMaterialApp(
        // GetX: initialBinding, routes, etc.
        home: MyHomePage(),
      ),
    ),
  );
}
```

#### Passo 4 — Override de componente individual na tela

```dart
// Sobrescrever o tema de botão apenas para uma seção da tela
OdinButtonTheme(
  data: OdinButtonTheme.of(context).copyWith(
    // propriedades específicas do OdinButtonThemeData
  ),
  child: Column(
    children: [
      OdinButton(label: Text('Ação principal'), onPress: () {}),
      OdinButton(label: Text('Ação secundária'), onPress: () {}),
    ],
  ),
)
```

Cada componente tem seu próprio `XTheme` widget:
- `OdinButtonTheme`
- `OdinAvatarTheme`
- `OdinCheckboxTheme`
- `OdinRadioButtonTheme`
- `OdinInputTheme` (via `OdinTextFieldState`)
- `OdinIconContainerTheme`
- `OdinIconButtonTheme`
- `OdinNavBarTheme`
- `OdinImageContainerTheme`
- `OdinImageGroupTheme`
- `OdinTooltipTheme`
- `OdinSwitcherTheme`
- `OdinDividerTheme`

#### Passo 5 — Trocar tema em runtime (dark mode)

```dart
// Usando ValueNotifier ou qualquer state manager
ValueNotifier<OdinColorScheme> _scheme = ValueNotifier(odinLightColorScheme);

ValueListenableBuilder<OdinColorScheme>(
  valueListenable: _scheme,
  builder: (context, scheme, _) => OdinThemeProvider(
    appColorScheme: scheme,
    typography: defaultTypography,
    builder: (context) => MyApp(),
  ),
)

// Alternar
_scheme.value = odinDarkColorScheme;
```

---

## 8. Cheatsheet Rápido

```
ESPAÇAMENTO         BORDER RADIUS          TIPOGRAFIA (px)
xxxs = 4            radius_8               xxs = 10
xxs  = 8            radius_10              xs  = 12
xs   = 16           radius_12              sm  = 14
sm   = 24           radius_16              base= 16
md   = 32           radius_20              md  = 18
lg   = 40           radius_32              lg  = 24
xl   = 48                                  xl  = 28
xxl  = 64                                  xxl = 32
xxxl = 128                                 xxxl= 48
                                           xxxxl=64

BUTTON KINDS        BADGE KINDS            TEXTFIELD STATES
primary             positive               enabled
neutral             warning                disabled
line                negative               error
                    informative            loading
                    neutral

AVATAR SIZES        NOTIFICATION KINDS     CHECKBOX SELECTION
24, 32, 40          success                selected
48, 64, 80          error                  unselected
112                 warning                indeterminate
                    info
                    loader
                    placeholder
```

---

## 9. Distribuição desta Skill

Esta skill fica em `.claude/commands/odin-design-system.md` dentro do repositório do design system. Para usá-la em outros projetos:

**Opção A — Copiar o arquivo:**
```bash
cp path/to/odin_teatro/.claude/commands/odin-design-system.md \
   meu_projeto/.claude/commands/odin-design-system.md
```

**Opção B — Symlink (desenvolvimento local):**
```bash
mkdir -p meu_projeto/.claude/commands
ln -s $(pwd)/odin_teatro/.claude/commands/odin-design-system.md \
      meu_projeto/.claude/commands/odin-design-system.md
```

**Opção C — Script no Makefile do DS:**
```makefile
install-claude-skill:
	mkdir -p $(TARGET)/.claude/commands
	cp .claude/commands/odin-design-system.md $(TARGET)/.claude/commands/
# uso: make install-claude-skill TARGET=../meu_projeto
```

Após instalar, invoque com `/odin-design-system` no Claude Code de qualquer projeto consumidor.
