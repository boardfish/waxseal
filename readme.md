# Waxseal

Waxseal is a GitHub Action you can use to compile Markdown documents with
Pandoc. Add your Markdown documents to an input directory, then let Waxseal put
it through your TeX/Pandoc template for that extra bit of shine.

## Usage

Configure your GitHub Actions workflow using something like this:

```yaml
# This is a basic workflow to help you get started with Actions

name: CI

on: [push]

jobs:
  waxseal_job:
    runs-on: ubuntu-latest
    name: Waxseal
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          # Make sure the actual branch is checked out when running on pull requests
          ref: ${{ github.head_ref }}
      - name: Waxseal it
        uses: boardfish/waxseal@v1.0.2
        id: waxseal
        with:
          input_directory: 'in'     # Takes .md files from ./in...
          output_directory: 'out'   # ...and compiles them to PDFs in ./out...
          template_file: 'template.tex' # ...using the template at template.tex.
```

Now, whenever you add or change a Markdown file in the `in` directory, Waxseal
will run it through the template you've provided.

To get a starter template, install `pandoc` locally and run `pandoc -D latex >
template.tex`. You should commit this template to your repo.
