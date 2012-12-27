# Scrapbook

Experiment designed to reflect on the organization of the 3 important
elements of web scraping/data processing:

* scheduling
* scraping
* processing

Optionally, monitoring might be added to each step.

## Scheduling

Scheduling includes the configuration & tracking of when scrapping and processing
should take place.

## Scraping

Scraping is organized by target and each "scraper" responds to
`#run` which returns an array of objects which will each respond to
`#to_json`. Scrapers shouldn't stop the execution, in other words, they
shouldn't raise exception but instead handle errors internally and
expose the issues via data structures.
The term scraping isn't quite right in the context of this experiment
since a scraper could simply be an API client consuming a web API for
instance.

## Processing

Once the data is scraped, the fetched information can be sent to one or
many processors until it reaches its final form. If the data is meant to
be persisted, the persistence layer should be implemented as a processor.
Examples of processors are data extractors, event triggers, persistence
layers etc...
Processors are called via `#process` and are usually implemented as
modules since they don't need to create instances or keep states.

### Design

Each unit should be autonomous, easy to test and chainable. Raised
exceptions should really be exceptional and always mean that human
intervention is needed. Ideally, each unit should also be designed to
run concurrently.


## Development

To run the scenario:

```
$ ruby runner.rb
```

To test/play with the different parts, use the console:

```
bin/console
```

