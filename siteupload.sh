#!/bin/bash
pdflatex test.tex && echo "CV compiled." && mv test.pdf ../undying-fish.github.io/docs/CurriculumVitae.pdf && echo "CV in local repository." && cd ../undying-fish.github.io && git pull && git add docs/CurriculumVitae.pdf && git commit -m "CV updated to most recent version at undying-fish/CV" && git push && echo "Voila!"
