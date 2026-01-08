# Prof. Sachin Kumar Website Redesign

This project redesigns, from the ground up, Prof. Sachin Kumar’s website by using Middleman to produce a modern, responsive, and easy-to-maintain static website.

## Team

- Aashka
- Julio
- Mark
- Mitch

## Project structure

Top-level layout of this repository:

- `config.rb` — Middleman configuration file.
- `Gemfile` — Ruby gems (dependencies) for this project.
- `README.md` — This file.
- `source/` — Source files for the Middleman site (templates, styles, scripts, images):
  - `source/index.html.erb` — Home page template.
  - `source/layouts/` — Layout partials and templates (`_header.erb`, `_footer.erb`, `layout.erb`, etc.).
  - `source/javascripts/` — Front-end JavaScript (`site.js`).
  - `source/stylesheets/` — SCSS/CSS source (`site.css.scss`).
  - `source/images/` — Static image assets used by the site.
- `build/` — Generated static site after running the build; ready for deployment. Contains `index.html`, `stylesheets/`, `javascripts/`, `images/`, etc.

## Getting started

Prerequisites

- Ruby and Bundler installed on your machine.

Quick start

1. Install dependencies:

    ```bash
    bundle install
    ```

2. Start the development server (live-reload):

    ```bash
    bundle exec middleman server
    ```

    Open [http://localhost:4567](http://localhost:4567) in your browser to preview the site while you develop.

3. Build the static site (production-ready files will be written to `build/`):

    ```bash
    bundle exec middleman build
    ```
