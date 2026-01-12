# Curriculum Visualization Redesign

The projects intends to provide the user with an interactive curriculum visualization platoform that displays courses and its pre-requsites, organized by semester. Sample curriculums can be viewed for various majors like CSE, CIS, MECH Engr, and ECE-CE. This system dynamically loads in data from the JSON files and produces course layouts based on a timeline structure all while emphasizing pre-requisite chainsupon user interaction.

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
- `source/` — Source files for the Middleman site (templates, styles, scripts, images, data):
  - `source/index.html.erb` — Main page template.
  - `source/data` - Course data based on major. Contains`cis.json`,`cse.json`,`ece-ce.json`, and `mecheng.json`
  - `source/partials/` — Layout partials
  - `source/layouts/` - Layout templates(`layout.erb`)
  - `source/javascripts/` — Front-end JavaScript (`site.js`).
  - `source/stylesheets/` — SCSS/CSS source (`site.css.scss`).
  - `source/images/` — Static image assets used by the site.


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

