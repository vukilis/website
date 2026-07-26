import { defineEcConfig } from 'astro-expressive-code';

export default defineEcConfig({
  themes: ['catppuccin-macchiato', 'catppuccin-latte'],
  useDarkModeMediaQuery: false,
  themeCssSelector: (theme) => {
    if (theme.name === 'catppuccin-macchiato') return '[data-theme="dark"]';
    if (theme.name === 'catppuccin-latte') return '[data-theme="light"]';
    return false;
  },
  styleOverrides: {
    borderRadius: '0.75rem',
    borderWidth: '1.5px',
    borderColor: [
      'rgba(255, 255, 255, 0.18)',
      'rgba(0, 0, 0, 0.10)',
    ],
    codeFontFamily: "'JetBrains Mono', 'Fira Code', 'SF Mono', ui-monospace, Menlo, Monaco, Consolas, 'Liberation Mono', monospace",
    codeFontSize: '0.88rem',
    codeFontWeight: '450',
    codeLineHeight: '1.75',
    codePaddingBlock: '1.25rem',
    codePaddingInline: '0.5rem',
    uiFontSize: 'small',
    uiFontFamily: "'Inter', 'DM Sans', system-ui, -apple-system, sans-serif",
    frames: {
      copyIcon: `url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2'%3E%3Crect x='9' y='9' width='13' height='13' rx='2'/%3E%3Cpath d='M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1'/%3E%3C/svg%3E")`,
      frameBoxShadowCssValue: '0 1px 3px rgba(0,0,0,0.05), 0 12px 36px rgba(0,0,0,0.10)',
      editorActiveTabIndicatorTopColor: 'transparent',
      editorActiveTabIndicatorBottomColor: 'transparent',
      inlineButtonBackground: [
        'rgba(255, 255, 255, 0.14)',
        'rgba(138, 92, 246, 0.45)',
      ],
      inlineButtonBackgroundIdleOpacity: '1',
      inlineButtonBackgroundHoverOrFocusOpacity: '1',
      inlineButtonBackgroundActiveOpacity: '1',
      inlineButtonForeground: [
        'rgba(255, 255, 255, 0.92)',
        'rgba(15, 23, 42, 0.85)',
      ],
      inlineButtonBorderOpacity: '0',
      showCopyToClipboardButton: true,
      inlineButtonBorder: 'transparent',
      inlineButtonBorderRadius: '0.375rem',
    },
  },
  defaultProps: {
    wrap: false,
    showLineNumbers: true,
  },
});
