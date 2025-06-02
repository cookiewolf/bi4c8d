# bi4c8d

-  [Staging URL](https://bi4c8d.netlify.app)
-  Production URL: 

# Development

## Prerequisites

- [node](https://nodejs.org/)
- [nvm for macOS & Linux](https://github.com/nvm-sh/nvm) or [nvm for Windows](https://github.com/coreybutler/nvm-windows)

## Setup & install instructions

- make sure you are using the correct node version with `nvm use`
- install with `npm install`

## Build

- `npm run dev` to start a dev server on http://localhost:5173
- `npm run build` generate a production build in `dist/`

## Formatting

We recommend integrating `elm-format@0.8.3` into your code editor, but if you don't...
- Please run `npm run format` to format `.elm` files in `src` before committing code.

## Testing

We're using elm-test-rs(https://github.com/mpizenberg/elm-test-rs) to run [elm tests](https://github.com/elm-explorations/test/)

-  run tests with `npm test`

## Code & configs

### This site is built with `Elm` and bundled by `Vite`

- [Elm's official homepage](https://elm-lang.org/).
- [Elm Package docs](https://package.elm-lang.org/)
- [Vite's official documentation.](https://vitejs.dev/)
- [Vite static asset handling](https://package.elm-lang.org/packages/hmsk/elm-vite-plugin-helper/latest/)

### What it's for

- `elm.json` for elm packages used for site
- `elm-tooling.json` for elm packages used for code
- `package.json` for node scripts and packages
- `package-lock.json` for current versions of node packages
- `.nvmrc` contains project node version
- `vite.config.js` for build config
- `.netlify.toml` for deploy config
- `tests/*` contains test files
- `src/*` contains app source files

### Content

- Assets to be copied to deploy bundle root are in `public/`
- Markdown content is in `content/` and compiled to `data/*.json` files with `npm run generate`
- Html added between `<template>` tags in [index.html](/index.html) will render in `<footer>`


### Styling & layouts

- TBC

## Deployment

Deploys to Netlify

-  code is tested and linted automatically before deploy
-  when a pull request is created, a preview site is deployed
-  when a pull request is merged into `main`, the production site is deployed

## Development workflow

### Adding issues

-  add effort & value labels (if you know enough about it)
-  put the issue in a milestone (if it is part of a current epic)

### Working on issue

-  assign it to yourself before starting work
-  make a branch that includes the issue type (fix/feat/chore etc & number)
-  make sure you understand the acceptance criteria
-  ask questions & make plan

### Code review & merge

-  check the acceptance criteria have been met
-  add comments & questions
-  once approved, leave for the author to merge 
