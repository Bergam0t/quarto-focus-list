This is a small filter to allow you to create a list that reveals one step at a time, fading out the previous point as you progress.

(So it's basically incremental lists, but with fade-in-then-semi-out applied to every list because I got sick of doing that manually).

Published purely for my own use when teaching so I don't have to keep copying it around, but sharing in case it's useful.

There's a good chance someone else has done a nicer implementation or there's a way to do this in Quarto natively, but I couldn't find it!

## Installation

You can add this extension to your project by running

```
quarto add bergam0t/quarto-focus-list
```

## Usage

First, you must make sure the filter is added to the list of extensions in your document header.

```yml
---
format:
  revealjs: default  # this will also work with other web-based formats, such as html
filters:
  - focus-list
---
```

> [!WARNING]
> Note that it is called 'focus-list' when added to your document - not 'quarto-focus-list'


> [!TIP]
> You could also do
>
> ```yml
> ---
> filters:
>   - bergam0t/focus-list
> ---
> ```
>
> if you have another filter extension with the same name!


Now you can create lists like so:

```md
::: {.focus-list}
- This is the first item
- And this is the second
:::
```

![](Code_KGpKuUYK8p.gif)

### Nested lists

Nested lists work to any depth, and every level fades to the same amount - a subpoint is just as
readable as a top-level point when it's the one you're on.

```md
::: {.focus-list}
- This is the first item
    - And this is a subpoint of it
        - Which can have subpoints of its own
- This is the second item
:::
```

By default, a point stays lit while any of its subpoints are being revealed, so your audience
keeps the heading the subpoints belong to.

### Options

If you'd rather the parent point faded out as soon as you move on to its subpoints - so only ever
one point is lit - add the `dim-parents` class:

```md
::: {.focus-list .dim-parents}
- This is the first item
    - And this is a subpoint of it
:::
```

Or set it once for the whole document in your header:

```yml
---
filters:
  - focus-list
focus-list:
  dim-parents: true
---
```

> [!NOTE]
> Keeping the parent lit uses the CSS `:has()` selector, which needs Chrome 105+, Safari 15.4+ or
> Firefox 121+. In older browsers you'll get the `dim-parents` behaviour instead.

## Thanks

I'm pretty sure this solution was heavily inspired by this conversation here: https://github.com/orgs/quarto-dev/discussions/4626


## Contributing

Please take a look at our [contributor guidance](CONTRIBUTING) and [code of conduct](CODE_OF_CONDUCT)

### Generative AI use disclosure and policy

This filter has been written with the help of Gemini 3 Fast.

All AI-generated code has been thoroughly reviewed and tested before inclusion.

We are happy to accept AI-supported contributions to the extension, but reserve the right to reject wholly AI generated pull requests which are not felt to add value to the project.
