# TeXporter

TeXporter exports Typst documents to LaTeX by traversing the document’s internal element tree. This is useful to generate LaTeX source for **paper submissions**, where the content is more important than the exact layout. The generated LaTeX will require manual adjustments according to the target journal’s template.

The Typst input should consist of plain content. Equations and tables are translated as much consistent with LaTeX code, while figures are exported as PDF.
Features that depend on placement or evaluation context may not be exported correctly.
Except in figures, avoid the use of `context` elements, as their content is not exported.

Figures are exported as pages of a single PDF file. These pages must be split into individual files, which the generated LaTeX code will reference as `figure-1.pdf`, `figure-2.pdf`, etc.

Since Typst uses figure for tables and figures, the identification is made based on the label, so figure labels should start with `fig:` and table labels should start with `tab:`. The generated LaTeX code will reference the figure files and use the `table` environment for tables.

Bibliography uses the `natbib` package, so the generated LaTeX code will reference a `.bib` file. 


---

## Usage

```md
#import "@local/texporter:0.1.0": texporter-build

#show: texporter-build

= Section

*Typst* content.

```

The generated LaTeX code is appended to the end of the document for *preview*.
It is also exposed as metadata with the label `latex`.

---

## Exporting the LaTeX source

Run:

```bash
typst query main.typ --input mode=latex '<latex>' --pretty --one --field value | jq -r . > translated.tex
```

Here `jq` extracts the raw LaTeX string from the JSON output `produced` by typst `query`.

---

## Exporting the figures

Run:
```bash
typst compile main.typ figures.pdf --input mode=figures
```

You can then use a tool such as `pdfseparate` to split the `figures.pdf` into individual files named `figure-1.pdf`, `figure-2.pdf`, etc.:
```bash
pdfseparate figures.pdf figure-%d.pdf
```

---
## Disclaimer

TeXporter is free to use and provided as-is, without any warranty. The software is intended as a convenience tool and does not guarantee complete or accurate translation of Typst documents to LaTeX.

Some features may be unsupported, partially supported, or translated incorrectly. Users are responsible for reviewing and validating the generated LaTeX output before use, especially for critical applications such as academic submissions.