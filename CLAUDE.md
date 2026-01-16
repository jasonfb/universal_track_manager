# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Universal Track Manager (UTM) is a Rails gem for tracking website visitors by user agent, IP address, HTTP referrer, and UTM (Urchin Tracking Module) parameters. It stores visit data in a database rather than just log files, solving the "first-land problem" where UTM parameters are only available on the initial page visit.

## Development Commands

### Setup (one-time)
```bash
# Create symlink for migrations
ln -s ../spec/dummy/db/migrate/ db/migrate

# Delete existing test database if present
rm -f db/test.sqlite3

# Install appraisal and dependencies
gem install appraisal
appraisal install
appraisal rails-6-1 rake dummy:db:migrate RAILS_ENV=test
```

### Running Tests
```bash
# Run specs against all Rails versions
appraisal rake spec

# Run specs against a specific Rails version
appraisal rails-6-1 rake spec

# Run a single spec file
appraisal rails-6-1 rspec spec/lib/universal_track_manager/controllers/concerns/universal_track_manager_concern_spec.rb
```

### Rebuilding Appraisal Gemfiles
```bash
appraisal install
```

## Architecture

### Core Components

- **`lib/universal_track_manager.rb`** - Main module with configuration DSL (`UniversalTrackManager.configure`) and settings accessors (`track_ips?`, `track_utms?`, etc.)

- **`lib/universal_track_manager/controllers/concerns/universal_track_manager_concern.rb`** - Rails controller concern to be included in `ApplicationController`. Implements `before_action :track_visitor` and provides `current_track.campaign` for accessing first-land UTM data.

### Models (in `lib/universal_track_manager/models/`)

- **Visit** - Tracks a visitor session. Contains IP, browser association, campaign association, and timestamps. Visits can be "evicted" (replaced) when IP, browser, or UTM parameters change within the same Rails session.

- **Campaign** - Stores UTM parameter combinations. Uses SHA1 hash for fast lookup of existing campaigns. Campaign columns are configurable.

- **Browser** - Stores user agent strings (deduplicated by name).

### Database Tables

The gem creates three tables: `browsers`, `campaigns`, `visits`. Table names can be overridden in the initializer using `class_eval` on the model classes.

### Visit Eviction Logic

A new visit is created (evicting the old one) when:
- IP address changes
- Browser/user agent changes
- UTM parameters change (only when new UTMs are present)
- HTTP referrer changes (if referrer tracking is enabled)

Evicted visits maintain a link to the `original_visit_id` and increment a `count` field.

### Generator

`rails generate universal_track_manager:install` creates:
- Migration for the three tables
- Initializer at `config/initializers/universal_track_manager.rb`

Supports `--add=fbclid,gclid` to augment default UTM fields or `--only=...` to replace them.
