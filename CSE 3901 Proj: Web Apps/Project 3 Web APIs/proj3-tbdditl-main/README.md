# CarmenCLI

CarmenCLI is a small Ruby command-line tool for interacting with a Carmen (Canvas) instance using its API.

This README was updated on 2025-10-11 to reflect the current repository layout and usage.

## Authors

### TBDDITL

1) Aashka Baruah
2) Julio Sica Perez
3) Mark Ling
4) Mitch Zahner

## Repository layout

- `bin/carmen` — executable entrypoint that delegates to the library CLI.
- `lib/carmen_cli/` — main library code:
  - `api_client.rb` — API client implementation
  - `cli.rb` — command-line interface
  - `course.rb`, `assignment.rb`, `grade.rb`, `calendar_event.rb`, `announcement.rb` — simple model wrappers
- `Gemfile` — Ruby dependencies

Files you may also see in the repository but not present in every clone:

- `.sample.env` — example environment variables (if present)
- `.devcontainer/` — optional devcontainer configuration

## Requirements

- Ruby (project is compatible with modern Ruby 3.x series)
- Bundler (install gems via Bundler)
- A Carmen (Canvas) API base URL and an access token

## Quick start

1. Clone this repository.

    ```sh
    git clone https://github.com/cse3901-2025au-1020/proj3-tbdditl.git
    ```

2. Install dependencies:

    ```sh
    # Install gems listed in the Gemfile
    bundle install
    ```

3. Ensure the CLI is executable (usually already set in the repo):

    ```sh
    chmod +x bin/carmen
    ```

4. Provide environment variables. Create a local `.env`:

    ```sh
    # Example (do NOT commit .env to git)
    CARMEN_API_BASE_URL="https://your-canvas.example.com/api/v1"
    CARMEN_API_ACCESS_TOKEN="your_token_here"
    ```

5. Run the CLI:

    ```sh
    ./bin/carmen <command> [options]
    ```

## Available commands

The CLI implementation lives in `CarmenCLI::CLI` (`lib/carmen_cli/cli.rb`). Commands and flags may change; run the binary with no arguments to see current usage:

```sh
./bin/carmen
```

Common commands implemented in the CLI (subject to change):

- `courses` — list courses (flags may filter past/active/all or by name)
- `todo` — list upcoming assignments (optionally for a course ID)
- `grades <course-id>` — show grades for a course
- `calendar` — list upcoming calendar events created BY THE USER
- `announcements <course-id>` — list announcements for a course
- `assignments <course-id>` — show assignments for a course

## Environment and implementation notes

- The API client is implemented in `lib/carmen_cli/api_client.rb`. It expects `CARMEN_API_BASE_URL` and `CARMEN_API_ACCESS_TOKEN` to be provided via environment variables
- Model-like wrappers live under `lib/carmen_cli/` for `Course`, `Assignment`, `Grade`, `CalendarEvent`, and `Announcement`.
- Network requests use the project's configured HTTP client

## Files of interest

```text
    proj3-tbdditl/
    ├── bin/
    │   └── carmen
    ├── lib/
    │   ├── carmen_cli/
    │   │   ├── announcement.rb
    │   │   ├── api_client.rb
    │   │   ├── assignment.rb
    │   │   ├── calendar_event.rb
    │   │   ├── course.rb
    │   │   ├── grade.rb
    │   │   └── cli.rb
    │   └── carmen_cli.rb
    ├── test/
    │   ├── carmen_cli/
    │   │   ├── test_announcement.rb
    │   │   ├── test_api_client.rb
    │   │   ├── test_assignment.rb
    │   │   ├── test_calendar_event.rb
    │   │   ├── test_course.rb
    │   │   └── test_grade.rb
    │   └── spec_helper.rb
    ├── .env
    ├── .gitignore
    └── Gemfile
```

- `bin/carmen` — CLI entrypoint
- `lib/carmen_cli/api_client.rb` — API client implementation
- `lib/carmen_cli/cli.rb` — CLI and command parsing
- `lib/carmen_cli/course.rb` — Course wrapper
- `lib/carmen_cli/assignment.rb` — Assignment wrapper
- `lib/carmen_cli/grade.rb` — Grade wrapper
- `lib/carmen_cli/calendar_event.rb` — CalendarEvent wrapper
- `lib/carmen_cli/announcement.rb` — Announcement wrapper
- `Gemfile` — project dependencies
