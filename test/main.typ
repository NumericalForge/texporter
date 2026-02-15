#import "@local/texporter:0.1.0": texporter-build
#import "@preview/physica:0.9.4": *


#show: texporter-build

= Introduction

A brief *introduction*.


= Review

== Maxwell equations

$
    nabla dot bold(E)   &= ρ/ε_0 \
    nabla dot bold(B)   &= 0 \ 
    nabla times bold(E) &= -pdv(bold(B), t) \
    nabla times bold(B) &= μ_0 (bold(J) + ε_0 pdv(bold(E), t))
$