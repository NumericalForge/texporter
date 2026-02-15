// Use as:
//
// #import "@local/latexify:0.0.1": latexify, export-figures
// Read from command line arguments:
// #let export-figs = sys.inputs.at("export-figs", default:"") == "true"
// #let latex = sys.inputs.at("latex", default:"") == "true"
//
// Available show rules:
// #show: latexify.with(run: latex)
// #show: export-figures.with(run: export-figs)


// Bash command to extract LaTeX code from a Typst file:
// typst query text.typ '<latex>' --pretty --one --field value | jq -r . > translated.tex
//
// Or, if jq is not available:
// echo "$(typst query text.typ '<latex>' --pretty --one --field value | sed 's/^"//; s/"$//; s/\\"/"/g')" > translated.tex 


#let math-symbols-to-latex = (
    // Greek
    "α": "\\alpha",
    "β": "\\beta",
    "γ": "\\gamma",
    "δ": "\\delta",
    "ε": "\\varepsilon",
    "ζ": "\\zeta",
    "η": "\\eta",
    "θ": "\\theta",
    "ι": "\\iota",
    "κ": "\\kappa",
    "λ": "\\lambda",
    "μ": "\\mu",
    "ν": "\\nu",
    "ξ": "\\xi",
    "ο": "\\omicron",
    "π": "\\pi",
    "ρ": "\\rho",
    "σ": "\\sigma",
    "τ": "\\tau",
    "υ": "\\upsilon",
    "φ": "\\phi",
    "χ": "\\chi",
    "ψ": "\\psi",
    "ω": "\\omega",
    "Γ": "\\Gamma",
    "Δ": "\\Delta",
    "Θ": "\\Theta",
    "Λ": "\\Lambda",
    "Ξ": "\\Xi",
    "Π": "\\Pi",
    "Σ": "\\Sigma",
    "Υ": "\\Upsilon",
    "Φ": "\\Phi",
    "Ψ": "\\Psi",
    "Ω": "\\Omega",

    // Symbols
    "ℓ": "\\ell",
    "…": "\\ldots",
    "⋯": "\\cdots",
    "⋮": "\\vdots",
    "⋱": "\\ddots",

    // Operators
    "∇": "\\nabla",
    "∂": "\\partial",
    "∑": "\\sum",
    "∫": "\\int",
    "∈": "\\in",
    "≤": "\\le",
    "≥": "\\ge",
    "−": "-",              // minus sign
    "·": "\\cdot",
    "±": "\\pm",           // (U+00B1) Plus-minus
    "∓": "\\mp",           // (U+2213) Minus-plus
    "×": "\\times",        // (U+00D7) Multiplication sign
    "÷": "\\div",          // (U+00F7) Division sign
    "∗": "\\ast",          // (U+2217) Asterisk operator
    "★": "\\star",         // (U+2605) or ⋆ (U+2606) Star operator
    "⋅": "\\cdot",         // (U+22C5) Dot operator
    "∘": "\\circ",         // (U+2218) Circle operator
    "•": "\\bullet",       // (U+2022) Bullet operator
    "⊕": "\\oplus",        // (U+2295) Circled plus
    "⊖": "\\ominus",       // (U+2296) Circled minus
    "⊗": "\\otimes",       // (U+2297) Circled times
    "⊘": "\\oslash",       // (U+2298) Circled slash
    "⊙": "\\odot",         // (U+2299) Circled dot
    "∩": "\\cap",          // (U+2229) Intersection
    "∪": "\\cup",          // (U+222A) Union
    "⊓": "\\sqcap",        // (U+2293) Square cap
    "⊔": "\\sqcup",        // (U+2294) Square cup
    "∨": "\\vee",          // (U+2228) Logical or
    "∧": "\\wedge",        // (U+2227) Logical and
    "∖": "\\setminus",     // (U+2216) Set minus
    "≀": "\\wr",           // (U+2240) Wreath product
    "≠": "\\neq",          // (U+2260) Not equal
    "≈": "\\approx",       // (U+2248) Approximately equal
    "≡": "\\equiv",        // (U+2261) Identical to
    "∼": "\\sim",          // (U+223C) Similar to
    "≃": "\\simeq",        // (U+2243) Asymptotically equal
    "≺": "\\prec",         // (U+227A) Precedes
    "≻": "\\succ",         // (U+227B) Succeeds
    "≼": "\\preceq",       // (U+2E6E) Precedes or equal
    "≽": "\\succeq",       // (U+2E6F) Succeeds or equal
    "⊂": "\\subset",       // (U+2282) Subset
    "⊃": "\\supset",       // (U+2283) Supset
    "⊆": "\\subseteq",     // (U+2286) Subset or equal
    "⊇": "\\supseteq",     // (U+2287) Supset or equal
    "⊑": "\\sqsubseteq",   // (U+2291) Square subset or equal
    "⊒": "\\sqsupseteq",   // (U+2292) Square supset or equal
    "∋": "\\ni",           // (U+220B) Contains as member
    "⊢": "\\vdash",        // (U+22A2) Right tack
    "⊣": "\\dashv",        // (U+22A3) Left tack
    "⊧": "\\models",       // (U+22A7) Models

    // Blackboard letters. Requires package amsfonts
    "𝔸": "\\mathbb{A}", 
    "𝔹": "\\mathbb{B}", 
    "ℂ": "\\mathbb{C}", 
    "𝔻": "\\mathbb{D}", 
    "𝔼": "\\mathbb{E}", 
    "𝔽": "\\mathbb{F}", 
    "𝔾": "\\mathbb{G}", 
    "ℍ": "\\mathbb{H}", 
    "𝕀": "\\mathbb{I}", 
    "𝕁": "\\mathbb{J}", 
    "𝕂": "\\mathbb{K}", 
    "𝕃": "\\mathbb{L}", 
    "𝕄": "\\mathbb{M}", 
    "ℕ": "\\mathbb{N}", 
    "𝕆": "\\mathbb{O}", 
    "ℙ": "\\mathbb{P}", 
    "ℚ": "\\mathbb{Q}", 
    "ℝ": "\\mathbb{R}", 
    "𝕊": "\\mathbb{S}", 
    "𝕋": "\\mathbb{T}", 
    "𝕌": "\\mathbb{U}", 
    "𝕍": "\\mathbb{V}", 
    "𝕎": "\\mathbb{W}", 
    "𝕏": "\\mathbb{X}", 
    "𝕐": "\\mathbb{Y}", 
    "ℤ": "\\mathbb{Z}", 
)

#let math-funcs-to-latex = (
    "sin": "\\sin",
    "cos": "\\cos",
    "tan": "\\tan",
    "log": "\\log",
    "exp": "\\exp",
    "min": "\\min",
    "max": "\\max",
    "inf": "\\inf",
    "sup": "\\sup",
    "lim": "\\lim",
    "asin": "\\arcsin",
    "acos": "\\arccos",
    "atan": "\\arctan",
    "sinh": "\\sinh",
    "cosh": "\\cosh",
    "tanh": "\\tanh",

    "nabla": "\\nabla",
    // "varepsilon": "\\varepsilon",
)


#let repeat-str(str, n) = {
    let res = ""
    for i in range(n) {
        res += str
    }
    return res
}

#let indent(lev) = {
    repeat-str("  ", lev)
}


#let render-equation(elems, lev) = {
    let elems = if type(elems) == array { elems } else { (elems,) }

    let ltx = ()

    let i = 0
    for elem in elems {
        i = i + 1
        let func = repr(elem.func())
    
        if func == "space" {
            ltx.push(" ")
        } else if func == "align-point" {
            ltx.push("&")
        } else if func == "text" {
            if elem.text.match(regex("^\d+\.?\d*$")) != none {
                ltx.push(elem.text)
            } else {
                let prev = if i > 0 { repr(elems.at(i - 1).func()) } else { "" }
                let next = if i < elems.len() - 1 { repr(elems.at(i + 1).func()) } else { "" }
                ltx.push("\\text{")
                // if prev in ("symbol", "op", "text") { ltx.push(" ") }
                ltx.push(elem.text.trim())
                // if next in ("symbol", "op", "text") { ltx.push(" ") }
                ltx.push("}")
            }
        } else if func == "linebreak" {
            ltx.push("\\\\\n")
            ltx.push(indent(lev))
        } else if func == "equation" {
            let temp = render-equation(elem.body, lev)
            ltx.push(temp)
        } else if func == "sequence" {
            let temp = render-equation(elem.children, lev)
            ltx.push(temp)
        } else if func == "root" {
            let rad = render-equation(elem.radicand, lev)
            if elem.has("index") {
                let index = render-equation(elem.index, lev)
                ltx.push("\\sqrt[" + index + "]{" + rad + "}")
            } else {
                ltx.push("\\sqrt{" + rad + "}")
            }
        } else if func == "cancel" {  // requires package "cancel"
            let rad = render-equation(elem.body, lev)
            ltx.push("\\cancel{" + rad + "}")
        } else if func == "lr" {
            if elem.body.has("children") {
                let left-br = elem.body.children.at(0).text
                let right-br = elem.body.children.at(-1).text
                
                let items = elem.body.children.slice(1,-1)
                
                // filter linebreaks and align-points
                let items = items.filter(x => not (repr(x.func()) in ("linebreak", "align-point")))

                // ltx.push(items.map(x => repr(x.func())).join("| "))
                // ltx.push(items.map(x => repr(x)).join("| "))


                if items.len() == 1 and repr(items.first().func()) == "symbol" {
                    ltx.push(left-br + items.first().text + right-br)
                } else {
                    let tmp = render-equation(items, lev)
                    ltx.push("\\left" + left-br + tmp + "\\right" + right-br)
                }
            } else {
                panic("lr body does not have brackets")
            }

        } else if func == "h" {
            ltx.push("\\hspace{" + repr(elem.amount) + "}")
        } else if func == "styled" {
            if repr(elem.child.func())=="symbol" {
                let s = elem.child.text
                if s.match(regex("[A-Z]"))!=none {
                    ltx.push("\\boldsymbol{" + s + "}") // Use bold for uppercase letters if styled
                } else {
                    s = math-symbols-to-latex.at(s, default: s)
                    ltx.push("\\boldsymbol{" + s + "}") // Use bold for lowercase letters if styled
                }
            } else {
                let temp = render-equation((elem.child,), lev) 
                ltx.push("\\boldsymbol{" + temp + "}") // Use bold for other elements if styled
            }
        } else if func == "accent" {
            let temp = render-equation(elem.base, lev)
            if elem.accent == "\u{0302}" {
                ltx.push("\\hat{" + temp + "}")
            } else if elem.accent == "\u{0304}" {
                ltx.push("\\bar{" + temp + "}")
            }
        } else if func == "symbol" {
            let tmp = math-symbols-to-latex.at(elem.text, default: "")
            if tmp != "" {
                ltx.push(tmp + " ")
            } else {
                ltx.push(elem.text)
            }
        } else if func == "equation" {
            let temp = render-equation(elem.body.children)
            ltx.push(temp)
        } else if func == "op" {
            let tmp = math-funcs-to-latex.at(elem.text.text, default: "")
            if tmp != "" {
                ltx.push(tmp + " ")
            } else {
                ltx.push("\\mathrm{" + elem.text.text + "} ")
            }
        } else if func == "frac" {
            let num = render-equation(elem.num, lev)
            let denom = render-equation(elem.denom, lev)
            ltx.push("\\frac{" + num + "}{" + denom + "}")
        } else if func == "attach" {
            let base = render-equation(elem.base, lev)
            if repr(elem.base.func()) in ("sequence", "lr") {
                ltx.push("{" + base + "}")
            } else {
                ltx.push(base)
            }

            if elem.has("b") {
                let b = render-equation(elem.b, lev)
                if repr(elem.b.func()) in ("sequence", "lr") {
                    ltx.push("_{" + b + "}")
                } else {
                    ltx.push("_" + b)
                }
            }
            if elem.has("t") {
                let t = render-equation(elem.t, lev)
                if repr(elem.t.func()) in ("sequence", "lr") {
                    ltx.push("^{" + t + "}")
                } else {
                    ltx.push("^" + t + " ")
                }
            }
            if elem.has("tr") {
                if repr(elem.tr.func())=="primes" {
                    let temp = repeat-str("'", elem.tr.count)
                    ltx.push(temp)
                } else {
                    ltx.push("[\\text{Unsupported math attach: tr")
                }
            }
            if elem.has("tl") { ltx.push("[\\text{Unsupported math attach: tl") }
            if elem.has("bl") { ltx.push("[\\text{Unsupported math attach: bl") }
            if elem.has("bt") { ltx.push("[\\text{Unsupported math attach: br") }

        } else if func == "vec" {
            // Typst does not expose the delimiter
            ltx.push("\\begin{pmatrix}\n")
            let ind = indent(lev)
            let nrows = elem.children.len()
            for i in range(nrows) {
                let item = elem.children.at(i)
                let temp = render-equation(item, lev)
                ltx.push(indent(lev + 1))
                ltx.push(temp)
                if i < nrows - 1 { ltx.push(" \\\\\n") }
            }
            ltx.push("\n")
            ltx.push(ind)
            ltx.push("\\end{pmatrix}")
        } else if func == "mat" {
            // Typst does not expose the delimiter
            ltx.push("\\begin{pmatrix}\n")
            let ind = indent(lev)
            let nrows = elem.rows.len()
            let ncols  = elem.rows.first().len()
            for i in range(nrows) {
                let row = elem.rows.at(i)
                ltx.push(indent(lev + 1))
                for j in range(ncols) {
                    let item = row.at(j)
                    let temp = render-equation(item, lev)
                    ltx.push(temp)
                    if j < ncols - 1 { ltx.push(" & ") }
                }
                if i < nrows - 1 { ltx.push(" \\\\\n") }
            }
            ltx.push("\n")
            ltx.push(ind)
            ltx.push("\\end{pmatrix}")
        } else if func=="cases" {
            ltx.push("\\begin{cases}\n")
            let ind = indent(lev)

            for item in elem.children {
                ltx.push(indent(lev + 1))
                let temp = render-equation(item, lev+1)
                ltx.push(temp)
                if item != elem.children.last() { ltx.push(" \\\\\n") }
            }
            ltx.push("\n")
            ltx.push(ind)
            ltx.push("\\end{cases}")
        } else {
            ltx.push("[\\text{Unsupported func: math." + func + "]}")
        }
    }
    ltx.join("")
}


#let find-elem(elem, func) = {
    let f = repr(elem.func())

    if f == func { return elem } 

    if elem.has("body") {
        return find-elem(elem.body, func)
    } 

    if f == "styled" {
        return find-elem(elem.child, func)
    }

    if elem.has("children") {  // for sequences and some elements that explicitly have children
        for child in elem.children {
            if find-elem(child, func) != none { return elem }
        }
        return none
    } 
    
    return none
}

#let simple-latex = (
    "strong": "\\textbf",
    "emph": "\\textit",
    "smallcaps": "\\textsc",
    "sub": "\\textsubscript",
    "super": "\\textsuperscript",
    "underline": "\\underline",
    "strike": "\\sout", // needs package "ulem"
    "rect": "\\fbox", // needs package "ulem"
)


#let render-latex(elems, lev) = {
    let ipage = 0
    let meta = ""
    let elems = if type(elems) == array { elems } else { (elems,) }
    let on-parbreak = true

    let ltx = ()
    let nelems = elems.len()
    for i in range(nelems) {
        let elem = elems.at(i)
        let func = repr(elem.func())
        if func != "parbreak" and func != "space" { on-parbreak = false }

        if func == "parbreak" {
            if not on-parbreak {ltx.push("\n\n") } // avoid using \\\\ for paragraph breaks
            on-parbreak = true 
        } else if func == "linebreak" {
            // if not on-parbreak {ltx.push("\n\n") } // avoid using \\\\ for paragraph breaks
            // on-parbreak = true
            ltx.push("\\\\{}\n")

            // ltx.push("\\\\{}\n")
        } else if func == "sequence" { 
            let temp = render-latex(elem.children, lev)
            ltx.push(temp)
        } else if func == "text" {
            ltx.push(elem.text
                .replace("&", "\\&").replace("%", "\\%").replace("$", "\\$").replace("#", "\\#")
                .replace("_", "\\_").replace("{", "\\{").replace("}", "\\}").replace("✉", "\\faEnvelopeO{}")
            )
        } else if func == "symbol" {
            ltx.push(elem.text)
        } else if func == "space" {
            ltx.push(" ")
        } else if func == "link" {
            ltx.push("\\url{" + elem.dest + "}")
        } else if func == "box" {
            ltx.push(render-latex(elem.body, lev))
        } else if func == "columns" {
            ltx.push(render-latex(elem.body, lev))
            // ltx.push(repr(elem))
        } else if func == "align" {
            let algn = repr(elem.alignment)
            let algn = if algn != "center" { "flush"+algn } else { algn }
            let ind = indent(lev)
            ltx.push("\n")
            ltx.push(ind)
            ltx.push("\\begin{" + algn + "}\n")
            if algn != "center" { ltx.push(indent(lev+1) + "\justifying\n") }
            ltx.push(render-latex(elem.body, lev+1))
            ltx.push("\n")
            ltx.push(ind)
            ltx.push("\\end{" + algn + "}\n")
        } else if func == "v" {
            ltx.push("\\vspace{" + repr(elem.amount) + "}")
        } else if func == "h" {
            ltx.push("\\hspace{" + repr(elem.amount) + "}")
        } else if func == "styled" {
            let temp = render-latex(elem.child, lev)
            ltx.push(temp)
        } else if func == "smartquote" {
            if elem.double {
                ltx.push("\u{0022}")
            } else {
                ltx.push("'")
            }
        } else if func == "heading" {
            let cs = if elem.depth == 1 {
                "\n\\section"
            } else if elem.depth == 2 {
                "\n\\subsection"
            } else if elem.depth == 3 {
                "\n\\subsubsection"
            }
            ltx.push(cs + "{" + render-latex(elem.body, lev) + "}\n")
            if elem.has("label") {
                let label = repr(elem.label).slice(1, -1)
                ltx.push( "\\label{" + label + "}\n")
            }
        } else if func == "raw" {
            if elem.block==false {
                ltx.push("\\verb~" + elem.text + "~")
            } else {
                let ind = indent(lev)
                ltx.push(ind)
                ltx.push("\\begin{verbatim}\n")
                ltx.push(elem.text)
                ltx.push("\n")
                ltx.push(ind)
                ltx.push("\\end{verbatim}\n")
            }
        } else if func == "equation" {
            if elem.block == true {
                let env = if find-elem(elem, "linebreak")!=none { "align" } else { "equation" }
                // ltx.push(repr(elem))

                let ind = indent(lev)
                ltx.push(ind)
                ltx.push("\\begin{" + env + "}\n")
                lev = lev + 1

                ltx.push(indent(lev))
                let temp = render-equation(elem.body, lev)
                ltx.push(temp)
                // ltx.push(" \\\\")
                ltx.push("\n")
                if elem.has("label") {
                    let label = repr(elem.label).slice(1, -1) // Remove quotes if string
                    let tag = label.split(":").at(0)
                    if tag != "eq" { panic("Equation label must start eq:. Found: " + label) }

                    ltx.push(indent(lev))
                    ltx.push( "\\label{" + label + "}\n")
                }
                lev = lev - 1
                ltx.push(ind)
                ltx.push("\\end{" + env + "}\n")
            } else {
                let temp = render-equation(elem.body, lev)
                ltx.push("$" + temp + "$")
            }
        } else if func == "image" {
            if type(elem.source) == bytes {
                panic("Image source is bytes. Set a label to get a filename.")
            } else {
                ltx.push("\\includegraphics{" + elem.source + "}")
            }
            ltx.push( repr(type(elem.source)==bytes))
        } else if func == "figure" {
            let env = if find-elem(elem, "table") != none { "table" } else { "figure" }

            let placement = if repr(elem).contains("placement: none") { "[h]" } else { "" } // Using repr trick because elem.placement does not work
            
            let ind = indent(lev)
            ltx.push(ind)
            ltx.push("\\begin{" + env + "}" + placement + "\n")
            lev = lev + 1

            ltx.push(indent(lev))
            ltx.push("\\centering\n")

            if env == "table" {
                ltx.push(indent(lev))
                let tmp = render-latex(elem.body, lev)
                ltx.push(tmp)
            } else {
                ipage = ipage + 1
                ltx.push(indent(lev))
                // let temp = "\\includegraphics[page=" + str(ipage) + "]{figures.pdf}"
                let temp = "\\includegraphics{figure-" + str(ipage) + ".pdf}"
                ltx.push(temp)
            }

            if elem.has("label") {
                let label = repr(elem.label).slice(1, -1)
                let tag = label.split(":").at(0)
                let tags = ("fig", "tab")
                if not tag in tags {
                    panic("Label must start with " + tags.join(" or ") + ". Found: " + label)
                }
                ltx.push("\n")
                ltx.push(indent(lev))
                ltx.push("\\label{" + label + "}\n")
            }
            if elem.has("caption") {
                let caption = render-latex(elem.caption.body, lev)
                ltx.push(indent(lev) + "\\caption{" + caption + "}\n")
            }

            lev = lev - 1
            ltx.push(ind + "\\end{" + env + "}\n")
        } else if func in ("table", "grid") {
            let ncols = elem.columns.len()
            let alignment = repeat-str("c", ncols) // default alignment

            // look for alighment in a previous metadata
            let j = i - 1
            while j >= 0 {
                let prev = elems.at(j)
                let prev-func = repr(prev.func())
                if prev-func == "metadata" {
                    alignment = prev.value.split(":").last() // replace alignment
                    break
                } else if not prev-func in ("space", "parbreak", "linebreak") {
                    break
                }
                j = j - 1
            }

            let ind = indent(lev)
            let ncols = elem.columns.len()
            ltx.push("\\begin{tabular}{" + alignment + "}\n")
            lev = lev + 1
            ltx.push(indent(lev))
            let icell = 0 // current cell index
            let ielem = 0 // current element index
            let nelem = elem.children.len()
            for child in elem.children {
                ielem = ielem + 1
                let child_func = repr(child.func())
                if child_func == "hline" {
                    ltx.push("\\hline")
                    if ielem < nelem { ltx.push("\n" + indent(lev)) }
                } else if child_func == "cell" {
                    icell = icell + 1
                    let tmp = render-latex(child.body, lev).trim()
                    if find-elem(child, "linebreak") == none {
                        ltx.push(tmp)
                    } else {
                        let tmp = tmp.replace("\\\\{}\n", "\\\\{}")
                        ltx.push("\\makecell{" + tmp + "}")
                    }
                    if calc.rem(icell, ncols) == 0  {
                        if ielem < nelem {
                            ltx.push(" \\\\\n" + indent(lev))
                        }
                    } else {
                        ltx.push(" & ")
                    }
                } else {
                    ltx.push("Unsupported child in table: " + child_func + "\n")
                }
            }
            lev = lev - 1
            ltx.push("\n")
            ltx.push(ind)
            ltx.push("\\end{tabular}")
        } else if func == "ref" {
            // ltx.push(repr(elem))
            let temp = repr(elem.target).slice(1, -1)  
            let parts = temp.split(":")
            if parts.len() == 1 {
                ltx.push("\\cite{" + temp + "}")
            } else if parts.len() == 2 {
                let (tp,lb) = parts
                let sup = if tp == "eq" {
                    "Eq."
                } else if tp == "fig" {
                    "Fig."
                } else if tp == "tab" {
                    "Table"
                } else if tp == "sec" {
                    "Section"
                } else {
                    panic("Unsupported supplememnt: " + tp)
                }
                ltx.push(sup + " \\ref{" + temp + "}")
            } else {
                panic("Too many ':' in label: " + temp)
            }
        } else if func == "cite" {
            let temp = repr(elem.key).slice(1, -1)
            if elem.form == "prose" {
                ltx.push("\\cite{" + temp + "}")
                // ltx.push("\\citep{" + temp + "}") // for natbib
            } else {
                ltx.push("\\cite{" + temp + "}")
                // ltx.push("\\citet{" + temp + "}") // for natbib
            }
        } else if func == "bibliography" {
            let src = elem.sources.first().split(".").first()
            ltx.push("\n\\bibliographystyle{unsrt}\n")
            ltx.push("\\bibliography{" + src + "}\n")
        } else if func in simple-latex.keys() {
            let temp = render-latex(elem.body, lev)
            ltx.push(simple-latex.at(func) + "{" + temp + "}")
        } else if func == "metadata" {
            // do nothing
        } else {
            ltx.push("?? Unsupported function: " + func + "\n")
        }
    }

    if ltx.len() == 0 { return "" }
    return ltx.join("")
}


#let export-latex(doc) = {
    let preamble = (
        "% This Tex file was generated from Typst source by latexify.typ",
        "% ",
        "% recommended settings:",
        "% \pdfminorversion=7 % Typst produces PDF 1.7",
        "% \documentclass{article} %",
        "% \usepackage{amsmath}",
        "% \usepackage{amsfonts}",
        "% \usepackage{cancel}",
        "% \usepackage{graphicx}",
        "% \usepackage{natbib}"
    )
    // let ltx = preamble.join("\n") + "\n" + render-latex(doc.children, 0).replace(regex("(\s*\\\\\\\\\s*\n)+"), "\\\\\n") // remove multiple line breaks
    let ltx = preamble.join("\n") + "\n" + render-latex(doc.children, 0)
    [#metadata(ltx)<latex>]
    [#metadata(doc)<typst>]
    doc
    // doc + "\n" + ltx
}


#let export-figures(doc) = {

    context {
        show figure: it => [#it#metadata(it)<figure>]
        set page(width:auto, height:auto, margin: (top:3pt, bottom:2pt, left:1pt, right:1pt), numbering: none)
        place(hide(doc))

        let figs = query(<figure>).map(x => x.value)
                    .filter(x => x.kind == image)
                    .map(x => x.body)
                    .intersperse(pagebreak(weak: true))
                    .join()
        
        figs
    }
}


#let texporter-build(doc) = {
  let mode = sys.inputs.at("mode", default: "pdf")
  
  if mode == "latex" {
    return export-latex(doc)
  } else if mode == "figs" {
    return export-figures(doc)
  } else {
    export-latex(doc)
    [ 
        #v(1cm)
        #set text(fill: red.darken(30%))
        *❱❱❱ Latex translation ❱❱❱* \ 
        #v(1cm)
    ]

    context raw( query(<latex>).first().value, lang:"latex", block:true ) 
  }
}
