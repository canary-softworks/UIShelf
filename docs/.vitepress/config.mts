import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  head: [['link', { rel: 'icon', href: '/favicon.ico' }]],
  base: "/UIShelf/",
  title: "UIShelf",
  titleTemplate: "Canary Docs",
  description: "Create modern & intuitive topbar icons",
  lastUpdated: true,
  lang: 'en-us',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      {
        text: 'Guides',
        items: [
          { text: 'Install', link: '/installation' },
          { text: 'Usage', link: '/guides/index' },
        ]
      },

      { text: 'API', link: '/api/index' },
      { text: 'Changelog', link: '/changelog' }
    ],

    sidebar: {
      '/api': [
        { text: 'UIShelf', link: '/api/index' },
        { text: 'Icon', link: '/api/icon' },
        { text: 'Spacer', link: '/api/spacer' },
      ],
      '/guides': [
        { text: 'Prologue', link: '/guides/index' },
        { text: 'Object Creation', link: '/guides/creation' },
        { text: 'Input', link: '/guides/input' },
        { text: 'Notices', link: '/guides/notices' },
        { text: 'Tooltips', link: '/guides/tooltips' },
      ]
    },

    outline: [2, 3],

    search: {
      provider: 'local'
    },

    editLink: {
      pattern: 'https://github.com/canary-softworks/UIShelf/edit/main/docs/:path'
    },

    footer: {
      message: 'Built with VitePress',
      copyright: 'Copyright © 2021 - 2024 Canary Softworks'
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/canary-development/UIShelf' },
      { icon: 'discord', link: 'https://discord.com/invite/adBFYaeEpJ' },
    ]
  }
})
