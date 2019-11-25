# Status

[![Build Status](https://travis-ci.com/jasonfb/universal_track_manager.svg?branch=master)](https://travis-ci.com/jasonfb/universal_track_manager)


```diff
- PUBLIC ALPHA: This code is not ready for production and is actively being developed.
+ Current version:  Version 0.0.1 (PUBLIC ALPHA)
```


```diff
! Like this gem? Please 'star' it (above), download it from RubyGems, or ... 
```
... [consider supporting it today with a small contribution](https://github.com/sponsors/jasonfb/)! For just $1/month you can support the development of this Gem and others like it.

# About

Universal Track Manager, also known as UTM, is a gem to track your visitors and their pageloads. You can use it to track Urchin Tracking Module (UTM) parameters, and the fact that these two things abbreviate to the same letters is play-on-words.

You can use Universal Track Manager to track simple information like browser, IP address, http referrer, and your inbound UTM (Urchin Tracking Module) parameters. Because UTM parameters are used most commonly with advirtising, we also refer to tracking your UTM parameters as "ad campaigns" or just "campaigns".

In particular, this Gem can be used to solve the common first-land problem where UTM parameters are present only in the first page of a user's visit, but not available naturally a few steps later when the event you want to track happens (see 'UTM Hooks')

Visits are a lot like Rails sessions; in fact, this Gem piggybacks off of Rails sessions for tracking the visit. (You will need to have a session store set up and in place.) 

However, visits are not identical to sessions. More than one visit can have been created from the same session.
 
A session will have only one visit at a time. If a new visit event happens within an existing session, like the user returns in the same browser the following day, the old visit gets evicted from the session and a link between the newly created visit and old visit is maintained in the visits table.

UTM parameters, IP addresses, and browser information are tracked by default. You must opt-in to track http_referrer. 


# NOT YET IMPLEMENTED (COMING SOON!):
- [x] fix the generator]
- [ ] track the visit IP address, user agent
- [ ] track the UTMs and stash them in an assocition 
- [ ] http referrer
- [ ] invalidate the old visit when a new visit happens, evict it from the session
- [ ] link the new visit to the old visit and carry forward the UTMs (SETTING??)
- [ ] track viewport screensize
- [ ] an optional long-cookie feature to drop a long-lived cookie into the visitor's browser that work separately from the Rails session
- [ ] track gclid or other advirtising URL parameters passed on first landings, like UTMs
- [ ] An optional extension to build in-house geolocation by IP address, or rely on an external service for geolocation by IP address and associate the user's looked-up location with their visit information
- [ ] Anonymized geolocation, to let you look-up IPs in order to geolocate users, but not store the actual IP addresses themselves.
- [ ] A switch to track the user before or after the controller action has rendered. Since the tracking adds a small overhead to each request, tracking after the controller has rendered makes your page respond faster for the user. But if you track before you render, you can use optionally use the tracked information to personalize, customize, or target your website to respond uniquely to the visitor. 


# Privacy & Legal Implications

In any country or region where a privacy law like the GDPR or California Consumer Privacy Act is in effect, getting informed consent to track this information is **just one part of what you must do to comply with the law**. 

Most privacy laws regulate the usage, storage, transmission, and removal of this data as well. You should consult a legal expert familiar with the laws of your region regarding privacy.
 
# Granularity

This Gem has been designed to allow the developer to flexibly choose the granularity of personal identification options, retention and use of the data you collect (see below). 

In particular, this Gem seeks to popularize and inform the Ruby community, as well as inform the broader landscape, on the granularity choices presented to a modern website in today's day and age. 

While the Rails session is typically where you might store information that could individually identify the user (user or account id), the visits table is, by default, detached from the session information so that when the session information is deleted, your visit does not contain a way to easily re-identify the individual, thus making your visitors somewhat anonymous. Since a reverse-engineering can be done from other places where you might store identifably information, this system cannot gaurantee to be fully anonymized unless you take extra steps to flush, aggregate, and purge your visits table in an anonymizing way (not natively implemented).  The native implementation does a reasonable job at detaching the visitors from the identifying information, thus providing partial anonymization. 

Essentially, with all this granularity and security options, you have 6 levels of privacy you can choose from:

1. Most private: 
Don't use this gem.

2. Somewhat private: 
Track user visits, but use this Gem's NO_SESSION flag [NOT YET IMPLEMENTED]

3. Less private: 
Track user visits and link them to the Rails session, but keep the existing security concepts around the Rails session (regularly purge old records from the table when they are older than 2 weeks). When you do this, if you Rails app is compromised by a hacker (both database access and your SECRET_BASE_KEY), your hacker will have access to both the identifably information (in the session) and non-identifiable table (in the visits table) for only the people who logged in within the last 2 weeks. Furthermore, if you want to associate some of your vital information (like your UTMs), with your users once they log-in or sign-up, you must implement this yourself and you may implement it by using the hooks provided  by the Gem.

4A. Barely private (bad idea from security perspective; terrible idea from privacy perspective): 
Track user visits and link them to the Rails session, but don't expire or purge your sessions. (*not recommended*)

4B. Barely private (good idea from security perspective; best idea from privacy perspective): 
Track user visits and link them to the Rails session, expire the sessions as expalined in #3 above, and use the long-cookie approach for an extra layer of identificiation.

5. Hardly private (good idea from security perspective; better idea from privacy perspective):
Just like 4B, use the `visits` from this gem, the Rails session with expiry, and possibly a long-cookie. As well, grab some or all of the information out of the `visits` table for storage elsewhere on an as-need basis. For example, you might track only the user agent (browser) and ad campaign (UTMs) but not the IP address. Since we assume that the browser doesn't change within a single visit (by definition, it can't), you don't need this gem to look at the browser (just do `request.user_agent`). But you can use this gem to grab the UTMs from a previsouly stored visit, explained below. 

6. No privacy (good idea from a security perpsective; bad idea from a privacy perspective):
Just like 4B, use the `visits` from this gem, the Rails session with expiry, and possibly a long-cookie. As well, create a foreign key from some other table directly to the visits table, and associate any time a user logs-in or signs-up to their visit details. 

# A Visit vs. A Session

A visit also stores the first and last time the visitor came during that visit. However, since visits may share sessions, a visit is made unique by any of:

• A new session

Even within the same Rails session, a visit can be defined unique by: 

• A new logical day*
• A new or different browser
• A new or different IP address


???
• A new or different viewport size (unless the viewport size is a reverse )

# Installation

Please familiarize yourself with the concepts above before installing.

1. add gem 'universal-track-manager' to your gemfile

2. run 

```
rails generate universal_track_manager:install

```

This will create a schema migration for the new tables that UTM will use (look for db/migrate/00000000000000_create_universal_tracking_manager_tables.rb. see 'Name Conflicts' below if any of these tables already exist in your app.)

3. In your ApplicationController, add:

```
  include UniversalTrackManagerConcern
```


4. If you have any controllers that descend from the ApplicationController that you don't want to track pageviews on:


# Options

Configuration options can be set in 
`config/initializers/universal_track_manager.rb` which will automatically be created for you when you run the install generator.

• Inbound UTM parameters are picked up automatically if they are present (the gem has no switch to turn this off). 

• IP tracking and browser tracking are turned ON by default, but you can switch them off with:

TODO: HOW TO TURN OFF IP TRACKING

• HTTP referrer is turned OFF by default. To turn it on, you will need to:

1) TODO: HOW TO TURN ON HTTP REFERRER TRACKING
2) run rake generate utm:track_referrer


# UTM Hooks

Note that in this section we are talking about the Urchin Tracking Module (also, non-coincidtally, abbreviated as UTMs). These appear on your inbound links as GET parameters and look like:

```
utm_source
utm_campaign
utm_medium
utm_term
utm_content
```


For example, a typical inbound link with fully coded UTM parameters might look like so:


https://www.example.com/page?utm_content=buffercf3b2&utm_medium=social&utm_source=facebook.com&utm_campaign=buffer

When a visitor first lands on your site, the UTMs from that first land are assocaited to the visit (we will call these the first-land UTMs). From here, your visitor might click to a second page, or a third page, before signing up or logging in. By this time, the UTMs are no longer stored in the URL parameters because the user has clicked several pages into your website. 

As the web operator, you want to know which of your advirtising campaigns are leading to which sign-ups or logins. One common approach is to store the UTMs in the session until the user signs up or logs in. 

Using this gem, we do not store the UTMs in the session, but instead the session has a link to the `visits` table that can used later (upon the event where you want to capture the UTMs). 

If you want to grab your UTMs them from Universal Track Manager object, support is already biult-in easily from any controller:

```
currrent_track.campaign

```

You can also fetch and store the `currrent_track.campaign_id` in your foreign table, which will allow you to aggregate your tracked events to your the inbound traffic sources. 

Remember, this Gem will not do this for you as you must associate this to your application's own unique needs. 


# Name Conflicts

• UTM will create tables named `browsers`, `campaigns`, `visits`. If you already have tables named like this, you will want to 1) edit the generated files after step 2, and 2) add an override for the UniversalTrackManager objects, like so:

```/initializers/universal_track_manager.rb

// specify that this gem should use the table name `web_visits` instead of `visits`
UniversalTrackManager::Visit.class_eval do 
  self.table_name =  :web_visits
end

// and/or specify that this gem should use the table name `web_browsers` instead of `browsers`


UniversalTrackManager::Browser.class_eval do 
  self.table_name =  :web_browser
end

// and/or specify that this gem should use the table name `ad_campaigns` instead of `campaigns`


UniversalTrackManager::Campaign.class_eval do 
  self.table_name =  :ad_campaigns
end
```

(If you already have models named Visit or Browser, don't worry: the scope of the UniversalTrackManager:: objects will prevent collisions with model-only objects in your app.)

• UTM will set a session variable named `visit_id` in your Rails session. If you already use a session variable with the same name, please override by:

[NOT IMPLEMENTED]



# CONTRIBUTING

## The Internal Specs

This is gem is tested with Appraisal, Rspec-rails, and rails-controller-test (for testing integration hooks with the Rails controllers)
 
Before modifying, run the specs by making sure to `cd` into the `GEM_CODE/` directory, then setup using

(tested with Ruby 2.6.5)

```
bundle exec appraisal install
bundle exec appraisal rails-6-0 rake dummy:db:migrate RAILS_ENV=test
```

to run specs in all versions of Rails (see `Appraisals` file)

```
bundle exec appraisal rake spec

```

## Open Issue, Fork & Branch, Submit PR Against Master

- Make sure your use case or implementation is documented. 
- Make sure it is tested. 


