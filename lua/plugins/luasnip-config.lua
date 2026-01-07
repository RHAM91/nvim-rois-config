return {
  'L3MON4D3/LuaSnip',
  build = "make install_jsregexp",
  dependencies = {
    'rafamadriz/friendly-snippets', -- Snippets predefinidos opcionales
  },
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node

    -- Cargar snippets desde archivos JSON/VSCode
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" }
    })

    -- Snippets para JavaScript/TypeScript
    ls.add_snippets("javascript", {
      s("cl", {
        t("console.log('"),
        i(1, "label"),
        t("', "),
        i(2, "value"),
        t(")"),
      }),

      s("fn", {
        t("function "),
        i(1, "name"),
        t("("),
        i(2, "params"),
        t(") {"),
        t({"", "\t"}),
        i(3, "// body"),
        t({"", "}"}),
      }),

      s("af", {
        t("const "),
        i(1, "name"),
        t(" = ("),
        i(2, "params"),
        t(") => {"),
        t({"", "\t"}),
        i(3, "// body"),
        t({"", "}"}),
      }),

      s("ife", {
        t("if ("),
        i(1, "condition"),
        t(") {"),
        t({"", "\t"}),
        i(2, "// body"),
        t({"", "} else {"}),
        t({"", "\t"}),
        i(3, "// else body"),
        t({"", "}"}),
      }),
    })

    -- Los mismos snippets para TypeScript
    ls.add_snippets("typescript", {
      s("cl", {
        t("console.log('"),
        i(1, "label"),
        t("', "),
        i(2, "value"),
        t(")"),
      }),

      s("fn", {
        t("function "),
        i(1, "name"),
        t("("),
        i(2, "params"),
        t("): "),
        i(3, "ReturnType"),
        t(" {"),
        t({"", "\t"}),
        i(4, "// body"),
        t({"", "}"}),
      }),

      s("af", {
        t("const "),
        i(1, "name"),
        t(" = ("),
        i(2, "params"),
        t("): "),
        i(3, "ReturnType"),
        t(" => {"),
        t({"", "\t"}),
        i(4, "// body"),
        t({"", "}"}),
      }),

      s("int", {
        t("interface "),
        i(1, "Name"),
        t(" {"),
        t({"", "\t"}),
        i(2, "property: type"),
        t({"", "}"}),
      }),
    })

    -- Snippets para Vue
    ls.add_snippets("vue", {
      s("vbase", {
        t({"<template>", "\t<div>", "\t\t"}),
        i(1, "<!-- content -->"),
        t({"", "\t</div>", "</template>", "", "<script setup lang=\"ts\">", ""}),
        i(2, "// script"),
        t({"", "</script>", "", "<style scoped>", ""}),
        i(3, "/* styles */"),
        t({"", "</style>"}),
      }),

      s("vref", {
        t("const "),
        i(1, "name"),
        t(" = ref"),
        t("<"),
        i(2, "type"),
        t(">("),
        i(3, "initialValue"),
        t(")"),
      }),

      s("vcomputed", {
        t("const "),
        i(1, "name"),
        t(" = computed(() => "),
        i(2, "value"),
        t(")"),
      }),
    })

    -- Atajos para navegar entre placeholders del snippet
    -- Usar Tab/Shift+Tab para navegar (configurado en blink-cmp.lua)
    -- Ctrl+h/j/k/l reservados para navegación de tmux
  end,
}
